Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbYEPOq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbYEPOq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYEPOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:28 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49246 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYEPOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:14 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 30/67] aufs whiteout for logical deletion and opaque directory, header
Date: Fri, 16 May 2008 23:32:44 +0900
Message-Id: <12109484011867-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484011143-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs whiteout for logical deletion and opaque directory, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/whout.h |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/whout.h b/fs/aufs/whout.h
new file mode 100644
index 0000000..f66239f
--- /dev/null
+++ b/fs/aufs/whout.h
@@ -0,0 +1,140 @@
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
+ * whiteout for logical deletion and opaque directory
+ *
+ * $Id: whout.h,v 1.2 2008/04/21 02:00:37 sfjro Exp $
+ */
+
+#ifndef __AUFS_WHOUT_H__
+#define __AUFS_WHOUT_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/aufs_type.h>
+#include "dir.h"
+#include "opts.h"
+#include "super.h"
+
+int au_wh_name_alloc(const char *name, int len, struct qstr *wh);
+void au_wh_name_free(struct qstr *wh);
+
+struct au_ndx;
+int au_wh_test(struct dentry *h_parent, struct qstr *wh_name, int try_sio,
+	       struct au_ndx *ndx);
+int au_diropq_test(struct dentry *h_dentry, struct au_ndx *ndx);
+
+struct dentry *au_whtmp_lkup(struct dentry *h_parent, struct qstr *prefix,
+			     struct au_ndx *ndx);
+int au_whtmp_ren(struct inode *dir, struct dentry *dentry, aufs_bindex_t bindex,
+		 int noself);
+int au_wh_unlink_dentry(struct inode *h_dir, struct dentry *wh_dentry,
+			struct dentry *dentry, struct inode *dir, int dlgt);
+
+struct au_branch;
+int au_wh_init(struct dentry *h_parent, struct au_branch *br,
+	       struct vfsmount *nfsmnt, struct super_block *sb);
+
+/* diropq flags */
+#define AuDiropq_CREATE	1
+#define AuDiropq_DLGT	(1 << 1)
+#define au_ftest_diropq(flags, name)	((flags) & AuDiropq_##name)
+#define au_fset_diropq(flags, name)	{ (flags) |= AuDiropq_##name; }
+#define au_fclr_diropq(flags, name)	{ (flags) &= ~AuDiropq_##name; }
+#ifndef CONFIG_AUFS_DLGT
+#undef AuDiropq_DLGT
+#define AuDiropq_DLGT	0
+#endif
+
+struct dentry *au_diropq_sio(struct dentry *dentry, aufs_bindex_t bindex,
+			     unsigned int flags);
+
+struct dentry *au_wh_lkup(struct dentry *h_parent, struct qstr *base_name,
+			  struct au_ndx *ndx);
+struct dentry *au_wh_create(struct inode *dir, struct dentry *dentry,
+			    aufs_bindex_t bindex, struct dentry *h_parent,
+			    struct au_ndx *ndx);
+
+/* real rmdir the whiteout-ed dir */
+struct au_whtmp_rmdir_args {
+	struct dentry *h_dentry;
+	struct au_nhash whlist;
+	aufs_bindex_t bindex;
+	struct inode *dir, *inode;
+	int noself;
+};
+
+struct au_nhash;
+int au_whtmp_rmdir(struct dentry *h_dentry, struct au_nhash *whlist,
+		   aufs_bindex_t bindex, struct inode *dir, struct inode *inode,
+		   int noself);
+void au_whtmp_kick_rmdir(struct dentry *h_dentry, struct au_nhash *whlist,
+			 aufs_bindex_t bindex, struct inode *dir,
+			 struct inode *inode, int noself,
+			 struct au_whtmp_rmdir_args *args);
+
+/* ---------------------------------------------------------------------- */
+
+static inline
+struct dentry *au_diropq_create(struct dentry *dentry, aufs_bindex_t bindex,
+				int dlgt)
+{
+	unsigned int flags = AuDiropq_CREATE;
+	if (unlikely(dlgt))
+		au_fset_diropq(flags, DLGT);
+	return au_diropq_sio(dentry, bindex, flags);
+}
+
+static inline
+int au_diropq_remove(struct dentry *dentry, aufs_bindex_t bindex, int dlgt)
+{
+	unsigned int flags = !AuDiropq_CREATE;
+	if (unlikely(dlgt))
+		au_fset_diropq(flags, DLGT);
+	return PTR_ERR(au_diropq_sio(dentry, bindex, flags));
+}
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_ROBR
+/* robr.c */
+int au_test_robr_wh(struct qstr *name, struct dentry *h_parent,
+		    struct qstr *wh_name, int try_sio, struct au_ndx *ndx);
+int au_test_robr_shwh(struct super_block *sb, const struct qstr *name);
+#else
+static inline
+int au_test_robr_wh(struct qstr *name, struct dentry *h_parent,
+		    struct qstr *wh_name, int try_sio, struct au_ndx *ndx)
+{
+	return au_wh_test(h_parent, wh_name, try_sio, ndx);
+}
+
+static inline
+int au_test_robr_shwh(struct super_block *sb, const struct qstr *name)
+{
+	if (unlikely(!au_opt_test(au_mntflags(sb), SHWH)
+		     && !strncmp(name->name, AUFS_WH_PFX, AUFS_WH_PFX_LEN)))
+		return -EPERM;
+	return 0;
+}
+#endif /* CONFIG_AUFS_ROBR */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_WHOUT_H__ */
-- 
1.4.4.4

