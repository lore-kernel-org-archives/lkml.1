Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYHHRYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYHHRYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYHHRX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:23:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15229 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYHHRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:23:56 -0400
Date: Fri, 8 Aug 2008 10:19:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mark.langsdorf@amd.com, lkml <linux-kernel@vger.kernel.org>
Cc: davej@codemonkey.org.uk, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] powernow-k8: fix build errors
Message-Id: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build when CONFIG_X86_POWERNOW_K8_ACPI=n:
(seems that someone forgot to test this build combo)
(fix 25 of 50 randconfig build errors)

linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1334: error: implicit declaration of function 'powernow_k8_cpu_preinit_acpi'
linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1352: error: 'acpi_perf_data' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20080808.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1331,7 +1331,9 @@ static int __cpuinit powernowk8_init(voi
 	}
 
 	if (supported_cpus == num_online_cpus()) {
+#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 		powernow_k8_cpu_preinit_acpi();
+#endif
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
 			num_online_nodes(),
@@ -1349,7 +1351,9 @@ static void __exit powernowk8_exit(void)
 
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 
+#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	free_percpu(acpi_perf_data);
+#endif
 }
 
 MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");
