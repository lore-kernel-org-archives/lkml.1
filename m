Return-Path: <linux-kernel-owner+w=401wt.eu-S966459AbXG3QZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966459AbXG3QZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938827AbXG3QP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161323.892472530@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:31 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 08/26] VFS: Export lives_below_in_same_fs()
Content-Disposition: inline; filename=um/vfs-export-lives_below_in_same_fs.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export lives_below_in_same_fs() for use in union mount code.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namespace.c        |    3 ++-
 include/linux/mount.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -793,7 +793,7 @@ static bool permit_mount(struct nameidat
 	return true;
 }
 
-static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
+int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
 {
 	while (1) {
 		if (d == dentry)
@@ -803,6 +803,7 @@ static int lives_below_in_same_fs(struct
 		d = d->d_parent;
 	}
 }
+EXPORT_SYMBOL_GPL(lives_below_in_same_fs);
 
 struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 					int flag, uid_t owner)
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -106,6 +106,7 @@ extern void shrink_submounts(struct vfsm
 
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
+extern int lives_below_in_same_fs(struct dentry *, struct dentry *);
 
 #endif
 #endif /* _LINUX_MOUNT_H */

-- 

