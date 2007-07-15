Return-Path: <linux-kernel-owner+w=401wt.eu-S1763726AbXGOQIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763726AbXGOQIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXGOQFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:00 -0400
Received: from www.osadl.org ([213.239.205.134]:42532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762092AbXGOQE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:57 -0400
Message-Id: <20070715155541.002963248@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch-mm 08/33] x86_64: Remove dead code and other janitor work in
	tsc.c
Content-Disposition: inline;
	filename=x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused code and variables and do some codingstyle / whitespace
cleanups while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
---

 arch/x86_64/kernel/tsc.c |   41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/tsc.c	2007-07-15 17:26:50.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/tsc.c	2007-07-15 17:49:03.000000000 +0200
@@ -35,25 +35,9 @@ static inline int check_tsc_unstable(voi
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
@@ -97,10 +81,8 @@ static struct notifier_block time_cpufre
 
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
 
@@ -108,8 +90,6 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
-static int tsc_unstable = 0;
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -122,17 +102,18 @@ __cpuinit int unsynchronized_tsc(void)
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

-- 

