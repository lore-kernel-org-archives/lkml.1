Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYCDCCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYCDCCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYCDCBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:15 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:49649 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYCDCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fvSkJiFA4uGUU/XxyOiLY2roP3NAWc80q8g09pzUQrE2K9aCJBRz+hK3JlaOx+1kDf8wasNecxC7R37AxHApKrS4lhTwaPrJRHDdxgiTluEGR2hIG4laKsGHBRG/A7oG5o0s749vr8ruaXs50kYoNz7K9zzk/IH+Uiln0LrK5pA=
Subject: [PATCH 02/13] ext3: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Stephen C. Tweedie" <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:00:59 -0800
Message-Id: <1204596059.22933.53.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext3/balloc.c   |   12 ++++----
 fs/ext3/ext3_jbd.c |   12 ++++----
 fs/ext3/ialloc.c   |    6 ++--
 fs/ext3/inode.c    |    6 ++--
 fs/ext3/namei.c    |   26 +++++++++---------
 fs/ext3/resize.c   |   70 ++++++++++++++++++++++++++--------------------------
 fs/ext3/super.c    |   14 +++++-----
 fs/ext3/xattr.c    |   14 +++++-----
 8 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index da0cb2c..6a55990 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -117,7 +117,7 @@ static int ext3_valid_block_bitmap(struct super_block *sb,
 		return 1;
 
 err_out:
-	ext3_error(sb, __FUNCTION__,
+	ext3_error(sb, __func__,
 			"Invalid block bitmap - "
 			"block_group = %d, block = %lu",
 			block_group, bitmap_blk);
@@ -147,7 +147,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext3_error(sb, __FUNCTION__,
+		ext3_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -158,7 +158,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 
 	if (bh_submit_read(bh) < 0) {
 		brelse(bh);
-		ext3_error(sb, __FUNCTION__,
+		ext3_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -236,7 +236,7 @@ restart:
 		BUG();
 }
 #define rsv_window_dump(root, verbose) \
-	__rsv_window_dump((root), (verbose), __FUNCTION__)
+	__rsv_window_dump((root), (verbose), __func__)
 #else
 #define rsv_window_dump(root, verbose) do {} while (0)
 #endif
@@ -618,7 +618,7 @@ do_more:
 		if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
 						bit + i, bitmap_bh->b_data)) {
 			jbd_unlock_bh_state(bitmap_bh);
-			ext3_error(sb, __FUNCTION__,
+			ext3_error(sb, __func__,
 				"bit already cleared for block "E3FSBLK,
 				 block + i);
 			jbd_lock_bh_state(bitmap_bh);
@@ -1668,7 +1668,7 @@ allocated:
 			if (ext3_test_bit(grp_alloc_blk+i,
 					bh2jh(bitmap_bh)->b_committed_data)) {
 				printk("%s: block was unexpectedly set in "
-					"b_committed_data\n", __FUNCTION__);
+					"b_committed_data\n", __func__);
 			}
 		}
 	}
diff --git a/fs/ext3/ext3_jbd.c b/fs/ext3/ext3_jbd.c
index e1f91fd..d401f14 100644
--- a/fs/ext3/ext3_jbd.c
+++ b/fs/ext3/ext3_jbd.c
@@ -9,7 +9,7 @@ int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
 {
 	int err = journal_get_undo_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -18,7 +18,7 @@ int __ext3_journal_get_write_access(const char *where, handle_t *handle,
 {
 	int err = journal_get_write_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -27,7 +27,7 @@ int __ext3_journal_forget(const char *where, handle_t *handle,
 {
 	int err = journal_forget(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -36,7 +36,7 @@ int __ext3_journal_revoke(const char *where, handle_t *handle,
 {
 	int err = journal_revoke(handle, blocknr, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -45,7 +45,7 @@ int __ext3_journal_get_create_access(const char *where,
 {
 	int err = journal_get_create_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -54,6 +54,6 @@ int __ext3_journal_dirty_metadata(const char *where,
 {
 	int err = journal_dirty_metadata(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4f4020c..5c1963e 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -644,7 +644,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "bad orphan ino %lu!  e2fsck was run?", ino);
 		goto error;
 	}
@@ -653,7 +653,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 	bit = (ino - 1) % EXT3_INODES_PER_GROUP(sb);
 	bitmap_bh = read_inode_bitmap(sb, block_group);
 	if (!bitmap_bh) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "inode bitmap error for orphan %lu", ino);
 		goto error;
 	}
@@ -678,7 +678,7 @@ iget_failed:
 	err = PTR_ERR(inode);
 	inode = NULL;
 bad_orphan:
-	ext3_warning(sb, __FUNCTION__,
+	ext3_warning(sb, __func__,
 		     "bad orphan inode %lu!  e2fsck was run?", ino);
 	printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
 	       bit, (unsigned long long)bitmap_bh->b_blocknr,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..0a7bc0b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -95,7 +95,7 @@ int ext3_forget(handle_t *handle, int is_metadata, struct inode *inode,
 	BUFFER_TRACE(bh, "call ext3_journal_revoke");
 	err = ext3_journal_revoke(handle, blocknr, bh);
 	if (err)
-		ext3_abort(inode->i_sb, __FUNCTION__,
+		ext3_abort(inode->i_sb, __func__,
 			   "error %d when attempting revoke", err);
 	BUFFER_TRACE(bh, "exit");
 	return err;
@@ -1190,7 +1190,7 @@ int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 {
 	int err = journal_dirty_data(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
+		ext3_journal_abort_handle(__func__, __func__,
 						bh, handle, err);
 	return err;
 }
@@ -3214,7 +3214,7 @@ void ext3_dirty_inode(struct inode *inode)
 		current_handle->h_transaction != handle->h_transaction) {
 		/* This task has a transaction open against a different fs */
 		printk(KERN_EMERG "%s: transactions do not match!\n",
-		       __FUNCTION__);
+		       __func__);
 	} else {
 		jbd_debug(5, "marking dirty.  outer handle=%p\n",
 				current_handle);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index dec3e0d..21d6c82 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -356,7 +356,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	if (root->info.hash_version != DX_HASH_TEA &&
 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
 	    root->info.hash_version != DX_HASH_LEGACY) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unrecognised inode hash code %d",
 			     root->info.hash_version);
 		brelse(bh);
@@ -370,7 +370,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash flags: %#06x",
 			     root->info.unused_flags);
 		brelse(bh);
@@ -379,7 +379,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	}
 
 	if ((indirect = root->info.indirect_levels) > 1) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash depth: %#06x",
 			     root->info.indirect_levels);
 		brelse(bh);
@@ -392,7 +392,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
 						   root->info.info_length)) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "dx entry: limit != root limit");
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
@@ -404,7 +404,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	{
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
-			ext3_warning(dir->i_sb, __FUNCTION__,
+			ext3_warning(dir->i_sb, __func__,
 				     "dx entry: no count or count > limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
@@ -449,7 +449,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
-			ext3_warning(dir->i_sb, __FUNCTION__,
+			ext3_warning(dir->i_sb, __func__,
 				     "dx entry: limit != node limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
@@ -465,7 +465,7 @@ fail2:
 	}
 fail:
 	if (*err == ERR_BAD_DX_DIR)
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Corrupt dir inode %ld, running e2fsck is "
 			     "recommended.", dir->i_ino);
 	return NULL;
@@ -913,7 +913,7 @@ restart:
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			/* read error, skip block & hope for the best */
-			ext3_error(sb, __FUNCTION__, "reading directory #%lu "
+			ext3_error(sb, __func__, "reading directory #%lu "
 				   "offset %lu", dir->i_ino, block);
 			brelse(bh);
 			goto next;
@@ -1005,7 +1005,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 		retval = ext3_htree_next_block(dir, hash, frame,
 					       frames, NULL);
 		if (retval < 0) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 			     "error reading index page in directory #%lu",
 			     dir->i_ino);
 			*err = retval;
@@ -1530,7 +1530,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 
 		if (levels && (dx_get_count(frames->entries) ==
 			       dx_get_limit(frames->entries))) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "Directory index full!");
 			err = -ENOSPC;
 			goto cleanup;
@@ -1832,11 +1832,11 @@ static int empty_dir (struct inode * inode)
 	if (inode->i_size < EXT3_DIR_REC_LEN(1) + EXT3_DIR_REC_LEN(2) ||
 	    !(bh = ext3_bread (NULL, inode, 0, 0, &err))) {
 		if (err)
-			ext3_error(inode->i_sb, __FUNCTION__,
+			ext3_error(inode->i_sb, __func__,
 				   "error %d reading directory #%lu offset 0",
 				   err, inode->i_ino);
 		else
-			ext3_warning(inode->i_sb, __FUNCTION__,
+			ext3_warning(inode->i_sb, __func__,
 				     "bad directory (dir #%lu) - no data block",
 				     inode->i_ino);
 		return 1;
@@ -1865,7 +1865,7 @@ static int empty_dir (struct inode * inode)
 				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err);
 			if (!bh) {
 				if (err)
-					ext3_error(sb, __FUNCTION__,
+					ext3_error(sb, __func__,
 						   "error %d reading directory"
 						   " #%lu offset %lu",
 						   err, inode->i_ino, offset);
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 9397d77..f7eb77c 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -48,60 +48,60 @@ static int verify_group_input(struct super_block *sb,
 		       free_blocks_count, input->reserved_blocks);
 
 	if (group != sbi->s_groups_count)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Cannot add at group %u (only %lu groups)",
 			     input->group, sbi->s_groups_count);
 	else if ((start - le32_to_cpu(es->s_first_data_block)) %
 		 EXT3_BLOCKS_PER_GROUP(sb))
-		ext3_warning(sb, __FUNCTION__, "Last group not full");
+		ext3_warning(sb, __func__, "Last group not full");
 	else if (input->reserved_blocks > input->blocks_count / 5)
-		ext3_warning(sb, __FUNCTION__, "Reserved blocks too high (%u)",
+		ext3_warning(sb, __func__, "Reserved blocks too high (%u)",
 			     input->reserved_blocks);
 	else if (free_blocks_count < 0)
-		ext3_warning(sb, __FUNCTION__, "Bad blocks count %u",
+		ext3_warning(sb, __func__, "Bad blocks count %u",
 			     input->blocks_count);
 	else if (!(bh = sb_bread(sb, end - 1)))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Cannot read last block ("E3FSBLK")",
 			     end - 1);
 	else if (outside(input->block_bitmap, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap not in group (block %u)",
 			     input->block_bitmap);
 	else if (outside(input->inode_bitmap, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap not in group (block %u)",
 			     input->inode_bitmap);
 	else if (outside(input->inode_table, start, end) ||
 	         outside(itend - 1, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode table not in group (blocks %u-"E3FSBLK")",
 			     input->inode_table, itend - 1);
 	else if (input->inode_bitmap == input->block_bitmap)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap same as inode bitmap (%u)",
 			     input->block_bitmap);
 	else if (inside(input->block_bitmap, input->inode_table, itend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap (%u) in inode table (%u-"E3FSBLK")",
 			     input->block_bitmap, input->inode_table, itend-1);
 	else if (inside(input->inode_bitmap, input->inode_table, itend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap (%u) in inode table (%u-"E3FSBLK")",
 			     input->inode_bitmap, input->inode_table, itend-1);
 	else if (inside(input->block_bitmap, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap (%u) in GDT table"
 			     " ("E3FSBLK"-"E3FSBLK")",
 			     input->block_bitmap, start, metaend - 1);
 	else if (inside(input->inode_bitmap, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap (%u) in GDT table"
 			     " ("E3FSBLK"-"E3FSBLK")",
 			     input->inode_bitmap, start, metaend - 1);
 	else if (inside(input->inode_table, start, metaend) ||
 	         inside(itend - 1, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode table (%u-"E3FSBLK") overlaps"
 			     "GDT table ("E3FSBLK"-"E3FSBLK")",
 			     input->inode_table, itend - 1, start, metaend - 1);
@@ -386,7 +386,7 @@ static int verify_reserved_gdb(struct super_block *sb,
 
 	while ((grp = ext3_list_backups(sb, &three, &five, &seven)) < end) {
 		if (le32_to_cpu(*p++) != grp * EXT3_BLOCKS_PER_GROUP(sb) + blk){
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "reserved GDT "E3FSBLK
 				     " missing grp %d ("E3FSBLK")",
 				     blk, grp,
@@ -440,7 +440,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	 */
 	if (EXT3_SB(sb)->s_sbh->b_blocknr !=
 	    le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			"won't resize using backup superblock at %llu",
 			(unsigned long long)EXT3_SB(sb)->s_sbh->b_blocknr);
 		return -EPERM;
@@ -464,7 +464,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 
 	data = (__le32 *)dind->b_data;
 	if (le32_to_cpu(data[gdb_num % EXT3_ADDR_PER_BLOCK(sb)]) != gdblock) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "new group %u GDT block "E3FSBLK" not reserved",
 			     input->group, gdblock);
 		err = -EINVAL;
@@ -488,7 +488,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 			GFP_KERNEL);
 	if (!n_group_desc) {
 		err = -ENOMEM;
-		ext3_warning (sb, __FUNCTION__,
+		ext3_warning (sb, __func__,
 			      "not enough memory for %lu groups", gdb_num + 1);
 		goto exit_inode;
 	}
@@ -586,7 +586,7 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	/* Get each reserved primary GDT block and verify it holds backups */
 	for (res = 0; res < reserved_gdb; res++, blk++) {
 		if (le32_to_cpu(*data) != blk) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "reserved block "E3FSBLK
 				     " not at offset %ld",
 				     blk,
@@ -730,7 +730,7 @@ static void update_backups(struct super_block *sb,
 	 */
 exit_err:
 	if (err) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't update backup for group %d (err %d), "
 			     "forcing fsck on next reboot", group, err);
 		sbi->s_mount_state &= ~EXT3_VALID_FS;
@@ -770,33 +770,33 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 
 	if (gdb_off == 0 && !EXT3_HAS_RO_COMPAT_FEATURE(sb,
 					EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Can't resize non-sparse filesystem further");
 		return -EPERM;
 	}
 
 	if (le32_to_cpu(es->s_blocks_count) + input->blocks_count <
 	    le32_to_cpu(es->s_blocks_count)) {
-		ext3_warning(sb, __FUNCTION__, "blocks_count overflow\n");
+		ext3_warning(sb, __func__, "blocks_count overflow\n");
 		return -EINVAL;
 	}
 
 	if (le32_to_cpu(es->s_inodes_count) + EXT3_INODES_PER_GROUP(sb) <
 	    le32_to_cpu(es->s_inodes_count)) {
-		ext3_warning(sb, __FUNCTION__, "inodes_count overflow\n");
+		ext3_warning(sb, __func__, "inodes_count overflow\n");
 		return -EINVAL;
 	}
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT3_HAS_COMPAT_FEATURE(sb,
 					     EXT3_FEATURE_COMPAT_RESIZE_INODE)){
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
 		inode = ext3_iget(sb, EXT3_RESIZE_INO);
 		if (IS_ERR(inode)) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "Error opening resize inode");
 			return PTR_ERR(inode);
 		}
@@ -825,7 +825,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 
 	lock_super(sb);
 	if (input->group != sbi->s_groups_count) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
 		err = -EBUSY;
 		goto exit_journal;
@@ -988,13 +988,13 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 			" too large to resize to %lu blocks safely\n",
 			sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 			"CONFIG_LBD not enabled\n");
 		return -EINVAL;
 	}
 
 	if (n_blocks_count < o_blocks_count) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't shrink FS - resize aborted");
 		return -EBUSY;
 	}
@@ -1004,7 +1004,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 		EXT3_BLOCKS_PER_GROUP(sb);
 
 	if (last == 0) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "need to use ext2online to resize further");
 		return -EPERM;
 	}
@@ -1012,7 +1012,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 	add = EXT3_BLOCKS_PER_GROUP(sb) - last;
 
 	if (o_blocks_count + add < o_blocks_count) {
-		ext3_warning(sb, __FUNCTION__, "blocks_count overflow");
+		ext3_warning(sb, __func__, "blocks_count overflow");
 		return -EINVAL;
 	}
 
@@ -1020,7 +1020,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 		add = n_blocks_count - o_blocks_count;
 
 	if (o_blocks_count + add < n_blocks_count)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "will only finish group ("E3FSBLK
 			     " blocks, %u new)",
 			     o_blocks_count + add, add);
@@ -1028,7 +1028,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 	/* See if the device is actually as big as what was requested */
 	bh = sb_bread(sb, o_blocks_count + add -1);
 	if (!bh) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't read last block, resize aborted");
 		return -ENOSPC;
 	}
@@ -1040,13 +1040,13 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 	handle = ext3_journal_start_sb(sb, 3);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-		ext3_warning(sb, __FUNCTION__, "error %d on journal start",err);
+		ext3_warning(sb, __func__, "error %d on journal start",err);
 		goto exit_put;
 	}
 
 	lock_super(sb);
 	if (o_blocks_count != le32_to_cpu(es->s_blocks_count)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
 		err = -EBUSY;
@@ -1055,7 +1055,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 
 	if ((err = ext3_journal_get_write_access(handle,
 						 EXT3_SB(sb)->s_sbh))) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "error %d on journal write access", err);
 		unlock_super(sb);
 		ext3_journal_stop(handle);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 18769cc..aa9d1ef 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -84,7 +84,7 @@ handle_t *ext3_journal_start_sb(struct super_block *sb, int nblocks)
 	 * take the FS itself readonly cleanly. */
 	journal = EXT3_SB(sb)->s_journal;
 	if (is_journal_aborted(journal)) {
-		ext3_abort(sb, __FUNCTION__,
+		ext3_abort(sb, __func__,
 			   "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
@@ -304,7 +304,7 @@ void ext3_update_dynamic_rev(struct super_block *sb)
 	if (le32_to_cpu(es->s_rev_level) > EXT3_GOOD_OLD_REV)
 		return;
 
-	ext3_warning(sb, __FUNCTION__,
+	ext3_warning(sb, __func__,
 		     "updating to rev %d because of new feature flag, "
 		     "running e2fsck is recommended",
 		     EXT3_DYNAMIC_REV);
@@ -1387,7 +1387,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		if (inode->i_nlink) {
 			printk(KERN_DEBUG
 				"%s: truncating inode %lu to %Ld bytes\n",
-				__FUNCTION__, inode->i_ino, inode->i_size);
+				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext3_truncate(inode);
@@ -1395,7 +1395,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		} else {
 			printk(KERN_DEBUG
 				"%s: deleting unreferenced inode %lu\n",
-				__FUNCTION__, inode->i_ino);
+				__func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
 			nr_orphans++;
@@ -2298,9 +2298,9 @@ static void ext3_clear_journal_err(struct super_block * sb,
 		char nbuf[16];
 
 		errstr = ext3_decode_error(sb, j_errno, nbuf);
-		ext3_warning(sb, __FUNCTION__, "Filesystem error recorded "
+		ext3_warning(sb, __func__, "Filesystem error recorded "
 			     "from previous mount: %s", errstr);
-		ext3_warning(sb, __FUNCTION__, "Marking fs in need of "
+		ext3_warning(sb, __func__, "Marking fs in need of "
 			     "filesystem check.");
 
 		EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
@@ -2427,7 +2427,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	}
 
 	if (sbi->s_mount_opt & EXT3_MOUNT_ABORT)
-		ext3_abort(sb, __FUNCTION__, "Abort forced by user");
+		ext3_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index fb89c29..4383768 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -232,7 +232,7 @@ ext3_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext3_xattr_check_block(bh)) {
-bad_block:	ext3_error(inode->i_sb, __FUNCTION__,
+bad_block:	ext3_error(inode->i_sb, __func__,
 			   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 			   EXT3_I(inode)->i_file_acl);
 		error = -EIO;
@@ -374,7 +374,7 @@ ext3_xattr_block_list(struct inode *inode, char *buffer, size_t buffer_size)
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext3_xattr_check_block(bh)) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 			   EXT3_I(inode)->i_file_acl);
 		error = -EIO;
@@ -649,7 +649,7 @@ ext3_xattr_block_find(struct inode *inode, struct ext3_xattr_info *i,
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));
 		if (ext3_xattr_check_block(bs->bh)) {
-			ext3_error(sb, __FUNCTION__,
+			ext3_error(sb, __func__,
 				"inode %lu: bad block "E3FSBLK, inode->i_ino,
 				EXT3_I(inode)->i_file_acl);
 			error = -EIO;
@@ -852,7 +852,7 @@ cleanup_dquot:
 	goto cleanup;
 
 bad_block:
-	ext3_error(inode->i_sb, __FUNCTION__,
+	ext3_error(inode->i_sb, __func__,
 		   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 		   EXT3_I(inode)->i_file_acl);
 	goto cleanup;
@@ -1081,14 +1081,14 @@ ext3_xattr_delete_inode(handle_t *handle, struct inode *inode)
 		goto cleanup;
 	bh = sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
 	if (!bh) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			"inode %lu: block "E3FSBLK" read error", inode->i_ino,
 			EXT3_I(inode)->i_file_acl);
 		goto cleanup;
 	}
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT3_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1)) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			"inode %lu: bad block "E3FSBLK, inode->i_ino,
 			EXT3_I(inode)->i_file_acl);
 		goto cleanup;
@@ -1215,7 +1215,7 @@ again:
 		}
 		bh = sb_bread(inode->i_sb, ce->e_block);
 		if (!bh) {
-			ext3_error(inode->i_sb, __FUNCTION__,
+			ext3_error(inode->i_sb, __func__,
 				"inode %lu: block %lu read error",
 				inode->i_ino, (unsigned long) ce->e_block);
 		} else if (le32_to_cpu(BHDR(bh)->h_refcount) >=
-- 
1.5.4.3.500.g83a2c


