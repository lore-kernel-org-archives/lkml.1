Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbXHFNUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbXHFNUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764994AbXHFNSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:18:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764518AbXHFNSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:02 -0400
Message-Id: <200708061317.l76DHvQr001694@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 25 Jul 2007 09:18:06 -0400
Subject: [PATCH 07/25] configfs: call attr_kill_to_mode from configfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: joel.becker@oracle.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only set ia_valid just before it's actually used

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/configfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index ddc003a..a67f36b 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -59,7 +59,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	struct inode * inode = dentry->d_inode;
 	struct configfs_dirent * sd = dentry->d_fsdata;
 	struct iattr * sd_iattr;
-	unsigned int ia_valid = iattr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
 	if (!sd)
@@ -67,6 +67,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	sd_iattr = sd->s_iattr;
 
+	attr_kill_to_mode(inode, iattr);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
@@ -90,6 +91,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	/* attributes were changed atleast once in past */
 
+	ia_valid = iattr->ia_valid;
 	if (ia_valid & ATTR_UID)
 		sd_iattr->ia_uid = iattr->ia_uid;
 	if (ia_valid & ATTR_GID)
-- 
1.5.2.2

