Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYFCRPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYFCRPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYFCRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:15:04 -0400
Received: from baikonur.stro.at ([213.239.196.228]:41068 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYFCRO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:14:58 -0400
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tim Gardner <tim.gardner@canonical.com>,
       maximilian attems <max@stro.at>
Subject: [PATCH] UBUNTU: i386 -generic builds. Ignore: yes
Date: Tue,  3 Jun 2008 18:48:37 +0200
Message-Id: <1212511717-13142-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 debian/config/i386/config.generic |    2 +-
 debian/control                    | 1147 ++++++++++++++++++++++++++-----------
 debian/control.stub               |  477 +++++-----------
 debian/d-i/kernel-versions        |   18 +-
 4 files changed, 972 insertions(+), 672 deletions(-)

diff --git a/debian/config/i386/config.generic b/debian/config/i386/config.generic
index cee78f4..1378f2d 100644
--- a/debian/config/i386/config.generic
+++ b/debian/config/i386/config.generic
@@ -165,7 +165,7 @@ CONFIG_BAYCOM_SER_HDX=m
 CONFIG_BLK_CPQ_CISS_DA=m
 CONFIG_BLK_CPQ_DA=m
 CONFIG_BLK_DEV_3W_XXXX_RAID=m
-CONFIG_BLK_DEV_4DRIVES=y
+# CONFIG_BLK_DEV_4DRIVES is not set
 CONFIG_BLK_DEV_AEC62XX=m
 CONFIG_BLK_DEV_ALI14XX=m
 CONFIG_BLK_DEV_ALI15X3=m
diff --git a/debian/control b/debian/control
index 83be255..f385422 100644
--- a/debian/control
+++ b/debian/control
@@ -15,7 +15,7 @@ Description: Linux kernel hacking dependencies
  This is a dummy package that will install all possible packages
  required to hack comfortably on the kernel.
 
-Package: linux-source-2.6.24
+Package: linux-source-2.6.25
 Architecture: all
 Section: devel
 Priority: optional
@@ -23,8 +23,8 @@ Provides: linux-source, linux-source-2.6
 Depends: binutils, bzip2, coreutils | fileutils (>= 4.0)
 Recommends: libc-dev, gcc, make
 Suggests: libncurses-dev | ncurses-dev, kernel-package, libqt3-dev
-Description: Linux kernel source for version 2.6.24 with Ubuntu patches
- This package provides the source code for the Linux kernel version 2.6.24.
+Description: Linux kernel source for version 2.6.25 with Ubuntu patches
+ This package provides the source code for the Linux kernel version 2.6.25.
  .
  You may configure the kernel to your setup by typing "make config" and
  following instructions, but you could get ncursesX.X-dev and try "make
@@ -32,7 +32,7 @@ Description: Linux kernel source for version 2.6.24 with Ubuntu patches
  to use QT or GNOME based configuration interfaces, but they need
  additional packages to be installed. Also, please read the detailed
  documentation in the file
- /usr/share/doc/linux-source-2.6.24/README.headers.gz.
+ /usr/share/doc/linux-source-2.6.25/README.headers.gz.
  .
  If you wish to use this package to create a custom Linux kernel, then it
  is suggested that you investigate the package kernel-package, which has
@@ -42,7 +42,7 @@ Description: Linux kernel source for version 2.6.24 with Ubuntu patches
  you do not want this package. Install the appropriate linux-headers
  package instead.
 
-Package: linux-doc-2.6.24
+Package: linux-doc-2.6.25
 Architecture: all
 Section: doc
 Priority: optional
@@ -50,25 +50,25 @@ Provides: linux-doc-2.6
 Conflicts: linux-doc-2.6
 Replaces: linux-doc-2.6
 Depends: coreutils | fileutils (>= 4.0)
-Description: Linux kernel specific documentation for version 2.6.24
- This package provides the various readme's in the 2.6.24 kernel
+Description: Linux kernel specific documentation for version 2.6.25
+ This package provides the various readme's in the 2.6.25 kernel
  Documentation/ subdirectory: these typically contain kernel-specific
  installation notes for some drivers for example. See
- /usr/share/doc/linux-doc-2.6.24/Documentation/00-INDEX for a list of what
+ /usr/share/doc/linux-doc-2.6.25/Documentation/00-INDEX for a list of what
  is contained in each file.  Please read the Changes file, as it contains
  information about the problems, which may result by upgrading your
  kernel.
 
-Package: linux-headers-2.6.24-16
+Package: linux-headers-2.6.25-1
 Architecture: all
 Section: devel
 Priority: optional
 Depends: coreutils | fileutils (>= 4.0)
 Provides: linux-headers, linux-headers-2.6
-Description: Header files related to Linux kernel version 2.6.24
- This package provides kernel header files for version 2.6.24, for sites
+Description: Header files related to Linux kernel version 2.6.25
+ This package provides kernel header files for version 2.6.25, for sites
  that want the latest kernel headers. Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details
 
 Package: linux-libc-dev
 Architecture: amd64 i386 powerpc sparc ia64 hppa lpia
@@ -80,7 +80,7 @@ Description: Linux Kernel Headers for development
  are used by the installed headers for GNU glibc and other system
  libraries.
 
-Package: linux-image-2.6.24-16-386
+Package: linux-image-2.6.25-1-386
 Architecture: i386
 Section: base
 Priority: optional
@@ -89,9 +89,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, ivtv-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on i386
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on i386
+ This package contains the Linux kernel image for version 2.6.25 on
  i386.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -106,26 +106,26 @@ Description: Linux kernel image for version 2.6.24 on i386
  the linux-386 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-386
+Package: linux-headers-2.6.25-1-386
 Architecture: i386
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on i386
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on i386
+ This package provides kernel header files for version 2.6.25 on
  i386.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-386
+Package: linux-image-debug-2.6.25-1-386
 Architecture: i386
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on i386
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on i386
+ This package provides a kernel debug image for version 2.6.25 on
  i386.
  .
  This is for sites that wish to debug the kernel.
@@ -133,7 +133,7 @@ Description: Linux kernel debug image for version 2.6.24 on i386
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-generic
+Package: linux-image-2.6.25-1-generic
 Architecture: i386 amd64
 Section: base
 Priority: optional
@@ -142,9 +142,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-m
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86/x86_64
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86/x86_64
+ This package contains the Linux kernel image for version 2.6.25 on
  x86/x86_64.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -159,26 +159,26 @@ Description: Linux kernel image for version 2.6.24 on x86/x86_64
  the linux-generic meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-generic
+Package: linux-headers-2.6.25-1-generic
 Architecture: i386 amd64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86/x86_64
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86/x86_64
+ This package provides kernel header files for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-generic
+Package: linux-image-debug-2.6.25-1-generic
 Architecture: i386 amd64
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86/x86_64
+ This package provides a kernel debug image for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that wish to debug the kernel.
@@ -186,7 +186,7 @@ Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-hppa32
+Package: linux-image-2.6.25-1-hppa32
 Architecture: hppa
 Section: base
 Priority: optional
@@ -195,9 +195,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: palo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit HP PA-RISC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit HP PA-RISC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit HP PA-RISC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -212,20 +212,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit HP PA-RISC SMP
  the linux-hppa32 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-hppa32
+Package: linux-headers-2.6.25-1-hppa32
 Architecture: hppa
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit HP PA-RISC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit HP PA-RISC SMP
+ This package provides kernel header files for version 2.6.25 on
  32-bit HP PA-RISC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-hppa64
+Package: linux-image-2.6.25-1-hppa64
 Architecture: hppa
 Section: base
 Priority: optional
@@ -234,9 +234,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: palo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit HP PA-RISC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit HP PA-RISC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit HP PA-RISC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -251,20 +251,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit HP PA-RISC SMP
  the linux-hppa64 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-hppa64
+Package: linux-headers-2.6.25-1-hppa64
 Architecture: hppa
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1-hppa64, binutils-hppa64, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1-hppa64, binutils-hppa64, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit HP PA-RISC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit HP PA-RISC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit HP PA-RISC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-itanium
+Package: linux-image-2.6.25-1-itanium
 Architecture: ia64
 Section: base
 Priority: optional
@@ -273,9 +273,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: elilo (>= 3.6-1)
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Itanium SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on Itanium SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  Itanium SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -290,20 +290,20 @@ Description: Linux kernel image for version 2.6.24 on Itanium SMP
  the linux-itanium meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-itanium
+Package: linux-headers-2.6.25-1-itanium
 Architecture: ia64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Itanium SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on Itanium SMP
+ This package provides kernel header files for version 2.6.25 on
  Itanium SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-mckinley
+Package: linux-image-2.6.25-1-mckinley
 Architecture: ia64
 Section: base
 Priority: optional
@@ -312,9 +312,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: elilo (>= 3.6-1)
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Itanium II SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on Itanium II SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  Itanium II SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -329,20 +329,20 @@ Description: Linux kernel image for version 2.6.24 on Itanium II SMP
  the linux-mckinley meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-mckinley
+Package: linux-headers-2.6.25-1-mckinley
 Architecture: ia64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Itanium II SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on Itanium II SMP
+ This package provides kernel header files for version 2.6.25 on
  Itanium II SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc
+Package: linux-image-2.6.25-1-powerpc
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -351,9 +351,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit PowerPC
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit PowerPC.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -368,20 +368,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC
  the linux-powerpc meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc
+Package: linux-headers-2.6.25-1-powerpc
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit PowerPC
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit PowerPC
+ This package provides kernel header files for version 2.6.25 on
  32-bit PowerPC.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc64-smp
+Package: linux-image-2.6.25-1-powerpc64-smp
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -390,9 +390,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit PowerPC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit PowerPC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit PowerPC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -407,20 +407,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit PowerPC SMP
  the linux-powerpc64-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc64-smp
+Package: linux-headers-2.6.25-1-powerpc64-smp
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit PowerPC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit PowerPC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit PowerPC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc-smp
+Package: linux-image-2.6.25-1-powerpc-smp
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -429,9 +429,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit PowerPC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit PowerPC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -446,20 +446,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC SMP
  the linux-powerpc-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc-smp
+Package: linux-headers-2.6.25-1-powerpc-smp
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit PowerPC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit PowerPC SMP
+ This package provides kernel header files for version 2.6.25 on
  32-bit PowerPC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-server
+Package: linux-image-2.6.25-1-server
 Architecture: i386 amd64
 Section: base
 Priority: optional
@@ -468,9 +468,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, kvm
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86/x86_64
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86/x86_64
+ This package contains the Linux kernel image for version 2.6.25 on
  x86/x86_64.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -485,26 +485,26 @@ Description: Linux kernel image for version 2.6.24 on x86/x86_64
  the linux-server meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-server
+Package: linux-headers-2.6.25-1-server
 Architecture: i386 amd64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86/x86_64
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86/x86_64
+ This package provides kernel header files for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-server
+Package: linux-image-debug-2.6.25-1-server
 Architecture: i386 amd64
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86/x86_64
+ This package provides a kernel debug image for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that wish to debug the kernel.
@@ -512,7 +512,7 @@ Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-sparc64
+Package: linux-image-2.6.25-1-sparc64
 Architecture: sparc
 Section: base
 Priority: optional
@@ -521,9 +521,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: silo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit UltraSPARC
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit UltraSPARC.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -538,20 +538,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC
  the linux-sparc64 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-sparc64
+Package: linux-headers-2.6.25-1-sparc64
 Architecture: sparc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit UltraSPARC
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit UltraSPARC
+ This package provides kernel header files for version 2.6.25 on
  64-bit UltraSPARC.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-sparc64-smp
+Package: linux-image-2.6.25-1-sparc64-smp
 Architecture: sparc
 Section: base
 Priority: optional
@@ -560,9 +560,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: silo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit UltraSPARC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit UltraSPARC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -577,20 +577,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC SMP
  the linux-sparc64-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-sparc64-smp
+Package: linux-headers-2.6.25-1-sparc64-smp
 Architecture: sparc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit UltraSPARC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit UltraSPARC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit UltraSPARC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-virtual
+Package: linux-image-2.6.25-1-virtual
 Architecture: i386
 Section: base
 Priority: optional
@@ -599,9 +599,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-m
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86
+ This package contains the Linux kernel image for version 2.6.25 on
  x86.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -616,26 +616,26 @@ Description: Linux kernel image for version 2.6.24 on x86
  the linux-virtual meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-virtual
+Package: linux-headers-2.6.25-1-virtual
 Architecture: i386
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86
+ This package provides kernel header files for version 2.6.25 on
  x86.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-virtual
+Package: linux-image-debug-2.6.25-1-virtual
 Architecture: i386
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86
+ This package provides a kernel debug image for version 2.6.25 on
  x86.
  .
  This is for sites that wish to debug the kernel.
@@ -643,197 +643,692 @@ Description: Linux kernel debug image for version 2.6.24 on x86
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-lpia
-Architecture: lpia
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ubuntu Moblie and Embedded LPIA edition
- This package contains the Linux kernel image for version 2.6.24 on
- Ubuntu Moblie and Embedded LPIA edition.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports UME processors.
- .
- UME kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-lpia meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
+Package: kernel-image-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: kernel-image
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: extra
+Description: Linux kernel binary image for the Debian installer
+ This package contains the Linux kernel image for the Debian installer
+ boot images. It does _not_ provide a usable kernel for your full
+ Debian system.
 
-Package: linux-headers-2.6.24-16-lpia
-Architecture: lpia
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ubuntu Moblie and Embedded LPIA edition
- This package provides kernel header files for version 2.6.24 on
- Ubuntu Moblie and Embedded LPIA edition.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+Package: nic-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: nic-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Network interface support
 
-Package: linux-image-2.6.24-16-rt
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ingo Molnar's full real time preemption patch (2.6.24.3-rt3)
- This package contains the Linux kernel image for version 2.6.24 on
- Ingo Molnar's full real time preemption patch (2.6.24.3-rt3).
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- RT kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-rt meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
+Package: nic-shared-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: nic-shared-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Shared NIC drivers
+ This package contains NIC drivers needed by combinations of nic-modules,
+ nic-extra-modules, and nic-pcmcia-modules.
 
-Package: linux-headers-2.6.24-16-rt
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ingo Molnar's full real time preemption patch (2.6.24.3-rt3)
- This package provides kernel header files for version 2.6.24 on
- Ingo Molnar's full real time preemption patch (2.6.24.3-rt3).
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+Package: serial-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: serial-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Serial port support
 
-Package: linux-image-2.6.24-16-lpiacompat
-Architecture: lpia
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ubuntu Moblie and Embedded-x86 compat edition
- This package contains the Linux kernel image for version 2.6.24 on
- Ubuntu Moblie and Embedded-x86 compat edition.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports UME processors.
- .
- UME kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-lpiacompat meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
+Package: ppp-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: ppp-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di, serial-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PPP (serial port) networking support
 
-Package: linux-headers-2.6.24-16-lpiacompat
-Architecture: lpia
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ubuntu Moblie and Embedded-x86 compat edition
- This package provides kernel header files for version 2.6.24 on
- Ubuntu Moblie and Embedded-x86 compat edition.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+Package: socket-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: socket-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Unix socket support
 
-Package: linux-image-2.6.24-16-xen
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on This kernel can be used for Xen dom0 and domU
- This package contains the Linux kernel image for version 2.6.24 on
- This kernel can be used for Xen dom0 and domU.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- Xen domO/domU
- .
- You likely do not want to install this package directly. Instead, install
- the linux-xen meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
+Package: ide-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: ide-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: IDE support
 
-Package: linux-headers-2.6.24-16-xen
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on This kernel can be used for Xen dom0 and domU
- This package provides kernel header files for version 2.6.24 on
- This kernel can be used for Xen dom0 and domU.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+Package: firewire-core-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: firewire-core-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Firewire (IEEE-1394) Support
 
-Package: linux-image-2.6.24-16-openvz
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on OpenVZ Virtualization enabled kernel
- This package contains the Linux kernel image for version 2.6.24 on
- OpenVZ Virtualization enabled kernel.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- OpenVZ kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-openvz meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
+Package: scsi-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: scsi-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: SCSI storage support
 
-Package: linux-headers-2.6.24-16-openvz
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on OpenVZ Virtualization enabled kernel
- This package provides kernel header files for version 2.6.24 on
- OpenVZ Virtualization enabled kernel.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+Package: plip-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: plip-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di, parport-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PLIP (parallel port) networking support
+
+Package: floppy-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: floppy-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Floppy driver support
+
+Package: ipv6-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: ipv6-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Support for IPv6 networking
+
+Package: fat-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: fat-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: FAT filesystem support
+ This includes Windows FAT and VFAT support.
+
+Package: nfs-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: nfs-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: NFS filesystem drivers
+ Includes the NFS client driver, and supporting modules.
+
+Package: md-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: md-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Multi-device support (raid, device-mapper, lvm)
+
+Package: usb-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: usb-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Core USB support
+
+Package: pcmcia-storage-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: pcmcia-storage-modules
+Depends: kernel-image-2.6.25-1-386-di, scsi-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PCMCIA storage support
+
+Package: fb-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: fb-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Framebuffer modules
+
+Package: input-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: input-modules
+Depends: kernel-image-2.6.25-1-386-di, usb-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Support for various input methods
+
+Package: irda-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: irda-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Support for Infrared protocols
+
+Package: parport-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: parport-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Parallel port support
+
+Package: nic-pcmcia-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: nic-pcmcia-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di, nic-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PCMCIA network interface support
+
+Package: pcmcia-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: pcmcia-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PCMCIA Modules
+
+Package: nic-usb-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: nic-usb-modules
+Depends: kernel-image-2.6.25-1-386-di, nic-shared-modules-2.6.25-1-386-di, usb-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: USB network interface support
+
+Package: sata-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: sata-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: SATA storage support
+
+Package: acpi-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: acpi-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Support for ACPI
+
+Package: crypto-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: crypto-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: extra
+Description: crypto modules
+ This package contains crypto modules.
+
+Package: fs-core-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: fs-core-modules, ext2-modules, ext3-modules, jfs-modules, reiserfs-modules, xfs-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Base filesystem modules
+ This includes ext2, ext3, jfs, reiserfs and xfs.
+
+Package: fs-secondary-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: fs-secondary-modules, ntfs-modules, ufs-modules, hfs-modules, affs-modules
+Depends: kernel-image-2.6.25-1-386-di, fat-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Extra filesystem modules
+ This includes support for Windows NTFS, SysV UFS, MacOS HFS and HFSPlus and
+ Amiga AFFS.
+
+Package: pata-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: pata-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: PATA support modules
+
+Package: storage-core-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: storage-core-modules, loop-modules
+Depends: kernel-image-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Core storage support
+ Includes core SCSI, LibATA, USB-Storage. Also includes related block
+ devices for CD, Disk and Tape medium (and IDE Floppy).
+
+Package: block-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: block-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di, parport-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Block storage devices
+ This package contains the block storage devices, including DAC960 and
+ paraide.
+
+Package: message-modules-2.6.25-1-386-di
+XC-Package-Type: udeb
+Provides: message-modules
+Depends: kernel-image-2.6.25-1-386-di, storage-core-modules-2.6.25-1-386-di, scsi-modules-2.6.25-1-386-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-386
+Section: debian-installer
+Priority: standard
+Description: Fusion and i2o storage modules
+ This package containes the fusion and i2o storage modules.
+
+Package: kernel-image-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: kernel-image
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: extra
+Description: Linux kernel binary image for the Debian installer
+ This package contains the Linux kernel image for the Debian installer
+ boot images. It does _not_ provide a usable kernel for your full
+ Debian system.
+
+Package: nic-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: nic-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Network interface support
+
+Package: nic-shared-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: nic-shared-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Shared NIC drivers
+ This package contains NIC drivers needed by combinations of nic-modules,
+ nic-extra-modules, and nic-pcmcia-modules.
+
+Package: serial-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: serial-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Serial port support
+
+Package: ppp-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: ppp-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di, serial-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PPP (serial port) networking support
+
+Package: socket-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: socket-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Unix socket support
+
+Package: ide-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: ide-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: IDE support
+
+Package: firewire-core-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: firewire-core-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Firewire (IEEE-1394) Support
+
+Package: scsi-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: scsi-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: SCSI storage support
+
+Package: plip-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: plip-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di, parport-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PLIP (parallel port) networking support
+
+Package: floppy-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: floppy-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Floppy driver support
+
+Package: ipv6-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: ipv6-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Support for IPv6 networking
+
+Package: fat-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: fat-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: FAT filesystem support
+ This includes Windows FAT and VFAT support.
+
+Package: nfs-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: nfs-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: NFS filesystem drivers
+ Includes the NFS client driver, and supporting modules.
+
+Package: md-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: md-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Multi-device support (raid, device-mapper, lvm)
+
+Package: usb-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: usb-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Core USB support
+
+Package: pcmcia-storage-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: pcmcia-storage-modules
+Depends: kernel-image-2.6.25-1-generic-di, scsi-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PCMCIA storage support
+
+Package: fb-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: fb-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Framebuffer modules
+
+Package: input-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: input-modules
+Depends: kernel-image-2.6.25-1-generic-di, usb-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Support for various input methods
+
+Package: irda-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: irda-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Support for Infrared protocols
+
+Package: parport-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: parport-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Parallel port support
+
+Package: nic-pcmcia-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: nic-pcmcia-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di, nic-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PCMCIA network interface support
+
+Package: pcmcia-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: pcmcia-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PCMCIA Modules
+
+Package: nic-usb-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: nic-usb-modules
+Depends: kernel-image-2.6.25-1-generic-di, nic-shared-modules-2.6.25-1-generic-di, usb-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: USB network interface support
+
+Package: sata-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: sata-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: SATA storage support
+
+Package: acpi-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: acpi-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Support for ACPI
+
+Package: crypto-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: crypto-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: extra
+Description: crypto modules
+ This package contains crypto modules.
+
+Package: fs-core-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: fs-core-modules, ext2-modules, ext3-modules, jfs-modules, reiserfs-modules, xfs-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Base filesystem modules
+ This includes ext2, ext3, jfs, reiserfs and xfs.
+
+Package: fs-secondary-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: fs-secondary-modules, ntfs-modules, ufs-modules, hfs-modules, affs-modules
+Depends: kernel-image-2.6.25-1-generic-di, fat-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Extra filesystem modules
+ This includes support for Windows NTFS, SysV UFS, MacOS HFS and HFSPlus and
+ Amiga AFFS.
+
+Package: pata-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: pata-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: PATA support modules
+
+Package: storage-core-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: storage-core-modules, loop-modules
+Depends: kernel-image-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Core storage support
+ Includes core SCSI, LibATA, USB-Storage. Also includes related block
+ devices for CD, Disk and Tape medium (and IDE Floppy).
+
+Package: block-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: block-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di, parport-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Block storage devices
+ This package contains the block storage devices, including DAC960 and
+ paraide.
+
+Package: message-modules-2.6.25-1-generic-di
+XC-Package-Type: udeb
+Provides: message-modules
+Depends: kernel-image-2.6.25-1-generic-di, storage-core-modules-2.6.25-1-generic-di, scsi-modules-2.6.25-1-generic-di
+Architecture: i386
+XB-Kernel-Version: 2.6.25-1-generic
+Section: debian-installer
+Priority: standard
+Description: Fusion and i2o storage modules
+ This package containes the fusion and i2o storage modules.
diff --git a/debian/control.stub b/debian/control.stub
index 83be255..f22267e 100644
--- a/debian/control.stub
+++ b/debian/control.stub
@@ -15,7 +15,7 @@ Description: Linux kernel hacking dependencies
  This is a dummy package that will install all possible packages
  required to hack comfortably on the kernel.
 
-Package: linux-source-2.6.24
+Package: linux-source-2.6.25
 Architecture: all
 Section: devel
 Priority: optional
@@ -23,8 +23,8 @@ Provides: linux-source, linux-source-2.6
 Depends: binutils, bzip2, coreutils | fileutils (>= 4.0)
 Recommends: libc-dev, gcc, make
 Suggests: libncurses-dev | ncurses-dev, kernel-package, libqt3-dev
-Description: Linux kernel source for version 2.6.24 with Ubuntu patches
- This package provides the source code for the Linux kernel version 2.6.24.
+Description: Linux kernel source for version 2.6.25 with Ubuntu patches
+ This package provides the source code for the Linux kernel version 2.6.25.
  .
  You may configure the kernel to your setup by typing "make config" and
  following instructions, but you could get ncursesX.X-dev and try "make
@@ -32,7 +32,7 @@ Description: Linux kernel source for version 2.6.24 with Ubuntu patches
  to use QT or GNOME based configuration interfaces, but they need
  additional packages to be installed. Also, please read the detailed
  documentation in the file
- /usr/share/doc/linux-source-2.6.24/README.headers.gz.
+ /usr/share/doc/linux-source-2.6.25/README.headers.gz.
  .
  If you wish to use this package to create a custom Linux kernel, then it
  is suggested that you investigate the package kernel-package, which has
@@ -42,7 +42,7 @@ Description: Linux kernel source for version 2.6.24 with Ubuntu patches
  you do not want this package. Install the appropriate linux-headers
  package instead.
 
-Package: linux-doc-2.6.24
+Package: linux-doc-2.6.25
 Architecture: all
 Section: doc
 Priority: optional
@@ -50,25 +50,25 @@ Provides: linux-doc-2.6
 Conflicts: linux-doc-2.6
 Replaces: linux-doc-2.6
 Depends: coreutils | fileutils (>= 4.0)
-Description: Linux kernel specific documentation for version 2.6.24
- This package provides the various readme's in the 2.6.24 kernel
+Description: Linux kernel specific documentation for version 2.6.25
+ This package provides the various readme's in the 2.6.25 kernel
  Documentation/ subdirectory: these typically contain kernel-specific
  installation notes for some drivers for example. See
- /usr/share/doc/linux-doc-2.6.24/Documentation/00-INDEX for a list of what
+ /usr/share/doc/linux-doc-2.6.25/Documentation/00-INDEX for a list of what
  is contained in each file.  Please read the Changes file, as it contains
  information about the problems, which may result by upgrading your
  kernel.
 
-Package: linux-headers-2.6.24-16
+Package: linux-headers-2.6.25-1
 Architecture: all
 Section: devel
 Priority: optional
 Depends: coreutils | fileutils (>= 4.0)
 Provides: linux-headers, linux-headers-2.6
-Description: Header files related to Linux kernel version 2.6.24
- This package provides kernel header files for version 2.6.24, for sites
+Description: Header files related to Linux kernel version 2.6.25
+ This package provides kernel header files for version 2.6.25, for sites
  that want the latest kernel headers. Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details
 
 Package: linux-libc-dev
 Architecture: amd64 i386 powerpc sparc ia64 hppa lpia
@@ -80,7 +80,7 @@ Description: Linux Kernel Headers for development
  are used by the installed headers for GNU glibc and other system
  libraries.
 
-Package: linux-image-2.6.24-16-386
+Package: linux-image-2.6.25-1-386
 Architecture: i386
 Section: base
 Priority: optional
@@ -89,9 +89,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, ivtv-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on i386
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on i386
+ This package contains the Linux kernel image for version 2.6.25 on
  i386.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -106,26 +106,26 @@ Description: Linux kernel image for version 2.6.24 on i386
  the linux-386 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-386
+Package: linux-headers-2.6.25-1-386
 Architecture: i386
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on i386
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on i386
+ This package provides kernel header files for version 2.6.25 on
  i386.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-386
+Package: linux-image-debug-2.6.25-1-386
 Architecture: i386
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on i386
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on i386
+ This package provides a kernel debug image for version 2.6.25 on
  i386.
  .
  This is for sites that wish to debug the kernel.
@@ -133,7 +133,7 @@ Description: Linux kernel debug image for version 2.6.24 on i386
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-generic
+Package: linux-image-2.6.25-1-generic
 Architecture: i386 amd64
 Section: base
 Priority: optional
@@ -142,9 +142,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-m
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86/x86_64
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86/x86_64
+ This package contains the Linux kernel image for version 2.6.25 on
  x86/x86_64.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -159,26 +159,26 @@ Description: Linux kernel image for version 2.6.24 on x86/x86_64
  the linux-generic meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-generic
+Package: linux-headers-2.6.25-1-generic
 Architecture: i386 amd64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86/x86_64
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86/x86_64
+ This package provides kernel header files for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-generic
+Package: linux-image-debug-2.6.25-1-generic
 Architecture: i386 amd64
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86/x86_64
+ This package provides a kernel debug image for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that wish to debug the kernel.
@@ -186,7 +186,7 @@ Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-hppa32
+Package: linux-image-2.6.25-1-hppa32
 Architecture: hppa
 Section: base
 Priority: optional
@@ -195,9 +195,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: palo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit HP PA-RISC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit HP PA-RISC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit HP PA-RISC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -212,20 +212,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit HP PA-RISC SMP
  the linux-hppa32 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-hppa32
+Package: linux-headers-2.6.25-1-hppa32
 Architecture: hppa
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit HP PA-RISC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit HP PA-RISC SMP
+ This package provides kernel header files for version 2.6.25 on
  32-bit HP PA-RISC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-hppa64
+Package: linux-image-2.6.25-1-hppa64
 Architecture: hppa
 Section: base
 Priority: optional
@@ -234,9 +234,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: palo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit HP PA-RISC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit HP PA-RISC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit HP PA-RISC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -251,20 +251,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit HP PA-RISC SMP
  the linux-hppa64 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-hppa64
+Package: linux-headers-2.6.25-1-hppa64
 Architecture: hppa
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1-hppa64, binutils-hppa64, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1-hppa64, binutils-hppa64, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit HP PA-RISC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit HP PA-RISC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit HP PA-RISC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-itanium
+Package: linux-image-2.6.25-1-itanium
 Architecture: ia64
 Section: base
 Priority: optional
@@ -273,9 +273,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: elilo (>= 3.6-1)
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Itanium SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on Itanium SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  Itanium SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -290,20 +290,20 @@ Description: Linux kernel image for version 2.6.24 on Itanium SMP
  the linux-itanium meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-itanium
+Package: linux-headers-2.6.25-1-itanium
 Architecture: ia64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Itanium SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on Itanium SMP
+ This package provides kernel header files for version 2.6.25 on
  Itanium SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-mckinley
+Package: linux-image-2.6.25-1-mckinley
 Architecture: ia64
 Section: base
 Priority: optional
@@ -312,9 +312,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: elilo (>= 3.6-1)
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Itanium II SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on Itanium II SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  Itanium II SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -329,20 +329,20 @@ Description: Linux kernel image for version 2.6.24 on Itanium II SMP
  the linux-mckinley meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-mckinley
+Package: linux-headers-2.6.25-1-mckinley
 Architecture: ia64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Itanium II SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on Itanium II SMP
+ This package provides kernel header files for version 2.6.25 on
  Itanium II SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc
+Package: linux-image-2.6.25-1-powerpc
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -351,9 +351,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit PowerPC
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit PowerPC.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -368,20 +368,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC
  the linux-powerpc meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc
+Package: linux-headers-2.6.25-1-powerpc
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit PowerPC
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit PowerPC
+ This package provides kernel header files for version 2.6.25 on
  32-bit PowerPC.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc64-smp
+Package: linux-image-2.6.25-1-powerpc64-smp
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -390,9 +390,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit PowerPC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit PowerPC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit PowerPC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -407,20 +407,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit PowerPC SMP
  the linux-powerpc64-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc64-smp
+Package: linux-headers-2.6.25-1-powerpc64-smp
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit PowerPC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit PowerPC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit PowerPC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-powerpc-smp
+Package: linux-image-2.6.25-1-powerpc-smp
 Architecture: powerpc
 Section: base
 Priority: optional
@@ -429,9 +429,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: yaboot
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 32-bit PowerPC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  32-bit PowerPC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -446,20 +446,20 @@ Description: Linux kernel image for version 2.6.24 on 32-bit PowerPC SMP
  the linux-powerpc-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-powerpc-smp
+Package: linux-headers-2.6.25-1-powerpc-smp
 Architecture: powerpc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16, gcc-4.1, ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1, gcc-4.1, ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 32-bit PowerPC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 32-bit PowerPC SMP
+ This package provides kernel header files for version 2.6.25 on
  32-bit PowerPC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-server
+Package: linux-image-2.6.25-1-server
 Architecture: i386 amd64
 Section: base
 Priority: optional
@@ -468,9 +468,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, kvm
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86/x86_64
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86/x86_64
+ This package contains the Linux kernel image for version 2.6.25 on
  x86/x86_64.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -485,26 +485,26 @@ Description: Linux kernel image for version 2.6.24 on x86/x86_64
  the linux-server meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-server
+Package: linux-headers-2.6.25-1-server
 Architecture: i386 amd64
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86/x86_64
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86/x86_64
+ This package provides kernel header files for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-server
+Package: linux-image-debug-2.6.25-1-server
 Architecture: i386 amd64
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86/x86_64
+ This package provides a kernel debug image for version 2.6.25 on
  x86/x86_64.
  .
  This is for sites that wish to debug the kernel.
@@ -512,7 +512,7 @@ Description: Linux kernel debug image for version 2.6.24 on x86/x86_64
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
 
-Package: linux-image-2.6.24-16-sparc64
+Package: linux-image-2.6.25-1-sparc64
 Architecture: sparc
 Section: base
 Priority: optional
@@ -521,9 +521,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: silo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit UltraSPARC
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit UltraSPARC.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -538,20 +538,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC
  the linux-sparc64 meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-sparc64
+Package: linux-headers-2.6.25-1-sparc64
 Architecture: sparc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit UltraSPARC
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit UltraSPARC
+ This package provides kernel header files for version 2.6.25 on
  64-bit UltraSPARC.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-sparc64-smp
+Package: linux-image-2.6.25-1-sparc64-smp
 Architecture: sparc
 Section: base
 Priority: optional
@@ -560,9 +560,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, redhat-cluster-modules, ivt
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: silo
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC SMP
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on 64-bit UltraSPARC SMP
+ This package contains the Linux kernel image for version 2.6.25 on
  64-bit UltraSPARC SMP.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -577,20 +577,20 @@ Description: Linux kernel image for version 2.6.24 on 64-bit UltraSPARC SMP
  the linux-sparc64-smp meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-sparc64-smp
+Package: linux-headers-2.6.25-1-sparc64-smp
 Architecture: sparc
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on 64-bit UltraSPARC SMP
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on 64-bit UltraSPARC SMP
+ This package provides kernel header files for version 2.6.25 on
  64-bit UltraSPARC SMP.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-2.6.24-16-virtual
+Package: linux-image-2.6.25-1-virtual
 Architecture: i386
 Section: base
 Priority: optional
@@ -599,9 +599,9 @@ Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-m
 Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
 Conflicts: hotplug (<< 0.0.20040105-1)
 Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on x86
- This package contains the Linux kernel image for version 2.6.24 on
+Suggests: fdutils, linux-doc-2.6.25 | linux-source-2.6.25
+Description: Linux kernel image for version 2.6.25 on x86
+ This package contains the Linux kernel image for version 2.6.25 on
  x86.
  .
  Also includes the corresponding System.map file, the modules built by the
@@ -616,224 +616,29 @@ Description: Linux kernel image for version 2.6.24 on x86
  the linux-virtual meta-package, which will ensure that upgrades work
  correctly, and that supporting packages are also installed.
 
-Package: linux-headers-2.6.24-16-virtual
+Package: linux-headers-2.6.25-1-virtual
 Architecture: i386
 Section: devel
 Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
+Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.25-1,  ${shlibs:Depends}
 Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on x86
- This package provides kernel header files for version 2.6.24 on
+Description: Linux kernel headers for version 2.6.25 on x86
+ This package provides kernel header files for version 2.6.25 on
  x86.
  .
  This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
+ /usr/share/doc/linux-headers-2.6.25-1/debian.README.gz for details.
 
-Package: linux-image-debug-2.6.24-16-virtual
+Package: linux-image-debug-2.6.25-1-virtual
 Architecture: i386
 Section: devel
 Priority: optional
 Provides: linux-debug
-Description: Linux kernel debug image for version 2.6.24 on x86
- This package provides a kernel debug image for version 2.6.24 on
+Description: Linux kernel debug image for version 2.6.25 on x86
+ This package provides a kernel debug image for version 2.6.25 on
  x86.
  .
  This is for sites that wish to debug the kernel.
  .
  The kernel image contained in this package is NOT meant to boot from. It
  is uncompressed, and unstripped.
-
-Package: linux-image-2.6.24-16-lpia
-Architecture: lpia
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ubuntu Moblie and Embedded LPIA edition
- This package contains the Linux kernel image for version 2.6.24 on
- Ubuntu Moblie and Embedded LPIA edition.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports UME processors.
- .
- UME kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-lpia meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
-
-Package: linux-headers-2.6.24-16-lpia
-Architecture: lpia
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ubuntu Moblie and Embedded LPIA edition
- This package provides kernel header files for version 2.6.24 on
- Ubuntu Moblie and Embedded LPIA edition.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
-
-Package: linux-image-2.6.24-16-rt
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ingo Molnar's full real time preemption patch (2.6.24.3-rt3)
- This package contains the Linux kernel image for version 2.6.24 on
- Ingo Molnar's full real time preemption patch (2.6.24.3-rt3).
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- RT kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-rt meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
-
-Package: linux-headers-2.6.24-16-rt
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ingo Molnar's full real time preemption patch (2.6.24.3-rt3)
- This package provides kernel header files for version 2.6.24 on
- Ingo Molnar's full real time preemption patch (2.6.24.3-rt3).
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
-
-Package: linux-image-2.6.24-16-lpiacompat
-Architecture: lpia
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on Ubuntu Moblie and Embedded-x86 compat edition
- This package contains the Linux kernel image for version 2.6.24 on
- Ubuntu Moblie and Embedded-x86 compat edition.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports UME processors.
- .
- UME kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-lpiacompat meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
-
-Package: linux-headers-2.6.24-16-lpiacompat
-Architecture: lpia
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on Ubuntu Moblie and Embedded-x86 compat edition
- This package provides kernel header files for version 2.6.24 on
- Ubuntu Moblie and Embedded-x86 compat edition.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
-
-Package: linux-image-2.6.24-16-xen
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on This kernel can be used for Xen dom0 and domU
- This package contains the Linux kernel image for version 2.6.24 on
- This kernel can be used for Xen dom0 and domU.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- Xen domO/domU
- .
- You likely do not want to install this package directly. Instead, install
- the linux-xen meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
-
-Package: linux-headers-2.6.24-16-xen
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on This kernel can be used for Xen dom0 and domU
- This package provides kernel header files for version 2.6.24 on
- This kernel can be used for Xen dom0 and domU.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
-
-Package: linux-image-2.6.24-16-openvz
-Architecture: i386 amd64
-Section: universe/base
-Priority: optional
-Pre-Depends: dpkg (>= 1.10.24)
-Provides: linux-image, linux-image-2.6, fuse-module, kvm-api-4, redhat-cluster-modules
-Depends: initramfs-tools (>= 0.36ubuntu6), coreutils | fileutils (>= 4.0), module-init-tools (>= 3.3-pre11-4ubuntu3)
-Conflicts: hotplug (<< 0.0.20040105-1)
-Recommends: lilo (>= 19.1) | grub
-Suggests: fdutils, linux-doc-2.6.24 | linux-source-2.6.24
-Description: Linux kernel image for version 2.6.24 on OpenVZ Virtualization enabled kernel
- This package contains the Linux kernel image for version 2.6.24 on
- OpenVZ Virtualization enabled kernel.
- .
- Also includes the corresponding System.map file, the modules built by the
- packager, and scripts that try to ensure that the system is not left in an
- unbootable state after an update.
- .
- Supports Generic processors.
- .
- OpenVZ kernel
- .
- You likely do not want to install this package directly. Instead, install
- the linux-openvz meta-package, which will ensure that upgrades work
- correctly, and that supporting packages are also installed.
-
-Package: linux-headers-2.6.24-16-openvz
-Architecture: i386 amd64
-Section: devel
-Priority: optional
-Depends: coreutils | fileutils (>= 4.0), linux-headers-2.6.24-16,  ${shlibs:Depends}
-Provides: linux-headers, linux-headers-2.6
-Description: Linux kernel headers for version 2.6.24 on OpenVZ Virtualization enabled kernel
- This package provides kernel header files for version 2.6.24 on
- OpenVZ Virtualization enabled kernel.
- .
- This is for sites that want the latest kernel headers.  Please read
- /usr/share/doc/linux-headers-2.6.24-16/debian.README.gz for details.
diff --git a/debian/d-i/kernel-versions b/debian/d-i/kernel-versions
index 63ac70e..3df72f2 100644
--- a/debian/d-i/kernel-versions
+++ b/debian/d-i/kernel-versions
@@ -1,15 +1,15 @@
 # arch	version		flavour		installedname			suffix	bdep
-amd64	2.6.24-16	generic			2.6.24-16-generic		-	
+amd64	2.6.25-1	generic			2.6.25-1-generic		-	
 
-hppa	2.6.24-16	hppa32			2.6.24-16-hppa32		y	
-hppa	2.6.24-16	hppa64			2.6.24-16-hppa64		y	
+hppa	2.6.25-1	hppa32			2.6.25-1-hppa32		y	
+hppa	2.6.25-1	hppa64			2.6.25-1-hppa64		y	
 
-i386	2.6.24-16	386				2.6.24-16-386			-	
-i386	2.6.24-16	generic			2.6.24-16-generic		-	
+i386	2.6.25-1	386				2.6.25-1-386			-	
+i386	2.6.25-1	generic			2.6.25-1-generic		-	
 
-ia64	2.6.24-16	itanium			2.6.24-16-itanium		-	
+ia64	2.6.25-1	itanium			2.6.25-1-itanium		-	
 
-powerpc	2.6.24-16	powerpc			2.6.24-16-powerpc		-	
-powerpc	2.6.24-16	powerpc64-smp	2.6.24-16-powerpc64-smp	-	
+powerpc	2.6.25-1	powerpc			2.6.25-1-powerpc		-	
+powerpc	2.6.25-1	powerpc64-smp	2.6.25-1-powerpc64-smp	-	
 
-sparc	2.6.24-16	sparc64			2.6.24-16-sparc64		-	
+sparc	2.6.25-1	sparc64			2.6.25-1-sparc64		-	
-- 
1.5.5.1

