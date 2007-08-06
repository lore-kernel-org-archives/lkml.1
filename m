Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXHFNyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXHFNyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbXHFNyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384AbXHFNyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:14 -0400
Date: Mon, 6 Aug 2007 09:54:10 -0400
Message-Id: <200708061354.l76DsAGu002265@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 02/25] 9p: have v9fs_vfs_setattr call attr_kill_to_mode
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/9p/vfs_inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..00fcd4e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -756,6 +756,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		return PTR_ERR(fid);
 
 	v9fs_blank_wstat(&wstat);
+	attr_kill_to_mode(dentry->d_inode, iattr);
 	if (iattr->ia_valid & ATTR_MODE)
 		wstat.mode = unixmode2p9mode(v9ses, iattr->ia_mode);
 
-- 
1.5.2.2

