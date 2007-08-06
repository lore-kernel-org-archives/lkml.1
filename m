Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXHFOAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXHFOAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933072AbXHFNyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbXHFNyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:46 -0400
Date: Mon, 6 Aug 2007 09:54:44 -0400
Message-Id: <200708061354.l76DsicE002320@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 13/25] hugetlbfs: call attr_kill_to_mode from hugetlbfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: wli@holomorphy.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only set ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/hugetlbfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c848a19..3566abb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -340,10 +340,13 @@ static int hugetlbfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
 
 	BUG_ON(!inode);
 
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		goto out;
-- 
1.5.2.2

