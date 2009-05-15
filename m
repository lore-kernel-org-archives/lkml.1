Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZEOSDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZEOSDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbZEOSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:00:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2058 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZEOSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:00:06 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] fs/efs: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:44 -0700
Message-Id: <250303c6119aa17de49b1e236c4ffe955708c83a.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/efs/dir.c   |    5 ++---
 fs/efs/inode.c |   14 ++++----------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index 49308a2..a11997b 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -71,9 +71,8 @@ static int efs_readdir(struct file *filp, void *dirent, filldir_t filldir) {
 			namelen  = dirslot->namelen;
 			nameptr  = dirslot->name;
 
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
-#endif
+			pr_debug("EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
+
 			if (namelen > 0) {
 				/* found the next entry */
 				filp->f_pos = (block << EFS_DIRBSIZE_BITS) | slot;
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index a8e7797..8df5d5e 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -139,10 +139,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 
 	brelse(bh);
    
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
-		inode->i_ino, in->numextents, inode->i_mode);
-#endif
+	pr_debug("EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
+		 inode->i_ino, in->numextents, inode->i_mode);
 
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
@@ -239,9 +237,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		return 0;
 	}
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: map_block(): indirect search for logical block %u\n", block);
-#endif
+	pr_debug("EFS: map_block(): indirect search for logical block %u\n", block);
 	direxts = in->extents[0].cooked.ex_offset;
 	indexts = in->numextents;
 
@@ -283,9 +279,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 				printk(KERN_ERR "EFS: bread() failed at block %d\n", iblock);
 				return 0;
 			}
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: map_block(): read indirect extent block %d\n", iblock);
-#endif
+			pr_debug("EFS: map_block(): read indirect extent block %d\n", iblock);
 			first = 0;
 			lastblock = iblock;
 		}
-- 
1.6.3.1.9.g95405b.dirty

