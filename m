Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbYBQIXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbYBQIXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbYBQIU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:20:56 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37004 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114AbYBQIUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:20:54 -0500
Date: Sun, 17 Feb 2008 10:20:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: hch@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/freevxfs/: proper externs
Message-ID: <20080217082028.GS3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the extern declarations of several structs to vxfs_extern.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/freevxfs/vxfs_extern.h |    5 +++++
 fs/freevxfs/vxfs_immed.c  |    1 +
 fs/freevxfs/vxfs_inode.c  |    5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

d5e4ab16e3f3550022ee77df02a0602bc03642ee diff --git a/fs/freevxfs/vxfs_extern.h b/fs/freevxfs/vxfs_extern.h
index 2b46064..50ab5ee 100644
--- a/fs/freevxfs/vxfs_extern.h
+++ b/fs/freevxfs/vxfs_extern.h
@@ -50,7 +50,11 @@ extern daddr_t			vxfs_bmap1(struct inode *, long);
 /* vxfs_fshead.c */
 extern int			vxfs_read_fshead(struct super_block *);
 
+/* vxfs_immed.c */
+extern const struct inode_operations vxfs_immed_symlink_iops;
+
 /* vxfs_inode.c */
+extern const struct address_space_operations vxfs_immed_aops;
 extern struct kmem_cache	*vxfs_inode_cachep;
 extern void			vxfs_dumpi(struct vxfs_inode_info *, ino_t);
 extern struct inode *		vxfs_get_fake_inode(struct super_block *,
@@ -69,6 +73,7 @@ extern const struct file_operations	vxfs_dir_operations;
 extern int			vxfs_read_olt(struct super_block *, u_long);
 
 /* vxfs_subr.c */
+extern const struct address_space_operations vxfs_aops;
 extern struct page *		vxfs_get_page(struct address_space *, u_long);
 extern void			vxfs_put_page(struct page *);
 extern struct buffer_head *	vxfs_bread(struct inode *, int);
diff --git a/fs/freevxfs/vxfs_immed.c b/fs/freevxfs/vxfs_immed.c
index 8a5959a..c36aeaf 100644
--- a/fs/freevxfs/vxfs_immed.c
+++ b/fs/freevxfs/vxfs_immed.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 
 #include "vxfs.h"
+#include "vxfs_extern.h"
 #include "vxfs_inode.h"
 
 
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index ad88d23..9f3f2ce 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -41,11 +41,6 @@
 #include "vxfs_extern.h"
 
 
-extern const struct address_space_operations vxfs_aops;
-extern const struct address_space_operations vxfs_immed_aops;
-
-extern const struct inode_operations vxfs_immed_symlink_iops;
-
 struct kmem_cache		*vxfs_inode_cachep;
 
 

