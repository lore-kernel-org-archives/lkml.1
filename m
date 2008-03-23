Return-Path: <linux-kernel-owner+w=401wt.eu-S1763505AbYCWIkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763505AbYCWIkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbYCWIKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:31 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2306 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759778AbYCWIK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:27 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 038/148] include/asm-x86/genapic_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:13 -0700
Message-Id: <1206259443-13210-39-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/genapic_32.h |   89 +++++++++++++++++++++---------------------
 1 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index b501ae7..5fa893d 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -18,18 +18,18 @@ struct mpc_config_bus;
 struct mp_config_table;
 struct mpc_config_processor;
 
-struct genapic { 
-	char *name; 
-	int (*probe)(void); 
+struct genapic {
+	char *name;
+	int (*probe)(void);
 
 	int (*apic_id_registered)(void);
 	cpumask_t (*target_cpus)(void);
 	int int_delivery_mode;
-	int int_dest_mode; 
+	int int_dest_mode;
 	int ESR_DISABLE;
 	int apic_destination_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
-	unsigned long (*check_apicid_present)(int apicid); 
+	unsigned long (*check_apicid_present)(int apicid);
 	int no_balance_irq;
 	int no_ioapic_check;
 	void (*init_apic_ldr)(void);
@@ -37,21 +37,21 @@ struct genapic {
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid); 
+	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
-	void (*setup_portio_remap)(void); 
+	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
 	void (*enable_apic_mode)(void);
 	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
 
 	/* mpparse */
 	/* When one of the next two hooks returns 1 the genapic
-	   is switched to this. Essentially they are additional probe 
+	   is switched to this. Essentially they are additional probe
 	   functions. */
-	int (*mps_oem_check)(struct mp_config_table *mpc, char *oem, 
-			      char *productid);
+	int (*mps_oem_check)(struct mp_config_table *mpc, char *oem,
+			     char *productid);
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	unsigned (*get_apic_id)(unsigned long x);
@@ -64,7 +64,7 @@ struct genapic {
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
-}; 
+};
 
 #define APICFUNC(x) .x = x,
 
@@ -77,39 +77,40 @@ struct genapic {
 #define IPIFUNC(x)
 #endif
 
-#define APIC_INIT(aname, aprobe) { \
-	.name = aname, \
-	.probe = aprobe, \
-	.int_delivery_mode = INT_DELIVERY_MODE, \
-	.int_dest_mode = INT_DEST_MODE, \
-	.no_balance_irq = NO_BALANCE_IRQ, \
-	.ESR_DISABLE = esr_disable, \
-	.apic_destination_logical = APIC_DEST_LOGICAL, \
-	APICFUNC(apic_id_registered) \
-	APICFUNC(target_cpus) \
-	APICFUNC(check_apicid_used) \
-	APICFUNC(check_apicid_present) \
-	APICFUNC(init_apic_ldr) \
-	APICFUNC(ioapic_phys_id_map) \
-	APICFUNC(setup_apic_routing) \
-	APICFUNC(multi_timer_check) \
-	APICFUNC(apicid_to_node) \
-	APICFUNC(cpu_to_logical_apicid) \
-	APICFUNC(cpu_present_to_apicid) \
-	APICFUNC(apicid_to_cpu_present) \
-	APICFUNC(setup_portio_remap) \
-	APICFUNC(check_phys_apicid_present) \
-	APICFUNC(mps_oem_check) \
-	APICFUNC(get_apic_id) \
-	.apic_id_mask = APIC_ID_MASK, \
-	APICFUNC(cpu_mask_to_apicid) \
-	APICFUNC(acpi_madt_oem_check) \
-	IPIFUNC(send_IPI_mask) \
-	IPIFUNC(send_IPI_allbutself) \
-	IPIFUNC(send_IPI_all) \
-	APICFUNC(enable_apic_mode) \
-	APICFUNC(phys_pkg_id) \
-	}
+#define APIC_INIT(aname, aprobe)			\
+{							\
+	.name = aname,					\
+	.probe = aprobe,				\
+	.int_delivery_mode = INT_DELIVERY_MODE,		\
+	.int_dest_mode = INT_DEST_MODE,			\
+	.no_balance_irq = NO_BALANCE_IRQ,		\
+	.ESR_DISABLE = esr_disable,			\
+	.apic_destination_logical = APIC_DEST_LOGICAL,	\
+	APICFUNC(apic_id_registered)			\
+	APICFUNC(target_cpus)				\
+	APICFUNC(check_apicid_used)			\
+	APICFUNC(check_apicid_present)			\
+	APICFUNC(init_apic_ldr)				\
+	APICFUNC(ioapic_phys_id_map)			\
+	APICFUNC(setup_apic_routing)			\
+	APICFUNC(multi_timer_check)			\
+	APICFUNC(apicid_to_node)			\
+	APICFUNC(cpu_to_logical_apicid)			\
+	APICFUNC(cpu_present_to_apicid)			\
+	APICFUNC(apicid_to_cpu_present)			\
+	APICFUNC(setup_portio_remap)			\
+	APICFUNC(check_phys_apicid_present)		\
+	APICFUNC(mps_oem_check)				\
+	APICFUNC(get_apic_id)				\
+	.apic_id_mask = APIC_ID_MASK,			\
+	APICFUNC(cpu_mask_to_apicid)			\
+	APICFUNC(acpi_madt_oem_check)			\
+	IPIFUNC(send_IPI_mask)				\
+	IPIFUNC(send_IPI_allbutself)			\
+	IPIFUNC(send_IPI_all)				\
+	APICFUNC(enable_apic_mode)			\
+	APICFUNC(phys_pkg_id)				\
+}
 
 extern struct genapic *genapic;
 
-- 
1.5.4.rc2

