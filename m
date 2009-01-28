Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbZA1X6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbZA1X6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbZA1Xoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:37611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482AbZA1Xom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:42 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 036/114] x86, apic: remove no_balance_irq and no_ioapic_check flags
Date: Wed, 28 Jan 2009 23:41:42 +0000
Message-Id: <1233186180-29883-37-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These flags are completely unused. (the in-kernel IRQ balancer has
been removed from the upstream kernel.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    1 -
 arch/x86/include/asm/es7000/apic.h            |    2 --
 arch/x86/include/asm/genapic.h                |    3 ---
 arch/x86/include/asm/mach-default/mach_apic.h |    2 --
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 --
 arch/x86/include/asm/summit/apic.h            |    2 --
 arch/x86/kernel/genapic_flat_64.c             |    6 ------
 arch/x86/kernel/genx2apic_cluster.c           |    3 ---
 arch/x86/kernel/genx2apic_phys.c              |    3 ---
 arch/x86/kernel/genx2apic_uv_x.c              |    3 ---
 arch/x86/mach-generic/bigsmp.c                |    3 ---
 arch/x86/mach-generic/default.c               |    3 ---
 arch/x86/mach-generic/es7000.c                |    4 ----
 arch/x86/mach-generic/numaq.c                 |    3 ---
 arch/x86/mach-generic/summit.c                |    3 ---
 16 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index bd52d4d..9164512 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -18,7 +18,6 @@ static inline const cpumask_t *bigsmp_target_cpus(void)
 }
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define NO_BALANCE_IRQ		(0)
 
 static inline unsigned long
 bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index cd888da..847008a 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -23,10 +23,8 @@ static inline const cpumask_t *es7000_target_cpus(void)
 #define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
 #define INT_DELIVERY_MODE_CLUSTER	(dest_LowestPrio)
 #define INT_DEST_MODE_CLUSTER		(1) /* logical delivery broadcast to all procs */
-#define NO_BALANCE_IRQ_CLUSTER		(1)
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define NO_BALANCE_IRQ		(0)
 
 static inline unsigned long
 es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index f9d1ec0..661898c 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -34,9 +34,6 @@ struct genapic {
 	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	int no_balance_irq;
-	int no_ioapic_check;
-
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 064bc11..8adccf8 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -17,8 +17,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 } 
 
-#define NO_BALANCE_IRQ (0)
-
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
 #define init_apic_ldr (apic->init_apic_ldr)
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index e035f88..4cb9e2b 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define NO_BALANCE_IRQ (apic->no_balance_irq)
 #define init_apic_ldr (apic->init_apic_ldr)
 #define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 571fdae..defee34 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -12,8 +12,6 @@ static inline const cpumask_t *numaq_target_cpus(void)
 	return &CPU_MASK_ALL;
 }
 
-#define NO_BALANCE_IRQ (1)
-
 static inline unsigned long
 numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 482038b..51df002 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -4,8 +4,6 @@
 #include <asm/smp.h>
 #include <linux/gfp.h>
 
-#define NO_BALANCE_IRQ (0)
-
 /* In clustered mode, the high nibble of APIC ID is a cluster number.
  * The low nibble is a 4-bit bitmap. */
 #define XAPIC_DEST_CPUS_SHIFT	4
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index d22cbda..9446f37 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -189,9 +189,6 @@ struct genapic apic_flat =  {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.no_balance_irq			= 0,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
 
@@ -335,9 +332,6 @@ struct genapic apic_physflat =  {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.no_balance_irq			= 0,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= physflat_vector_allocation_domain,
 	/* not needed, but shouldn't hurt: */
 	.init_apic_ldr			= flat_init_apic_ldr,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index b91a48e..2eeca6e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -191,9 +191,6 @@ struct genapic apic_x2apic_cluster = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.no_balance_irq			= 0,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= x2apic_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index f070e86..be0ee3e 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -187,9 +187,6 @@ struct genapic apic_x2apic_phys = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.no_balance_irq			= 0,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= x2apic_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index c8a8915..68b423f 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -252,9 +252,6 @@ struct genapic apic_x2apic_uv_x = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.no_balance_irq			= 0,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= uv_vector_allocation_domain,
 	.init_apic_ldr			= uv_init_apic_ldr,
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index aa8443f..6da251a 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -74,9 +74,6 @@ struct genapic apic_bigsmp = {
 	.check_apicid_used		= bigsmp_check_apicid_used,
 	.check_apicid_present		= bigsmp_check_apicid_present,
 
-	.no_balance_irq			= NO_BALANCE_IRQ,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 47f6b5b..e89e8c9 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -41,9 +41,6 @@ struct genapic apic_default = {
 	.check_apicid_used		= default_check_apicid_used,
 	.check_apicid_present		= default_check_apicid_present,
 
-	.no_balance_irq			= NO_BALANCE_IRQ,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 5633f32..8e9eeec 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -23,7 +23,6 @@ void __init es7000_update_genapic_to_cluster(void)
 	apic->target_cpus = target_cpus_cluster;
 	apic->irq_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
 	apic->irq_dest_mode = INT_DEST_MODE_CLUSTER;
-	apic->no_balance_irq = NO_BALANCE_IRQ_CLUSTER;
 
 	apic->init_apic_ldr = init_apic_ldr_cluster;
 
@@ -117,9 +116,6 @@ struct genapic apic_es7000 = {
 	.check_apicid_used		= es7000_check_apicid_used,
 	.check_apicid_present		= es7000_check_apicid_present,
 
-	.no_balance_irq			= NO_BALANCE_IRQ,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index d85206d..f909189 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -61,9 +61,6 @@ struct genapic apic_numaq = {
 	.check_apicid_used		= numaq_check_apicid_used,
 	.check_apicid_present		= numaq_check_apicid_present,
 
-	.no_balance_irq			= NO_BALANCE_IRQ,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index f54cf73..99a9bea 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -54,9 +54,6 @@ struct genapic apic_summit = {
 	.check_apicid_used		= summit_check_apicid_used,
 	.check_apicid_present		= summit_check_apicid_present,
 
-	.no_balance_irq			= NO_BALANCE_IRQ,
-	.no_ioapic_check		= 0,
-
 	.vector_allocation_domain	= vector_allocation_domain,
 	.init_apic_ldr			= init_apic_ldr,
 
-- 
1.6.0.2

