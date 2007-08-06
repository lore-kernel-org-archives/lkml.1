Return-Path: <linux-kernel-owner+w=401wt.eu-S1764580AbXHFNzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764580AbXHFNzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764220AbXHFNyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763015AbXHFNyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:16 -0400
Date: Mon, 6 Aug 2007 09:54:13 -0400
Message-Id: <200708061354.l76DsDQd002270@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 03/25] AFFS: call attr_kill_to_mode from affs_notify_change
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: zippel@linux-m68k.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/affs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 4609a6c..1fa2937 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -218,6 +218,7 @@ affs_notify_change(struct dentry *dentry, struct iattr *attr)
 
 	pr_debug("AFFS: notify_change(%lu,0x%x)\n",inode->i_ino,attr->ia_valid);
 
+	attr_kill_to_mode(inode, attr);
 	error = inode_change_ok(inode,attr);
 	if (error)
 		goto out;
-- 
1.5.2.2

