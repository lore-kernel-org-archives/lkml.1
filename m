Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXHFOBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXHFOBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbXHFNzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764265AbXHFNzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:02 -0400
Date: Mon, 6 Aug 2007 09:55:00 -0400
Message-Id: <200708061355.l76Dt0D1002347@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 18/25] ramfs_nommu: call attr_kill_to_mode from ramfs_nommu_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


..and only set old_ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ramfs/file-nommu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index cad2b7a..c354883 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -192,9 +192,12 @@ static int ramfs_nommu_resize(struct inode *inode, loff_t newsize, loff_t size)
 static int ramfs_nommu_setattr(struct dentry *dentry, struct iattr *ia)
 {
 	struct inode *inode = dentry->d_inode;
-	unsigned int old_ia_valid = ia->ia_valid;
+	unsigned int old_ia_valid;
 	int ret = 0;
 
+	attr_kill_to_mode(inode, ia);
+	old_ia_valid = ia->ia_valid;
+
 	/* POSIX UID/GID verification for setting inode attributes */
 	ret = inode_change_ok(inode, ia);
 	if (ret)
-- 
1.5.2.2

