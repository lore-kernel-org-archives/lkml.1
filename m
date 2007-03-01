Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXCAHSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXCAHSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933024AbXCAHSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:18:00 -0500
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:45695 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbXCAHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:17:58 -0500
Subject: [PATCH 5/5] Move definition of hard_smp_processor_id to asm/smp.h
	- alpha, m32r, powerpc, s390, sparc, sparc64, um
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 16:18:23 +0900
Message-Id: <1172733503.1498.275.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move definition of hard_smp_processor_id to asm/smp.h on alpha, m32r,
powerpc, s390, sparc, sparc64, and um architectures.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc2/include/asm-alpha/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h
--- linux-2.6.21-rc2/include/asm-alpha/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h	2007-03-07 13:34:14.000000000 +0900
@@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
diff -urNp linux-2.6.21-rc2/include/asm-m32r/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-m32r/smp.h
--- linux-2.6.21-rc2/include/asm-m32r/smp.h	2007-03-07 12:04:26.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-m32r/smp.h	2007-03-07 13:39:22.000000000 +0900
@@ -108,6 +108,10 @@ extern unsigned long send_IPI_mask_phys(
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
 
-#endif	/* CONFIG_SMP */
+#else	/* CONFIG_SMP */
+
+#define hard_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
 
 #endif	/* _ASM_M32R_SMP_H */
diff -urNp linux-2.6.21-rc2/include/asm-powerpc/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-powerpc/smp.h
--- linux-2.6.21-rc2/include/asm-powerpc/smp.h	2007-03-07 12:04:26.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-powerpc/smp.h	2007-03-07 13:54:18.000000000 +0900
@@ -83,6 +83,7 @@ extern void __cpu_die(unsigned int cpu);
 
 #else
 /* for UP */
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_maps()
 
 #endif /* CONFIG_SMP */
diff -urNp linux-2.6.21-rc2/include/asm-s390/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-s390/smp.h
--- linux-2.6.21-rc2/include/asm-s390/smp.h	2007-03-07 12:04:26.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-s390/smp.h	2007-03-07 13:43:31.000000000 +0900
@@ -113,6 +113,7 @@ static inline void smp_send_stop(void)
 	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
 }
 
+#define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #define smp_get_cpu(cpu) ({ 0; })
 #define smp_put_cpu(cpu) ({ 0; })
diff -urNp linux-2.6.21-rc2/include/asm-sparc/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-sparc/smp.h
--- linux-2.6.21-rc2/include/asm-sparc/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-sparc/smp.h	2007-03-07 13:36:27.000000000 +0900
@@ -165,6 +165,7 @@ void smp_setup_cpu_possible_map(void);
 
 #else /* SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(SMP) */
diff -urNp linux-2.6.21-rc2/include/asm-sparc64/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-sparc64/smp.h
--- linux-2.6.21-rc2/include/asm-sparc64/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-sparc64/smp.h	2007-03-07 13:48:35.000000000 +0900
@@ -47,6 +47,7 @@ extern void smp_setup_cpu_possible_map(v
 
 #else
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(CONFIG_SMP) */
diff -urNp linux-2.6.21-rc2/include/asm-um/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-um/smp.h
--- linux-2.6.21-rc2/include/asm-um/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-um/smp.h	2007-03-07 13:26:01.000000000 +0900
@@ -24,6 +24,10 @@ extern inline void smp_cpus_done(unsigne
 
 extern struct task_struct *idle_threads[NR_CPUS];
 
+#else
+
+#define hard_smp_processor_id()		0
+
 #endif
 
 #endif


