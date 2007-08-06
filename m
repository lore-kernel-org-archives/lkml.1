Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbXHFN7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbXHFN7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbXHFNyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbXHFNym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:42 -0400
Date: Mon, 6 Aug 2007 09:54:38 -0400
Message-Id: <200708061354.l76DscWo002310@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 11/25] hostfs: call attr_kill_to_mode from hostfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: user-mode-linux-user@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/hostfs/hostfs_kern.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index c778620..ea75204 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -833,6 +833,8 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	int fd = HOSTFS_I(dentry->d_inode)->fd;
 
+	attr_kill_to_mode(dentry->d_inode, attr);
+
 	err = inode_change_ok(dentry->d_inode, attr);
 	if (err)
 		return err;
-- 
1.5.2.2

