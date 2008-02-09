Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYBINgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYBINgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbYBINf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:60457 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbYBINfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:23 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/8] pid, kgdb: add pid_max prototype
Date: Sat,  9 Feb 2008 07:35:08 -0600
Message-Id: <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:54.0243 (UTC) FILETIME=[8DD06730:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add pid_max prototype - now used by sysctl and kgdb as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/pid.h |    2 ++
 kernel/kgdb.c       |    2 +-
 kernel/sysctl.c     |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index f84d532..e066d3d 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -86,6 +86,8 @@ extern struct task_struct *FASTCALL(get_pid_task(struct pid *pid,
 
 extern struct pid *get_task_pid(struct task_struct *task, enum pid_type type);
 
+extern int pid_max;
+
 /*
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 3f06d09..2986bd2 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -45,6 +45,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/kgdb.h>
+#include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
 
@@ -101,7 +102,6 @@ struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
  * CPU having a lock:
  */
 
-extern int pid_max;
 /* How many times to count all of the waiting CPUs */
 #define ROUNDUP_WAIT		640000	/* Arbitrary, increase if needed. */
 #define BUF_THREAD_ID_SIZE	16
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d41ef6b..97a152c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
+#include <linux/pid.h>
 #include <linux/net.h>
 #include <linux/sysrq.h>
 #include <linux/highuid.h>
@@ -71,7 +72,6 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
-extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
-- 
1.5.4

