Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbXHFOC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbXHFOC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765264AbXHFNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765033AbXHFNzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:06 -0400
Date: Mon, 6 Aug 2007 09:55:03 -0400
Message-Id: <200708061355.l76Dt37g002360@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 19/25] reiserfs: call attr_kill_to_mode from reiserfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only save off ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/reiserfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ddde489..55b2aea 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2896,7 +2896,11 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
+
 	reiserfs_write_lock(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
-- 
1.5.2.2

