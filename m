Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbXLCRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbXLCRGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXLCRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:06:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbXLCRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:06:13 -0500
Date: Mon, 3 Dec 2007 12:06:11 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, wim@iguana.be, dzickus@redhat.com,
       clalance@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20071203170611.4651.89732.sendpatchset@prarit.boston.redhat.com>
Subject: PATCH: Remove endflag in NMI smp_call_function call
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Wim, I'm not sure if you're the right person to get this or not.  Nothing else
 came close in the MAINTAINERS file ....)

'endflag' is globally defined -- Passing endflag into smp_call_function is no
longer necessary.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index f5cc47c..50ba4e6 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -89,7 +89,7 @@ static int __init check_nmi_watchdog(void)
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+		smp_call_function(nmi_cpu_busy, NULL, 0, 0);
 
 	for_each_possible_cpu(cpu)
 		prev_nmi_count[cpu] = per_cpu(irq_stat, cpu).__nmi_count;
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index a576fd7..0443068 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -97,7 +97,7 @@ int __init check_nmi_watchdog (void)
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+		smp_call_function(nmi_cpu_busy, NULL, 0, 0);
 #endif
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++)
