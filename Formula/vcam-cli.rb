class VcamCli < Formula
  desc "Command line tool and MCP server for the VCam API"
  homepage "https://github.com/vcamapp/vcam-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vcamapp/vcam-cli/releases/download/v0.1.0/vcam-aarch64-apple-darwin.tar.xz"
      sha256 "5653fd2b77396cc4adf02f9933d435a36112cc643d23dddd13f8aed914e60a73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vcamapp/vcam-cli/releases/download/v0.1.0/vcam-x86_64-apple-darwin.tar.xz"
      sha256 "8da236523186c49092c6bb2465a7cb037aaea883d9f6d94f382301fca6d21864"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vcamapp/vcam-cli/releases/download/v0.1.0/vcam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8490ae221560892d09e33a64f4a3ebd1ae0a12d86812b696576cc3b489a38306"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vcamapp/vcam-cli/releases/download/v0.1.0/vcam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c5445bf2d9626827cf6344d2fb5e5c46af7144bc630c2b37470c82b2808f03b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vcam"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vcam"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vcam"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vcam"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
