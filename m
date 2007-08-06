Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbXHFN7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbXHFN7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbXHFNys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbXHFNyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:44 -0400
Date: Mon, 6 Aug 2007 09:54:41 -0400
Message-Id: <200708061354.l76Dsf0O002315@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 12/25] HPFS: call attr_kill_to_mode from hpfs_notify_change
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: mikulas@artax.karlin.mff.cuni.cz
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/hpfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 85d3e1d..d2b26eb 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -265,6 +265,7 @@ int hpfs_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error=0;
 	lock_kernel();
+	attr_kill_to_mode(inode, attr);
 	if ( ((attr->ia_valid & ATTR_SIZE) && attr->ia_size > inode->i_size) ||
 	     (hpfs_sb(inode->i_sb)->sb_root == inode->i_ino) ) {
 		error = -EINVAL;
-- 
1.5.2.2

