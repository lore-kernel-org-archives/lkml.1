Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbXJLP66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbXJLP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXJLP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:58:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:52914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbXJLP6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:58:50 -0400
Date: Fri, 12 Oct 2007 17:58:49 +0200
From: Jan Blunck <jblunck@suse.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [PATCH] VFS: Remove lives_below_in_same_fs()
Message-ID: <20071012155849.GG8471@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is another cleanup which removes lives_below_in_same_fs() since
is_subdir() from fs/dcache.c is providing the same functionality and is more
widespreadly used.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namespace.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1036,17 +1036,6 @@ static bool permit_mount(struct nameidat
 	return true;
 }
 
-static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
-{
-	while (1) {
-		if (d == dentry)
-			return 1;
-		if (d == NULL || d == d->d_parent)
-			return 0;
-		d = d->d_parent;
-	}
-}
-
 struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 					int flag, uid_t owner)
 {
@@ -1063,7 +1052,7 @@ struct vfsmount *copy_tree(struct vfsmou
 
 	p = mnt;
 	list_for_each_entry(r, &mnt->mnt_mounts, mnt_child) {
-		if (!lives_below_in_same_fs(r->mnt_mountpoint, dentry))
+		if (!is_subdir(r->mnt_mountpoint, dentry))
 			continue;
 
 		for (s = r; s; s = next_mnt(s, r)) {
