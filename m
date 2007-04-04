Return-Path: <linux-kernel-owner+w=401wt.eu-S2992756AbXDDJDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992756AbXDDJDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXDDJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:03:53 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:51133 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992756AbXDDJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:03:53 -0400
Subject: [PATCH 4/4] Always ask the hardware to obtain hardware processor
	id - ia64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de, ebiederm@xmission.com,
       horms@verge.net.au, tony.luck@intel.com, vgoyal@in.ibm.com
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 04 Apr 2007 18:03:51 +0900
Message-Id: <1175677431.1888.5.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Always ask the hardware to determine the hardware processor id in both
UP and SMP kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc5-orig/include/asm-ia64/smp.h linux-2.6.21-rc5/include/asm-ia64/smp.h
--- linux-2.6.21-rc5-orig/include/asm-ia64/smp.h	2007-04-04 15:57:31.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-ia64/smp.h	2007-04-04 16:31:36.000000000 +0900
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
@@ -130,7 +130,6 @@ extern int is_multithreading_enabled(voi
 
 #else /* CONFIG_SMP */
 
-#define hard_smp_processor_id()		0
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()
 


