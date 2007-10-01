Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbXJAF4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbXJAF4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXJAFwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:52:10 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40807 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXJAFvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:37 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/19] Unionfs: remove periods from the end of printk strings
Date: Mon,  1 Oct 2007 01:50:50 -0400
Message-Id: <1191217861181-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    2 +-
 fs/unionfs/main.c   |    2 +-
 fs/unionfs/rename.c |    4 ++--
 fs/unionfs/super.c  |   10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 981c0d9..929f15b 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -215,7 +215,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 			}
 			err = -EIO;
 			printk(KERN_ERR "unionfs: EIO: invalid whiteout "
-			       "entry type %d.\n",
+			       "entry type %d\n",
 			       wh_lower_dentry->d_inode->i_mode);
 			dput(wh_lower_dentry);
 			dput(first_lower_dentry);
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 25d1461..25ac851 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -485,7 +485,7 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 		 * don't, above this check.
 		 */
 		if (!optarg) {
-			printk(KERN_ERR "unionfs: %s requires an argument.\n",
+			printk(KERN_ERR "unionfs: %s requires an argument\n",
 			       optname);
 			err = -EINVAL;
 			goto out_error;
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index c90405d..81121f0 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -294,14 +294,14 @@ revert:
 	local_err = unionfs_refresh_lower_dentry(new_dentry, old_bstart);
 	if (local_err) {
 		printk(KERN_ERR "unionfs: revert failed in rename: "
-		       "the new refresh failed.\n");
+		       "the new refresh failed\n");
 		eio = -EIO;
 	}
 
 	local_err = unionfs_refresh_lower_dentry(old_dentry, old_bstart);
 	if (local_err) {
 		printk(KERN_ERR "unionfs: revert failed in rename: "
-		       "the old refresh failed.\n");
+		       "the old refresh failed\n");
 		eio = -EIO;
 		goto revert_out;
 	}
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 798def9..647b08c 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -173,18 +173,18 @@ static noinline int do_remount_mode_option(char *optarg, int cur_branches,
 	/* by now, optarg contains the branch name */
 	if (!*optarg) {
 		printk(KERN_ERR
-		       "unionfs: no branch specified for mode change.\n");
+		       "unionfs: no branch specified for mode change\n");
 		goto out;
 	}
 	if (!modename) {
-		printk(KERN_ERR "unionfs: branch \"%s\" requires a mode.\n",
+		printk(KERN_ERR "unionfs: branch \"%s\" requires a mode\n",
 		       optarg);
 		goto out;
 	}
 	*modename++ = '\0';
 	perms = __parse_branch_mode(modename);
 	if (perms == 0) {
-		printk(KERN_ERR "unionfs: invalid mode \"%s\" for \"%s\".\n",
+		printk(KERN_ERR "unionfs: invalid mode \"%s\" for \"%s\"\n",
 		       modename, optarg);
 		goto out;
 	}
@@ -584,7 +584,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 		 */
 		if (!optarg || !*optarg) {
 			printk(KERN_ERR "unionfs: all remount options require "
-			       "an argument (%s).\n", optname);
+			       "an argument (%s)\n", optname);
 			err = -EINVAL;
 			goto out_release;
 		}
@@ -634,7 +634,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 		 */
 		if (!strcmp("dirs", optname)) {
 			printk(KERN_WARNING
-			       "unionfs: remount ignoring option \"%s\".\n",
+			       "unionfs: remount ignoring option \"%s\"\n",
 			       optname);
 			continue;
 		}
-- 
1.5.2.2

