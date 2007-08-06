Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbXHFN6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbXHFN6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXHFNyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbXHFNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:36 -0400
Date: Mon, 6 Aug 2007 09:54:35 -0400
Message-Id: <200708061354.l76DsZBF002305@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
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

