Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXHFN5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXHFN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764695AbXHFNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXHFNyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:21 -0400
Date: Mon, 6 Aug 2007 09:54:19 -0400
Message-Id: <200708061354.l76DsJrB002280@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 05/25] CIFS: call attr_kill_to_mode in cifs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dd41677..6fee1fa 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1429,6 +1429,8 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	cifs_sb = CIFS_SB(direntry->d_inode->i_sb);
 	pTcon = cifs_sb->tcon;
 
+	attr_kill_to_mode(direntry->d_inode, attrs);
+
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) == 0) {
 		/* check if we have permission to change attrs */
 		rc = inode_change_ok(direntry->d_inode, attrs);
-- 
1.5.2.2

