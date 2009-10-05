Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZJEAyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZJEAyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbZJEAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:54:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1674 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZJEAyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:54:38 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       amd64-microcode@amd64.org
Subject: [PATCH 04/21] microcode: use pr_<level> and add pr_fmt
Date: Sun,  4 Oct 2009 17:53:31 -0700
Message-Id: <05a1529c4fda089020281e09c6684018225da011.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted a few printks to pr_<level>
Added a space after an exclamation point

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/microcode_amd.c   |    5 +++-
 arch/x86/kernel/microcode_core.c  |   23 ++++++++++--------
 arch/x86/kernel/microcode_intel.c |   47 +++++++++++++++---------------------
 3 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 366baa1..85c6b13 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -13,6 +13,9 @@
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/firmware.h>
 #include <linux/pci_ids.h>
 #include <linux/uaccess.h>
@@ -291,7 +294,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 		if (!leftover) {
 			vfree(uci->mc);
 			uci->mc = new_mc;
-			pr_debug("microcode: CPU%d found a matching microcode "
+			pr_debug("CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",
 				 cpu, new_rev, uci->cpu_sig.rev);
 		} else {
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..c7e2bb7 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -70,6 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
@@ -211,7 +214,7 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	if ((len >> PAGE_SHIFT) > totalram_pages) {
-		pr_err("microcode: too much data (max %ld pages)\n", totalram_pages);
+		pr_err("too much data (max %ld pages)\n", totalram_pages);
 		return ret;
 	}
 
@@ -246,7 +249,7 @@ static int __init microcode_dev_init(void)
 
 	error = misc_register(&microcode_dev);
 	if (error) {
-		pr_err("microcode: can't misc_register on minor=%d\n", MICROCODE_MINOR);
+		pr_err("can't misc_register on minor=%d\n", MICROCODE_MINOR);
 		return error;
 	}
 
@@ -361,7 +364,7 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 	if (!uci->mc)
 		return UCODE_NFOUND;
 
-	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
+	pr_debug("CPU%d updated upon resume\n", cpu);
 	apply_microcode_on_target(cpu);
 
 	return UCODE_OK;
@@ -381,7 +384,7 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 
 	if (ustate == UCODE_OK) {
-		pr_debug("microcode: CPU%d updated upon init\n", cpu);
+		pr_debug("CPU%d updated upon init\n", cpu);
 		apply_microcode_on_target(cpu);
 	}
 
@@ -408,7 +411,7 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("microcode: CPU%d added\n", cpu);
+	pr_debug("CPU%d added\n", cpu);
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
@@ -427,7 +430,7 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("microcode: CPU%d removed\n", cpu);
+	pr_debug("CPU%d removed\n", cpu);
 	microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
@@ -475,15 +478,15 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		microcode_update_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		pr_debug("microcode: CPU%d added\n", cpu);
+		pr_debug("CPU%d added\n", cpu);
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
-			pr_err("microcode: Failed to create group for CPU%d\n", cpu);
+			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
-		pr_debug("microcode: CPU%d removed\n", cpu);
+		pr_debug("CPU%d removed\n", cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_UP_CANCELED_FROZEN:
@@ -509,7 +512,7 @@ static int __init microcode_init(void)
 		microcode_ops = init_amd_microcode();
 
 	if (!microcode_ops) {
-		pr_err("microcode: no support for this CPU vendor\n");
+		pr_err("no support for this CPU vendor\n");
 		return -ENODEV;
 	}
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0d334dd..ebd193e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,6 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/firmware.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
@@ -146,8 +149,7 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
 	    cpu_has(c, X86_FEATURE_IA64)) {
-		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
-			"processor\n", cpu_num);
+		pr_err("CPU%d not a capable Intel processor\n", cpu_num);
 		return -1;
 	}
 
@@ -165,8 +167,8 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
-			cpu_num, csig->sig, csig->pf, csig->rev);
+	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+		cpu_num, csig->sig, csig->pf, csig->rev);
 
 	return 0;
 }
@@ -194,28 +196,24 @@ static int microcode_sanity_check(void *mc)
 	data_size = get_datasize(mc_header);
 
 	if (data_size + MC_HEADER_SIZE > total_size) {
-		printk(KERN_ERR "microcode: error! "
-				"Bad data size in microcode data file\n");
+		pr_err("error! Bad data size in microcode data file\n");
 		return -EINVAL;
 	}
 
 	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		printk(KERN_ERR "microcode: error! "
-				"Unknown microcode update format\n");
+		pr_err("error! Unknown microcode update format\n");
 		return -EINVAL;
 	}
 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
 	if (ext_table_size) {
 		if ((ext_table_size < EXT_HEADER_SIZE)
 		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
-			printk(KERN_ERR "microcode: error! "
-				"Small exttable size in microcode data file\n");
+			pr_err("error! Small exttable size in microcode data file\n");
 			return -EINVAL;
 		}
 		ext_header = mc + MC_HEADER_SIZE + data_size;
 		if (ext_table_size != exttable_size(ext_header)) {
-			printk(KERN_ERR "microcode: error! "
-				"Bad exttable size in microcode data file\n");
+			pr_err("error! Bad exttable size in microcode data file\n");
 			return -EFAULT;
 		}
 		ext_sigcount = ext_header->count;
@@ -230,8 +228,7 @@ static int microcode_sanity_check(void *mc)
 		while (i--)
 			ext_table_sum += ext_tablep[i];
 		if (ext_table_sum) {
-			printk(KERN_WARNING "microcode: aborting, "
-				"bad extended signature table checksum\n");
+			pr_warning("aborting, bad extended signature table checksum\n");
 			return -EINVAL;
 		}
 	}
@@ -242,7 +239,7 @@ static int microcode_sanity_check(void *mc)
 	while (i--)
 		orig_sum += ((int *)mc)[i];
 	if (orig_sum) {
-		printk(KERN_ERR "microcode: aborting, bad checksum\n");
+		pr_err("aborting, bad checksum\n");
 		return -EINVAL;
 	}
 	if (!ext_table_size)
@@ -255,7 +252,7 @@ static int microcode_sanity_check(void *mc)
 			- (mc_header->sig + mc_header->pf + mc_header->cksum)
 			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
 		if (sum) {
-			printk(KERN_ERR "microcode: aborting, bad checksum\n");
+			pr_err("aborting, bad checksum\n");
 			return -EINVAL;
 		}
 	}
@@ -327,13 +324,11 @@ static int apply_microcode(int cpu)
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	if (val[1] != mc_intel->hdr.rev) {
-		printk(KERN_ERR "microcode: CPU%d update "
-				"to revision 0x%x failed\n",
-			cpu_num, mc_intel->hdr.rev);
+		pr_err("CPU%d update to revision 0x%x failed\n",
+		       cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
-	printk(KERN_INFO "microcode: CPU%d updated to revision "
-			 "0x%x, date = %04x-%02x-%02x \n",
+	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x \n",
 		cpu_num, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
@@ -362,8 +357,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
 		mc_size = get_totalsize(&mc_header);
 		if (!mc_size || mc_size > leftover) {
-			printk(KERN_ERR "microcode: error!"
-					"Bad data in microcode data file\n");
+			pr_err("error! Bad data in microcode data file\n");
 			break;
 		}
 
@@ -405,9 +399,8 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 		vfree(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
-	pr_debug("microcode: CPU%d found a matching microcode update with"
-		 " version 0x%x (current=0x%x)\n",
-			cpu, new_rev, uci->cpu_sig.rev);
+	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
+		 cpu, new_rev, uci->cpu_sig.rev);
 out:
 	return state;
 }
@@ -429,7 +422,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		c->x86, c->x86_model, c->x86_mask);
 
 	if (request_firmware(&firmware, name, device)) {
-		pr_debug("microcode: data file %s load failed\n", name);
+		pr_debug("data file %s load failed\n", name);
 		return UCODE_NFOUND;
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

