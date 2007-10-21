Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbXJUXw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbXJUXw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXJUXvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49186 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXJUXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:44 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 4/9] Unionfs: don't printk trivial message upon normal rename-copyup
Date: Sun, 21 Oct 2007 19:51:17 -0400
Message-Id: <11930106842213-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rename.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 91d41d4..1ab474f 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -40,10 +40,12 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				       new_dentry, new_dentry->d_name.name,
 				       bindex);
 		if (IS_ERR(lower_new_dentry)) {
-			printk(KERN_ERR "unionfs: error creating directory "
-			       "tree for rename, bindex = %d, err = %ld\n",
-			       bindex, PTR_ERR(lower_new_dentry));
 			err = PTR_ERR(lower_new_dentry);
+			if (err == -EROFS)
+				goto out;
+			printk(KERN_ERR "unionfs: error creating directory "
+			       "tree for rename, bindex=%d err=%d\n",
+			       bindex, err);
 			goto out;
 		}
 	}
-- 
1.5.2.2

