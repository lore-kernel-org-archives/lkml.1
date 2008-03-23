Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYCWIQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYCWIQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYCWIIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:21 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2250 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758957AbYCWIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:18 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 124/148] include/asm-x86/system.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:39 -0700
Message-Id: <1206259443-13210-125-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/system.h |  223 ++++++++++++++++++++++++----------------------
 1 files changed, 116 insertions(+), 107 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 9161b50..df7133c 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -38,35 +38,33 @@ do {									\
 	 */								\
 	unsigned long ebx, ecx, edx, esi, edi;				\
 									\
-	asm volatile(							\
-		"pushfl			\n\t"	/* save    flags */	\
-		"pushl %%ebp		\n\t"	/* save    EBP   */	\
-		"movl %%esp,%[prev_sp]	\n\t"	/* save    ESP   */	\
-		"movl %[next_sp],%%esp	\n\t"	/* restore ESP   */	\
-		"movl $1f,%[prev_ip]	\n\t"	/* save    EIP   */	\
-		"pushl %[next_ip]	\n\t"	/* restore EIP   */	\
-		"jmp __switch_to	\n"	/* regparm call  */	\
-		"1:			\t"				\
-		"popl %%ebp		\n\t"	/* restore EBP   */	\
-		"popfl			\n"	/* restore flags */	\
+	asm volatile("pushfl\n\t"		/* save    flags */	\
+		     "pushl %%ebp\n\t"		/* save    EBP   */	\
+		     "movl %%esp,%[prev_sp]\n\t"	/* save    ESP   */ \
+		     "movl %[next_sp],%%esp\n\t"	/* restore ESP   */ \
+		     "movl $1f,%[prev_ip]\n\t"	/* save    EIP   */	\
+		     "pushl %[next_ip]\n\t"	/* restore EIP   */	\
+		     "jmp __switch_to\n"	/* regparm call  */	\
+		     "1:\t"						\
+		     "popl %%ebp\n\t"		/* restore EBP   */	\
+		     "popfl\n"			/* restore flags */	\
 									\
-		  /* output parameters */				\
-		: [prev_sp] "=m" (prev->thread.sp),			\
-		  [prev_ip] "=m" (prev->thread.ip),			\
-			    "=a" (last),				\
+		     /* output parameters */				\
+		     : [prev_sp] "=m" (prev->thread.sp),		\
+		       [prev_ip] "=m" (prev->thread.ip),		\
+		       "=a" (last),					\
 									\
-		  /* clobbered output registers: */			\
-		  "=b" (ebx), "=c" (ecx), "=d" (edx),			\
-		  "=S" (esi), "=D" (edi)				\
-									\
-		  /* input parameters: */				\
-		: [next_sp]  "m" (next->thread.sp),			\
-		  [next_ip]  "m" (next->thread.ip),			\
-									\
-		  /* regparm parameters for __switch_to(): */		\
-		  [prev]     "a" (prev),				\
-		  [next]     "d" (next)					\
-	);								\
+		       /* clobbered output registers: */		\
+		       "=b" (ebx), "=c" (ecx), "=d" (edx),		\
+		       "=S" (esi), "=D" (edi)				\
+		       							\
+		       /* input parameters: */				\
+		     : [next_sp]  "m" (next->thread.sp),		\
+		       [next_ip]  "m" (next->thread.ip),		\
+		       							\
+		       /* regparm parameters for __switch_to(): */	\
+		       [prev]     "a" (prev),				\
+		       [next]     "d" (next));				\
 } while (0)
 
 /*
@@ -81,66 +79,77 @@ do {									\
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
 #define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
 
-#define __EXTRA_CLOBBER  \
-	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
-	  "r12", "r13", "r14", "r15"
+#define __EXTRA_CLOBBER					\
+	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11"	\
+	, "r12", "r13", "r14", "r15"
 
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev, next, last) \
-	asm volatile(SAVE_CONTEXT						    \
-	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
-	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
-	     "call __switch_to\n\t"					  \
-	     ".globl thread_return\n"					  \
-	     "thread_return:\n\t"					  \
-	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
-	     "movq %P[task_canary](%%rsi),%%r8\n\t"			  \
-	     "movq %%r8,%%gs:%P[pda_canary]\n\t"			  \
-	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
-	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
-	     "movq %%rax,%%rdi\n\t" 					  \
-	     "jc   ret_from_fork\n\t"					  \
-	     RESTORE_CONTEXT						  \
-	     : "=a" (last)					  	  \
-	     : [next] "S" (next), [prev] "D" (prev),			  \
-	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
-	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
-	       [tif_fork] "i" (TIF_FORK),			  	  \
-	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [task_canary] "i" (offsetof(struct task_struct, stack_canary)),\
-	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent)), \
-	       [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))\
-	     : "memory", "cc" __EXTRA_CLOBBER)
+	asm volatile(SAVE_CONTEXT					\
+		     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */ \
+		     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */ \
+		     "call __switch_to\n\t"				\
+		     ".globl thread_return\n"				\
+		     "thread_return:\n\t"				\
+		     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"		\
+		     "movq %P[task_canary](%%rsi),%%r8\n\t"		\
+		     "movq %%r8,%%gs:%P[pda_canary]\n\t"		\
+		     "movq %P[thread_info](%%rsi),%%r8\n\t"		\
+		     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t" \
+		     "movq %%rax,%%rdi\n\t"				\
+		     "jc   ret_from_fork\n\t"				\
+		     RESTORE_CONTEXT					\
+		     : "=a" (last)					\
+		     : [next] "S" (next), [prev] "D" (prev),		\
+		     [threadrsp]					\
+		       "i" (offsetof(struct task_struct, thread.sp)),	\
+		     [ti_flags]						\
+		       "i" (offsetof(struct thread_info, flags)),	\
+		     [tif_fork]						\
+		       "i" (TIF_FORK),					\
+		     [thread_info]					\
+		       "i" (offsetof(struct task_struct, stack)),	\
+		     [task_canary]					\
+		       "i" (offsetof(struct task_struct, stack_canary)), \
+		     [pda_pcurrent]					\
+		       "i" (offsetof(struct x8664_pda, pcurrent)),	\
+		     [pda_canary]					\
+		       "i" (offsetof(struct x8664_pda, stack_canary))	\
+		     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
 #ifdef __KERNEL__
-#define _set_base(addr, base) do { unsigned long __pr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %%dl,%2\n\t" \
-	"movb %%dh,%3" \
-	:"=&d" (__pr) \
-	:"m" (*((addr)+2)), \
-	 "m" (*((addr)+4)), \
-	 "m" (*((addr)+7)), \
-	 "0" (base) \
-	); } while (0)
-
-#define _set_limit(addr, limit) do { unsigned long __lr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %2,%%dh\n\t" \
-	"andb $0xf0,%%dh\n\t" \
-	"orb %%dh,%%dl\n\t" \
-	"movb %%dl,%2" \
-	:"=&d" (__lr) \
-	:"m" (*(addr)), \
-	 "m" (*((addr)+6)), \
-	 "0" (limit) \
-	); } while (0)
-
-#define set_base(ldt, base) _set_base(((char *)&(ldt)) , (base))
-#define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
+#define _set_base(addr, base)				\
+do {							\
+	unsigned long __pr;				\
+	asm volatile ("movw %%dx,%1\n\t"		\
+		      "rorl $16,%%edx\n\t"		\
+		      "movb %%dl,%2\n\t"		\
+		      "movb %%dh,%3"			\
+		      : "=&d" (__pr)			\
+		      : "m" (*((addr)+2)),		\
+			"m" (*((addr)+4)),		\
+			"m" (*((addr)+7)),		\
+			"0" (base));			\
+} while (0)
+
+#define _set_limit(addr, limit)				\
+do {							\
+	unsigned long __lr;				\
+	asm volatile ("movw %%dx,%1\n\t"		\
+		      "rorl $16,%%edx\n\t"		\
+		      "movb %2,%%dh\n\t"		\
+		      "andb $0xf0,%%dh\n\t"		\
+		      "orb %%dh,%%dl\n\t"		\
+		      "movb %%dl,%2"			\
+		      : "=&d" (__lr)			\
+		      : "m" (*(addr)),			\
+			"m" (*((addr)+6)),		\
+			"0" (limit));			\
+} while (0)
+
+#define set_base(ldt, base) _set_base(((char *)&(ldt)), (base))
+#define set_limit(ldt, limit) _set_limit(((char *)&(ldt)), ((limit) - 1))
 
 extern void load_gs_index(unsigned);
 
@@ -150,35 +159,34 @@ extern void load_gs_index(unsigned);
  */
 #define loadsegment(seg, value)			\
 	asm volatile("\n"			\
-		"1:\t"				\
-		"movl %k0,%%" #seg "\n"		\
-		"2:\n"				\
-		".section .fixup,\"ax\"\n"	\
-		"3:\t"				\
-		"movl %k1, %%" #seg "\n\t"	\
-		"jmp 2b\n"			\
-		".previous\n"			\
-		_ASM_EXTABLE(1b,3b)		\
-		: :"r" (value), "r" (0))
+		     "1:\t"			\
+		     "movl %k0,%%" #seg "\n"	\
+		     "2:\n"			\
+		     ".section .fixup,\"ax\"\n"	\
+		     "3:\t"			\
+		     "movl %k1, %%" #seg "\n\t"	\
+		     "jmp 2b\n"			\
+		     ".previous\n"		\
+		     _ASM_EXTABLE(1b,3b)	\
+		     : :"r" (value), "r" (0))
 
 
 /*
  * Save a segment register away
  */
-#define savesegment(seg, value) \
+#define savesegment(seg, value)				\
 	asm volatile("mov %%" #seg ",%0":"=rm" (value))
 
 static inline unsigned long get_limit(unsigned long segment)
 {
 	unsigned long __limit;
-	__asm__("lsll %1,%0"
-		:"=r" (__limit):"r" (segment));
-	return __limit+1;
+	asm("lsll %1,%0" : "=r" (__limit) : "r" (segment));
+	return __limit + 1;
 }
 
 static inline void native_clts(void)
 {
-	asm volatile ("clts");
+	asm volatile("clts");
 }
 
 /*
@@ -193,43 +201,43 @@ static unsigned long __force_order;
 static inline unsigned long native_read_cr0(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" :"=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
 	return val;
 }
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": :"r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
 }
 
 static inline unsigned long native_read_cr2(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" :"=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
 	return val;
 }
 
 static inline void native_write_cr2(unsigned long val)
 {
-	asm volatile("mov %0,%%cr2": :"r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
 }
 
 static inline unsigned long native_read_cr3(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" :"=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
 	return val;
 }
 
 static inline void native_write_cr3(unsigned long val)
 {
-	asm volatile("mov %0,%%cr3": :"r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
 }
 
 static inline unsigned long native_read_cr4(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr4,%0\n\t" :"=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
 	return val;
 }
 
@@ -241,7 +249,7 @@ static inline unsigned long native_read_cr4_safe(void)
 #ifdef CONFIG_X86_32
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
-		     _ASM_EXTABLE(1b,2b)
+		     _ASM_EXTABLE(1b, 2b)
 		     : "=r" (val), "=m" (__force_order) : "0" (0));
 #else
 	val = native_read_cr4();
@@ -251,7 +259,7 @@ static inline unsigned long native_read_cr4_safe(void)
 
 static inline void native_write_cr4(unsigned long val)
 {
-	asm volatile("mov %0,%%cr4": :"r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
 }
 
 #ifdef CONFIG_X86_64
@@ -272,6 +280,7 @@ static inline void native_wbinvd(void)
 {
 	asm volatile("wbinvd": : :"memory");
 }
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -304,7 +313,7 @@ static inline void clflush(volatile void *__p)
 	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
 }
 
-#define nop() __asm__ __volatile__ ("nop")
+#define nop() asm volatile ("nop")
 
 void disable_hlt(void);
 void enable_hlt(void);
@@ -403,7 +412,7 @@ void default_idle(void);
 # define smp_wmb()	barrier()
 #endif
 #define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
+#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 #else
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
-- 
1.5.4.rc2

