Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYEPOw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYEPOw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYEPOnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:43:17 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49306 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbYEPOm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:26 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 26/67] aufs sub-dcache, header
Date: Fri, 16 May 2008 23:32:40 +0900
Message-Id: <12109484012904-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948401147-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs sub-dcache, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dcsub.h |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/dcsub.h b/fs/aufs/dcsub.h
new file mode 100644
index 0000000..e012b94
--- /dev/null
+++ b/fs/aufs/dcsub.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2007-2008 Junjiro Okajima
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
+ * sub-routines for dentry cache
+ *
+ * $Id: dcsub.h,v 1.1 2008/04/18 12:18:29 sfjro Exp $
+ */
+
+#ifndef __AUFS_DCSUB_H__
+#define __AUFS_DCSUB_H__
+
+#ifdef __KERNEL__
+
+#include <linux/dcache.h>
+
+struct au_dpage {
+	int ndentry;
+	struct dentry **dentries;
+};
+
+struct au_dcsub_pages {
+	int ndpage;
+	struct au_dpage *dpages;
+};
+
+/* ---------------------------------------------------------------------- */
+
+int au_dpages_init(struct au_dcsub_pages *dpages, gfp_t gfp);
+void au_dpages_free(struct au_dcsub_pages *dpages);
+typedef int (*au_dpages_test)(struct dentry *dentry, void *arg);
+int au_dcsub_pages(struct au_dcsub_pages *dpages, struct dentry *root,
+		   au_dpages_test test, void *arg);
+int au_dcsub_pages_rev(struct au_dcsub_pages *dpages, struct dentry *dentry,
+		       int do_include, au_dpages_test test, void *arg);
+int au_test_subdir(struct dentry *d1, struct dentry *d2);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DCSUB_H__ */
-- 
1.4.4.4

