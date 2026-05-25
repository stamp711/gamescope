{
  description = "Dev shell for gamescope";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # Reuse the full build-input set from nixpkgs' gamescope package
        # (its native + build inputs are added to the shell environment).
        inputsFrom = [ pkgs.gamescope ];

        # Editor / LSP tooling
        packages = with pkgs; [
          git # override the gamescope-version `git` stub from inputsFrom
          clang-tools # clangd, clang-format
        ];

        # Extras nixpkgs disables but we want available for development
        buildInputs = [
          pkgs.catch2_3 # tests subdir; nixpkgs builds with enable_tests=false
        ];

        shellHook = ''
          echo "gamescope dev shell"
          echo "  meson setup build/ && ninja -C build/"
        '';
      };
    };
}
