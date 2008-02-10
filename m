Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYBJHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYBJHNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbYBJHNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:13:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbYBJHNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:13:37 -0500
Date: Sun, 10 Feb 2008 08:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [1/6] pids: add pid_max prototype
Message-ID: <20080210071321.GA3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add pid_max prototype - used by sysctl and will be used by kgdb as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/pid.h |    2 ++
 kernel/sysctl.c     |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-kgdb.q/include/linux/pid.h
===================================================================
--- linux-kgdb.q.orig/include/linux/pid.h
+++ linux-kgdb.q/include/linux/pid.h
@@ -86,6 +86,8 @@ extern struct task_struct *FASTCALL(get_
 
 extern struct pid *get_task_pid(struct task_struct *task, enum pid_type type);
 
+extern int pid_max;
+
 /*
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
Index: linux-kgdb.q/kernel/sysctl.c
===================================================================
--- linux-kgdb.q.orig/kernel/sysctl.c
+++ linux-kgdb.q/kernel/sysctl.c
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
