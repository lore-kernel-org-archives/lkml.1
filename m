Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbXHFNXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbXHFNXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765490AbXHFNS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:18:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765207AbXHFNSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:07 -0400
Message-Id: <200708061318.l76DI3su001711@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 12:53:03 -0400
Subject: [PATCH 10/25] GFS2: have gfs2_setattr call attr_kill_to_mode
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/gfs2/ops_inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 911c115..8401fc7 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -994,6 +994,8 @@ static int gfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
 
+	attr_kill_to_mode(inode, attr);
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		goto out;
-- 
1.5.2.2

