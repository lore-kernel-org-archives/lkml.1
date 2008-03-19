Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYCSToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYCSToq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYCSTaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbYCSTau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:50 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 06/79] [PATCH] decouple call to print_cpu_info from smp_store_cpu_info
Date: Wed, 19 Mar 2008 14:25:01 -0300
Message-Id: <12059476032561-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059475982810-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This will ease integration with i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 13ab112..1da28c6 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -97,7 +97,6 @@ static void __cpuinit smp_store_cpu_info(int id)
 	*c = boot_cpu_data;
 	c->cpu_index = id;
 	identify_cpu(c);
-	print_cpu_info(c);
 }
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
@@ -568,6 +567,8 @@ do_rest:
 		if (cpu_isset(cpu, cpu_callin_map)) {
 			/* number CPUs logically, starting from 1 (BSP is 0) */
 			Dprintk("CPU has booted.\n");
+			printk(KERN_INFO "CPU%d: ", cpu);
+			print_cpu_info(&cpu_data(cpu));
 		} else {
 			boot_error = 1;
 			if (*((volatile unsigned char *)phys_to_virt(SMP_TRAMPOLINE_BASE))
@@ -751,6 +752,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 
 	setup_boot_clock();
+	printk(KERN_INFO "CPU%d: ", 0);
+	print_cpu_info(&cpu_data(0));
 }
 
 /*
-- 
1.5.0.6

