Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYG1VQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYG1VQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbYG1VJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:45 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbYG1VJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:43 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 18/24] x86: kernel/signal_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:25 -0300
Message-Id: <1217279371-4410-19-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-16-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-17-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces and tabs.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/signal_64.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index b45ef8d..4b7e082 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -42,9 +42,9 @@
 #endif
 
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-               sigset_t *set, struct pt_regs * regs); 
+               sigset_t *set, struct pt_regs * regs);
 int ia32_setup_frame(int sig, struct k_sigaction *ka,
-            sigset_t *set, struct pt_regs * regs); 
+            sigset_t *set, struct pt_regs * regs);
 
 asmlinkage long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
@@ -189,7 +189,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
 
@@ -201,7 +201,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 badframe:
 	signal_fault(regs,frame,"sigreturn");
 	return 0;
-}	
+}
 
 /*
  * Set up a signal frame.
@@ -267,32 +267,32 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			   sigset_t *set, struct pt_regs * regs)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL; 
+	struct _fpstate __user *fp = NULL;
 	int err = 0;
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate)); 
+		fp = get_stack(ka, regs, sizeof(struct _fpstate));
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
 		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 			goto give_sigsegv;
 
-		if (save_i387(fp) < 0) 
-			err |= -1; 
+		if (save_i387(fp) < 0)
+			err |= -1;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	if (ka->sa.sa_flags & SA_SIGINFO) { 
+	if (ka->sa.sa_flags & SA_SIGINFO) {
 		err |= copy_siginfo_to_user(&frame->info, info);
 		if (err)
 			goto give_sigsegv;
 	}
-		
+
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
@@ -302,9 +302,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
 	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
-	if (sizeof(*set) == 16) { 
+	if (sizeof(*set) == 16) {
 		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]); 
+		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
 	} else
 		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
@@ -315,7 +315,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
 	} else {
 		/* could use a vstub here */
-		goto give_sigsegv; 
+		goto give_sigsegv;
 	}
 
 	if (err)
@@ -323,7 +323,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->di = sig;
-	/* In case the signal handler was declared without prototypes */ 
+	/* In case the signal handler was declared without prototypes */
 	regs->ax = 0;
 
 	/* This also works for non SA_SIGINFO handlers because they expect the
@@ -376,7 +376,7 @@ static long current_syscall_ret(struct pt_regs *regs)
 
 /*
  * OK, we're invoking a handler
- */	
+ */
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
@@ -420,7 +420,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 			ret = ia32_setup_rt_frame(sig, ka, info, oldset, regs);
 		else
 			ret = ia32_setup_frame(sig, ka, oldset, regs);
-	} else 
+	} else
 #endif
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
@@ -552,8 +552,8 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
-{ 
-	struct task_struct *me = current; 
+{
+	struct task_struct *me = current;
 	if (show_unhandled_signals && printk_ratelimit()) {
 		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
 	       me->comm,me->pid,where,frame,regs->ip,regs->sp,regs->orig_ax);
@@ -561,5 +561,5 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 		printk("\n");
 	}
 
-	force_sig(SIGSEGV, me); 
-} 
+	force_sig(SIGSEGV, me);
+}
-- 
1.5.4.5

