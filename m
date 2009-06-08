Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZFHTZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZFHTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZFHTXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:23 -0400
Received: from thunk.org ([69.25.196.29]:39547 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbZFHTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 45/49] ext4: Get rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle()
Date: Mon,  8 Jun 2009 15:23:03 -0400
Message-Id: <1244488987-32564-46-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-45-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
 <1244488987-32564-43-git-send-email-tytso@mit.edu>
 <1244488987-32564-44-git-send-email-tytso@mit.edu>
 <1244488987-32564-45-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Get rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle(). This
seems to be a relict from some old days and setting disksize in this
function does not make much sense.  Currently it was set only by
ext4_getblk().  Since the parameter has some effect only if create ==
1, it is easy to check by grepping through the sources that the three
callers which end up calling ext4_getblk() with create == 1
(ext4_append, ext4_quota_write, ext4_mkdir) do the right thing and set
disksize themselves.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    6 ++----
 fs/ext4/extents.c |    9 ---------
 fs/ext4/inode.c   |   20 +++-----------------
 3 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4311cc8..59657ff 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -323,15 +323,13 @@ struct ext4_new_group_data {
 #define EXT4_GET_BLOCKS_UNINIT_EXT		0x0002
 #define EXT4_GET_BLOCKS_CREATE_UNINIT_EXT	(EXT4_GET_BLOCKS_UNINIT_EXT|\
 						 EXT4_GET_BLOCKS_CREATE)
-	/* Update the ext4_inode_info i_disksize field */
-#define EXT4_GET_BLOCKS_EXTEND_DISKSIZE		0x0004
 	/* Caller is from the delayed allocation writeout path,
 	   so set the magic i_delalloc_reserve_flag after taking the 
 	   inode allocation semaphore for */
-#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0008
+#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
 	/* Call ext4_da_update_reserve_space() after successfully 
 	   allocating the blocks */
-#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0010
+#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
 
 
 /*
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d4e99e9..9c35a7b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2779,7 +2779,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
-	loff_t disksize;
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%u requested for inode %u\n",
@@ -2969,14 +2968,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
-	if (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE) {
-		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
-		if (disksize > i_size_read(inode))
-			disksize = i_size_read(inode);
-		if (disksize > EXT4_I(inode)->i_disksize)
-			EXT4_I(inode)->i_disksize = disksize;
-	}
-
 	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 14c00ff..95a3f45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1003,19 +1003,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
 					partial, indirect_blks, count);
-	/*
-	 * i_disksize growing is protected by i_data_sem.  Don't forget to
-	 * protect it if you're about to implement concurrent
-	 * ext4_get_block() -bzzz
-	*/
-	if (!err && (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE)) {
-		disksize = ((loff_t) iblock + count) << inode->i_blkbits;
-		if (disksize > i_size_read(inode))
-			disksize = i_size_read(inode);
-		if (disksize > ei->i_disksize)
-			ei->i_disksize = disksize;
-	}
-	if (err)
+	else 
 		goto cleanup;
 
 	set_buffer_new(bh_result);
@@ -1321,7 +1309,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 {
 	struct buffer_head dummy;
 	int fatal = 0, err;
-	int flags = EXT4_GET_BLOCKS_EXTEND_DISKSIZE;
+	int flags = 0;
 
 	J_ASSERT(handle != NULL || create == 0);
 
@@ -2153,9 +2141,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	}
 
 	/*
-	 * Update on-disk size along with block allocation we don't
-	 * use EXT4_GET_BLOCKS_EXTEND_DISKSIZE as size may change
-	 * within already allocated block -bzzz
+	 * Update on-disk size along with block allocation.
 	 */
 	disksize = ((loff_t) next + blks) << mpd->inode->i_blkbits;
 	if (disksize > i_size_read(mpd->inode))
-- 
1.6.3.2.1.gb9f7d.dirty

