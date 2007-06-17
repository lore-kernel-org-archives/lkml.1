Return-Path: <linux-kernel-owner+w=401wt.eu-S1761129AbXFQTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129AbXFQTKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760846AbXFQTJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36833 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760777AbXFQTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:45 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 16/16] Unionfs: Remove superfluous check for NULL pointer
Date: Sun, 17 Jun 2007 15:09:23 -0400
Message-Id: <11821073652554-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we use containers and the struct inode is _inside_ the
unionfs_inode_info structure, UNIONFS_I will always (given a non-NULL inode
pointer), return a valid non-NULL pointer.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |    8 +++++++-
 fs/unionfs/super.c  |    6 ------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index d4933ce..4da34c6 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -18,7 +18,13 @@
 #ifndef _FANOUT_H_
 #define _FANOUT_H_
 
-/* Inode to private data */
+/*
+ * Inode to private data
+ *
+ * Since we use containers and the struct inode is _inside_ the
+ * unionfs_inode_info structure, UNIONFS_I will always (given a non-NULL
+ * inode pointer), return a valid non-NULL pointer.
+ */
 static inline struct unionfs_inode_info *UNIONFS_I(const struct inode *inode)
 {
 	return container_of(inode, struct unionfs_inode_info, vfs_inode);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 9f248b9..0e6dad1 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -32,12 +32,6 @@ static void unionfs_read_inode(struct inode *inode)
 
 	unionfs_read_lock(inode->i_sb);
 
-	if (!info) {
-		printk(KERN_ERR "unionfs: no kernel memory when allocating "
-		       "inode private data!\n");
-		BUG();
-	}
-
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
-- 
1.5.2.rc1.165.gaf9b

