Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbXJYNAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbXJYNAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXJYNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:00:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40451 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXJYNAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:00:36 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2007 18:30:22 +0530
Message-Id: <20071025130022.8720.77346.sendpatchset@balbir-laptop>
Subject: [x86 patch] Fix UML signal.h build errors
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix build errors seen in UML. Replaces #ifdef __i386__ with
#if BITS_PER_LONG == 32

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/asm-x86/signal.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/asm-x86/signal.h~uml-fix-sigaction-build-errors include/asm-x86/signal.h
--- 2.6.24-rc1/include/asm-x86/signal.h~uml-fix-sigaction-build-errors	2007-10-25 18:24:40.000000000 +0530
+++ 2.6.24-rc1-balbir/include/asm-x86/signal.h	2007-10-25 18:27:53.000000000 +0530
@@ -17,7 +17,7 @@ struct siginfo;
 
 #define _NSIG		64
 
-#ifdef __i386__
+#if BITS_PER_LONG == 32
 # define _NSIG_BPW	32
 #else
 # define _NSIG_BPW	64
@@ -121,7 +121,7 @@ typedef unsigned long sigset_t;
 
 #ifndef __ASSEMBLY__
 
-#ifdef __i386__
+#if BITS_PER_LONG == 32
 # ifdef __KERNEL__
 struct old_sigaction {
 	__sighandler_t sa_handler;
@@ -157,7 +157,7 @@ struct sigaction {
 #define sa_sigaction	_u._sa_sigaction
 
 # endif /* ! __KERNEL__ */
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 struct sigaction {
 	__sighandler_t sa_handler;
@@ -170,7 +170,7 @@ struct k_sigaction {
 	struct sigaction sa;
 };
 
-#endif /* !__i386__ */
+#endif /* !BITS_PER_LONG == 32 */
 
 typedef struct sigaltstack {
 	void __user *ss_sp;
@@ -181,12 +181,12 @@ typedef struct sigaltstack {
 #ifdef __KERNEL__
 #include <asm/sigcontext.h>
 
-#ifdef __386__
+#if BITS_PER_LONG == 32
 
 #define __HAVE_ARCH_SIG_BITOPS
 
 #define sigaddset(set,sig)		   \
-	(__builtin_constantp(sig) ?	   \
+	(__builtin_constant_p(sig) ?	   \
 	 __const_sigaddset((set),(sig)) :  \
 	 __gen_sigaddset((set),(sig)))
 
@@ -253,13 +253,13 @@ struct pt_regs;
 		}					\
 	} while (0)
 
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 #undef __HAVE_ARCH_SIG_BITOPS
 
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
 
-#endif /* !__i386__ */
+#endif /* !BITS_PER_LONG == 32 */
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
