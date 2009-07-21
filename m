Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZGUGEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZGUGEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZGUGEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62225 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZGUGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:28 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Remove redundant inode uid/gid assignment
Date: Tue, 21 Jul 2009 00:03:50 -0600
Message-Id: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a redundant update of inode's i_uid and i_gid
after v9fs_get_inode() since the latter already sets up
a new inode and sets the proper uid and gid values.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 38d695d... b5295fd... M	fs/9p/vfs_super.c
 fs/9p/vfs_super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 38d695d..b5295fd 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -113,8 +113,6 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct v9fs_session_info *v9ses = NULL;
 	struct p9_wstat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current_fsuid();
-	gid_t gid = current_fsgid();
 	struct p9_fid *fid;
 	int retval = 0;
 
@@ -150,9 +148,6 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 		goto release_sb;
 	}
 
-	inode->i_uid = uid;
-	inode->i_gid = gid;
-
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
-- 
1.6.0.4

