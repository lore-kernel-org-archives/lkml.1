Return-Path: <linux-kernel-owner+w=401wt.eu-S1765168AbYEPPFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765168AbYEPPFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbYEPOp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:26 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49218 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYEPOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:06 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 43/67] aufs virtual or vertical directory
Date: Fri, 16 May 2008 23:32:57 +0900
Message-Id: <12109484021927-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484023820-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs virtual or vertical directory

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/vdir.c |  963 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 963 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/vdir.c b/fs/aufs/vdir.c
new file mode 100644
index 0000000..f2b67e9
--- /dev/null
+++ b/fs/aufs/vdir.c
@@ -0,0 +1,963 @@
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
+ * virtual or vertical directory
+ *
+ * $Id: vdir.c,v 1.3 2008/04/28 03:05:48 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+static int calc_size(int namelen)
+{
+	int sz;
+
+	sz = sizeof(struct au_vdir_de) + namelen;
+	if (sizeof(ino_t) == sizeof(long)) {
+		const int mask = sizeof(ino_t) - 1;
+		if (sz & mask) {
+			sz += sizeof(ino_t);
+			sz &= ~mask;
+		}
+	} else {
+#if 0 // remove
+		BUG();
+		/* this block will be discarded by optimizer. */
+		int m;
+		m = sz % sizeof(ino_t);
+		if (m)
+			sz += sizeof(ino_t) - m;
+#endif
+	}
+
+	AuDebugOn(sz % sizeof(ino_t));
+	return sz;
+}
+
+static int set_deblk_end(union au_vdir_deblk_p *p,
+			 union au_vdir_deblk_p *deblk_end)
+{
+	if (calc_size(0) <= deblk_end->p - p->p) {
+		p->de->de_str.len = 0;
+		//smp_mb();
+		return 0;
+	}
+	return -1; /* error */
+}
+
+/* returns true or false */
+static int is_deblk_end(union au_vdir_deblk_p *p,
+			union au_vdir_deblk_p *deblk_end)
+{
+	if (calc_size(0) <= deblk_end->p - p->p)
+		return !p->de->de_str.len;
+	return 1;
+}
+
+static au_vdir_deblk_t *last_deblk(struct au_vdir *vdir)
+{
+	return vdir->vd_deblk[vdir->vd_nblk - 1];
+}
+
+void au_nhash_init(struct au_nhash *nhash)
+{
+	int i;
+	for (i = 0; i < AuSize_NHASH; i++)
+		INIT_HLIST_HEAD(nhash->heads + i);
+}
+
+struct au_nhash *au_nhash_new(gfp_t gfp)
+{
+	struct au_nhash *nhash;
+
+	nhash = kmalloc(sizeof(*nhash), gfp);
+	if (nhash) {
+		au_nhash_init(nhash);
+		return nhash;
+	}
+	return ERR_PTR(-ENOMEM);
+}
+
+void au_nhash_del(struct au_nhash *nhash)
+{
+	au_nhash_fin(nhash);
+	kfree(nhash);
+}
+
+void au_nhash_move(struct au_nhash *dst, struct au_nhash *src)
+{
+	int i;
+
+	AuTraceEnter();
+
+	//DbgWhlist(src);
+	*dst = *src;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		struct hlist_head *h;
+		h = dst->heads + i;
+		if (h->first)
+			h->first->pprev = &h->first;
+		INIT_HLIST_HEAD(src->heads + i);
+	}
+	//DbgWhlist(src);
+	//DbgWhlist(dst);
+	//smp_mb();
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_nhash_fin(struct au_nhash *whlist)
+{
+	int i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos, *n;
+
+	AuTraceEnter();
+
+	for (i = 0; i < AuSize_NHASH; i++) {
+		head = whlist->heads + i;
+		hlist_for_each_entry_safe(tpos, pos, n, head, wh_hash) {
+			//hlist_del(pos);
+			kfree(tpos);
+		}
+	}
+}
+
+int au_nhash_test_longer_wh(struct au_nhash *whlist, aufs_bindex_t btgt,
+			    int limit)
+{
+	int n, i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos;
+
+	LKTRTrace("limit %d\n", limit);
+	//return 1;
+
+	n = 0;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		head = whlist->heads + i;
+		hlist_for_each_entry(tpos, pos, head, wh_hash)
+			if (tpos->wh_bindex == btgt && ++n > limit)
+				return 1;
+	}
+	return 0;
+}
+
+static unsigned int au_name_hash(const unsigned char *name, unsigned int len)
+{
+	return (full_name_hash(name, len) % AuSize_NHASH);
+}
+
+/* returns found(true) or not */
+int au_nhash_test_known_wh(struct au_nhash *whlist, char *name, int namelen)
+{
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos;
+	struct au_vdir_destr *str;
+
+	LKTRTrace("%.*s\n", namelen, name);
+
+	head = whlist->heads + au_name_hash(name, namelen);
+	hlist_for_each_entry(tpos, pos, head, wh_hash) {
+		str = &tpos->wh_str;
+		LKTRTrace("%.*s\n", str->len, str->name);
+		if (str->len == namelen && !memcmp(str->name, name, namelen))
+			return 1;
+	}
+	return 0;
+}
+
+int au_nhash_append_wh(struct au_nhash *whlist, char *name, int namelen,
+		       ino_t ino, unsigned int d_type, aufs_bindex_t bindex,
+		       unsigned char shwh)
+{
+	int err;
+	struct au_vdir_destr *str;
+	struct au_vdir_wh *wh;
+
+	LKTRTrace("%.*s\n", namelen, name);
+
+	err = -ENOMEM;
+	wh = kmalloc(sizeof(*wh) + namelen, GFP_TEMPORARY);
+	if (unlikely(!wh))
+		goto out;
+	err = 0;
+	wh->wh_bindex = bindex;
+	if (unlikely(shwh))
+		au_shwh_init_wh(wh, ino, d_type);
+	str = &wh->wh_str;
+	str->len = namelen;
+	memcpy(str->name, name, namelen);
+	hlist_add_head(&wh->wh_hash,
+		       whlist->heads + au_name_hash(name, namelen));
+	//smp_mb();
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_vdir_free(struct au_vdir *vdir)
+{
+	au_vdir_deblk_t **deblk;
+
+	AuTraceEnter();
+
+	deblk = vdir->vd_deblk;
+	while (vdir->vd_nblk--) {
+		kfree(*deblk);
+		deblk++;
+	}
+	kfree(vdir->vd_deblk);
+	au_cache_free_vdir(vdir);
+}
+
+static int append_deblk(struct au_vdir *vdir)
+{
+	int err, sz, i;
+	au_vdir_deblk_t **o;
+	union au_vdir_deblk_p p, deblk_end;
+
+	AuTraceEnter();
+
+	err = -ENOMEM;
+	sz = sizeof(*o) * vdir->vd_nblk;
+	o = au_kzrealloc(vdir->vd_deblk, sz, sz + sizeof(*o), GFP_KERNEL);
+	if (unlikely(!o))
+		goto out;
+	vdir->vd_deblk = o;
+	p.deblk = kmalloc(sizeof(*p.deblk), GFP_KERNEL);
+	if (p.deblk) {
+		i = vdir->vd_nblk++;
+		vdir->vd_deblk[i] = p.deblk;
+		vdir->vd_last.i = i;
+		vdir->vd_last.p.p = p.p;
+		deblk_end.deblk = p.deblk + 1;
+		err = set_deblk_end(&p, &deblk_end);
+		AuDebugOn(err);
+	}
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static struct au_vdir *alloc_vdir(void)
+{
+	struct au_vdir *vdir;
+	int err;
+
+	AuTraceEnter();
+
+	err = -ENOMEM;
+	vdir = au_cache_alloc_vdir();
+	if (unlikely(!vdir))
+		goto out;
+	vdir->vd_deblk = kzalloc(sizeof(*vdir->vd_deblk), GFP_KERNEL);
+	if (unlikely(!vdir->vd_deblk))
+		goto out_free;
+
+	vdir->vd_nblk = 0;
+	vdir->vd_version = 0;
+	vdir->vd_jiffy = 0;
+	err = append_deblk(vdir);
+	if (!err)
+		return vdir; /* success */
+
+	kfree(vdir->vd_deblk);
+
+ out_free:
+	au_cache_free_vdir(vdir);
+ out:
+	vdir = ERR_PTR(err);
+	AuTraceErrPtr(vdir);
+	return vdir;
+}
+
+static int reinit_vdir(struct au_vdir *vdir)
+{
+	int err;
+	union au_vdir_deblk_p p, deblk_end;
+
+	AuTraceEnter();
+
+	while (vdir->vd_nblk > 1) {
+		kfree(vdir->vd_deblk[vdir->vd_nblk - 1]);
+		vdir->vd_deblk[vdir->vd_nblk - 1] = NULL;
+		vdir->vd_nblk--;
+	}
+	p.deblk = vdir->vd_deblk[0];
+	deblk_end.deblk = p.deblk + 1;
+	err = set_deblk_end(&p, &deblk_end);
+	AuDebugOn(err);
+	vdir->vd_version = 0;
+	vdir->vd_jiffy = 0;
+	vdir->vd_last.i = 0;
+	vdir->vd_last.p.deblk = vdir->vd_deblk[0];
+	//smp_mb();
+	//DbgVdir(vdir);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void free_dehlist(struct au_nhash *dehlist)
+{
+	int i;
+	struct hlist_head *head;
+	struct au_vdir_dehstr *tpos;
+	struct hlist_node *pos, *n;
+
+	AuTraceEnter();
+
+	for (i = 0; i < AuSize_NHASH; i++) {
+		head = dehlist->heads + i;
+		hlist_for_each_entry_safe(tpos, pos, n, head, hash) {
+			//hlist_del(pos);
+			au_cache_free_dehstr(tpos);
+		}
+	}
+}
+
+/* returns found(true) or not */
+static int test_known(struct au_nhash *delist, char *name, int namelen)
+{
+	struct hlist_head *head;
+	struct au_vdir_dehstr *tpos;
+	struct hlist_node *pos;
+	struct au_vdir_destr *str;
+
+	LKTRTrace("%.*s\n", namelen, name);
+
+	head = delist->heads + au_name_hash(name, namelen);
+	hlist_for_each_entry(tpos, pos, head, hash) {
+		str = tpos->str;
+		LKTRTrace("%.*s\n", str->len, str->name);
+		if (str->len == namelen && !memcmp(str->name, name, namelen))
+			return 1;
+	}
+	return 0;
+
+}
+
+static int append_de(struct au_vdir *vdir, char *name, int namelen, ino_t ino,
+		     unsigned int d_type, struct au_nhash *delist)
+{
+	int err, sz;
+	union au_vdir_deblk_p p, *room, deblk_end;
+	struct au_vdir_dehstr *dehstr;
+
+	LKTRTrace("%.*s %d, i%lu, dt%u\n", namelen, name, namelen, ino, d_type);
+
+	p.deblk = last_deblk(vdir);
+	deblk_end.deblk = p.deblk + 1;
+	room = &vdir->vd_last.p;
+	AuDebugOn(room->p < p.p || deblk_end.p <= room->p
+		  || !is_deblk_end(room, &deblk_end));
+
+	sz = calc_size(namelen);
+	if (unlikely(sz > deblk_end.p - room->p)) {
+		err = append_deblk(vdir);
+		if (unlikely(err))
+			goto out;
+		p.deblk = last_deblk(vdir);
+		deblk_end.deblk = p.deblk + 1;
+		//smp_mb();
+		AuDebugOn(room->p != p.p);
+	}
+
+	err = -ENOMEM;
+	dehstr = au_cache_alloc_dehstr();
+	if (unlikely(!dehstr))
+		goto out;
+	dehstr->str = &room->de->de_str;
+	hlist_add_head(&dehstr->hash,
+		       delist->heads + au_name_hash(name, namelen));
+
+	room->de->de_ino = ino;
+	room->de->de_type = d_type;
+	room->de->de_str.len = namelen;
+	memcpy(room->de->de_str.name, name, namelen);
+
+	err = 0;
+	room->p += sz;
+	if (unlikely(set_deblk_end(room, &deblk_end)))
+		err = append_deblk(vdir);
+	//smp_mb();
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_ino(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		  ino_t *ino)
+{
+	int err;
+	struct au_xino_entry xinoe;
+	static DEFINE_MUTEX(mtx);
+
+	/* a race condition for hardlinks */
+	mutex_lock(&mtx);
+	err = au_xino_read(sb, bindex, h_ino, &xinoe);
+	if (unlikely(err))
+		goto out;
+
+	if (!xinoe.ino) {
+		//struct inode *h_inode;
+		err = -EIO;
+		xinoe.ino = au_xino_new_ino(sb);
+		if (unlikely(!xinoe.ino))
+			goto out;
+#if 0 // rfu
+		//xinoe.h_gen = AuXino_INVALID_HGEN;
+		h_inode = ilookup(au_sbr_sb(sb, bindex), h_ino);
+		if (h_inode) {
+			if (!is_bad_inode(h_inode)) {
+				xinoe.h_gen = h_inode->i_generation;
+				WARN_ON(xinoe.h_gen == AuXino_INVALID_HGEN);
+			}
+			iput(h_inode);
+		}
+#endif
+		err = au_xino_write(sb, bindex, h_ino, &xinoe);
+		if (unlikely(err))
+			goto out;
+	}
+
+	*ino = xinoe.ino;
+
+ out:
+	mutex_unlock(&mtx);
+	AuTraceErr(err);
+	return err;
+}
+
+static int au_wh_ino(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		     ino_t *ino)
+{
+#ifdef CONFIG_AUFS_SHWH
+	return au_ino(sb, bindex, h_ino, ino);
+#else
+	return 0;
+#endif
+}
+
+#define AuFillVdir_CALLED	1
+#define AuFillVdir_SHWH		(1 << 1)
+#define au_ftest_fillvdir(flags, name)	((flags) & AuFillVdir_##name)
+#define au_fset_fillvdir(flags, name)	{ (flags) |= AuFillVdir_##name; }
+#define au_fclr_fillvdir(flags, name)	{ (flags) &= ~AuFillVdir_##name; }
+#ifndef CONFIG_AUFS_SHWH
+#undef AuFillVdir_SHWH
+#define AuFillVdir_SHWH		0
+#endif
+
+struct fillvdir_arg {
+	struct file		*file;
+	struct au_vdir 	*vdir;
+	struct au_nhash	*delist;
+	struct au_nhash	*whlist;
+	aufs_bindex_t		bindex;
+	unsigned int		flags;
+	int			err;
+};
+
+static int fillvdir(void *__arg, const char *__name, int namelen, loff_t offset,
+		    u64 h_ino, unsigned int d_type)
+{
+	struct fillvdir_arg *arg = __arg;
+	char *name = (void *)__name;
+	aufs_bindex_t bindex, bend;
+	struct super_block *sb;
+	ino_t ino;
+
+	LKTRTrace("%.*s, namelen %d, i%Lu, dt%u\n",
+		  namelen, name, namelen, (u64)h_ino, d_type);
+
+	sb = arg->file->f_dentry->d_sb;
+	bend = arg->bindex;
+	arg->err = 0;
+	au_fset_fillvdir(arg->flags, CALLED);
+	//smp_mb();
+	if (namelen <= AUFS_WH_PFX_LEN
+	    || memcmp(name, AUFS_WH_PFX, AUFS_WH_PFX_LEN)) {
+		for (bindex = 0; bindex < bend; bindex++)
+			if (test_known(arg->delist + bindex, name, namelen)
+			    || au_nhash_test_known_wh(arg->whlist + bindex,
+						      name, namelen))
+				goto out; /* already exists or whiteouted */
+
+		ino = 1; /* why does gcc warns? */
+		arg->err = au_ino(sb, bend, h_ino, &ino);
+		if (!arg->err)
+			arg->err = append_de(arg->vdir, name, namelen, ino,
+					     d_type, arg->delist + bend);
+	} else {
+		name += AUFS_WH_PFX_LEN;
+		namelen -= AUFS_WH_PFX_LEN;
+		for (bindex = 0; bindex < bend; bindex++)
+			if (au_nhash_test_known_wh(arg->whlist + bend, name,
+						   namelen))
+				goto out; /* already whiteouted */
+
+		ino = 1; /* dummy */
+		if (unlikely(au_ftest_fillvdir(arg->flags, SHWH)))
+			arg->err = au_wh_ino(sb, bend, h_ino, &ino);
+		if (!arg->err)
+			arg->err = au_nhash_append_wh
+				(arg->whlist + bend, name, namelen, ino, d_type,
+				 bend, au_ftest_fillvdir(arg->flags, SHWH));
+	}
+
+ out:
+	if (!arg->err)
+		arg->vdir->vd_jiffy = jiffies;
+	//smp_mb();
+	AuTraceErr(arg->err);
+	return arg->err;
+}
+
+static int au_handle_shwh(struct super_block *sb, struct au_vdir *vdir,
+			  aufs_bindex_t bstart, aufs_bindex_t bend,
+			  struct au_nhash *_whlist, struct au_nhash *_delist)
+{
+#ifdef CONFIG_AUFS_SHWH
+	int err, i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos, *n;
+	char *p, *o;
+	struct au_nhash *whlist, *delist;
+	struct au_vdir_destr *destr;
+	aufs_bindex_t bindex;
+
+	AuTraceEnter();
+	AuDebugOn(!au_opt_test(au_mntflags(sb), SHWH));
+
+	err = -ENOMEM;
+	o = p = __getname();
+	if (unlikely(!p))
+		goto out;
+
+	err = 0;
+	memcpy(p, AUFS_WH_PFX, AUFS_WH_PFX_LEN);
+	p += AUFS_WH_PFX_LEN;
+	for (bindex = bstart; !err && bindex <= bend; bindex++) {
+		whlist = _whlist + bindex;
+		delist = _delist + bindex;
+
+		for (i = 0; i < AuSize_NHASH; i++) {
+			head = whlist->heads + i;
+			hlist_for_each_entry_safe(tpos, pos, n, head, wh_hash) {
+				destr = &tpos->wh_str;
+				memcpy(p, destr->name, destr->len);
+				err = append_de(vdir, o,
+						destr->len + AUFS_WH_PFX_LEN,
+						tpos->wh_ino, tpos->wh_type,
+						delist);
+				if (unlikely(err))
+					break;
+			}
+		}
+	}
+
+	__putname(o);
+
+ out:
+	AuTraceErr(err);
+	return err;
+#else
+	return 0;
+#endif
+}
+
+static int au_do_read_vdir(struct fillvdir_arg *arg)
+{
+	int err, dlgt, shwh;
+	aufs_bindex_t bend, bindex, bstart;
+	struct super_block *sb;
+	unsigned int mnt_flags;
+	struct file *hf;
+	loff_t offset;
+
+	AuTraceEnter();
+
+	err = -ENOMEM;
+	bend = au_fbend(arg->file);
+	arg->delist = kmalloc(sizeof(*arg->delist) * (bend + 1), GFP_TEMPORARY);
+	if (unlikely(!arg->delist))
+		goto out;
+	arg->whlist = kmalloc(sizeof(*arg->whlist) * (bend + 1), GFP_TEMPORARY);
+	if (unlikely(!arg->whlist))
+		goto out_delist;
+	err = 0;
+	for (bindex = 0; bindex <= bend; bindex++) {
+		au_nhash_init(arg->delist + bindex);
+		au_nhash_init(arg->whlist + bindex);
+	}
+
+	sb = arg->file->f_dentry->d_sb;
+	mnt_flags = au_mntflags(sb);
+	dlgt = !!au_opt_test_dlgt(mnt_flags);
+	arg->flags = 0;
+	shwh = 0;
+	if (unlikely(au_opt_test(mnt_flags, SHWH))) {
+		shwh = 1;
+		au_fset_fillvdir(arg->flags, SHWH);
+	}
+	bstart = au_fbstart(arg->file);
+	for (bindex = bstart; !err && bindex <= bend; bindex++) {
+		hf = au_h_fptr(arg->file, bindex);
+		if (!hf)
+			continue;
+
+		offset = vfsub_llseek(hf, 0, SEEK_SET);
+		err = offset;
+		if (unlikely(offset))
+			break;
+		arg->bindex = bindex;
+		do {
+			arg->err = 0;
+			au_fclr_fillvdir(arg->flags, CALLED);
+			//smp_mb();
+			err = vfsub_readdir(hf, fillvdir, arg, dlgt);
+			if (err >= 0)
+				err = arg->err;
+		} while (!err && au_ftest_fillvdir(arg->flags, CALLED));
+	}
+
+	if (unlikely(!err && shwh))
+		err = au_handle_shwh(sb, arg->vdir, bstart, bend, arg->whlist,
+				     arg->delist);
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		free_dehlist(arg->delist + bindex);
+		au_nhash_fin(arg->whlist + bindex);
+	}
+	kfree(arg->whlist);
+
+ out_delist:
+	kfree(arg->delist);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int read_vdir(struct file *file, int may_read)
+{
+	int err, do_read;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct au_vdir *vdir, *allocated;
+	unsigned long expire;
+	struct fillvdir_arg arg;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	LKTRTrace("%.*s, may %d\n", AuDLNPair(dentry), may_read);
+	FiMustWriteLock(file);
+	inode = dentry->d_inode;
+	IMustLock(inode);
+	IiMustWriteLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode));
+
+	err = 0;
+	allocated = NULL;
+	do_read = 0;
+	sb = inode->i_sb;
+	expire = au_sbi(sb)->si_rdcache;
+	vdir = au_ivdir(inode);
+#if 0 // debug
+	AuDbg("vdir %p, fvdir %p, i_ver %lu, vd_ver %lu, jiffy %lu,"
+	      " vd_jiffy %lu, expire %lu\n",
+	      vdir, au_fvdir_cache(file), inode->i_version,
+	      vdir ? vdir->vd_version : 0LU, jiffies,
+	      vdir ? vdir->vd_jiffy + expire : 0LU, expire);
+#endif
+	if (!vdir) {
+		AuDebugOn(au_fvdir_cache(file));
+		do_read = 1;
+		vdir = alloc_vdir();
+		err = PTR_ERR(vdir);
+		if (IS_ERR(vdir))
+			goto out;
+		err = 0;
+		allocated = vdir;
+	} else if (may_read
+		   && (inode->i_version != vdir->vd_version
+		       || time_after(jiffies, vdir->vd_jiffy + expire))) {
+		LKTRTrace("iver %Lu, vdver %lu, exp %lu\n",
+			  inode->i_version, vdir->vd_version,
+			  vdir->vd_jiffy + expire);
+		do_read = 1;
+		err = reinit_vdir(vdir);
+		if (unlikely(err))
+			goto out;
+	}
+	//AuDbgVdir(vdir); goto out;
+
+#if 0 // debug
+	AuDbg("do_read %d\n", do_read);
+#endif
+	if (!do_read)
+		return 0; /* success */
+
+	arg.file = file;
+	arg.vdir = vdir;
+	err = au_do_read_vdir(&arg);
+	if (!err) {
+		//file->f_pos = 0;
+		vdir->vd_version = inode->i_version;
+		vdir->vd_last.i = 0;
+		vdir->vd_last.p.deblk = vdir->vd_deblk[0];
+		if (allocated)
+			au_set_ivdir(inode, allocated);
+		//AuDbgVdir(vdir);
+	} else if (allocated)
+		au_vdir_free(allocated);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int copy_vdir(struct au_vdir *tgt, struct au_vdir *src)
+{
+	int err, i, rerr, n;
+
+	AuTraceEnter();
+	AuDebugOn(tgt->vd_nblk != 1);
+	//AuDbgVdir(tgt);
+
+	err = -ENOMEM;
+	if (tgt->vd_nblk < src->vd_nblk) {
+		au_vdir_deblk_t **p;
+		p = au_kzrealloc(tgt->vd_deblk, sizeof(*p) * tgt->vd_nblk,
+				 sizeof(*p) * src->vd_nblk, GFP_KERNEL);
+		if (unlikely(!p))
+			goto out;
+		tgt->vd_deblk = p;
+	}
+
+	tgt->vd_nblk = src->vd_nblk;
+	n = src->vd_nblk;
+	memcpy(tgt->vd_deblk[0], src->vd_deblk[0], AuSize_DEBLK);
+	//tgt->vd_last.i = 0;
+	//tgt->vd_last.p.deblk = tgt->vd_deblk[0];
+	tgt->vd_version = src->vd_version;
+	tgt->vd_jiffy = src->vd_jiffy;
+
+	for (i = 1; i < n; i++) {
+		tgt->vd_deblk[i] = kmalloc(AuSize_DEBLK, GFP_KERNEL);
+		if (tgt->vd_deblk[i])
+			memcpy(tgt->vd_deblk[i], src->vd_deblk[i],
+			       AuSize_DEBLK);
+		else
+			goto out;
+	}
+	//smp_mb();
+	//AuDbgVdir(tgt);
+	return 0; /* success */
+
+ out:
+	rerr = reinit_vdir(tgt);
+	BUG_ON(rerr);
+	AuTraceErr(err);
+	return err;
+}
+
+int au_vdir_init(struct file *file)
+{
+	int err;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct au_vdir *vdir_cache, *allocated;
+
+	dentry = file->f_dentry;
+	LKTRTrace("%.*s, pos %Ld\n", AuDLNPair(dentry), file->f_pos);
+	FiMustWriteLock(file);
+	inode = dentry->d_inode;
+	IiMustWriteLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode));
+
+	err = read_vdir(file, !file->f_pos);
+	if (unlikely(err))
+		goto out;
+	//AuDbgVdir(au_ivdir(inode)); goto out;
+
+	allocated = NULL;
+	vdir_cache = au_fvdir_cache(file);
+	if (!vdir_cache) {
+		vdir_cache = alloc_vdir();
+		err = PTR_ERR(vdir_cache);
+		if (IS_ERR(vdir_cache))
+			goto out;
+		allocated = vdir_cache;
+	} else if (!file->f_pos && vdir_cache->vd_version != file->f_version) {
+		err = reinit_vdir(vdir_cache);
+		if (unlikely(err))
+			goto out;
+	} else
+		return 0; /* success */
+	//err = 0; AuDbgVdir(vdir_cache); goto out;
+
+	err = copy_vdir(vdir_cache, au_ivdir(inode));
+	if (!err) {
+		file->f_version = inode->i_version;
+		if (allocated)
+			au_set_fvdir_cache(file, allocated);
+	} else if (allocated)
+		au_vdir_free(allocated);
+
+ out:
+	//au_debug_on();
+	AuTraceErr(err);
+	//au_debug_off();
+	return err;
+}
+
+static loff_t calc_offset(struct au_vdir *vdir)
+{
+	loff_t offset;
+	union au_vdir_deblk_p p;
+
+	p.deblk = vdir->vd_deblk[vdir->vd_last.i];
+	offset = vdir->vd_last.p.p - p.p;
+	offset += sizeof(*p.deblk) * vdir->vd_last.i;
+	return offset;
+}
+
+/* returns true or false */
+static int seek_vdir(struct file *file)
+{
+	int valid, i, n;
+	struct dentry *dentry;
+	struct au_vdir *vdir_cache;
+	loff_t offset;
+	union au_vdir_deblk_p p, deblk_end;
+
+	dentry = file->f_dentry;
+	LKTRTrace("%.*s, pos %Ld\n", AuDLNPair(dentry), file->f_pos);
+	vdir_cache = au_fvdir_cache(file);
+	AuDebugOn(!vdir_cache);
+	//AuDbgVdir(vdir_cache);
+
+	valid = 1;
+	offset = calc_offset(vdir_cache);
+	LKTRTrace("offset %Ld\n", offset);
+	if (file->f_pos == offset)
+		goto out;
+
+	vdir_cache->vd_last.i = 0;
+	vdir_cache->vd_last.p.deblk = vdir_cache->vd_deblk[0];
+	if (!file->f_pos)
+		goto out;
+
+	valid = 0;
+	i = file->f_pos / AuSize_DEBLK;
+	LKTRTrace("i %d\n", i);
+	if (i >= vdir_cache->vd_nblk)
+		goto out;
+
+	n = vdir_cache->vd_nblk;
+	for (; i < n; i++) {
+		p.deblk = vdir_cache->vd_deblk[i];
+		deblk_end.deblk = p.deblk + 1;
+		offset = i;
+		offset *= AuSize_DEBLK;
+		while (!is_deblk_end(&p, &deblk_end) && offset < file->f_pos) {
+			int l;
+			l = calc_size(p.de->de_str.len);
+			offset += l;
+			p.p += l;
+		}
+		if (!is_deblk_end(&p, &deblk_end)) {
+			valid = 1;
+			vdir_cache->vd_last.i = i;
+			vdir_cache->vd_last.p = p;
+			break;
+		}
+	}
+
+ out:
+	//smp_mb();
+	AuTraceErr(!valid);
+	return valid;
+}
+
+int au_vdir_fill_de(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err, l;
+	struct dentry *dentry;
+	struct au_vdir *vdir_cache;
+	struct au_vdir_de *de;
+	union au_vdir_deblk_p deblk_end;
+
+	dentry = file->f_dentry;
+	LKTRTrace("%.*s, pos %Ld\n", AuDLNPair(dentry), file->f_pos);
+	vdir_cache = au_fvdir_cache(file);
+	AuDebugOn(!vdir_cache);
+	//AuDbgVdir(vdir_cache);
+
+	if (!seek_vdir(file))
+		return 0;
+
+	while (1) {
+		deblk_end.deblk
+			= vdir_cache->vd_deblk[vdir_cache->vd_last.i] + 1;
+		while (!is_deblk_end(&vdir_cache->vd_last.p, &deblk_end)) {
+			de = vdir_cache->vd_last.p.de;
+			LKTRTrace("%.*s, off%Ld, i%lu, dt%d\n",
+				  de->de_str.len, de->de_str.name,
+				  file->f_pos, de->de_ino, de->de_type);
+			err = filldir(dirent, de->de_str.name, de->de_str.len,
+				      file->f_pos, de->de_ino, de->de_type);
+			if (unlikely(err)) {
+				AuTraceErr(err);
+				//return err;
+				//todo: ignore the error caused by udba.
+				return 0;
+			}
+
+			l = calc_size(de->de_str.len);
+			vdir_cache->vd_last.p.p += l;
+			file->f_pos += l;
+		}
+		if (vdir_cache->vd_last.i < vdir_cache->vd_nblk - 1) {
+			vdir_cache->vd_last.i++;
+			vdir_cache->vd_last.p.deblk
+				= vdir_cache->vd_deblk[vdir_cache->vd_last.i];
+			file->f_pos = sizeof(*vdir_cache->vd_last.p.deblk)
+				* vdir_cache->vd_last.i;
+			continue;
+		}
+		break;
+	}
+
+	//smp_mb();
+	return 0;
+}
-- 
1.4.4.4

