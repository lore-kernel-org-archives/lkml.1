Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbZFLNnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbZFLNnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764917AbZFLNbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:21 -0400
Received: from ozlabs.org ([203.10.76.45]:55298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764444AbZFLNbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:19 -0400
CC: Richard Henderson <rth@twiddle.net>
CC: Russell King <rmk@arm.linux.org.uk>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 7/7] cpumask: remove arch_send_call_function_ipi
Message-Id: <20090612133107.6C534DDDE2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now everyone is converted to arch_send_call_function_ipi_mask, remove
the shim and the #defines.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/include/asm/smp.h    |    1 -
 arch/arm/include/asm/smp.h      |    1 -
 arch/ia64/include/asm/smp.h     |    1 -
 arch/m32r/include/asm/smp.h     |    1 -
 arch/mips/include/asm/smp.h     |    1 -
 arch/parisc/include/asm/smp.h   |    1 -
 arch/powerpc/include/asm/smp.h  |    1 -
 arch/s390/include/asm/smp.h     |    1 -
 arch/sh/include/asm/smp.h       |    1 -
 arch/sparc/include/asm/smp_64.h |    1 -
 arch/x86/include/asm/smp.h      |    1 -
 kernel/smp.c                    |    7 -------
 12 files changed, 18 deletions(-)

diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -48,7 +48,6 @@ extern int smp_num_cpus;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else /* CONFIG_SMP */
 
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -98,7 +98,6 @@ extern void platform_cpu_enable(unsigned
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 /*
  * Local timer interrupt handling function (can be IPI'ed).
diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -127,7 +127,6 @@ extern int is_multithreading_enabled(voi
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else /* CONFIG_SMP */
 
diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
--- a/arch/m32r/include/asm/smp.h
+++ b/arch/m32r/include/asm/smp.h
@@ -89,7 +89,6 @@ extern unsigned long send_IPI_mask_phys(
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif	/* not __ASSEMBLY__ */
 
diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -59,6 +59,5 @@ extern asmlinkage void smp_call_function
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASM_SMP_H */
diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -30,7 +30,6 @@ extern void smp_send_all_nop(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* !ASSEMBLY */
 
diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -147,7 +147,6 @@ extern struct smp_ops_t *smp_ops;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -88,7 +88,6 @@ extern int smp_cpu_polarization[];
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif
 
diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -44,7 +44,6 @@ void plat_send_ipi(unsigned int cpu, uns
 
 void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else
 
diff --git a/arch/sparc/include/asm/smp_64.h b/arch/sparc/include/asm/smp_64.h
--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -36,7 +36,6 @@ extern int sparc64_multi_core;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 /*
  *	General functions that each host system must provide.
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -121,7 +121,6 @@ static inline void arch_send_call_functi
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	smp_ops.send_call_func_ipi(mask);
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -335,13 +335,6 @@ void __smp_call_function_single(int cpu,
 	generic_exec_single(cpu, data, wait);
 }
 
-/* Deprecated: shim for archs using old arch_send_call_function_ipi API. */
-
-#ifndef arch_send_call_function_ipi_mask
-# define arch_send_call_function_ipi_mask(maskp) \
-	 arch_send_call_function_ipi(*(maskp))
-#endif
-
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).

