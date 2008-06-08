Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbYFHLHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbYFHLHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbYFHLH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:07:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:44021 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbYFHLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Eip0Br0eyLtuxPEefgzqywAYPiyr3vPP/uQ7ZgWN3J05XXS7rGXAlAWWDRCGzpjwkU
         vMlNG6DRDmi0HxZ7osi8QY3medlmym1hTJ9zQ2IjvPCegZ3cyi53PQZUZxikLVeUm9qW
         0Ye2QjrmzKEowVB3Bi+RC1ZNTzvKRLUg52mMc=
Date: Sun, 8 Jun 2008 13:07:18 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes to arch/x86/kernel/io_apic_32.c
Message-ID: <20080608130718.5d36e25b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 91 errors, 73 warnings, 2850 lines checked

After:
total: 1 errors, 47 warnings, 2848 lines checked

Compile tested:

paolo@paolo-desktop:/tmp$ size io*
   text    data     bss     dec     hex filename
  13836    1756   11104   26696    6848 io_apic_32.o.after
  13836    1756   11104   26696    6848 io_apic_32.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |  356 +++++++++++++++++++++---------------------
 1 files changed, 177 insertions(+), 179 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 9dbe7e9..3ec4050 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -37,12 +37,12 @@
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 
-#include <asm/io.h>
-#include <asm/smp.h>
+#include <linux/io.h>
+#include <linux/smp.h>
 #include <asm/desc.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
-#include <asm/nmi.h>
+#include <linux/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 
@@ -81,7 +81,7 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+#if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
 
@@ -245,7 +245,7 @@ static void __init replace_pin_at_irq(unsigned int irq,
 	}
 }
 
-static void __modify_IO_APIC_irq (unsigned int irq, unsigned long enable, unsigned long disable)
+static void __modify_IO_APIC_irq(unsigned int irq, unsigned long enable, unsigned long disable)
 {
 	struct irq_pin_list *entry = irq_2_pin + irq;
 	unsigned int pin, reg;
@@ -265,30 +265,30 @@ static void __modify_IO_APIC_irq (unsigned int irq, unsigned long enable, unsign
 }
 
 /* mask = 1 */
-static void __mask_IO_APIC_irq (unsigned int irq)
+static void __mask_IO_APIC_irq(unsigned int irq)
 {
 	__modify_IO_APIC_irq(irq, 0x00010000, 0);
 }
 
 /* mask = 0 */
-static void __unmask_IO_APIC_irq (unsigned int irq)
+static void __unmask_IO_APIC_irq(unsigned int irq)
 {
 	__modify_IO_APIC_irq(irq, 0, 0x00010000);
 }
 
 /* mask = 1, trigger = 0 */
-static void __mask_and_edge_IO_APIC_irq (unsigned int irq)
+static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
 {
 	__modify_IO_APIC_irq(irq, 0x00010000, 0x00008000);
 }
 
 /* mask = 0, trigger = 1 */
-static void __unmask_and_level_IO_APIC_irq (unsigned int irq)
+static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
 {
 	__modify_IO_APIC_irq(irq, 0x00008000, 0x00010000);
 }
 
-static void mask_IO_APIC_irq (unsigned int irq)
+static void mask_IO_APIC_irq(unsigned int irq)
 {
 	unsigned long flags;
 
@@ -297,7 +297,7 @@ static void mask_IO_APIC_irq (unsigned int irq)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq (unsigned int irq)
+static void unmask_IO_APIC_irq(unsigned int irq)
 {
 	unsigned long flags;
 
@@ -309,7 +309,7 @@ static void unmask_IO_APIC_irq (unsigned int irq)
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
-	
+
 	/* Check delivery_mode to be sure we're not clearing an SMI pin */
 	entry = ioapic_read_entry(apic, pin);
 	if (entry.delivery_mode == dest_SMI)
@@ -321,7 +321,7 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 	ioapic_mask_entry(apic, pin);
 }
 
-static void clear_IO_APIC (void)
+static void clear_IO_APIC(void)
 {
 	int apic, pin;
 
@@ -338,7 +338,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 	struct irq_pin_list *entry = irq_2_pin + irq;
 	unsigned int apicid_value;
 	cpumask_t tmp;
-	
+
 	cpus_and(tmp, cpumask, cpu_online_map);
 	if (cpus_empty(tmp))
 		tmp = TARGET_CPUS;
@@ -367,7 +367,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 # include <linux/kernel_stat.h>	/* kstat */
 # include <linux/slab.h>		/* kmalloc() */
 # include <linux/timer.h>
- 
+
 #define IRQBALANCE_CHECK_ARCH -999
 #define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
 #define MIN_BALANCED_IRQ_INTERVAL	(HZ/2)
@@ -379,14 +379,14 @@ static int physical_balance __read_mostly;
 static long balanced_irq_interval __read_mostly = MAX_BALANCED_IRQ_INTERVAL;
 
 static struct irq_cpu_info {
-	unsigned long * last_irq;
-	unsigned long * irq_delta;
+	unsigned long *last_irq;
+	unsigned long *irq_delta;
 	unsigned long irq;
 } irq_cpu_data[NR_CPUS];
 
 #define CPU_IRQ(cpu)		(irq_cpu_data[cpu].irq)
-#define LAST_CPU_IRQ(cpu,irq)   (irq_cpu_data[cpu].last_irq[irq])
-#define IRQ_DELTA(cpu,irq) 	(irq_cpu_data[cpu].irq_delta[irq])
+#define LAST_CPU_IRQ(cpu, irq)   (irq_cpu_data[cpu].last_irq[irq])
+#define IRQ_DELTA(cpu, irq) 	(irq_cpu_data[cpu].irq_delta[irq])
 
 #define IDLE_ENOUGH(cpu,now) \
 	(idle_cpu(cpu) && ((now) - per_cpu(irq_stat, (cpu)).idle_timestamp > 1))
@@ -425,8 +425,8 @@ inside:
 			if (cpu == -1)
 				cpu = NR_CPUS-1;
 		}
-	} while (!cpu_online(cpu) || !IRQ_ALLOWED(cpu,allowed_mask) ||
-			(search_idle && !IDLE_ENOUGH(cpu,now)));
+	} while (!cpu_online(cpu) || !IRQ_ALLOWED(cpu, allowed_mask) ||
+			(search_idle && !IDLE_ENOUGH(cpu, now)));
 
 	return cpu;
 }
@@ -436,15 +436,14 @@ static inline void balance_irq(int cpu, int irq)
 	unsigned long now = jiffies;
 	cpumask_t allowed_mask;
 	unsigned int new_cpu;
-		
+
 	if (irqbalance_disabled)
-		return; 
+		return;
 
 	cpus_and(allowed_mask, cpu_online_map, balance_irq_affinity[irq]);
 	new_cpu = move(cpu, allowed_mask, now, 1);
-	if (cpu != new_cpu) {
+	if (cpu != new_cpu)
 		set_pending_irq(irq, cpumask_of_cpu(new_cpu));
-	}
 }
 
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
@@ -456,14 +455,14 @@ static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 			if (!irq_desc[j].action)
 				continue;
 			/* Is it a significant load ?  */
-			if (IRQ_DELTA(CPU_TO_PACKAGEINDEX(i),j) <
+			if (IRQ_DELTA(CPU_TO_PACKAGEINDEX(i), j) <
 						useful_load_threshold)
 				continue;
 			balance_irq(i, j);
 		}
 	}
 	balanced_irq_interval = max((long)MIN_BALANCED_IRQ_INTERVAL,
-		balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);	
+		balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);
 	return;
 }
 
@@ -492,22 +491,22 @@ static void do_irq_balance(void)
 			/* Is this an active IRQ or balancing disabled ? */
 			if (!irq_desc[j].action || irq_balancing_disabled(j))
 				continue;
-			if ( package_index == i )
-				IRQ_DELTA(package_index,j) = 0;
+			if (package_index == i)
+				IRQ_DELTA(package_index, j) = 0;
 			/* Determine the total count per processor per IRQ */
 			value_now = (unsigned long) kstat_cpu(i).irqs[j];
 
 			/* Determine the activity per processor per IRQ */
-			delta = value_now - LAST_CPU_IRQ(i,j);
+			delta = value_now - LAST_CPU_IRQ(i, j);
 
 			/* Update last_cpu_irq[][] for the next time */
-			LAST_CPU_IRQ(i,j) = value_now;
+			LAST_CPU_IRQ(i, j) = value_now;
 
 			/* Ignore IRQs whose rate is less than the clock */
 			if (delta < useful_load_threshold)
 				continue;
 			/* update the load for the processor or package total */
-			IRQ_DELTA(package_index,j) += delta;
+			IRQ_DELTA(package_index, j) += delta;
 
 			/* Keep track of the higher numbered sibling as well */
 			if (i != package_index)
@@ -533,7 +532,8 @@ static void do_irq_balance(void)
 	max_cpu_irq = ULONG_MAX;
 
 tryanothercpu:
-	/* Look for heaviest loaded processor.
+	/*
+	 * Look for heaviest loaded processor.
 	 * We may come back to get the next heaviest loaded processor.
 	 * Skip processors with trivial loads.
 	 */
@@ -542,7 +542,7 @@ tryanothercpu:
 	for_each_online_cpu(i) {
 		if (i != CPU_TO_PACKAGEINDEX(i))
 			continue;
-		if (max_cpu_irq <= CPU_IRQ(i)) 
+		if (max_cpu_irq <= CPU_IRQ(i))
 			continue;
 		if (tmp_cpu_irq < CPU_IRQ(i)) {
 			tmp_cpu_irq = CPU_IRQ(i);
@@ -551,8 +551,9 @@ tryanothercpu:
 	}
 
 	if (tmp_loaded == -1) {
- 	 /* In the case of small number of heavy interrupt sources, 
-	  * loading some of the cpus too much. We use Ingo's original 
+	 /*
+	  * In the case of small number of heavy interrupt sources,
+	  * loading some of the cpus too much. We use Ingo's original
 	  * approach to rotate them around.
 	  */
 		if (!first_attempt && imbalance >= useful_load_threshold) {
@@ -561,13 +562,14 @@ tryanothercpu:
 		}
 		goto not_worth_the_effort;
 	}
-	
+
 	first_attempt = 0;		/* heaviest search */
 	max_cpu_irq = tmp_cpu_irq;	/* load */
 	max_loaded = tmp_loaded;	/* processor */
 	imbalance = (max_cpu_irq - min_cpu_irq) / 2;
-	
-	/* if imbalance is less than approx 10% of max load, then
+
+	/*
+	 * if imbalance is less than approx 10% of max load, then
 	 * observe diminishing returns action. - quit
 	 */
 	if (imbalance < (max_cpu_irq >> 3))
@@ -583,26 +585,25 @@ tryanotherirq:
 		/* Is this an active IRQ? */
 		if (!irq_desc[j].action)
 			continue;
-		if (imbalance <= IRQ_DELTA(max_loaded,j))
+		if (imbalance <= IRQ_DELTA(max_loaded, j))
 			continue;
 		/* Try to find the IRQ that is closest to the imbalance
 		 * without going over.
 		 */
-		if (move_this_load < IRQ_DELTA(max_loaded,j)) {
-			move_this_load = IRQ_DELTA(max_loaded,j);
+		if (move_this_load < IRQ_DELTA(max_loaded, j)) {
+			move_this_load = IRQ_DELTA(max_loaded, j);
 			selected_irq = j;
 		}
 	}
-	if (selected_irq == -1) {
+	if (selected_irq == -1)
 		goto tryanothercpu;
-	}
 
 	imbalance = move_this_load;
-	
+
 	/* For physical_balance case, we accumulated both load
 	 * values in the one of the siblings cpu_irq[],
 	 * to use the same code for physical and logical processors
-	 * as much as possible. 
+	 * as much as possible.
 	 *
 	 * NOTE: the cpu_irq[] array holds the sum of the load for
 	 * sibling A and sibling B in the slot for the lowest numbered
@@ -631,11 +632,11 @@ tryanotherirq:
 		/* mark for change destination */
 		set_pending_irq(selected_irq, cpumask_of_cpu(min_loaded));
 
-		/* Since we made a change, come back sooner to 
+		/* Since we made a change, come back sooner to
 		 * check for more variation.
 		 */
 		balanced_irq_interval = max((long)MIN_BALANCED_IRQ_INTERVAL,
-			balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);	
+			balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);
 		return;
 	}
 	goto tryanotherirq;
@@ -646,7 +647,7 @@ not_worth_the_effort:
 	 * upward
 	 */
 	balanced_irq_interval = min((long)MAX_BALANCED_IRQ_INTERVAL,
-		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);	
+		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);
 	return;
 }
 
@@ -685,13 +686,13 @@ static int __init balanced_irq_init(void)
 	cpumask_t tmp;
 
 	cpus_shift_right(tmp, cpu_online_map, 2);
-        c = &boot_cpu_data;
+	c = &boot_cpu_data;
 	/* When not overwritten by the command line ask subarchitecture. */
 	if (irqbalance_disabled == IRQBALANCE_CHECK_ARCH)
 		irqbalance_disabled = NO_BALANCE_IRQ;
 	if (irqbalance_disabled)
 		return 0;
-	
+
 	 /* disable irqbalance completely if there is only one processor online */
 	if (num_online_cpus() < 2) {
 		irqbalance_disabled = 1;
@@ -711,10 +712,10 @@ static int __init balanced_irq_init(void)
 			printk(KERN_ERR "balanced_irq_init: out of memory");
 			goto failed;
 		}
-		memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
-		memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
+		memset(irq_cpu_data[i].irq_delta, 0, sizeof(unsigned long) * NR_IRQS);
+		memset(irq_cpu_data[i].last_irq, 0, sizeof(unsigned long) * NR_IRQS);
 	}
-	
+
 	printk(KERN_INFO "Starting balanced_irq\n");
 	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
 		return 0;
@@ -849,7 +850,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	}
 	if (i < mp_irq_entries) {
 		int apic;
-		for(apic = 0; apic < nr_ioapics; apic++) {
+		for (apic = 0; apic < nr_ioapics; apic++) {
 			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
 				return apic;
 		}
@@ -886,7 +887,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		    !mp_irqs[i].mp_irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
+			int irq = pin_2_irq(i, apic, mp_irqs[i].mp_dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
@@ -906,7 +907,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
 /*
- * This function currently is only a helper for the i386 smp boot process where 
+ * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
  * so mask in all cases should simply be TARGET_CPUS
  */
@@ -981,37 +982,36 @@ static int MPBIOS_polarity(int idx)
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mp_irqflag & 3)
+	switch (mp_irqs[idx].mp_irqflag & 3) {
+	case 0: /* conforms, ie. bus-type dependent polarity */
 	{
-		case 0: /* conforms, ie. bus-type dependent polarity */
-		{
-			polarity = test_bit(bus, mp_bus_not_pci)?
-				default_ISA_polarity(idx):
-				default_PCI_polarity(idx);
-			break;
-		}
-		case 1: /* high active */
-		{
-			polarity = 0;
-			break;
-		}
-		case 2: /* reserved */
-		{
-			printk(KERN_WARNING "broken BIOS!!\n");
-			polarity = 1;
-			break;
-		}
-		case 3: /* low active */
-		{
-			polarity = 1;
-			break;
-		}
-		default: /* invalid */
-		{
-			printk(KERN_WARNING "broken BIOS!!\n");
-			polarity = 1;
-			break;
-		}
+		polarity = test_bit(bus, mp_bus_not_pci)?
+			default_ISA_polarity(idx):
+			default_PCI_polarity(idx);
+		break;
+	}
+	case 1: /* high active */
+	{
+		polarity = 0;
+		break;
+	}
+	case 2: /* reserved */
+	{
+		printk(KERN_WARNING "broken BIOS!!\n");
+		polarity = 1;
+		break;
+	}
+	case 3: /* low active */
+	{
+		polarity = 1;
+		break;
+	}
+	default: /* invalid */
+	{
+		printk(KERN_WARNING "broken BIOS!!\n");
+		polarity = 1;
+		break;
+	}
 	}
 	return polarity;
 }
@@ -1024,69 +1024,67 @@ static int MPBIOS_trigger(int idx)
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].mp_irqflag>>2) & 3) {
+	case 0: /* conforms, ie. bus-type dependent */
 	{
-		case 0: /* conforms, ie. bus-type dependent */
-		{
-			trigger = test_bit(bus, mp_bus_not_pci)?
-					default_ISA_trigger(idx):
-					default_PCI_trigger(idx);
+		trigger = test_bit(bus, mp_bus_not_pci)?
+				default_ISA_trigger(idx):
+				default_PCI_trigger(idx);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-			switch (mp_bus_id_to_type[bus])
-			{
-				case MP_BUS_ISA: /* ISA pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				case MP_BUS_EISA: /* EISA pin */
-				{
-					trigger = default_EISA_trigger(idx);
-					break;
-				}
-				case MP_BUS_PCI: /* PCI pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				case MP_BUS_MCA: /* MCA pin */
-				{
-					trigger = default_MCA_trigger(idx);
-					break;
-				}
-				default:
-				{
-					printk(KERN_WARNING "broken BIOS!!\n");
-					trigger = 1;
-					break;
-				}
-			}
-#endif
+		switch (mp_bus_id_to_type[bus]) {
+		case MP_BUS_ISA: /* ISA pin */
+		{
+			/* set before the switch */
 			break;
 		}
-		case 1: /* edge */
+		case MP_BUS_EISA: /* EISA pin */
 		{
-			trigger = 0;
+			trigger = default_EISA_trigger(idx);
 			break;
 		}
-		case 2: /* reserved */
+		case MP_BUS_PCI: /* PCI pin */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
-			trigger = 1;
+			/* set before the switch */
 			break;
 		}
-		case 3: /* level */
+		case MP_BUS_MCA: /* MCA pin */
 		{
-			trigger = 1;
+			trigger = default_MCA_trigger(idx);
 			break;
 		}
-		default: /* invalid */
+		default:
 		{
 			printk(KERN_WARNING "broken BIOS!!\n");
-			trigger = 0;
+			trigger = 1;
 			break;
 		}
 	}
+#endif
+		break;
+	}
+	case 1: /* edge */
+	{
+		trigger = 0;
+		break;
+	}
+	case 2: /* reserved */
+	{
+		printk(KERN_WARNING "broken BIOS!!\n");
+		trigger = 1;
+		break;
+	}
+	case 3: /* level */
+	{
+		trigger = 1;
+		break;
+	}
+	default: /* invalid */
+	{
+		printk(KERN_WARNING "broken BIOS!!\n");
+		trigger = 0;
+		break;
+	}
+	}
 	return trigger;
 }
 
@@ -1154,8 +1152,8 @@ static inline int IO_APIC_irq_trigger(int irq)
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			idx = find_irq_entry(apic,pin,mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx,apic,pin)))
+			idx = find_irq_entry(apic, pin, mp_INT);
+			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
 				return irq_trigger(idx);
 		}
 	}
@@ -1170,7 +1168,7 @@ static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 }
 
 static int __assign_irq_vector(int irq)
 {
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_vector = FIRST_DEVICE_VECTOR, current_offset;
 	int vector, offset;
 
 	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
@@ -1243,15 +1241,15 @@ static void __init setup_IO_APIC_irqs(void)
 		/*
 		 * add it to the IO-APIC irq-routing table:
 		 */
-		memset(&entry,0,sizeof(entry));
+		memset(&entry, 0, sizeof(entry));
 
 		entry.delivery_mode = INT_DELIVERY_MODE;
 		entry.dest_mode = INT_DEST_MODE;
 		entry.mask = 0;				/* enable IRQ */
-		entry.dest.logical.logical_dest = 
+		entry.dest.logical.logical_dest =
 					cpu_mask_to_apicid(TARGET_CPUS);
 
-		idx = find_irq_entry(apic,pin,mp_INT);
+		idx = find_irq_entry(apic, pin, mp_INT);
 		if (idx == -1) {
 			if (first_notcon) {
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
@@ -1295,7 +1293,7 @@ static void __init setup_IO_APIC_irqs(void)
 			vector = assign_irq_vector(irq);
 			entry.vector = vector;
 			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
-		
+
 			if (!apic && (irq < 16))
 				disable_8259A_irq(irq);
 		}
@@ -1315,7 +1313,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 {
 	struct IO_APIC_route_entry entry;
 
-	memset(&entry,0,sizeof(entry));
+	memset(&entry, 0, sizeof(entry));
 
 	/*
 	 * We use logical delivery to get the timer IRQ
@@ -1353,7 +1351,7 @@ void __init print_IO_APIC(void)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
- 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
 		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
@@ -1458,7 +1456,7 @@ void __init print_IO_APIC(void)
 
 #if 0
 
-static void print_APIC_bitfield (int base)
+static void print_APIC_bitfield(int base)
 {
 	unsigned int v;
 	int i, j;
@@ -1479,7 +1477,7 @@ static void print_APIC_bitfield (int base)
 	}
 }
 
-void /*__init*/ print_local_APIC(void * dummy)
+void /*__init*/ print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
 
@@ -1562,7 +1560,7 @@ void /*__init*/ print_local_APIC(void * dummy)
 	printk("\n");
 }
 
-void print_all_local_APICs (void)
+void print_all_local_APICs(void)
 {
 	on_each_cpu(print_local_APIC, NULL, 1, 1);
 }
@@ -1585,11 +1583,11 @@ void /*__init*/ print_PIC(void)
 	v = inb(0xa0) << 8 | inb(0x20);
 	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
 
-	outb(0x0b,0xa0);
-	outb(0x0b,0x20);
+	outb(0x0b, 0xa0);
+	outb(0x0b, 0x20);
 	v = inb(0xa0) << 8 | inb(0x20);
-	outb(0x0a,0xa0);
-	outb(0x0a,0x20);
+	outb(0x0a, 0xa0);
+	outb(0x0a, 0x20);
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
@@ -1625,7 +1623,7 @@ static void __init enable_IO_APIC(void)
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
-	for(apic = 0; apic < nr_ioapics; apic++) {
+	for (apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
@@ -1747,7 +1745,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		
+
 		old_id = mp_ioapics[apic].mp_apicid;
 
 		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
@@ -1799,7 +1797,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		/*
 		 * Read the right value from the MPC table and
 		 * write it into the ID register.
-	 	 */
+		 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic].mp_apicid);
@@ -2019,7 +2017,7 @@ static void ack_apic(unsigned int irq)
 	ack_APIC_irq();
 }
 
-static void mask_lapic_irq (unsigned int irq)
+static void mask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
@@ -2027,7 +2025,7 @@ static void mask_lapic_irq (unsigned int irq)
 	apic_write_around(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq (unsigned int irq)
+static void unmask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
@@ -2045,14 +2043,14 @@ static struct irq_chip lapic_chip __read_mostly = {
 static void __init setup_nmi(void)
 {
 	/*
- 	 * Dirty trick to enable the NMI watchdog ...
+	 * Dirty trick to enable the NMI watchdog ...
 	 * We put the 8259A master into AEOI mode and
 	 * unmask on all local APICs LVT0 as NMI.
 	 *
 	 * The idea to use the 8259A in AEOI mode ('8259A Virtual Wire')
 	 * is from Maciej W. Rozycki - so we do not have to EOI from
 	 * the NMI handler or the timer interrupt.
-	 */ 
+	 */
 	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
 	enable_NMI_through_LVT0();
@@ -2316,10 +2314,10 @@ void __init setup_IO_APIC(void)
  *	Called after all the initialization is done. If we didnt find any
  *	APIC bugs then we can allow the modify fast path
  */
- 
+
 static int __init io_apic_bug_finalize(void)
 {
-	if(sis_apic_bug == -1)
+	if (sis_apic_bug == -1)
 		sis_apic_bug = 0;
 	return 0;
 }
@@ -2330,17 +2328,17 @@ struct sysfs_ioapic_data {
 	struct sys_device dev;
 	struct IO_APIC_route_entry entry[0];
 };
-static struct sysfs_ioapic_data * mp_ioapic_data[MAX_IO_APICS];
+static struct sysfs_ioapic_data *mp_ioapic_data[MAX_IO_APICS];
 
 static int ioapic_suspend(struct sys_device *dev, pm_message_t state)
 {
 	struct IO_APIC_route_entry *entry;
 	struct sysfs_ioapic_data *data;
 	int i;
-	
+
 	data = container_of(dev, struct sysfs_ioapic_data, dev);
 	entry = data->entry;
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i ++)
+	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
 		entry[i] = ioapic_read_entry(dev->id, i);
 
 	return 0;
@@ -2353,7 +2351,7 @@ static int ioapic_resume(struct sys_device *dev)
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
 	int i;
-	
+
 	data = container_of(dev, struct sysfs_ioapic_data, dev);
 	entry = data->entry;
 
@@ -2364,7 +2362,7 @@ static int ioapic_resume(struct sys_device *dev)
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i ++)
+	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
 		ioapic_write_entry(dev->id, i, entry[i]);
 
 	return 0;
@@ -2378,15 +2376,15 @@ static struct sysdev_class ioapic_sysdev_class = {
 
 static int __init ioapic_init_sysfs(void)
 {
-	struct sys_device * dev;
+	struct sys_device *dev;
 	int i, size, error = 0;
 
 	error = sysdev_class_register(&ioapic_sysdev_class);
 	if (error)
 		return error;
 
-	for (i = 0; i < nr_ioapics; i++ ) {
-		size = sizeof(struct sys_device) + nr_ioapic_registers[i] 
+	for (i = 0; i < nr_ioapics; i++) {
+		size = sizeof(struct sys_device) + nr_ioapic_registers[i]
 			* sizeof(struct IO_APIC_route_entry);
 		mp_ioapic_data[i] = kmalloc(size, GFP_KERNEL);
 		if (!mp_ioapic_data[i]) {
@@ -2395,7 +2393,7 @@ static int __init ioapic_init_sysfs(void)
 		}
 		memset(mp_ioapic_data[i], 0, size);
 		dev = &mp_ioapic_data[i]->dev;
-		dev->id = i; 
+		dev->id = i;
 		dev->cls = &ioapic_sysdev_class;
 		error = sysdev_register(dev);
 		if (error) {
@@ -2470,7 +2468,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
 			((INT_DEST_MODE == 0) ?
-				MSI_ADDR_DEST_MODE_PHYSICAL:
+MSI_ADDR_DEST_MODE_PHYSICAL:
 				MSI_ADDR_DEST_MODE_LOGICAL) |
 			((INT_DELIVERY_MODE != dest_LowestPrio) ?
 				MSI_ADDR_REDIRECTION_CPU:
@@ -2481,7 +2479,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 			MSI_DATA_TRIGGER_EDGE |
 			MSI_DATA_LEVEL_ASSERT |
 			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-				MSI_DATA_DELIVERY_FIXED:
+MSI_DATA_DELIVERY_FIXED:
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(vector);
 	}
@@ -2652,12 +2650,12 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 #endif /* CONFIG_HT_IRQ */
 
 /* --------------------------------------------------------------------------
-                          ACPI-based IOAPIC Configuration
+			ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
 
 #ifdef CONFIG_ACPI
 
-int __init io_apic_get_unique_id (int ioapic, int apic_id)
+int __init io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -2666,10 +2664,10 @@ int __init io_apic_get_unique_id (int ioapic, int apic_id)
 	int i = 0;
 
 	/*
-	 * The P4 platform supports up to 256 APIC IDs on two separate APIC 
-	 * buses (one for LAPICs, one for IOAPICs), where predecessors only 
+	 * The P4 platform supports up to 256 APIC IDs on two separate APIC
+	 * buses (one for LAPICs, one for IOAPICs), where predecessors only
 	 * supports up to 16 on one shared APIC bus.
-	 * 
+	 *
 	 * TBD: Expand LAPIC/IOAPIC support on P4-class systems to take full
 	 *      advantage of new APIC bus architecture.
 	 */
@@ -2688,7 +2686,7 @@ int __init io_apic_get_unique_id (int ioapic, int apic_id)
 	}
 
 	/*
-	 * Every APIC in a system must have a unique ID or we get lots of nice 
+	 * Every APIC in a system must have a unique ID or we get lots of nice
 	 * 'stuck on smp_invalidate_needed IPI wait' messages.
 	 */
 	if (check_apicid_used(apic_id_map, apic_id)) {
@@ -2705,7 +2703,7 @@ int __init io_apic_get_unique_id (int ioapic, int apic_id)
 			"trying %d\n", ioapic, apic_id, i);
 
 		apic_id = i;
-	} 
+	}
 
 	tmp = apicid_to_cpu_present(apic_id);
 	physids_or(apic_id_map, apic_id_map, tmp);
@@ -2732,7 +2730,7 @@ int __init io_apic_get_unique_id (int ioapic, int apic_id)
 }
 
 
-int __init io_apic_get_version (int ioapic)
+int __init io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -2745,7 +2743,7 @@ int __init io_apic_get_version (int ioapic)
 }
 
 
-int __init io_apic_get_redir_entries (int ioapic)
+int __init io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -2758,7 +2756,7 @@ int __init io_apic_get_redir_entries (int ioapic)
 }
 
 
-int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int active_high_low)
+int io_apic_set_pci_routing(int ioapic, int pin, int irq, int edge_level, int active_high_low)
 {
 	struct IO_APIC_route_entry entry;
 
@@ -2774,7 +2772,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int a
 	 * corresponding device driver registers for this IRQ.
 	 */
 
-	memset(&entry,0,sizeof(entry));
+	memset(&entry, 0, sizeof(entry));
 
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
-- 
1.5.6.rc1.21.g03300

