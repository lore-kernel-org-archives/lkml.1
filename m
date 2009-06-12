Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZFLNhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZFLNhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764468AbZFLNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:30:58 -0400
Received: from ozlabs.org ([203.10.76.45]:55267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763388AbZFLNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:57 -0400
CC: linux-kernel@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 11/13] cpumask: use mm_cpumask() wrapper: sh
Message-Id: <20090612133058.E6FA7DDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/sh/include/asm/mmu_context.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/mmu_context.h b/arch/sh/include/asm/mmu_context.h
--- a/arch/sh/include/asm/mmu_context.h
+++ b/arch/sh/include/asm/mmu_context.h
@@ -117,11 +117,11 @@ static inline void switch_mm(struct mm_s
 	unsigned int cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 		set_TTB(next->pgd);
 		activate_context(next, cpu);
 	} else
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask))
+		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)))
 			activate_context(next, cpu);
 }
 #else

