Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbYEPO72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbYEPO72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYEPOoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:13 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49298 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbYEPOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:23 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 28/67] aufs copy-up/down functions
Date: Fri, 16 May 2008 23:32:42 +0900
Message-Id: <12109484011862-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <121094840127-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs copy-up/down functions

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/cpup.h |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/cpup.h b/fs/aufs/cpup.h
new file mode 100644
index 0000000..0e398f2
--- /dev/null
+++ b/fs/aufs/cpup.h
@@ -0,0 +1,82 @@
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
+ * copy-up/down functions
+ *
+ * $Id: cpup.h,v 1.2 2008/04/21 01:33:43 sfjro Exp $
+ */
+
+#ifndef __AUFS_CPUP_H__
+#define __AUFS_CPUP_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/aufs_type.h>
+
+void au_cpup_attr_timesizes(struct inode *inode);
+void au_cpup_attr_nlink(struct inode *inode);
+void au_cpup_attr_changeable(struct inode *inode);
+void au_cpup_igen(struct inode *inode, struct inode *h_inode);
+void au_cpup_attr_all(struct inode *inode);
+
+/* ---------------------------------------------------------------------- */
+
+/* cpup flags */
+#define AuCpup_DTIME	1	/* do dtime_store/revert */
+#define au_ftest_cpup(flags, name)	((flags) & AuCpup_##name)
+#define au_fset_cpup(flags, name)	{ (flags) |= AuCpup_##name; }
+#define au_fclr_cpup(flags, name)	{ (flags) &= ~AuCpup_##name; }
+
+int au_cpup_single(struct dentry *dentry, aufs_bindex_t bdst,
+		   aufs_bindex_t bsrc, loff_t len, unsigned int flags);
+int au_sio_cpup_single(struct dentry *dentry, aufs_bindex_t bdst,
+		       aufs_bindex_t bsrc, loff_t len, unsigned int flags);
+int au_cpup_simple(struct dentry *dentry, aufs_bindex_t bdst, loff_t len,
+		   unsigned int flags);
+int au_sio_cpup_simple(struct dentry *dentry, aufs_bindex_t bdst, loff_t len,
+		       unsigned int flags);
+int au_cpup_wh(struct dentry *dentry, aufs_bindex_t bdst, loff_t len,
+	       struct file *file);
+int au_sio_cpup_wh(struct dentry *dentry, aufs_bindex_t bdst, loff_t len,
+		   struct file *file);
+
+int au_cp_dirs(struct dentry *dentry, aufs_bindex_t bdst, struct dentry *locked,
+	       int (*cp)(struct dentry *dentry, aufs_bindex_t bdst,
+			 struct dentry *h_parent, void *arg),
+	       void *arg);
+int au_cpup_dirs(struct dentry *dentry, aufs_bindex_t bdst,
+		 struct dentry *locked);
+int au_test_and_cpup_dirs(struct dentry *dentry, aufs_bindex_t bdst,
+			  struct dentry *locked);
+
+/* ---------------------------------------------------------------------- */
+
+/* keep timestamps when copyup */
+struct au_dtime {
+	struct dentry *dt_dentry, *dt_h_dentry;
+	struct au_hinode *dt_hdir;
+	struct timespec dt_atime, dt_mtime;
+};
+void au_dtime_store(struct au_dtime *dt, struct dentry *dentry,
+		    struct dentry *h_dentry, struct au_hinode *hdir);
+void au_dtime_revert(struct au_dtime *dt);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_CPUP_H__ */
-- 
1.4.4.4

