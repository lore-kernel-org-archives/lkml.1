Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZISVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZISVun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZISVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:42:07 -0400
Received: from kroah.org ([198.145.64.141]:40481 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZISVmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:42:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/79] vt: move kernel stuff out of vt.h
Date: Sat, 19 Sep 2009 14:36:47 -0700
Message-Id: <1253396244-7885-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We have vt_kern.h for this


Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/vt.h      |   11 -----------
 include/linux/vt_kern.h |   12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/vt.h b/include/linux/vt.h
index 89c03a1..831daf6 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -1,17 +1,6 @@
 #ifndef _LINUX_VT_H
 #define _LINUX_VT_H
 
-#ifdef __KERNEL__
-struct notifier_block;
-
-struct vt_notifier_param {
-	struct vc_data *vc;	/* VC on which the update happened */
-	unsigned int c;		/* Printed char */
-};
-
-extern int register_vt_notifier(struct notifier_block *nb);
-extern int unregister_vt_notifier(struct notifier_block *nb);
-#endif
 
 /*
  * These constants are also useful for user-level apps (e.g., VC
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 5b53efe..c0c4e11 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -13,6 +13,7 @@
 #include <linux/console_struct.h>
 #include <linux/mm.h>
 #include <linux/consolemap.h>
+#include <linux/notifier.h>
 
 /*
  * Presently, a lot of graphics programs do not restore the contents of
@@ -118,4 +119,15 @@ struct vt_spawn_console {
 extern struct vt_spawn_console vt_spawn_con;
 
 extern int vt_move_to_console(unsigned int vt, int alloc);
+
+/* Interfaces for VC notification of character events (for accessibility etc) */
+
+struct vt_notifier_param {
+	struct vc_data *vc;	/* VC on which the update happened */
+	unsigned int c;		/* Printed char */
+};
+
+extern int register_vt_notifier(struct notifier_block *nb);
+extern int unregister_vt_notifier(struct notifier_block *nb);
+
 #endif /* _VT_KERN_H */
-- 
1.6.4.2

