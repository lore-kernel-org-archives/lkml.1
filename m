Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXL1Ur4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXL1Ur4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXL1UoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37138 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXL1Unr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:47 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 24/30] Unionfs: update inode times after a successful open
Date: Fri, 28 Dec 2007 15:42:58 -0500
Message-Id: <11988745963906-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 4077907..b8357a7 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -583,10 +583,13 @@ out:
 		kfree(UNIONFS_F(file));
 	}
 out_nofree:
-	unionfs_check_inode(inode);
 	if (!err) {
+		dentry = file->f_path.dentry;
+		unionfs_copy_attr_times(dentry->d_parent->d_inode);
+		unionfs_copy_attr_times(inode);
 		unionfs_check_file(file);
-		unionfs_check_dentry(file->f_path.dentry->d_parent);
+		unionfs_check_dentry(dentry->d_parent);
+		unionfs_check_inode(inode);
 	}
 	unionfs_read_unlock(inode->i_sb);
 	return err;
-- 
1.5.2.2

