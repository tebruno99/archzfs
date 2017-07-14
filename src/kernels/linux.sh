# For build.sh
mode_name="std"
mode_desc="Select and use the packages for the default linux kernel"

# Kernel versions for default ZFS packages
pkgrel="1"
kernel_version="4.11.9-1"

# Kernel version for GIT packages
pkgrel_git="${pkgrel}"
kernel_version_git="${kernel_version}"
zfs_git_commit=""
spl_git_commit=""
zfs_git_url="https://github.com/zfsonlinux/zfs.git"
spl_git_url="https://github.com/zfsonlinux/spl.git"

header="\
# Maintainer: Jesus Alvarez <jeezusjr at gmail dot com>
#
# This PKGBUILD was generated by the archzfs build scripts located at
#
# http://github.com/archzfs/archzfs
#
# ! WARNING !
#
# The archzfs packages are kernel modules, so these PKGBUILDS will only work with the kernel package they target. In this
# case, the archzfs-linux packages will only work with the default linux package! To have a single PKGBUILD target many
# kernels would make for a cluttered PKGBUILD!
#
# If you have a custom kernel, you will need to change things in the PKGBUILDS. If you would like to have AUR or archzfs repo
# packages for your favorite kernel package built using the archzfs build tools, submit a request in the Issue tracker on the
# archzfs github page.
#"

update_linux_pkgbuilds() {
    pkg_list=("spl-linux" "zfs-linux")
    kernel_version_full=$(kernel_version_full ${kernel_version})
    kernel_version_full_pkgver=$(kernel_version_full_no_hyphen ${kernel_version})
    kernel_version_major=${kernel_version%-*}
    kernel_mod_path="${kernel_version_full}-ARCH"
    archzfs_package_group="archzfs-linux"
    spl_pkgver=${zol_version}_${kernel_version_full_pkgver}
    zfs_pkgver=${zol_version}_${kernel_version_full_pkgver}
    spl_pkgrel=${pkgrel}
    zfs_pkgrel=${pkgrel}
    spl_conflicts="'spl-linux-git'"
    spl_headers_conflicts="'spl-linux-git-headers' 'spl-linux-lts-headers' 'spl-linux-lts-git-headers' 'spl-linux-hardened-headers' 'spl-linux-hardened-git-headers'"
    zfs_headers_conflicts="'zfs-linux-git-headers' 'zfs-linux-lts-headers' 'zfs-linux-lts-git-headers' 'zfs-linux-hardened-headers' 'zfs-linux-hardened-git-headers'"
    zfs_conflicts="'zfs-linux-git'"
    spl_pkgname="spl-linux"
    spl_utils_pkgname="spl-utils-common"
    zfs_pkgname="zfs-linux"
    zfs_utils_pkgname="zfs-utils-common"
    # Paths are relative to build.sh
    spl_pkgbuild_path="packages/${kernel_name}/${spl_pkgname}"
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    spl_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-${zol_version}/spl-${zol_version}.tar.gz"
    zfs_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-${zol_version}/zfs-${zol_version}.tar.gz"
    spl_workdir="\${srcdir}/spl-${zol_version}"
    zfs_workdir="\${srcdir}/zfs-${zol_version}"
    linux_depends="\"linux=${kernel_version_full}\""
    linux_headers_depends="\"linux-headers=${kernel_version_full}\""
    spl_replaces='replaces=("spl-git")'
    zfs_replaces='replaces=("zfs-git")'
    zfs_makedepends="\"${spl_pkgname}-headers\""
}

update_linux_git_pkgbuilds() {
    pkg_list=("spl-linux-git" "zfs-linux-git")
    kernel_version=${kernel_version_git}
    kernel_version_full=$(kernel_version_full ${kernel_version_git})
    kernel_version_full_pkgver=$(kernel_version_full_no_hyphen ${kernel_version_git})
    kernel_version_major=${kernel_version_git%-*}
    kernel_mod_path="${kernel_version_full}-ARCH"
    archzfs_package_group="archzfs-linux-git"
    spl_pkgver="" # Set later by call to git_calc_pkgver
    zfs_pkgver="" # Set later by call to git_calc_pkgver
    spl_pkgrel=${pkgrel_git}
    zfs_pkgrel=${pkgrel_git}
    spl_conflicts="'spl-linux'"
    spl_headers_conflicts="'spl-linux-headers' 'spl-linux-lts-headers' 'spl-linux-lts-git-headers' 'spl-linux-hardened-headers' 'spl-linux-hardened-git-headers'"
    zfs_headers_conflicts="'zfs-linux-headers' 'zfs-linux-lts-headers' 'zfs-linux-lts-git-headers' 'zfs-linux-hardened-headers' 'zfs-linux-hardened-git-headers'"
    zfs_conflicts="'zfs-linux'"
    spl_pkgname="spl-linux-git"
    spl_utils_pkgname="spl-utils-common-git"
    zfs_pkgname="zfs-linux-git"
    zfs_utils_pkgname="zfs-utils-common-git"
    spl_pkgbuild_path="packages/${kernel_name}/${spl_pkgname}"
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    spl_src_target="git+${spl_git_url}"
    if [[ ${spl_git_commit} != "" ]]; then
        spl_src_target="git+${spl_git_url}#commit=${spl_git_commit}"
    fi
    spl_src_hash="SKIP"
    linux_depends="\"linux=${kernel_version_full}\""
    linux_headers_depends="\"linux-headers=${kernel_version_full}\""
    spl_makedepends="\"git\""
    zfs_src_target="git+${zfs_git_url}"
    if [[ ${zfs_git_commit} != "" ]]; then
        zfs_src_target="git+${zfs_git_url}#commit=${zfs_git_commit}"
    fi
    zfs_src_hash="SKIP"
    zfs_makedepends="\"git\" \"${spl_pkgname}-headers\""
    spl_workdir="\${srcdir}/spl"
    zfs_workdir="\${srcdir}/zfs"
    if have_command "update"; then
        git_check_repo
        git_calc_pkgver
    fi
}
