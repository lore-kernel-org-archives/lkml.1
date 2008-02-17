Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYBQDCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYBQDCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYBQC6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36364 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbYBQC6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:30 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/17] Unionfs: use dget_parent in revalidation code
Date: Sat, 16 Feb 2008 21:57:22 -0500
Message-Id: <12032170522320-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index a956b94..f8f65e1 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -410,15 +410,10 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 		goto out;
 	}
 
-	/*
-	 * lock all dentries in chain, in child to parent order.
-	 * if failed, then sleep for a little, then retry.
-	 */
-	dtmp = dentry->d_parent;
-	for (i = chain_len-1; i >= 0; i--) {
-		chain[i] = dget(dtmp);
-		dtmp = dtmp->d_parent;
-	}
+	/* grab all dentries in chain, in child to parent order */
+	dtmp = dentry;
+	for (i = chain_len-1; i >= 0; i--)
+		dtmp = chain[i] = dget_parent(dtmp);
 
 	/*
 	 * call __unionfs_d_revalidate_one() on each dentry, but in parent
-- 
1.5.2.2

