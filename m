Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYEPOys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYEPOys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYEPOnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:43:41 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49330 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbYEPOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:30 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 59/67] aufs misc functions, source
Date: Fri, 16 May 2008 23:33:13 +0900
Message-Id: <12109484021382-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484023487-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs misc functions, source

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/misc.c |  307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 307 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/misc.c b/fs/aufs/misc.c
new file mode 100644
index 0000000..edb5f7c
--- /dev/null
+++ b/fs/aufs/misc.c
@@ -0,0 +1,307 @@
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
+ * $Id: misc.c,v 1.5 2008/05/12 00:27:16 sfjro Exp $
+ */
+
+//#include <linux/fs.h>
+//#include <linux/namei.h>
+//#include <linux/mm.h>
+//#include <asm/uaccess.h>
+#include "aufs.h"
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp)
+{
+	void *q;
+
+	LKTRTrace("p %p, nused %d, sz %d\n", p, nused, new_sz);
+	AuDebugOn(new_sz <= 0);
+	if (new_sz <= nused)
+		return p;
+
+	q = krealloc(p, new_sz, gfp);
+	if (q)
+		memset(q + nused, 0, new_sz - nused);
+	return q;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct nameidata *au_dup_nd(struct au_sbinfo *sbinfo, struct nameidata *dst,
+			    struct nameidata *src)
+{
+	LKTRTrace("src %p\n", src);
+
+	if (src) {
+		*dst = *src;
+		dst->flags &= ~LOOKUP_PARENT;
+		if (sbinfo->si_wbr_create == AuWbrCreate_TDP) {
+			if ((dst->flags & LOOKUP_CREATE)
+			    && !(dst->intent.open.flags & O_CREAT))
+				dst->flags &= ~LOOKUP_CREATE;
+		} else {
+			dst->flags &= ~LOOKUP_CREATE;
+			dst->intent.open.flags &= ~O_CREAT;
+		}
+	} else
+		dst = NULL;
+
+	return dst;
+}
+
+#ifdef CONFIG_AUFS_FAKE_DM
+struct nameidata *au_fake_dm(struct nameidata *fake_nd, struct nameidata *nd,
+			     struct super_block *sb, aufs_bindex_t bindex)
+{
+	LKTRTrace("nd %p, b%d\n", nd, bindex);
+
+	if (!nd)
+		return NULL;
+
+	fake_nd->path.dentry = NULL;
+	fake_nd->path.mnt = NULL;
+	return fake_nd;
+}
+
+void au_fake_dm_release(struct nameidata *fake_nd)
+{
+	/* empty */
+}
+
+int au_h_create(struct inode *h_dir, struct dentry *h_dentry, int mode,
+		int dlgt, struct nameidata *nd, struct vfsmount *nfsmnt)
+{
+	int err;
+
+	LKTRTrace("hi%lu, %.*s, 0%o, nd %d, nfsmnt %d\n",
+		  h_dir->i_ino, AuDLNPair(h_dentry), mode, !!nd, !!nfsmnt);
+
+	err = -ENOSYS;
+	if (!nfsmnt)
+		err = vfsub_create(h_dir, h_dentry, mode, /*nd*/NULL, dlgt);
+
+	AuTraceErr(err);
+	return err;
+}
+#else
+struct nameidata *au_fake_dm(struct nameidata *fake_nd, struct nameidata *nd,
+			     struct super_block *sb, aufs_bindex_t bindex)
+{
+	LKTRTrace("nd %p, b%d\n", nd, bindex);
+
+	if (!nd)
+		return NULL;
+
+	DiMustAnyLock(nd->path.dentry);
+
+	fake_nd->path.dentry = NULL;
+	fake_nd->path.mnt = NULL;
+
+	if (bindex <= au_dbend(nd->path.dentry))
+		fake_nd->path.dentry = au_h_dptr(nd->path.dentry, bindex);
+	if (fake_nd->path.dentry) {
+		fake_nd->path.mnt = au_sbr_mnt(sb, bindex);
+		AuDebugOn(!fake_nd->path.mnt);
+		path_get(&fake_nd->path);
+	} else
+		fake_nd = ERR_PTR(-ENOENT);
+
+	AuTraceErrPtr(fake_nd);
+	return fake_nd;
+}
+
+void au_fake_dm_release(struct nameidata *fake_nd)
+{
+	if (fake_nd)
+		path_put(&fake_nd->path);
+}
+
+int au_h_create(struct inode *h_dir, struct dentry *h_dentry, int mode,
+		int dlgt, struct nameidata *nd, struct vfsmount *nfsmnt)
+{
+	int err;
+
+	LKTRTrace("hi%lu, %.*s, 0%o, nd %d, nfsmnt %d\n",
+		  h_dir->i_ino, AuDLNPair(h_dentry), mode, !!nd, !!nfsmnt);
+
+	err = -ENOSYS;
+	if (!nfsmnt)
+		err = vfsub_create(h_dir, h_dentry, mode, /*nd*/NULL, dlgt);
+	else {
+		struct nameidata fake_nd;
+
+		if (nd)
+			fake_nd = *nd;
+		else
+			memset(&fake_nd, 0, sizeof(fake_nd));
+		fake_nd.path.dentry = h_dentry;
+		fake_nd.path.mnt = nfsmnt;
+		path_get(&fake_nd.path);
+		fake_nd.flags = LOOKUP_CREATE;
+		fake_nd.intent.open.flags = O_CREAT | FMODE_READ;
+		fake_nd.intent.open.create_mode = mode;
+
+		err = vfsub_create(h_dir, h_dentry, mode, &fake_nd, dlgt);
+		path_put(&fake_nd.path);
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+#endif /* CONFIG_AUFS_FAKE_DM */
+
+/* ---------------------------------------------------------------------- */
+
+int au_copy_file(struct file *dst, struct file *src, loff_t len,
+		 struct super_block *sb)
+{
+	int err, all_zero;
+	unsigned long blksize;
+	char *buf;
+	struct vfsub_args vargs;
+	/* reduce stack space */
+	struct iattr *ia;
+
+	LKTRTrace("%.*s, %.*s\n",
+		  AuDLNPair(dst->f_dentry), AuDLNPair(src->f_dentry));
+	AuDebugOn(!(dst->f_mode & FMODE_WRITE));
+#ifdef CONFIG_AUFS_DEBUG
+	{
+		struct dentry *parent;
+		parent = dget_parent(dst->f_dentry);
+		IMustLock(parent->d_inode);
+		dput(parent);
+	}
+#endif
+
+	err = -ENOMEM;
+	blksize = dst->f_dentry->d_sb->s_blocksize;
+	if (!blksize || PAGE_SIZE < blksize)
+		blksize = PAGE_SIZE;
+	LKTRTrace("blksize %lu\n", blksize);
+	buf = kmalloc(blksize, GFP_TEMPORARY);
+	//buf = NULL;
+	if (unlikely(!buf))
+		goto out;
+	ia = kmalloc(sizeof(*ia), GFP_TEMPORARY);
+	if (unlikely(!ia))
+		goto out_buf;
+
+#ifdef CONFIG_AUFS_DEBUG
+	if (len > (1 << 22))
+		AuWarn("copying a large file %Ld\n", (long long)len);
+#endif
+	vfsub_args_init(&vargs, NULL, au_opt_test_dlgt(au_mntflags(sb)), 0);
+	err = 0;
+	all_zero = 0;
+	src->f_pos = 0;
+	dst->f_pos = 0;
+	while (len) {
+		size_t sz, rbytes, wbytes, i;
+		char *p;
+
+		LKTRTrace("len %lld\n", len);
+		sz = blksize;
+		if (len < blksize)
+			sz = len;
+
+		/* support LSM and notify */
+		rbytes = 0;
+		// signal_pending
+		while (!rbytes || err == -EAGAIN || err == -EINTR) {
+			rbytes = vfsub_read_k(src, buf, sz, &src->f_pos,
+					      vfsub_ftest(vargs.flags, DLGT));
+			err = rbytes;
+		}
+		if (unlikely(err < 0))
+			break;
+
+		all_zero = 0;
+		if (len >= rbytes && rbytes == blksize) {
+			//todo: try bitmap or memcmp()/get_zeroed_page()
+			unsigned long *ulp;
+			size_t n;
+
+			all_zero = 1;
+			ulp = (void *)buf;
+			n = rbytes / sizeof(*ulp);
+			i = n;
+			while (n-- > 0 && all_zero)
+				all_zero = !*ulp++;
+			p = (void *)ulp;
+			i *= sizeof(*ulp);
+			for (; all_zero && i < rbytes; i++)
+				all_zero = !*p++;
+		}
+		if (!all_zero) {
+			wbytes = rbytes;
+			p = buf;
+			while (wbytes) {
+				size_t b;
+				/* support LSM and notify */
+				b = vfsub_write_k(dst, p, wbytes, &dst->f_pos,
+						  &vargs);
+				err = b;
+				// signal_pending
+				if (unlikely(err == -EAGAIN || err == -EINTR))
+					continue;
+				if (unlikely(err < 0))
+					break;
+				wbytes -= b;
+				p += b;
+			}
+		} else {
+			loff_t res;
+			LKTRLabel(hole);
+			res = vfsub_llseek(dst, rbytes, SEEK_CUR);
+			err = res;
+			if (unlikely(res < 0))
+				break;
+		}
+		len -= rbytes;
+		err = 0;
+	}
+
+	/* the last block may be a hole */
+	if (unlikely(!err && all_zero)) {
+		struct dentry *h_d = dst->f_dentry;
+		struct inode *h_i = h_d->d_inode;
+
+		LKTRLabel(last hole);
+		do {
+			// signal_pending
+			err = vfsub_write_k(dst, "\0", 1, &dst->f_pos, &vargs);
+		} while (err == -EAGAIN || err == -EINTR);
+		if (err == 1) {
+			ia->ia_size = dst->f_pos;
+			ia->ia_valid = ATTR_SIZE | ATTR_FILE;
+			ia->ia_file = dst;
+			mutex_lock_nested(&h_i->i_mutex, AuLsc_I_CHILD2);
+			err = vfsub_notify_change(h_d, ia, &vargs);
+			mutex_unlock(&h_i->i_mutex);
+		}
+	}
+
+	kfree(ia);
+ out_buf:
+	kfree(buf);
+ out:
+	AuTraceErr(err);
+	return err;
+}
-- 
1.4.4.4

