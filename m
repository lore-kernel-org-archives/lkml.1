Return-Path: <linux-kernel-owner+w=401wt.eu-S936586AbXGSKKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936586AbXGSKKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbXGSJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:35384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbXGSJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:17 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, johnstul@us.ibm.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [27/58] x86_64: Remove dead code and other janitor work in  tsc.c
Message-Id: <20070719095512.AABFE14E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Remove unused code and variables and do some codingstyle / whitespace
cleanups while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
---

 arch/x86_64/kernel/tsc.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -36,25 +36,9 @@ static inline int check_tsc_unstable(voi
  * first tick after the change will be slightly wrong.
  */
 
-#include <linux/workqueue.h>
-
-static unsigned int cpufreq_delayed_issched = 0;
-static unsigned int cpufreq_init = 0;
-static struct work_struct cpufreq_delayed_get_work;
-
-static void handle_cpufreq_delayed_get(struct work_struct *v)
-{
-	unsigned int cpu;
-	for_each_online_cpu(cpu) {
-		cpufreq_get(cpu);
-	}
-	cpufreq_delayed_issched = 0;
-}
-
-static unsigned int  ref_freq = 0;
-static unsigned long loops_per_jiffy_ref = 0;
-
-static unsigned long tsc_khz_ref = 0;
+static unsigned int  ref_freq;
+static unsigned long loops_per_jiffy_ref;
+static unsigned long tsc_khz_ref;
 
 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				 void *data)
@@ -98,10 +82,8 @@ static struct notifier_block time_cpufre
 
 static int __init cpufreq_tsc(void)
 {
-	INIT_WORK(&cpufreq_delayed_get_work, handle_cpufreq_delayed_get);
-	if (!cpufreq_register_notifier(&time_cpufreq_notifier_block,
-				       CPUFREQ_TRANSITION_NOTIFIER))
-		cpufreq_init = 1;
+	cpufreq_register_notifier(&time_cpufreq_notifier_block,
+				  CPUFREQ_TRANSITION_NOTIFIER);
 	return 0;
 }
 
@@ -123,17 +105,18 @@ __cpuinit int unsynchronized_tsc(void)
 #endif
 	/* Most intel systems have synchronized TSCs except for
 	   multi node systems */
- 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
 #ifdef CONFIG_ACPI
 		/* But TSC doesn't tick in C3 so don't use it there */
-		if (acpi_gbl_FADT.header.length > 0 && acpi_gbl_FADT.C3latency < 1000)
+		if (acpi_gbl_FADT.header.length > 0 &&
+		    acpi_gbl_FADT.C3latency < 1000)
 			return 1;
 #endif
- 		return 0;
+		return 0;
 	}
 
- 	/* Assume multi socket systems are not synchronized */
- 	return num_present_cpus() > 1;
+	/* Assume multi socket systems are not synchronized */
+	return num_present_cpus() > 1;
 }
 
 int __init notsc_setup(char *s)
