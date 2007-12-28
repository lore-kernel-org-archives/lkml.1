Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbXL1UtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbXL1UtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXL1UoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:01 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37135 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXL1Unq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:46 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 09/30] Unionfs: release special files on copyup
Date: Fri, 28 Dec 2007 15:42:43 -0500
Message-Id: <11988745893190-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we copyup a special file (char, block, etc.), then dput the source
object.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 3fe4865..f48209f 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -505,13 +505,12 @@ out_unlock:
 
 out_free:
 	/*
-	 * If old_lower_dentry was a directory, we need to dput it.  If it
-	 * was a file, then it was already dput indirectly by other
+	 * If old_lower_dentry was not a file, then we need to dput it.  If
+	 * it was a file, then it was already dput indirectly by other
 	 * functions we call above which operate on regular files.
 	 */
 	if (old_lower_dentry && old_lower_dentry->d_inode &&
-	    (S_ISDIR(old_lower_dentry->d_inode->i_mode) ||
-	     S_ISLNK(old_lower_dentry->d_inode->i_mode)))
+	    !S_ISREG(old_lower_dentry->d_inode->i_mode))
 		dput(old_lower_dentry);
 	kfree(symbuf);
 
-- 
1.5.2.2

