Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbYEPPH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbYEPPH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbYEPOpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:43 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49210 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYEPOmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:03 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 46/67] aufs inode private data
Date: Fri, 16 May 2008 23:33:00 +0900
Message-Id: <12109484021901-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948402867-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs inode private data

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/iinfo.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 290 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/iinfo.c b/fs/aufs/iinfo.c
new file mode 100644
index 0000000..c8eb976
--- /dev/null
+++ b/fs/aufs/iinfo.c
@@ -0,0 +1,290 @@
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
+ * inode private data
+ *
+ * $Id: iinfo.c,v 1.2 2008/04/21 01:32:05 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+struct au_iinfo *au_ii(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+
+	iinfo = &(container_of(inode, struct aufs_icntnr, vfs_inode)->iinfo);
+	/* bad_inode case */
+	if (unlikely(!iinfo->ii_hinode))
+		return NULL;
+	AuDebugOn(!iinfo->ii_hinode
+		  /* || au_sbi(inode->i_sb)->si_bend < iinfo->ii_bend */
+		  || iinfo->ii_bend < iinfo->ii_bstart);
+	return iinfo;
+}
+
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct inode *hidden_inode;
+
+	IiMustAnyLock(inode);
+	AuDebugOn(bindex < 0 || au_ibend(inode) < bindex);
+	hidden_inode = au_ii(inode)->ii_hinode[0 + bindex].hi_inode;
+	AuDebugOn(hidden_inode && atomic_read(&hidden_inode->i_count) <= 0);
+	return hidden_inode;
+}
+
+aufs_bindex_t au_ii_br_id(struct inode *inode, aufs_bindex_t bindex)
+{
+	IiMustAnyLock(inode);
+	AuDebugOn(bindex < 0
+		  || au_ibend(inode) < bindex
+		  || !au_ii(inode)->ii_hinode[0 + bindex].hi_inode);
+	return au_ii(inode)->ii_hinode[0 + bindex].hi_id;
+}
+
+// hard/soft set
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct au_iinfo *iinfo = au_ii(inode);
+	struct inode *h_inode;
+
+	IiMustWriteLock(inode);
+	AuDebugOn(au_sbend(inode->i_sb) < bindex);
+	iinfo->ii_bstart = bindex;
+	h_inode = iinfo->ii_hinode[bindex + 0].hi_inode;
+	if (h_inode)
+		au_cpup_igen(inode, h_inode);
+}
+
+unsigned int au_hi_flags(struct inode *inode, int isdir)
+{
+	unsigned int flags;
+	const unsigned int mnt_flags = au_mntflags(inode->i_sb);
+
+	flags = 0;
+	if (au_opt_test(mnt_flags, XINO))
+		au_fset_hi(flags, XINO);
+	if (unlikely(isdir && au_opt_test(mnt_flags, UDBA_INOTIFY)))
+		au_fset_hi(flags, NOTIFY);
+	return flags;
+}
+
+void au_set_h_iptr(struct inode *inode, aufs_bindex_t bindex,
+		   struct inode *h_inode, unsigned int flags)
+{
+	struct au_hinode *hinode;
+	struct inode *hi;
+	struct au_iinfo *iinfo = au_ii(inode);
+
+	LKTRTrace("i%lu, b%d, hi%lu, flags 0x%x\n",
+		  inode->i_ino, bindex, h_inode ? h_inode->i_ino : 0, flags);
+	IiMustWriteLock(inode);
+	hinode = iinfo->ii_hinode + bindex;
+	hi = hinode->hi_inode;
+	AuDebugOn(bindex < au_ibstart(inode) || au_ibend(inode) < bindex
+		  || (h_inode && atomic_read(&h_inode->i_count) <= 0)
+		  || (h_inode && hi));
+
+	if (hi) {
+#if 0 // remove this
+		if (!hi->i_nlink && au_ftest_hi(flags, XINO)) {
+			AuDebugOn(au_sbr_id(sb, bindex) != hinode->hi_id);
+			au_xino_write0(inode->i_sb, bindex, hi->i_ino, 0);
+			/* ignore this error */
+			/* bad action? */
+		}
+#endif
+		au_hiput(hinode);
+	}
+	hinode->hi_inode = h_inode;
+	if (h_inode) {
+		int err;
+		struct super_block *sb = inode->i_sb;
+
+		if (bindex == iinfo->ii_bstart)
+			au_cpup_igen(inode, h_inode);
+		hinode->hi_id = au_sbr_id(sb, bindex);
+		if (au_ftest_hi(flags, XINO)) {
+			struct au_xino_entry xinoe = {
+				.ino	= inode->i_ino,
+				//.h_gen	= h_inode->i_generation
+			};
+			err = au_xino_write(sb, bindex, h_inode->i_ino, &xinoe);
+			if (unlikely(err))
+				AuIOErr1("failed au_xino_write() %d\n", err);
+		}
+
+		if (unlikely(au_ftest_hi(flags, NOTIFY)
+			     && au_br_hinotifyable(au_sbr_perm(sb, bindex)))) {
+			err = au_hin_alloc(hinode, inode, h_inode);
+			if (unlikely(err))
+				AuIOErr1("au_hin_alloc() %d\n", err);
+		}
+	}
+}
+
+void au_set_hi_wh(struct inode *inode, aufs_bindex_t bindex,
+		  struct dentry *h_wh)
+{
+	struct au_hinode *hinode;
+
+	IiMustWriteLock(inode);
+	hinode = au_ii(inode)->ii_hinode + bindex;
+	AuDebugOn(hinode->hi_whdentry);
+	hinode->hi_whdentry = h_wh;
+}
+
+void au_update_iigen(struct inode *inode)
+{
+	//IiMustWriteLock(inode);
+	AuDebugOn(!inode->i_sb);
+	atomic_set(&au_ii(inode)->ii_generation, au_sigen(inode->i_sb));
+	//smp_mb(); /* atomic_set */
+}
+
+/* it may be called at remount time, too */
+void au_update_brange(struct inode *inode, int do_put_zero)
+{
+	struct au_iinfo *iinfo;
+
+	LKTRTrace("i%lu, %d\n", inode->i_ino, do_put_zero);
+	IiMustWriteLock(inode);
+
+	iinfo = au_ii(inode);
+	if (unlikely(!iinfo) || iinfo->ii_bstart < 0)
+		return;
+
+	if (do_put_zero) {
+		aufs_bindex_t bindex;
+		for (bindex = iinfo->ii_bstart; bindex <= iinfo->ii_bend;
+		     bindex++) {
+			struct inode *h_i;
+			h_i = iinfo->ii_hinode[0 + bindex].hi_inode;
+			if (h_i && !h_i->i_nlink)
+				au_set_h_iptr(inode, bindex, NULL, 0);
+		}
+	}
+
+	iinfo->ii_bstart = -1;
+	while (++iinfo->ii_bstart <= iinfo->ii_bend)
+		if (iinfo->ii_hinode[0 + iinfo->ii_bstart].hi_inode)
+			break;
+	if (iinfo->ii_bstart > iinfo->ii_bend) {
+		iinfo->ii_bstart = -1;
+		iinfo->ii_bend = -1;
+		return;
+	}
+
+	iinfo->ii_bend++;
+	while (0 <= --iinfo->ii_bend)
+		if (iinfo->ii_hinode[0 + iinfo->ii_bend].hi_inode)
+			break;
+	AuDebugOn(iinfo->ii_bstart > iinfo->ii_bend || iinfo->ii_bend < 0);
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_iinfo_init(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+	struct super_block *sb;
+	int nbr, i;
+
+	sb = inode->i_sb;
+	AuDebugOn(!sb);
+	iinfo = &(container_of(inode, struct aufs_icntnr, vfs_inode)->iinfo);
+	AuDebugOn(iinfo->ii_hinode);
+	nbr = au_sbend(sb) + 1;
+	if (unlikely(nbr <= 0))
+		nbr = 1;
+	iinfo->ii_hinode = kcalloc(nbr, sizeof(*iinfo->ii_hinode), GFP_KERNEL);
+	//iinfo->ii_hinode = NULL;
+	if (iinfo->ii_hinode) {
+		for (i = 0; i < nbr; i++)
+			iinfo->ii_hinode[i].hi_id = -1;
+		atomic_set(&iinfo->ii_generation, au_sigen(sb));
+		//smp_mb(); /* atomic_set */
+		au_rw_init_nolock(&iinfo->ii_rwsem);
+		iinfo->ii_bstart = -1;
+		iinfo->ii_bend = -1;
+		iinfo->ii_vdir = NULL;
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+static int au_iinfo_write0(struct super_block *sb, struct au_hinode *hinode,
+			   ino_t ino)
+{
+	int err, locked;
+	aufs_bindex_t bindex;
+
+	err = 0;
+	locked = si_read_trylock(sb, !AuLock_FLUSH); // crucio!
+	bindex = au_br_index(sb, hinode->hi_id);
+	if (bindex >= 0)
+		err = au_xino_write0(sb, bindex, hinode->hi_inode->i_ino, ino);
+	/* error action? */
+	if (locked)
+		si_read_unlock(sb);
+	return err;
+}
+
+void au_iinfo_fin(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+	aufs_bindex_t bend;
+	struct au_hinode *hi;
+	struct super_block *sb;
+	int unlinked;
+	ino_t ino;
+
+	iinfo = au_ii(inode);
+	/* bad_inode case */
+	if (unlikely(!iinfo))
+		return;
+
+	if (unlikely(iinfo->ii_vdir))
+		au_vdir_free(iinfo->ii_vdir);
+
+	if (iinfo->ii_bstart >= 0) {
+		sb = inode->i_sb;
+		unlinked = !inode->i_nlink;
+		ino = 0;
+		if (unlinked)
+			ino = inode->i_ino;
+		hi = iinfo->ii_hinode + iinfo->ii_bstart;
+		bend = iinfo->ii_bend;
+		while (iinfo->ii_bstart++ <= bend) {
+			if (hi->hi_inode) {
+				if (unlinked || !hi->hi_inode->i_nlink) {
+					au_iinfo_write0(sb, hi, ino);
+					/* ignore this error */
+					ino = 0;
+				}
+				au_hiput(hi);
+			}
+			hi++;
+		}
+		//iinfo->ii_bstart = iinfo->ii_bend = -1;
+	}
+
+	kfree(iinfo->ii_hinode);
+	//iinfo->ii_hinode = NULL;
+}
-- 
1.4.4.4

