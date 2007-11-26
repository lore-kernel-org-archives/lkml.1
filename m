Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbXKZQta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbXKZQta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXKZQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:48:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53021 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbXKZQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:48:27 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/16] Unionfs: minor coding standards applied
Date: Mon, 26 Nov 2007 11:44:00 -0500
Message-Id: <1196095454232-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c  |    4 ++--
 fs/unionfs/dirfops.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 98bed0b..3fe4865 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -460,8 +460,8 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 		goto out_unlink;
 
 	/* Set permissions. */
-	if ((err = copyup_permissions(sb, old_lower_dentry,
-				      new_lower_dentry)))
+	err = copyup_permissions(sb, old_lower_dentry, new_lower_dentry);
+	if (err)
 		goto out_unlink;
 
 #ifdef CONFIG_UNION_FS_XATTR
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index c644c13..5276cb3 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -77,8 +77,9 @@ static int unionfs_filldir(void *dirent, const char *name, int namelen,
 		goto out;
 	}
 	buf->entries_written++;
-	if ((err = add_filldir_node(buf->rdstate, name, namelen,
-				    buf->rdstate->bindex, is_wh_entry)))
+	err = add_filldir_node(buf->rdstate, name, namelen,
+			       buf->rdstate->bindex, is_wh_entry);
+	if (err)
 		buf->filldir_error = err;
 
 out:
-- 
1.5.2.2

