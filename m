Return-Path: <linux-kernel-owner+w=401wt.eu-S1764710AbYCSUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764710AbYCSUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYCSTit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbYCSTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:34 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 23/79] [PATCH] unify extern masks declaration
Date: Wed, 19 Mar 2008 14:25:18 -0300
Message-Id: <12059476802159-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947675605-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

take them off smp_{32,64}.h and move to smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   12 ++++++++++++
 include/asm-x86/smp_32.h |    8 --------
 include/asm-x86/smp_64.h |   11 -----------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index b4c5143..d02e6ea 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -3,12 +3,24 @@
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <asm/percpu.h>
 
 extern cpumask_t cpu_callout_map;
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
+extern u16 x86_cpu_to_apicid_init[];
+extern u16 x86_bios_cpu_apicid_init[];
+extern void *x86_cpu_to_apicid_early_ptr;
+extern void *x86_bios_cpu_apicid_early_ptr;
+
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
+DECLARE_PER_CPU(cpumask_t, cpu_core_map);
+DECLARE_PER_CPU(u16, cpu_llc_id);
+DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
+DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
+
 /*
  * Trampoline 80x86 program as an array.
  */
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 51624ab..478f556 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -21,14 +21,6 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
 
-extern u16 __initdata x86_cpu_to_apicid_init[];
-extern void *x86_cpu_to_apicid_early_ptr;
-
-DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_t, cpu_core_map);
-DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
-
 #ifdef CONFIG_SMP
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 394c785..1b3c0f1 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -19,17 +19,6 @@ extern cpumask_t cpu_callin_map;
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-extern u16 __initdata x86_cpu_to_apicid_init[];
-extern u16 __initdata x86_bios_cpu_apicid_init[];
-extern void *x86_cpu_to_apicid_early_ptr;
-extern void *x86_bios_cpu_apicid_early_ptr;
-
-DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_t, cpu_core_map);
-DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
-DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
-
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
 	if (cpu_present(mps_cpu))
-- 
1.5.0.6

