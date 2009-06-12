Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbZFLNmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbZFLNmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764591AbZFLNbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:15 -0400
Received: from ozlabs.org ([203.10.76.45]:55292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764585AbZFLNbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:07 -0400
CC: linux-kernel@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 5/7] cpumask: arch_send_call_function_ipi_mask: sh
Message-Id: <20090612133109.90693DDD01@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask(), and by defining
it, the old arch_send_call_function_ipi is defined by the core code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/sh/include/asm/smp.h |    3 ++-
 arch/sh/kernel/smp.c      |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -43,7 +43,8 @@ void plat_send_ipi(unsigned int cpu, uns
 void plat_send_ipi(unsigned int cpu, unsigned int message);
 
 void arch_send_call_function_single_ipi(int cpu);
-void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else
 
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -171,11 +171,11 @@ void smp_send_stop(void)
 	smp_call_function(stop_this_cpu, 0, 0);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		plat_send_ipi(cpu, SMP_MSG_FUNCTION);
 }
 

