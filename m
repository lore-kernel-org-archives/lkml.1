Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbYDDMtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbYDDMtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYDDMrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:47:36 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49478 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800AbYDDMr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:47:26 -0400
Message-Id: <20080404122358.390018116@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:46 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 04/30] Prototypes of realpath.
Content-Disposition: inline; filename=tomoyo-realpath-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file defines realpath related prototypes.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 include/linux/realpath.h |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/include/linux/realpath.h
@@ -0,0 +1,62 @@
+/*
+ * include/linux/realpath.h
+ *
+ * Get the canonicalized absolute pathnames. The basis for SAKURA and TOMOYO.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#ifndef _LINUX_REALPATH_H
+#define _LINUX_REALPATH_H
+
+struct dentry;
+struct vfsmount;
+struct condition_list;
+struct path_info;
+
+/* Returns realpath(3) of the given pathname but ignores chroot'ed root. */
+int ccs_realpath_from_dentry2(struct dentry *dentry, struct vfsmount *mnt,
+			      char *newname, int newname_len);
+
+/*
+ * Returns realpath(3) of the given pathname but ignores chroot'ed root.
+ * These functions use ccs_alloc(), so caller must ccs_free()
+ * if these functions didn't return NULL.
+ */
+char *ccs_realpath(const char *pathname);
+/* Same with ccs_realpath() except that it doesn't follow the final symlink. */
+char *ccs_realpath_nofollow(const char *pathname);
+/* Same with ccs_realpath() except that the pathname is already solved. */
+char *ccs_realpath_from_dentry(struct dentry *dentry, struct vfsmount *mnt);
+
+/*
+ * Allocate memory for ACL entry.
+ * The RAM is chunked, so NEVER try to kfree() the returned pointer.
+ */
+void *ccs_alloc_element(const unsigned int size);
+
+/* Get used RAM size for ccs_alloc_elements(). */
+unsigned int ccs_get_memory_used_for_elements(void);
+
+/*
+ * Keep the given name on the RAM.
+ * The RAM is shared, so NEVER try to modify or kfree() the returned name.
+ */
+const struct path_info *ccs_save_name(const char *name);
+
+/* Get used RAM size for ccs_save_name(). */
+unsigned int ccs_get_memory_used_for_save_name(void);
+
+/* Allocate memory for temporary use (e.g. permission checks). */
+void *ccs_alloc(const size_t size);
+
+/* Get used RAM size for ccs_alloc(). */
+unsigned int ccs_get_memory_used_for_dynamic(void);
+
+/* Free memory allocated by ccs_alloc(). */
+void ccs_free(const void *p);
+
+#endif

-- 
