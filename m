Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYCDCBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYCDCBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYCDCBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:05 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:13312 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYCDCBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IvXT6i5aoyg/zrBzWwfWusEjR89eqqjA0w3FWBapSDz0IOuWS+8KIZ58imSp/3Fy0/K0z8ERI2eqzhP900aWX0rlf8bVws0dIpGkgzS46PmZZYP5SiRY8NKSa8iHRDqrBcKkszftgt4EsyRpzkKjm4DvHFhEs18bVlzoDtEmXQA=
Subject: [PATCH 01/13] ext2: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Stephen C. Tweedie" <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:00:58 -0800
Message-Id: <1204596058.22933.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext2/balloc.c |   10 +++++-----
 fs/ext2/dir.c    |   14 +++++++-------
 fs/ext2/super.c  |    6 +++---
 fs/ext2/xip.c    |    2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e7b2baf..62957b4 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -106,7 +106,7 @@ static int ext2_valid_block_bitmap(struct super_block *sb,
 		return 1;
 
 err_out:
-	ext2_error(sb, __FUNCTION__,
+	ext2_error(sb, __func__,
 			"Invalid block bitmap - "
 			"block_group = %d, block = %lu",
 			block_group, bitmap_blk);
@@ -132,7 +132,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext2_error(sb, __FUNCTION__,
+		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -143,7 +143,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 
 	if (bh_submit_read(bh) < 0) {
 		brelse(bh);
-		ext2_error(sb, __FUNCTION__,
+		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -249,7 +249,7 @@ restart:
 		BUG();
 }
 #define rsv_window_dump(root, verbose) \
-	__rsv_window_dump((root), (verbose), __FUNCTION__)
+	__rsv_window_dump((root), (verbose), __func__)
 #else
 #define rsv_window_dump(root, verbose) do {} while (0)
 #endif
@@ -548,7 +548,7 @@ do_more:
 	for (i = 0, group_freed = 0; i < count; i++) {
 		if (!ext2_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
 						bit + i, bitmap_bh->b_data)) {
-			ext2_error(sb, __FUNCTION__,
+			ext2_error(sb, __func__,
 				"bit already cleared for block %lu", block + i);
 		} else {
 			group_freed++;
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 8dededd..92ffaa1 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -295,7 +295,7 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 		struct page *page = ext2_get_page(inode, n);
 
 		if (IS_ERR(page)) {
-			ext2_error(sb, __FUNCTION__,
+			ext2_error(sb, __func__,
 				   "bad page in #%lu",
 				   inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
@@ -314,7 +314,7 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 		limit = kaddr + ext2_last_byte(inode, n) - EXT2_DIR_REC_LEN(1);
 		for ( ;(char*)de <= limit; de = ext2_next_entry(de)) {
 			if (de->rec_len == 0) {
-				ext2_error(sb, __FUNCTION__,
+				ext2_error(sb, __func__,
 					"zero-length directory entry");
 				ext2_put_page(page);
 				return -EIO;
@@ -381,7 +381,7 @@ struct ext2_dir_entry_2 * ext2_find_entry (struct inode * dir,
 			kaddr += ext2_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (de->rec_len == 0) {
-					ext2_error(dir->i_sb, __FUNCTION__,
+					ext2_error(dir->i_sb, __func__,
 						"zero-length directory entry");
 					ext2_put_page(page);
 					goto out;
@@ -396,7 +396,7 @@ struct ext2_dir_entry_2 * ext2_find_entry (struct inode * dir,
 			n = 0;
 		/* next page is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
-			ext2_error(dir->i_sb, __FUNCTION__,
+			ext2_error(dir->i_sb, __func__,
 				"dir %lu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
 				(unsigned long long)dir->i_blocks);
@@ -506,7 +506,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
-				ext2_error(dir->i_sb, __FUNCTION__,
+				ext2_error(dir->i_sb, __func__,
 					"zero-length directory entry");
 				err = -EIO;
 				goto out_unlock;
@@ -578,7 +578,7 @@ int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
 
 	while ((char*)de < (char*)dir) {
 		if (de->rec_len == 0) {
-			ext2_error(inode->i_sb, __FUNCTION__,
+			ext2_error(inode->i_sb, __func__,
 				"zero-length directory entry");
 			err = -EIO;
 			goto out;
@@ -670,7 +670,7 @@ int ext2_empty_dir (struct inode * inode)
 
 		while ((char *)de <= kaddr) {
 			if (de->rec_len == 0) {
-				ext2_error(inode->i_sb, __FUNCTION__,
+				ext2_error(inode->i_sb, __func__,
 					"zero-length directory entry");
 				printk("kaddr=%p, de=%p\n", kaddr, de);
 				goto not_empty;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 088b011..e417f72 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -90,7 +90,7 @@ void ext2_update_dynamic_rev(struct super_block *sb)
 	if (le32_to_cpu(es->s_rev_level) > EXT2_GOOD_OLD_REV)
 		return;
 
-	ext2_warning(sb, __FUNCTION__,
+	ext2_warning(sb, __func__,
 		     "updating to rev %d because of new feature flag, "
 		     "running e2fsck is recommended",
 		     EXT2_DYNAMIC_REV);
@@ -1062,7 +1062,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount3;
 	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
-		ext2_warning(sb, __FUNCTION__,
+		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	return 0;
@@ -1180,7 +1180,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
 	    invalidate_inodes(sb))
-		ext2_warning(sb, __FUNCTION__, "busy inodes while remounting "\
+		ext2_warning(sb, __func__, "busy inodes while remounting "\
 			     "xip remain in cache (no functional problem)");
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index ca7f003..1856ff5 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -64,7 +64,7 @@ void ext2_xip_verify_sb(struct super_block *sb)
 	if ((sbi->s_mount_opt & EXT2_MOUNT_XIP) &&
 	    !sb->s_bdev->bd_disk->fops->direct_access) {
 		sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
-		ext2_warning(sb, __FUNCTION__,
+		ext2_warning(sb, __func__,
 			     "ignoring xip option - not supported by bdev");
 	}
 }
-- 
1.5.4.3.500.g83a2c


