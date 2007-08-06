Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbXHFOG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbXHFOG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbXHFNzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018AbXHFNzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:22 -0400
Date: Mon, 6 Aug 2007 09:55:12 -0400
Message-Id: <200708061355.l76DtCd0002375@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 22/25] UDF: call attr_kill_to_mode from udf_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: bfennema@falcon.csc.calpoly.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only save off ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ufs/truncate.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index 79c54c8..193679b 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -509,9 +509,12 @@ out:
 static int ufs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		return error;
-- 
1.5.2.2

