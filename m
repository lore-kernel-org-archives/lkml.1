Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZLJInJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZLJInJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZLJInF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:43:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:51672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbZLJInE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:43:04 -0500
Date: Thu, 10 Dec 2009 08:42:34 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <3b4375af246dec5941168858910210937c110af9.1260383912.git.joe@perches.com>
References: <3b4375af246dec5941168858910210937c110af9.1260383912.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: es7000_32.c: Use pr_<level> and add pr_fmt(fmt)
Message-ID: <tip-5cd476effe9570d2e520cf904d51f5c992972647@git.kernel.org>
Git-Commit-ID: 5cd476effe9570d2e520cf904d51f5c992972647
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cd476effe9570d2e520cf904d51f5c992972647
Gitweb:     http://git.kernel.org/tip/5cd476effe9570d2e520cf904d51f5c992972647
Author:     Joe Perches <joe@perches.com>
AuthorDate: Wed, 9 Dec 2009 10:45:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:57:49 +0100

x86: es7000_32.c: Use pr_<level> and add pr_fmt(fmt)

- Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 - Converted a few printk(KERN_INFO to pr_info(
 - Stripped "es7000_mipcfg" from pr_debug

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <3b4375af246dec5941168858910210937c110af9.1260383912.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/es7000_32.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index e85f8fb..dd2b5f2 100644
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
