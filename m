Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbXISV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbXISV0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbXISVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52805 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXISVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:03 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 4/6] Unionfs: check integrity only if validated dentry successfully
Date: Wed, 19 Sep 2007 17:24:38 -0400
Message-Id: <11902370833942-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 91f9780..9e0742d 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -418,7 +418,8 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	unionfs_lock_dentry(dentry);
 	err = __unionfs_d_revalidate_chain(dentry, nd, false);
 	unionfs_unlock_dentry(dentry);
-	unionfs_check_dentry(dentry);
+	if (err > 0) /* true==1: dentry is valid */
+		unionfs_check_dentry(dentry);
 
 	unionfs_read_unlock(dentry->d_sb);
 
-- 
1.5.2.2

