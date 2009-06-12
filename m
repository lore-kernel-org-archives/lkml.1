Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbZFLNkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbZFLNkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbZFLNbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:09 -0400
Received: from ozlabs.org ([203.10.76.45]:55294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764464AbZFLNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:04 -0400
CC: linux-kernel@vger.kernel.org
To: Jeff Dike <jdike@addtoit.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 12/13] cpumask: use mm_cpumask() wrapper: um
Message-Id: <20090612133106.E0C31DDDD4@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/um/include/asm/mmu_context.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -35,8 +35,8 @@ static inline void switch_mm(struct mm_s
 	unsigned cpu = smp_processor_id();
 
 	if(prev != next){
-		cpu_clear(cpu, prev->cpu_vm_mask);
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_clear(cpu, mm_cpumask(prev));
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 		if(next != &init_mm)
 			__switch_mm(&next->context.id);
 	}

