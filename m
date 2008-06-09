Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbYFIOoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbYFIOoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYFIOoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:44:15 -0400
Received: from sacred.ru ([62.205.161.221]:47780 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYFIOoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:44:15 -0400
Message-ID: <484D4119.1050206@openvz.org>
Date: Mon, 09 Jun 2008 18:41:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] pidns: remove now unused kill_proc function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 09 Jun 2008 18:43:45 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function operated on a pid_t to kill a task, which is
no longer valid in a containerized system.

It has finally lost all its users and we can safely remove 
it from the tree.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 include/linux/sched.h |    1 -
 kernel/signal.c       |   12 ------------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4efb39b..4d877ea 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1792,7 +1792,6 @@ extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
-extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
diff --git a/kernel/signal.c b/kernel/signal.c
index 0514da5..5e5463a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1228,17 +1228,6 @@ int kill_pid(struct pid *pid, int sig, int priv)
 }
 EXPORT_SYMBOL(kill_pid);
 
-int
-kill_proc(pid_t pid, int sig, int priv)
-{
-	int ret;
-
-	rcu_read_lock();
-	ret = kill_pid_info(sig, __si_special(priv), find_pid(pid));
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
@@ -1910,7 +1899,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(kill_proc);
 EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
