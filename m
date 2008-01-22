Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYAVDGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYAVDGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbYAVDDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:03:32 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64887 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbYAVDDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:03:30 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 04/49] ext4 extents: remove unneeded casts
Date: Mon, 21 Jan 2008 22:01:43 -0500
Message-Id: <1200970948-17903-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-4-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

There are many casts in extents.c which are not needed,
as the variables are already the type of the cast, or
are being promoted for no particular reason in printk's.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |   49 ++++++++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 19d8059..6853722 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -374,7 +374,7 @@ ext4_ext_binsearch_idx(struct inode *inode,
 	struct ext4_extent_idx *r, *l, *m;
 
 
-	ext_debug("binsearch for %lu(idx):  ", (unsigned long)block);
+	ext_debug("binsearch for %u(idx):  ", block);
 
 	l = EXT_FIRST_INDEX(eh) + 1;
 	r = EXT_LAST_INDEX(eh);
@@ -440,7 +440,7 @@ ext4_ext_binsearch(struct inode *inode,
 		return;
 	}
 
-	ext_debug("binsearch for %lu:  ", (unsigned long)block);
+	ext_debug("binsearch for %u:  ", block);
 
 	l = EXT_FIRST_EXTENT(eh) + 1;
 	r = EXT_LAST_EXTENT(eh);
@@ -766,7 +766,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	while (k--) {
 		oldblock = newblock;
 		newblock = ablocks[--a];
-		bh = sb_getblk(inode->i_sb, (ext4_fsblk_t)newblock);
+		bh = sb_getblk(inode->i_sb, newblock);
 		if (!bh) {
 			err = -EIO;
 			goto cleanup;
@@ -786,9 +786,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		fidx->ei_block = border;
 		ext4_idx_store_pblock(fidx, oldblock);
 
-		ext_debug("int.index at %d (block %llu): %lu -> %llu\n", i,
-				newblock, (unsigned long) le32_to_cpu(border),
-				oldblock);
+		ext_debug("int.index at %d (block %llu): %u -> %llu\n",
+				i, newblock, le32_to_cpu(border), oldblock);
 		/* copy indexes */
 		m = 0;
 		path[i].p_idx++;
@@ -1476,10 +1475,10 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 	} else if (block < le32_to_cpu(ex->ee_block)) {
 		lblock = block;
 		len = le32_to_cpu(ex->ee_block) - block;
-		ext_debug("cache gap(before): %lu [%lu:%lu]",
-				(unsigned long) block,
-				(unsigned long) le32_to_cpu(ex->ee_block),
-				(unsigned long) ext4_ext_get_actual_len(ex));
+		ext_debug("cache gap(before): %u [%u:%u]",
+				block,
+				le32_to_cpu(ex->ee_block),
+				 ext4_ext_get_actual_len(ex));
 	} else if (block >= le32_to_cpu(ex->ee_block)
 			+ ext4_ext_get_actual_len(ex)) {
 		ext4_lblk_t next;
@@ -1487,10 +1486,10 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 			+ ext4_ext_get_actual_len(ex);
 
 		next = ext4_ext_next_allocated_block(path);
-		ext_debug("cache gap(after): [%lu:%lu] %lu",
-				(unsigned long) le32_to_cpu(ex->ee_block),
-				(unsigned long) ext4_ext_get_actual_len(ex),
-				(unsigned long) block);
+		ext_debug("cache gap(after): [%u:%u] %u",
+				le32_to_cpu(ex->ee_block),
+				ext4_ext_get_actual_len(ex),
+				block);
 		BUG_ON(next == lblock);
 		len = next - lblock;
 	} else {
@@ -1498,7 +1497,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 		BUG();
 	}
 
-	ext_debug(" -> %lu:%lu\n", (unsigned long) lblock, len);
+	ext_debug(" -> %u:%lu\n", lblock, len);
 	ext4_ext_put_in_cache(inode, lblock, len, 0, EXT4_EXT_CACHE_GAP);
 }
 
@@ -1520,11 +1519,9 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 		ex->ee_block = cpu_to_le32(cex->ec_block);
 		ext4_ext_store_pblock(ex, cex->ec_start);
 		ex->ee_len = cpu_to_le16(cex->ec_len);
-		ext_debug("%lu cached by %lu:%lu:%llu\n",
-				(unsigned long) block,
-				(unsigned long) cex->ec_block,
-				(unsigned long) cex->ec_len,
-				cex->ec_start);
+		ext_debug("%u cached by %u:%u:%llu\n",
+				block,
+				cex->ec_block, cex->ec_len, cex->ec_start);
 		return cex->ec_type;
 	}
 
@@ -2145,9 +2142,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	unsigned long allocated = 0;
 
 	__clear_bit(BH_New, &bh_result->b_state);
-	ext_debug("blocks %lu/%lu requested for inode %u\n",
-			(unsigned long) iblock, max_blocks,
-			(unsigned) inode->i_ino);
+	ext_debug("blocks %u/%lu requested for inode %u\n",
+			iblock, max_blocks, inode->i_ino);
 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 
 	/* check in cache */
@@ -2210,7 +2206,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			newblock = iblock - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (iblock - ee_block);
-			ext_debug("%d fit into %lu:%d -> %llu\n", (int) iblock,
+			ext_debug("%u fit into %lu:%d -> %llu\n", iblock,
 					ee_block, ee_len, newblock);
 
 			/* Do not put uninitialized extent in the cache */
@@ -2470,9 +2466,8 @@ retry:
 		if (!ret) {
 			ext4_error(inode->i_sb, "ext4_fallocate",
 				   "ext4_ext_get_blocks returned 0! inode#%lu"
-				   ", block=%lu, max_blocks=%lu",
-				   inode->i_ino, (unsigned long)block,
-				   (unsigned long)max_blocks);
+				   ", block=%u, max_blocks=%lu",
+				   inode->i_ino, block, max_blocks);
 			ret = -EIO;
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
-- 
1.5.4.rc3.31.g1271-dirty

