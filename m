Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbZFLNlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbZFLNlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZFLNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:12 -0400
Received: from ozlabs.org ([203.10.76.45]:55302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764677AbZFLNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:06 -0400
CC: linux-kernel@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 6/7] cpumask: arch_send_call_function_ipi_mask: s390
Message-Id: <20090612133108.2138CDDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/s390/include/asm/smp.h |    3 ++-
 arch/s390/kernel/smp.c      |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -87,7 +87,8 @@ extern struct mutex smp_cpu_state_mutex;
 extern int smp_cpu_polarization[];
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -129,11 +129,11 @@ static void smp_ext_bitcall(int cpu, ec_
 		udelay(10);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		smp_ext_bitcall(cpu, ec_call_function);
 }
 

