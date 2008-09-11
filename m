Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYIKE5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYIKE5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYIKE5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:57:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:32784 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYIKE5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ewpK7Ondw3EFqlsFwsUfpu0sK3thwxi7r4ArqMjWZ09d/lGzYaOfm8nprJc3EwaVhY
         3BbZXXNI7Mdnb0tYVQj0ZNj2Xuci4ISvw4OvVxMgpFeugQoSu7zt0psr/7GOfdAm6tKL
         xVLic90ayNYqSik3wSNO/Za0FktweiHk+9rgg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: print out apic id with hex format
Date: Wed, 10 Sep 2008 21:56:46 -0700
Message-Id: <1221109006-4315-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic.c      |    2 +-
 arch/x86/kernel/cpu/amd.c   |    2 +-
 arch/x86/kernel/cpu/intel.c |    2 +-
 arch/x86/kernel/smpboot.c   |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -1586,7 +1586,7 @@ int __init APIC_init_uniprocessor(void)
 	 */
 	if (!cpu_has_apic &&
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
+		printk(KERN_ERR "BIOS bug, local APIC 0x%x not detected!...\n",
 		       boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -249,7 +249,7 @@ static void __cpuinit srat_detect_node(s
 	}
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -174,7 +174,7 @@ static void __cpuinit srat_detect_node(v
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -542,10 +542,10 @@ static inline void __inquire_remote_apic
 	int timeout;
 	u32 status;
 
-	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
+	printk(KERN_INFO "Inquiring remote APIC 0x%x...\n", apicid);
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
+		printk(KERN_INFO "... APIC 0x%x %s: ", apicid, names[i]);
 
 		/*
 		 * Wait for idle.
@@ -871,7 +871,7 @@ do_rest:
 	start_ip = setup_trampoline();
 
 	/* So we see what's up   */
-	printk(KERN_INFO "Booting processor %d/%d ip %lx\n",
+	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
 			  cpu, apicid, start_ip);
 
 	/*
