Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYBQC70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYBQC70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYBQC5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36252 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYBQC5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:47 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 07/17] Unionfs: follow_link locking fixes
Date: Sat, 16 Feb 2008 21:57:16 -0500
Message-Id: <12032170503161-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 8d939dc..6377533 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -820,7 +820,11 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	err = 0;
 
 out:
-	unionfs_check_dentry(dentry);
+	if (!err) {
+		unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
+		unionfs_check_dentry(dentry);
+		unionfs_unlock_dentry(dentry);
+	}
 	unionfs_check_nd(nd);
 	return ERR_PTR(err);
 }
-- 
1.5.2.2

