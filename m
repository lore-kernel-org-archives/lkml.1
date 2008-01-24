Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYAZQJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYAZQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYAZP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:31 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756727AbYAZP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:27 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 08/52] [microblaze] Interrupt handling, timer support, supported function
Date: Thu, 24 Jan 2008 16:03:33 +0100
Message-Id: <671df2e842f46f829133f893b5388e29a797494d.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <9e7bb497ba4b4ffbb368d9613a0105529791e6b8.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
 <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
 <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
 <c4d02deb7e0a9a243a961bfe066e5d05e72a836e.1201107832.git.monstr@monstr.eu>
 <e83ac9f205e3ef0524ded397faf91a7a0750100c.1201107832.git.monstr@monstr.eu>
 <2802c9c0575435ca5c412601eb30a04f3fe4eec6.1201107832.git.monstr@monstr.eu>
 <9e7bb497ba4b4ffbb368d9613a0105529791e6b8.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/hack.c  |   88 +++++++++++++++++++++++++
 arch/microblaze/kernel/intc.c  |  141 ++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/irq.c   |   88 +++++++++++++++++++++++++
 arch/microblaze/kernel/timer.c |  134 ++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/hack.h  |   19 ++++++
 include/asm-microblaze/irq.h   |   34 ++++++++++
 6 files changed, 504 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/hack.c
 create mode 100644 arch/microblaze/kernel/intc.c
 create mode 100644 arch/microblaze/kernel/irq.c
 create mode 100644 arch/microblaze/kernel/timer.c
 create mode 100644 include/asm-microblaze/hack.h
 create mode 100644 include/asm-microblaze/irq.h

diff --git a/arch/microblaze/kernel/hack.c b/arch/microblaze/kernel/hack.c
new file mode 100644
index 0000000..627f06d
--- /dev/null
+++ b/arch/microblaze/kernel/hack.c
@@ -0,0 +1,88 @@
+/*
+ * arch/microblaze/kernel/hack.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#include <linux/interrupt.h>
+#include <asm/hack.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...)
+#endif
+
+/* NOTE
+ * self-modified part of code for improvement of interrupt controller
+ * save instruction in interrupt rutine
+ */
+void function_hack(const int *arr_fce, const unsigned int base)
+{
+	unsigned int flags = 0;
+	unsigned int j, i;
+	unsigned int *addr = NULL;
+
+	local_irq_save(flags);
+	__disable_icache();
+
+	/* zero terminated array */
+	for (j = 0; arr_fce[j] != 0; j++) {
+		/* get start address of function */
+		addr = (unsigned int *) arr_fce[j];
+		DBG("%s: func(%d) at 0x%x\n",
+					__FUNCTION__, j, (unsigned int) addr);
+		for (i = 0;; i++) {
+			DBG("%s: instruction code at %d: 0x%x\n",
+						__FUNCTION__, i, addr[i]);
+			if (addr[i] == 0xb0001234) {
+				/* detecting of lwi or swi instruction */
+				if ((addr[i+1] & 0xec00ff00) == 0xe800ff00) {
+					DBG("%s: curr instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __FUNCTION__, i, addr[i], i+1,
+								addr[i+1]);
+					addr[i] = 0xb0000000 + (base >> 16);
+					addr[i+1] = (addr[i+1] & 0xffff00ff) +
+							(base & 0xffff);
+					__invalidate_icache(addr[i]);
+					__invalidate_icache(addr[i+1]);
+					DBG("%s: hack instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __FUNCTION__, i, addr[i], i+1,
+								addr[i+1]);
+				} else /* detection addik for ack */
+				if ((addr[i+1] & 0xfc00ff00) == 0x3000ff00) {
+					DBG("%s: curr instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __FUNCTION__, i, addr[i], i+1,
+								addr[i+1]);
+					addr[i] = 0xb0000000 + (base >> 16);
+					addr[i+1] = (addr[i+1] & 0xffff00ff) +
+							(base & 0xffff);
+					__invalidate_icache(addr[i]);
+					__invalidate_icache(addr[i+1]);
+					DBG("%s: hack instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __FUNCTION__, i, addr[i], i+1,
+								addr[i+1]);
+				}
+			} else if (addr[i] == 0xb60f0008) {
+				DBG("%s: end of array %d\n",
+							__FUNCTION__, i);
+				break;
+			}
+		}
+	}
+	local_irq_restore(flags);
+} /* end of self-modified code */
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
new file mode 100644
index 0000000..7ed6a3a
--- /dev/null
+++ b/arch/microblaze/kernel/intc.c
@@ -0,0 +1,141 @@
+/*
+ * arch/microblaze/kernel/intc.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/autoconf.h>
+#include <asm/page.h>
+#include <asm/io.h>
+
+#include <asm/prom.h>
+#include <asm/irq.h>
+#include <asm/hack.h>
+unsigned int NR_IRQ;
+
+/* No one else should require these constants, so define them locally here. */
+#define ISR 0x00			/* Interrupt Status Register */
+#define IPR 0x04			/* Interrupt Pending Register */
+#define IER 0x08			/* Interrupt Enable Register */
+#define IAR 0x0c			/* Interrupt Acknowledge Register */
+#define SIE 0x10			/* Set Interrupt Enable bits */
+#define CIE 0x14			/* Clear Interrupt Enable bits */
+#define IVR 0x18			/* Interrupt Vector Register */
+#define MER 0x1c			/* Master Enable Register */
+
+#define MER_ME (1<<0)
+#define MER_HIE (1<<1)
+
+static void __init opb_intc_enable(unsigned int irq)
+{
+	unsigned int mask = (0x00000001 << (irq & 31));
+	pr_debug("enable: %d\n", irq);
+	iowrite32(mask, HACK_BASE_ADDR + SIE);
+}
+
+static void opb_intc_disable(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable: %d\n", irq);
+	iowrite32(mask, HACK_BASE_ADDR + CIE);
+}
+
+static void opb_intc_disable_and_ack(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable_and_ack: %d\n", irq);
+	iowrite32(mask, HACK_BASE_ADDR + CIE);
+	/* ack edge triggered intr */
+	if (!(irq_desc[irq].status & IRQ_LEVEL))
+		iowrite32(mask, HACK_BASE_ADDR + IAR);
+}
+
+static void opb_intc_end(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+
+	pr_debug("end: %d\n", irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+		iowrite32(mask, HACK_BASE_ADDR + SIE);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			iowrite32(mask, HACK_BASE_ADDR + IAR);
+	}
+}
+
+static struct irq_chip opb_intc = {
+	.name = "OPB-INTC",
+	.enable = opb_intc_enable,
+	.disable = opb_intc_disable,
+	.ack = opb_intc_disable_and_ack,
+	.end = opb_intc_end,
+};
+
+unsigned int get_irq(struct pt_regs *regs)
+{
+	int irq;
+
+	/*
+	 * NOTE: This function is the one that needs to be improved in
+	 * order to handle multiple interrupt controllers. It currently
+	 * is hardcoded to check for interrupts only on the first INTC.
+	 */
+
+	irq = ioread32(HACK_BASE_ADDR + IVR);
+	pr_debug("get_irq: %d\n", irq);
+
+	return irq;
+}
+
+void __init init_IRQ(void)
+{
+	int i = 0;
+	unsigned int intc_baseaddr = 0;
+	int handle = 0x010;
+	struct device_node *intc;
+	int arr_func[] = {
+				(int)&get_irq,
+				(int)&opb_intc_enable,
+				(int)&opb_intc_disable,
+				(int)&opb_intc_disable_and_ack,
+				(int)&opb_intc_end,
+				0
+			};
+
+	intc = of_find_compatible_node(NULL, NULL, "xlnx,opb-intc");
+	intc_baseaddr = *(int *) of_get_property(intc, "reg", NULL);
+	/* intc_baseaddr = (unsigned long) ioremap(intc_baseaddr, PAGE_SIZE); */
+	NR_IRQ = *(int *) of_get_property(intc, "xlnx,num-intr-inputs", NULL);
+
+	function_hack((int *) arr_func, intc_baseaddr);
+
+	printk(KERN_INFO "OPB INTC #0 at 0x%08lX, handle 0x%x\n",
+		(unsigned long) intc_baseaddr, handle);
+
+	/*
+	 * Disable all external interrupts until they are
+	 * explicity requested.
+	 */
+	iowrite32(0, intc_baseaddr + IER);
+
+	/* Acknowledge any pending interrupts just in case. */
+	iowrite32(0xffffffff, intc_baseaddr + IAR);
+
+	/* Turn on the Master Enable. */
+	iowrite32(MER_HIE|MER_ME, intc_baseaddr + MER);
+
+	for (i = 0; i < NR_IRQ; ++i) {
+		irq_desc[i].chip = &opb_intc;
+
+		if (handle & (0x00000001 << i))
+			irq_desc[i].status &= ~IRQ_LEVEL;
+		else
+			irq_desc[i].status |= IRQ_LEVEL;
+	}
+}
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
new file mode 100644
index 0000000..9b27199
--- /dev/null
+++ b/arch/microblaze/kernel/irq.c
@@ -0,0 +1,88 @@
+/*
+ * arch/microblaze/kernel/process.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/hardirq.h>
+#include <linux/interrupt.h>
+#include <linux/irqflags.h>
+#include <linux/seq_file.h>
+#include <linux/kernel_stat.h>
+
+#include <asm/irq.h>
+
+/*
+ * 'what should we do if we get a hw irq event on an illegal vector'.
+ * each architecture has to answer this themselves.
+ */
+void ack_bad_irq(unsigned int irq)
+{
+	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", irq);
+}
+
+void do_IRQ(struct pt_regs *regs)
+{
+	unsigned int irq;
+
+	irq_enter();
+	set_irq_regs(regs);
+	irq = get_irq(regs);
+	BUG_ON(irq == -1U);
+	__do_IRQ(irq);
+
+	irq_exit();
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_printf(p, "		");
+		for_each_online_cpu(j)
+			seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	if (i < NR_IRQ) {
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto skip;
+		seq_printf(p, "%3d: ", i);
+#ifndef CONFIG_SMP
+		seq_printf(p, "%10u ", kstat_irqs(i));
+#else
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+#endif
+		seq_printf(p, " %8s", irq_desc[i].status &
+					IRQ_LEVEL ? "level": "edge");
+		seq_printf(p, " %8s", irq_desc[i].chip->name);
+		seq_printf(p, "  %s", action->name);
+
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+skip:
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+	return 0;
+}
+
+/*unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
+{
+	printk ("ERROR %s\n",__FUNCTION__);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_of_parse_and_map);*/
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
new file mode 100644
index 0000000..a686cd7
--- /dev/null
+++ b/arch/microblaze/kernel/timer.c
@@ -0,0 +1,134 @@
+/*
+ * arch/microblaze/kernel/timer.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/interrupt.h>
+#include <linux/profile.h>
+#include <linux/irq.h>
+#include <asm/io.h>
+#include <asm/cpuinfo.h>
+#include <asm/setup.h>
+
+#include <asm/prom.h>
+#include <asm/hack.h>
+#include <asm/irq.h>
+
+#define TCSR0	(0x00)
+#define TLR0	(0x04)
+#define TCR0	(0x08)
+#define TCSR1	(0x10)
+#define TLR1	(0x14)
+#define TCR1	(0x18)
+
+#define TCSR_MDT	(1<<0)
+#define TCSR_UDT	(1<<1)
+#define TCSR_GENT	(1<<2)
+#define TCSR_CAPT	(1<<3)
+#define TCSR_ARHT	(1<<4)
+#define TCSR_LOAD	(1<<5)
+#define TCSR_ENIT	(1<<6)
+#define TCSR_ENT	(1<<7)
+#define TCSR_TINT	(1<<8)
+#define TCSR_PWMA	(1<<9)
+#define TCSR_ENALL	(1<<10)
+
+static void timer_ack(void)
+{
+	iowrite32(ioread32(HACK_BASE_ADDR + TCSR0), HACK_BASE_ADDR + TCSR0);
+}
+
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	heartbeat();
+
+	timer_ack();
+
+	write_seqlock(&xtime_lock);
+
+	do_timer(1);
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+
+	write_sequnlock(&xtime_lock);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irqaction = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.name = "timer",
+};
+
+unsigned long do_gettimeoffset(void)
+{
+	/* Current counter value */
+	unsigned int tcr = ioread32(HACK_BASE_ADDR + TCR0);
+
+	/* Load register value (couting down */
+	unsigned int tcmp = ioread32(HACK_BASE_ADDR + TLR0);
+
+	/* Offset, in nanoseconds */
+	/* FIXME remove loading from structure - build in is faster */
+	unsigned long offset = (tcmp-tcr)/(cpuinfo->cpu_clock_freq/1000000);
+
+	return offset;
+}
+
+void system_timer_init(void)
+{
+	int irq = 0;
+	struct device_node *timer;
+	unsigned int timer_baseaddr = 0;
+	int arr_func[] = {
+				(int)&do_gettimeoffset,
+				(int)&timer_ack,
+				0
+			};
+
+	timer = of_find_compatible_node(NULL, NULL, "xlnx,opb-timer");
+	timer_baseaddr = *(int *) of_get_property(timer, "reg", NULL);
+	/* timer_baseaddr =
+		(unsigned long) ioremap(timer_baseaddr, PAGE_SIZE); */
+	irq = *(int *) of_get_property(timer, "interrupts", NULL);
+
+	function_hack((int *) arr_func, timer_baseaddr);
+
+	printk(KERN_INFO "OPB TIMER #0 at 0x%08x, irq=%d\n",
+		timer_baseaddr, irq);
+
+	/* set the initial value to the load register */
+	iowrite32(cpuinfo->cpu_clock_freq/HZ, timer_baseaddr + TLR0);
+
+	/* load the initial value */
+	iowrite32(TCSR_LOAD, timer_baseaddr + TCSR0);
+
+	/* see opb timer data sheet for detail
+	 * !ENALL - don't enable 'em all
+	 * !PWMA - disable pwm
+	 * TINT - clear interrupt status
+	 * ENT- enable timer itself
+	 * EINT - enable interrupt
+	 * !LOAD - clear the bit to let go
+	 * ARHT - auto reload
+	 * !CAPT - no external trigger
+	 * !GENT - no external signal
+	 * UDT - set the timer as down counter
+	 * !MDT0 - generate mode
+	 *
+	 */
+	iowrite32(TCSR_TINT|TCSR_ENT|TCSR_ENIT|TCSR_ARHT|TCSR_UDT,
+			timer_baseaddr + TCSR0);
+
+	setup_irq(irq, &timer_irqaction);
+}
diff --git a/include/asm-microblaze/hack.h b/include/asm-microblaze/hack.h
new file mode 100644
index 0000000..5bfd557
--- /dev/null
+++ b/include/asm-microblaze/hack.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/hack.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+/*
+ * HACK_BASE_ADDR is constant address for hack function.
+ * do not change this value - it is hardcoded in hack function
+ * arch/microblaze/kernel/hack.c:function_hack()
+ */
+
+#define HACK_BASE_ADDR	0x1234ff00
+
+void function_hack(const int *arr_fce, const unsigned int base);
diff --git a/include/asm-microblaze/irq.h b/include/asm-microblaze/irq.h
new file mode 100644
index 0000000..1d9b9c4
--- /dev/null
+++ b/include/asm-microblaze/irq.h
@@ -0,0 +1,34 @@
+/*
+ * include/asm-microblaze/irq.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_IRQ_H
+#define _ASM_IRQ_H
+
+#include <linux/seq_file.h>
+#define NR_IRQS 32
+#include <linux/irq.h>
+
+extern unsigned int NR_IRQ;
+extern void ledoff(void);
+
+#define NO_IRQ (-1)
+
+static inline int irq_canonicalize(int irq)
+{
+	return (irq);
+}
+
+struct pt_regs;
+extern void do_IRQ(struct pt_regs *regs);
+extern void __init init_IRQ(void);
+int show_interrupts(struct seq_file *p, void *v);
+irqreturn_t timer_interrupt(int irq, void *dev_id);
+
+#endif /* _ASM_IRQ_H */
-- 
1.5.4.rc4.14.g6fc74

