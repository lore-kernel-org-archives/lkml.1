Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZDYPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZDYPLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 11:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZDYPLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 11:11:14 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:55111 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZDYPLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 11:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=W1m5DQtnKLVSWNxIeZkBxjcTeGdw9o8uyvbKM6AHReMaNiXulDUYd2LkIa5Dk+5od4
         Y0SZDJUh3ZNw18TH78YbDb+49cZvMCA9M5t0j1BTkPy/llPf5fqetgmSnBtnPE6Nzq/U
         4PCOg3ylVoNYjgRTjr5LIjiCRELkQdgc7Gzqw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: rename CONFIG_LBD to CONFIG_LBDAF
Date: Sat, 25 Apr 2009 17:14:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904251714.52020.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow-up to "block: enable by default support for large devices
and files on 32-bit archs".

Rename CONFIG_LBD to CONFIG_LBDAF to:
- allow update of existing [def]configs for "default y" change
- reflect that it is used also for large files support nowadays

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/SubmitChecklist       |    2 +-
 Documentation/ja_JP/SubmitChecklist |    2 +-
 block/Kconfig                       |    4 ++--
 drivers/md/dm-exception-store.h     |    2 +-
 fs/ext3/resize.c                    |    2 +-
 fs/ext3/super.c                     |    2 +-
 fs/ext4/resize.c                    |    2 +-
 fs/ext4/super.c                     |   10 +++++-----
 fs/gfs2/Kconfig                     |    2 +-
 fs/ocfs2/super.c                    |    2 +-
 fs/xfs/linux-2.6/xfs_linux.h        |    2 +-
 fs/xfs/linux-2.6/xfs_super.c        |    2 +-
 include/linux/kernel.h              |    2 +-
 include/linux/types.h               |    2 +-
 14 files changed, 19 insertions(+), 19 deletions(-)

Index: b/Documentation/SubmitChecklist
===================================================================
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -54,7 +54,7 @@ kernel patches.
     CONFIG_PREEMPT.
 
 14: If the patch affects IO/Disk, etc: has been tested with and without
-    CONFIG_LBD.
+    CONFIG_LBDAF.
 
 15: All codepaths have been exercised with all lockdep features enabled.
 
Index: b/Documentation/ja_JP/SubmitChecklist
===================================================================
--- a/Documentation/ja_JP/SubmitChecklist
+++ b/Documentation/ja_JP/SubmitChecklist
@@ -75,7 +75,7 @@ Linux カーネルパッチ投稿者向�
     ビルドした上、動作確認を行ってください。
 
 14: もしパッチがディスクのI/O性能などに影響を与えるようであれば、
-    'CONFIG_LBD'オプションを有効にした場合と無効にした場合の両方で
+    'CONFIG_LBDAF'オプションを有効にした場合と無効にした場合の両方で
     テストを実施してみてください。
 
 15: lockdepの機能を全て有効にした上で、全てのコードパスを評価してください。
Index: b/block/Kconfig
===================================================================
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -23,8 +23,8 @@ menuconfig BLOCK
 
 if BLOCK
 
-config LBD
-	bool "Support for large block devices and files"
+config LBDAF
+	bool "Support for large (2TB+) block devices and files"
 	depends on !64BIT
 	default y
 	help
Index: b/drivers/md/dm-exception-store.h
===================================================================
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -111,7 +111,7 @@ struct dm_exception_store {
 /*
  * Funtions to manipulate consecutive chunks
  */
-#  if defined(CONFIG_LBD) || (BITS_PER_LONG == 64)
+#  if defined(CONFIG_LBDAF) || (BITS_PER_LONG == 64)
 #    define DM_CHUNK_CONSECUTIVE_BITS 8
 #    define DM_CHUNK_NUMBER_BITS 56
 
Index: b/fs/ext3/resize.c
===================================================================
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -991,7 +991,7 @@ int ext3_group_extend(struct super_block
 			sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
 			ext3_warning(sb, __func__,
-			"CONFIG_LBD not enabled\n");
+			"CONFIG_LBDAF not enabled\n");
 		return -EINVAL;
 	}
 
Index: b/fs/ext3/super.c
===================================================================
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1812,7 +1812,7 @@ static int ext3_fill_super (struct super
 		printk(KERN_ERR "EXT3-fs: filesystem on %s:"
 			" too large to mount safely\n", sb->s_id);
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT3-fs: CONFIG_LBD not "
+			printk(KERN_WARNING "EXT3-fs: CONFIG_LBDAF not "
 					"enabled\n");
 		goto failed_mount;
 	}
Index: b/fs/ext4/resize.c
===================================================================
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1002,7 +1002,7 @@ int ext4_group_extend(struct super_block
 			" too large to resize to %llu blocks safely\n",
 			sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
-			ext4_warning(sb, __func__, "CONFIG_LBD not enabled");
+			ext4_warning(sb, __func__, "CONFIG_LBDAF not enabled");
 		return -EINVAL;
 	}
 
Index: b/fs/ext4/super.c
===================================================================
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1894,7 +1894,7 @@ static loff_t ext4_max_size(int blkbits,
 	/* small i_blocks in vfs inode? */
 	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
 		/*
-		 * CONFIG_LBD is not enabled implies the inode
+		 * CONFIG_LBDAF is not enabled implies the inode
 		 * i_block represent total blocks in 512 bytes
 		 * 32 == size of vfs inode i_blocks * 8
 		 */
@@ -1937,7 +1937,7 @@ static loff_t ext4_max_bitmap_size(int b
 
 	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
 		/*
-		 * !has_huge_files or CONFIG_LBD is not enabled
+		 * !has_huge_files or CONFIG_LBDAF is not enabled
 		 * implies the inode i_block represent total blocks in
 		 * 512 bytes 32 == size of vfs inode i_blocks * 8
 		 */
@@ -2372,13 +2372,13 @@ static int ext4_fill_super(struct super_
 	if (has_huge_files) {
 		/*
 		 * Large file size enabled file system can only be
-		 * mount if kernel is build with CONFIG_LBD
+		 * mount if kernel is build with CONFIG_LBDAF
 		 */
 		if (sizeof(root->i_blocks) < sizeof(u64) &&
 				!(sb->s_flags & MS_RDONLY)) {
 			printk(KERN_ERR "EXT4-fs: %s: Filesystem with huge "
 					"files cannot be mounted read-write "
-					"without CONFIG_LBD.\n", sb->s_id);
+					"without CONFIG_LBDAF.\n", sb->s_id);
 			goto failed_mount;
 		}
 	}
@@ -2500,7 +2500,7 @@ static int ext4_fill_super(struct super_
 		printk(KERN_ERR "EXT4-fs: filesystem on %s:"
 			" too large to mount safely\n", sb->s_id);
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT4-fs: CONFIG_LBD not "
+			printk(KERN_WARNING "EXT4-fs: CONFIG_LBDAF not "
 					"enabled\n");
 		goto failed_mount;
 	}
Index: b/fs/gfs2/Kconfig
===================================================================
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,6 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
-	depends on EXPERIMENTAL && (64BIT || LBD)
+	depends on EXPERIMENTAL && (64BIT || LBDAF)
 	select DLM if GFS2_FS_LOCKING_DLM
 	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
 	select SYSFS if GFS2_FS_LOCKING_DLM
Index: b/fs/ocfs2/super.c
===================================================================
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -555,7 +555,7 @@ static unsigned long long ocfs2_max_file
 	 */
 
 #if BITS_PER_LONG == 32
-# if defined(CONFIG_LBD)
+# if defined(CONFIG_LBDAF)
 	BUILD_BUG_ON(sizeof(sector_t) != 8);
 	/*
 	 * We might be limited by page cache size.
Index: b/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -24,7 +24,7 @@
  * XFS_BIG_BLKNOS needs block layer disk addresses to be 64 bits.
  * XFS_BIG_INUMS requires XFS_BIG_BLKNOS to be set.
  */
-#if defined(CONFIG_LBD) || (BITS_PER_LONG == 64)
+#if defined(CONFIG_LBDAF) || (BITS_PER_LONG == 64)
 # define XFS_BIG_BLKNOS	1
 # define XFS_BIG_INUMS	1
 #else
Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -609,7 +609,7 @@ xfs_max_file_offset(
 	 */
 
 #if BITS_PER_LONG == 32
-# if defined(CONFIG_LBD)
+# if defined(CONFIG_LBDAF)
 	ASSERT(sizeof(sector_t) == 8);
 	pagefactor = PAGE_CACHE_SIZE;
 	bitshift = BITS_PER_LONG;
Index: b/include/linux/kernel.h
===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -58,7 +58,7 @@ extern const char linux_proc_banner[];
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
 
-#ifdef CONFIG_LBD
+#ifdef CONFIG_LBDAF
 # include <asm/div64.h>
 # define sector_div(a, b) do_div(a, b)
 #else
Index: b/include/linux/types.h
===================================================================
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -131,7 +131,7 @@ typedef		__s64		int64_t;
  *
  * blkcnt_t is the type of the inode's block count.
  */
-#ifdef CONFIG_LBD
+#ifdef CONFIG_LBDAF
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
 #else
