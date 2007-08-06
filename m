Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbXHFOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbXHFOER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933167AbXHFNz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765226AbXHFNzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:12 -0400
Date: Mon, 6 Aug 2007 09:55:09 -0400
Message-Id: <200708061355.l76Dt9QF002370@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 21/25] sysfs: call attr_kill_to_mode from sysfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only save off ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/sysfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 10d1b52..38f2ba9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -49,7 +49,7 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	struct inode * inode = dentry->d_inode;
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 	struct iattr * sd_iattr;
-	unsigned int ia_valid = iattr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
 	if (!sd)
@@ -57,6 +57,9 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	sd_iattr = sd->s_iattr;
 
+	attr_kill_to_mode(inode, iattr);
+	ia_valid = iattr->ia_valid;
+
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
-- 
1.5.2.2

