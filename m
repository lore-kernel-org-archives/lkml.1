Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZA1X63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZA1X63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbZA1Xon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:37609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474AbZA1Xol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:41 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 038/114] x86, apic: clean up ->init_apic_ldr()
Date: Wed, 28 Jan 2009 23:41:44 +0000
Message-Id: <1233186180-29883-39-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 +-
 arch/x86/include/asm/es7000/apic.h            |    4 ++--
 arch/x86/include/asm/mach-default/mach_apic.h |    3 +--
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    2 +-
 arch/x86/kernel/apic.c                        |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    4 ++--
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 9164512..8194130 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -46,7 +46,7 @@ static inline unsigned long calculate_ldr(int cpu)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static inline void init_apic_ldr(void)
+static inline void bigsmp_init_apic_ldr(void)
 {
 	unsigned long val;
 	int cpu = smp_processor_id();
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 847008a..06f5757 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -52,7 +52,7 @@ static inline unsigned long calculate_ldr(int cpu)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static inline void init_apic_ldr_cluster(void)
+static inline void es7000_init_apic_ldr_cluster(void)
 {
 	unsigned long val;
 	int cpu = smp_processor_id();
@@ -62,7 +62,7 @@ static inline void init_apic_ldr_cluster(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline void init_apic_ldr(void)
+static inline void es7000_init_apic_ldr(void)
 {
 	unsigned long val;
 	int cpu = smp_processor_id();
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 9c56542..23e0a2d 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -19,7 +19,6 @@ static inline const struct cpumask *default_target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define init_apic_ldr (apic->init_apic_ldr)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define phys_pkg_id	(apic->phys_pkg_id)
@@ -36,7 +35,7 @@ extern void setup_apic_routing(void);
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static inline void init_apic_ldr(void)
+static inline void default_init_apic_ldr(void)
 {
 	unsigned long val;
 
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index e94881a..8e51f41 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define init_apic_ldr (apic->init_apic_ldr)
 #define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
 #define multi_timer_check (apic->multi_timer_check)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index defee34..8022974 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -28,7 +28,7 @@ static inline int numaq_apic_id_registered(void)
 	return 1;
 }
 
-static inline void init_apic_ldr(void)
+static inline void numaq_init_apic_ldr(void)
 {
 	/* Already done in NUMA-Q firmware */
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 51df002..9108c89 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -37,7 +37,7 @@ static inline unsigned long summit_check_apicid_present(int bit)
 
 extern u8 cpu_2_logical_apicid[];
 
-static inline void init_apic_ldr(void)
+static inline void summit_init_apic_ldr(void)
 {
 	unsigned long val, id;
 	int count = 0;
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 3853ed7..b707793 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1179,7 +1179,7 @@ void __cpuinit setup_local_APIC(void)
 	 * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
 	 * document number 292116).  So here it goes...
 	 */
-	init_apic_ldr();
+	apic->init_apic_ldr();
 
 	/*
 	 * Set Task Priority to 'accept all'. We never change this
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 391cc99..7b7fc47 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -75,7 +75,7 @@ struct genapic apic_bigsmp = {
 	.check_apicid_present		= bigsmp_check_apicid_present,
 
 	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
-	.init_apic_ldr			= init_apic_ldr,
+	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 6adc3c6..633e848 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -56,7 +56,7 @@ struct genapic apic_default = {
 	.check_apicid_present		= default_check_apicid_present,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
-	.init_apic_ldr			= init_apic_ldr,
+	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index bc1f21c..b70833e 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -24,7 +24,7 @@ void __init es7000_update_genapic_to_cluster(void)
 	apic->irq_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
 	apic->irq_dest_mode = INT_DEST_MODE_CLUSTER;
 
-	apic->init_apic_ldr = init_apic_ldr_cluster;
+	apic->init_apic_ldr = es7000_init_apic_ldr_cluster;
 
 	apic->cpu_mask_to_apicid = cpu_mask_to_apicid_cluster;
 }
@@ -117,7 +117,7 @@ struct genapic apic_es7000 = {
 	.check_apicid_present		= es7000_check_apicid_present,
 
 	.vector_allocation_domain	= es7000_vector_allocation_domain,
-	.init_apic_ldr			= init_apic_ldr,
+	.init_apic_ldr			= es7000_init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 712882f..a06fda5 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -62,7 +62,7 @@ struct genapic apic_numaq = {
 	.check_apicid_present		= numaq_check_apicid_present,
 
 	.vector_allocation_domain	= numaq_vector_allocation_domain,
-	.init_apic_ldr			= init_apic_ldr,
+	.init_apic_ldr			= numaq_init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 1834887..36c552f 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -55,7 +55,7 @@ struct genapic apic_summit = {
 	.check_apicid_present		= summit_check_apicid_present,
 
 	.vector_allocation_domain	= summit_vector_allocation_domain,
-	.init_apic_ldr			= init_apic_ldr,
+	.init_apic_ldr			= summit_init_apic_ldr,
 
 	.ioapic_phys_id_map		= ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_routing,
-- 
1.6.0.2

