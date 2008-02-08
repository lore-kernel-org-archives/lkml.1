Return-Path: <linux-kernel-owner+w=401wt.eu-S935858AbYBHUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858AbYBHUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935450AbYBHUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935437AbYBHUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VX7MA0CKl1CMtljTu924qEPuWbO/tZZO/N9OqzPlk++V+Qv+YlwTpIP9fFnMR4mNfatLE0VgT+3ge/SHFKQUVXurjzOms6HZdEI5pCN2kGKGX76nt8a8HpMA+Paz+jCN910FpWTwOHs0vPgOdabZiXY/EQya3vutS4NrxnaCSMQ=
Subject: [PATCH 9/9] x86: define DEBUG_SIG in signal_64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:10:03 -0800
Message-Id: <1202501403.12966.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it more like signal_32.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_64.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 40b30cd..6278083 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -28,7 +28,7 @@
 #include <asm/mce.h>
 #include "sigframe.h"
 
-/* #define DEBUG_SIG 1 */
+#define DEBUG_SIG 0
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
@@ -142,7 +142,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
 
-#ifdef DEBUG_SIG
+#if DEBUG_SIG
 	printk("%d sigreturn ip:%lx sp:%lx frame:%p ax:%lx\n",current->pid,regs->ip,regs->sp,frame,ax);
 #endif
 
@@ -274,7 +274,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto give_sigsegv;
 
-#ifdef DEBUG_SIG
+#if DEBUG_SIG
 	printk("%d old ip %lx old sp %lx old ax %lx\n", current->pid,regs->ip,regs->sp,regs->ax);
 #endif
 
@@ -302,7 +302,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->flags &= ~X86_EFLAGS_TF;
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
-#ifdef DEBUG_SIG
+#if DEBUG_SIG
 	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
 #endif
@@ -324,7 +324,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 {
 	int ret;
 
-#ifdef DEBUG_SIG
+#if DEBUG_SIG
 	printk("handle_signal pid:%d sig:%lu ip:%lx sp:%lx regs=%p\n",
 		current->pid, sig,
 		regs->ip, regs->sp, regs);
@@ -463,7 +463,7 @@ static void do_signal(struct pt_regs *regs)
 void do_notify_resume(struct pt_regs *regs, void *unused,
 		      __u32 thread_info_flags)
 {
-#ifdef DEBUG_SIG
+#if DEBUG_SIG
 	printk("do_notify_resume flags:%x ip:%lx sp:%lx caller:%p pending:%x\n",
 	       thread_info_flags, regs->ip, regs->sp, __builtin_return_address(0),signal_pending(current));
 #endif
-- 
1.5.4.1219.g65b9

