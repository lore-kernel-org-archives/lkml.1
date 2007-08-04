Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbXHDTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbXHDTW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXHDTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:22:23 -0400
Received: from fallback.mail.ru ([194.67.57.14]:6772 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130AbXHDTWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:22:21 -0400
Date: Sat, 4 Aug 2007 23:24:31 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: move non-layout parts of ufs_fs.h to fs/ufs/
Message-ID: <20070804192431.GA12216@rain>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070803140917.GA24385@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803140917.GA24385@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototypes and in-core structures to fs/ufs/ similar to what most
other filesystems already do.

I made little modifications: move also ufs debug macros and
mount options constants into fs/ufs/ufs.h, this stuff
also private for ufs.

 
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.23-rc2/fs/ufs/balloc.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/balloc.c
+++ linux-2.6.23-rc2/fs/ufs/balloc.c
@@ -19,6 +19,7 @@
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/cylinder.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/cylinder.c
+++ linux-2.6.23-rc2/fs/ufs/cylinder.c
@@ -17,6 +17,7 @@
 
 #include <asm/byteorder.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/dir.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/dir.c
+++ linux-2.6.23-rc2/fs/ufs/dir.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/file.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/file.c
+++ linux-2.6.23-rc2/fs/ufs/file.c
@@ -27,6 +27,9 @@
 #include <linux/ufs_fs.h>
 #include <linux/buffer_head.h>	/* for sync_mapping_buffers() */
 
+#include "ufs.h"
+
+
 static int ufs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
Index: linux-2.6.23-rc2/fs/ufs/ialloc.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/ialloc.c
+++ linux-2.6.23-rc2/fs/ufs/ialloc.c
@@ -34,6 +34,7 @@
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/inode.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/inode.c
+++ linux-2.6.23-rc2/fs/ufs/inode.c
@@ -38,6 +38,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/namei.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/namei.c
+++ linux-2.6.23-rc2/fs/ufs/namei.c
@@ -31,7 +31,7 @@
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
 #include <linux/smp_lock.h>
-#include "swab.h"	/* will go away - see comment in mknod() */
+#include "ufs.h"
 #include "util.h"
 
 static inline int ufs_add_nondir(struct dentry *dentry, struct inode *inode)
@@ -110,7 +110,6 @@ static int ufs_mknod (struct inode * dir
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, mode, rdev);
-		/* NOTE: that'll go when we get wide dev_t */
 		ufs_set_inode_dev(inode->i_sb, UFS_I(inode), rdev);
 		mark_inode_dirty(inode);
 		lock_kernel();
Index: linux-2.6.23-rc2/fs/ufs/super.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/super.c
+++ linux-2.6.23-rc2/fs/ufs/super.c
@@ -91,6 +91,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/symlink.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/symlink.c
+++ linux-2.6.23-rc2/fs/ufs/symlink.c
@@ -28,6 +28,8 @@
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/ufs_fs.h>
+#include "ufs.h"
+
 
 static void *ufs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
Index: linux-2.6.23-rc2/fs/ufs/truncate.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/truncate.c
+++ linux-2.6.23-rc2/fs/ufs/truncate.c
@@ -46,6 +46,7 @@
 #include <linux/blkdev.h>
 #include <linux/sched.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/fs/ufs/ufs.h
===================================================================
--- /dev/null
+++ linux-2.6.23-rc2/fs/ufs/ufs.h
@@ -0,0 +1,157 @@
+#ifndef _UFS_UFS_H
+#define _UFS_UFS_H 1
+
+#define UFS_MAX_GROUP_LOADED 8
+#define UFS_CGNO_EMPTY ((unsigned)-1)
+
+struct ufs_sb_private_info;
+struct ufs_cg_private_info;
+struct ufs_csum;
+
+struct ufs_sb_info {
+	struct ufs_sb_private_info * s_uspi;
+	struct ufs_csum	* s_csp;
+	unsigned s_bytesex;
+	unsigned s_flags;
+	struct buffer_head ** s_ucg;
+	struct ufs_cg_private_info * s_ucpi[UFS_MAX_GROUP_LOADED];
+	unsigned s_cgno[UFS_MAX_GROUP_LOADED];
+	unsigned short s_cg_loaded;
+	unsigned s_mount_opt;
+};
+
+struct ufs_inode_info {
+	union {
+		__fs32	i_data[15];
+		__u8	i_symlink[4*15];
+		__fs64	u2_i_data[15];
+	} i_u1;
+	__u32	i_flags;
+	__u32	i_shadow;
+	__u32	i_unused1;
+	__u32	i_unused2;
+	__u32	i_oeftflag;
+	__u16	i_osync;
+	__u64	i_lastfrag;
+	__u32   i_dir_start_lookup;
+	struct inode vfs_inode;
+};
+
+/* mount options */
+#define UFS_MOUNT_ONERROR		0x0000000F
+#define UFS_MOUNT_ONERROR_PANIC		0x00000001
+#define UFS_MOUNT_ONERROR_LOCK		0x00000002
+#define UFS_MOUNT_ONERROR_UMOUNT	0x00000004
+#define UFS_MOUNT_ONERROR_REPAIR	0x00000008
+
+#define UFS_MOUNT_UFSTYPE		0x0000FFF0
+#define UFS_MOUNT_UFSTYPE_OLD		0x00000010
+#define UFS_MOUNT_UFSTYPE_44BSD		0x00000020
+#define UFS_MOUNT_UFSTYPE_SUN		0x00000040
+#define UFS_MOUNT_UFSTYPE_NEXTSTEP	0x00000080
+#define UFS_MOUNT_UFSTYPE_NEXTSTEP_CD	0x00000100
+#define UFS_MOUNT_UFSTYPE_OPENSTEP	0x00000200
+#define UFS_MOUNT_UFSTYPE_SUNx86	0x00000400
+#define UFS_MOUNT_UFSTYPE_HP	        0x00000800
+#define UFS_MOUNT_UFSTYPE_UFS2		0x00001000
+#define UFS_MOUNT_UFSTYPE_SUNOS		0x00002000
+
+#define ufs_clear_opt(o,opt)	o &= ~UFS_MOUNT_##opt
+#define ufs_set_opt(o,opt)	o |= UFS_MOUNT_##opt
+#define ufs_test_opt(o,opt)	((o) & UFS_MOUNT_##opt)
+
+/*
+ * Debug code
+ */
+#ifdef CONFIG_UFS_DEBUG
+#	define UFSD(f, a...)	{					\
+		printk ("UFSD (%s, %d): %s:",				\
+			__FILE__, __LINE__, __FUNCTION__);		\
+		printk (f, ## a);					\
+	}
+#else
+#	define UFSD(f, a...)	/**/
+#endif
+
+/* balloc.c */
+extern void ufs_free_fragments (struct inode *, u64, unsigned);
+extern void ufs_free_blocks (struct inode *, u64, unsigned);
+extern u64 ufs_new_fragments(struct inode *, void *, u64, u64,
+			     unsigned, int *, struct page *);
+
+/* cylinder.c */
+extern struct ufs_cg_private_info * ufs_load_cylinder (struct super_block *, unsigned);
+extern void ufs_put_cylinder (struct super_block *, unsigned);
+
+/* dir.c */
+extern const struct inode_operations ufs_dir_inode_operations;
+extern int ufs_add_link (struct dentry *, struct inode *);
+extern ino_t ufs_inode_by_name(struct inode *, struct dentry *);
+extern int ufs_make_empty(struct inode *, struct inode *);
+extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct dentry *, struct page **);
+extern int ufs_delete_entry(struct inode *, struct ufs_dir_entry *, struct page *);
+extern int ufs_empty_dir (struct inode *);
+extern struct ufs_dir_entry *ufs_dotdot(struct inode *, struct page **);
+extern void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
+			 struct page *page, struct inode *inode);
+
+/* file.c */
+extern const struct inode_operations ufs_file_inode_operations;
+extern const struct file_operations ufs_file_operations;
+
+extern const struct address_space_operations ufs_aops;
+
+/* ialloc.c */
+extern void ufs_free_inode (struct inode *inode);
+extern struct inode * ufs_new_inode (struct inode *, int);
+
+/* inode.c */
+extern void ufs_read_inode (struct inode *);
+extern void ufs_put_inode (struct inode *);
+extern int ufs_write_inode (struct inode *, int);
+extern int ufs_sync_inode (struct inode *);
+extern void ufs_delete_inode (struct inode *);
+extern struct buffer_head * ufs_bread (struct inode *, unsigned, int, int *);
+extern int ufs_getfrag_block (struct inode *inode, sector_t fragment, struct buffer_head *bh_result, int create);
+
+/* namei.c */
+extern const struct file_operations ufs_dir_operations;
+
+/* super.c */
+extern void ufs_warning (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
+extern void ufs_error (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
+extern void ufs_panic (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
+
+/* symlink.c */
+extern const struct inode_operations ufs_fast_symlink_inode_operations;
+
+/* truncate.c */
+extern int ufs_truncate (struct inode *, loff_t);
+
+static inline struct ufs_sb_info *UFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct ufs_inode_info *UFS_I(struct inode *inode)
+{
+	return container_of(inode, struct ufs_inode_info, vfs_inode);
+}
+
+/*
+ * Give cylinder group number for a file system block.
+ * Give cylinder group block number for a file system block.
+ */
+/* #define	ufs_dtog(d)	((d) / uspi->s_fpg) */
+static inline u64 ufs_dtog(struct ufs_sb_private_info * uspi, u64 b)
+{
+	do_div(b, uspi->s_fpg);
+	return b;
+}
+/* #define	ufs_dtogd(d)	((d) % uspi->s_fpg) */
+static inline u32 ufs_dtogd(struct ufs_sb_private_info * uspi, u64 b)
+{
+	return do_div(b, uspi->s_fpg);
+}
+
+#endif /* _UFS_UFS_H */
Index: linux-2.6.23-rc2/fs/ufs/util.c
===================================================================
--- linux-2.6.23-rc2.orig/fs/ufs/util.c
+++ linux-2.6.23-rc2/fs/ufs/util.c
@@ -11,6 +11,7 @@
 #include <linux/ufs_fs.h>
 #include <linux/buffer_head.h>
 
+#include "ufs.h"
 #include "swab.h"
 #include "util.h"
 
Index: linux-2.6.23-rc2/include/linux/ufs_fs.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/ufs_fs.h
+++ linux-2.6.23-rc2/include/linux/ufs_fs.h
@@ -46,11 +46,6 @@ typedef __u32 __bitwise __fs32;
 typedef __u16 __bitwise __fs16;
 #endif
 
-#ifdef __KERNEL__
-#include <linux/ufs_fs_i.h>
-#include <linux/ufs_fs_sb.h>
-#endif
-
 #define UFS_BBLOCK 0
 #define UFS_BBSIZE 8192
 #define UFS_SBLOCK 8192
@@ -188,29 +183,6 @@ typedef __u16 __bitwise __fs16;
 #define UFS_42INODEFMT	-1
 #define UFS_44INODEFMT	2
 
-/* mount options */
-#define UFS_MOUNT_ONERROR		0x0000000F
-#define UFS_MOUNT_ONERROR_PANIC		0x00000001
-#define UFS_MOUNT_ONERROR_LOCK		0x00000002
-#define UFS_MOUNT_ONERROR_UMOUNT	0x00000004
-#define UFS_MOUNT_ONERROR_REPAIR	0x00000008
-
-#define UFS_MOUNT_UFSTYPE		0x0000FFF0
-#define UFS_MOUNT_UFSTYPE_OLD		0x00000010
-#define UFS_MOUNT_UFSTYPE_44BSD		0x00000020
-#define UFS_MOUNT_UFSTYPE_SUN		0x00000040
-#define UFS_MOUNT_UFSTYPE_NEXTSTEP	0x00000080
-#define UFS_MOUNT_UFSTYPE_NEXTSTEP_CD	0x00000100
-#define UFS_MOUNT_UFSTYPE_OPENSTEP	0x00000200
-#define UFS_MOUNT_UFSTYPE_SUNx86	0x00000400
-#define UFS_MOUNT_UFSTYPE_HP	        0x00000800
-#define UFS_MOUNT_UFSTYPE_UFS2		0x00001000
-#define UFS_MOUNT_UFSTYPE_SUNOS		0x00002000
-
-#define ufs_clear_opt(o,opt)	o &= ~UFS_MOUNT_##opt
-#define ufs_set_opt(o,opt)	o |= UFS_MOUNT_##opt
-#define ufs_test_opt(o,opt)	((o) & UFS_MOUNT_##opt)
-
 /*
  * MINFREE gives the minimum acceptable percentage of file system
  * blocks which may be free. If the freelist drops below this level
@@ -225,19 +197,6 @@ typedef __u16 __bitwise __fs16;
  */
 #define UFS_MINFREE         5
 #define UFS_DEFAULTOPT      UFS_OPTTIME
-
-/*
- * Debug code
- */
-#ifdef CONFIG_UFS_DEBUG
-#	define UFSD(f, a...)	{					\
-		printk ("UFSD (%s, %d): %s:",				\
-			__FILE__, __LINE__, __FUNCTION__);		\
-		printk (f, ## a);					\
-	}
-#else
-#	define UFSD(f, a...)	/**/
-#endif
             
 /*
  * Turn file system block numbers into disk block addresses.
@@ -991,89 +950,4 @@ struct ufs_super_block_third {
 	__u8	fs_space[1];
 };
 
-#ifdef __KERNEL__
-
-/* balloc.c */
-extern void ufs_free_fragments (struct inode *, u64, unsigned);
-extern void ufs_free_blocks (struct inode *, u64, unsigned);
-extern u64 ufs_new_fragments(struct inode *, void *, u64, u64,
-			     unsigned, int *, struct page *);
-
-/* cylinder.c */
-extern struct ufs_cg_private_info * ufs_load_cylinder (struct super_block *, unsigned);
-extern void ufs_put_cylinder (struct super_block *, unsigned);
-
-/* dir.c */
-extern const struct inode_operations ufs_dir_inode_operations;
-extern int ufs_add_link (struct dentry *, struct inode *);
-extern ino_t ufs_inode_by_name(struct inode *, struct dentry *);
-extern int ufs_make_empty(struct inode *, struct inode *);
-extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct dentry *, struct page **);
-extern int ufs_delete_entry(struct inode *, struct ufs_dir_entry *, struct page *);
-extern int ufs_empty_dir (struct inode *);
-extern struct ufs_dir_entry *ufs_dotdot(struct inode *, struct page **);
-extern void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
-			 struct page *page, struct inode *inode);
-
-/* file.c */
-extern const struct inode_operations ufs_file_inode_operations;
-extern const struct file_operations ufs_file_operations;
-
-extern const struct address_space_operations ufs_aops;
-
-/* ialloc.c */
-extern void ufs_free_inode (struct inode *inode);
-extern struct inode * ufs_new_inode (struct inode *, int);
-
-/* inode.c */
-extern void ufs_read_inode (struct inode *);
-extern void ufs_put_inode (struct inode *);
-extern int ufs_write_inode (struct inode *, int);
-extern int ufs_sync_inode (struct inode *);
-extern void ufs_delete_inode (struct inode *);
-extern struct buffer_head * ufs_bread (struct inode *, unsigned, int, int *);
-extern int ufs_getfrag_block (struct inode *inode, sector_t fragment, struct buffer_head *bh_result, int create);
-
-/* namei.c */
-extern const struct file_operations ufs_dir_operations;
-        
-/* super.c */
-extern void ufs_warning (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
-extern void ufs_error (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
-extern void ufs_panic (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
-
-/* symlink.c */
-extern const struct inode_operations ufs_fast_symlink_inode_operations;
-
-/* truncate.c */
-extern int ufs_truncate (struct inode *, loff_t);
-
-static inline struct ufs_sb_info *UFS_SB(struct super_block *sb)
-{
-	return sb->s_fs_info;
-}
-
-static inline struct ufs_inode_info *UFS_I(struct inode *inode)
-{
-	return container_of(inode, struct ufs_inode_info, vfs_inode);
-}
-
-/*
- * Give cylinder group number for a file system block.
- * Give cylinder group block number for a file system block.
- */
-/* #define	ufs_dtog(d)	((d) / uspi->s_fpg) */
-static inline u64 ufs_dtog(struct ufs_sb_private_info * uspi, u64 b)
-{
-	do_div(b, uspi->s_fpg);
-	return b;
-}
-/* #define	ufs_dtogd(d)	((d) % uspi->s_fpg) */
-static inline u32 ufs_dtogd(struct ufs_sb_private_info * uspi, u64 b)
-{
-	return do_div(b, uspi->s_fpg);
-}
-
-#endif	/* __KERNEL__ */
-
 #endif /* __LINUX_UFS_FS_H */
Index: linux-2.6.23-rc2/include/linux/ufs_fs_i.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/ufs_fs_i.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *  linux/include/linux/ufs_fs_i.h
- *
- * Copyright (C) 1996
- * Adrian Rodriguez (adrian@franklins-tower.rutgers.edu)
- * Laboratory for Computer Science Research Computing Facility
- * Rutgers, The State University of New Jersey
- *
- * NeXTstep support added on February 5th 1998 by
- * Niels Kristian Bech Jensen <nkbj@image.dk>.
- */
-
-#ifndef _LINUX_UFS_FS_I_H
-#define _LINUX_UFS_FS_I_H
-
-struct ufs_inode_info {
-	union {
-		__fs32	i_data[15];
-		__u8	i_symlink[4*15];
-		__fs64	u2_i_data[15];
-	} i_u1;
-	__u32	i_flags;
-	__u32	i_shadow;
-	__u32	i_unused1;
-	__u32	i_unused2;
-	__u32	i_oeftflag;
-	__u16	i_osync;
-	__u64	i_lastfrag;
-	__u32   i_dir_start_lookup;
-	struct inode vfs_inode;
-};
-
-#endif /* _LINUX_UFS_FS_I_H */
Index: linux-2.6.23-rc2/include/linux/ufs_fs_sb.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/ufs_fs_sb.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* 
- *  linux/include/linux/ufs_fs_sb.h
- *
- * Copyright (C) 1996
- * Adrian Rodriguez (adrian@franklins-tower.rutgers.edu)
- * Laboratory for Computer Science Research Computing Facility
- * Rutgers, The State University of New Jersey
- *
- * $Id: ufs_fs_sb.h,v 1.8 1998/05/06 12:04:40 jj Exp $
- *
- * Write support by Daniel Pirkl <daniel.pirkl@email.cz>
- */
-
-#ifndef __LINUX_UFS_FS_SB_H
-#define __LINUX_UFS_FS_SB_H
-
-
-#define UFS_MAX_GROUP_LOADED 8
-#define UFS_CGNO_EMPTY ((unsigned)-1)
-
-struct ufs_sb_private_info;
-struct ufs_cg_private_info;
-struct ufs_csum;
-
-struct ufs_sb_info {
-	struct ufs_sb_private_info * s_uspi;	
-	struct ufs_csum	* s_csp;
-	unsigned s_bytesex;
-	unsigned s_flags;
-	struct buffer_head ** s_ucg;
-	struct ufs_cg_private_info * s_ucpi[UFS_MAX_GROUP_LOADED]; 
-	unsigned s_cgno[UFS_MAX_GROUP_LOADED];
-	unsigned short s_cg_loaded;
-	unsigned s_mount_opt;
-};
-
-#endif

-- 
/Evgeniy

