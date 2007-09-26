Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbXIZSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbXIZSLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbXIZSLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:11:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:55794 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXIZSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=lxs7rDX9/QhNLjIcr1sVmqHJ1opBCrv6QdlJa2k8CToIhc2tZ42O10dLQ4SACVpzYLEHdJLU+K+R+QWWziwKd9MW0LecjFAJ43Df7TEDCv3OPflaWBBYb5dscGzyXjBUQextp7jpZrRBA/tjUdIM2oLbFKEHV0tnhgIpSXN79a8=
From: Denis Cheng <crquan@gmail.com>
To: Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] fs/ocfs2/: removed unneeded initial value and function's return value
Date: Thu, 27 Sep 2007 02:10:04 +0800
Message-Id: <1190830204-7252-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/ocfs2/super.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c034b51..b98ec12 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -105,7 +105,7 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait);
 
 static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb);
 static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb);
-static int ocfs2_release_system_inodes(struct ocfs2_super *osb);
+static void ocfs2_release_system_inodes(struct ocfs2_super *osb);
 static int ocfs2_fill_local_node_info(struct ocfs2_super *osb);
 static int ocfs2_check_volume(struct ocfs2_super *osb);
 static int ocfs2_verify_volume(struct ocfs2_dinode *di,
@@ -177,7 +177,7 @@ static void ocfs2_write_super(struct super_block *sb)
 
 static int ocfs2_sync_fs(struct super_block *sb, int wait)
 {
-	int status = 0;
+	int status;
 	tid_t target;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
@@ -275,9 +275,9 @@ bail:
 	return status;
 }
 
-static int ocfs2_release_system_inodes(struct ocfs2_super *osb)
+static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 {
-	int status = 0, i;
+	int i;
 	struct inode *inode;
 
 	mlog_entry_void();
@@ -302,8 +302,7 @@ static int ocfs2_release_system_inodes(struct ocfs2_super *osb)
 		osb->root_inode = NULL;
 	}
 
-	mlog_exit(status);
-	return status;
+	mlog_exit(0);
 }
 
 /* We're allocating fs objects, use GFP_NOFS */
@@ -453,7 +452,7 @@ static int ocfs2_sb_probe(struct super_block *sb,
 			  struct buffer_head **bh,
 			  int *sector_size)
 {
-	int status = 0, tmpstat;
+	int status, tmpstat;
 	struct ocfs1_vol_disk_hdr *hdr;
 	struct ocfs2_dinode *di;
 	int blksize;
@@ -1275,7 +1274,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
 				  int sector_size)
 {
-	int status = 0;
+	int status;
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
@@ -1596,7 +1595,7 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 
 static int ocfs2_check_volume(struct ocfs2_super *osb)
 {
-	int status = 0;
+	int status;
 	int dirty;
 	int local;
 	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
-- 
1.5.3.2

