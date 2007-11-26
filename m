Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXKZQsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXKZQsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbXKZQpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:54 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52801 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbXKZQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:41 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/16] Unionfs: use f_path instead of f_dentry/mnt
Date: Mon, 26 Nov 2007 11:43:58 -0500
Message-Id: <11960954531638-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c  |    2 +-
 fs/unionfs/fanout.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 8464fbb..bc221d6 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -437,7 +437,7 @@ void __unionfs_check_nd(const struct nameidata *nd,
 	if (nd->flags & LOOKUP_OPEN) {
 		file = nd->intent.open.file;
 		if (unlikely(file->f_path.dentry &&
-			     strcmp(file->f_dentry->d_sb->s_type->name,
+			     strcmp(file->f_path.dentry->d_sb->s_type->name,
 				    UNIONFS_NAME))) {
 			PRINT_CALLER(fname, fxn, line);
 			pr_debug(" CND1: lower_file of type %s\n",
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index ec18013..864383e 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -106,7 +106,7 @@ static inline void unionfs_set_lower_file_idx(struct file *f, int index,
 	UNIONFS_F(f)->lower_files[index] = val;
 	/* save branch ID (may be redundant?) */
 	UNIONFS_F(f)->saved_branch_ids[index] =
-		branch_id((f)->f_dentry->d_sb, index);
+		branch_id((f)->f_path.dentry->d_sb, index);
 }
 
 static inline void unionfs_set_lower_file(struct file *f, struct file *val)
-- 
1.5.2.2

