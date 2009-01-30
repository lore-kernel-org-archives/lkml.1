Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZA3KVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZA3KVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZA3KR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZA3KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove multi_timer_check
Date: Fri, 30 Jan 2009 11:17:13 +0100
Message-Id: <1233310639-27916-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-7-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Only used by NUMAQ

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/genapic.h      |    1 -
 arch/x86/kernel/bigsmp_32.c         |    1 -
 arch/x86/kernel/es7000_32.c         |    1 -
 arch/x86/kernel/genapic_flat_64.c   |    2 --
 arch/x86/kernel/genx2apic_cluster.c |    1 -
 arch/x86/kernel/genx2apic_phys.c    |    1 -
 arch/x86/kernel/genx2apic_uv_x.c    |    1 -
 arch/x86/kernel/io_apic.c           |    8 --------
 arch/x86/kernel/numaq_32.c          |   10 ----------
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/summit_32.c         |    1 -
 11 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 07bab93..6197803 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -40,7 +40,6 @@ struct genapic {
 	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
 
 	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index 85d72ee..9c1e464 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -228,7 +228,6 @@ struct genapic apic_bigsmp = {
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 770205b..5e1c4aa 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -764,7 +764,6 @@ struct genapic apic_es7000 = {
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
 	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index b42e724..6a00ea8 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -198,7 +198,6 @@ struct genapic apic_flat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
@@ -341,7 +340,6 @@ struct genapic apic_physflat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 6cccd3a..7e01834 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -203,7 +203,6 @@ struct genapic apic_x2apic_cluster = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 17ff29a..b92d60b 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -189,7 +189,6 @@ struct genapic apic_x2apic_phys = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index d46531d..6394b0e 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -262,7 +262,6 @@ struct genapic apic_x2apic_uv_x = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= NULL,
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 3378ffb..9a3e66f 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1602,14 +1602,6 @@ static void __init setup_IO_APIC_irqs(void)
 
 			irq = pin_2_irq(idx, apic_id, pin);
 
-			/*
-			 * Skip the timer IRQ if there's a quirk handler
-			 * installed and if it returns 1:
-			 */
-			if (apic->multi_timer_check &&
-					apic->multi_timer_check(apic_id, irq))
-				continue;
-
 			desc = irq_to_desc_alloc_cpu(irq, cpu);
 			if (!desc) {
 				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 07954d1..73ce5ef 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -415,15 +415,6 @@ static inline void numaq_setup_apic_routing(void)
 		"NUMA-Q", nr_ioapics);
 }
 
-/*
- * Skip adding the timer int on secondary nodes, which causes
- * a small but painful rift in the time-space continuum.
- */
-static inline int numaq_multi_timer_check(int apic, int irq)
-{
-	return apic != 0 && irq == 0;
-}
-
 static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	/* We don't have a good way to do this yet - hack */
@@ -554,7 +545,6 @@ struct genapic apic_numaq = {
 
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
-	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= numaq_apicid_to_node,
 	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index e96b6b2..c296fb4 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -94,7 +94,6 @@ struct genapic apic_default = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= default_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 7b7eeb6..dbb7206 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -564,7 +564,6 @@ struct genapic apic_summit = {
 
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.apicid_to_node			= summit_apicid_to_node,
 	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
-- 
1.5.6.5

