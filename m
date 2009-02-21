Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZBUC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZBUC6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 21:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZBUC6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 21:58:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:58772 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBUC6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 21:58:04 -0500
Message-ID: <499F6DB6.3060500@ct.jp.nec.com>
Date: Fri, 20 Feb 2009 18:57:58 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: ia32_signal: remove unused debug code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

DEBUG_SIG will not be used.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index dd77ac0..adc63f8 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -33,8 +33,6 @@
 #include <asm/sigframe.h>
 #include <asm/sys_ia32.h>
 
-#define DEBUG_SIG 0
-
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
 #define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
@@ -220,12 +218,6 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#if DEBUG_SIG
-	printk(KERN_DEBUG "SIG restore_sigcontext: "
-	       "sc=%p err(%x) eip(%x) cs(%x) flg(%x)\n",
-	       sc, sc->err, sc->ip, sc->cs, sc->flags);
-#endif
-
 	get_user_try {
 		/*
 		 * Reload fs and gs if they have changed in the signal
@@ -488,11 +480,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-#if DEBUG_SIG
-	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
-	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
-#endif
-
 	return 0;
 }
 
@@ -574,10 +561,5 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-#if DEBUG_SIG
-	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
-	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
-#endif
-
 	return 0;
 }
-- 
1.6.1.2

