Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYDAVIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYDAVIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbYDAVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45570 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428AbYDAVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:34 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 09/14] Unionfs: use noinline_for_stack
Date: Tue,  1 Apr 2008 17:06:51 -0400
Message-Id: <12070840201164-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    2 +-
 fs/unionfs/super.c  |   24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 7618716..7f512c2 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -32,7 +32,7 @@ static int is_validname(const char *name)
 }
 
 /* The rest of these are utility functions for lookup. */
-static noinline int is_opaque_dir(struct dentry *dentry, int bindex)
+static noinline_for_stack int is_opaque_dir(struct dentry *dentry, int bindex)
 {
 	int err = 0;
 	struct dentry *lower_dentry;
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index fba1598..2456654 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -189,9 +189,11 @@ out:
 }
 
 /* handle mode changing during remount */
-static noinline int do_remount_mode_option(char *optarg, int cur_branches,
-					   struct unionfs_data *new_data,
-					   struct path *new_lower_paths)
+static noinline_for_stack int do_remount_mode_option(
+					char *optarg,
+					int cur_branches,
+					struct unionfs_data *new_data,
+					struct path *new_lower_paths)
 {
 	int err = -EINVAL;
 	int perms, idx;
@@ -250,9 +252,10 @@ out:
 }
 
 /* handle branch deletion during remount */
-static noinline int do_remount_del_option(char *optarg, int cur_branches,
-					  struct unionfs_data *new_data,
-					  struct path *new_lower_paths)
+static noinline_for_stack int do_remount_del_option(
+					char *optarg, int cur_branches,
+					struct unionfs_data *new_data,
+					struct path *new_lower_paths)
 {
 	int err = -EINVAL;
 	int idx;
@@ -313,10 +316,11 @@ out:
 }
 
 /* handle branch insertion during remount */
-static noinline int do_remount_add_option(char *optarg, int cur_branches,
-					  struct unionfs_data *new_data,
-					  struct path *new_lower_paths,
-					  int *high_branch_id)
+static noinline_for_stack int do_remount_add_option(
+					char *optarg, int cur_branches,
+					struct unionfs_data *new_data,
+					struct path *new_lower_paths,
+					int *high_branch_id)
 {
 	int err = -EINVAL;
 	int perms;
-- 
1.5.2.2

