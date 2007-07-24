Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXHFNYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXHFNYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765500AbXHFNSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:18:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765208AbXHFNSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:04 -0400
Message-Id: <200708061318.l76DI1Wh001705@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 12:52:06 -0400
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

