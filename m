Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbYCWJBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbYCWJBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760269AbYCWIMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2359 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbYCWILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:48 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 068/148] include/asm-x86/mmu_context_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:43 -0700
Message-Id: <1206259443-13210-69-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmu_context_64.h |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index ad6dc82..ca44c71 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -20,12 +20,12 @@ void destroy_context(struct mm_struct *mm);
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (read_pda(mmu_state) == TLBSTATE_OK) 
+	if (read_pda(mmu_state) == TLBSTATE_OK)
 		write_pda(mmu_state, TLBSTATE_LAZY);
 #endif
 }
 
-static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
 	unsigned cpu = smp_processor_id();
@@ -39,7 +39,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
 
-		if (unlikely(next->context.ldt != prev->context.ldt)) 
+		if (unlikely(next->context.ldt != prev->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
@@ -48,7 +48,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		if (read_pda(active_mm) != next)
 			BUG();
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
-			/* We were in lazy tlb mode and leave_mm disabled 
+			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
@@ -59,13 +59,14 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 #endif
 }
 
-#define deactivate_mm(tsk,mm)	do { \
-	load_gs_index(0); \
-	asm volatile("movl %0,%%fs"::"r"(0));  \
-} while(0)
+#define deactivate_mm(tsk, mm)			\
+do {						\
+	load_gs_index(0);			\
+	asm volatile("movl %0,%%fs"::"r"(0));	\
+} while (0)
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
+#define activate_mm(prev, next)			\
+	switch_mm((prev), (next), NULL)
 
 
 #endif
-- 
1.5.4.rc2

