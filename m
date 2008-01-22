Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYAVDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYAVDIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbYAVDFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:25 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65333 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337AbYAVDFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:21 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 45/49] ext4: Use the ext4_ext_actual_len() helper function
Date: Mon, 21 Jan 2008 22:02:24 -0500
Message-Id: <1200970948-17903-46-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-45-git-send-email-tytso@mit.edu>
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
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
 <1200970948-17903-43-git-send-email-tytso@mit.edu>
 <1200970948-17903-44-git-send-email-tytso@mit.edu>
 <1200970948-17903-45-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

ext4 uses the high bit of the extent length to encode whether the extent
is intialized or not. The helper function ext4_ext_get_actual_len should
be used to get the actual length of the extent.

This addresses the kernel bug documented here:
     http://bugzilla.kernel.org/show_bug.cgi?id=9732

kernel BUG at fs/ext4/extents.c:1056!
....
Call Trace:
[<ffffffff88366073>] :ext4dev:ext4_ext_get_blocks+0x5ba/0x8c1
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff812748f6>] _spin_unlock+0x17/0x20
[<ffffffff883400a6>] :jbd2:start_this_handle+0x4e0/0x4fe
[<ffffffff88366564>] :ext4dev:ext4_fallocate+0x175/0x39a
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff81056480>] __lock_acquire+0x4e7/0xc4d
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff810a8de7>] sys_fallocate+0xe4/0x10d
[<ffffffff8100c043>] tracesys+0xd5/0xda

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 13e3e8c..b6b9ec7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1029,7 +1029,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 {
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
-	int depth;
+	int depth, ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1043,6 +1043,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
+	ee_len = ext4_ext_get_actual_len(ex);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
 		while (--depth >= 0) {
@@ -1052,10 +1053,10 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
-	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
-	*logical = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1;
-	*phys = ext_pblock(ex) + le16_to_cpu(ex->ee_len) - 1;
+	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
+	*phys = ext_pblock(ex) + ee_len - 1;
 	return 0;
 }
 
@@ -1075,7 +1076,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth;
+	int depth, ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1089,6 +1090,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
+	ee_len = ext4_ext_get_actual_len(ex);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
 		while (--depth >= 0) {
@@ -1100,7 +1102,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
-	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
 	if (ex != EXT_LAST_EXTENT(path[depth].p_hdr)) {
 		/* next allocated block in this leaf */
@@ -1316,7 +1318,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	if (ext1_ee_len + ext2_ee_len > max_len)
 		return 0;
 #ifdef AGGRESSIVE_TEST
-	if (le16_to_cpu(ex1->ee_len) >= 4)
+	if (ext1_ee_len >= 4)
 		return 0;
 #endif
 
@@ -2313,7 +2315,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				   - le32_to_cpu(newex.ee_block)
 				   + ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
-			allocated = le16_to_cpu(newex.ee_len) -
+			allocated = ext4_ext_get_actual_len(&newex) -
 					(iblock - le32_to_cpu(newex.ee_block));
 			goto out;
 		} else {
@@ -2429,7 +2431,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newex.ee_len = cpu_to_le16(max_blocks);
 	err = ext4_ext_check_overlap(inode, &newex, path);
 	if (err)
-		allocated = le16_to_cpu(newex.ee_len);
+		allocated = ext4_ext_get_actual_len(&newex);
 	else
 		allocated = max_blocks;
 
@@ -2461,7 +2463,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		 * but otherwise we'd need to call it every free() */
 		ext4_mb_discard_inode_preallocations(inode);
 		ext4_free_blocks(handle, inode, ext_pblock(&newex),
-					le16_to_cpu(newex.ee_len), 0);
+					ext4_ext_get_actual_len(&newex), 0);
 		goto out2;
 	}
 
@@ -2470,7 +2472,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
-	allocated = le16_to_cpu(newex.ee_len);
+	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
-- 
1.5.4.rc3.31.g1271-dirty

