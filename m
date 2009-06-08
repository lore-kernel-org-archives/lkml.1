Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZFHTag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZFHTag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZFHTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:45 -0400
Received: from thunk.org ([69.25.196.29]:39595 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbZFHTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 30/49] ext4: Rename ext4_get_blocks_wrap() to be ext4_get_blocks()
Date: Mon,  8 Jun 2009 15:22:48 -0400
Message-Id: <1244488987-32564-31-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-30-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another function rename for clarity's sake.  The _wrap prefix simply
confuses people, and didn't add much people trying to follow the code
paths.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/dir.c     |    3 +--
 fs/ext4/ext4.h    |    8 ++++----
 fs/ext4/extents.c |    6 +++---
 fs/ext4/inode.c   |   35 +++++++++++++++++------------------
 4 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b647899..052d637 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -131,8 +131,7 @@ static int ext4_readdir(struct file *filp,
 		struct buffer_head *bh = NULL;
 
 		map_bh.b_state = 0;
-		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh,
-						0, 0, 0);
+		err = ext4_get_blocks(NULL, inode, blk, 1, &map_bh, 0, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 89190ae..5dc8368 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1617,10 +1617,10 @@ extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
-extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
-			sector_t block, unsigned int max_blocks,
-			struct buffer_head *bh, int create,
-			int extend_disksize, int flag);
+extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
+			   sector_t block, unsigned int max_blocks,
+			   struct buffer_head *bh, int create,
+			   int extend_disksize, int flag);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4fec6b7..7e7d02d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3151,9 +3151,9 @@ retry:
 			break;
 		}
 		map_bh.b_state = 0;
-		ret = ext4_get_blocks_wrap(handle, inode, block,
-					  max_blocks, &map_bh,
-					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
+		ret = ext4_get_blocks(handle, inode, block,
+				      max_blocks, &map_bh,
+				      EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f758e80..a9a9b9b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1121,7 +1121,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 }
 
 /*
- * The ext4_get_blocks_wrap() function try to look up the requested blocks,
+ * The ext4_get_blocks() function tries to look up the requested blocks,
  * and returns if the blocks are already mapped.
  *
  * Otherwise it takes the write lock of the i_data_sem and allocate blocks
@@ -1142,9 +1142,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  *
  * It returns the error in case of allocation failure.
  */
-int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
-			unsigned int max_blocks, struct buffer_head *bh,
-			int create, int extend_disksize, int flag)
+int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
+		    unsigned int max_blocks, struct buffer_head *bh,
+		    int create, int extend_disksize, int flag)
 {
 	int retval;
 
@@ -1268,8 +1268,8 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
 		started = 1;
 	}
 
-	ret = ext4_get_blocks_wrap(handle, inode, iblock,
-					max_blocks, bh_result, create, 0, 0);
+	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
+			      create, 0, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -1294,10 +1294,9 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
-	err = ext4_get_blocks_wrap(handle, inode, block, 1,
-					&dummy, create, 1, 0);
+	err = ext4_get_blocks(handle, inode, block, 1, &dummy, create, 1, 0);
 	/*
-	 * ext4_get_blocks_wrap() returns number of blocks
+	 * ext4_get_blocks() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
 	 */
 	if (err > 0) {
@@ -2009,8 +2008,8 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 
 	handle = ext4_journal_current_handle();
 	BUG_ON(!handle);
-	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, 1, 0, EXT4_DELALLOC_RSVED);
+	ret = ext4_get_blocks(handle, inode, iblock, max_blocks,
+			      bh_result, 1, 0, EXT4_DELALLOC_RSVED);
 	if (ret <= 0)
 		return ret;
 
@@ -2067,11 +2066,11 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	/*
 	 * We need to make sure the BH_Delay flag is passed down to
 	 * ext4_da_get_block_write(), since it calls
-	 * ext4_get_blocks_wrap() with the EXT4_DELALLOC_RSVED flag.
-	 * This flag causes ext4_get_blocks_wrap() to call
+	 * ext4_get_blocks() with the EXT4_DELALLOC_RSVED flag.
+	 * This flag causes ext4_get_blocks() to call
 	 * ext4_da_update_reserve_space() if the passed buffer head
 	 * has the BH_Delay flag set.  In the future, once we clean up
-	 * the interfaces to ext4_get_blocks_wrap(), we should pass in
+	 * the interfaces to ext4_get_blocks(), we should pass in
 	 * a separate flag which requests that the delayed allocation
 	 * statistics should be updated, instead of depending on the
 	 * state information getting passed down via the map_bh's
@@ -2363,7 +2362,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	 * preallocated blocks are unmapped but should treated
 	 * the same as allocated blocks.
 	 */
-	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0, 0);
+	ret = ext4_get_blocks(NULL, inode, iblock, 1,  bh_result, 0, 0, 0);
 	if ((ret == 0) && !buffer_delay(bh_result)) {
 		/* the block isn't (pre)allocated yet, let's reserve space */
 		/*
@@ -2407,8 +2406,8 @@ static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
 	 * we don't want to do block allocation in writepage
 	 * so call get_block_wrap with create = 0
 	 */
-	ret = ext4_get_blocks_wrap(NULL, inode, iblock, max_blocks,
-				   bh_result, 0, 0, 0);
+	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks,
+			      bh_result, 0, 0, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -5034,7 +5033,7 @@ int ext4_writepage_trans_blocks(struct inode *inode)
  * Calculate the journal credits for a chunk of data modification.
  *
  * This is called from DIO, fallocate or whoever calling
- * ext4_get_blocks_wrap() to map/allocate a chunk of contigous disk blocks.
+ * ext4_get_blocks() to map/allocate a chunk of contigous disk blocks.
  *
  * journal buffers for data blocks are not included here, as DIO
  * and fallocate do no need to journal data buffers.
-- 
1.6.3.2.1.gb9f7d.dirty

