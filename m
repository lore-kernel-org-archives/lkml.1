Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYADSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYADSa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYADSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:30:20 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:52219 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYADSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:30:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=CAjaYoCxOGc5lqW2m5EedzXYHfYoSybItS+igSocn3anJ5jAzCa+TUJ6NaTMTry+pJx4W8sGStT6JS7TEKX30SwnDEjxYAQoBWGFNyFGT8W+JPzeRatjlAN73FebFe8FsbfMK4dVe97XfxgQUNhm21YoDYym3N5r13m+Qtv4vnU=
Date: Fri, 4 Jan 2008 19:30:13 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] exit: Fix a number of Codying style violations
Message-ID: <20080104193013.07106b05@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a number of Codying style violations.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 kernel/exit.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 549c055..044154c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,9 +50,9 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-extern void sem_exit (void);
+extern void sem_exit(void);
 
-static void exit_mm(struct task_struct * tsk);
+static void exit_mm(struct task_struct *tsk);
 
 static void __unhash_process(struct task_struct *p)
 {
@@ -128,7 +128,7 @@ static void __exit_signal(struct task_struct *tsk)
 	rcu_read_unlock();
 
 	__cleanup_sighand(sighand);
-	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
+	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	flush_sigqueue(&tsk->pending);
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
@@ -142,7 +142,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
-void release_task(struct task_struct * p)
+void release_task(struct task_struct *p)
 {
 	struct task_struct *leader;
 	int zap_leader;
@@ -341,7 +341,6 @@ int allow_signal(int sig)
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
-
 EXPORT_SYMBOL(allow_signal);
 
 int disallow_signal(int sig)
@@ -355,7 +354,6 @@ int disallow_signal(int sig)
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
-
 EXPORT_SYMBOL(disallow_signal);
 
 /*
@@ -411,10 +409,9 @@ void daemonize(const char *name, ...)
 
 	reparent_to_kthreadd();
 }
-
 EXPORT_SYMBOL(daemonize);
 
-static void close_files(struct files_struct * files)
+static void close_files(struct files_struct *files)
 {
 	int i, j;
 	struct fdtable *fdt;
@@ -435,7 +432,7 @@ static void close_files(struct files_struct * files)
 		set = fdt->open_fds->fds_bits[j++];
 		while (set) {
 			if (set & 1) {
-				struct file * file = xchg(&fdt->fd[i], NULL);
+				struct file *file = xchg(&fdt->fd[i], NULL);
 				if (file) {
 					filp_close(file, files);
 					cond_resched();
@@ -478,7 +475,6 @@ void fastcall put_files_struct(struct files_struct *files)
 		free_fdtable(fdt);
 	}
 }
-
 EXPORT_SYMBOL(put_files_struct);
 
 void reset_files_struct(struct task_struct *tsk, struct files_struct *files)
@@ -495,7 +491,7 @@ EXPORT_SYMBOL(reset_files_struct);
 
 static void __exit_files(struct task_struct *tsk)
 {
-	struct files_struct * files = tsk->files;
+	struct files_struct *files = tsk->files;
 
 	if (files) {
 		task_lock(tsk);
@@ -533,7 +529,7 @@ void put_fs_struct(struct fs_struct *fs)
 
 static void __exit_fs(struct task_struct *tsk)
 {
-	struct fs_struct * fs = tsk->fs;
+	struct fs_struct *fs = tsk->fs;
 
 	if (fs) {
 		task_lock(tsk);
@@ -547,14 +543,13 @@ void exit_fs(struct task_struct *tsk)
 {
 	__exit_fs(tsk);
 }
-
 EXPORT_SYMBOL_GPL(exit_fs);
 
 /*
  * Turn us into a lazy TLB process if we
  * aren't already..
  */
-static void exit_mm(struct task_struct * tsk)
+static void exit_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 
@@ -705,7 +700,7 @@ static void forget_original_parent(struct task_struct *father)
 			reparent_thread(p, father, 0);
 		} else {
 			/* reparent ptraced task to its real parent */
-			__ptrace_unlink (p);
+			__ptrace_unlink(p);
 			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
 			    thread_group_empty(p))
 				do_notify_parent(p, p->exit_signal);
@@ -768,7 +763,7 @@ static void exit_notify(struct task_struct *tsk)
 	/*
 	 * This does two things:
 	 *
-  	 * A.  Make init inherit all the child processes
+	 * A.  Make init inherit all the child processes
 	 * B.  Check to see if any process groups have become orphaned
 	 *	as a result of our exiting, and if they have any stopped
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
@@ -1052,7 +1047,6 @@ fastcall NORET_TYPE void do_exit(long code)
 	for (;;)
 		cpu_relax();	/* For when BUG is null */
 }
-
 EXPORT_SYMBOL_GPL(do_exit);
 
 NORET_TYPE void complete_and_exit(struct completion *comp, long code)
@@ -1062,7 +1056,6 @@ NORET_TYPE void complete_and_exit(struct completion *comp, long code)
 
 	do_exit(code);
 }
-
 EXPORT_SYMBOL(complete_and_exit);
 
 asmlinkage long sys_exit(int error_code)
@@ -1537,7 +1530,7 @@ static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
 	int flag, retval;
 	int allowed, denied;
 
-	add_wait_queue(&current->signal->wait_chldexit,&wait);
+	add_wait_queue(&current->signal->wait_chldexit, &wait);
 repeat:
 	/*
 	 * We will set this flag if we see any child that might later
@@ -1596,10 +1589,10 @@ repeat:
 					goto end;
 				break;
 			default:
-			// case EXIT_DEAD:
+			/* case EXIT_DEAD: */
 				if (p->exit_state == EXIT_DEAD)
 					continue;
-			// case EXIT_ZOMBIE:
+			/* case EXIT_ZOMBIE: */
 				if (p->exit_state == EXIT_ZOMBIE) {
 					/*
 					 * Eligible but we cannot release
@@ -1664,7 +1657,7 @@ check_continued:
 		retval = denied;
 end:
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wait);
 	if (infop) {
 		if (retval > 0)
 		retval = 0;
-- 
1.5.4.rc2.17.g257f

