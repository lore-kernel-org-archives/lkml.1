Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbYEPPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbYEPPIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbYEPOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:51 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49194 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYEPOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:00 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 56/67] aufs 'robr', aufs as readonly branch of another aufs
Date: Fri, 16 May 2008 23:33:10 +0900
Message-Id: <1210948402310-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484023300-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs 'robr', aufs as readonly branch of another aufs

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/robr.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/robr.c b/fs/aufs/robr.c
new file mode 100644
index 0000000..0e508bc
--- /dev/null
+++ b/fs/aufs/robr.c
@@ -0,0 +1,111 @@
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
+ * 'robr', aufs as readonly branch of another aufs
+ *
+ * $Id: robr.c,v 1.2 2008/05/12 00:26:53 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+int au_test_robr_wh(struct qstr *name, struct dentry *h_parent,
+		    struct qstr *wh_name, int try_sio, struct au_ndx *ndx)
+{
+	if (strncmp(name->name, AUFS_WH_PFX, AUFS_WH_PFX_LEN))
+		return au_wh_test(h_parent, wh_name, try_sio, ndx);
+	return -EPERM;
+}
+
+int au_test_robr_shwh(struct super_block *sb, const struct qstr *name)
+{
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct au_robr_lvma {
+	struct list_head list;
+	struct vm_area_struct *vma;
+};
+
+struct file *au_robr_safe_file(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct super_block *sb = file->f_dentry->d_sb;
+	struct au_robr_lvma *lvma, *entry;
+	struct au_sbinfo *sbinfo;
+	int found, warn;
+
+	AuTraceEnter();
+	AuDebugOn(!au_test_aufs(sb));
+
+	warn = 0;
+	found = 0;
+	sbinfo = au_sbi(sb);
+	spin_lock(&sbinfo->si_lvma_lock);
+	list_for_each_entry(entry, &sbinfo->si_lvma, list) {
+		found = (entry->vma == vma);
+		if (unlikely(found))
+			break;
+	}
+	if (!found) {
+		lvma = kmalloc(sizeof(*lvma), GFP_ATOMIC);
+		if (lvma) {
+			lvma->vma = vma;
+			list_add(&lvma->list, &sbinfo->si_lvma);
+		} else {
+			warn = 1;
+			file = NULL;
+		}
+	} else
+		file = NULL;
+	spin_unlock(&sbinfo->si_lvma_lock);
+
+	if (unlikely(warn))
+		AuWarn1("no memory for lvma\n");
+	return file;
+}
+
+void au_robr_reset_file(struct vm_area_struct *vma, struct file *file)
+{
+	struct super_block *sb = file->f_dentry->d_sb;
+	struct au_robr_lvma *entry, *found;
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+	AuDebugOn(!au_test_aufs(sb));
+
+	vma->vm_file = file;
+	//smp_mb(); /* flush vm_file */
+
+	found = NULL;
+	sbinfo = au_sbi(sb);
+	spin_lock(&sbinfo->si_lvma_lock);
+	list_for_each_entry(entry, &sbinfo->si_lvma, list)
+		if (entry->vma == vma) {
+			found = entry;
+			break;
+		}
+	AuDebugOn(!found);
+	list_del(&found->list);
+	spin_unlock(&sbinfo->si_lvma_lock);
+	kfree(found);
+}
-- 
1.4.4.4

