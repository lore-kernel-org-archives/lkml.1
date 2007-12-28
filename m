Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXL1Ux1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXL1Ux1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXL1Uon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37212 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbXL1UoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:44:25 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 18/30] Unionfs: remove unnecessary parent lock in create
Date: Fri, 28 Dec 2007 15:42:52 -0500
Message-Id: <1198874593510-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 7ec9c1b..3df9b19 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -32,13 +32,6 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	unionfs_lock_dentry(dentry->d_parent);
-	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd, false);
-	unionfs_unlock_dentry(dentry->d_parent);
-	if (unlikely(!valid)) {
-		err = -ESTALE;	/* same as what real_lookup does */
-		goto out;
-	}
 	valid = __unionfs_d_revalidate_chain(dentry, nd, false);
 	/*
 	 * It's only a bug if this dentry was not negative and couldn't be
-- 
1.5.2.2

