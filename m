Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXCAHRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXCAHRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXCAHRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:17:25 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45686 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbXCAHRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:17:24 -0500
Subject: [PATCH 3/5] Use the APIC to determine the hardware processor id -
	x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 16:17:49 +0900
Message-Id: <1172733469.1498.270.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the APIC to determine the hardware processor id in both UP and SMP
kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc2/include/asm-x86_64/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-x86_64/smp.h
--- linux-2.6.21-rc2/include/asm-x86_64/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/asm-x86_64/smp.h	2007-03-07 12:42:47.000000000 +0900
@@ -58,12 +58,6 @@ static inline int num_booting_cpus(void)
 
 #define raw_smp_processor_id() read_pda(cpunumber)
 
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
-}
-
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
@@ -72,7 +66,13 @@ extern unsigned disabled_cpus;
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
+
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
+}
 
 /*
  * Some lowlevel functions might want to know about


