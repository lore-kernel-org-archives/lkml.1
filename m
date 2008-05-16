Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYEPPDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYEPPDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbYEPOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:40 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49277 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYEPOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:19 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 7/67] aufs module initialization and module-global
Date: Fri, 16 May 2008 23:32:21 +0900
Message-Id: <12109484011533-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948401415-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs module initialization and module-global

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/module.h |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/module.h b/fs/aufs/module.h
new file mode 100644
index 0000000..cccee38
--- /dev/null
+++ b/fs/aufs/module.h
@@ -0,0 +1,78 @@
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
+ * module initialization and module-global
+ *
+ * $Id: module.h,v 1.2 2008/04/21 01:33:00 sfjro Exp $
+ */
+
+#ifndef __AUFS_MODULE_H__
+#define __AUFS_MODULE_H__
+
+#ifdef __KERNEL__
+
+//#include <linux/slab.h>
+
+/* ---------------------------------------------------------------------- */
+
+/* module parameters */
+extern short aufs_nwkq;
+extern int sysaufs_brs;
+
+/* ---------------------------------------------------------------------- */
+
+extern char au_esc_chars[];
+extern int au_dir_roflags;
+
+/* kmem cache */
+enum {
+	AuCache_DINFO,
+	AuCache_ICNTNR,
+	AuCache_FINFO,
+	AuCache_VDIR,
+	AuCache_DEHSTR,
+#ifdef CONFIG_AUFS_HINOTIFY
+	AuCache_HINOTIFY,
+#endif
+	AuCache_Last
+};
+
+extern struct kmem_cache *au_cachep[];
+
+#define AuCacheArgs(type, sz)	(type), (sz), 0, SLAB_RECLAIM_ACCOUNT, NULL
+#define AuCacheX(type, extra) \
+	kmem_cache_create(AuCacheArgs(#type, sizeof(struct type) + extra))
+#define AuCache(type)		AuCacheX(type, 0)
+
+/* ---------------------------------------------------------------------- */
+
+#define AuCacheFuncs(name, index) \
+static inline void *au_cache_alloc_##name(void) \
+{ return kmem_cache_alloc(au_cachep[index], GFP_KERNEL); } \
+static inline void au_cache_free_##name(void *p) \
+{ kmem_cache_free(au_cachep[index], p); }
+
+AuCacheFuncs(dinfo, AuCache_DINFO);
+AuCacheFuncs(icntnr, AuCache_ICNTNR);
+AuCacheFuncs(finfo, AuCache_FINFO);
+AuCacheFuncs(vdir, AuCache_VDIR);
+AuCacheFuncs(dehstr, AuCache_DEHSTR);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_MODULE_H__ */
-- 
1.4.4.4

