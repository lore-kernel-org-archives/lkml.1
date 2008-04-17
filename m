Return-Path: <linux-kernel-owner+w=401wt.eu-S935255AbYDQJv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255AbYDQJv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933753AbYDQJ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573AbYDQJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 37/48] [GFS2] remove gfs2_dev_iops
Date: Thu, 17 Apr 2008 09:39:13 +0100
Message-Id: <1208421645785-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216431261-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

struct inode_operations gfs2_dev_iops is always the same as gfs2_file_iops,
since Jan 2006, when GFS2 merged into mainstream kernel.

So one of them could be removed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 810ff02..7b9f31e 100644
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
index af7097a..6cbbb5b 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1149,16 +1149,6 @@ const struct inode_operations gfs2_file_iops = {
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
1.5.1.2

