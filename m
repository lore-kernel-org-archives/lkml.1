Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbXL1UrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbXL1UrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXL1UoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37146 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXL1Unt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:49 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 25/30] Unionfs: minor cleanup in check_empty
Date: Fri, 28 Dec 2007 15:42:59 -0500
Message-Id: <11988745971468-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dirhelper.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index b40090a..4b73bb6 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -182,6 +182,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *mnt;
 	struct super_block *sb;
 	struct file *lower_file;
 	struct unionfs_rdutil_callback *buf = NULL;
@@ -226,15 +227,11 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 			continue;
 
 		dget(lower_dentry);
-		unionfs_mntget(dentry, bindex);
+		mnt = unionfs_mntget(dentry, bindex);
 		branchget(sb, bindex);
-		lower_file =
-			dentry_open(lower_dentry,
-				    unionfs_lower_mnt_idx(dentry, bindex),
-				    O_RDONLY);
+		lower_file = dentry_open(lower_dentry, mnt, O_RDONLY);
 		if (IS_ERR(lower_file)) {
 			err = PTR_ERR(lower_file);
-			dput(lower_dentry);
 			branchput(sb, bindex);
 			goto out;
 		}
-- 
1.5.2.2

