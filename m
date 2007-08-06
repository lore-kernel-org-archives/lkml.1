Return-Path: <linux-kernel-owner+w=401wt.eu-S1765738AbXHFOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765738AbXHFOEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXHFNz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765125AbXHFNzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:11 -0400
Date: Mon, 6 Aug 2007 09:55:06 -0400
Message-Id: <200708061355.l76Dt6vI002365@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 20/25] smbfs: call attr_kill_to_mode from smb_notify_change
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..seems unlikely that the sb mode would include a setuid bit, but I suppose
it's possible.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/smbfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 73d1450..f42d191 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -675,6 +675,8 @@ smb_notify_change(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		goto out;
 
+	attr_kill_to_mode(inode, attr);
+
 	if ((error = inode_change_ok(inode, attr)) < 0)
 		goto out;
 
-- 
1.5.2.2

