Return-Path: <linux-kernel-owner+w=401wt.eu-S1760365AbYEPOsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365AbYEPOsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbYEPOmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:44 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49256 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYEPOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:16 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 20/67] aufs mount options/flags, header
Date: Fri, 16 May 2008 23:32:34 +0900
Message-Id: <12109484012871-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484013702-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs mount options/flags, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/opts.h |  245 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 245 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/opts.h b/fs/aufs/opts.h
new file mode 100644
index 0000000..3b3ae84
--- /dev/null
+++ b/fs/aufs/opts.h
@@ -0,0 +1,245 @@
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
+ * mount options/flags
+ *
+ * $Id: opts.h,v 1.2 2008/04/21 01:46:26 sfjro Exp $
+ */
+
+#ifndef __AUFS_OPTS_H__
+#define __AUFS_OPTS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/aufs_type.h>
+#include "wkq.h"
+
+/* ---------------------------------------------------------------------- */
+/* mount flags */
+
+/* external inode number bitmap and translation table */
+#define AuOpt_XINO		1
+#define AuOpt_TRUNC_XINO	(1 << 1)
+#define AuOpt_LINO		(1 << 2)
+#define AuOpt_UDBA_NONE		(1 << 3)	/* users direct branch access */
+#define AuOpt_UDBA_REVAL	(1 << 4)
+#define AuOpt_UDBA_INOTIFY	(1 << 5)
+#define AuOpt_SHWH		(1 << 6)
+#define AuOpt_PLINK		(1 << 7)
+#define AuOpt_WARN_PERM		(1 << 8)
+#define AuOpt_DIRPERM1		(1 << 9)
+#define AuOpt_DLGT		(1 << 10)
+#define AuOpt_COO_NONE		(1 << 11)	/* copyup on open */
+#define AuOpt_COO_LEAF		(1 << 12)
+#define AuOpt_COO_ALL		(1 << 13)
+#define AuOpt_ALWAYS_DIROPQ	(1 << 14)
+#define AuOpt_REFROF		(1 << 15)
+#define AuOpt_VERBOSE		(1 << 16)
+#ifndef CONFIG_AUFS_HINOTIFY
+#undef AuOpt_UDBA_INOTIFY
+#define AuOpt_UDBA_INOTIFY	0
+#endif
+#ifndef CONFIG_AUFS_SHWH
+#undef AuOpt_SHWH
+#define AuOpt_SHWH		0
+#endif
+#ifndef CONFIG_AUFS_DLGT
+#undef AuOpt_DIRPERM1
+#define AuOpt_DIRPERM1		0
+#undef AuOpt_DLGT
+#define AuOpt_DLGT		0
+#endif
+
+/* policies to select one among multiple writable branches */
+enum {
+	AuWbrCreate_TDP,	/* top down parent */
+	AuWbrCreate_RR,		/* round robin */
+	AuWbrCreate_MFS,	/* most free space */
+	AuWbrCreate_MFSV,	/* mfs with seconds */
+	AuWbrCreate_MFSRR,	/* mfs then rr */
+	AuWbrCreate_MFSRRV,	/* mfs then rr with seconds */
+	AuWbrCreate_PMFS,	/* parent and mfs */
+	AuWbrCreate_PMFSV,	/* parent and mfs with seconds */
+
+	AuWbrCreate_Def = AuWbrCreate_TDP
+};
+
+enum {
+	AuWbrCopyup_TDP,	/* top down parent */
+	AuWbrCopyup_BUP,	/* bottom up parent */
+	AuWbrCopyup_BU,		/* bottom up */
+
+	AuWbrCopyup_Def = AuWbrCopyup_TDP
+};
+
+#define AuOptMask_COO		(AuOpt_COO_NONE \
+				 | AuOpt_COO_LEAF \
+				 | AuOpt_COO_ALL)
+#define AuOptMask_UDBA		(AuOpt_UDBA_NONE \
+				 | AuOpt_UDBA_REVAL \
+				 | AuOpt_UDBA_INOTIFY)
+
+#ifdef CONFIG_AUFS_COMPAT
+#define AuOpt_DefExtra1	AuOpt_ALWAYS_DIROPQ
+#else
+#define AuOpt_DefExtra1	0
+#endif
+
+#define AuOpt_Def	(AuOpt_XINO \
+			 | AuOpt_UDBA_REVAL \
+			 | AuOpt_WARN_PERM \
+			 | AuOpt_COO_NONE \
+			 | AuOpt_PLINK \
+			 | AuOpt_DefExtra1)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_opt_add {
+	aufs_bindex_t		bindex;
+	char			*path;
+	int			perm;
+	struct nameidata	nd;
+};
+
+struct au_opt_del {
+	char		*path;
+	struct dentry	*h_root;
+};
+
+struct au_opt_mod {
+	char		*path;
+	int		perm;
+	struct dentry	*h_root;
+};
+
+struct au_opt_xino {
+	char		*path;
+	struct file	*file;
+};
+
+struct au_opt_xino_itrunc {
+	aufs_bindex_t	bindex;
+};
+
+struct au_opt_xino_trunc_v {
+	u64		upper;
+	int		step;
+};
+
+struct au_opt_wbr_create {
+	int wbr_create;
+	int mfs_second;
+	u64 mfsrr_watermark;
+};
+
+struct au_opt {
+	int type;
+	union {
+		struct au_opt_xino	xino;
+		struct au_opt_xino_itrunc xino_itrunc;
+		struct au_opt_add	add;
+		struct au_opt_del	del;
+		struct au_opt_mod	mod;
+		int			dirwh;
+		int			rdcache;
+		int			deblk;
+		int			nhash;
+		int			udba;
+		int			coo;
+		struct au_opt_wbr_create wbr_create;
+		int			wbr_copyup;
+	};
+};
+
+/* opts flags */
+#define AuOpts_REMOUNT		1
+#define AuOpts_REFRESH_DIR	(1 << 1)
+#define AuOpts_REFRESH_NONDIR	(1 << 2)
+#define AuOpts_TRUNC_XIB	(1 << 3)
+#define au_ftest_opts(flags, name)	((flags) & AuOpts_##name)
+#define au_fset_opts(flags, name)	{ (flags) |= AuOpts_##name; }
+#define au_fclr_opts(flags, name)	{ (flags) &= ~AuOpts_##name; }
+
+struct au_opts {
+	struct au_opt	*opt;
+	int		max_opt;
+
+	unsigned int	given_udba;
+	unsigned int	flags;
+};
+
+/* ---------------------------------------------------------------------- */
+
+const char *au_optstr_br_perm(int brperm);
+const char *au_optstr_udba(int udba);
+const char *au_optstr_coo(int coo);
+const char *au_optstr_wbr_copyup(int wbr_copyup);
+const char *au_optstr_wbr_create(int wbr_create);
+
+void au_opts_free(struct au_opts *opts);
+int au_opts_parse(struct super_block *sb, unsigned long flags, char *str,
+		  struct au_opts *opts);
+int au_opts_mount(struct super_block *sb, struct au_opts *opts);
+int au_opts_remount(struct super_block *sb, struct au_opts *opts);
+
+/* ---------------------------------------------------------------------- */
+
+static inline unsigned int au_opt_do_test(unsigned int flags, unsigned int bit)
+{
+	AuDebugOn(bit & (AuOpt_DLGT | AuOpt_DIRPERM1));
+	return (flags & bit);
+}
+
+#define au_opt_test(flags, name)	au_opt_do_test(flags, AuOpt_##name)
+
+#define au_opt_set(flags, name) do { \
+	BUILD_BUG_ON(AuOpt_##name & (AuOptMask_COO | AuOptMask_UDBA)); \
+	((flags) |= AuOpt_##name); \
+} while (0)
+
+#define au_opt_clr(flags, name)		{ ((flags) &= ~AuOpt_##name); }
+
+#define au_opt_set_coo(flags, name) do { \
+	(flags) &= ~AuOptMask_COO; \
+	((flags) |= AuOpt_##name); \
+} while(0)
+
+#define au_opt_set_udba(flags, name) do { \
+	(flags) &= ~AuOptMask_UDBA; \
+	((flags) |= AuOpt_##name); \
+} while(0)
+
+static inline unsigned int au_opt_test_dlgt(unsigned int flags)
+{
+	if (!au_test_wkq(current))
+		return (flags & AuOpt_DLGT);
+	return 0;
+}
+
+static inline unsigned int au_opt_test_dirperm1(unsigned int flags)
+{
+	if (!au_test_wkq(current))
+		return (flags & AuOpt_DIRPERM1);
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_OPTS_H__ */
-- 
1.4.4.4

