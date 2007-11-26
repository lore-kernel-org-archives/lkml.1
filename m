Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXKZQuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXKZQuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbXKZQst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:48:49 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53075 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655AbXKZQsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:48:47 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 04/16] Unionfs: minor cleanup in the debugging infrastructure
Date: Mon, 26 Nov 2007 11:44:01 -0500
Message-Id: <11960954541631-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |   64 ++++++++++++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index bc221d6..c2b8b58 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -97,24 +97,22 @@ void __unionfs_check_inode(const struct inode *inode,
 					 "istart/end=%d:%d\n", inode,
 					 lower_inode, bindex, istart, iend);
 			}
-		} else {	/* lower_inode == NULL */
-			if (bindex >= istart && bindex <= iend) {
-				/*
-				 * directories can have NULL lower inodes in
-				 * b/t start/end, but NOT if at the
-				 * start/end range.
-				 */
-				if (unlikely(!(S_ISDIR(inode->i_mode) &&
-					       bindex > istart &&
-					       bindex < iend))) {
-					PRINT_CALLER(fname, fxn, line);
-					pr_debug(" Ci7: inode/linode=%p:%p "
-						 "bindex=%d istart/end=%d:%d\n",
-						 inode, lower_inode, bindex,
-						 istart, iend);
-				}
-			}
+			continue;
 		}
+		/* if we get here, then lower_inode == NULL */
+		if (bindex < istart || bindex > iend)
+			continue;
+		/*
+		 * directories can have NULL lower inodes in b/t start/end,
+		 * but NOT if at the start/end range.
+		 */
+		if (unlikely(S_ISDIR(inode->i_mode) &&
+			     bindex > istart && bindex < iend))
+			continue;
+		PRINT_CALLER(fname, fxn, line);
+		pr_debug(" Ci7: inode/linode=%p:%p "
+			 "bindex=%d istart/end=%d:%d\n",
+			 inode, lower_inode, bindex, istart, iend);
 	}
 }
 
@@ -274,24 +272,22 @@ check_inode:
 					 "istart/end=%d:%d\n", dentry,
 					 lower_inode, bindex, istart, iend);
 			}
-		} else {	/* lower_inode == NULL */
-			if (bindex >= istart && bindex <= iend) {
-				/*
-				 * directories can have NULL lower inodes in
-				 * b/t start/end, but NOT if at the
-				 * start/end range.
-				 */
-				if (unlikely(!(S_ISDIR(inode->i_mode) &&
-					       bindex > istart &&
-					       bindex < iend))) {
-					PRINT_CALLER(fname, fxn, line);
-					pr_debug(" CI7: dentry/linode=%p:%p "
-						 "bindex=%d istart/end=%d:%d\n",
-						 dentry, lower_inode, bindex,
-						 istart, iend);
-				}
-			}
+			continue;
 		}
+		/* if we get here, then lower_inode == NULL */
+		if (bindex < istart || bindex > iend)
+			continue;
+		/*
+		 * directories can have NULL lower inodes in b/t start/end,
+		 * but NOT if at the start/end range.
+		 */
+		if (unlikely(S_ISDIR(inode->i_mode) &&
+			     bindex > istart && bindex < iend))
+			continue;
+		PRINT_CALLER(fname, fxn, line);
+		pr_debug(" CI7: dentry/linode=%p:%p "
+			 "bindex=%d istart/end=%d:%d\n",
+			 dentry, lower_inode, bindex, istart, iend);
 	}
 
 	/*
-- 
1.5.2.2

