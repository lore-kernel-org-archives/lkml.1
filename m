Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYDDMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYDDMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbYDDMri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:47:38 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49669 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823AbYDDMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:47:27 -0400
Message-Id: <20080404122358.772001758@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:47 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 05/30] External functions prototypes for SAKURA.
Content-Disposition: inline; filename=tomoyo-sakura-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file defines prototypes and constants that are needed by hooks.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 include/linux/sakura.h |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/include/linux/sakura.h
@@ -0,0 +1,82 @@
+/*
+ * include/linux/sakura.h
+ *
+ * Implementation of the Domain-Free Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+/*
+ * A brief description about SAKURA:
+ *
+ *  SAKURA stands for "Security Advancement Know-how Upon Read-only Approach".
+ *  As the name shows, SAKURA was originally a methodology to make root fs
+ *  read-only to avoid tampering the system files.
+ *  But now, SAKURA is not only a methodology but also a kernel patch
+ *  that improves the system security with less effort.
+ *
+ *  SAKURA can restrict operations that affect systemwide.
+ *  SAKURA manages the filesystem's namespace related operations so that
+ *  files remains where the administrator expects.
+ */
+
+#ifndef _LINUX_SAKURA_H
+#define _LINUX_SAKURA_H
+
+#if defined(CONFIG_SAKURA)
+
+/* Check whether the given pathname is allowed to chroot to. */
+int ccs_check_chroot_permission(struct nameidata *nd);
+
+/* Check whether the mount operation with the given parameters is allowed. */
+int ccs_check_mount_permission(char *dev_name, char *dir_name, char *type,
+			       const unsigned long *flags);
+
+/* Check whether the current process is allowed to pivot_root. */
+int ccs_check_pivot_root_permission(struct nameidata *old_nd,
+				    struct nameidata *new_nd);
+
+/* Check whether the given mount operation hides an mounted partition. */
+int ccs_may_mount(struct nameidata *nd);
+
+/* Check whether the given mountpoint is allowed to umount. */
+int ccs_may_umount(struct vfsmount *mnt);
+
+/* Check whether the given port is allowed to autobind. */
+int ccs_may_autobind(const u16 port);
+
+#else
+
+static inline int ccs_check_chroot_permission(struct nameidata *nd)
+{
+	return 0;
+}
+static inline int ccs_check_mount_permission(char *dev_name, char *dir_name,
+					     char *type,
+					     const unsigned long *flags)
+{
+	return 0;
+}
+static inline int ccs_check_pivot_root_permission(struct nameidata *old_nd,
+						  struct nameidata *new_nd)
+{
+	return 0;
+}
+static inline int ccs_may_mount(struct nameidata *nd)
+{
+	return 0;
+}
+static inline int ccs_may_umount(struct vfsmount *mnt)
+{
+	return 0;
+}
+static inline int ccs_may_autobind(const u16 port)
+{
+	return 0;
+}
+
+#endif
+
+#endif

-- 
