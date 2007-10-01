Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXJAFxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXJAFxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXJAFvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:36 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40774 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXJAFv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:27 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 05/19] Unionfs: use UNIONFS_NAME macro
Date: Mon,  1 Oct 2007 01:50:42 -0400
Message-Id: <1191217858948-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |    2 +-
 fs/unionfs/main.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index b103eb9..da82a47 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -428,7 +428,7 @@ void __unionfs_check_nd(const struct nameidata *nd,
 		file = nd->intent.open.file;
 		if (unlikely(file->f_path.dentry &&
 			     strcmp(file->f_dentry->d_sb->s_type->name,
-				    "unionfs"))) {
+				    UNIONFS_NAME))) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CND1: lower_file of type %s\n",
 			       file->f_path.dentry->d_sb->s_type->name);
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 72438fb..615617a 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -227,7 +227,7 @@ void unionfs_reinterpose(struct dentry *dentry)
 int check_branch(struct nameidata *nd)
 {
 	/* XXX: remove in ODF code -- stacking unions allowed there */
-	if (!strcmp(nd->dentry->d_sb->s_type->name, "unionfs"))
+	if (!strcmp(nd->dentry->d_sb->s_type->name, UNIONFS_NAME))
 		return -EINVAL;
 	if (!nd->dentry->d_inode)
 		return -ENOENT;
@@ -722,7 +722,7 @@ static int unionfs_get_sb(struct file_system_type *fs_type,
 
 static struct file_system_type unionfs_fs_type = {
 	.owner		= THIS_MODULE,
-	.name		= "unionfs",
+	.name		= UNIONFS_NAME,
 	.get_sb		= unionfs_get_sb,
 	.kill_sb	= generic_shutdown_super,
 	.fs_flags	= FS_REVAL_DOT,
-- 
1.5.2.2

