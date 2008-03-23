Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbYCWI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbYCWI35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbYCWIJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:41 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2284 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759130AbYCWIJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:39 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 100/148] include/asm-x86/processor.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:15 -0700
Message-Id: <1206259443-13210-101-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/processor.h |   73 ++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 958106c..7b1e3a8 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -175,12 +175,12 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (*eax), "2" (*ecx));
+	asm("cpuid"
+	    : "=a" (*eax),
+	      "=b" (*ebx),
+	      "=c" (*ecx),
+	      "=d" (*edx)
+	    : "0" (*eax), "2" (*ecx));
 }
 
 static inline void load_cr3(pgd_t *pgdir)
@@ -430,17 +430,23 @@ static inline unsigned long native_get_debugreg(int regno)
 
 	switch (regno) {
 	case 0:
-		asm("mov %%db0, %0" :"=r" (val)); break;
+		asm("mov %%db0, %0" :"=r" (val));
+		break;
 	case 1:
-		asm("mov %%db1, %0" :"=r" (val)); break;
+		asm("mov %%db1, %0" :"=r" (val));
+		break;
 	case 2:
-		asm("mov %%db2, %0" :"=r" (val)); break;
+		asm("mov %%db2, %0" :"=r" (val));
+		break;
 	case 3:
-		asm("mov %%db3, %0" :"=r" (val)); break;
+		asm("mov %%db3, %0" :"=r" (val));
+		break;
 	case 6:
-		asm("mov %%db6, %0" :"=r" (val)); break;
+		asm("mov %%db6, %0" :"=r" (val));
+		break;
 	case 7:
-		asm("mov %%db7, %0" :"=r" (val)); break;
+		asm("mov %%db7, %0" :"=r" (val));
+		break;
 	default:
 		BUG();
 	}
@@ -481,14 +487,14 @@ static inline void native_set_iopl_mask(unsigned mask)
 #ifdef CONFIG_X86_32
 	unsigned int reg;
 
-	__asm__ __volatile__ ("pushfl;"
-			      "popl %0;"
-			      "andl %1, %0;"
-			      "orl %2, %0;"
-			      "pushl %0;"
-			      "popfl"
-				: "=&r" (reg)
-				: "i" (~X86_EFLAGS_IOPL), "r" (mask));
+	asm volatile ("pushfl;"
+		      "popl %0;"
+		      "andl %1, %0;"
+		      "orl %2, %0;"
+		      "pushl %0;"
+		      "popfl"
+		      : "=&r" (reg)
+		      : "i" (~X86_EFLAGS_IOPL), "r" (mask));
 #endif
 }
 
@@ -526,8 +532,8 @@ static inline void native_swapgs(void)
 #define set_debugreg(value, register)				\
 	native_set_debugreg(register, value)
 
-static inline void
-load_sp0(struct tss_struct *tss, struct thread_struct *thread)
+static inline void load_sp0(struct tss_struct *tss,
+			    struct thread_struct *thread)
 {
 	native_load_sp0(tss, thread);
 }
@@ -683,7 +689,7 @@ static inline unsigned int cpuid_edx(unsigned int op)
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
 static inline void rep_nop(void)
 {
-	__asm__ __volatile__("rep; nop" ::: "memory");
+	asm volatile("rep; nop" ::: "memory");
 }
 
 static inline void cpu_relax(void)
@@ -697,32 +703,29 @@ static inline void sync_core(void)
 	int tmp;
 
 	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-					  : "ebx", "ecx", "edx", "memory");
+		     : "ebx", "ecx", "edx", "memory");
 }
 
-static inline void
-__monitor(const void *eax, unsigned long ecx, unsigned long edx)
+static inline void __monitor(const void *eax, unsigned long ecx,
+			     unsigned long edx)
 {
 	/* "monitor %eax, %ecx, %edx;" */
-	asm volatile(
-		".byte 0x0f, 0x01, 0xc8;"
-		:: "a" (eax), "c" (ecx), "d"(edx));
+	asm volatile(".byte 0x0f, 0x01, 0xc8;"
+		     :: "a" (eax), "c" (ecx), "d"(edx));
 }
 
 static inline void __mwait(unsigned long eax, unsigned long ecx)
 {
 	/* "mwait %eax, %ecx;" */
-	asm volatile(
-		".byte 0x0f, 0x01, 0xc9;"
-		:: "a" (eax), "c" (ecx));
+	asm volatile(".byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
 }
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
 	/* "mwait %eax, %ecx;" */
-	asm volatile(
-		"sti; .byte 0x0f, 0x01, 0xc9;"
-		:: "a" (eax), "c" (ecx));
+	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
 }
 
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
-- 
1.5.4.rc2

