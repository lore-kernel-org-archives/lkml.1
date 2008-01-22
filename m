Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYAVDDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYAVDDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYAVDC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:02:56 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64666 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbYAVDCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:02:53 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Alex Tomas <alex@clusterfs.com>, Andreas Dilger <adilger@clusterfs.com>,
       Johann Lombardi <johann@clusterfs.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 40/49] ext4: Add new functions for searching extent tree
Date: Mon, 21 Jan 2008 22:02:19 -0500
Message-Id: <1200970948-17903-41-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-40-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Tomas <alex@clusterfs.com>

Add the functions ext4_ext_search_left() and ext4_ext_search_right(),
which are used by mballoc during ext4_ext_get_blocks to decided whether
to merge extent information.

Signed-off-by: Alex Tomas <alex@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Johann Lombardi <johann@clusterfs.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c               |  142 +++++++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs_extents.h |    4 +
 2 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 03d1bbb..a60227c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1017,6 +1017,148 @@ out:
 }
 
 /*
+ * search the closest allocated block to the left for *logical
+ * and returns it at @logical + it's physical address at @phys
+ * if *logical is the smallest allocated block, the function
+ * returns 0 at @phys
+ * return value contains 0 (success) or error code
+ */
+int
+ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
+			ext4_lblk_t *logical, ext4_fsblk_t *phys)
+{
+	struct ext4_extent_idx *ix;
+	struct ext4_extent *ex;
+	int depth;
+
+	BUG_ON(path == NULL);
+	depth = path->p_depth;
+	*phys = 0;
+
+	if (depth == 0 && path->p_ext == NULL)
+		return 0;
+
+	/* usually extent in the path covers blocks smaller
+	 * then *logical, but it can be that extent is the
+	 * first one in the file */
+
+	ex = path[depth].p_ext;
+	if (*logical < le32_to_cpu(ex->ee_block)) {
+		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
+		while (--depth >= 0) {
+			ix = path[depth].p_idx;
+			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
+		}
+		return 0;
+	}
+
+	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+
+	*logical = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1;
+	*phys = ext_pblock(ex) + le16_to_cpu(ex->ee_len) - 1;
+	return 0;
+}
+
+/*
+ * search the closest allocated block to the right for *logical
+ * and returns it at @logical + it's physical address at @phys
+ * if *logical is the smallest allocated block, the function
+ * returns 0 at @phys
+ * return value contains 0 (success) or error code
+ */
+int
+ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
+			ext4_lblk_t *logical, ext4_fsblk_t *phys)
+{
+	struct buffer_head *bh = NULL;
+	struct ext4_extent_header *eh;
+	struct ext4_extent_idx *ix;
+	struct ext4_extent *ex;
+	ext4_fsblk_t block;
+	int depth;
+
+	BUG_ON(path == NULL);
+	depth = path->p_depth;
+	*phys = 0;
+
+	if (depth == 0 && path->p_ext == NULL)
+		return 0;
+
+	/* usually extent in the path covers blocks smaller
+	 * then *logical, but it can be that extent is the
+	 * first one in the file */
+
+	ex = path[depth].p_ext;
+	if (*logical < le32_to_cpu(ex->ee_block)) {
+		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
+		while (--depth >= 0) {
+			ix = path[depth].p_idx;
+			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
+		}
+		*logical = le32_to_cpu(ex->ee_block);
+		*phys = ext_pblock(ex);
+		return 0;
+	}
+
+	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+
+	if (ex != EXT_LAST_EXTENT(path[depth].p_hdr)) {
+		/* next allocated block in this leaf */
+		ex++;
+		*logical = le32_to_cpu(ex->ee_block);
+		*phys = ext_pblock(ex);
+		return 0;
+	}
+
+	/* go up and search for index to the right */
+	while (--depth >= 0) {
+		ix = path[depth].p_idx;
+		if (ix != EXT_LAST_INDEX(path[depth].p_hdr))
+			break;
+	}
+
+	if (depth < 0) {
+		/* we've gone up to the root and
+		 * found no index to the right */
+		return 0;
+	}
+
+	/* we've found index to the right, let's
+	 * follow it and find the closest allocated
+	 * block to the right */
+	ix++;
+	block = idx_pblock(ix);
+	while (++depth < path->p_depth) {
+		bh = sb_bread(inode->i_sb, block);
+		if (bh == NULL)
+			return -EIO;
+		eh = ext_block_hdr(bh);
+		if (ext4_ext_check_header(inode, eh, depth)) {
+			brelse(bh);
+			return -EIO;
+		}
+		ix = EXT_FIRST_INDEX(eh);
+		block = idx_pblock(ix);
+		brelse(bh);
+	}
+
+	bh = sb_bread(inode->i_sb, block);
+	if (bh == NULL)
+		return -EIO;
+	eh = ext_block_hdr(bh);
+	if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
+		brelse(bh);
+		return -EIO;
+	}
+	ex = EXT_FIRST_EXTENT(eh);
+	*logical = le32_to_cpu(ex->ee_block);
+	*phys = ext_pblock(ex);
+	brelse(bh);
+	return 0;
+
+}
+
+/*
  * ext4_ext_next_allocated_block:
  * returns allocated block in subsequent extent or EXT_MAX_BLOCK.
  * NOTE: it considers block number from index entry as
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 023683b..56d0ec6 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -221,5 +221,9 @@ extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *,
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
+extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
+						ext4_lblk_t *, ext4_fsblk_t *);
+extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
+						ext4_lblk_t *, ext4_fsblk_t *);
 #endif /* _LINUX_EXT4_EXTENTS */
 
-- 
1.5.4.rc3.31.g1271-dirty

