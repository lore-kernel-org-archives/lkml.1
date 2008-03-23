Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYCWIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYCWIRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbYCWII3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2253 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbYCWII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:27 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 043/148] include/asm-x86/i387.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:18 -0700
Message-Id: <1206259443-13210-44-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/i387.h |   94 ++++++++++++++++++++++-------------------------
 1 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index a365de5..d552843 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -42,7 +42,7 @@ static inline void tolerant_fwait(void)
 {
 	asm volatile("1: fwait\n"
 		     "2:\n"
-		     _ASM_EXTABLE(1b,2b));
+		     _ASM_EXTABLE(1b, 2b));
 }
 
 static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
@@ -55,7 +55,7 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
 		     ".previous\n"
-		     _ASM_EXTABLE(1b,3b)
+		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
 #if 0 /* See comment in __save_init_fpu() below. */
 		     : [fx] "r" (fx), "m" (*fx), "0" (0));
@@ -77,11 +77,11 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
 {
 	if (unlikely(fx->swd & X87_FSW_ES))
-		 asm volatile("fnclex");
+		asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
-		     "    emms\n"		/* clear stack tags */
-		     "    fildl %%gs:0",	/* load to clear state */
-		     X86_FEATURE_FXSAVE_LEAK);
+			  "    emms\n"		/* clear stack tags */
+			  "    fildl %%gs:0",	/* load to clear state */
+			  X86_FEATURE_FXSAVE_LEAK);
 }
 
 static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
@@ -94,14 +94,15 @@ static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
 		     ".previous\n"
-		     _ASM_EXTABLE(1b,3b)
+		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
 #if 0 /* See comment in __fxsave_clear() below. */
 		     : [fx] "r" (fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "0" (0));
 #endif
-	if (unlikely(err) && __clear_user(fx, sizeof(struct i387_fxsave_struct)))
+	if (unlikely(err) &&
+	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
 		err = -EFAULT;
 	/* No need to clear here because the caller clears USED_MATH */
 	return err;
@@ -116,21 +117,21 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 #if 0
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+	asm volatile("fxsaveq %0"
+		     : "=m" (tsk->thread.xstate->fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
-	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+	asm volatile("rex64/fxsave %0"
+		     : "=m" (tsk->thread.xstate->fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (tsk->thread.xstate->fxsave)
-			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+	asm volatile("rex64/fxsave (%1)"
+		     : "=m" (tsk->thread.xstate->fxsave)
+		     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
 	clear_fpu_state(&tsk->thread.xstate->fxsave);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
@@ -146,7 +147,7 @@ static inline int save_i387(struct _fpstate __user *buf)
 	int err = 0;
 
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
+		     sizeof(tsk->thread.xstate->fxsave));
 
 	if ((unsigned long)buf % 16)
 		printk("save_i387: bad fpstate %p\n", buf);
@@ -155,8 +156,10 @@ static inline int save_i387(struct _fpstate __user *buf)
 		return 0;
 	clear_used_math(); /* trigger finit */
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)buf);
-		if (err) return err;
+		err = save_i387_checking((struct i387_fxsave_struct __user *)
+					 buf);
+		if (err)
+			return err;
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
@@ -190,14 +193,12 @@ static inline void tolerant_fwait(void)
 static inline void restore_fpu(struct task_struct *tsk)
 {
 	/*
-	 * The "nop" is needed to make the instructions the same
-	 * length.
+	 * The "nop" is needed to make the instructions the same length.
 	 */
-	alternative_input(
-		"nop ; frstor %1",
-		"fxrstor %1",
-		X86_FEATURE_FXSR,
-		"m" (tsk->thread.xstate->fxsave));
+	alternative_input("nop ; frstor %1",
+			  "fxrstor %1",
+			  X86_FEATURE_FXSR,
+			  "m" (tsk->thread.xstate->fxsave));
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -216,22 +217,21 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
-	alternative_input(
-		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-		"fxsave %[fx]\n"
-		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.xstate->fxsave),
-		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+	alternative_input("fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
+			  "fxsave %[fx]\n"
+			  "bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
+			  X86_FEATURE_FXSR,
+			  [fx] "m" (tsk->thread.xstate->fxsave),
+			  [fsw] "m" (tsk->thread.xstate->fxsave.swd)
+			  : "memory");
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
+	alternative_input(GENERIC_NOP8 GENERIC_NOP2,
+			  "emms\n\t"	  	/* clear stack tags */
+			  "fildl %[addr]", 	/* set F?P to defined value */
+			  X86_FEATURE_FXSAVE_LEAK,
+			  [addr] "m" (safe_address));
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -322,29 +322,23 @@ static inline void clear_fpu(struct task_struct *tsk)
  */
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
-	if (cpu_has_fxsr) {
+	if (cpu_has_fxsr)
 		return tsk->thread.xstate->fxsave.cwd;
-	} else {
-		return (unsigned short) tsk->thread.xstate->fsave.cwd;
-	}
+	return (unsigned short)tsk->thread.xstate->fsave.cwd;
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
-	if (cpu_has_fxsr) {
+	if (cpu_has_fxsr)
 		return tsk->thread.xstate->fxsave.swd;
-	} else {
-		return (unsigned short) tsk->thread.xstate->fsave.swd;
-	}
+	return (unsigned short)tsk->thread.xstate->fsave.swd;
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
-	if (cpu_has_xmm) {
+	if (cpu_has_xmm)
 		return tsk->thread.xstate->fxsave.mxcsr;
-	} else {
-		return MXCSR_DEFAULT;
-	}
+	return MXCSR_DEFAULT;
 }
 
 #endif	/* _ASM_X86_I387_H */
-- 
1.5.4.rc2

