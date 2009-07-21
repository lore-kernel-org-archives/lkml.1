Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZGUGEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZGUGEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZGUGEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:45 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:53871 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZGUGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:36 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Check for error in return value of v9fs_fid_add
Date: Tue, 21 Jul 2009 00:03:56 -0600
Message-Id: <1248156236-3005-7-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if v9fs_fid_add was successful or not based on its
return value.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 4a947f9... fac30d2... M	fs/9p/vfs_inode.c
 fs/9p/vfs_inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 4a947f9..fac30d2 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -471,7 +471,10 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		dentry->d_op = &v9fs_dentry_operations;
 
 	d_instantiate(dentry, inode);
-	v9fs_fid_add(dentry, fid);
+	err = v9fs_fid_add(dentry, fid);
+	if (err < 0)
+		goto error;
+
 	return ofid;
 
 error:
-- 
1.6.0.4

