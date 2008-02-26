Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYBZHZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYBZHZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbYBZHZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:25:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:50701 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275AbYBZHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QLhU2jDOwqYTGjjN2m8sEvnmepZVU+1UnpqqsqONWxSzMq+78w4h9facqxh6gxOkyvmPFUJ2+lyZS8P+yCIxoMllJ8foC6AHpxj2ApaaGQ2ozJrwQgm7smb/wUt0un63LfOPj6idWPuCnMjC/uasloGn7C4N/lJVzygMA+Dv+tI=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [GFS2] remove gfs2_dev_iops
Date: Tue, 26 Feb 2008 15:25:03 +0800
Message-Id: <1204010704-11842-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct inode_operations gfs2_dev_iops is always the same as gfs2_file_iops,
since Jan 2006, when GFS2 merged into mainstream kernel.

So one of them could be removed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/inode.c     |    2 +-
 fs/gfs2/ops_inode.c |   10 ----------
 fs/gfs2/ops_inode.h |    1 -
 3 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 37725ad..1069ceb 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -149,7 +149,7 @@ void gfs2_set_iop(struct inode *inode)
 	} else if (S_ISLNK(mode)) {
 		inode->i_op = &gfs2_symlink_iops;
 	} else {
-		inode->i_op = &gfs2_dev_iops;
+		inode->i_op = &gfs2_file_iops;
 	}
 
 	unlock_new_inode(inode);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index e874129..ab9a073 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1148,16 +1148,6 @@ const struct inode_operations gfs2_file_iops = {
 	.removexattr = gfs2_removexattr,
 };
 
-const struct inode_operations gfs2_dev_iops = {
-	.permission = gfs2_permission,
-	.setattr = gfs2_setattr,
-	.getattr = gfs2_getattr,
-	.setxattr = gfs2_setxattr,
-	.getxattr = gfs2_getxattr,
-	.listxattr = gfs2_listxattr,
-	.removexattr = gfs2_removexattr,
-};
-
 const struct inode_operations gfs2_dir_iops = {
 	.create = gfs2_create,
 	.lookup = gfs2_lookup,
diff --git a/fs/gfs2/ops_inode.h b/fs/gfs2/ops_inode.h
index fd8cee2..14b4b79 100644
--- a/fs/gfs2/ops_inode.h
+++ b/fs/gfs2/ops_inode.h
@@ -15,7 +15,6 @@
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
 extern const struct inode_operations gfs2_symlink_iops;
-extern const struct inode_operations gfs2_dev_iops;
 extern const struct file_operations gfs2_file_fops;
 extern const struct file_operations gfs2_dir_fops;
 extern const struct file_operations gfs2_file_fops_nolock;
-- 
1.5.4.2

