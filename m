Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYEPOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYEPOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYEPOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:05 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49183 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYEPOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:41:58 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 62/67] aufs magic sysrq handler
Date: Fri, 16 May 2008 23:33:16 +0900
Message-Id: <12109484021127-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484021767-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs magic sysrq handler

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sysrq.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/sysrq.c b/fs/aufs/sysrq.c
new file mode 100644
index 0000000..c50c885
--- /dev/null
+++ b/fs/aufs/sysrq.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (C) 2008 Junjiro Okajima
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
+ * magic sysrq hanlder
+ *
+ * $Id: sysrq.c,v 1.4 2008/05/04 23:53:27 sfjro Exp $
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/sysrq.h>
+#include "aufs.h"
+
+static void sysrq_sb(struct super_block *sb)
+{
+	char *plevel;
+	struct inode *i;
+
+	plevel = au_plevel;
+	au_plevel = KERN_WARNING;
+	au_debug_on();
+
+	pr_warning(AUFS_NAME ": superblock\n");
+	au_dpri_sb(sb);
+	pr_warning(AUFS_NAME ": root dentry\n");
+	au_dpri_dentry(sb->s_root);
+#if 0
+	pr_warning(AUFS_NAME ": root inode\n");
+	au_dpri_inode(sb->s_root->d_inode);
+#endif
+#if 1
+	pr_warning(AUFS_NAME ": isolated inode\n");
+	list_for_each_entry(i, &sb->s_inodes, i_sb_list)
+		if (list_empty(&i->i_dentry))
+			au_dpri_inode(i);
+#endif
+
+	au_plevel = plevel;
+	au_debug_off();
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* module parameter */
+static char *aufs_sysrq_key = "a";
+module_param_named(sysrq, aufs_sysrq_key, charp, S_IRUGO);
+MODULE_PARM_DESC(sysrq, "MagicSysRq key for " AUFS_NAME);
+
+static void au_sysrq(int key, struct tty_struct *tty)
+{
+	struct au_sbinfo *sbinfo;
+
+#if 0
+	if (au_debug_test())
+		au_debug_off();
+	else
+		au_debug_on();
+#endif
+
+	//mutex_lock(&au_sbilist_mtx);
+	list_for_each_entry(sbinfo, &au_sbilist, si_list)
+		sysrq_sb(sbinfo->si_sb);
+	//mutex_unlock(&au_sbilist_mtx);
+}
+
+static struct sysrq_key_op au_sysrq_op = {
+	.handler	= au_sysrq,
+	.help_msg	= "Aufs",
+	.action_msg	= "Aufs",
+	.enable_mask	= SYSRQ_ENABLE_DUMP //??
+};
+
+/* ---------------------------------------------------------------------- */
+
+int __init au_sysrq_init(void)
+{
+	int err;
+	char key;
+
+	err = -1;
+	key = *aufs_sysrq_key;
+	if ('a' <= key && key <= 'z')
+		err = register_sysrq_key(key, &au_sysrq_op);
+	if (unlikely(err))
+		AuErr("err %d, sysrq=%c\n", err, key);
+	return err;
+}
+
+void au_sysrq_fin(void)
+{
+	int err;
+	err = unregister_sysrq_key(*aufs_sysrq_key, &au_sysrq_op);
+	if (unlikely(err))
+		AuErr("err %d (ignored)\n", err);
+}
-- 
1.4.4.4

