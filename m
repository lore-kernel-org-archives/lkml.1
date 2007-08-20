Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXHTU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXHTU4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXHTUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:53:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765215AbXHTUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:53:35 -0400
Date: Mon, 20 Aug 2007 16:53:33 -0400
Message-Id: <200708202053.l7KKrXRC017773@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 4/4] Have reiser4 call generic_attrkill from its setattr operation
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only filesystem in -mm but not in mainline that seems to
be affected by this change...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/reiser4/plugin/inode_ops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/reiser4/plugin/inode_ops.c b/fs/reiser4/plugin/inode_ops.c
index 48430f7..25a0093 100644
--- a/fs/reiser4/plugin/inode_ops.c
+++ b/fs/reiser4/plugin/inode_ops.c
@@ -436,6 +436,7 @@ int reiser4_setattr_common(struct dentry *dentry, struct iattr *attr)
 	int result;
 
 	inode = dentry->d_inode;
+	generic_attrkill(inode->i_mode, attr);
 	result = inode_change_ok(inode, attr);
 	if (result)
 		return result;
-- 
1.5.2.2

