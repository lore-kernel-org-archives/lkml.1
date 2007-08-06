Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbXHFOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbXHFOH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbXHFNyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbXHFNya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:30 -0400
Date: Mon, 6 Aug 2007 09:54:28 -0400
Message-Id: <200708061354.l76DsSDg002295@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 08/25] ext234: have setattr functions call attr_kill_to_mode
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. and only save off ia_valid once it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/inode.c |    1 +
 fs/ext3/inode.c |    5 ++++-
 fs/ext4/inode.c |    5 ++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0079b2c..33dfc48 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1311,6 +1311,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	attr_kill_to_mode(inode, iattr);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index de4e316..5ca1085 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2919,7 +2919,10 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4848e0..9a51e44 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2935,7 +2935,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
-- 
1.5.2.2

