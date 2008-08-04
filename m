Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYHDKLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYHDKLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYHDKKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:10:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:26698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYHDKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YMnr8f/spBnza65or6ZA/u9/QpsRsP3v2v10Q9mbwb+bS9r+g9WSVv+PjEBn7TlSph
         vPh4TVb5Fi3enOcGMN6V2bOmbcJyMI8N+g/pvQpPgYkAZO9m+pMrTPT64UV3AevtjAE3
         dYFWRDD0xJjSMLtvt/T/+IrgYTIX3pA+xS1r0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 01/04] x86_64: use get_irq_desc together with dyn_array
Date: Mon,  4 Aug 2008 03:09:58 -0700
Message-Id: <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate 32 irq_desc, and get_irq_desc will try to get more.

got:

Allocating PCI resources starting at 90000000 (gap: 88000000:76c00000)
dyn_array irq_2_pin+0x0/0x8 size:0x8 nr:192 align:0x8
dyn_array irq_cfg+0x0/0x8 size:0x108 nr:96 align:0x1000
dyn_array irq_desc+0x0/0x8 size:0x180 nr:32 align:0x1000
dyn_array irq_2_iommu+0x0/0x8 size:0x10 nr:96 align:0x1000
dyn_array irq_timer_state+0x0/0x50 size:0x8 nr:96 align:0x1000
dyn_array total_size: 0xc600
dyn_array irq_2_pin+0x0/0x8  ==> [0x28028000 - 0x28028600]
dyn_array irq_cfg+0x0/0x8  ==> [0x28029000 - 0x2802f300]
dyn_array irq_desc+0x0/0x8  ==> [0x28030000 - 0x28033000]
dyn_array irq_2_iommu+0x0/0x8  ==> [0x28033000 - 0x28033600]
dyn_array irq_timer_state+0x0/0x50  ==> [0x28034000 - 0x28034300]
per_cpu_dyn_array per_cpu__kstat+0x48/0x50 size:0x4 nr:96 align:0x8
per_cpu_dyn_array total_size: 0x180
PERCPU: Allocating 57344 bytes of per cpu data
per cpu data for cpu0 on node0 at 0000000028035000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x280422a8 - 0x28042428]
per cpu data for cpu1 on node0 at 0000000028043000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x280502a8 - 0x28050428]
per cpu data for cpu2 on node0 at 0000000028051000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x2805e2a8 - 0x2805e428]
per cpu data for cpu3 on node0 at 000000002805f000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x2806c2a8 - 0x2806c428]
per cpu data for cpu4 on node1 at 000000017ba18000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x17ba252a8 - 0x17ba25428]
per cpu data for cpu5 on node1 at 000000017ba26000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x17ba332a8 - 0x17ba33428]
per cpu data for cpu6 on node1 at 000000017ba34000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x17ba412a8 - 0x17ba41428]
per cpu data for cpu7 on node1 at 000000017ba42000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x17ba4f2a8 - 0x17ba4f428]
per cpu data for cpu8 on node2 at 000000027ba18000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x27ba252a8 - 0x27ba25428]
per cpu data for cpu9 on node2 at 000000027ba26000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x27ba332a8 - 0x27ba33428]
per cpu data for cpu10 on node2 at 000000027ba34000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x27ba412a8 - 0x27ba41428]
per cpu data for cpu11 on node2 at 000000027ba42000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x27ba4f2a8 - 0x27ba4f428]
per cpu data for cpu12 on node3 at 000000037ba18000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x37ba252a8 - 0x37ba25428]
per cpu data for cpu13 on node3 at 000000037ba26000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x37ba332a8 - 0x37ba33428]
per cpu data for cpu14 on node3 at 000000037ba34000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x37ba412a8 - 0x37ba41428]
per cpu data for cpu15 on node3 at 000000037ba42000
per_cpu_dyn_array per_cpu__kstat+0x48/0x50  ==> [0x37ba4f2a8 - 0x37ba4f428]
NR_CPUS: 1024, nr_cpu_ids: 16, nr_node_ids 4
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 4129993
Policy zone: Normal
Kernel command line: console=uart8250,io,0x3f8,115200n8 initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug show_msr=1 nopat initcall_debug apic=verbose pci=routeirq ip=dhcp load_ramdisk=1 ramdisk_size=131072 BOOT_IMAGE=kernel.org/bzImage_2.6.27_k8.1
Initializing CPU#0
try to get more irq_desc 32
try to get more irq_desc 32
PID hash table entries: 4096 (order: 12, 32768 bytes)

to do:
1. do the same thing to irq_cfg
2. clean up nr_irqs reference and try to kill it, so could remove after_bootmem/alloc_bootmem in get_irq_desc

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c        |   46 ++++++++++----
 arch/x86/kernel/io_apic_64.c        |   71 ++++++++++++++-------
 arch/x86/kernel/irq_32.c            |   24 ++++---
 arch/x86/kernel/irq_64.c            |   35 +++++-----
 arch/x86/kernel/irqinit_64.c        |   10 +--
 arch/x86/kernel/visws_quirks.c      |   30 +++++----
 arch/x86/mach-voyager/voyager_smp.c |    4 -
 drivers/gpio/gpiolib.c              |    2 
 drivers/mfd/asic3.c                 |    4 -
 drivers/mfd/htc-egpio.c             |    2 
 drivers/parisc/dino.c               |    6 +
 drivers/parisc/eisa.c               |    4 -
 drivers/parisc/gsc.c                |   12 ++-
 drivers/parisc/iosapic.c            |    4 -
 drivers/parisc/superio.c            |    4 -
 drivers/pcmcia/hd64465_ss.c         |   12 ++-
 drivers/xen/events.c                |    8 +-
 include/linux/irq.h                 |   32 ++++++---
 kernel/irq/autoprobe.c              |   10 +--
 kernel/irq/chip.c                   |   32 +++++----
 kernel/irq/handle.c                 |  118 ++++++++++++++++++++++++++++++++----
 kernel/irq/manage.c                 |   35 ++++++----
 kernel/irq/migration.c              |   14 ++--
 kernel/irq/proc.c                   |   36 ++++++----
 kernel/irq/resend.c                 |    2 
 kernel/irq/spurious.c               |    5 -
 26 files changed, 377 insertions(+), 185 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -345,6 +345,7 @@ static void set_ioapic_affinity_irq(unsi
 	struct irq_pin_list *entry = irq_2_pin + irq;
 	unsigned int apicid_value;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, cpumask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -365,7 +366,8 @@ static void set_ioapic_affinity_irq(unsi
 			break;
 		entry = irq_2_pin + entry->next;
 	}
-	irq_desc[irq].affinity = cpumask;
+	desc = get_irq_desc(irq);
+	desc->affinity = cpumask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -475,10 +477,12 @@ static inline void balance_irq(int cpu,
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 {
 	int i, j;
+	struct irq_desc *desc;
 
 	for_each_online_cpu(i) {
 		for (j = 0; j < nr_irqs; j++) {
-			if (!irq_desc[j].action)
+			desc = get_irq_desc[j];
+			if (!desc->action)
 				continue;
 			/* Is it a significant load ?  */
 			if (IRQ_DELTA(CPU_TO_PACKAGEINDEX(i), j) <
@@ -505,6 +509,7 @@ static void do_irq_balance(void)
 	unsigned long tmp_cpu_irq;
 	unsigned long imbalance = 0;
 	cpumask_t allowed_mask, target_cpu_mask, tmp;
+	struct irq_desc *desc;
 
 	for_each_possible_cpu(i) {
 		int package_index;
@@ -515,7 +520,8 @@ static void do_irq_balance(void)
 		for (j = 0; j < nr_irqs; j++) {
 			unsigned long value_now, delta;
 			/* Is this an active IRQ or balancing disabled ? */
-			if (!irq_desc[j].action || irq_balancing_disabled(j))
+			desc = get_irq_desc[j];
+			if (!desc->action || irq_balancing_disabled(j))
 				continue;
 			if (package_index == i)
 				IRQ_DELTA(package_index, j) = 0;
@@ -609,7 +615,8 @@ tryanotherirq:
 	selected_irq = -1;
 	for (j = 0; j < nr_irqs; j++) {
 		/* Is this an active IRQ? */
-		if (!irq_desc[j].action)
+		desc = get_irq_desc[j];
+		if (!desc->action)
 			continue;
 		if (imbalance <= IRQ_DELTA(max_loaded, j))
 			continue;
@@ -682,10 +689,12 @@ static int balanced_irq(void *unused)
 	int i;
 	unsigned long prev_balance_time = jiffies;
 	long time_remaining = balanced_irq_interval;
+	struct irq_desc *desc;
 
 	/* push everything to CPU 0 to give us a starting point.  */
 	for (i = 0 ; i < nr_irqs ; i++) {
-		irq_desc[i].pending_mask = cpumask_of_cpu(0);
+		desc = get_irq_desc(i);
+		desc->pending_mask = cpumask_of_cpu(0);
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
 
@@ -1258,13 +1267,16 @@ static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
 {
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL) {
-		irq_desc[irq].status |= IRQ_LEVEL;
+		desc->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
 	} else {
-		irq_desc[irq].status &= ~IRQ_LEVEL;
+		desc->status &= ~IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
 	}
@@ -2031,6 +2043,7 @@ static struct irq_chip ioapic_chip __rea
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2052,9 +2065,11 @@ static inline void init_IO_APIC_traps(vo
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else
+			else {
+				desc = get_irq_desc(irq);
 				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
+				desc->chip = &no_irq_chip;
+			}
 		}
 	}
 }
@@ -2093,7 +2108,10 @@ static struct irq_chip lapic_chip __read
 
 static void lapic_register_intr(int irq, int vector)
 {
-	irq_desc[irq].status &= ~IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 	set_intr_gate(vector, interrupt[irq]);
@@ -2560,6 +2578,7 @@ static void set_msi_irq_affinity(unsigne
 	unsigned int dest;
 	cpumask_t tmp;
 	int vector;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2579,7 +2598,8 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2653,6 +2673,7 @@ static void set_ht_irq_affinity(unsigned
 {
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2663,7 +2684,8 @@ static void set_ht_irq_affinity(unsigned
 	dest = cpu_mask_to_apicid(mask);
 
 	target_ht_irq(irq, dest);
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -345,6 +345,7 @@ static void set_ioapic_affinity_irq(unsi
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -361,9 +362,10 @@ static void set_ioapic_affinity_irq(unsi
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	irq_desc[irq].affinity = mask;
+	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif
@@ -928,14 +930,17 @@ static struct irq_chip ir_ioapic_chip;
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
 	if (trigger)
-		irq_desc[irq].status |= IRQ_LEVEL;
+		desc->status |= IRQ_LEVEL;
 	else
-		irq_desc[irq].status &= ~IRQ_LEVEL;
+		desc->status &= ~IRQ_LEVEL;
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		irq_desc[irq].status |= IRQ_MOVE_PCNTXT;
+		desc->status |= IRQ_MOVE_PCNTXT;
 		if (trigger)
 			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
 						      handle_fasteoi_irq,
@@ -1593,7 +1598,7 @@ static DECLARE_DELAYED_WORK(ir_migration
 static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 	int modify_ioapic_rte = desc->status & IRQ_LEVEL;
@@ -1634,12 +1639,13 @@ static void migrate_ioapic_irq(int irq,
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc->affinity = mask;
 }
 
 static int migrate_irq_remapped_level(int irq)
 {
 	int ret = -1;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	mask_IO_APIC_irq(irq);
 
@@ -1655,11 +1661,11 @@ static int migrate_irq_remapped_level(in
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, irq_desc[irq].pending_mask);
+	migrate_ioapic_irq(irq, desc->pending_mask);
 
 	ret = 0;
-	irq_desc[irq].status &= ~IRQ_MOVE_PENDING;
-	cpus_clear(irq_desc[irq].pending_mask);
+	desc->status &= ~IRQ_MOVE_PENDING;
+	cpus_clear(desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq(irq);
@@ -1671,7 +1677,7 @@ static void ir_irq_migration(struct work
 	int irq;
 
 	for (irq = 0; irq < nr_irqs; irq++) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = get_irq_desc(irq);
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -1683,8 +1689,7 @@ static void ir_irq_migration(struct work
 				continue;
 			}
 
-			desc->chip->set_affinity(irq,
-					         irq_desc[irq].pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -1695,9 +1700,11 @@ static void ir_irq_migration(struct work
  */
 static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	if (irq_desc[irq].status & IRQ_LEVEL) {
-		irq_desc[irq].status |= IRQ_MOVE_PENDING;
-		irq_desc[irq].pending_mask = mask;
+	struct irq_desc *desc = get_irq_desc(irq);
+
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		desc->pending_mask = mask;
 		migrate_irq_remapped_level(irq);
 		return;
 	}
@@ -1722,7 +1729,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (irq >= nr_irqs)
 			continue;
 
-		desc = irq_desc + irq;
+		desc = get_irq_desc(irq);
 		cfg = irq_cfg + irq;
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
@@ -1788,7 +1795,7 @@ static void ack_apic_level(unsigned int
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(get_irq_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
 	}
@@ -1865,6 +1872,7 @@ static struct irq_chip ir_ioapic_chip __
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1886,9 +1894,11 @@ static inline void init_IO_APIC_traps(vo
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else
+			else {
+				desc = get_irq_desc(irq);
 				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
+				desc->chip = &no_irq_chip;
+			}
 		}
 	}
 }
@@ -1923,7 +1933,10 @@ static struct irq_chip lapic_chip __read
 
 static void lapic_register_intr(int irq)
 {
-	irq_desc[irq].status &= ~IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 }
@@ -2399,6 +2412,7 @@ static void set_msi_irq_affinity(unsigne
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2418,7 +2432,8 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -2432,6 +2447,7 @@ static void ir_set_msi_irq_affinity(unsi
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2466,7 +2482,8 @@ static void ir_set_msi_irq_affinity(unsi
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -2540,7 +2557,7 @@ static int setup_msi_irq(struct pci_dev
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = get_irq_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -2652,6 +2669,7 @@ static void dmar_msi_set_affinity(unsign
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2671,7 +2689,8 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2728,6 +2747,7 @@ static void set_ht_irq_affinity(unsigned
 	struct irq_cfg *cfg = irq_cfg + irq;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2740,7 +2760,8 @@ static void set_ht_irq_affinity(unsigned
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	irq_desc[irq].affinity = mask;
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -224,7 +224,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
 	int overflow, irq = ~regs->orig_ax;
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (unlikely((unsigned)irq >= nr_irqs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -273,15 +273,16 @@ int show_interrupts(struct seq_file *p,
 
 	if (i < nr_irqs) {
 		unsigned any_count = 0;
+		struct irq_desc *desc = get_irq_desc(i);
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
 			any_count |= kstat_cpu(j).irqs[i];
 #endif
-		action = irq_desc[i].action;
+		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -291,8 +292,8 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -302,7 +303,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == nr_irqs) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
@@ -398,17 +399,20 @@ void fixup_irqs(cpumask_t map)
 
 	for (irq = 0; irq < nr_irqs; irq++) {
 		cpumask_t mask;
+		struct irq_desc *desc;
+
 		if (irq == 2)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		desc = get_irq_desc(irq);
+		cpus_and(mask, desc->affinity, map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
 		}
-		if (irq_desc[irq].chip->set_affinity)
-			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, mask);
+		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -83,15 +83,16 @@ int show_interrupts(struct seq_file *p,
 
 	if (i < nr_irqs) {
 		unsigned any_count = 0;
+		struct irq_desc *desc = get_irq_desc(i);
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
 			any_count |= kstat_cpu(j).irqs[i];
 #endif
-		action = irq_desc[i].action;
+		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -101,8 +102,8 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -111,7 +112,7 @@ int show_interrupts(struct seq_file *p,
 		}
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == nr_irqs) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
@@ -228,37 +229,39 @@ void fixup_irqs(cpumask_t map)
 		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
+		struct irq_desc *desc;
 
 		if (irq == 2)
 			continue;
 
+		desc = get_irq_desc(irq);
 		/* interrupt's are disabled at this point */
-		spin_lock(&irq_desc[irq].lock);
+		spin_lock(&desc->lock);
 
 		if (!irq_has_action(irq) ||
-		    cpus_equal(irq_desc[irq].affinity, map)) {
-			spin_unlock(&irq_desc[irq].lock);
+		    cpus_equal(desc->affinity, map)) {
+			spin_unlock(&desc->lock);
 			continue;
 		}
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		cpus_and(mask, desc->affinity, map);
 		if (cpus_empty(mask)) {
 			break_affinity = 1;
 			mask = map;
 		}
 
-		if (irq_desc[irq].chip->mask)
-			irq_desc[irq].chip->mask(irq);
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
 
-		if (irq_desc[irq].chip->set_affinity)
-			irq_desc[irq].chip->set_affinity(irq, mask);
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, mask);
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (irq_desc[irq].chip->unmask)
-			irq_desc[irq].chip->unmask(irq);
+		if (desc->chip->unmask)
+			desc->chip->unmask(irq);
 
-		spin_unlock(&irq_desc[irq].lock);
+		spin_unlock(&desc->lock);
 
 		if (break_affinity && set_affinity)
 			printk("Broke affinity for irq %i\n", irq);
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -143,9 +143,11 @@ static void __init init_ISA_irqs (void)
 	init_8259A(0);
 
 	for (i = 0; i < nr_irqs; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
+		struct irq_desc *desc = get_irq_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
 
 		if (i < 16) {
 			/*
@@ -157,7 +159,7 @@ static void __init init_ISA_irqs (void)
 			/*
 			 * 'high' PCI IRQs filled in on demand
 			 */
-			irq_desc[i].chip = &no_irq_chip;
+			desc->chip = &no_irq_chip;
 		}
 	}
 }
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -486,10 +486,11 @@ static void disable_cobalt_irq(unsigned
 static unsigned int startup_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if ((irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
-		irq_desc[irq].status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
+	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
+		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
 	enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
@@ -508,9 +509,10 @@ static void ack_cobalt_irq(unsigned int
 static void end_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
@@ -628,7 +630,7 @@ static irqreturn_t piix4_master_intr(int
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	desc = irq_desc + realirq;
+	desc = get_irq_desc(realirq);
 
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
@@ -664,27 +666,29 @@ void init_VISWS_APIC_irqs(void)
 	int i;
 
 	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = 0;
-		irq_desc[i].depth = 1;
+		struct irq_desc *desc = get_irq_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = 0;
+		desc->depth = 1;
 
 		if (i == 0) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_IDE0) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_IDE1) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_8259) {
-			irq_desc[i].chip = &piix4_master_irq_type;
+			desc->chip = &piix4_master_irq_type;
 		}
 		else if (i < CO_IRQ_APIC0) {
-			irq_desc[i].chip = &piix4_virtual_irq_type;
+			desc->chip = &piix4_virtual_irq_type;
 		}
 		else if (IS_CO_APIC(i)) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 	}
 
Index: linux-2.6/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6/arch/x86/mach-voyager/voyager_smp.c
@@ -1481,7 +1481,7 @@ static void disable_local_vic_irq(unsign
  * the interrupt off to another CPU */
 static void before_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = get_irq_desc(irq);
 	__u8 cpu = smp_processor_id();
 
 	_raw_spin_lock(&vic_irq_lock);
@@ -1516,7 +1516,7 @@ static void before_handle_vic_irq(unsign
 /* Finish the VIC interrupt: basically mask */
 static void after_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = get_irq_desc(irq);
 
 	_raw_spin_lock(&vic_irq_lock);
 	{
Index: linux-2.6/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -1058,7 +1058,7 @@ static void gpiolib_dbg_show(struct seq_
 
 		if (!is_out) {
 			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_desc + irq;
+			struct irq_desc	*desc = get_irq_desc(irq);
 
 			/* This races with request_irq(), set_irq_type(),
 			 * and set_irq_wake() ... but those are "rare".
Index: linux-2.6/drivers/mfd/asic3.c
===================================================================
--- linux-2.6.orig/drivers/mfd/asic3.c
+++ linux-2.6/drivers/mfd/asic3.c
@@ -124,7 +124,7 @@ static void asic3_irq_demux(unsigned int
 					irqnr = asic->irq_base +
 						(ASIC3_GPIOS_PER_BANK * bank)
 						+ i;
-					desc = irq_desc + irqnr;
+					desc = get_irq_desc(irqnr);
 					desc->handle_irq(irqnr, desc);
 					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
@@ -137,7 +137,7 @@ static void asic3_irq_demux(unsigned int
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc + asic->irq_base + i;
+				desc = get_irq_desc(asic->irq_base + i);
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
Index: linux-2.6/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6/drivers/mfd/htc-egpio.c
@@ -112,7 +112,7 @@ static void egpio_handler(unsigned int i
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
 		irq = ei->irq_start + irqpin;
-		desc = &irq_desc[irq];
+		desc = get_irq_desc(irq);
 		desc->handle_irq(irq, desc);
 	}
 }
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -298,7 +298,8 @@ struct pci_port_ops dino_port_ops = {
 
 static void dino_disable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = get_irq_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
 	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
@@ -310,7 +311,8 @@ static void dino_disable_irq(unsigned in
 
 static void dino_enable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = get_irq_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
 
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -346,10 +346,10 @@ static int __init eisa_probe(struct pari
 	}
 	
 	/* Reserve IRQ2 */
-	irq_desc[2].action = &irq2_action;
+	get_irq_desc(2)->action = &irq2_action;
 	
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &eisa_interrupt_type;
+		get_irq_desc(i)->chip = &eisa_interrupt_type;
 	}
 	
 	EISA_bus = 1;
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -108,7 +108,8 @@ int gsc_find_local_irq(unsigned int irq,
 
 static void gsc_asic_disable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = get_irq_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -123,7 +124,8 @@ static void gsc_asic_disable_irq(unsigne
 
 static void gsc_asic_enable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = get_irq_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -159,12 +161,14 @@ static struct hw_interrupt_type gsc_asic
 int gsc_assign_irq(struct hw_interrupt_type *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
+	struct irq_desc *desc;
 
 	if (irq > GSC_IRQ_MAX)
 		return NO_IRQ;
 
-	irq_desc[irq].chip = type;
-	irq_desc[irq].chip_data = data;
+	desc = get_irq_desc(irq);
+	desc->chip = type;
+	desc->chip_data = data;
 	return irq++;
 }
 
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -619,7 +619,9 @@ iosapic_set_irt_data( struct vector_info
 
 static struct vector_info *iosapic_get_vector(unsigned int irq)
 {
-	return irq_desc[irq].chip_data;
+	struct irq_desc *desc = get_irq_desc(irq);
+
+	return desc->chip_data;
 }
 
 static void iosapic_disable_irq(unsigned int irq)
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -363,7 +363,9 @@ int superio_fixup_irq(struct pci_dev *pc
 #endif
 
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &superio_interrupt_type;
+		struct irq_desc *desc = get_irq_desc(i);
+
+		desc->chip = &superio_interrupt_type;
 	}
 
 	/*
Index: linux-2.6/drivers/pcmcia/hd64465_ss.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/hd64465_ss.c
+++ linux-2.6/drivers/pcmcia/hd64465_ss.c
@@ -234,15 +234,18 @@ static struct hw_interrupt_type hd64465_
  */
 static void hs_map_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_map_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 
+	desc = get_irq_desc(irq);
     	hs_mapped_irq[irq].sock = sp;
 	/* insert ourselves as the irq controller */
-	hs_mapped_irq[irq].old_handler = irq_desc[irq].chip;
-	irq_desc[irq].chip = &hd64465_ss_irq_type;
+	hs_mapped_irq[irq].old_handler = desc->chip;
+	desc->chip = &hd64465_ss_irq_type;
 }
 
 
@@ -251,13 +254,16 @@ static void hs_map_irq(hs_socket_t *sp,
  */
 static void hs_unmap_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_unmap_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 		
+	desc = get_irq_desc(irq);
 	/* restore the original irq controller */
-	irq_desc[irq].chip = hs_mapped_irq[irq].old_handler;
+	desc->chip = hs_mapped_irq[irq].old_handler;
 }
 
 /*============================================================*/
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	get_irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -139,8 +139,10 @@ static void init_evtchn_cpu_bindings(voi
 #ifdef CONFIG_SMP
 	int i;
 	/* By default all event channels notify CPU#0. */
-	for (i = 0; i < nr_irqs; i++)
-		irq_desc[i].affinity = cpumask_of_cpu(0);
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = get_irq_desc(i);
+		desc->affinity = cpumask_of_cpu(0);
+	}
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -154,6 +154,10 @@ struct irq_chip {
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned int		irq;
+	struct irq_desc		*next;
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -181,9 +185,9 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-#ifdef CONFIG_HAVE_DYN_ARRAY
-extern struct irq_desc *irq_desc;
-#else
+extern struct irq_desc *get_irq_desc(unsigned int irq);
+#ifndef CONFIG_HAVE_DYN_ARRAY
+/* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
@@ -251,7 +255,10 @@ extern int no_irq_affinity;
 
 static inline int irq_balancing_disabled(unsigned int irq)
 {
-	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	return desc->status & IRQ_NO_BALANCING_MASK;
 }
 
 /* Handle irq action chains: */
@@ -283,7 +290,7 @@ extern unsigned int __do_IRQ(unsigned in
  */
 static inline void generic_handle_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
@@ -327,7 +334,10 @@ __set_irq_handler(unsigned int irq, irq_
 static inline void __set_irq_handler_unlocked(int irq,
 					      irq_flow_handler_t handler)
 {
-	irq_desc[irq].handle_irq = handler;
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	desc->handle_irq = handler;
 }
 
 /*
@@ -361,7 +371,7 @@ extern void destroy_irq(unsigned int irq
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	return desc->action != NULL;
 }
 
@@ -376,10 +386,10 @@ extern int set_irq_chip_data(unsigned in
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
-#define get_irq_chip(irq)	(irq_desc[irq].chip)
-#define get_irq_chip_data(irq)	(irq_desc[irq].chip_data)
-#define get_irq_data(irq)	(irq_desc[irq].handler_data)
-#define get_irq_msi(irq)	(irq_desc[irq].msi_desc)
+#define get_irq_chip(irq)	(get_irq_desc(irq)->chip)
+#define get_irq_chip_data(irq)	(get_irq_desc(irq)->chip_data)
+#define get_irq_data(irq)	(get_irq_desc(irq)->handler_data)
+#define get_irq_msi(irq)	(get_irq_desc(irq)->msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -39,7 +39,7 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc + i;
+		desc = get_irq_desc(i);
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -69,7 +69,7 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc + i;
+		desc = get_irq_desc(i);
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -92,7 +92,7 @@ unsigned long probe_irq_on(void)
 	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
-		desc = irq_desc + i;
+		desc = get_irq_desc(i);
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -131,7 +131,7 @@ unsigned int probe_irq_mask(unsigned lon
 
 	mask = 0;
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = get_irq_desc(i);
 		unsigned int status;
 
 		spin_lock_irq(&desc->lock);
@@ -174,7 +174,7 @@ int probe_irq_off(unsigned long val)
 	int i, irq_found = 0, nr_irqs = 0;
 
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = get_irq_desc(i);
 		unsigned int status;
 
 		spin_lock_irq(&desc->lock);
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -33,7 +33,7 @@ void dynamic_irq_init(unsigned int irq)
 	}
 
 	/* Ensure we don't have left over values from a previous use of this irq */
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
@@ -65,7 +65,7 @@ void dynamic_irq_cleanup(unsigned int ir
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
@@ -100,7 +100,7 @@ int set_irq_chip(unsigned int irq, struc
 	if (!chip)
 		chip = &no_irq_chip;
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
@@ -126,7 +126,7 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	if (desc->chip->set_type) {
 		spin_lock_irqsave(&desc->lock, flags);
 		ret = desc->chip->set_type(irq, type);
@@ -154,7 +154,7 @@ int set_irq_data(unsigned int irq, void
 		return -EINVAL;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->handler_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -179,7 +179,7 @@ int set_irq_msi(unsigned int irq, struct
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
@@ -197,9 +197,10 @@ int set_irq_msi(unsigned int irq, struct
  */
 int set_irq_chip_data(unsigned int irq, void *data)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	unsigned long flags;
 
+	desc = get_irq_desc(irq);
 	if (irq >= nr_irqs || !desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
@@ -218,8 +219,9 @@ EXPORT_SYMBOL(set_irq_chip_data);
  */
 static void default_enable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = get_irq_desc(irq);
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
@@ -236,7 +238,10 @@ static void default_disable(unsigned int
  */
 static unsigned int default_startup(unsigned int irq)
 {
-	irq_desc[irq].chip->enable(irq);
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	desc->chip->enable(irq);
 
 	return 0;
 }
@@ -246,8 +251,9 @@ static unsigned int default_startup(unsi
  */
 static void default_shutdown(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = get_irq_desc(irq);
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
@@ -550,7 +556,7 @@ __set_irq_handler(unsigned int irq, irq_
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 
 	if (!handle)
 		handle = handle_bad_irq;
@@ -615,7 +621,7 @@ void __init set_irq_noprobe(unsigned int
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOPROBE;
@@ -633,7 +639,7 @@ void __init set_irq_probe(unsigned int i
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status &= ~IRQ_NOPROBE;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -18,6 +18,14 @@
 
 #include "internals.h"
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+#endif
+
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -50,7 +58,8 @@ handle_bad_irq(unsigned int irq, struct
 int nr_irqs = NR_IRQS;
 
 #ifdef CONFIG_HAVE_DYN_ARRAY
-static struct irq_desc irq_desc_init __initdata = {
+static struct irq_desc irq_desc_init = {
+	.irq = -1U,
 	.status = IRQ_DISABLED,
 	.chip = &no_irq_chip,
 	.handle_irq = handle_bad_irq,
@@ -61,6 +70,26 @@ static struct irq_desc irq_desc_init __i
 #endif
 };
 
+
+static void init_one_irq_desc(struct irq_desc *desc)
+{
+	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
+#ifdef CONFIG_TRACE_IRQFLAGS
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+#endif
+}
+
+static int nr_irq_desc = 32;
+
+static int __init parse_nr_irq_desc(char *arg)
+{
+	if (arg)
+		nr_irq_desc = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+
+early_param("nr_irq_desc", parse_nr_irq_desc);
+
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -70,11 +99,65 @@ static void __init init_work(void *data)
 	desc = *da->name;
 
 	for (i = 0; i < *da->nr; i++)
-		memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
+		init_one_irq_desc(&desc[i]);
+
+	for (i = 1; i < *da->nr; i++)
+		desc[i-1].next = &desc[i];
 }
 
-struct irq_desc *irq_desc;
-DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+static struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
+
+extern int after_bootmem;
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+			     unsigned long align,
+			     unsigned long goal);
+struct irq_desc *get_irq_desc(unsigned int irq)
+{
+	struct irq_desc *desc, *desc_pri;
+	int i;
+	int count = 0;
+
+	BUG_ON(irq == -1U);
+
+	desc_pri = desc = &irq_desc[0];
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		if (desc->irq == -1U) {
+			desc->irq = irq;
+			return desc;
+		}
+		desc_pri = desc;
+		desc = desc->next;
+		count++;
+	}
+
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
+
+	if (after_bootmem)
+		desc = kzalloc(sizeof(struct irq_desc)*nr_irq_desc, GFP_ATOMIC);
+	else
+		desc = __alloc_bootmem_nopanic(sizeof(struct irq_desc)*nr_irq_desc, PAGE_SIZE, 0);
+
+        if (!desc)
+		panic("please boot with nr_irq_desc= %d\n", count * 2);
+
+	for (i = 0; i < nr_irq_desc; i++)
+		init_one_irq_desc(&desc[i]);
+
+	for (i = 1; i < nr_irq_desc; i++)
+		desc[i-1].next = &desc[i];
+
+	desc->irq = irq;
+	desc_pri->next = desc;
+
+	return desc;
+}
 
 #else
 
@@ -90,6 +173,15 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 #endif
 	}
 };
+
+struct irq_desc *get_irq_desc(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_desc[irq];
+
+	return NULL;
+}
+
 #endif
 
 /*
@@ -98,7 +190,10 @@ struct irq_desc irq_desc[NR_IRQS] __cach
  */
 static void ack_bad(unsigned int irq)
 {
-	print_irq_desc(irq, irq_desc + irq);
+	struct irq_desc *desc;
+
+	desc = get_irq_desc(irq);
+	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
 
@@ -195,7 +290,7 @@ irqreturn_t handle_IRQ_event(unsigned in
  */
 unsigned int __do_IRQ(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	struct irqaction *action;
 	unsigned int status;
 
@@ -286,19 +381,16 @@ out:
 }
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
 
+#ifdef CONFIG_TRACE_IRQFLAGS
 void early_init_irq_lock_class(void)
 {
+#ifndef CONFIG_HAVE_DYN_ARRAY
 	int i;
 
 	for (i = 0; i < nr_irqs; i++)
 		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
+#endif
 }
-
 #endif
+
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -31,7 +31,7 @@ cpumask_t irq_default_affinity = CPU_MAS
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned int status;
 
 	if (irq >= nr_irqs)
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(synchronize_irq);
  */
 int irq_can_set_affinity(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
 	    !desc->chip->set_affinity)
@@ -81,7 +81,7 @@ int irq_can_set_affinity(unsigned int ir
  */
 int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
@@ -111,14 +111,16 @@ int irq_set_affinity(unsigned int irq, c
 int irq_select_affinity(unsigned int irq)
 {
 	cpumask_t mask;
+	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
-	irq_desc[irq].affinity = mask;
-	irq_desc[irq].chip->set_affinity(irq, mask);
+	desc = get_irq_desc(irq);
+	desc->affinity = mask;
+	desc->chip->set_affinity(irq, mask);
 
 	set_balance_irq_affinity(irq, mask);
 	return 0;
@@ -140,7 +142,7 @@ int irq_select_affinity(unsigned int irq
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned long flags;
 
 	if (irq >= nr_irqs)
@@ -169,7 +171,7 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (irq >= nr_irqs)
 		return;
@@ -211,7 +213,7 @@ static void __enable_irq(struct irq_desc
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned long flags;
 
 	if (irq >= nr_irqs)
@@ -225,7 +227,7 @@ EXPORT_SYMBOL(enable_irq);
 
 int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
@@ -248,7 +250,7 @@ int set_irq_wake_real(unsigned int irq,
  */
 int set_irq_wake(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned long flags;
 	int ret = 0;
 
@@ -288,12 +290,13 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
+	struct irq_desc *desc = get_irq_desc(irq);
 	struct irqaction *action;
 
-	if (irq >= nr_irqs || irq_desc[irq].status & IRQ_NOREQUEST)
+	if (irq >= nr_irqs || desc->status & IRQ_NOREQUEST)
 		return 0;
 
-	action = irq_desc[irq].action;
+	action =desc->action;
 	if (action)
 		if (irqflags & action->flags & IRQF_SHARED)
 			action = NULL;
@@ -342,7 +345,7 @@ static int __irq_set_trigger(struct irq_
  */
 int setup_irq(unsigned int irq, struct irqaction *new)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
 	unsigned long flags;
@@ -506,7 +509,7 @@ void free_irq(unsigned int irq, void *de
 	if (irq >= nr_irqs)
 		return;
 
-	desc = irq_desc + irq;
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	p = &desc->action;
 	for (;;) {
@@ -602,6 +605,7 @@ int request_irq(unsigned int irq, irq_ha
 {
 	struct irqaction *action;
 	int retval;
+	struct irq_desc *desc;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -619,7 +623,8 @@ int request_irq(unsigned int irq, irq_ha
 		return -EINVAL;
 	if (irq >= nr_irqs)
 		return -EINVAL;
-	if (irq_desc[irq].status & IRQ_NOREQUEST)
+	desc = get_irq_desc(irq);
+	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
 	if (!handler)
 		return -EINVAL;
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -3,18 +3,18 @@
 
 void set_pending_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_MOVE_PENDING;
-	irq_desc[irq].pending_mask = mask;
+	desc->pending_mask = mask;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void move_masked_irq(int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	cpumask_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
@@ -30,7 +30,7 @@ void move_masked_irq(int irq)
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpus_empty(irq_desc[irq].pending_mask)))
+	if (unlikely(cpus_empty(desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -38,7 +38,7 @@ void move_masked_irq(int irq)
 
 	assert_spin_locked(&desc->lock);
 
-	cpus_and(tmp, irq_desc[irq].pending_mask, cpu_online_map);
+	cpus_and(tmp, desc->pending_mask, cpu_online_map);
 
 	/*
 	 * If there was a valid mask to work with, please
@@ -55,12 +55,12 @@ void move_masked_irq(int irq)
 	if (likely(!cpus_empty(tmp))) {
 		desc->chip->set_affinity(irq,tmp);
 	}
-	cpus_clear(irq_desc[irq].pending_mask);
+	cpus_clear(desc->pending_mask);
 }
 
 void move_native_irq(int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -19,7 +19,7 @@ static struct proc_dir_entry *root_irq_d
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *desc = irq_desc + (long)data;
+	struct irq_desc *desc = get_irq_desc((long)data);
 	cpumask_t *mask = &desc->affinity;
 	int len;
 
@@ -45,8 +45,9 @@ static int irq_affinity_write_proc(struc
 {
 	unsigned int irq = (int)(long)data, full_count = count, err;
 	cpumask_t new_value;
+	struct irq_desc *desc = get_irq_desc(irq);
 
-	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
+	if (!desc->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
@@ -112,20 +113,20 @@ static int default_affinity_write(struct
 static int irq_spurious_read(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *d = &irq_desc[(long) data];
+	struct irq_desc *desc = get_irq_desc((long) data);
 	return sprintf(page, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
-			d->irq_count,
-			d->irqs_unhandled,
-			jiffies_to_msecs(d->last_unhandled));
+			desc->irq_count,
+			desc->irqs_unhandled,
+			jiffies_to_msecs(desc->last_unhandled));
 }
 
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = get_irq_desc(irq);
 	struct irqaction *action;
 	unsigned long flags;
 	int ret = 1;
@@ -145,8 +146,9 @@ static int name_unique(unsigned int irq,
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
 	char name [MAX_NAMELEN];
+	struct irq_desc *desc = get_irq_desc(irq);
 
-	if (!irq_desc[irq].dir || action->dir || !action->name ||
+	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
 		return;
 
@@ -154,7 +156,7 @@ void register_handler_proc(unsigned int
 	snprintf(name, MAX_NAMELEN, "%s", action->name);
 
 	/* create /proc/irq/1234/handler/ */
-	action->dir = proc_mkdir(name, irq_desc[irq].dir);
+	action->dir = proc_mkdir(name, desc->dir);
 }
 
 #undef MAX_NAMELEN
@@ -165,22 +167,22 @@ void register_irq_proc(unsigned int irq)
 {
 	char name [MAX_NAMELEN];
 	struct proc_dir_entry *entry;
+	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (!root_irq_dir ||
-		(irq_desc[irq].chip == &no_irq_chip) ||
-			irq_desc[irq].dir)
+		(desc->chip == &no_irq_chip) || desc->dir)
 		return;
 
 	memset(name, 0, MAX_NAMELEN);
 	sprintf(name, "%d", irq);
 
 	/* create /proc/irq/1234 */
-	irq_desc[irq].dir = proc_mkdir(name, root_irq_dir);
+	desc->dir = proc_mkdir(name, root_irq_dir);
 
 #ifdef CONFIG_SMP
 	{
 		/* create /proc/irq/<irq>/smp_affinity */
-		entry = create_proc_entry("smp_affinity", 0600, irq_desc[irq].dir);
+		entry = create_proc_entry("smp_affinity", 0600, desc->dir);
 
 		if (entry) {
 			entry->data = (void *)(long)irq;
@@ -190,7 +192,7 @@ void register_irq_proc(unsigned int irq)
 	}
 #endif
 
-	entry = create_proc_entry("spurious", 0444, irq_desc[irq].dir);
+	entry = create_proc_entry("spurious", 0444, desc->dir);
 	if (entry) {
 		entry->data = (void *)(long)irq;
 		entry->read_proc = irq_spurious_read;
@@ -201,8 +203,10 @@ void register_irq_proc(unsigned int irq)
 
 void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 {
-	if (action->dir)
-		remove_proc_entry(action->dir->name, irq_desc[irq].dir);
+	if (action->dir) {
+		struct irq_desc *desc = get_irq_desc(irq);
+		remove_proc_entry(action->dir->name, desc->dir);
+	}
 }
 
 void register_default_affinity_proc(void)
Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c
+++ linux-2.6/kernel/irq/resend.c
@@ -36,7 +36,7 @@ static void resend_irqs(unsigned long ar
 	while (!bitmap_empty(irqs_resend, nr_irqs)) {
 		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
-		desc = irq_desc + irq;
+		desc = get_irq_desc(irq);
 		local_irq_disable();
 		desc->handle_irq(irq, desc);
 		local_irq_enable();
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -92,11 +92,12 @@ static int misrouted_irq(int irq)
 	int ok = 0;
 
 	for (i = 1; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc;
 
 		if (i == irq)	/* Already tried */
 			continue;
 
+		desc = get_irq_desc(i);
 		if (try_one_irq(i, desc))
 			ok = 1;
 	}
@@ -108,7 +109,7 @@ static void poll_spurious_irqs(unsigned
 {
 	int i;
 	for (i = 1; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = get_irq_desc(i);
 		unsigned int status;
 
 		/* Racy but it doesn't matter */
