Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbXHFODT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbXHFODT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933037AbXHFNyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbXHFNyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:38 -0400
Date: Mon, 6 Aug 2007 09:54:32 -0400
Message-Id: <200708061354.l76DsWAq002300@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 09/25] FUSE: Call attr_kill_to_mode from fuse_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: fuse-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fuse/dir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index bd5a772..60c8d5e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1016,6 +1016,8 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	int err;
 	int is_truncate = 0;
 
+	attr_kill_to_mode(inode, attr);
+
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
 		if (err)
-- 
1.5.2.2

