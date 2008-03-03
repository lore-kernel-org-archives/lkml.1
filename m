Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYCCRW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYCCRW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbYCCRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516AbYCCRPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:18 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 29/52] adjust types in smpcommon_32.c
Date: Mon,  3 Mar 2008 14:12:57 -0300
Message-Id: <1204564400-17636-30-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-29-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so they can have the same type as x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    6 +++---
 include/asm-x86/smp_32.h     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 579b9b7..5a446f0 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -67,7 +67,7 @@ int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u8, cpu_llc_id) = BAD_APICID;
+DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
@@ -92,10 +92,10 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
-u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
+u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
 			{ [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
-DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
+DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 41b58e0..29f6195 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -21,13 +21,13 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
 
-extern u8 __initdata x86_cpu_to_apicid_init[];
+extern u16 __initdata x86_cpu_to_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
-DECLARE_PER_CPU(u8, cpu_llc_id);
-DECLARE_PER_CPU(u8, x86_cpu_to_apicid);
+DECLARE_PER_CPU(u16, cpu_llc_id);
+DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void cpu_exit_clear(void);
-- 
1.5.0.6

