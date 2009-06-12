Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbZFLNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbZFLNkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764823AbZFLNbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:06 -0400
Received: from ozlabs.org ([203.10.76.45]:55290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763106AbZFLNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:04 -0400
CC: linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 9/13] cpumask: use mm_cpumask() wrapper: mn10300
Message-Id: <20090612133106.3340DDDDB2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask
(to be a pointer).

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Also change the actual arg name here to "mm" (which it is), not "task".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/mn10300/include/asm/mmu_context.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -38,13 +38,13 @@ extern unsigned long mmu_context_cache[N
 #define enter_lazy_tlb(mm, tsk)	do {} while (0)
 
 #ifdef CONFIG_SMP
-#define cpu_ran_vm(cpu, task) \
-	cpu_set((cpu), (task)->cpu_vm_mask)
-#define cpu_maybe_ran_vm(cpu, task) \
-	cpu_test_and_set((cpu), (task)->cpu_vm_mask)
+#define cpu_ran_vm(cpu, mm) \
+	cpumask_set_cpu((cpu), mm_cpumask(mm))
+#define cpu_maybe_ran_vm(cpu, mm) \
+	cpumask_test_and_set_cpu((cpu), mm_cpumask(mm))
 #else
-#define cpu_ran_vm(cpu, task)		do {} while (0)
-#define cpu_maybe_ran_vm(cpu, task)	true
+#define cpu_ran_vm(cpu, mm)		do {} while (0)
+#define cpu_maybe_ran_vm(cpu, mm)	true
 #endif /* CONFIG_SMP */
 
 /*

