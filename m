Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZG2Tzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZG2Tzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZG2Tzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:55:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:22021 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZG2Tzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:55:52 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND 1/2] 9p: Add missing cast for the error return value in v9fs_get_inode
Date: Wed, 29 Jul 2009 13:49:01 -0600
Message-Id: <1248896942-13027-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cast the error return value (ENOMEM) in v9fs_get_inode() to its
correct type using ERR_PTR.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 fac30d2... 06a223d... M	fs/9p/vfs_inode.c
 fs/9p/vfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index fac30d2..06a223d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -215,7 +215,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 	inode = new_inode(sb);
 	if (!inode) {
 		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_mode = mode;
-- 
1.6.3.3

