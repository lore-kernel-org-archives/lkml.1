Return-Path: <linux-kernel-owner+w=401wt.eu-S1765319AbYEPPGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765319AbYEPPGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbYEPOp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:29 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49215 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYEPOmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:05 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 44/67] aufs inode operations
Date: Fri, 16 May 2008 23:32:58 +0900
Message-Id: <12109484022004-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484021927-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs inode operations

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/inode.h |  336 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 336 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/inode.h b/fs/aufs/inode.h
new file mode 100644
index 0000000..6b6945f
--- /dev/null
+++ b/fs/aufs/inode.h
@@ -0,0 +1,336 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * inode operations
+ *
+ * $Id: inode.h,v 1.2 2008/04/21 01:32:05 sfjro Exp $
+ */
+
+#ifndef __AUFS_INODE_H__
+#define __AUFS_INODE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/security.h>
+#include <linux/aufs_type.h>
+#include "hinode.h"
+#include "misc.h"
+#include "super.h"
+
+struct au_hinode;
+struct au_vdir;
+struct au_iinfo {
+	atomic_t		ii_generation;
+	struct super_block	*ii_hsb1;	/* no get/put */
+
+	struct au_rwsem		ii_rwsem;
+	aufs_bindex_t		ii_bstart, ii_bend;
+	struct au_hinode	*ii_hinode;
+	struct au_vdir		*ii_vdir;
+};
+
+struct aufs_icntnr {
+	struct au_iinfo iinfo;
+	struct inode vfs_inode;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* inode.c */
+int au_refresh_hinode_self(struct inode *inode);
+int au_refresh_hinode(struct inode *inode, struct dentry *dentry);
+struct inode *au_new_inode(struct dentry *dentry);
+int au_test_ro(struct super_block *sb, aufs_bindex_t bindex,
+	       struct inode *inode);
+int au_test_h_perm(struct inode *h_inode, int mask, int dlgt);
+int au_test_h_perm_sio(struct inode *h_inode, int mask, int dlgt);
+
+/* i_op.c */
+extern struct inode_operations aufs_iop, aufs_symlink_iop, aufs_dir_iop;
+
+/* au_wr_dir flags */
+#define AuWrDir_ADD_ENTRY	1
+#define AuWrDir_LOCK_SRCDIR	(1 << 1)
+#define AuWrDir_ISDIR		(1 << 2)
+#define au_ftest_wrdir(flags, name)	((flags) & AuWrDir_##name)
+#define au_fset_wrdir(flags, name)	{ (flags) |= AuWrDir_##name; }
+#define au_fclr_wrdir(flags, name)	{ (flags) &= ~AuWrDir_##name; }
+
+struct au_wr_dir_args {
+	aufs_bindex_t force_btgt;
+	unsigned int flags;
+};
+int au_wr_dir(struct dentry *dentry, struct dentry *src_dentry,
+	      struct au_wr_dir_args *args);
+
+/* i_op_add.c */
+struct au_ndx;
+int au_may_add(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir, struct au_ndx *ndx);
+int aufs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int aufs_symlink(struct inode *dir, struct dentry *dentry, const char *symname);
+int aufs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd);
+int aufs_link(struct dentry *src_dentry, struct inode *dir,
+	      struct dentry *dentry);
+int aufs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+
+/* i_op_del.c */
+int au_wr_dir_need_wh(struct dentry *dentry, int isdir, aufs_bindex_t *bcpup,
+		      struct dentry *locked);
+int au_may_del(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir, struct au_ndx *ndx);
+int aufs_unlink(struct inode *dir, struct dentry *dentry);
+int aufs_rmdir(struct inode *dir, struct dentry *dentry);
+
+/* i_op_ren.c */
+int au_wbr(struct dentry *dentry, aufs_bindex_t btgt);
+int aufs_rename(struct inode *src_dir, struct dentry *src_dentry,
+		struct inode *dir, struct dentry *dentry);
+
+#ifdef CONFIG_AUFS_DLGT
+/* dlgt.c */
+int au_security_inode_permission(struct inode *h_inode, int mask,
+				 struct nameidata *fake_nd, int dlgt);
+#else
+static inline
+int au_security_inode_permission(struct inode *h_inode, int mask,
+				 struct nameidata *fake_nd, int dlgt)
+{
+	return security_inode_permission(h_inode, mask, fake_nd);
+}
+#endif /* CONFIG_AUFS_DLGT */
+
+#ifdef CONFIG_AUFS_WORKAROUND_FUSE
+/* br_fuse.c */
+int aufs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *st);
+#endif
+
+#if 0 // xattr
+/* xattr.c */
+int aufs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		  size_t sz, int flags);
+ssize_t aufs_getxattr(struct dentry *dentry, const char *name, void *value,
+		      size_t sz);
+ssize_t aufs_listxattr(struct dentry *dentry, char *list, size_t sz);
+int aufs_removexattr(struct dentry *dentry, const char *name);
+#endif
+
+/* iinfo.c */
+struct au_iinfo *au_ii(struct inode *inode);
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex);
+aufs_bindex_t au_ii_br_id(struct inode *inode, aufs_bindex_t bindex);
+
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex);
+void au_set_hi_wh(struct inode *inode, aufs_bindex_t bindex,
+		  struct dentry *h_wh);
+unsigned int au_hi_flags(struct inode *inode, int isdir);
+
+/* hinode flags */
+#define AuHi_XINO	1
+#define AuHi_NOTIFY	(1 << 1)
+#define au_ftest_hi(flags, name)	((flags) & AuHi_##name)
+#define au_fset_hi(flags, name)		{ (flags) |= AuHi_##name; }
+#define au_fclr_hi(flags, name)		{ (flags) &= ~AuHi_##name; }
+#ifndef CONFIG_AUFS_HINOTIFY
+#undef AuHi_NOTIFY
+#define AuHi_NOTIFY	0
+#endif
+
+void au_set_h_iptr(struct inode *inode, aufs_bindex_t bindex,
+		   struct inode *h_inode, unsigned int flags);
+
+void au_update_iigen(struct inode *inode);
+void au_update_brange(struct inode *inode, int do_put_zero);
+
+int au_iinfo_init(struct inode *inode);
+void au_iinfo_fin(struct inode *inode);
+
+/* plink.c */
+#ifdef CONFIG_AUFS_DEBUG
+void au_plink_list(struct super_block *sb);
+#else
+static inline void au_plink_list(struct super_block *sb)
+{
+	/* nothing */
+}
+#endif
+int au_plink_test(struct super_block *sb, struct inode *inode);
+struct dentry *au_plink_lkup(struct super_block *sb, aufs_bindex_t bindex,
+			     struct inode *inode);
+void au_plink_append(struct super_block *sb, struct inode *inode,
+		     struct dentry *h_dentry, aufs_bindex_t bindex);
+void au_plink_put(struct super_block *sb);
+void au_plink_half_refresh(struct super_block *sb, aufs_bindex_t br_id);
+
+/* ---------------------------------------------------------------------- */
+
+/* lock subclass for iinfo */
+enum {
+	AuLsc_II_CHILD,		/* child first */
+	AuLsc_II_CHILD2,	/* rename(2), link(2), and cpup at hinotify */
+	AuLsc_II_CHILD3,	/* copyup dirs */
+	AuLsc_II_PARENT,
+	AuLsc_II_PARENT2,
+	AuLsc_II_PARENT3,
+	AuLsc_II_PARENT4,
+	AuLsc_II_NEW		/* new inode */
+};
+
+/*
+ * ii_read_lock_child, ii_write_lock_child,
+ * ii_read_lock_child2, ii_write_lock_child2,
+ * ii_read_lock_child3, ii_write_lock_child3,
+ * ii_read_lock_parent, ii_write_lock_parent,
+ * ii_read_lock_parent2, ii_write_lock_parent2,
+ * ii_read_lock_parent3, ii_write_lock_parent3,
+ * ii_read_lock_parent4, ii_write_lock_parent4,
+ * ii_read_lock_new, ii_write_lock_new
+ */
+#define AuReadLockFunc(name, lsc) \
+static inline void ii_read_lock_##name(struct inode *i) \
+{ au_rw_read_lock_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); }
+
+#define AuWriteLockFunc(name, lsc) \
+static inline void ii_write_lock_##name(struct inode *i) \
+{ au_rw_write_lock_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); }
+
+#define AuRWLockFuncs(name, lsc) \
+	AuReadLockFunc(name, lsc) \
+	AuWriteLockFunc(name, lsc)
+
+AuRWLockFuncs(child, CHILD);
+AuRWLockFuncs(child2, CHILD2);
+AuRWLockFuncs(child3, CHILD3);
+AuRWLockFuncs(parent, PARENT);
+AuRWLockFuncs(parent2, PARENT2);
+AuRWLockFuncs(parent3, PARENT3);
+AuRWLockFuncs(parent4, PARENT4);
+AuRWLockFuncs(new, NEW);
+
+#undef AuReadLockFunc
+#undef AuWriteLockFunc
+#undef AuRWLockFuncs
+
+/*
+ * ii_read_unlock, ii_write_unlock, ii_downgrade_lock
+ */
+AuSimpleUnlockRwsemFuncs(ii, struct inode *i, au_ii(i)->ii_rwsem);
+
+/* to debug easier, do not make them inlined functions */
+#define IiMustReadLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustReadLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustWriteLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustWriteLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustAnyLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustAnyLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustNoWaiters(i)	AuRwMustNoWaiters(&au_ii(i)->ii_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_ibstart(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_bstart;
+}
+
+static inline aufs_bindex_t au_ibend(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_bend;
+}
+
+static inline struct au_vdir *au_ivdir(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode));
+	return au_ii(inode)->ii_vdir;
+}
+
+static inline struct dentry *au_hi_wh(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct au_hinode *hinode;
+	IiMustAnyLock(inode);
+	hinode = au_ii(inode)->ii_hinode + bindex;
+	return hinode->hi_whdentry;
+}
+
+static inline void au_set_ibend(struct inode *inode, aufs_bindex_t bindex)
+{
+	IiMustWriteLock(inode);
+	AuDebugOn(au_sbend(inode->i_sb) < bindex || bindex < au_ibstart(inode));
+	au_ii(inode)->ii_bend = bindex;
+}
+
+static inline void au_set_ivdir(struct inode *inode, struct au_vdir *vdir)
+{
+	IiMustWriteLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode) || (au_ii(inode)->ii_vdir && vdir));
+	au_ii(inode)->ii_vdir = vdir;
+}
+
+static inline void au_hiput(struct au_hinode *hinode)
+{
+	au_hin_free(hinode);
+	dput(hinode->hi_whdentry);
+	iput(hinode->hi_inode);
+}
+
+static inline struct au_hinode *au_hi(struct inode *inode, aufs_bindex_t bindex)
+{
+	//todo: this lock check causes some unnecessary locks in callers.
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_hinode + bindex;
+}
+
+/* tiny test for inode number */
+/* tmpfs generation is too rough */
+static inline int au_test_higen(struct inode *inode, struct inode *h_inode)
+{
+	IiMustAnyLock(inode);
+	return !(au_ii(inode)->ii_hsb1 == h_inode->i_sb
+		 && inode->i_generation == h_inode->i_generation);
+}
+
+static inline au_gen_t au_iigen(struct inode *inode)
+{
+	return atomic_read(&au_ii(inode)->ii_generation);
+}
+
+#ifdef CONFIG_AUFS_HINOTIFY
+static inline au_gen_t au_iigen_dec(struct inode *inode)
+{
+	//AuDbg("i%lu\n", inode->i_ino);
+	return atomic_dec_return(&au_ii(inode)->ii_generation);
+}
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_INODE_H__ */
-- 
1.4.4.4

