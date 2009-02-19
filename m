Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZBSSV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZBSSV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZBSSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:20:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36641 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZBSSUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:20:12 -0500
Subject: [RFC][PATCH 1/5] create fs flag to mark c/r supported fs's
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 10:20:07 -0800
Message-Id: <20090219182007.B4B47C1F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are plenty of filesystems that are not supported for
c/r at this point.  Think of things like hugetlbfs which
are externally visible or pipefs which are kernel-internal.

This provides a quick way to make the "normal" filesystems
which are currently supported.  This is also safe if any
new code gets added.  We assume that a fs is non-supported
unless someone takes explicit action to the contrary.

I bet there are some more filesystems that are OK, but
these probably cover 99% of the users for now.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/ext2/super.c              |    2 +-
 linux-2.6.git-dave/fs/ext3/super.c              |    2 +-
 linux-2.6.git-dave/fs/ext4/super.c              |    4 ++--
 linux-2.6.git-dave/fs/fat/namei_msdos.c         |    2 +-
 linux-2.6.git-dave/fs/fat/namei_vfat.c          |    2 +-
 linux-2.6.git-dave/fs/jfs/super.c               |    2 +-
 linux-2.6.git-dave/fs/minix/inode.c             |    2 +-
 linux-2.6.git-dave/fs/reiserfs/super.c          |    2 +-
 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_super.c |    2 +-
 linux-2.6.git-dave/include/linux/fs.h           |    1 +
 10 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/ext2/super.c~sb_op-for-checkpointable-files fs/ext2/super.c
--- linux-2.6.git/fs/ext2/super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/ext2/super.c	2009-02-19 10:17:23.000000000 -0800
@@ -1401,7 +1401,7 @@ static struct file_system_type ext2_fs_t
 	.name		= "ext2",
 	.get_sb		= ext2_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static int __init init_ext2_fs(void)
diff -puN fs/ext3/super.c~sb_op-for-checkpointable-files fs/ext3/super.c
--- linux-2.6.git/fs/ext3/super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/ext3/super.c	2009-02-19 10:17:23.000000000 -0800
@@ -2969,7 +2969,7 @@ static struct file_system_type ext3_fs_t
 	.name		= "ext3",
 	.get_sb		= ext3_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static int __init init_ext3_fs(void)
diff -puN fs/ext4/super.c~sb_op-for-checkpointable-files fs/ext4/super.c
--- linux-2.6.git/fs/ext4/super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/ext4/super.c	2009-02-19 10:17:23.000000000 -0800
@@ -3543,7 +3543,7 @@ static struct file_system_type ext4_fs_t
 	.name		= "ext4",
 	.get_sb		= ext4_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 #ifdef CONFIG_EXT4DEV_COMPAT
@@ -3562,7 +3562,7 @@ static struct file_system_type ext4dev_f
 	.name		= "ext4dev",
 	.get_sb		= ext4dev_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 MODULE_ALIAS("ext4dev");
 #endif
diff -puN fs/fat/namei_msdos.c~sb_op-for-checkpointable-files fs/fat/namei_msdos.c
--- linux-2.6.git/fs/fat/namei_msdos.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/fat/namei_msdos.c	2009-02-19 10:17:23.000000000 -0800
@@ -685,7 +685,7 @@ static struct file_system_type msdos_fs_
 	.name		= "msdos",
 	.get_sb		= msdos_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static int __init init_msdos_fs(void)
diff -puN fs/fat/namei_vfat.c~sb_op-for-checkpointable-files fs/fat/namei_vfat.c
--- linux-2.6.git/fs/fat/namei_vfat.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/fat/namei_vfat.c	2009-02-19 10:17:23.000000000 -0800
@@ -1077,7 +1077,7 @@ static struct file_system_type vfat_fs_t
 	.name		= "vfat",
 	.get_sb		= vfat_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static int __init init_vfat_fs(void)
diff -puN fs/jfs/super.c~sb_op-for-checkpointable-files fs/jfs/super.c
--- linux-2.6.git/fs/jfs/super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/jfs/super.c	2009-02-19 10:17:23.000000000 -0800
@@ -757,7 +757,7 @@ static struct file_system_type jfs_fs_ty
 	.name		= "jfs",
 	.get_sb		= jfs_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static void init_once(void *foo)
diff -puN fs/minix/inode.c~sb_op-for-checkpointable-files fs/minix/inode.c
--- linux-2.6.git/fs/minix/inode.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/minix/inode.c	2009-02-19 10:17:23.000000000 -0800
@@ -623,7 +623,7 @@ static struct file_system_type minix_fs_
 	.name		= "minix",
 	.get_sb		= minix_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 static int __init init_minix_fs(void)
diff -puN fs/reiserfs/super.c~sb_op-for-checkpointable-files fs/reiserfs/super.c
--- linux-2.6.git/fs/reiserfs/super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/reiserfs/super.c	2009-02-19 10:17:23.000000000 -0800
@@ -2284,7 +2284,7 @@ struct file_system_type reiserfs_fs_type
 	.name = "reiserfs",
 	.get_sb = get_super_block,
 	.kill_sb = reiserfs_kill_sb,
-	.fs_flags = FS_REQUIRES_DEV,
+	.fs_flags = FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 MODULE_DESCRIPTION("ReiserFS journaled filesystem");
diff -puN fs/xfs/linux-2.6/xfs_super.c~sb_op-for-checkpointable-files fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_super.c~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_super.c	2009-02-19 10:17:23.000000000 -0800
@@ -1866,7 +1866,7 @@ static struct file_system_type xfs_fs_ty
 	.name			= "xfs",
 	.get_sb			= xfs_fs_get_sb,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_CHECKPOINTABLE,
 };
 
 STATIC int __init
diff -puN include/linux/fs.h~sb_op-for-checkpointable-files include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~sb_op-for-checkpointable-files	2009-02-19 10:17:23.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2009-02-19 10:17:23.000000000 -0800
@@ -104,6 +104,7 @@ extern int dir_notify_enable;
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
+#define FS_CHECKPOINTABLE 8
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
_
