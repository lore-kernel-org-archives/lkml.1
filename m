Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXJBNwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXJBNwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXJBNv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:51:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52574 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXJBNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:51:56 -0400
Date: Tue, 2 Oct 2007 15:51:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch] menuconfig - lift the fs menu
Message-ID: <Pine.LNX.4.64.0710021549421.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Lift the FS menu a bit by moving filesystem-specific
parts into their own menu.

This also moves minix and romfs into the "misc fs" menu,
as per Randy Dunlap's suggestion [http://lkml.org/lkml/2007/9/25/344]

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/Kconfig      |   81 +++++++++++++++++++++++++++++++-------------------------
 fs/gfs2/Kconfig |    9 ++++--
 fs/xfs/Kconfig  |   10 +++---
 3 files changed, 56 insertions(+), 44 deletions(-)

Index: linux-2.6.23/fs/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/Kconfig
+++ linux-2.6.23/fs/Kconfig
@@ -6,6 +6,17 @@ menu "File systems"
 
 if BLOCK
 
+menuconfig EXT_FS
+	bool "Extended filesystem family"
+	default y
+	---help---
+	  Say Y here to get to see options for the 'ext' filesystems.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if EXT_FS
+
 config EXT2_FS
 	tristate "Second extended fs support"
 	help
@@ -272,7 +283,9 @@ config FS_MBCACHE
 	default y if EXT2_FS=y || EXT3_FS=y || EXT4DEV_FS=y
 	default m if EXT2_FS=m || EXT3_FS=m || EXT4DEV_FS=m
 
-config REISERFS_FS
+endif # EXT_FS
+
+menuconfig REISERFS_FS
 	tristate "Reiserfs support"
 	help
 	  Stores not just filenames but the files themselves in a balanced
@@ -358,7 +371,7 @@ config REISERFS_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
-config JFS_FS
+menuconfig JFS_FS
 	tristate "JFS filesystem support"
 	select NLS
 	help
@@ -420,7 +433,7 @@ config FS_POSIX_ACL
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 
-config OCFS2_FS
+menuconfig OCFS2_FS
 	tristate "OCFS2 file system support"
 	depends on NET && SYSFS
 	select CONFIGFS_FS
@@ -458,39 +471,6 @@ config OCFS2_DEBUG_MASKLOG
 	  This option will enlarge your kernel, but it allows debugging of
 	  ocfs2 filesystem issues.
 
-config MINIX_FS
-	tristate "Minix fs support"
-	help
-	  Minix is a simple operating system used in many classes about OS's.
-	  The minix file system (method to organize files on a hard disk
-	  partition or a floppy disk) was the original file system for Linux,
-	  but has been superseded by the second extended file system ext2fs.
-	  You don't want to use the minix file system on your hard disk
-	  because of certain built-in restrictions, but it is sometimes found
-	  on older Linux floppy disks.  This option will enlarge your kernel
-	  by about 28 KB. If unsure, say N.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called minix.  Note that the file system of your root
-	  partition (the one containing the directory /) cannot be compiled as
-	  a module.
-
-config ROMFS_FS
-	tristate "ROM file system support"
-	---help---
-	  This is a very small read-only file system mainly intended for
-	  initial ram disks of installation disks, but it could be used for
-	  other read-only media as well.  Read
-	  <file:Documentation/filesystems/romfs.txt> for details.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called romfs.  Note that the file system of your
-	  root partition (the one containing the directory /) cannot be a
-	  module.
-
-	  If you don't know whether you need it, then you don't need it:
-	  answer N.
-
 endif
 
 config INOTIFY
@@ -1397,7 +1377,22 @@ config HPFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called hpfs.  If unsure, say N.
 
+config MINIX_FS
+	tristate "Minix fs support"
+	---help---
+	  Minix is a simple operating system used in many classes about OSs.
+	  The minix file system (method to organize files on a hard disk
+	  partition or a floppy disk) was the original file system for Linux,
+	  but has been superseded by the second extended file system ext2fs.
+	  You don't want to use the minix file system on your hard disk
+	  because of certain built-in restrictions, but it is sometimes found
+	  on older Linux floppy disks. This option will enlarge your kernel
+	  by about 28 KB. If unsure, say N.
 
+	  To compile this file system support as a module, choose M here: the
+	  module will be called minix. Note that the file system of your root
+	  partition (the one containing the directory /) cannot be compiled as
+	  a module.
 
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
@@ -1425,7 +1420,21 @@ config QNX4FS_RW
 	  It's currently broken, so for now:
 	  answer N.
 
+config ROMFS_FS
+	tristate "ROM file system support"
+	---help---
+	  This is a very small read-only file system mainly intended for
+	  initial ram disks of installation disks, but it could be used for
+	  other read-only media as well. Read
+	  <file:Documentation/filesystems/romfs.txt> for details.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called romfs. Note that the file system of your
+	  root partition (the one containing the directory /) cannot be a
+	  module.
 
+	  If you don't know whether you need it, then you don't need it:
+	  answer N.
 
 config SYSV_FS
 	tristate "System V/Xenix/V7/Coherent file system support"
Index: linux-2.6.23/fs/gfs2/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/gfs2/Kconfig
+++ linux-2.6.23/fs/gfs2/Kconfig
@@ -1,4 +1,4 @@
-config GFS2_FS
+menuconfig GFS2_FS
 	tristate "GFS2 file system support"
 	depends on EXPERIMENTAL
 	select FS_POSIX_ACL
@@ -18,9 +18,10 @@ config GFS2_FS
 	  the below locking modules. Documentation and utilities for GFS2 can
 	  be found here: http://sources.redhat.com/cluster
 
+if GFS2_FS
+
 config GFS2_FS_LOCKING_NOLOCK
 	tristate "GFS2 \"nolock\" locking module"
-	depends on GFS2_FS
 	help
 	  Single node locking module for GFS2.
 
@@ -34,7 +35,7 @@ config GFS2_FS_LOCKING_NOLOCK
 
 config GFS2_FS_LOCKING_DLM
 	tristate "GFS2 DLM locking module"
-	depends on GFS2_FS && SYSFS && NET && INET && (IPV6 || IPV6=n)
+	depends on SYSFS && NET && INET && (IPV6 || IPV6=n)
 	select IP_SCTP if DLM_SCTP
 	select CONFIGFS_FS
 	select DLM
@@ -44,3 +45,5 @@ config GFS2_FS_LOCKING_DLM
 	  Most users of GFS2 will require this module. It provides the locking
 	  interface between GFS2 and the DLM, which is required to use GFS2
 	  in a cluster environment.
+
+endif # GFS2_FS
Index: linux-2.6.23/fs/xfs/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/xfs/Kconfig
+++ linux-2.6.23/fs/xfs/Kconfig
@@ -1,4 +1,4 @@
-config XFS_FS
+menuconfig XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	help
@@ -18,9 +18,10 @@ config XFS_FS
 	  system of your root partition is compiled as a module, you'll need
 	  to use an initial ramdisk (initrd) to boot.
 
+if XFS_FS
+
 config XFS_QUOTA
 	bool "XFS Quota support"
-	depends on XFS_FS
 	help
 	  If you say Y here, you will be able to set limits for disk usage on
 	  a per user and/or a per group basis under XFS.  XFS considers quota
@@ -37,7 +38,6 @@ config XFS_QUOTA
 
 config XFS_SECURITY
 	bool "XFS Security Label support"
-	depends on XFS_FS
 	help
 	  Security labels support alternative access control models
 	  implemented by security modules like SELinux.  This option
@@ -49,7 +49,6 @@ config XFS_SECURITY
 
 config XFS_POSIX_ACL
 	bool "XFS POSIX ACL support"
-	depends on XFS_FS
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
 	  groups beyond the owner/group/world scheme.
@@ -61,7 +60,6 @@ config XFS_POSIX_ACL
 
 config XFS_RT
 	bool "XFS Realtime subvolume support"
-	depends on XFS_FS
 	help
 	  If you say Y here you will be able to mount and use XFS filesystems
 	  which contain a realtime subvolume.  The realtime subvolume is a
@@ -76,3 +74,5 @@ config XFS_RT
 	  See the xfs man page in section 5 for additional information.
 
 	  If unsure, say N.
+
+endif # XFS_FS

