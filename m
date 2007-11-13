Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXKMKMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXKMKMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXKMKLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:11:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50694 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXKMKKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:53 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 6/9] Unionfs: debugging updates
Date: Tue, 13 Nov 2007 05:10:25 -0500
Message-Id: <11949486303151-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't perform dentry+inode checks unless both are valid.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 0066ccd..8464fbb 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -299,7 +299,7 @@ check_inode:
 	 * be NULL.  But, check that all three are NULL: lower dentry, mnt,
 	 * and inode.
 	 */
-	if (S_ISDIR(inode->i_mode))
+	if (dstart >= 0 && dend >= 0 && S_ISDIR(inode->i_mode))
 		for (bindex = dstart+1; bindex < dend; bindex++) {
 			lower_inode = unionfs_lower_inode_idx(inode, bindex);
 			lower_dentry = unionfs_lower_dentry_idx(dentry,
-- 
1.5.2.2

