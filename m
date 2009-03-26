Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZCZPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZCZPkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZCZPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:40:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZCZPk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:40:28 -0400
Date: Thu, 26 Mar 2009 16:40:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] irq updates for v2.6.30
Message-ID: <20090326154000.GA7524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-for-linus

Highlights:

 - Sparseirq finishing touches

 - Flush out pre-genirq migration helper constructs

Risks:

 - The sparseirq bits had a higher than usual proportion of non-x86 
   build bugs during development. No known regressions.

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      fix "sparseirq: use kstat_irqs_cpu on non-x86 architectures too"

David Miller (2):
      sparc64: Fix build by including linux/irq.h into time_64.c
      sparc64: Fix build by using kstat_irqs_cpu()

Hannes Eder (1):
      kernel/irq: fix sparse warning: make symbol static

Ingo Molnar (5):
      irq: provide debug_poll_all_shared_irqs() method under CONFIG_DEBUG_SHIRQ
      irq: clean up manage.c
      irq: refactor and clean up the free_irq() code flow
      irq: further clean up the free_irq() code flow
      irq: name 'p' variables a bit better

Johannes Weiner (1):
      irq: use GFP_KERNEL for action allocation in request_irq()

KOSAKI Motohiro (1):
      sparseirq: make for_each_irq_desc() more robust

Magnus Damm (3):
      irq: add remove_irq() for freeing of setup_irq() irqs
      irq: match remove_irq() args with setup_irq()
      irq: export remove_irq() and setup_irq() symbols

Peter Zijlstra (1):
      genirq: assert that irq handlers are indeed running in hardirq context

Stephen Rothwell (1):
      sparseirq, powerpc/cell: fix unused variable warning in interrupt.c

Thomas Gleixner (8):
      genirq: remove unused hw_irq_controller typedef
      genirq: remove redundant if condition
      genirq: make irqreturn_t an enum
      genirq: use kzalloc instead of explicit zero initialization
      genirq: add doc to struct irqaction
      genirq: deprecate __do_IRQ
      genirq: deprecate obsolete typedefs and defines
      x86: disable __do_IRQ support

Wang Chen (1):
      genirq: check chip->ack before calling

Yinghai Lu (7):
      sparseirq: make some func to be used with genirq
      sparseirq: use kstat_irqs_cpu instead
      sparseirq: fix build with unknown irq_desc struct
      sparseirq: use kstat_irqs_cpu on non-x86 architectures too
      irq: clean up irq stat methods
      irq: clear kstat_irqs
      irq: optimize init_kstat_irqs/init_copy_kstat_irqs


 Documentation/DocBook/genericirq.tmpl      |    1 +
 Documentation/feature-removal-schedule.txt |   17 +++
 arch/alpha/kernel/irq.c                    |    2 +-
 arch/alpha/kernel/irq_alpha.c              |    2 +-
 arch/arm/kernel/irq.c                      |    2 +-
 arch/arm/mach-ns9xxx/irq.c                 |    3 +-
 arch/avr32/kernel/irq.c                    |    2 +-
 arch/blackfin/kernel/irqchip.c             |    2 +-
 arch/cris/kernel/irq.c                     |    2 +-
 arch/frv/kernel/irq.c                      |    2 +-
 arch/h8300/kernel/irq.c                    |    4 +-
 arch/ia64/kernel/irq.c                     |    2 +-
 arch/m32r/kernel/irq.c                     |    2 +-
 arch/mips/kernel/irq.c                     |    2 +-
 arch/mn10300/kernel/irq.c                  |    2 +-
 arch/parisc/kernel/irq.c                   |    2 +-
 arch/powerpc/kernel/irq.c                  |    2 +-
 arch/powerpc/platforms/cell/interrupt.c    |    4 +-
 arch/sh/kernel/irq.c                       |    2 +-
 arch/sparc/kernel/irq_64.c                 |    2 +-
 arch/sparc/kernel/time_64.c                |    2 +-
 arch/um/kernel/irq.c                       |    2 +-
 arch/x86/Kconfig                           |    3 +
 arch/xtensa/kernel/irq.c                   |    2 +-
 drivers/char/random.c                      |    6 +-
 drivers/pci/intr_remapping.c               |    2 +-
 include/linux/interrupt.h                  |   17 +++
 include/linux/irq.h                        |   16 +--
 include/linux/irqnr.h                      |    8 +-
 include/linux/irqreturn.h                  |   28 ++---
 include/linux/kernel_stat.h                |   13 +-
 kernel/irq/chip.c                          |    7 +-
 kernel/irq/handle.c                        |   39 ++++--
 kernel/irq/internals.h                     |    1 +
 kernel/irq/manage.c                        |  192 ++++++++++++++++------------
 kernel/irq/numa_migrate.c                  |   11 +-
 kernel/irq/spurious.c                      |   14 ++-
 37 files changed, 252 insertions(+), 170 deletions(-)

diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index 3a882d9..c671a01 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -440,6 +440,7 @@ desc->chip->end();
      used in the generic IRQ layer.
      </para>
 !Iinclude/linux/irq.h
+!Iinclude/linux/interrupt.h
   </chapter>
 
   <chapter id="pubfunctions">
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20d3b94..9aa1dda 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -344,3 +344,20 @@ Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and
 	Removal is subject to fixing any remaining bugs in ACPI which may
 	cause the thermal throttling not to happen at the right time.
 Who:	Dave Jones <davej@redhat.com>, Matthew Garrett <mjg@redhat.com>
+
+-----------------------------
+
+What:	__do_IRQ all in one fits nothing interrupt handler
+When:	2.6.32
+Why:	__do_IRQ was kept for easy migration to the type flow handlers.
+	More than two years of migration time is enough.
+Who:	Thomas Gleixner <tglx@linutronix.de>
+
+-----------------------------
+
+What:	obsolete generic irq defines and typedefs
+When:	2.6.30
+Why:	The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t)
+	have been kept around for migration reasons. After more than two years
+	it's time to remove them finally
+Who:	Thomas Gleixner <tglx@linutronix.de>
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 703731a..d3812eb 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -90,7 +90,7 @@ show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(irq));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[irq]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
 		seq_printf(p, "  %c%s",
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index e16aeb6..67c19f8 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -64,7 +64,7 @@ do_entInt(unsigned long type, unsigned long vector,
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-		        kstat_cpu(cpu).irqs[RTC_IRQ]++;
+		        kstat_incr_irqs_this_cpu(RTC_IRQ, irq_to_desc(RTC_IRQ));
 		} else {
 			handle_irq(RTC_IRQ);
 		}
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 363db18..7296f04 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -76,7 +76,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 		seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 22e0eb6..feb0e54 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -63,7 +63,6 @@ static struct irq_chip ns9xxx_chip = {
 #else
 static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -72,7 +71,7 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 	BUG_ON(desc->status & IRQ_INPROGRESS);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index a8e767d..9f57222 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -58,7 +58,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 7fd1265..bd052a6 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -83,7 +83,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %8s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 2dfac8c..7f642fc 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -66,7 +66,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 73abae7..af3e824 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -74,7 +74,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index ef4f004..74f8dd7 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -183,7 +183,7 @@ asmlinkage void do_IRQ(int irq)
 #if defined(CONFIG_PROC_FS)
 int show_interrupts(struct seq_file *p, void *v)
 {
-	int i = *(loff_t *) v, j;
+	int i = *(loff_t *) v;
 	struct irqaction * action;
 	unsigned long flags;
 
@@ -196,7 +196,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
-		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+		seq_printf(p, "%10u ", kstat_irqs(i));
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index a58f64c..4f59661 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -80,7 +80,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j) {
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		}
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index 2aeae46..8dfd31e 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -49,7 +49,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 4b4007b..7b845ba 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -108,7 +108,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 56c64cc..50fdb5c 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -221,7 +221,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 29e70e1..adfd617 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -185,7 +185,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 23b8b5e..17efb71 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -190,7 +190,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif /* CONFIG_SMP */
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 28c04da..882e470 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -237,8 +237,6 @@ extern int noirqdebug;
 
 static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	const unsigned int cpu = smp_processor_id();
-
 	spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
@@ -254,7 +252,7 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 		goto out_eoi;
 	}
 
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 64b7690..0080a16 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 1c378d8..8ba064f 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -185,7 +185,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %9s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 2db3c22..642562d 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -36,10 +36,10 @@
 #include <linux/clocksource.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 
 #include <asm/oplib.h>
 #include <asm/timer.h>
-#include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/starfire.h>
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3d7aad0..336b615 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -42,7 +42,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc2fbad..3a330a4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -165,6 +165,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+       def_bool y
+
 config GENERIC_IRQ_PROBE
 	bool
 	default y
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 5fbcde5..f3b66fb 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -99,7 +99,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7c13581..7c43ae7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -241,6 +241,10 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+# include <linux/irq.h>
+#endif
+
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
@@ -558,7 +562,7 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
 
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 45effc5..b721c2f 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -20,7 +20,7 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-#ifdef CONFIG_SPARSE_IRQ
+#ifdef CONFIG_GENERIC_HARDIRQS
 static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
 {
 	struct irq_2_iommu *iommu;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 9127f6b..91658d0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -61,6 +61,17 @@
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
+/**
+ * struct irqaction - per interrupt action descriptor
+ * @handler:	interrupt handler function
+ * @flags:	flags (see IRQF_* above)
+ * @mask:	no comment as it is useless and about to be removed
+ * @name:	name of the device
+ * @dev_id:	cookie to identify the device
+ * @next:	pointer to the next irqaction for shared interrupts
+ * @irq:	interrupt number
+ * @dir:	pointer to the proc/irq/NN/name entry
+ */
 struct irqaction {
 	irq_handler_t handler;
 	unsigned long flags;
@@ -462,6 +473,12 @@ static inline void init_irq_proc(void)
 }
 #endif
 
+#if defined(CONFIG_GENERIC_HARDIRQS) && defined(CONFIG_DEBUG_SHIRQ)
+extern void debug_poll_all_shared_irqs(void);
+#else
+static inline void debug_poll_all_shared_irqs(void) { }
+#endif
+
 int show_interrupts(struct seq_file *p, void *v);
 
 struct irq_desc;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index f899b50..6db939a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -160,12 +160,10 @@ struct irq_2_iommu;
  */
 struct irq_desc {
 	unsigned int		irq;
-#ifdef CONFIG_SPARSE_IRQ
 	struct timer_rand_state *timer_rand_state;
 	unsigned int            *kstat_irqs;
-# ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_INTR_REMAP
 	struct irq_2_iommu      *irq_2_iommu;
-# endif
 #endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
@@ -202,12 +200,6 @@ extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc
 extern struct irq_desc irq_desc[NR_IRQS];
 #else /* CONFIG_SPARSE_IRQ */
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
-
-#define kstat_irqs_this_cpu(DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()]++)
-
 #endif /* CONFIG_SPARSE_IRQ */
 
 extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
@@ -226,7 +218,6 @@ irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
  * Migration helpers for obsolete names, they will go away:
  */
 #define hw_interrupt_type	irq_chip
-typedef struct irq_chip		hw_irq_controller;
 #define no_irq_type		no_irq_chip
 typedef struct irq_desc		irq_desc_t;
 
@@ -236,6 +227,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
+extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
@@ -280,7 +272,7 @@ static inline int irq_balancing_disabled(unsigned int irq)
 }
 
 /* Handle irq action chains: */
-extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
+extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
 /*
  * Built-in IRQ handlers for various IRQ types,
@@ -325,7 +317,7 @@ static inline void generic_handle_irq(unsigned int irq)
 
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
-			   int action_ret);
+			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 86af92e..52ebbb4 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -28,13 +28,17 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
 # define for_each_irq_desc(irq, desc)					\
 	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
 	     irq++, desc = irq_to_desc(irq))				\
-		if (desc)
+		if (!desc)						\
+			;						\
+		else
 
 
 # define for_each_irq_desc_reverse(irq, desc)				\
 	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
 	     irq--, desc = irq_to_desc(irq))				\
-		if (desc)
+		if (!desc)						\
+			;						\
+		else
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 881883c..c5584ca 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -1,25 +1,17 @@
-/* irqreturn.h */
 #ifndef _LINUX_IRQRETURN_H
 #define _LINUX_IRQRETURN_H
 
-/*
- * For 2.4.x compatibility, 2.4.x can use
- *
- *	typedef void irqreturn_t;
- *	#define IRQ_NONE
- *	#define IRQ_HANDLED
- *	#define IRQ_RETVAL(x)
- *
- * To mix old-style and new-style irq handler returns.
- *
- * IRQ_NONE means we didn't handle it.
- * IRQ_HANDLED means that we did have a valid interrupt and handled it.
- * IRQ_RETVAL(x) selects on the two depending on x being non-zero (for handled)
+/**
+ * enum irqreturn
+ * @IRQ_NONE		interrupt was not from this device
+ * @IRQ_HANDLED		interrupt was handled by this device
  */
-typedef int irqreturn_t;
+enum irqreturn {
+	IRQ_NONE,
+	IRQ_HANDLED,
+};
 
-#define IRQ_NONE	(0)
-#define IRQ_HANDLED	(1)
-#define IRQ_RETVAL(x)	((x) != 0)
+typedef enum irqreturn irqreturn_t;
+#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
 
 #endif
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 570d204..0c8b89f 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -28,7 +28,7 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
 };
@@ -41,7 +41,7 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 
 extern unsigned long long nr_context_switches(void);
 
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
 #define kstat_irqs_this_cpu(irq) \
 	(kstat_this_cpu.irqs[irq])
 
@@ -52,16 +52,19 @@ static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 {
 	kstat_this_cpu.irqs[irq]++;
 }
-#endif
-
 
-#ifndef CONFIG_SPARSE_IRQ
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
        return kstat_cpu(cpu).irqs[irq];
 }
 #else
+#include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+#define kstat_irqs_this_cpu(DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()])
+#define kstat_incr_irqs_this_cpu(irqno, DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()]++)
+
 #endif
 
 /*
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 7de11bd..03d0bed 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -78,6 +78,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
 	desc->name = NULL;
+	clear_kstat_irqs(desc);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
@@ -290,7 +291,8 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		desc->chip->mask_ack(irq);
 	else {
 		desc->chip->mask(irq);
-		desc->chip->ack(irq);
+		if (desc->chip->ack)
+			desc->chip->ack(irq);
 	}
 }
 
@@ -476,7 +478,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->chip->ack(irq);
+	if (desc->chip->ack)
+		desc->chip->ack(irq);
 	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3aba8d1..f6cdda6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -83,19 +83,21 @@ static struct irq_desc irq_desc_init = {
 
 void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 {
-	unsigned long bytes;
-	char *ptr;
 	int node;
-
-	/* Compute how many bytes we need per irq and allocate them */
-	bytes = nr * sizeof(unsigned int);
+	void *ptr;
 
 	node = cpu_to_node(cpu);
-	ptr = kzalloc_node(bytes, GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
 
-	if (ptr)
-		desc->kstat_irqs = (unsigned int *)ptr;
+	/*
+	 * don't overwite if can not get new one
+	 * init_copy_kstat_irqs() could still use old one
+	 */
+	if (ptr) {
+		printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n",
+			 cpu, node);
+		desc->kstat_irqs = ptr;
+	}
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
@@ -227,6 +229,7 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
+static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
@@ -238,8 +241,10 @@ int __init early_irq_init(void)
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
+		desc[i].kstat_irqs = kstat_irqs_all[i];
+	}
 
 	return arch_early_irq_init();
 }
@@ -255,6 +260,11 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 }
 #endif /* !CONFIG_SPARSE_IRQ */
 
+void clear_kstat_irqs(struct irq_desc *desc)
+{
+	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+}
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -328,6 +338,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
+	WARN_ONCE(!in_irq(), "BUG: IRQ handler called from non-hardirq context!");
+
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
@@ -347,6 +359,11 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
+
+#ifdef CONFIG_ENABLE_WARN_DEPRECATED
+# warning __do_IRQ is deprecated. Please convert to proper flow handlers
+#endif
+
 /**
  * __do_IRQ - original all in one highlevel IRQ handler
  * @irq:	the interrupt number
@@ -467,12 +484,10 @@ void early_init_irq_lock_class(void)
 	}
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
-#endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index e6d0a43..b60950b 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -15,6 +15,7 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern void clear_kstat_irqs(struct irq_desc *desc);
 extern spinlock_t sparse_irq_lock;
 extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 291f036..ea119ef 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -109,7 +109,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 /*
  * Generic version of the affinity autoselector.
  */
-int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
+static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	if (!irq_can_set_affinity(irq))
 		return 0;
@@ -133,7 +133,7 @@ set_affinity:
 	return 0;
 }
 #else
-static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *d)
+static inline int setup_affinity(unsigned int irq, struct irq_desc *d)
 {
 	return irq_select_affinity(irq);
 }
@@ -149,14 +149,14 @@ int irq_select_affinity_usr(unsigned int irq)
 	int ret;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	ret = do_irq_select_affinity(irq, desc);
+	ret = setup_affinity(irq, desc);
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ret;
 }
 
 #else
-static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
+static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	return 0;
 }
@@ -389,9 +389,9 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
  * allocate special interrupts that are part of the architecture.
  */
 static int
-__setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
+__setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 {
-	struct irqaction *old, **p;
+	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
@@ -423,8 +423,8 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 	 * The following block of code has to be executed atomically
 	 */
 	spin_lock_irqsave(&desc->lock, flags);
-	p = &desc->action;
-	old = *p;
+	old_ptr = &desc->action;
+	old = *old_ptr;
 	if (old) {
 		/*
 		 * Can't share interrupts unless both agree to and are
@@ -447,8 +447,8 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 
 		/* add new interrupt at end of irq queue */
 		do {
-			p = &old->next;
-			old = *p;
+			old_ptr = &old->next;
+			old = *old_ptr;
 		} while (old);
 		shared = 1;
 	}
@@ -488,7 +488,7 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 			desc->status |= IRQ_NO_BALANCING;
 
 		/* Set default affinity mask once everything is setup */
-		do_irq_select_affinity(irq, desc);
+		setup_affinity(irq, desc);
 
 	} else if ((new->flags & IRQF_TRIGGER_MASK)
 			&& (new->flags & IRQF_TRIGGER_MASK)
@@ -499,7 +499,7 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
-	*p = new;
+	*old_ptr = new;
 
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
@@ -549,90 +549,117 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 
 	return __setup_irq(irq, desc, act);
 }
+EXPORT_SYMBOL_GPL(setup_irq);
 
-/**
- *	free_irq - free an interrupt
- *	@irq: Interrupt line to free
- *	@dev_id: Device identity to free
- *
- *	Remove an interrupt handler. The handler is removed and if the
- *	interrupt line is no longer in use by any driver it is disabled.
- *	On a shared IRQ the caller must ensure the interrupt is disabled
- *	on the card it drives before calling this function. The function
- *	does not return until any executing interrupts for this IRQ
- *	have completed.
- *
- *	This function must not be called from interrupt context.
+ /*
+ * Internal function to unregister an irqaction - used to free
+ * regular and special interrupts that are part of the architecture.
  */
-void free_irq(unsigned int irq, void *dev_id)
+static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irqaction **p;
+	struct irqaction *action, **action_ptr;
 	unsigned long flags;
 
-	WARN_ON(in_interrupt());
+	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
 
 	if (!desc)
-		return;
+		return NULL;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	p = &desc->action;
+
+	/*
+	 * There can be multiple actions per IRQ descriptor, find the right
+	 * one based on the dev_id:
+	 */
+	action_ptr = &desc->action;
 	for (;;) {
-		struct irqaction *action = *p;
+		action = *action_ptr;
 
-		if (action) {
-			struct irqaction **pp = p;
+		if (!action) {
+			WARN(1, "Trying to free already-free IRQ %d\n", irq);
+			spin_unlock_irqrestore(&desc->lock, flags);
 
-			p = &action->next;
-			if (action->dev_id != dev_id)
-				continue;
+			return NULL;
+		}
 
-			/* Found it - now remove it from the list of entries */
-			*pp = action->next;
+		if (action->dev_id == dev_id)
+			break;
+		action_ptr = &action->next;
+	}
 
-			/* Currently used only by UML, might disappear one day.*/
+	/* Found it - now remove it from the list of entries: */
+	*action_ptr = action->next;
+
+	/* Currently used only by UML, might disappear one day: */
 #ifdef CONFIG_IRQ_RELEASE_METHOD
-			if (desc->chip->release)
-				desc->chip->release(irq, dev_id);
+	if (desc->chip->release)
+		desc->chip->release(irq, dev_id);
 #endif
 
-			if (!desc->action) {
-				desc->status |= IRQ_DISABLED;
-				if (desc->chip->shutdown)
-					desc->chip->shutdown(irq);
-				else
-					desc->chip->disable(irq);
-			}
-			spin_unlock_irqrestore(&desc->lock, flags);
-			unregister_handler_proc(irq, action);
+	/* If this was the last handler, shut down the IRQ line: */
+	if (!desc->action) {
+		desc->status |= IRQ_DISABLED;
+		if (desc->chip->shutdown)
+			desc->chip->shutdown(irq);
+		else
+			desc->chip->disable(irq);
+	}
+	spin_unlock_irqrestore(&desc->lock, flags);
+
+	unregister_handler_proc(irq, action);
+
+	/* Make sure it's not being used on another CPU: */
+	synchronize_irq(irq);
 
-			/* Make sure it's not being used on another CPU */
-			synchronize_irq(irq);
-#ifdef CONFIG_DEBUG_SHIRQ
-			/*
-			 * It's a shared IRQ -- the driver ought to be
-			 * prepared for it to happen even now it's
-			 * being freed, so let's make sure....  We do
-			 * this after actually deregistering it, to
-			 * make sure that a 'real' IRQ doesn't run in
-			 * parallel with our fake
-			 */
-			if (action->flags & IRQF_SHARED) {
-				local_irq_save(flags);
-				action->handler(irq, dev_id);
-				local_irq_restore(flags);
-			}
-#endif
-			kfree(action);
-			return;
-		}
-		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
 #ifdef CONFIG_DEBUG_SHIRQ
-		dump_stack();
-#endif
-		spin_unlock_irqrestore(&desc->lock, flags);
-		return;
+	/*
+	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
+	 * event to happen even now it's being freed, so let's make sure that
+	 * is so by doing an extra call to the handler ....
+	 *
+	 * ( We do this after actually deregistering it, to make sure that a
+	 *   'real' IRQ doesn't run in * parallel with our fake. )
+	 */
+	if (action->flags & IRQF_SHARED) {
+		local_irq_save(flags);
+		action->handler(irq, dev_id);
+		local_irq_restore(flags);
 	}
+#endif
+	return action;
+}
+
+/**
+ *	remove_irq - free an interrupt
+ *	@irq: Interrupt line to free
+ *	@act: irqaction for the interrupt
+ *
+ * Used to remove interrupts statically setup by the early boot process.
+ */
+void remove_irq(unsigned int irq, struct irqaction *act)
+{
+	__free_irq(irq, act->dev_id);
+}
+EXPORT_SYMBOL_GPL(remove_irq);
+
+/**
+ *	free_irq - free an interrupt allocated with request_irq
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Remove an interrupt handler. The handler is removed and if the
+ *	interrupt line is no longer in use by any driver it is disabled.
+ *	On a shared IRQ the caller must ensure the interrupt is disabled
+ *	on the card it drives before calling this function. The function
+ *	does not return until any executing interrupts for this IRQ
+ *	have completed.
+ *
+ *	This function must not be called from interrupt context.
+ */
+void free_irq(unsigned int irq, void *dev_id)
+{
+	kfree(__free_irq(irq, dev_id));
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -679,11 +706,12 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	 * the behavior is classified as "will not fix" so we need to
 	 * start nudging drivers away from using that idiom.
 	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED))
-			== (IRQF_SHARED|IRQF_DISABLED))
-		pr_warning("IRQ %d/%s: IRQF_DISABLED is not "
-				"guaranteed on shared IRQs\n",
-				irq, devname);
+	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) ==
+					(IRQF_SHARED|IRQF_DISABLED)) {
+		pr_warning(
+		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
+			irq, devname);
+	}
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -709,15 +737,13 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	if (!handler)
 		return -EINVAL;
 
-	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);
+	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
-	action->next = NULL;
 	action->dev_id = dev_id;
 
 	retval = __setup_irq(irq, desc, action);
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index acd8835..aef18ab 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -17,16 +17,11 @@ static void init_copy_kstat_irqs(struct irq_desc *old_desc,
 				 struct irq_desc *desc,
 				 int cpu, int nr)
 {
-	unsigned long bytes;
-
 	init_kstat_irqs(desc, cpu, nr);
 
-	if (desc->kstat_irqs != old_desc->kstat_irqs) {
-		/* Compute how many bytes we need per irq and allocate them */
-		bytes = nr * sizeof(unsigned int);
-
-		memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
-	}
+	if (desc->kstat_irqs != old_desc->kstat_irqs)
+		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
+			 nr * sizeof(*desc->kstat_irqs));
 }
 
 static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dd364c1..4d56829 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -104,7 +104,7 @@ static int misrouted_irq(int irq)
 	return ok;
 }
 
-static void poll_spurious_irqs(unsigned long dummy)
+static void poll_all_shared_irqs(void)
 {
 	struct irq_desc *desc;
 	int i;
@@ -123,11 +123,23 @@ static void poll_spurious_irqs(unsigned long dummy)
 
 		try_one_irq(i, desc);
 	}
+}
+
+static void poll_spurious_irqs(unsigned long dummy)
+{
+	poll_all_shared_irqs();
 
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }
 
+#ifdef CONFIG_DEBUG_SHIRQ
+void debug_poll_all_shared_irqs(void)
+{
+	poll_all_shared_irqs();
+}
+#endif
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic

