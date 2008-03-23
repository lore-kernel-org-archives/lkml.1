Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYCWIVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYCWIVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbYCWIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:54 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2264 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbYCWIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:50 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 057/148] include/asm-x86/kexec.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:32 -0700
Message-Id: <1206259443-13210-58-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/kexec.h |   71 +++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/include/asm-x86/kexec.h b/include/asm-x86/kexec.h
index c90d3c7..8f855a1 100644
--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -94,10 +94,9 @@ static inline void crash_fixup_ss_esp(struct pt_regs *newregs,
 {
 #ifdef CONFIG_X86_32
 	newregs->sp = (unsigned long)&(oldregs->sp);
-	__asm__ __volatile__(
-			"xorl %%eax, %%eax\n\t"
-			"movw %%ss, %%ax\n\t"
-			:"=a"(newregs->ss));
+	asm volatile("xorl %%eax, %%eax\n\t"
+		     "movw %%ss, %%ax\n\t"
+		     :"=a"(newregs->ss));
 #endif
 }
 
@@ -114,39 +113,39 @@ static inline void crash_setup_regs(struct pt_regs *newregs,
 		crash_fixup_ss_esp(newregs, oldregs);
 	} else {
 #ifdef CONFIG_X86_32
-		__asm__ __volatile__("movl %%ebx,%0" : "=m"(newregs->bx));
-		__asm__ __volatile__("movl %%ecx,%0" : "=m"(newregs->cx));
-		__asm__ __volatile__("movl %%edx,%0" : "=m"(newregs->dx));
-		__asm__ __volatile__("movl %%esi,%0" : "=m"(newregs->si));
-		__asm__ __volatile__("movl %%edi,%0" : "=m"(newregs->di));
-		__asm__ __volatile__("movl %%ebp,%0" : "=m"(newregs->bp));
-		__asm__ __volatile__("movl %%eax,%0" : "=m"(newregs->ax));
-		__asm__ __volatile__("movl %%esp,%0" : "=m"(newregs->sp));
-		__asm__ __volatile__("movl %%ss, %%eax;" :"=a"(newregs->ss));
-		__asm__ __volatile__("movl %%cs, %%eax;" :"=a"(newregs->cs));
-		__asm__ __volatile__("movl %%ds, %%eax;" :"=a"(newregs->ds));
-		__asm__ __volatile__("movl %%es, %%eax;" :"=a"(newregs->es));
-		__asm__ __volatile__("pushfl; popl %0" :"=m"(newregs->flags));
+		asm volatile("movl %%ebx,%0" : "=m"(newregs->bx));
+		asm volatile("movl %%ecx,%0" : "=m"(newregs->cx));
+		asm volatile("movl %%edx,%0" : "=m"(newregs->dx));
+		asm volatile("movl %%esi,%0" : "=m"(newregs->si));
+		asm volatile("movl %%edi,%0" : "=m"(newregs->di));
+		asm volatile("movl %%ebp,%0" : "=m"(newregs->bp));
+		asm volatile("movl %%eax,%0" : "=m"(newregs->ax));
+		asm volatile("movl %%esp,%0" : "=m"(newregs->sp));
+		asm volatile("movl %%ss, %%eax;" :"=a"(newregs->ss));
+		asm volatile("movl %%cs, %%eax;" :"=a"(newregs->cs));
+		asm volatile("movl %%ds, %%eax;" :"=a"(newregs->ds));
+		asm volatile("movl %%es, %%eax;" :"=a"(newregs->es));
+		asm volatile("pushfl; popl %0" :"=m"(newregs->flags));
 #else
-		__asm__ __volatile__("movq %%rbx,%0" : "=m"(newregs->bx));
-		__asm__ __volatile__("movq %%rcx,%0" : "=m"(newregs->cx));
-		__asm__ __volatile__("movq %%rdx,%0" : "=m"(newregs->dx));
-		__asm__ __volatile__("movq %%rsi,%0" : "=m"(newregs->si));
-		__asm__ __volatile__("movq %%rdi,%0" : "=m"(newregs->di));
-		__asm__ __volatile__("movq %%rbp,%0" : "=m"(newregs->bp));
-		__asm__ __volatile__("movq %%rax,%0" : "=m"(newregs->ax));
-		__asm__ __volatile__("movq %%rsp,%0" : "=m"(newregs->sp));
-		__asm__ __volatile__("movq %%r8,%0" : "=m"(newregs->r8));
-		__asm__ __volatile__("movq %%r9,%0" : "=m"(newregs->r9));
-		__asm__ __volatile__("movq %%r10,%0" : "=m"(newregs->r10));
-		__asm__ __volatile__("movq %%r11,%0" : "=m"(newregs->r11));
-		__asm__ __volatile__("movq %%r12,%0" : "=m"(newregs->r12));
-		__asm__ __volatile__("movq %%r13,%0" : "=m"(newregs->r13));
-		__asm__ __volatile__("movq %%r14,%0" : "=m"(newregs->r14));
-		__asm__ __volatile__("movq %%r15,%0" : "=m"(newregs->r15));
-		__asm__ __volatile__("movl %%ss, %%eax;" :"=a"(newregs->ss));
-		__asm__ __volatile__("movl %%cs, %%eax;" :"=a"(newregs->cs));
-		__asm__ __volatile__("pushfq; popq %0" :"=m"(newregs->flags));
+		asm volatile("movq %%rbx,%0" : "=m"(newregs->bx));
+		asm volatile("movq %%rcx,%0" : "=m"(newregs->cx));
+		asm volatile("movq %%rdx,%0" : "=m"(newregs->dx));
+		asm volatile("movq %%rsi,%0" : "=m"(newregs->si));
+		asm volatile("movq %%rdi,%0" : "=m"(newregs->di));
+		asm volatile("movq %%rbp,%0" : "=m"(newregs->bp));
+		asm volatile("movq %%rax,%0" : "=m"(newregs->ax));
+		asm volatile("movq %%rsp,%0" : "=m"(newregs->sp));
+		asm volatile("movq %%r8,%0" : "=m"(newregs->r8));
+		asm volatile("movq %%r9,%0" : "=m"(newregs->r9));
+		asm volatile("movq %%r10,%0" : "=m"(newregs->r10));
+		asm volatile("movq %%r11,%0" : "=m"(newregs->r11));
+		asm volatile("movq %%r12,%0" : "=m"(newregs->r12));
+		asm volatile("movq %%r13,%0" : "=m"(newregs->r13));
+		asm volatile("movq %%r14,%0" : "=m"(newregs->r14));
+		asm volatile("movq %%r15,%0" : "=m"(newregs->r15));
+		asm volatile("movl %%ss, %%eax;" :"=a"(newregs->ss));
+		asm volatile("movl %%cs, %%eax;" :"=a"(newregs->cs));
+		asm volatile("pushfq; popq %0" :"=m"(newregs->flags));
 #endif
 		newregs->ip = (unsigned long)current_text_addr();
 	}
-- 
1.5.4.rc2

