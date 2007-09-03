Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXICCZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXICCZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXICCYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:24:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57580 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXICCYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:20 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 16/32] Unionfs: minor file_release updates
Date: Sun,  2 Sep 2007 22:20:39 -0400
Message-Id: <11887860572220-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 612207a..1050c49 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -593,8 +593,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	struct unionfs_inode_info *inodeinfo;
 	struct super_block *sb = inode->i_sb;
 	int bindex, bstart, bend;
-	int fgen;
-	int err;
+	int fgen, err = 0;
 
 	unionfs_read_lock(sb);
 	/*
@@ -618,7 +617,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 
 		if (lower_file) {
 			fput(lower_file);
-			branchput(inode->i_sb, bindex);
+			branchput(sb, bindex);
 		}
 	}
 	kfree(fileinfo->lower_files);
@@ -640,6 +639,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 		fileinfo->rdstate = NULL;
 	}
 	kfree(fileinfo);
+
 out:
 	unionfs_read_unlock(sb);
 	return err;
-- 
1.5.2.2.238.g7cbf2f2

