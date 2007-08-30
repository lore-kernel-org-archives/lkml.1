Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXH3SXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXH3SXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbXH3SXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:23:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48635 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbXH3SXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:23:30 -0400
Date: Thu, 30 Aug 2007 11:20:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, bos@serpentine.com, rob@landley.net,
       werner@almesberger.net, hpa@zytor.com
Subject: [PATCH] docs: ramdisk/initrd/initramfs corrections
Message-Id: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

initrd/initramfs/ramdisk docs:
- fix typos/spellos/grammar
- clarify RAM disk config location
- correct cpio option

Cc: Bryan O'Sullivan <bos@serpentine.com>
Cc: Rob Landley <rob@landley.net>
Cc: Werner Almesberger <werner@almesberger.net>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/early-userspace/README                 |    6 +++---
 Documentation/filesystems/ramfs-rootfs-initramfs.txt |   14 +++++++-------
 Documentation/initrd.txt                             |   12 ++++++------
 Documentation/ramdisk.txt                            |   17 +++++++++++------
 4 files changed, 27 insertions(+), 22 deletions(-)

--- linux-2.6.23-rc4.orig/Documentation/ramdisk.txt
+++ linux-2.6.23-rc4/Documentation/ramdisk.txt
@@ -22,16 +22,21 @@ The RAM disk dynamically grows as more s
 RAM from the buffer cache. The driver marks the buffers it is using as dirty
 so that the VM subsystem does not try to reclaim them later.
 
-Also, the RAM disk supports up to 16 RAM disks out of the box, and can
-be reconfigured to support up to 255 RAM disks - change "#define NUM_RAMDISKS"
-in drivers/block/rd.c.  To use RAM disk support with your system, run
-'./MAKEDEV ram' from the /dev directory.  RAM disks are all major number 1, and
-start with minor number 0 for /dev/ram0, etc.  If used, modern kernels use
-/dev/ram0 for an initrd.
+The RAM disk supports up to 16 RAM disks by default, and can be reconfigured
+to support an unlimited number of RAM disks (at your own risk).  Just change
+the configuration symbol BLK_DEV_RAM_COUNT in the Block drivers config menu
+and (re)build the kernel.
+
+To use RAM disk support with your system, run './MAKEDEV ram' from the /dev
+directory.  RAM disks are all major number 1, and start with minor number 0
+for /dev/ram0, etc.  If used, modern kernels use /dev/ram0 for an initrd.
 
 The old "ramdisk=<ram_size>" has been changed to "ramdisk_size=<ram_size>" to
 make it clearer.  The original "ramdisk=<ram_size>" has been kept around for
 compatibility reasons, but it may be removed in the future.
+There are also config symbols (in the Block drivers config menu) for these
+variables:  BLK_DEV_RAM_SIZE defaults to 4096 and BLK_DEV_RAM_BLOCKSIZE
+defaults to 1024.
 
 The new RAM disk also has the ability to load compressed RAM disk images,
 allowing one to squeeze more programs onto an average installation or
--- linux-2.6.23-rc4.orig/Documentation/initrd.txt
+++ linux-2.6.23-rc4/Documentation/initrd.txt
@@ -80,8 +80,8 @@ Compressed cpio images
 ----------------------
 
 Recent kernels have support for populating a ramdisk from a compressed cpio
-archive, on such systems, the creation of a ramdisk image doesn't need to
-involve special block devices or loopbacks, you merely create a directory on
+archive. On such systems, the creation of a ramdisk image doesn't need to
+involve special block devices or loopbacks; you merely create a directory on
 disk with the desired initrd content, cd to that directory, and run (as an
 example):
 
@@ -293,7 +293,7 @@ information as small as possible. In thi
 generated with all the necessary modules. Then, only /sbin/init or a file
 read by it would have to be different.
 
-A third scenario are more convenient recovery disks, because information
+A third scenario is more convenient recovery disks, because information
 like the location of the root FS partition doesn't have to be provided at
 boot time, but the system loaded from initrd can invoke a user-friendly
 dialog and it can also perform some sanity checks (or even some form of
@@ -339,8 +339,8 @@ the new, supported mechanism is called "
 Mixed change_root and pivot_root mechanism
 ------------------------------------------
 
-In case you did not want to use root=/dev/ram0 to trig the pivot_root mechanism,
-you may create both /linuxrc and /sbin/init in your initrd image.
+In case you did not want to use root=/dev/ram0 to trigger the pivot_root
+mechanism, you may create both /linuxrc and /sbin/init in your initrd image.
 
 /linuxrc would contain only the following:
 
@@ -350,7 +350,7 @@ echo 0x0100 >/proc/sys/kernel/real-root-
 umount -n /proc
 
 Once linuxrc exited, the kernel would mount again your initrd as root,
-this time executing /sbin/init. Again, it would be duty of this init
+this time executing /sbin/init. Again, it would be the duty of this init
 to build the right environment (maybe using the root= device passed on
 the cmdline) before the final execution of the real /sbin/init.
 
--- linux-2.6.23-rc4.orig/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ linux-2.6.23-rc4/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -8,7 +8,7 @@ What is ramfs?
 
 Ramfs is a very simple filesystem that exports Linux's disk caching
 mechanisms (the page cache and dentry cache) as a dynamically resizable
-ram-based filesystem.
+RAM-based filesystem.
 
 Normally all files are cached in memory by Linux.  Pages of data read from
 backing store (usually the block device the filesystem is mounted on) are kept
@@ -34,7 +34,7 @@ ramfs and ramdisk:
 ------------------
 
 The older "ram disk" mechanism created a synthetic block device out of
-an area of ram and used it as backing store for a filesystem.  This block
+an area of RAM and used it as backing store for a filesystem.  This block
 device was of fixed size, so the filesystem mounted on it was of fixed
 size.  Using a ram disk also required unnecessarily copying memory from the
 fake block device into the page cache (and copying changes back out), as well
@@ -46,8 +46,8 @@ unnecessary work for the CPU, and pollut
 to avoid this copying by playing with the page tables, but they're unpleasantly
 complicated and turn out to be about as expensive as the copying anyway.)
 More to the point, all the work ramfs is doing has to happen _anyway_,
-since all file access goes through the page and dentry caches.  The ram
-disk is simply unnecessary, ramfs is internally much simpler.
+since all file access goes through the page and dentry caches.  The RAM
+disk is simply unnecessary; ramfs is internally much simpler.
 
 Another reason ramdisks are semi-obsolete is that the introduction of
 loopback devices offered a more flexible and convenient way to create
@@ -103,7 +103,7 @@ All this differs from the old initrd in 
     initramfs archive is a gzipped cpio archive (like tar only simpler,
     see cpio(1) and Documentation/early-userspace/buffer-format.txt).  The
     kernel's cpio extraction code is not only extremely small, it's also
-    __init data that can be discarded during the boot process.
+    __init text and data that can be discarded during the boot process.
 
   - The program run by the old initrd (which was called /initrd, not /init) did
     some setup and then returned to the kernel, while the init program from
@@ -220,7 +220,7 @@ device) but the separate packaging of in
 non-GPL code you'd like to run from initramfs, without conflating it with
 the GPL licensed Linux kernel binary).
 
-It can also be used to supplement the kernel's built-in initamfs image.  The
+It can also be used to supplement the kernel's built-in initramfs image.  The
 files in the external archive will overwrite any conflicting files in
 the built-in initramfs archive.  Some distributors also prefer to customize
 a single kernel image with task-specific initramfs images, without recompiling.
@@ -339,7 +339,7 @@ smooth transition and allowing early boo
 The move to early userspace is necessary because finding and mounting the real
 root device is complex.  Root partitions can span multiple devices (raid or
 separate journal).  They can be out on the network (requiring dhcp, setting a
-specific mac address, logging into a server, etc).  They can live on removable
+specific MAC address, logging into a server, etc).  They can live on removable
 media, with dynamically allocated major/minor numbers and persistent naming
 issues requiring a full udev implementation to sort out.  They can be
 compressed, encrypted, copy-on-write, loopback mounted, strangely partitioned,
--- linux-2.6.23-rc4.orig/Documentation/early-userspace/README
+++ linux-2.6.23-rc4/Documentation/early-userspace/README
@@ -19,7 +19,7 @@ It consists of several major infrastruct
 - klibc, a userspace C library, currently packaged separately, that is
   optimized for correctness and small size.
 
-The cpio file format used by initramfs is the "newc" (aka "cpio -c")
+The cpio file format used by initramfs is the "newc" (aka "cpio -H newc")
 format, and is documented in the file "buffer-format.txt".  There are
 two ways to add an early userspace image: specify an existing cpio
 archive to be used as the image or have the kernel build process build
@@ -44,7 +44,7 @@ The image is specified as one or more so
 CONFIG_INITRAMFS_SOURCE.  Sources can be either directories or files -
 cpio archives are *not* allowed when building from sources.
 
-A source directory will have it and all of it's contents packaged.  The
+A source directory will have it and all of its contents packaged.  The
 specified directory name will be mapped to '/'.  When packaging a
 directory, limited user and group ID translation can be performed.
 INITRAMFS_ROOT_UID can be set to a user ID that needs to be mapped to
@@ -144,7 +144,7 @@ c) using initramfs.  The call to prepare
    initrd format, an cpio archive.  It must be called "/init".  This binary
    is responsible to do all the things prepare_namespace() would do.
 
-   To remain backwards compatibility, the /init binary will only run if it
+   To maintain backwards compatibility, the /init binary will only run if it
    comes via an initramfs cpio archive.  If this is not the case,
    init/main.c:init() will run prepare_namespace() to mount the final root
    and exec one of the predefined init binaries.
