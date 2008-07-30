Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYG3Coh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYG3Coh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYG3CoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46240 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYG3CoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:16 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 14/19] Unionfs: minor checkpatch fixes
Date: Tue, 29 Jul 2008 22:43:44 -0400
Message-Id: <12173858413675-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c  |   12 ------------
 fs/unionfs/super.c |    4 ++--
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 6484e2b..0cdd50b 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -459,8 +459,6 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 
 	while ((optname = strsep(&options, ",")) != NULL) {
 		char *optarg;
-		char *endptr;
-		int intval;
 
 		if (!optname || !*optname)
 			continue;
@@ -493,16 +491,6 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 			continue;
 		}
 
-		/* All of these options require an integer argument. */
-		intval = simple_strtoul(optarg, &endptr, 0);
-		if (*endptr) {
-			printk(KERN_ERR
-			       "unionfs: invalid %s option '%s'\n",
-			       optname, optarg);
-			err = -EINVAL;
-			goto out_error;
-		}
-
 		err = -EINVAL;
 		printk(KERN_ERR
 		       "unionfs: unrecognized option '%s'\n", optname);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index f163c08..1f4b3f4 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -33,8 +33,8 @@ struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
- 	if (!(inode->i_state & I_NEW))
- 		return inode;
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
-- 
1.5.2.2

