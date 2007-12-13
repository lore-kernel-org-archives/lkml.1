Return-Path: <linux-kernel-owner+w=401wt.eu-S934496AbXLNAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496AbXLNAAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765038AbXLMX6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:58:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:43831 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934151AbXLMX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:58:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="237491354"
Message-Id: <20071213235711.224801000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:44 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 01/12] PAT 64b: Add cpu_shutdown() support
Content-Disposition: inline; filename=cpu_shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't do anything yet.
  
Based on a earlier patch by Eric Biederman and Andi Kleen.

Simple forward port of cpu-shutdown.patch to x86 tree.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6/arch/x86/kernel/reboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/reboot_64.c	2007-12-11 03:30:35.000000000 -0800
+++ linux-2.6/arch/x86/kernel/reboot_64.c	2007-12-11 03:30:46.000000000 -0800
@@ -113,6 +113,7 @@
 #endif
 
 	disable_IO_APIC();
+	cpu_shutdown();
 
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-12-11 03:30:35.000000000 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-12-11 03:30:46.000000000 -0800
@@ -293,3 +293,7 @@
 
 	raw_local_save_flags(kernel_eflags);
 }
+
+void cpu_shutdown(void)
+{
+}
Index: linux-2.6/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_64.h	2007-12-11 03:30:35.000000000 -0800
+++ linux-2.6/include/asm-x86/processor_64.h	2007-12-11 03:30:46.000000000 -0800
@@ -100,6 +100,7 @@
 extern char ignore_irq13;
 
 extern void identify_cpu(struct cpuinfo_x86 *);
+extern void cpu_shutdown(void);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
Index: linux-2.6/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp_64.c	2007-10-25 02:45:41.000000000 -0700
+++ linux-2.6/arch/x86/kernel/smp_64.c	2007-12-11 03:36:31.000000000 -0800
@@ -471,6 +471,7 @@
 	 */
 	cpu_clear(smp_processor_id(), cpu_online_map);
 	disable_local_APIC();
+	cpu_shutdown();
 	for (;;) 
 		halt();
 } 

-- 
