Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZJEA5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZJEA5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbZJEAzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:55:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbZJEAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 06/21] es7000_32.c: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:33 -0700
Message-Id: <0a4480e0e4e8d1e63450e49e7e7171d981ea9d31.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted a few printk(KERN_INFO to pr_info(
Stripped "es7000_mipcfg" from pr_debug

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/apic/es7000_32.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 89174f8..4a59ae8 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -27,6 +27,9 @@
  *
  * http://www.unisys.com
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
@@ -223,9 +226,9 @@ static int parse_unisys_oem(char *oemptr)
 			mip_addr = val;
 			mip = (struct mip_reg *)val;
 			mip_reg = __va(mip);
-			pr_debug("es7000_mipcfg: host_reg = 0x%lx \n",
+			pr_debug("host_reg = 0x%lx\n",
 				 (unsigned long)host_reg);
-			pr_debug("es7000_mipcfg: mip_reg = 0x%lx \n",
+			pr_debug("mip_reg = 0x%lx\n",
 				 (unsigned long)mip_reg);
 			success++;
 			break;
@@ -401,7 +404,7 @@ static void es7000_enable_apic_mode(void)
 	if (!es7000_plat)
 		return;
 
-	printk(KERN_INFO "ES7000: Enabling APIC mode.\n");
+	pr_info("Enabling APIC mode.\n");
 	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
 	es7000_mip_reg.off_0x00 = MIP_SW_APIC;
 	es7000_mip_reg.off_0x38 = MIP_VALID;
@@ -514,8 +517,7 @@ static void es7000_setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 
-	printk(KERN_INFO
-	  "Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
+	pr_info("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
 			"Physical Cluster" : "Logical Cluster",
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
-- 
1.6.3.1.10.g659a0.dirty

