Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXCAHRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXCAHRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXCAHRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:17:54 -0500
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:45690 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbXCAHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:17:53 -0500
Subject: [PATCH 4/5] Always ask the hardware to obtain hardware processor
	id - ia64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 16:18:18 +0900
Message-Id: <1172733498.1498.273.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Always ask the hardware to determine the hardware processor id in both UP and SMP kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc2/include/asm-ia64/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-ia64/smp.h
--- linux-2.6.21-rc2/include/asm-ia64/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-ia64/smp.h	2007-03-07 13:03:48.000000000 +0900
@@ -38,6 +38,8 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
+#define hard_smp_processor_id()		ia64_get_lid()
+
 #ifdef CONFIG_SMP
 
 #define XTP_OFFSET		0x1e0008
@@ -110,8 +112,6 @@ max_xtp (void)
 		writeb(0x0f, ipi_base_addr + XTP_OFFSET); /* Set XTP to max */
 }
 
-#define hard_smp_processor_id()		ia64_get_lid()
-
 /* Upping and downing of CPUs */
 extern int __cpu_disable (void);
 extern void __cpu_die (unsigned int cpu);
@@ -128,7 +128,7 @@ extern void unlock_ipi_calllock(void);
 extern void identify_siblings (struct cpuinfo_ia64 *);
 extern int is_multithreading_enabled(void);
 
-#else
+#else /* CONFIG_SMP */
 
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()


