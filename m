Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYAXRFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYAXRFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbYAXQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbYAXQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:40 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 02/19] dlm: proper prototypes
Date: Thu, 24 Jan 2008 10:50:25 -0600
Message-Id: <1201193442-8260-3-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper prototype for some functions in
fs/dlm/dlm_internal.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |   16 ++++++++++++++++
 fs/dlm/lock.c         |    1 -
 fs/dlm/lockspace.c    |    8 --------
 fs/dlm/main.c         |   10 ----------
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index d2fc238..ec61bba 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -570,5 +570,21 @@ static inline int dlm_no_directory(struct dlm_ls *ls)
 	return (ls->ls_exflags & DLM_LSFL_NODIR) ? 1 : 0;
 }
 
+int dlm_netlink_init(void);
+void dlm_netlink_exit(void);
+void dlm_timeout_warn(struct dlm_lkb *lkb);
+
+#ifdef CONFIG_DLM_DEBUG
+int dlm_register_debugfs(void);
+void dlm_unregister_debugfs(void);
+int dlm_create_debug_file(struct dlm_ls *ls);
+void dlm_delete_debug_file(struct dlm_ls *ls);
+#else
+static inline int dlm_register_debugfs(void) { return 0; }
+static inline void dlm_unregister_debugfs(void) { }
+static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
+static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
+#endif
+
 #endif				/* __DLM_INTERNAL_DOT_H__ */
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 3915b8e..7bc6ad9 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -88,7 +88,6 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 static int receive_extralen(struct dlm_message *ms);
 static void do_purge(struct dlm_ls *ls, int nodeid, int pid);
 static void del_timeout(struct dlm_lkb *lkb);
-void dlm_timeout_warn(struct dlm_lkb *lkb);
 
 /*
  * Lock compatibilty matrix - thanks Steve
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 6353a83..b99485b 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -24,14 +24,6 @@
 #include "recover.h"
 #include "requestqueue.h"
 
-#ifdef CONFIG_DLM_DEBUG
-int dlm_create_debug_file(struct dlm_ls *ls);
-void dlm_delete_debug_file(struct dlm_ls *ls);
-#else
-static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
-static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
-#endif
-
 static int			ls_count;
 static struct mutex		ls_lock;
 static struct list_head		lslist;
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index eca2907..58487fb 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -18,16 +18,6 @@
 #include "memory.h"
 #include "config.h"
 
-#ifdef CONFIG_DLM_DEBUG
-int dlm_register_debugfs(void);
-void dlm_unregister_debugfs(void);
-#else
-static inline int dlm_register_debugfs(void) { return 0; }
-static inline void dlm_unregister_debugfs(void) { }
-#endif
-int dlm_netlink_init(void);
-void dlm_netlink_exit(void);
-
 static int __init init_dlm(void)
 {
 	int error;
-- 
1.5.3.3

