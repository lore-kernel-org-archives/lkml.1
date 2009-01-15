Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZAOHOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZAOHOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZAOHN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:13:59 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:44735 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZAOHN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=C5CXrZc8B+9mVZNx6nR8mSL6ijsxqyFxehP74U3X5khictqYmXBrm3xCmRRFQ2dNCc
         UV3srtm0sW7WnNW7w/UAgPF+7PyE2h3wV2tXaU5RiASh21yM7xLGhWTx6DK64BRikNP4
         EsUclBlUs/FcLg971HO2OLEGNH/gxs1LD4jew=
Message-ID: <496ee22e.04686e0a.3cf0.5e40@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] BTRFS: Mark '__init' for btrfs_init_cachep,
 btrfs_init_sysfs,btrfs_interface_init 
Date: Thu, 15 Jan 2009 15:13:45 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There functions are only called by 'static int __init init_btrfs_fs(void)',
so also mark them as '__init'.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eee060f..7e03ec8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2045,7 +2045,7 @@ int btrfs_write_inode(struct inode *inode, int wait);
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
-int btrfs_init_cachep(void);
+int __init btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
@@ -2089,7 +2089,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, int cache_only);
 
 /* sysfs.c */
-int btrfs_init_sysfs(void);
+int __init btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_super(struct btrfs_fs_info *fs);
 int btrfs_sysfs_add_root(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8adfe05..7170c4a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4521,7 +4521,7 @@ struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
 				 SLAB_MEM_SPREAD | extra_flags), ctor);
 }
 
-int btrfs_init_cachep(void)
+int __init btrfs_init_cachep(void)
 {
 	btrfs_inode_cachep = btrfs_cache_create("btrfs_inode_cache",
 					  sizeof(struct btrfs_inode),
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a14b49..0a3fc0d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -649,7 +649,7 @@ static struct miscdevice btrfs_misc = {
 	.fops		= &btrfs_ctl_fops
 };
 
-static int btrfs_interface_init(void)
+static int __init btrfs_interface_init(void)
 {
 	return misc_register(&btrfs_misc);
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a240b6f..bd73c97 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -254,7 +254,7 @@ void btrfs_sysfs_del_super(struct btrfs_fs_info *fs)
 	wait_for_completion(&fs->kobj_unregister);
 }
 
-int btrfs_init_sysfs(void)
+int __init btrfs_init_sysfs(void)
 {
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
 	if (!btrfs_kset)

