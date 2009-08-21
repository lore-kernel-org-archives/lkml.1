Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbZHUVdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbZHUVdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbZHUVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:34 -0400
Received: from www.tglx.de ([62.245.132.106]:51950 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951AbZHUVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:32 -0400
Message-Id: <20090821205603.173685499@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:32:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 28/32] x86: time_32/64.c unify profile_pc
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-time-unify-profiling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is identical except for the formatting and a useless
#ifdef. Make it the same.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time_32.c |   13 ++++++-------
 arch/x86/kernel/time_64.c |    8 +++++---
 2 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -33,23 +33,22 @@ unsigned long profile_pc(struct pt_regs 
 {
 	unsigned long pc = instruction_pointer(regs);
 
-#ifdef CONFIG_SMP
 	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
-		unsigned long *sp = (unsigned long *)&regs->sp;
-
-		/* Return address is either directly at stack pointer
-		   or above a saved flags. Eflags has bits 22-31 zero,
-		   kernel addresses don't. */
+		unsigned long *sp = (unsigned long *)regs->sp;
+		/*
+		 * Return address is either directly at stack pointer
+		 * or above a saved flags. Eflags has bits 22-31 zero,
+		 * kernel addresses don't.
+		 */
 		if (sp[0] >> 22)
 			return sp[0];
 		if (sp[1] >> 22)
 			return sp[1];
 #endif
 	}
-#endif
 	return pc;
 }
 EXPORT_SYMBOL(profile_pc);
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -33,14 +33,16 @@ unsigned long profile_pc(struct pt_regs 
 {
 	unsigned long pc = instruction_pointer(regs);
 
-	/* Assume the lock function has either no stack frame or a copy
-	   of flags from PUSHF
-	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
 	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
 		unsigned long *sp = (unsigned long *)regs->sp;
+		/*
+		 * Return address is either directly at stack pointer
+		 * or above a saved flags. Eflags has bits 22-31 zero,
+		 * kernel addresses don't.
+		 */
 		if (sp[0] >> 22)
 			return sp[0];
 		if (sp[1] >> 22)


