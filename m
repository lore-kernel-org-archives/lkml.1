Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYHDKLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYHDKLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYHDKK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:10:56 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:26698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYHDKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tmOuYt82/nyw9GbIcikfBohzBe6vH4keNDwQHelf+Yp4kOupy9JVEJo5tSmz/Mh53d
         bg8DN6+i2JNdQsvHzR+sSCk+yWrE67z4SPEEXb55vnGQIBKKt9Km+owotjcvPMzkDi62
         5lXjdvjR90hsdi21xv+EPflh1O9vBQWcnxcJg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/04] x86: add get_irq_cfg in io_apic_64.c
Date: Mon,  4 Aug 2008 03:09:59 -0700
Message-Id: <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate size is 32, and if is not enough, get_irq_cfg will more with alloc_bootmem or kzalloc

got:
dyn_array irq_2_pin+0x0/0x8 size:0x8 nr:192 align:0x8
dyn_array irq_cfgx+0x0/0x8 size:0x118 nr:32 align:0x1000
dyn_array irq_desc+0x0/0x8 size:0x180 nr:32 align:0x1000
dyn_array irq_2_iommu+0x0/0x8 size:0x10 nr:96 align:0x1000
dyn_array irq_timer_state+0x0/0x50 size:0x8 nr:96 align:0x1000
dyn_array total_size: 0x8600
dyn_array irq_2_pin+0x0/0x8  ==> [0x28028000 - 0x28028600]
dyn_array irq_cfgx+0x0/0x8  ==> [0x28029000 - 0x2802b300]
dyn_array irq_desc+0x0/0x8  ==> [0x2802c000 - 0x2802f000]
dyn_array irq_2_iommu+0x0/0x8  ==> [0x2802f000 - 0x2802f600]
dyn_array irq_timer_state+0x0/0x50  ==> [0x28030000 - 0x28030300]
...
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 0-0 not connected.
IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 0-16, 0-17, 0-18, 0-19, 0-20, 0-21, 0-22, 0-23, 1-0, 1-1, 1-2, 1-3, 1-4, 1-5, 1-6, 1-7, 1-8, 1-9, 1-10, 1-11, 1-12, 1-13, 1-14, 1-15, 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not connected.
try to get more irq_cfg 32
try to get more irq_cfg 32
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_64.c |  181 +++++++++++++++++++++++++++++++++----------
 1 file changed, 141 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -57,7 +57,11 @@
 
 #define __apicdebuginit(type) static type __init
 
+struct irq_cfg;
+
 struct irq_cfg {
+	unsigned int irq;
+	struct irq_cfg *next;
 	cpumask_t domain;
 	cpumask_t old_domain;
 	unsigned move_cleanup_count;
@@ -67,34 +71,112 @@ struct irq_cfg {
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 static struct irq_cfg irq_cfg_legacy[] __initdata = {
-	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+	[0]  = { .irq =  0, .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
+	[1]  = { .irq =  1, .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
+	[2]  = { .irq =  2, .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
+	[3]  = { .irq =  3, .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
+	[4]  = { .irq =  4, .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
+	[5]  = { .irq =  5, .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
+	[6]  = { .irq =  6, .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
+	[7]  = { .irq =  7, .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
+	[8]  = { .irq =  8, .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
+	[9]  = { .irq =  9, .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
+	[10] = { .irq = 10, .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
+	[11] = { .irq = 11, .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
+	[12] = { .irq = 12, .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
+	[13] = { .irq = 13, .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
+	[14] = { .irq = 14, .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
+	[15] = { .irq = 15, .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-static struct irq_cfg *irq_cfg;
+static struct irq_cfg irq_cfg_init = { .irq =  -1U, };
+/* need to be biger than size of irq_cfg_legacy */
+static int nr_irq_cfg = 32;
+
+static int __init parse_nr_irq_cfg(char *arg)
+{
+	if (arg) {
+		nr_irq_cfg = simple_strtoul(arg, NULL, 0);
+		if (nr_irq_cfg < 32)
+			nr_irq_cfg = 32;
+	}
+	return 0;
+}
+
+early_param("nr_irq_cfg", parse_nr_irq_cfg);
+
+static void init_one_irq_cfg(struct irq_cfg *cfg)
+{
+        memcpy(cfg, &irq_cfg_init, sizeof(struct irq_desc));
+}
 
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
+	struct irq_cfg *cfg;
+	int i;
+
+	cfg = *da->name;
+
+	memcpy(cfg, irq_cfg_legacy, sizeof(irq_cfg_legacy));
 
-	memcpy(*da->name, irq_cfg_legacy, sizeof(irq_cfg_legacy));
+	i = sizeof(irq_cfg_legacy)/sizeof(irq_cfg_legacy[0]);
+	for (; i < *da->nr; i++)
+		init_one_irq_cfg(&cfg[i]);
+
+	for (i = 1; i < *da->nr; i++)
+		cfg[i-1].next = &cfg[i];
 }
 
-DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+static struct irq_cfg *irq_cfgx;
+DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
+
+static struct irq_cfg *get_irq_cfg(unsigned int irq)
+{
+	struct irq_cfg *cfg, *cfg_pri;
+	int i;
+	int count = 0;
+
+	BUG_ON(irq == -1U);
+
+	cfg_pri = cfg = &irq_cfgx[0];
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		if (cfg->irq == -1U) {
+			cfg->irq = irq;
+			return cfg;
+		}
+		cfg_pri = cfg;
+		cfg = cfg->next;
+		count++;
+	}
+
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	printk(KERN_DEBUG "try to get more irq_cfg %d\n", nr_irq_cfg);
+
+	if (after_bootmem)
+		cfg = kzalloc(sizeof(struct irq_cfg)*nr_irq_cfg, GFP_ATOMIC);
+	else
+		cfg = __alloc_bootmem_nopanic(sizeof(struct irq_cfg)*nr_irq_cfg, PAGE_SIZE, 0);
+
+	if (!cfg)
+		panic("please boot with nr_irq_cfg= %d\n", count * 2);
+
+	for (i = 0; i < nr_irq_cfg; i++)
+		init_one_irq_cfg(&cfg[i]);
+
+	for (i = 1; i < nr_irq_cfg; i++)
+		cfg[i-1].next = &cfg[i];
+
+	cfg->irq = irq;
+	cfg_pri->next = cfg;
+
+	return cfg;
+}
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
@@ -341,7 +423,7 @@ static void __target_IO_APIC_irq(unsigne
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -806,7 +888,7 @@ static int __assign_irq_vector(int irq,
 	struct irq_cfg *cfg;
 
 	BUG_ON((unsigned)irq >= nr_irqs);
-	cfg = &irq_cfg[irq];
+	cfg = get_irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
@@ -880,7 +962,7 @@ static void __clear_irq_vector(int irq)
 	int cpu, vector;
 
 	BUG_ON((unsigned)irq >= nr_irqs);
-	cfg = &irq_cfg[irq];
+	cfg = get_irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -900,17 +982,23 @@ static void __setup_vector_irq(int cpu)
 
 	/* Mark the inuse vectors */
 	for (irq = 0; irq < nr_irqs; ++irq) {
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+		struct irq_cfg *cfg = get_irq_cfg(irq);
+
+		if (!cpu_isset(cpu, cfg->domain))
 			continue;
-		vector = irq_cfg[irq].vector;
+		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
+		struct irq_cfg *cfg;
+
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+
+		cfg = get_irq_cfg(irq);
+		if (!cpu_isset(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -1024,7 +1112,7 @@ static int setup_ioapic_entry(int apic,
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			      int trigger, int polarity)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
 
@@ -1550,7 +1638,7 @@ static unsigned int startup_ioapic_irq(u
 
 static int ioapic_retrigger_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = &irq_cfg[irq];
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
@@ -1597,7 +1685,7 @@ static DECLARE_DELAYED_WORK(ir_migration
  */
 static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 	struct irq_desc *desc = get_irq_desc(irq);
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
@@ -1730,7 +1818,7 @@ asmlinkage void smp_irq_move_cleanup_int
 			continue;
 
 		desc = get_irq_desc(irq);
-		cfg = irq_cfg + irq;
+		cfg = get_irq_cfg(irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
 			goto unlock;
@@ -1749,7 +1837,7 @@ unlock:
 
 static void irq_complete_move(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -1886,7 +1974,10 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for (irq = 0; irq < nr_irqs ; irq++) {
-		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
+		struct irq_cfg *cfg;
+
+		cfg = get_irq_cfg(irq);
+		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
@@ -2023,7 +2114,7 @@ static inline void __init unlock_ExtINT_
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg + 0;
+	struct irq_cfg *cfg = get_irq_cfg(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2301,13 +2392,15 @@ int create_irq(void)
 	int irq;
 	int new;
 	unsigned long flags;
+	struct irq_cfg *cfg_new;
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		if (irq_cfg[new].vector != 0)
+		cfg_new = get_irq_cfg(new);
+		if (cfg_new->vector != 0)
 			continue;
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
@@ -2341,7 +2434,7 @@ void destroy_irq(unsigned int irq)
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
 	cpumask_t tmp;
@@ -2351,6 +2444,7 @@ static int msi_compose_msg(struct pci_de
 	if (err)
 		return err;
 
+	cfg = get_irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2408,7 +2502,7 @@ static int msi_compose_msg(struct pci_de
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -2421,6 +2515,7 @@ static void set_msi_irq_affinity(unsigne
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = get_irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2443,7 +2538,7 @@ static void set_msi_irq_affinity(unsigne
  */
 static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
@@ -2459,6 +2554,7 @@ static void ir_set_msi_irq_affinity(unsi
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = get_irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2665,7 +2761,7 @@ void arch_teardown_msi_irq(unsigned int
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -2678,6 +2774,7 @@ static void dmar_msi_set_affinity(unsign
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = get_irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2744,7 +2841,7 @@ static void target_ht_irq(unsigned int i
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
 	struct irq_desc *desc;
@@ -2756,6 +2853,7 @@ static void set_ht_irq_affinity(unsigned
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = get_irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2778,7 +2876,7 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	cpumask_t tmp;
 
@@ -2788,6 +2886,7 @@ int arch_setup_ht_irq(unsigned int irq,
 		struct ht_irq_msg msg;
 		unsigned dest;
 
+		cfg = get_irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
@@ -2886,6 +2985,7 @@ int acpi_get_override_irq(int bus_irq, i
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
+	struct irq_cfg *cfg;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -2901,7 +3001,8 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			if (!irq_cfg[irq].vector)
+			cfg = get_irq_cfg(irq);
+			if (!cfg->vector)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
