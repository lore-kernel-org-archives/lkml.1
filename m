Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbXHFOFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbXHFOFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbXHFNzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906AbXHFNzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:23 -0400
Date: Mon, 6 Aug 2007 09:55:15 -0400
Message-Id: <200708061355.l76DtFVO002381@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 23/25] XFS: call attr_kill_to_mode from xfs_vn_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..and only save off ia_valid after it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 0b5fa12..67fba53 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -651,12 +651,15 @@ xfs_vn_setattr(
 	struct iattr	*attr)
 {
 	struct inode	*inode = dentry->d_inode;
-	unsigned int	ia_valid = attr->ia_valid;
+	unsigned int	ia_valid;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 	bhv_vattr_t	vattr = { 0 };
 	int		flags = 0;
 	int		error;
 
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
+
 	if (ia_valid & ATTR_UID) {
 		vattr.va_mask |= XFS_AT_UID;
 		vattr.va_uid = attr->ia_uid;
-- 
1.5.2.2

