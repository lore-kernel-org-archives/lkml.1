Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZA1XxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZA1XxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbZA1XoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:37504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbZA1XoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:10 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 021/114] x86, genapic: rename int_delivery_mode, et. al.
Date: Wed, 28 Jan 2009 23:41:27 +0000
Message-Id: <1233186180-29883-22-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

int_delivery_mode is supposed to mean 'interrupt delivery mode', but
it's quite a misnomer as 'int' we usually think of as an integer type ...

The standard naming for such attributes is 'irq' - so rename the following
fields and macros:

 int_delivery_mode => irq_delivery_mode
 INT_DELIVERY_MODE => IRQ_DELIVERY_MODE
 int_dest_mode     => irq_dest_mode
 INT_DEST_MODE     => IRQ_DEST_MODE

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    4 +-
 arch/x86/include/asm/es7000/apic.h            |    4 +-
 arch/x86/include/asm/genapic.h                |    4 +-
 arch/x86/include/asm/mach-default/mach_apic.h |    8 +++---
 arch/x86/include/asm/mach-generic/mach_apic.h |    4 +-
 arch/x86/include/asm/numaq/apic.h             |    4 +-
 arch/x86/include/asm/summit/apic.h            |    4 +-
 arch/x86/kernel/genapic_flat_64.c             |    8 +++---
 arch/x86/kernel/genx2apic_cluster.c           |    4 +-
 arch/x86/kernel/genx2apic_phys.c              |    4 +-
 arch/x86/kernel/genx2apic_uv_x.c              |    4 +-
 arch/x86/kernel/io_apic.c                     |   30 ++++++++++++------------
 arch/x86/mach-generic/bigsmp.c                |    4 +-
 arch/x86/mach-generic/default.c               |    4 +-
 arch/x86/mach-generic/es7000.c                |    8 +++---
 arch/x86/mach-generic/numaq.c                 |    4 +-
 arch/x86/mach-generic/summit.c                |    4 +-
 17 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 42c56df..8ff8bba 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -21,8 +21,8 @@ static inline const cpumask_t *target_cpus(void)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define INT_DELIVERY_MODE	(dest_Fixed)
-#define INT_DEST_MODE		(0)    /* phys delivery to target proc */
+#define IRQ_DELIVERY_MODE	(dest_Fixed)
+#define IRQ_DEST_MODE		(0)    /* phys delivery to target proc */
 #define NO_BALANCE_IRQ		(0)
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index a1819b5..830e873 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -27,8 +27,8 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ_CLUSTER		(1)
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define INT_DELIVERY_MODE	(dest_Fixed)
-#define INT_DEST_MODE		(0)    /* phys delivery to target procs */
+#define IRQ_DELIVERY_MODE	(dest_Fixed)
+#define IRQ_DEST_MODE		(0)    /* phys delivery to target procs */
 #define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 108abdf..e998e3d 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -23,8 +23,8 @@ struct genapic {
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 	int (*apic_id_registered)(void);
 
-	u32 int_delivery_mode;
-	u32 int_dest_mode;
+	u32 irq_delivery_mode;
+	u32 irq_dest_mode;
 
 	const struct cpumask *(*target_cpus)(void);
 
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 6a454fa..b536479 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -22,8 +22,8 @@ static inline const struct cpumask *target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define INT_DELIVERY_MODE (apic->int_delivery_mode)
-#define INT_DEST_MODE (apic->int_dest_mode)
+#define IRQ_DELIVERY_MODE (apic->irq_delivery_mode)
+#define IRQ_DEST_MODE (apic->irq_dest_mode)
 #define TARGET_CPUS	  (apic->target_cpus())
 #define init_apic_ldr (apic->init_apic_ldr)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
@@ -35,8 +35,8 @@ static inline const struct cpumask *target_cpus(void)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
-#define INT_DELIVERY_MODE dest_LowestPrio
-#define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
+#define IRQ_DELIVERY_MODE dest_LowestPrio
+#define IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
 #define TARGET_CPUS (target_cpus())
 #define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index cc6e9d7..03492f2 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -5,8 +5,8 @@
 
 #define esr_disable (apic->ESR_DISABLE)
 #define NO_BALANCE_IRQ (apic->no_balance_irq)
-#define INT_DELIVERY_MODE (apic->int_delivery_mode)
-#define INT_DEST_MODE (apic->int_dest_mode)
+#define IRQ_DELIVERY_MODE (apic->irq_delivery_mode)
+#define IRQ_DEST_MODE (apic->irq_dest_mode)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (apic->apic_destination_logical)
 #define TARGET_CPUS	  (apic->target_cpus())
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 59b62b1..d885e35 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -15,8 +15,8 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ (1)
 #define esr_disable (1)
 
-#define INT_DELIVERY_MODE dest_LowestPrio
-#define INT_DEST_MODE 0     /* physical delivery on LOCAL quad */
+#define IRQ_DELIVERY_MODE dest_LowestPrio
+#define IRQ_DEST_MODE 0     /* physical delivery on LOCAL quad */
  
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index a36ef6e..0b7d0d1 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -24,8 +24,8 @@ static inline const cpumask_t *target_cpus(void)
 	return &cpumask_of_cpu(0);
 }
 
-#define INT_DELIVERY_MODE (dest_LowestPrio)
-#define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
+#define IRQ_DELIVERY_MODE (dest_LowestPrio)
+#define IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index e923337..0a263d6 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -180,8 +180,8 @@ struct genapic apic_flat =  {
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
-	.int_delivery_mode		= dest_LowestPrio,
-	.int_dest_mode			= (APIC_DEST_LOGICAL != 0),
+	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
 
 	.target_cpus			= flat_target_cpus,
 	.ESR_DISABLE			= 0,
@@ -326,8 +326,8 @@ struct genapic apic_physflat =  {
 	.acpi_madt_oem_check		= physflat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
-	.int_delivery_mode		= dest_Fixed,
-	.int_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_delivery_mode		= dest_Fixed,
+	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= physflat_target_cpus,
 	.ESR_DISABLE			= 0,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index fc855e5..e9ff7dc 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -182,8 +182,8 @@ struct genapic apic_x2apic_cluster = {
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
-	.int_delivery_mode		= dest_LowestPrio,
-	.int_dest_mode			= (APIC_DEST_LOGICAL != 0),
+	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
 
 	.target_cpus			= x2apic_target_cpus,
 	.ESR_DISABLE			= 0,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index c98361f..8141b5a 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -178,8 +178,8 @@ struct genapic apic_x2apic_phys = {
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
-	.int_delivery_mode		= dest_Fixed,
-	.int_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_delivery_mode		= dest_Fixed,
+	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= x2apic_target_cpus,
 	.ESR_DISABLE			= 0,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 94f606f..6a73cad 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -243,8 +243,8 @@ struct genapic apic_x2apic_uv_x = {
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
 	.apic_id_registered		= uv_apic_id_registered,
 
-	.int_delivery_mode		= dest_Fixed,
-	.int_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_delivery_mode		= dest_Fixed,
+	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= uv_target_cpus,
 	.ESR_DISABLE			= 0,
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7283234..5f967b9 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1514,9 +1514,9 @@ static int setup_ioapic_entry(int apic_id, int irq,
 		memset(&irte, 0, sizeof(irte));
 
 		irte.present = 1;
-		irte.dst_mode = INT_DEST_MODE;
+		irte.dst_mode = IRQ_DEST_MODE;
 		irte.trigger_mode = trigger;
-		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.dlvry_mode = IRQ_DELIVERY_MODE;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
 
@@ -1529,8 +1529,8 @@ static int setup_ioapic_entry(int apic_id, int irq,
 	} else
 #endif
 	{
-		entry->delivery_mode = INT_DELIVERY_MODE;
-		entry->dest_mode = INT_DEST_MODE;
+		entry->delivery_mode = IRQ_DELIVERY_MODE;
+		entry->dest_mode = IRQ_DEST_MODE;
 		entry->dest = destination;
 	}
 
@@ -1659,10 +1659,10 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
 	 */
-	entry.dest_mode = INT_DEST_MODE;
+	entry.dest_mode = IRQ_DEST_MODE;
 	entry.mask = 1;					/* mask IRQ now */
 	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
-	entry.delivery_mode = INT_DELIVERY_MODE;
+	entry.delivery_mode = IRQ_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
 	entry.vector = vector;
@@ -3279,9 +3279,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		memset (&irte, 0, sizeof(irte));
 
 		irte.present = 1;
-		irte.dst_mode = INT_DEST_MODE;
+		irte.dst_mode = IRQ_DEST_MODE;
 		irte.trigger_mode = 0; /* edge */
-		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.dlvry_mode = IRQ_DELIVERY_MODE;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
 
@@ -3299,10 +3299,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		msg->address_hi = MSI_ADDR_BASE_HI;
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
-			((INT_DEST_MODE == 0) ?
+			((IRQ_DEST_MODE == 0) ?
 				MSI_ADDR_DEST_MODE_PHYSICAL:
 				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
+			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
 				MSI_ADDR_REDIRECTION_CPU:
 				MSI_ADDR_REDIRECTION_LOWPRI) |
 			MSI_ADDR_DEST_ID(dest);
@@ -3310,7 +3310,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		msg->data =
 			MSI_DATA_TRIGGER_EDGE |
 			MSI_DATA_LEVEL_ASSERT |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
+			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
 				MSI_DATA_DELIVERY_FIXED:
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
@@ -3711,11 +3711,11 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 			HT_IRQ_LOW_BASE |
 			HT_IRQ_LOW_DEST_ID(dest) |
 			HT_IRQ_LOW_VECTOR(cfg->vector) |
-			((INT_DEST_MODE == 0) ?
+			((IRQ_DEST_MODE == 0) ?
 				HT_IRQ_LOW_DM_PHYSICAL :
 				HT_IRQ_LOW_DM_LOGICAL) |
 			HT_IRQ_LOW_RQEOI_EDGE |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
+			((IRQ_DELIVERY_MODE != dest_LowestPrio) ?
 				HT_IRQ_LOW_MT_FIXED :
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
@@ -3763,8 +3763,8 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
 
 	entry->vector = cfg->vector;
-	entry->delivery_mode = INT_DELIVERY_MODE;
-	entry->dest_mode = INT_DEST_MODE;
+	entry->delivery_mode = IRQ_DELIVERY_MODE;
+	entry->dest_mode = IRQ_DEST_MODE;
 	entry->polarity = 0;
 	entry->trigger = 0;
 	entry->mask = 0;
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 17abf5c..c15c1aa 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -64,8 +64,8 @@ struct genapic apic_bigsmp = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
-	.int_delivery_mode		= INT_DELIVERY_MODE,
-	.int_dest_mode			= INT_DEST_MODE,
+	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 1f30559..d32b175 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -31,8 +31,8 @@ struct genapic apic_default = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= default_apic_id_registered,
 
-	.int_delivery_mode		= INT_DELIVERY_MODE,
-	.int_dest_mode			= INT_DEST_MODE,
+	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index d68ca0b..0665389 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -21,8 +21,8 @@
 void __init es7000_update_genapic_to_cluster(void)
 {
 	apic->target_cpus = target_cpus_cluster;
-	apic->int_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
-	apic->int_dest_mode = INT_DEST_MODE_CLUSTER;
+	apic->irq_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
+	apic->irq_dest_mode = INT_DEST_MODE_CLUSTER;
 	apic->no_balance_irq = NO_BALANCE_IRQ_CLUSTER;
 
 	apic->init_apic_ldr = init_apic_ldr_cluster;
@@ -107,8 +107,8 @@ struct genapic apic_es7000 = {
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
 	.apic_id_registered		= es7000_apic_id_registered,
 
-	.int_delivery_mode		= INT_DELIVERY_MODE,
-	.int_dest_mode			= INT_DEST_MODE,
+	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index b22a79b..4019571 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -51,8 +51,8 @@ struct genapic apic_numaq = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= numaq_apic_id_registered,
 
-	.int_delivery_mode		= INT_DELIVERY_MODE,
-	.int_dest_mode			= INT_DEST_MODE,
+	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 744fa1b..946da7a 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -44,8 +44,8 @@ struct genapic apic_summit = {
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
 	.apic_id_registered		= summit_apic_id_registered,
 
-	.int_delivery_mode		= INT_DELIVERY_MODE,
-	.int_dest_mode			= INT_DEST_MODE,
+	.irq_delivery_mode		= IRQ_DELIVERY_MODE,
+	.irq_dest_mode			= IRQ_DEST_MODE,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

