Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbXHFNX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbXHFNX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764905AbXHFNSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:18:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765329AbXHFNSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:12 -0400
Message-Id: <200708061318.l76DIADv001729@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 12:58:03 -0400
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

