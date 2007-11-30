Return-Path: <linux-kernel-owner+w=401wt.eu-S934859AbXK3Rrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbXK3Rrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760414AbXK3Rrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:47:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813AbXK3Rr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:47:28 -0500
Date: Fri, 30 Nov 2007 09:47:13 -0800
Message-Id: <200711301747.lAUHlDdM006716@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jarek Poplawski <jarkao2@o2.pl>
Subject: [PATCH] Documentation/Changes -> Documentation/Requirements
In-reply-to: <20071130071647.GA2017@ff.dom.local>
References: <20071130071647.GA2017@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change Documentation/Changes to Documentation/Requirements, and at
least begin to separate the runtime requirements from the kernel
compilation requirements.

There are definitely kernel compilation requirements that are not
listed in this file.  It would be good to get them uncovered.

This document is obviously woefully incomplete, for one thing it has
absolutely no per-architecture information, except "may depend on the
CPU in your system."  Hopefully this will encourage people to document
those per-architecture requirements.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/Changes               |  396 -----------------------------------
 Documentation/HOWTO                 |    2 +-
 Documentation/Requirements          |  394 ++++++++++++++++++++++++++++++++++
 Documentation/filesystems/locks.txt |    2 +-
 Documentation/isdn/README           |    2 +-
 Documentation/ja_JP/HOWTO           |    2 +-
 Documentation/ko_KR/HOWTO           |    2 +-
 Documentation/networking/PLIP.txt   |    2 +-
 Documentation/zh_CN/HOWTO           |    2 +-
 README                              |    4 +-
 arch/h8300/Kconfig                  |    2 +-
 arch/m68k/Kconfig                   |    2 +-
 arch/sparc/Kconfig                  |    4 +-
 arch/sparc64/Kconfig                |    2 +-
 arch/um/Kconfig                     |    2 +-
 drivers/net/Kconfig                 |    4 +-
 drivers/net/pcmcia/Kconfig          |    2 +-
 drivers/pcmcia/Kconfig              |    4 +-
 fs/Kconfig                          |    6 +-
 fs/Kconfig.binfmt                   |    2 +-
 net/Kconfig                         |    4 +-
 scripts/ver_linux                   |    2 +-
 22 files changed, 421 insertions(+), 423 deletions(-)
 delete mode 100644 Documentation/Changes
 create mode 100644 Documentation/Requirements

diff --git a/Documentation/Changes b/Documentation/Changes
deleted file mode 100644
index cb2b141..0000000
--- a/Documentation/Changes
+++ /dev/null
@@ -1,396 +0,0 @@
-Intro
-=====
-
-This document is designed to provide a list of the minimum levels of
-software necessary to run the 2.6 kernels, as well as provide brief
-instructions regarding any other "Gotchas" users may encounter when
-trying life on the Bleeding Edge.  If upgrading from a pre-2.4.x
-kernel, please consult the Changes file included with 2.4.x kernels for
-additional information; most of that information will not be repeated
-here.  Basically, this document assumes that your system is already
-functional and running at least 2.4.x kernels.
-
-This document is originally based on my "Changes" file for 2.0.x kernels
-and therefore owes credit to the same people as that file (Jared Mauch,
-Axel Boldt, Alessandro Sigala, and countless other users all over the
-'net).
-
-Current Minimal Requirements
-============================
-
-Upgrade to at *least* these software revisions before thinking you've
-encountered a bug!  If you're unsure what version you're currently
-running, the suggested command should tell you.
-
-Again, keep in mind that this list assumes you are already
-functionally running a Linux 2.4 kernel.  Also, not all tools are
-necessary on all systems; obviously, if you don't have any ISDN
-hardware, for example, you probably needn't concern yourself with
-isdn4k-utils.
-
-o  Gnu C                  3.2                     # gcc --version
-o  Gnu make               3.79.1                  # make --version
-o  binutils               2.12                    # ld -v
-o  util-linux             2.10o                   # fdformat --version
-o  module-init-tools      0.9.10                  # depmod -V
-o  e2fsprogs              1.29                    # tune2fs
-o  jfsutils               1.1.3                   # fsck.jfs -V
-o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
-o  xfsprogs               2.6.0                   # xfs_db -V
-o  pcmciautils            004                     # pccardctl -V
-o  quota-tools            3.09                    # quota -V
-o  PPP                    2.4.0                   # pppd --version
-o  isdn4k-utils           3.1pre1                 # isdnctrl 2>&1|grep version
-o  nfs-utils              1.0.5                   # showmount --version
-o  procps                 3.2.0                   # ps --version
-o  oprofile               0.9                     # oprofiled --version
-o  udev                   081                     # udevinfo -V
-o  grub                   0.93                    # grub --version
-
-Kernel compilation
-==================
-
-GCC
----
-
-The gcc version requirements may vary depending on the type of CPU in your
-computer.
-
-Make
-----
-
-You will need Gnu make 3.79.1 or later to build the kernel.
-
-Binutils
---------
-
-Linux on IA-32 has recently switched from using as86 to using gas for
-assembling the 16-bit boot code, removing the need for as86 to compile
-your kernel.  This change does, however, mean that you need a recent
-release of binutils.
-
-System utilities
-================
-
-Architectural changes
----------------------
-
-DevFS has been obsoleted in favour of udev
-(http://www.kernel.org/pub/linux/utils/kernel/hotplug/)
-
-32-bit UID support is now in place.  Have fun!
-
-Linux documentation for functions is transitioning to inline
-documentation via specially-formatted comments near their
-definitions in the source.  These comments can be combined with the
-SGML templates in the Documentation/DocBook directory to make DocBook
-files, which can then be converted by DocBook stylesheets to PostScript,
-HTML, PDF files, and several other formats.  In order to convert from
-DocBook format to a format of your choice, you'll need to install Jade as
-well as the desired DocBook stylesheets.
-
-Util-linux
-----------
-
-New versions of util-linux provide *fdisk support for larger disks,
-support new options to mount, recognize more supported partition
-types, have a fdformat which works with 2.4 kernels, and similar goodies.
-You'll probably want to upgrade.
-
-Ksymoops
---------
-
-If the unthinkable happens and your kernel oopses, you may need the
-ksymoops tool to decode it, but in most cases you don't.
-In the 2.6 kernel it is generally preferred to build the kernel with
-CONFIG_KALLSYMS so that it produces readable dumps that can be used as-is
-(this also produces better output than ksymoops).
-If for some reason your kernel is not build with CONFIG_KALLSYMS and
-you have no way to rebuild and reproduce the Oops with that option, then
-you can still decode that Oops with ksymoops.
-
-Module-Init-Tools
------------------
-
-A new module loader is now in the kernel that requires module-init-tools
-to use.  It is backward compatible with the 2.4.x series kernels.
-
-Mkinitrd
---------
-
-These changes to the /lib/modules file tree layout also require that
-mkinitrd be upgraded.
-
-E2fsprogs
----------
-
-The latest version of e2fsprogs fixes several bugs in fsck and
-debugfs.  Obviously, it's a good idea to upgrade.
-
-JFSutils
---------
-
-The jfsutils package contains the utilities for the file system.
-The following utilities are available:
-o fsck.jfs - initiate replay of the transaction log, and check
-  and repair a JFS formatted partition.
-o mkfs.jfs - create a JFS formatted partition.
-o other file system utilities are also available in this package.
-
-Reiserfsprogs
--------------
-
-The reiserfsprogs package should be used for reiserfs-3.6.x
-(Linux kernels 2.4.x). It is a combined package and contains working
-versions of mkreiserfs, resize_reiserfs, debugreiserfs and
-reiserfsck. These utils work on both i386 and alpha platforms.
-
-Xfsprogs
---------
-
-The latest version of xfsprogs contains mkfs.xfs, xfs_db, and the
-xfs_repair utilities, among others, for the XFS filesystem.  It is
-architecture independent and any version from 2.0.0 onward should
-work correctly with this version of the XFS kernel code (2.6.0 or
-later is recommended, due to some significant improvements).
-
-PCMCIAutils
------------
-
-PCMCIAutils replaces pcmcia-cs (see below). It properly sets up
-PCMCIA sockets at system startup and loads the appropriate modules
-for 16-bit PCMCIA devices if the kernel is modularized and the hotplug
-subsystem is used.
-
-Pcmcia-cs
----------
-
-PCMCIA (PC Card) support is now partially implemented in the main
-kernel source. The "pcmciautils" package (see above) replaces pcmcia-cs
-for newest kernels.
-
-Quota-tools
------------
-
-Support for 32 bit uid's and gid's is required if you want to use
-the newer version 2 quota format.  Quota-tools version 3.07 and
-newer has this support.  Use the recommended version or newer
-from the table above.
-
-Intel IA32 microcode
---------------------
-
-A driver has been added to allow updating of Intel IA32 microcode,
-accessible as a normal (misc) character device.  If you are not using
-udev you may need to:
-
-mkdir /dev/cpu
-mknod /dev/cpu/microcode c 10 184
-chmod 0644 /dev/cpu/microcode
-
-as root before you can use this.  You'll probably also want to
-get the user-space microcode_ctl utility to use with this.
-
-Powertweak
-----------
-
-If you are running v0.1.17 or earlier, you should upgrade to
-version v0.99.0 or higher. Running old versions may cause problems
-with programs using shared memory.
-
-udev
-----
-udev is a userspace application for populating /dev dynamically with
-only entries for devices actually present.  udev replaces the basic
-functionality of devfs, while allowing persistent device naming for
-devices.
-
-FUSE
-----
-
-Needs libfuse 2.4.0 or later.  Absolute minimum is 2.3.0 but mount
-options 'direct_io' and 'kernel_cache' won't work.
-
-Networking
-==========
-
-General changes
----------------
-
-If you have advanced network configuration needs, you should probably
-consider using the network tools from ip-route2.
-
-Packet Filter / NAT
--------------------
-The packet filtering and NAT code uses the same tools like the previous 2.4.x
-kernel series (iptables).  It still includes backwards-compatibility modules
-for 2.2.x-style ipchains and 2.0.x-style ipfwadm.
-
-PPP
----
-
-The PPP driver has been restructured to support multilink and to
-enable it to operate over diverse media layers.  If you use PPP,
-upgrade pppd to at least 2.4.0.
-
-If you are not using udev, you must have the device file /dev/ppp
-which can be made by:
-
-mknod /dev/ppp c 108 0
-
-as root.
-
-Isdn4k-utils
-------------
-
-Due to changes in the length of the phone number field, isdn4k-utils
-needs to be recompiled or (preferably) upgraded.
-
-NFS-utils
----------
-
-In 2.4 and earlier kernels, the nfs server needed to know about any
-client that expected to be able to access files via NFS.  This
-information would be given to the kernel by "mountd" when the client
-mounted the filesystem, or by "exportfs" at system startup.  exportfs
-would take information about active clients from /var/lib/nfs/rmtab.
-
-This approach is quite fragile as it depends on rmtab being correct
-which is not always easy, particularly when trying to implement
-fail-over.  Even when the system is working well, rmtab suffers from
-getting lots of old entries that never get removed.
-
-With 2.6 we have the option of having the kernel tell mountd when it
-gets a request from an unknown host, and mountd can give appropriate
-export information to the kernel.  This removes the dependency on
-rmtab and means that the kernel only needs to know about currently
-active clients.
-
-To enable this new functionality, you need to:
-
-  mount -t nfsd nfsd /proc/fs/nfsd
-
-before running exportfs or mountd.  It is recommended that all NFS
-services be protected from the internet-at-large by a firewall where
-that is possible.
-
-Getting updated software
-========================
-
-Kernel compilation
-******************
-
-gcc
----
-o  <ftp://ftp.gnu.org/gnu/gcc/>
-
-Make
-----
-o  <ftp://ftp.gnu.org/gnu/make/>
-
-Binutils
---------
-o  <ftp://ftp.kernel.org/pub/linux/devel/binutils/>
-
-System utilities
-****************
-
-Util-linux
-----------
-o  <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>
-
-Ksymoops
---------
-o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
-
-Module-Init-Tools
------------------
-o  <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
-
-Mkinitrd
---------
-o  <ftp://rawhide.redhat.com/pub/rawhide/SRPMS/SRPMS/>
-
-E2fsprogs
----------
-o  <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.29.tar.gz>
-
-JFSutils
---------
-o  <http://jfs.sourceforge.net/>
-
-Reiserfsprogs
--------------
-o  <http://www.namesys.com/pub/reiserfsprogs/reiserfsprogs-3.6.3.tar.gz>
-
-Xfsprogs
---------
-o  <ftp://oss.sgi.com/projects/xfs/download/>
-
-Pcmciautils
------------
-o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/pcmcia/>
-
-Pcmcia-cs
----------
-o  <http://pcmcia-cs.sourceforge.net/>
-
-Quota-tools
-----------
-o  <http://sourceforge.net/projects/linuxquota/>
-
-DocBook Stylesheets
--------------------
-o  <http://nwalsh.com/docbook/dsssl/>
-
-XMLTO XSLT Frontend
--------------------
-o  <http://cyberelk.net/tim/xmlto/>
-
-Intel P6 microcode
-------------------
-o  <http://www.urbanmyth.org/microcode/>
-
-Powertweak
-----------
-o  <http://powertweak.sourceforge.net/>
-
-udev
-----
-o <http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html>
-
-FUSE
-----
-o <http://sourceforge.net/projects/fuse>
-
-Networking
-**********
-
-PPP
----
-o  <ftp://ftp.samba.org/pub/ppp/ppp-2.4.0.tar.gz>
-
-Isdn4k-utils
-------------
-o  <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/isdn4k-utils.v3.1pre1.tar.gz>
-
-NFS-utils
----------
-o  <http://sourceforge.net/project/showfiles.php?group_id=14>
-
-Iptables
---------
-o  <http://www.iptables.org/downloads.html>
-
-Ip-route2
----------
-o  <ftp://ftp.tux.org/pub/net/ip-routing/iproute2-2.2.4-now-ss991023.tar.gz>
-
-OProfile
---------
-o  <http://oprofile.sf.net/download/>
-
-NFS-Utils
----------
-o  <http://nfs.sourceforge.net/>
-
diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 5483561..0a897c7 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -86,7 +86,7 @@ required reading:
     what is necessary to do to configure and build the kernel.  People
     who are new to the kernel should start here.
 
-  Documentation/Changes
+  Documentation/Requirements
     This file gives a list of the minimum levels of various software
     packages that are necessary to build and run the kernel
     successfully.
diff --git a/Documentation/Requirements b/Documentation/Requirements
new file mode 100644
index 0000000..bd7bc2c
--- /dev/null
+++ b/Documentation/Requirements
@@ -0,0 +1,394 @@
+Intro
+=====
+
+This document is designed to provide a list of the minimum levels of
+software necessary to run the 2.6 kernels, as well as provide brief
+instructions regarding any other "Gotchas" users may encounter when
+trying life on the Bleeding Edge.  If upgrading from a pre-2.4.x
+kernel, please consult the Changes file included with 2.4.x kernels for
+additional information; most of that information will not be repeated
+here.  Basically, this document assumes that your system is already
+functional and running at least 2.4.x kernels.
+
+This document is originally based on my "Changes" file for 2.0.x kernels
+and therefore owes credit to the same people as that file (Jared Mauch,
+Axel Boldt, Alessandro Sigala, and countless other users all over the
+'net).
+
+
+Minimal Runtime Requirements
+============================
+
+Upgrade to at *least* these software revisions before thinking you've
+encountered a bug!  If you're unsure what version you're currently
+running, the suggested command should tell you.
+
+Again, keep in mind that this list assumes you are already
+functionally running a Linux 2.4 kernel.  Also, not all tools are
+necessary on all systems; obviously, if you don't have any ISDN
+hardware, for example, you probably needn't concern yourself with
+isdn4k-utils.
+
+o  util-linux             2.10o                   # fdformat --version
+o  module-init-tools      0.9.10                  # depmod -V
+o  e2fsprogs              1.29                    # tune2fs
+o  jfsutils               1.1.3                   # fsck.jfs -V
+o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
+o  xfsprogs               2.6.0                   # xfs_db -V
+o  pcmciautils            004                     # pccardctl -V
+o  quota-tools            3.09                    # quota -V
+o  PPP                    2.4.0                   # pppd --version
+o  isdn4k-utils           3.1pre1                 # isdnctrl 2>&1|grep version
+o  nfs-utils              1.0.5                   # showmount --version
+o  procps                 3.2.0                   # ps --version
+o  oprofile               0.9                     # oprofiled --version
+o  udev                   081                     # udevinfo -V
+o  grub                   0.93                    # grub --version
+
+
+Kernel Compilation Requirements
+===============================
+
+On all systems, minimal requirements (see below for additional notes):
+
+o  Gnu C                  3.2                     # gcc --version
+o  Gnu make               3.79.1                  # make --version
+o  binutils               2.12                    # ld -v
+o  Gnu bc                 1.06                    # bc -v
+o  Perl                   5.6.0(?)                # perl -v
+
+Not all tools may be required for all kernel configurations.
+
+
+GCC/Binutils
+------------
+
+The gcc or binutils version requirements may vary depending on the
+type of CPU in your computer.  (Need to add a list here...)
+
+
+System utilities
+================
+
+Architectural changes
+---------------------
+
+DevFS has been obsoleted in favour of udev
+(http://www.kernel.org/pub/linux/utils/kernel/hotplug/)
+
+32-bit UID support is now in place.  Have fun!
+
+Linux documentation for functions is transitioning to inline
+documentation via specially-formatted comments near their
+definitions in the source.  These comments can be combined with the
+SGML templates in the Documentation/DocBook directory to make DocBook
+files, which can then be converted by DocBook stylesheets to PostScript,
+HTML, PDF files, and several other formats.  In order to convert from
+DocBook format to a format of your choice, you'll need to install Jade as
+well as the desired DocBook stylesheets.
+
+Util-linux
+----------
+
+New versions of util-linux provide *fdisk support for larger disks,
+support new options to mount, recognize more supported partition
+types, have a fdformat which works with 2.4 kernels, and similar goodies.
+You'll probably want to upgrade.
+
+Ksymoops
+--------
+
+If the unthinkable happens and your kernel oopses, you may need the
+ksymoops tool to decode it, but in most cases you don't.
+In the 2.6 kernel it is generally preferred to build the kernel with
+CONFIG_KALLSYMS so that it produces readable dumps that can be used as-is
+(this also produces better output than ksymoops).
+If for some reason your kernel is not build with CONFIG_KALLSYMS and
+you have no way to rebuild and reproduce the Oops with that option, then
+you can still decode that Oops with ksymoops.
+
+Module-Init-Tools
+-----------------
+
+A new module loader is now in the kernel that requires module-init-tools
+to use.  It is backward compatible with the 2.4.x series kernels.
+
+Mkinitrd
+--------
+
+These changes to the /lib/modules file tree layout also require that
+mkinitrd be upgraded.
+
+E2fsprogs
+---------
+
+The latest version of e2fsprogs fixes several bugs in fsck and
+debugfs.  Obviously, it's a good idea to upgrade.
+
+JFSutils
+--------
+
+The jfsutils package contains the utilities for the file system.
+The following utilities are available:
+o fsck.jfs - initiate replay of the transaction log, and check
+  and repair a JFS formatted partition.
+o mkfs.jfs - create a JFS formatted partition.
+o other file system utilities are also available in this package.
+
+Reiserfsprogs
+-------------
+
+The reiserfsprogs package should be used for reiserfs-3.6.x
+(Linux kernels 2.4.x). It is a combined package and contains working
+versions of mkreiserfs, resize_reiserfs, debugreiserfs and
+reiserfsck. These utils work on both i386 and alpha platforms.
+
+Xfsprogs
+--------
+
+The latest version of xfsprogs contains mkfs.xfs, xfs_db, and the
+xfs_repair utilities, among others, for the XFS filesystem.  It is
+architecture independent and any version from 2.0.0 onward should
+work correctly with this version of the XFS kernel code (2.6.0 or
+later is recommended, due to some significant improvements).
+
+PCMCIAutils
+-----------
+
+PCMCIAutils replaces pcmcia-cs (see below). It properly sets up
+PCMCIA sockets at system startup and loads the appropriate modules
+for 16-bit PCMCIA devices if the kernel is modularized and the hotplug
+subsystem is used.
+
+Pcmcia-cs
+---------
+
+PCMCIA (PC Card) support is now partially implemented in the main
+kernel source. The "pcmciautils" package (see above) replaces pcmcia-cs
+for newest kernels.
+
+Quota-tools
+-----------
+
+Support for 32 bit uid's and gid's is required if you want to use
+the newer version 2 quota format.  Quota-tools version 3.07 and
+newer has this support.  Use the recommended version or newer
+from the table above.
+
+Intel IA32 microcode
+--------------------
+
+A driver has been added to allow updating of Intel IA32 microcode,
+accessible as a normal (misc) character device.  If you are not using
+udev you may need to:
+
+mkdir /dev/cpu
+mknod /dev/cpu/microcode c 10 184
+chmod 0644 /dev/cpu/microcode
+
+as root before you can use this.  You'll probably also want to
+get the user-space microcode_ctl utility to use with this.
+
+Powertweak
+----------
+
+If you are running v0.1.17 or earlier, you should upgrade to
+version v0.99.0 or higher. Running old versions may cause problems
+with programs using shared memory.
+
+udev
+----
+udev is a userspace application for populating /dev dynamically with
+only entries for devices actually present.  udev replaces the basic
+functionality of devfs, while allowing persistent device naming for
+devices.
+
+FUSE
+----
+
+Needs libfuse 2.4.0 or later.  Absolute minimum is 2.3.0 but mount
+options 'direct_io' and 'kernel_cache' won't work.
+
+Networking
+==========
+
+General changes
+---------------
+
+If you have advanced network configuration needs, you should probably
+consider using the network tools from ip-route2.
+
+Packet Filter / NAT
+-------------------
+The packet filtering and NAT code uses the same tools like the previous 2.4.x
+kernel series (iptables).  It still includes backwards-compatibility modules
+for 2.2.x-style ipchains and 2.0.x-style ipfwadm.
+
+PPP
+---
+
+The PPP driver has been restructured to support multilink and to
+enable it to operate over diverse media layers.  If you use PPP,
+upgrade pppd to at least 2.4.0.
+
+If you are not using udev, you must have the device file /dev/ppp
+which can be made by:
+
+mknod /dev/ppp c 108 0
+
+as root.
+
+Isdn4k-utils
+------------
+
+Due to changes in the length of the phone number field, isdn4k-utils
+needs to be recompiled or (preferably) upgraded.
+
+NFS-utils
+---------
+
+In 2.4 and earlier kernels, the nfs server needed to know about any
+client that expected to be able to access files via NFS.  This
+information would be given to the kernel by "mountd" when the client
+mounted the filesystem, or by "exportfs" at system startup.  exportfs
+would take information about active clients from /var/lib/nfs/rmtab.
+
+This approach is quite fragile as it depends on rmtab being correct
+which is not always easy, particularly when trying to implement
+fail-over.  Even when the system is working well, rmtab suffers from
+getting lots of old entries that never get removed.
+
+With 2.6 we have the option of having the kernel tell mountd when it
+gets a request from an unknown host, and mountd can give appropriate
+export information to the kernel.  This removes the dependency on
+rmtab and means that the kernel only needs to know about currently
+active clients.
+
+To enable this new functionality, you need to:
+
+  mount -t nfsd nfsd /proc/fs/nfsd
+
+before running exportfs or mountd.  It is recommended that all NFS
+services be protected from the internet-at-large by a firewall where
+that is possible.
+
+Getting updated software
+========================
+
+Kernel compilation
+******************
+
+gcc
+---
+o  <ftp://ftp.gnu.org/gnu/gcc/>
+
+Make
+----
+o  <ftp://ftp.gnu.org/gnu/make/>
+
+Binutils
+--------
+o  <ftp://ftp.kernel.org/pub/linux/devel/binutils/>
+
+System utilities
+****************
+
+Util-linux
+----------
+o  <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>
+
+Ksymoops
+--------
+o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
+
+Module-Init-Tools
+-----------------
+o  <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
+
+Mkinitrd
+--------
+o  <ftp://rawhide.redhat.com/pub/rawhide/SRPMS/SRPMS/>
+
+E2fsprogs
+---------
+o  <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.29.tar.gz>
+
+JFSutils
+--------
+o  <http://jfs.sourceforge.net/>
+
+Reiserfsprogs
+-------------
+o  <http://www.namesys.com/pub/reiserfsprogs/reiserfsprogs-3.6.3.tar.gz>
+
+Xfsprogs
+--------
+o  <ftp://oss.sgi.com/projects/xfs/download/>
+
+Pcmciautils
+-----------
+o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/pcmcia/>
+
+Pcmcia-cs
+---------
+o  <http://pcmcia-cs.sourceforge.net/>
+
+Quota-tools
+----------
+o  <http://sourceforge.net/projects/linuxquota/>
+
+DocBook Stylesheets
+-------------------
+o  <http://nwalsh.com/docbook/dsssl/>
+
+XMLTO XSLT Frontend
+-------------------
+o  <http://cyberelk.net/tim/xmlto/>
+
+Intel P6 microcode
+------------------
+o  <http://www.urbanmyth.org/microcode/>
+
+Powertweak
+----------
+o  <http://powertweak.sourceforge.net/>
+
+udev
+----
+o <http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html>
+
+FUSE
+----
+o <http://sourceforge.net/projects/fuse>
+
+Networking
+**********
+
+PPP
+---
+o  <ftp://ftp.samba.org/pub/ppp/ppp-2.4.0.tar.gz>
+
+Isdn4k-utils
+------------
+o  <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/isdn4k-utils.v3.1pre1.tar.gz>
+
+NFS-utils
+---------
+o  <http://sourceforge.net/project/showfiles.php?group_id=14>
+
+Iptables
+--------
+o  <http://www.iptables.org/downloads.html>
+
+Ip-route2
+---------
+o  <ftp://ftp.tux.org/pub/net/ip-routing/iproute2-2.2.4-now-ss991023.tar.gz>
+
+OProfile
+--------
+o  <http://oprofile.sf.net/download/>
+
+NFS-Utils
+---------
+o  <http://nfs.sourceforge.net/>
+
diff --git a/Documentation/filesystems/locks.txt b/Documentation/filesystems/locks.txt
index fab857a..17b8d19 100644
--- a/Documentation/filesystems/locks.txt
+++ b/Documentation/filesystems/locks.txt
@@ -19,7 +19,7 @@ forever.
 
 This should not cause problems for anybody, since everybody using a
 2.1.x kernel should have updated their C library to a suitable version
-anyway (see the file "Documentation/Changes".)
+anyway (see the file "Documentation/Requirements".)
 
 1.2 Allow Mixed Locks Again
 ---------------------------
diff --git a/Documentation/isdn/README b/Documentation/isdn/README
index 6783437..c6e42fc 100644
--- a/Documentation/isdn/README
+++ b/Documentation/isdn/README
@@ -321,7 +321,7 @@ README for the ISDN-subsystem
   ATTENTION!
 
   Always use the latest module utilities. The current version is
-  named in Documentation/Changes. Some old versions of insmod
+  named in Documentation/Requirements. Some old versions of insmod
   are not capable of setting the driver-Ids correctly.
 
 3. Lowlevel-driver configuration.
diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index d9d832c..1d8e1fb 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -122,7 +122,7 @@ Linux カーネルソースツリーは幅広い範囲のドキュメントを�
     ています。カーネルに関して初めての人はここからスタートすると良いで
     しょう。
 
-  Documentation/Changes
+  Documentation/Requirements
      このファイルはカーネルをうまく生成(訳注 build )し、走らせるのに最
      小限のレベルで必要な数々のソフトウェアパッケージの一覧を示してい
      ます。
diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index b51d7ca..dd9403c 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -98,7 +98,7 @@ mtk-manpages@gmx.net의 메인트너에게 보낼 것을 권장한다.
     빌드하기 위해 필요한 것을 설명한다. 커널에 입문하는 사람들은 여기서
     시작해야 한다.
 
-  Documentation/Changes
+  Documentation/Requirements
     이 파일은 커널을 성공적으로 빌드하고 실행시키기 위해 필요한 다양한
     소프트웨어 패키지들의 최소 버젼을 나열한다.
 
diff --git a/Documentation/networking/PLIP.txt b/Documentation/networking/PLIP.txt
index ad7e3f7..0070e87 100644
--- a/Documentation/networking/PLIP.txt
+++ b/Documentation/networking/PLIP.txt
@@ -102,7 +102,7 @@ reason, bits are dropped.
 
 A utility that can perform this change in Linux is plipconfig, which is part
 of the net-tools package (its location can be found in the
-Documentation/Changes file). An example command would be
+Documentation/Requirements file). An example command would be
 'plipconfig plipX trigger 10000', where plipX is the appropriate
 PLIP device.
 
diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 48fc67b..5e323a6 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -93,7 +93,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
     文件简要介绍了Linux内核的背景，并且描述了如何配置和编译内核。内核的
     新用户应该从这里开始。
 
-  Documentation/Changes
+  Documentation/Requirements
     文件给出了用来编译和使用内核所需要的最小软件包列表。
 
   Documentation/CodingStyle
diff --git a/README b/README
index 159912c..3364c25 100644
--- a/README
+++ b/README
@@ -128,7 +128,7 @@ SOFTWARE REQUIREMENTS
 
    Compiling and running the 2.6.xx kernels requires up-to-date
    versions of various software packages.  Consult
-   Documentation/Changes for the minimum version numbers required
+   Documentation/Requirements for the minimum version numbers required
    and how to get updates for these packages.  Beware that using
    excessively old versions of these packages can cause indirect
    errors that are very difficult to track down, so don't assume that
@@ -217,7 +217,7 @@ CONFIGURING the kernel:
 COMPILING the kernel:
 
  - Make sure you have at least gcc 3.2 available.
-   For more information, refer to Documentation/Changes.
+   For more information, refer to Documentation/Requirements.
 
    Please note that you can still run a.out user programs with this kernel.
 
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ff6a871..6fe7ec4 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -192,7 +192,7 @@ config UNIX98_PTYS
 
 	  If you want to say Y here, you need to have the C library glibc 2.1
 	  or later (equal to libc-6.1, check with "ls -l /lib/libc.so.*").
-	  Read the instructions in <file:Documentation/Changes> pertaining to
+	  Read the instructions in <file:Documentation/Requirements> pertaining to
 	  pseudo terminals. It's safe to say N.
 
 config UNIX98_PTY_COUNT
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 01dee84..d9d41d1 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -92,7 +92,7 @@ config PCMCIA
 	  cards, you need to say Y here and also to "CardBus support" below.
 
 	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
+	  Hinds' pcmcia-cs package (see the file <file:Documentation/Requirements>
 	  for location).  Please also read the PCMCIA-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 527adc8..8227b0c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -107,7 +107,7 @@ config PCMCIA
 	  cards, you need to say Y here and also to "CardBus support" below.
 
 	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
+	  Hinds' pcmcia-cs package (see the file <file:Documentation/Requirements>
 	  for location).  Please also read the PCMCIA-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
@@ -299,7 +299,7 @@ config UNIX98_PTYS
 
 	  If you want to say Y here, you need to have the C library glibc 2.1
 	  or later (equal to libc-6.1, check with "ls -l /lib/libc.so.*").
-	  Read the instructions in <file:Documentation/Changes> pertaining to
+	  Read the instructions in <file:Documentation/Requirements> pertaining to
 	  pseudo terminals. It's safe to say N.
 
 config UNIX98_PTY_COUNT
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 10b212a..bb34884 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -305,7 +305,7 @@ config PCMCIA
 	  cards, you need to say Y here and also to "CardBus support" below.
 
 	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
+	  Hinds' pcmcia-cs package (see the file <file:Documentation/Requirements>
 	  for location).  Please also read the PCMCIA-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dd1689b..fa19d77 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -105,7 +105,7 @@ config NET
 	  should consider updating your networking tools too because changes
 	  in the kernel and the tools often go hand in hand. The tools are
 	  contained in the package net-tools, the location and version number
-	  of which are given in <file:Documentation/Changes>.
+	  of which are given in <file:Documentation/Requirements>.
 
 	  For a general introduction to Linux networking, it is highly
 	  recommended to read the NET-HOWTO, available from
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index e8d69b0..31e1182 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1737,7 +1737,7 @@ config NET_POCKET
 	  (or PC-card) slot of your laptop instead (PCMCIA is the standard for
 	  credit card size extension cards used by all modern laptops), you
 	  need the pcmcia-cs package (location contained in the file
-	  <file:Documentation/Changes>) and you can say N here.
+	  <file:Documentation/Requirements>) and you can say N here.
 
 	  Laptop users should read the Linux Laptop home page at
 	  <http://www.linux-on-laptops.com/> or
@@ -2787,7 +2787,7 @@ config PPP
 	  To use PPP, you need an additional program called pppd as described
 	  in the PPP-HOWTO, available at
 	  <http://www.tldp.org/docs.html#howto>.  Make sure that you have
-	  the version of pppd recommended in <file:Documentation/Changes>.
+	  the version of pppd recommended in <file:Documentation/Requirements>.
 	  The PPP option enlarges your kernel by about 16 KB.
 
 	  There are actually two versions of PPP: the traditional PPP for
diff --git a/drivers/net/pcmcia/Kconfig b/drivers/net/pcmcia/Kconfig
index e8f55d8..87e4c06 100644
--- a/drivers/net/pcmcia/Kconfig
+++ b/drivers/net/pcmcia/Kconfig
@@ -13,7 +13,7 @@ menuconfig NET_PCMCIA
 	  PCMCIA.
 
 	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
+	  Hinds' pcmcia-cs package (see the file <file:Documentation/Requirements>
 	  for location).  You also want to check out the PCMCIA-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.
 
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 519b4ff..cd15dd6 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -45,7 +45,7 @@ config PCMCIA
 	   only using 32-bit CardBus cards, say Y or M here.
 
 	   To use 16-bit PCMCIA cards, you will need supporting software in
-	   most cases. (see the file <file:Documentation/Changes> for
+	   most cases. (see the file <file:Documentation/Requirements> for
 	   location and details).
 
 	   To compile this driver as modules, choose M here: the
@@ -77,7 +77,7 @@ config PCMCIA_IOCTL
 	  (pcmcia-cs) to function properly.
 
 	  You should use the new pcmciautils package instead (see
-	  <file:Documentation/Changes> for location and details).
+	  <file:Documentation/Requirements> for location and details).
 
 	  If unsure, say Y.
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 635f3e2..05f4153 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -602,7 +602,7 @@ config AUTOFS_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from the autofs
-	  package; you can find the location in <file:Documentation/Changes>.
+	  package; you can find the location in <file:Documentation/Requirements>.
 	  You also want to answer Y to "NFS file system support", below.
 
 	  If you want to use the newer version of the automounter with more
@@ -647,7 +647,7 @@ config FUSE_FS
 	  <http://fuse.sourceforge.net/>
 
 	  See <file:Documentation/filesystems/fuse.txt> for more information.
-	  See <file:Documentation/Changes> for needed library/utility version.
+	  See <file:Documentation/Requirements> for needed library/utility version.
 
 	  If you want to develop a userspace FS, or if you want to use
 	  a filesystem based on FUSE, answer Y or M.
@@ -1689,7 +1689,7 @@ config NFSD
 	  faster.
 
 	  In either case, you will need support software; the respective
-	  locations are given in the file <file:Documentation/Changes> in the
+	  locations are given in the file <file:Documentation/Requirements> in the
 	  NFS section.
 
 	  If you say Y here, you will get support for version 2 of the NFS
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index d4fc609..91cd5b2 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -20,7 +20,7 @@ config BINFMT_ELF
 	  If you find that after upgrading from Linux kernel 1.2 and saying Y
 	  here, you still can't run any ELF binaries (they just crash), then
 	  you'll have to install the newest ELF runtime libraries, including
-	  ld.so (check the file <file:Documentation/Changes> for location and
+	  ld.so (check the file <file:Documentation/Requirements> for location and
 	  latest version).
 
 config BINFMT_ELF_FDPIC
diff --git a/net/Kconfig b/net/Kconfig
index ab4e6da..cb7648d 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -16,7 +16,7 @@ config NET
 	  should consider updating your networking tools too because changes
 	  in the kernel and the tools often go hand in hand. The tools are
 	  contained in the package net-tools, the location and version number
-	  of which are given in <file:Documentation/Changes>.
+	  of which are given in <file:Documentation/Requirements>.
 
 	  For a general introduction to Linux networking, it is highly
 	  recommended to read the NET-HOWTO, available from
@@ -126,7 +126,7 @@ menuconfig NETFILTER
 	  Various modules exist for netfilter which replace the previous
 	  masquerading (ipmasqadm), packet filtering (ipchains), transparent
 	  proxying, and portforwarding mechanisms. Please see
-	  <file:Documentation/Changes> under "iptables" for the location of
+	  <file:Documentation/Requirements> under "iptables" for the location of
 	  these packages.
 
 	  Make sure to say N to "Fast switching" below if you intend to say Y
diff --git a/scripts/ver_linux b/scripts/ver_linux
index ab69ece..f16e61c 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -6,7 +6,7 @@
 #
 PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:$PATH
 echo 'If some fields are empty or look unusual you may have an old version.'
-echo 'Compare to the current minimal requirements in Documentation/Changes.'
+echo 'Compare to the current minimal requirements in Documentation/Requirements.'
 echo ' '
 
 uname -a
-- 
1.5.3.4

