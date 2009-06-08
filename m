Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZFHTaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZFHTaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZFHTXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:44 -0400
Received: from thunk.org ([69.25.196.29]:39590 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZFHTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 29/49] ext4: Rename ext4_get_blocks_handle() to be ext4_ind_get_blocks()
Date: Mon,  8 Jun 2009 15:22:47 -0400
Message-Id: <1244488987-32564-30-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-29-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The static function ext4_get_blocks_handle() is badly named.  Of
*course* it takes a handle.  Since its counterpart for extent-based
file is ext4_ext_get_blocks(), rename it to be ext4_ind_get_blocks().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 476d843..f758e80 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -914,7 +914,7 @@ err_out:
  * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
  * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
-static int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
+static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 				  ext4_lblk_t iblock, unsigned int maxblocks,
 				  struct buffer_head *bh_result,
 				  int create, int extend_disksize)
@@ -1129,7 +1129,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  * mapped.
  *
  * If file type is extents based, it will call ext4_ext_get_blocks(),
- * Otherwise, call with ext4_get_blocks_handle() to handle indirect mapping
+ * Otherwise, call with ext4_ind_get_blocks() to handle indirect mapping
  * based files
  *
  * On success, it returns the number of blocks being mapped or allocate.
@@ -1160,8 +1160,8 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, 0, 0);
 	} else {
-		retval = ext4_get_blocks_handle(handle,
-				inode, block, max_blocks, bh, 0, 0);
+		retval = ext4_ind_get_blocks(handle, inode, block, max_blocks,
+					     bh, 0, 0);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -1215,7 +1215,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, create, extend_disksize);
 	} else {
-		retval = ext4_get_blocks_handle(handle, inode, block,
+		retval = ext4_ind_get_blocks(handle, inode, block,
 				max_blocks, bh, create, extend_disksize);
 
 		if (retval > 0 && buffer_new(bh)) {
@@ -1297,7 +1297,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	err = ext4_get_blocks_wrap(handle, inode, block, 1,
 					&dummy, create, 1, 0);
 	/*
-	 * ext4_get_blocks_handle() returns number of blocks
+	 * ext4_get_blocks_wrap() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
 	 */
 	if (err > 0) {
-- 
1.6.3.2.1.gb9f7d.dirty

