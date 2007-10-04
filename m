Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXJDQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXJDQQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbXJDQQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:16:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46028 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbXJDQQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:16:01 -0400
Date: Thu, 4 Oct 2007 09:15:59 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>
Subject: [PATCH] Rename is_cgroup_init()
Message-ID: <20071004161559.GA19451@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] Rename is_cgroup_init()

is_container_init() was accidentally renamed to is_cgroup_init() when
renaming "container" to "control group". This patch restores the
original name.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/sched.h |    4 ++--
 kernel/capability.c   |    2 +-
 kernel/pid.c          |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: 2.6.23-rc8-mm2/include/linux/sched.h
===================================================================
--- 2.6.23-rc8-mm2.orig/include/linux/sched.h	2007-10-02 22:05:18.000000000 -0700
+++ 2.6.23-rc8-mm2/include/linux/sched.h	2007-10-03 10:26:12.000000000 -0700
@@ -1303,10 +1303,10 @@ static inline int is_global_init(struct 
 }
 
 /*
- * is_cgroup_init:
+ * is_container_init:
  * check whether in the task is init in its own pid namespace.
  */
-extern int is_cgroup_init(struct task_struct *tsk);
+extern int is_container_init(struct task_struct *tsk);
 
 extern struct pid *cad_pid;
 
Index: 2.6.23-rc8-mm2/kernel/capability.c
===================================================================
--- 2.6.23-rc8-mm2.orig/kernel/capability.c	2007-09-27 13:20:11.000000000 -0700
+++ 2.6.23-rc8-mm2/kernel/capability.c	2007-10-03 10:26:35.000000000 -0700
@@ -130,7 +130,7 @@ static inline int cap_set_all(kernel_cap
      int found = 0;
 
      do_each_thread(g, target) {
-             if (target == current || is_cgroup_init(target->group_leader))
+             if (target == current || is_container_init(target->group_leader))
                      continue;
              found = 1;
 	     if (security_capset_check(target, effective, inheritable,
Index: 2.6.23-rc8-mm2/kernel/pid.c
===================================================================
--- 2.6.23-rc8-mm2.orig/kernel/pid.c	2007-10-03 10:24:12.000000000 -0700
+++ 2.6.23-rc8-mm2/kernel/pid.c	2007-10-03 10:24:45.000000000 -0700
@@ -81,7 +81,7 @@ struct pid_namespace init_pid_ns = {
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
-int is_cgroup_init(struct task_struct *tsk)
+int is_container_init(struct task_struct *tsk)
 {
 	int ret = 0;
 	struct pid *pid;
@@ -94,7 +94,7 @@ int is_cgroup_init(struct task_struct *t
 
 	return ret;
 }
-EXPORT_SYMBOL(is_cgroup_init);
+EXPORT_SYMBOL(is_container_init);
 
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
