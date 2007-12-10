Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXLJCt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXLJCt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXLJCni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:38 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49806 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbXLJCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:21 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Mike Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 41/42] eCryptfs: use simplified fs_stack API for inode operations
Date: Sun,  9 Dec 2007 21:42:14 -0500
Message-Id: <11972545633306-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Mike Halcrow <mhalcrow@us.ibm.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/ecryptfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0b1ab01..a846557 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -588,9 +588,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
+	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
+		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
 out_lock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
@@ -924,7 +924,7 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 	rc = notify_change(lower_dentry, ia);
 out:
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
 }
 
-- 
1.5.2.2

