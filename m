Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbZFLNnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbZFLNnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763404AbZFLNbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:16 -0400
Received: from ozlabs.org ([203.10.76.45]:55294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764628AbZFLNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:06 -0400
CC: linux-kernel@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 4/7] cpumask: arch_send_call_function_ipi_mask: powerpc
Message-Id: <20090612133108.A8692DDDA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask(), and by defining
it, the old arch_send_call_function_ipi is defined by the core code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/powerpc/include/asm/smp.h |    3 ++-
 arch/powerpc/kernel/smp.c      |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -139,7 +139,8 @@ extern struct smp_ops_t *smp_ops;
 extern struct smp_ops_t *smp_ops;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -130,11 +130,11 @@ void arch_send_call_function_single_ipi(
 	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
 }
 

