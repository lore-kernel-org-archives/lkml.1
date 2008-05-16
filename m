Return-Path: <linux-kernel-owner+w=401wt.eu-S1765555AbYEPPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765555AbYEPPHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYEPOpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:46 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49205 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYEPOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:02 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 51/67] aufs lower (branch filesystem) inode and setting inotify
Date: Fri, 16 May 2008 23:33:05 +0900
Message-Id: <12109484024169-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484021063-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs lower (branch filesystem) inode and setting inotify

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/hinode.h |  188 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/hinode.h b/fs/aufs/hinode.h
new file mode 100644
index 0000000..59ddae7
--- /dev/null
+++ b/fs/aufs/hinode.h
@@ -0,0 +1,188 @@
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
+ * lower (branch filesystem) inode and setting inotify
+ *
+ * $Id: hinode.h,v 1.3 2008/04/28 03:08:37 sfjro Exp $
+ */
+
+#ifndef __AUFS_HINODE_H__
+#define __AUFS_HINODE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/inotify.h>
+#include <linux/aufs_type.h>
+//#include "branch.h"
+//#include "inode.h"
+#include "super.h"
+#include "vfsub.h"
+
+/* ---------------------------------------------------------------------- */
+
+struct au_hinotify {
+#ifdef CONFIG_AUFS_HINOTIFY
+	struct inotify_watch	hin_watch;
+	struct inode		*hin_aufs_inode;	/* no get/put */
+
+	/* an array of atomic_t X au_hin_nignore */
+	atomic_t		hin_ignore[0];
+#endif
+};
+
+struct au_hinode {
+	struct inode		*hi_inode;
+	aufs_bindex_t		hi_id;
+#ifdef CONFIG_AUFS_HINOTIFY
+	struct au_hinotify	*hi_notify;
+#endif
+
+	/* reference to the copied-up whiteout with get/put */
+	struct dentry		*hi_whdentry;
+};
+
+struct au_hin_ignore {
+#ifdef CONFIG_AUFS_HINOTIFY
+	__u32			ign_events;
+	struct au_hinode	*ign_hinode;
+#endif
+};
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_HINOTIFY
+static inline
+void au_hin_init(struct au_hinode *hinode, struct au_hinotify *val)
+{
+	hinode->hi_notify = val;
+}
+
+/* hinotify.c */
+int au_hin_alloc(struct au_hinode *hinode, struct inode *inode,
+		 struct inode *h_inode);
+void au_hin_free(struct au_hinode *hinode);
+void au_do_hdir_lock(struct inode *h_dir, struct inode *dir,
+		     aufs_bindex_t bindex, unsigned int lsc);
+void au_hdir_unlock(struct inode *h_dir, struct inode *dir,
+		    aufs_bindex_t bindex);
+struct dentry *au_hdir_lock_rename(struct dentry **h_parents,
+				   struct inode **dirs, aufs_bindex_t bindex,
+				   int issamedir);
+void au_hdir_unlock_rename(struct dentry **h_parents, struct inode **dirs,
+			   aufs_bindex_t bindex, int issamedir);
+void au_reset_hinotify(struct inode *inode, unsigned int flags);
+
+void au_hin_ignore(struct au_hinode *hinode, __u32 events);
+void au_hin_unignore(struct au_hinode *hinode, __u32 events);
+
+int __init au_inotify_init(void);
+void au_inotify_fin(void);
+
+#else
+
+static inline
+void au_hin_init(struct au_hinode *hinode, struct au_hinotify *val)
+{
+	/* empty */
+}
+
+static inline
+int au_hin_alloc(struct au_hinode *hinode, struct inode *inode,
+		 struct inode *h_inode)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void au_hin_free(struct au_hinode *hinode)
+{
+	/* nothing */
+}
+
+static inline
+void au_do_hdir_lock(struct inode *h_dir, struct inode *dir,
+		     aufs_bindex_t bindex, unsigned int lsc)
+{
+	mutex_lock_nested(&h_dir->i_mutex, lsc);
+}
+
+static inline
+void au_hdir_unlock(struct inode *h_dir, struct inode *dir,
+		    aufs_bindex_t bindex)
+{
+	mutex_unlock(&h_dir->i_mutex);
+}
+
+static inline
+struct dentry *au_hdir_lock_rename(struct dentry **h_parents,
+				   struct inode **dirs, aufs_bindex_t bindex,
+				   int issamedir)
+{
+	return vfsub_lock_rename(h_parents[0], h_parents[1]);
+}
+
+static inline
+void au_hdir_unlock_rename(struct dentry **h_parents, struct inode **dirs,
+			   aufs_bindex_t bindex, int issamedir)
+{
+	vfsub_unlock_rename(h_parents[0], h_parents[1]);
+}
+
+static inline void au_reset_hinotify(struct inode *inode, unsigned int flags)
+{
+	/* nothing */
+}
+
+static inline void au_hin_ignore(struct au_hinotify *hinotify, __u32 events)
+{
+	/* nothing */
+}
+
+static inline void au_hin_unignore(struct au_hinotify *hinotify, __u32 events)
+{
+	/* nothing */
+}
+
+static inline int au_inotify_init(void)
+{
+	return 0;
+}
+
+#define au_inotify_fin()	do {} while (0)
+#endif /* CONFIG_AUFS_HINOTIFY */
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * au_hdir_lock, au_hdir2_lock
+ */
+#define AuLockFunc(name, lsc) \
+static inline \
+void name##_lock(struct inode *h_dir, struct inode *dir, aufs_bindex_t bindex) \
+{ au_do_hdir_lock(h_dir, dir, bindex, AuLsc_I_##lsc); }
+
+AuLockFunc(au_hdir, PARENT);
+AuLockFunc(au_hdir2, PARENT2);
+
+#undef AuLockFunc
+
+/* ---------------------------------------------------------------------- */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_HINODE_H__ */
-- 
1.4.4.4

