Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXHFNz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXHFNz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764949AbXHFNyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764163AbXHFNyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:18 -0400
Date: Mon, 6 Aug 2007 09:54:16 -0400
Message-Id: <200708061354.l76DsGoQ002275@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 04/25] AFS: call attr_kill_to_mode from afs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is necessary or desirable for AFS, but adding it for
consistency.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/afs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d196840..d0ad5e6 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -370,6 +370,9 @@ int afs_setattr(struct dentry *dentry, struct iattr *attr)
 	       vnode->fid.vid, vnode->fid.vnode, dentry->d_name.name,
 	       attr->ia_valid);
 
+	/* FIXME: is this necessary? */
+	attr_kill_to_mode(dentry->d_inode, attr);
+
 	if (!(attr->ia_valid & (ATTR_SIZE | ATTR_MODE | ATTR_UID | ATTR_GID |
 				ATTR_MTIME))) {
 		_leave(" = 0 [unsupported]");
-- 
1.5.2.2

