Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZETSKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZETSKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZETSJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:09:55 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:27167 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754001AbZETSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:09:55 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: change print_once to printk_once
Date: Wed, 20 May 2009 11:09:54 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201109.55072.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the print_once code blocks with the printk_once macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4709ead..1ac90c8 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1221,7 +1221,6 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
 	int rc;
-	static int print_once;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1244,19 +1243,12 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			/*
-			 * Replace this one with print_once as soon as such a
-			 * thing gets introduced
-			 */
-			if (!print_once) {
-				WARN_ONCE(1, KERN_ERR FW_BUG PFX "Your BIOS "
+			printk_once(KERN_ERR FW_BUG PFX "Your BIOS "
 					"does not provide ACPI _PSS objects "
 					"in a way that Linux understands. "
 					"Please report this to the Linux ACPI"
 					" maintainers and complain to your "
 					"BIOS vendor.\n");
-				print_once++;
-			}
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 2ecd95e..909a2ef 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -179,26 +179,18 @@ static struct notifier_block dbs_cpufreq_notifier_block = {
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n",
 		       current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n", current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MIN_SAMPLING_RATE);
 }
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 338f428..3430cdd 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -216,27 +216,19 @@ static void ondemand_powersave_bias_init(void)
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: ondemand sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: ondemand sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n",
 		       current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: ondemand sampling_rate_min "
+	printk_once(KERN_INFO "CPUFREQ: ondemand sampling_rate_min "
 		       "sysfs file is deprecated - used by: %s\n",
 		       current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MIN_SAMPLING_RATE);
 }
 
