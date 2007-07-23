Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXGWIVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXGWIVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGWIVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:21:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:45216 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXGWIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=ErcH7iXRvsihP8L0j1HoozlwtEqzdsi0q/9ggzvEgOnJdCfCW6tCvzHI/q+WDE7aCrAcelxKQCriqri7//1On3/sqqXgj6fmi+1ZypRvhTgyc+cEyw0SXczqweS07XPkwqAx/lSUJC395aUL5UKdcyJ7NnUJbyMx6vtt3LHOuPs=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 1/1] fs: remove the unused mempages parameter
Date: Mon, 23 Jul 2007 16:21:13 +0800
Message-Id: <1185178873862-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the mempages parameter is actually not used, they should be removed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
If applied, now there is only files_init use the mempages parameter,
 	files_init(mempages);
but i don't think the adaptation to mempages in files_init is really useful;
and if files_init also changed to the prototype void (*func)(void),
the wrapper vfs_caches_init would also not need the mempages parameter.

 fs/dcache.c        |    8 ++++----
 fs/inode.c         |    2 +-
 fs/namespace.c     |    2 +-
 include/linux/fs.h |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 678d39d..4895959 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2108,7 +2108,7 @@ static void __init dcache_init_early(void)
 		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
 }
 
-static void __init dcache_init(unsigned long mempages)
+static void __init dcache_init(void)
 {
 	int loop;
 
@@ -2170,10 +2170,10 @@ void __init vfs_caches_init(unsigned long mempages)
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	dcache_init(mempages);
-	inode_init(mempages);
+	dcache_init();
+	inode_init();
 	files_init(mempages);
-	mnt_init(mempages);
+	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
 }
diff --git a/fs/inode.c b/fs/inode.c
index 29f5068..d7431e6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1378,7 +1378,7 @@ void __init inode_init_early(void)
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
-void __init inode_init(unsigned long mempages)
+void __init inode_init(void)
 {
 	int loop;
 
diff --git a/fs/namespace.c b/fs/namespace.c
index ddbda13..07daa79 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1791,7 +1791,7 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, ns->root, ns->root->mnt_root);
 }
 
-void __init mnt_init(unsigned long mempages)
+void __init mnt_init(void)
 {
 	struct list_head *d;
 	unsigned int nr_hash;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d33bead..41b37bc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -301,9 +301,9 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 
-extern void __init inode_init(unsigned long);
+extern void __init inode_init(void);
 extern void __init inode_init_early(void);
-extern void __init mnt_init(unsigned long);
+extern void __init mnt_init(void);
 extern void __init files_init(unsigned long);
 
 struct buffer_head;
-- 
1.5.2.2

