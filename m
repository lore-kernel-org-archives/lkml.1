Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbYEVVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbYEVVVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYEVVVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:21:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888AbYEVVVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:21:41 -0400
Date: Thu, 22 May 2008 17:21:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] debug printk infrastructure -convert cpufreq
Message-ID: <20080522212108.GI28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    1 +
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c    |    1 +
 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c         |    1 +
 arch/x86/kernel/cpu/cpufreq/longhaul.c           |    1 +
 arch/x86/kernel/cpu/cpufreq/longrun.c            |    1 +
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    1 +
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c        |    1 +
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    1 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    1 +
 arch/x86/kernel/cpu/cpufreq/sc520_freq.c         |    1 +
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    1 +
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    1 +
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c      |    1 +
 drivers/cpufreq/cpufreq.c                        |    5 +++--
 drivers/cpufreq/cpufreq_performance.c            |    1 +
 drivers/cpufreq/cpufreq_powersave.c              |    1 +
 drivers/cpufreq/cpufreq_userspace.c              |    1 +
 include/linux/cpufreq.h                          |    3 ++-
 18 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index e2d870d..a16b416 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -768,6 +768,7 @@ static int __init acpi_cpufreq_init(void)
 {
 	int ret;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	dprintk("acpi_cpufreq_init\n");
 
 	ret = acpi_cpufreq_early_init();
diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index f03e915..45580b1 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -422,6 +422,7 @@ static int __init nforce2_init(void)
 		return -ENODEV;
 	}
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	return cpufreq_register_driver(&nforce2_driver);
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
index 9d9eae8..dcc7748 100644
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -446,6 +446,7 @@ static int __init cpufreq_gx_init(void)
 	struct gxfreq_params *params;
 	struct pci_dev *gx_pci;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	/* Test if we have the right hardware */
 	if ((gx_pci = gx_detect_chipset()) == NULL)
 		return -ENODEV;
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index 06fcce5..fec8b57 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -430,6 +430,7 @@ static int __init longhaul_get_ranges(void)
 	unsigned int ratio;
 	int mult;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	/* Get current frequency */
 	mult = longhaul_get_cpu_mult();
 	if (mult == -1) {
diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c b/arch/x86/kernel/cpu/cpufreq/longrun.c
index af4a867..be771e3 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -300,6 +300,7 @@ static int __init longrun_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	if (c->x86_vendor != X86_VENDOR_TRANSMETA ||
 	    !cpu_has(c, X86_FEATURE_LONGRUN))
 		return -ENODEV;
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 199e4e0..794c0e1 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -282,6 +282,7 @@ static int __init cpufreq_p4_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int ret;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	/*
 	 * THERM_CONTROL is architectural for IA32 now, so
 	 * we can rely on the capability checks
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index eb9b62b..efd6a35 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -217,6 +217,7 @@ static int __init powernow_k6_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	if ((c->x86_vendor != X86_VENDOR_AMD) || (c->x86 != 5) ||
 		((c->x86_model != 12) && (c->x86_model != 13)))
 		return -ENODEV;
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 0a61159..f508f62 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -678,6 +678,7 @@ static struct cpufreq_driver powernow_driver = {
 
 static int __init powernow_init (void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	if (check_powernow()==0)
 		return -ENODEV;
 	return cpufreq_register_driver(&powernow_driver);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 46d4034..9839f6f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1286,6 +1286,7 @@ static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	for_each_online_cpu(i) {
 		if (check_supported_cpu(i))
 			supported_cpus++;
diff --git a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
index 42da9bd..eeb0706 100644
--- a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
+++ b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
@@ -154,6 +154,7 @@ static int __init sc520_freq_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int err;
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	/* Test if we have the right hardware */
 	if(c->x86_vendor != X86_VENDOR_AMD ||
 				c->x86 != 4 || c->x86_model != 9) {
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 908dd34..2b11d78 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -615,6 +615,7 @@ static int __init centrino_init(void)
 {
 	struct cpuinfo_x86 *cpu = &cpu_data(0);
 
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	if (!cpu_has(cpu, X86_FEATURE_EST))
 		return -ENODEV;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 1b50244..172746a 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -393,6 +393,7 @@ static struct cpufreq_driver speedstep_driver = {
  */
 static int __init speedstep_init(void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	/* detect processor */
 	speedstep_processor = speedstep_detect_processor();
 	if (!speedstep_processor) {
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8a85c93..4b40cf1 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -361,6 +361,7 @@ static struct cpufreq_driver speedstep_driver = {
  */
 static int __init speedstep_init(void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	speedstep_processor = speedstep_detect_processor();
 
 	switch (speedstep_processor) {
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 35a26a3..ea54337 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 /*********************************************************************
  *                     UNIFIED DEBUG HELPERS                         *
  *********************************************************************/
-#ifdef CONFIG_CPU_FREQ_DEBUG
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK)
 
 /* what part(s) of the CPUfreq subsystem are debugged? */
 static unsigned int debug;
@@ -224,7 +224,7 @@ void cpufreq_debug_printk(unsigned int type, const char *prefix,
 	unsigned long flags;
 
 	WARN_ON(!prefix);
-	if (type & debug) {
+	if (dev_dbg_enabled(type)) {
 		spin_lock_irqsave(&disable_ratelimit_lock, flags);
 		if (!disable_ratelimit && debug_ratelimit
 					&& !printk_ratelimit()) {
@@ -1889,6 +1889,7 @@ static int __init cpufreq_core_init(void)
 {
 	int cpu;
 
+	register_dev_dbg_handler(NULL, TYPE_FLAG, NULL, debug);
 	for_each_possible_cpu(cpu) {
 		per_cpu(policy_cpu, cpu) = -1;
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..266967d 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -46,6 +46,7 @@ EXPORT_SYMBOL(cpufreq_gov_performance);
 
 static int __init cpufreq_gov_performance_init(void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	return cpufreq_register_governor(&cpufreq_gov_performance);
 }
 
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 13fe06b..e896d15 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -44,6 +44,7 @@ static struct cpufreq_governor cpufreq_gov_powersave = {
 
 static int __init cpufreq_gov_powersave_init(void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	return cpufreq_register_governor(&cpufreq_gov_powersave);
 }
 
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index cb2ac01..76889fc 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -191,6 +191,7 @@ EXPORT_SYMBOL(cpufreq_gov_userspace);
 
 static int __init cpufreq_gov_userspace_init(void)
 {
+	register_dev_dbg_handler("cpufreq", NULL, NULL, NULL);
 	return cpufreq_register_governor(&cpufreq_gov_userspace);
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ddd8652..ec05304 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -366,8 +366,9 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 #define CPUFREQ_DEBUG_DRIVER	2
 #define CPUFREQ_DEBUG_GOVERNOR	4
 
-#ifdef CONFIG_CPU_FREQ_DEBUG
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK)
 
+#define DEBUG 1
 extern void cpufreq_debug_printk(unsigned int type, const char *prefix, 
 				 const char *fmt, ...);
 
-- 
1.5.4.5

