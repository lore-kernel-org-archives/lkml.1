Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYHREOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYHREOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYHRENo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:13:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:23416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYHRENc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=irjB0OnckLDuRLL1ksY7O9n8ZKW/Xl4OFc8XJaDxXwqau8WN0rby84GRFexrgBciil
         vwxlPWh3hTvLc8wcokmsD/aBw6xzEy1wao2qRTU3HkwIq7+DStC1ZxK+AEo1kO1qgSp/
         wkXtlVvnP8G6svr8wTMDn0o0vfbFWXnRxNvZU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/2] irq: rename irq_desc() to to_irq_desc()
Date: Sun, 17 Aug 2008 21:12:29 -0700
Message-Id: <1219032749-9312-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219032749-9312-2-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1219032749-9312-1-git-send-email-yhlu.kernel@gmail.com>
 <1219032749-9312-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could revert back to use irq_desc[] for other arch except x86

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/alpha/kernel/irq.c                     |   21 +--
 arch/alpha/kernel/irq_alpha.c               |    7 -
 arch/alpha/kernel/irq_i8259.c               |    8 -
 arch/alpha/kernel/irq_pyxis.c               |    9 -
 arch/alpha/kernel/irq_srm.c                 |    9 -
 arch/alpha/kernel/sys_alcor.c               |    9 -
 arch/alpha/kernel/sys_cabriolet.c           |    8 -
 arch/alpha/kernel/sys_dp264.c               |    9 -
 arch/alpha/kernel/sys_eb64p.c               |    8 -
 arch/alpha/kernel/sys_eiger.c               |    7 -
 arch/alpha/kernel/sys_jensen.c              |   50 ++++-----
 arch/alpha/kernel/sys_marvel.c              |   20 +--
 arch/alpha/kernel/sys_mikasa.c              |    8 -
 arch/alpha/kernel/sys_noritake.c            |    8 -
 arch/alpha/kernel/sys_rawhide.c             |    8 -
 arch/alpha/kernel/sys_rx164.c               |    8 -
 arch/alpha/kernel/sys_sable.c               |    8 -
 arch/alpha/kernel/sys_takara.c              |    8 -
 arch/alpha/kernel/sys_titan.c               |    8 -
 arch/alpha/kernel/sys_wildfire.c            |   19 +--
 arch/arm/common/gic.c                       |    2 
 arch/arm/common/it8152.c                    |    2 
 arch/arm/common/locomo.c                    |   16 +--
 arch/arm/common/sa1111.c                    |    4 
 arch/arm/kernel/ecard.c                     |    4 
 arch/arm/kernel/irq.c                       |    8 -
 arch/arm/mach-at91/gpio.c                   |    4 
 arch/arm/mach-davinci/gpio.c                |   13 --
 arch/arm/mach-ep93xx/core.c                 |   12 +-
 arch/arm/mach-footbridge/isa-irq.c          |    2 
 arch/arm/mach-h720x/common.c                |    2 
 arch/arm/mach-h720x/cpu-h7202.c             |    2 
 arch/arm/mach-imx/irq.c                     |    2 
 arch/arm/mach-integrator/integrator_cp.c    |    2 
 arch/arm/mach-iop13xx/msi.c                 |    2 
 arch/arm/mach-ixp2000/core.c                |    4 
 arch/arm/mach-ixp2000/ixdp2x00.c            |    2 
 arch/arm/mach-ixp2000/ixdp2x01.c            |    2 
 arch/arm/mach-ixp23xx/core.c                |    2 
 arch/arm/mach-ixp23xx/ixdp2351.c            |    4 
 arch/arm/mach-lh7a40x/common.h              |    2 
 arch/arm/mach-netx/generic.c                |    2 
 arch/arm/mach-ns9xxx/board-a9m9750dev.c     |    2 
 arch/arm/mach-omap1/fpga.c                  |    2 
 arch/arm/mach-orion5x/irq.c                 |   12 +-
 arch/arm/mach-pxa/gpio.c                    |    2 
 arch/arm/mach-pxa/lpd270.c                  |    2 
 arch/arm/mach-pxa/lubbock.c                 |    2 
 arch/arm/mach-pxa/mainstone.c               |    2 
 arch/arm/mach-pxa/pcm990-baseboard.c        |    2 
 arch/arm/mach-s3c2410/bast-irq.c            |    6 -
 arch/arm/mach-s3c2412/irq.c                 |    4 
 arch/arm/mach-s3c2440/irq.c                 |    4 
 arch/arm/mach-s3c2443/irq.c                 |    4 
 arch/arm/mach-sa1100/h3600.c                |   14 +-
 arch/arm/mach-sa1100/irq.c                  |    2 
 arch/arm/mach-sa1100/neponset.c             |    6 -
 arch/arm/mach-versatile/core.c              |    2 
 arch/arm/oprofile/op_model_mpcore.c         |    2 
 arch/arm/plat-mxc/gpio.c                    |    7 -
 arch/arm/plat-omap/gpio.c                   |   12 --
 arch/arm/plat-orion/irq.c                   |    2 
 arch/arm/plat-s3c24xx/irq.c                 |   14 +-
 arch/arm/plat-s3c24xx/s3c244x-irq.c         |    4 
 arch/avr32/mach-at32ap/extint.c             |    7 -
 arch/avr32/mach-at32ap/intc.c               |    2 
 arch/avr32/mach-at32ap/pio.c                |    2 
 arch/blackfin/kernel/irqchip.c              |   12 --
 arch/blackfin/kernel/traps.c                |    8 -
 arch/blackfin/mach-bf537/boards/cm_bf537.c  |    2 
 arch/blackfin/mach-bf537/boards/stamp.c     |    2 
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |    2 
 arch/blackfin/mach-common/ints-priority.c   |    8 -
 arch/cris/arch-v10/kernel/irq.c             |    2 
 arch/cris/arch-v32/kernel/irq.c             |    6 -
 arch/cris/kernel/irq.c                      |   12 --
 arch/frv/kernel/irq.c                       |   10 -
 arch/h8300/kernel/irq.c                     |   24 +---
 arch/ia64/hp/sim/hpsim_irq.c                |    2 
 arch/ia64/include/asm/hw_irq.h              |    2 
 arch/ia64/kernel/iosapic.c                  |   19 +--
 arch/ia64/kernel/irq.c                      |   16 +--
 arch/ia64/kernel/irq_ia64.c                 |   12 +-
 arch/ia64/kernel/mca.c                      |    2 
 arch/ia64/kernel/msi_ia64.c                 |    4 
 arch/ia64/kernel/smpboot.c                  |    2 
 arch/ia64/sn/kernel/irq.c                   |   11 --
 arch/ia64/sn/kernel/msi_sn.c                |    4 
 arch/m32r/kernel/irq.c                      |   12 --
 arch/m32r/platforms/m32104ut/setup.c        |   37 +++---
 arch/m32r/platforms/m32700ut/setup.c        |  133 +++++++++++-------------
 arch/m32r/platforms/mappi/setup.c           |   84 ++++++---------
 arch/m32r/platforms/mappi2/setup.c          |  103 +++++++------------
 arch/m32r/platforms/mappi3/setup.c          |  103 +++++++------------
 arch/m32r/platforms/oaks32r/setup.c         |   62 ++++-------
 arch/m32r/platforms/opsput/setup.c          |  149 +++++++++++-----------------
 arch/m32r/platforms/usrv/setup.c            |   92 ++++++-----------
 arch/m68knommu/kernel/irq.c                 |   18 +--
 arch/mips/au1000/common/irq.c               |    2 
 arch/mips/dec/ioasic-irq.c                  |    2 
 arch/mips/emma2rh/markeins/irq_markeins.c   |    2 
 arch/mips/kernel/irq-gic.c                  |    2 
 arch/mips/kernel/irq-msc01.c                |    2 
 arch/mips/kernel/irq.c                      |   10 -
 arch/mips/kernel/smtc.c                     |    2 
 arch/mips/mti-malta/malta-smtc.c            |    2 
 arch/mips/sgi-ip22/ip22-int.c               |    2 
 arch/mips/sgi-ip22/ip22-time.c              |    2 
 arch/mips/sgi-ip32/ip32-irq.c               |   10 -
 arch/mips/sibyte/bcm1480/irq.c              |    5 
 arch/mips/sibyte/bcm1480/smp.c              |    2 
 arch/mips/sibyte/sb1250/irq.c               |    5 
 arch/mips/sibyte/sb1250/smp.c               |    2 
 arch/mips/sni/a20r.c                        |    2 
 arch/mips/sni/pcimt.c                       |    2 
 arch/mips/sni/pcit.c                        |    2 
 arch/mips/sni/rm200.c                       |    2 
 arch/mips/vr41xx/common/icu.c               |   44 ++++----
 arch/mips/vr41xx/common/irq.c               |    2 
 arch/mn10300/kernel/irq.c                   |   13 --
 arch/parisc/kernel/irq.c                    |   41 +++----
 arch/powerpc/include/asm/irq.h              |    2 
 arch/powerpc/kernel/crash.c                 |    2 
 arch/powerpc/kernel/irq.c                   |   15 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c     |    2 
 arch/powerpc/platforms/powermac/pic.c       |    4 
 arch/powerpc/platforms/pseries/eeh_driver.c |    2 
 arch/powerpc/platforms/pseries/xics.c       |    4 
 arch/powerpc/sysdev/cpm2_pic.c              |    5 
 arch/powerpc/sysdev/mpic.c                  |   16 +--
 arch/powerpc/sysdev/qe_lib/qe_ic.c          |    2 
 arch/sh/boards/mach-cayman/irq.c            |    4 
 arch/sh/boards/mach-dreamcast/irq.c         |    2 
 arch/sh/boards/mach-dreamcast/setup.c       |    2 
 arch/sh/boards/mach-microdev/irq.c          |    4 
 arch/sh/boards/mach-se/7206/irq.c           |    2 
 arch/sh/boards/mach-se/7343/irq.c           |    2 
 arch/sh/boards/mach-se/7722/irq.c           |    2 
 arch/sh/boards/mach-systemh/irq.c           |    4 
 arch/sh/cchips/hd6446x/hd64461.c            |    4 
 arch/sh/cchips/hd6446x/hd64465/setup.c      |    4 
 arch/sh/kernel/cpu/irq/imask.c              |    4 
 arch/sh/kernel/cpu/irq/intc-sh5.c           |    4 
 arch/sh/kernel/irq.c                        |   12 --
 arch/sparc64/kernel/irq.c                   |   41 +++----
 arch/sparc64/kernel/pci_msi.c               |    2 
 arch/sparc64/kernel/time.c                  |    2 
 arch/um/kernel/irq.c                        |   31 ++---
 arch/x86/kernel/io_apic.c                   |   32 +++---
 arch/x86/kernel/irq_32.c                    |    4 
 arch/x86/kernel/irq_64.c                    |    4 
 arch/x86/kernel/irqinit_32.c                |    2 
 arch/x86/kernel/irqinit_64.c                |    2 
 arch/x86/kernel/visws_quirks.c              |    8 -
 arch/x86/mach-voyager/voyager_smp.c         |    4 
 arch/xtensa/kernel/irq.c                    |   12 --
 drivers/char/random.c                       |    4 
 drivers/gpio/gpiolib.c                      |    2 
 drivers/mfd/asic3.c                         |    4 
 drivers/mfd/htc-egpio.c                     |    2 
 drivers/parisc/dino.c                       |    6 -
 drivers/parisc/eisa.c                       |    6 -
 drivers/parisc/gsc.c                        |    8 -
 drivers/parisc/iosapic.c                    |    2 
 drivers/parisc/superio.c                    |    4 
 drivers/pci/intr_remapping.c                |    4 
 drivers/pcmcia/hd64465_ss.c                 |    4 
 drivers/xen/events.c                        |    6 -
 include/asm-mips/irq.h                      |    2 
 include/linux/irq.h                         |   26 ++--
 kernel/irq/autoprobe.c                      |   10 -
 kernel/irq/chip.c                           |   28 ++---
 kernel/irq/handle.c                         |   24 ++--
 kernel/irq/manage.c                         |   26 ++--
 kernel/irq/migration.c                      |    2 
 kernel/irq/proc.c                           |   12 +-
 kernel/irq/resend.c                         |    2 
 kernel/irq/spurious.c                       |    4 
 178 files changed, 877 insertions(+), 1129 deletions(-)

Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -46,19 +46,16 @@ int irq_select_affinity(unsigned int irq
 {
 	static int last_cpu;
 	int cpu = last_cpu + 1;
-	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
-
-	if (!desc->chip->set_affinity || irq_user_affinity[irq])
+	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
 	while (!cpu_possible(cpu) || !cpu_isset(cpu, irq_default_affinity))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	desc->affinity = cpumask_of_cpu(cpu);
-	desc->chip->set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	irq_desc[irq].chip->set_affinity(irq, cpumask_of_cpu(cpu));
 	return 0;
 }
 #endif /* CONFIG_SMP */
@@ -83,10 +80,8 @@ show_interrupts(struct seq_file *p, void
 #endif
 
 	if (irq < ACTUAL_NR_IRQS) {
-		struct irq_desc *desc = irq_desc(irq);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[irq].lock, flags);
+		action = irq_desc[irq].action;
 		if (!action) 
 			goto unlock;
 		seq_printf(p, "%3d: ", irq);
@@ -96,7 +91,7 @@ show_interrupts(struct seq_file *p, void
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
 		seq_printf(p, "  %c%s",
 			(action->flags & IRQF_DISABLED)?'+':' ',
 			action->name);
@@ -109,7 +104,7 @@ show_interrupts(struct seq_file *p, void
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	} else if (irq == ACTUAL_NR_IRQS) {
 #ifdef CONFIG_SMP
 		seq_puts(p, "IPI: ");
@@ -161,6 +156,6 @@ handle_irq(int irq)
 	 * at IPL 0.
 	 */
 	local_irq_disable();
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 }
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -64,7 +64,7 @@ do_entInt(unsigned long type, unsigned l
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-			irq_desc(RTC_IRQ)->kstat_irqs[cpu]++;
+			irq_desc[RTC_IRQ].kstat_irqs[cpu]++;
 		} else {
 			handle_irq(RTC_IRQ);
 		}
@@ -240,9 +240,8 @@ static struct hw_interrupt_type rtc_irq_
 void __init
 init_rtc_irq(void)
 {
-	struct irq_desc *desc = irq_desc(RTC_IRQ);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &rtc_irq_type;
+	irq_desc[RTC_IRQ].status = IRQ_DISABLED;
+	irq_desc[RTC_IRQ].chip = &rtc_irq_type;
 	setup_irq(RTC_IRQ, &timer_irqaction);
 }
 
Index: linux-2.6/arch/alpha/kernel/irq_i8259.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_i8259.c
+++ linux-2.6/arch/alpha/kernel/irq_i8259.c
@@ -79,7 +79,7 @@ i8259a_startup_irq(unsigned int irq)
 void
 i8259a_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		i8259a_enable_irq(irq);
 }
 
@@ -107,10 +107,8 @@ init_i8259a_irqs(void)
 	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
 
 	for (i = 0; i < 16; i++) {
-		struct irq_desc *desc;
-		desc = irq_desc(i);
-		desc->status = IRQ_DISABLED;
-		desc->chip = &i8259a_irq_type;
+		irq_desc[i].status = IRQ_DISABLED;
+		irq_desc[i].chip = &i8259a_irq_type;
 	}
 
 	setup_irq(2, &cascade);
Index: linux-2.6/arch/alpha/kernel/irq_pyxis.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_pyxis.c
+++ linux-2.6/arch/alpha/kernel/irq_pyxis.c
@@ -50,7 +50,7 @@ pyxis_startup_irq(unsigned int irq)
 static void
 pyxis_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		pyxis_enable_irq(irq);
 }
 
@@ -117,13 +117,10 @@ init_pyxis_irqs(unsigned long ignore_mas
 	*(vuip) CIA_IACK_SC;
 
 	for (i = 16; i < 48; ++i) {
-		struct irq_desc *desc;
-
 		if ((ignore_mask >> i) & 1)
 			continue;
-		desc = irq_desc(i);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &pyxis_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &pyxis_irq_type;
 	}
 
 	setup_irq(16+7, &isa_cascade_irqaction);
Index: linux-2.6/arch/alpha/kernel/irq_srm.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_srm.c
+++ linux-2.6/arch/alpha/kernel/irq_srm.c
@@ -43,7 +43,7 @@ srm_startup_irq(unsigned int irq)
 static void
 srm_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		srm_enable_irq(irq);
 }
 
@@ -64,13 +64,10 @@ init_srm_irqs(long max, unsigned long ig
 	long i;
 
 	for (i = 16; i < max; ++i) {
-		struct irq_desc *desc;
-
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
-		desc = irq_desc(i);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &srm_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &srm_irq_type;
 	}
 }
 
Index: linux-2.6/arch/alpha/kernel/sys_alcor.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_alcor.c
+++ linux-2.6/arch/alpha/kernel/sys_alcor.c
@@ -85,7 +85,7 @@ alcor_isa_mask_and_ack_irq(unsigned int
 static void
 alcor_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		alcor_enable_irq(irq);
 }
 
@@ -137,16 +137,13 @@ alcor_init_irq(void)
 	*(vuip)GRU_INT_CLEAR = 0; mb();			/* all clear */
 
 	for (i = 16; i < 48; ++i) {
-		struct irq_desc *desc;
-
 		/* On Alcor, at least, lines 20..30 are not connected
 		   and can generate spurious interrupts if we turn them
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
-		desc = irq_desc(i);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &alcor_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &alcor_irq_type;
 	}
 	i8259a_irq_type.ack = alcor_isa_mask_and_ack_irq;
 
Index: linux-2.6/arch/alpha/kernel/sys_cabriolet.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_cabriolet.c
+++ linux-2.6/arch/alpha/kernel/sys_cabriolet.c
@@ -67,7 +67,7 @@ cabriolet_startup_irq(unsigned int irq)
 static void
 cabriolet_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		cabriolet_enable_irq(irq);
 }
 
@@ -122,10 +122,8 @@ common_init_irq(void (*srm_dev_int)(unsi
 		outb(0xff, 0x806);
 
 		for (i = 16; i < 35; ++i) {
-			struct irq_desc *desc = irq_desc(i);
-
-			desc->status = IRQ_DISABLED | IRQ_LEVEL;
-			desc->chip = &cabriolet_irq_type;
+			irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+			irq_desc[i].chip = &cabriolet_irq_type;
 		}
 	}
 
Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -125,7 +125,7 @@ dp264_startup_irq(unsigned int irq)
 static void
 dp264_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		dp264_enable_irq(irq);
 }
 
@@ -157,7 +157,7 @@ clipper_startup_irq(unsigned int irq)
 static void
 clipper_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		clipper_enable_irq(irq);
 }
 
@@ -298,9 +298,8 @@ init_tsunami_irqs(struct hw_interrupt_ty
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = ops;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = ops;
 	}
 }
 
Index: linux-2.6/arch/alpha/kernel/sys_eb64p.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eb64p.c
+++ linux-2.6/arch/alpha/kernel/sys_eb64p.c
@@ -65,7 +65,7 @@ eb64p_startup_irq(unsigned int irq)
 static void
 eb64p_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eb64p_enable_irq(irq);
 }
 
@@ -135,10 +135,8 @@ eb64p_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 32; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &eb64p_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &eb64p_irq_type;
 	}		
 
 	common_init_isa_dma();
Index: linux-2.6/arch/alpha/kernel/sys_eiger.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eiger.c
+++ linux-2.6/arch/alpha/kernel/sys_eiger.c
@@ -76,7 +76,7 @@ eiger_startup_irq(unsigned int irq)
 static void
 eiger_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eiger_enable_irq(irq);
 }
 
@@ -153,9 +153,8 @@ eiger_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 128; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &eiger_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &eiger_irq_type;
 	}
 }
 
Index: linux-2.6/arch/alpha/kernel/sys_jensen.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_jensen.c
+++ linux-2.6/arch/alpha/kernel/sys_jensen.c
@@ -68,16 +68,13 @@ jensen_local_startup(unsigned int irq)
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
 		i8259a_startup_irq(1);
-	else {
-		struct irq_desc *desc = irq_desc(irq);
-
+	else
 		/*
 		 * For all true local interrupts, set the flag that prevents
 		 * the IPL from being dropped during handler processing.
 		 */
-		if (desc->action)
-			desc->action->flags |= IRQF_DISABLED;
-	}
+		if (irq_desc[irq].action)
+			irq_desc[irq].action->flags |= IRQF_DISABLED;
 	return 0;
 }
 
@@ -161,21 +158,22 @@ jensen_device_interrupt(unsigned long ve
 	}
 
 	/* If there is no handler yet... */
-	if (irq_desc(irq)->action == NULL) {
-		/* If it is a local interrupt that cannot be masked... */
-		if (vector >= 0x900) {
-			/* Clear keyboard/mouse state */
-			inb(0x64);
-			inb(0x60);
-			/* Reset serial ports */
-			inb(0x3fa);
-			inb(0x2fa);
-			outb(0x0c, 0x3fc);
-			outb(0x0c, 0x2fc);
-			/* Clear NMI */
-			outb(0, 0x61);
-			outb(0, 0x461);
-		}
+	if (irq_desc[irq].action == NULL) {
+	    /* If it is a local interrupt that cannot be masked... */
+	    if (vector >= 0x900)
+	    {
+	        /* Clear keyboard/mouse state */
+	    	inb(0x64);
+		inb(0x60);
+		/* Reset serial ports */
+		inb(0x3fa);
+		inb(0x2fa);
+		outb(0x0c, 0x3fc);
+		outb(0x0c, 0x2fc);
+		/* Clear NMI */
+		outb(0,0x61);
+		outb(0,0x461);
+	    }
 	}
 
 #if 0
@@ -208,11 +206,11 @@ jensen_init_irq(void)
 {
 	init_i8259a_irqs();
 
-	irq_desc(1)->chip = &jensen_local_irq_type;
-	irq_desc(4)->chip = &jensen_local_irq_type;
-	irq_desc(3)->chip = &jensen_local_irq_type;
-	irq_desc(7)->chip = &jensen_local_irq_type;
-	irq_desc(9)->chip = &jensen_local_irq_type;
+	irq_desc[1].chip = &jensen_local_irq_type;
+	irq_desc[4].chip = &jensen_local_irq_type;
+	irq_desc[3].chip = &jensen_local_irq_type;
+	irq_desc[7].chip = &jensen_local_irq_type;
+	irq_desc[9].chip = &jensen_local_irq_type;
 
 	common_init_isa_dma();
 }
Index: linux-2.6/arch/alpha/kernel/sys_marvel.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_marvel.c
+++ linux-2.6/arch/alpha/kernel/sys_marvel.c
@@ -152,7 +152,7 @@ io7_startup_irq(unsigned int irq)
 static void
 io7_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		io7_enable_irq(irq);
 }
 
@@ -303,10 +303,8 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
-		struct irq_desc *desc = irq_desc(base + i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = lsi_ops;
+		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[base + i].chip = lsi_ops;
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -319,10 +317,8 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
-		struct irq_desc *desc = irq_desc(base + i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = msi_ops;
+		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[base + i].chip = msi_ops;
 	}
 
 	for (i = 0; i < 16; ++i)
@@ -339,10 +335,8 @@ marvel_init_irq(void)
 
 	/* Reserve the legacy irqs.  */
 	for (i = 0; i < 16; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->chip = &marvel_legacy_irq_type;
+		irq_desc[i].status = IRQ_DISABLED;
+		irq_desc[i].chip = &marvel_legacy_irq_type;
 	}
 
 	/* Init the io7 irqs.  */
Index: linux-2.6/arch/alpha/kernel/sys_mikasa.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_mikasa.c
+++ linux-2.6/arch/alpha/kernel/sys_mikasa.c
@@ -64,7 +64,7 @@ mikasa_startup_irq(unsigned int irq)
 static void
 mikasa_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		mikasa_enable_irq(irq);
 }
 
@@ -115,10 +115,8 @@ mikasa_init_irq(void)
 	mikasa_update_irq_hw(0);
 
 	for (i = 16; i < 32; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &mikasa_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &mikasa_irq_type;
 	}
 
 	init_i8259a_irqs();
Index: linux-2.6/arch/alpha/kernel/sys_noritake.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_noritake.c
+++ linux-2.6/arch/alpha/kernel/sys_noritake.c
@@ -69,7 +69,7 @@ noritake_startup_irq(unsigned int irq)
 static void
 noritake_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
                 noritake_enable_irq(irq);
 }
 
@@ -144,10 +144,8 @@ noritake_init_irq(void)
 	outw(0, 0x54c);
 
 	for (i = 16; i < 48; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &noritake_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &noritake_irq_type;
 	}
 
 	init_i8259a_irqs();
Index: linux-2.6/arch/alpha/kernel/sys_rawhide.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rawhide.c
+++ linux-2.6/arch/alpha/kernel/sys_rawhide.c
@@ -131,7 +131,7 @@ rawhide_startup_irq(unsigned int irq)
 static void
 rawhide_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rawhide_enable_irq(irq);
 }
 
@@ -194,10 +194,8 @@ rawhide_init_irq(void)
 	}
 
 	for (i = 16; i < 128; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &rawhide_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &rawhide_irq_type;
 	}
 
 	init_i8259a_irqs();
Index: linux-2.6/arch/alpha/kernel/sys_rx164.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rx164.c
+++ linux-2.6/arch/alpha/kernel/sys_rx164.c
@@ -68,7 +68,7 @@ rx164_startup_irq(unsigned int irq)
 static void
 rx164_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rx164_enable_irq(irq);
 }
 
@@ -116,10 +116,8 @@ rx164_init_irq(void)
 
 	rx164_update_irq_hw(0);
 	for (i = 16; i < 40; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &rx164_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &rx164_irq_type;
 	}
 
 	init_i8259a_irqs();
Index: linux-2.6/arch/alpha/kernel/sys_sable.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_sable.c
+++ linux-2.6/arch/alpha/kernel/sys_sable.c
@@ -484,7 +484,7 @@ sable_lynx_startup_irq(unsigned int irq)
 static void
 sable_lynx_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		sable_lynx_enable_irq(irq);
 }
 
@@ -535,10 +535,8 @@ sable_lynx_init_irq(int nr_irqs)
 	long i;
 
 	for (i = 0; i < nr_irqs; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &sable_lynx_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &sable_lynx_irq_type;
 	}
 
 	common_init_isa_dma();
Index: linux-2.6/arch/alpha/kernel/sys_takara.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_takara.c
+++ linux-2.6/arch/alpha/kernel/sys_takara.c
@@ -70,7 +70,7 @@ takara_startup_irq(unsigned int irq)
 static void
 takara_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		takara_enable_irq(irq);
 }
 
@@ -153,10 +153,8 @@ takara_init_irq(void)
 		takara_update_irq_hw(i, -1);
 
 	for (i = 16; i < 128; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &takara_irq_type;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = &takara_irq_type;
 	}
 
 	common_init_isa_dma();
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -139,7 +139,7 @@ titan_startup_irq(unsigned int irq)
 static void
 titan_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		titan_enable_irq(irq);
 }
 
@@ -187,10 +187,8 @@ init_titan_irqs(struct hw_interrupt_type
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		struct irq_desc *desc = irq_desc(i);
-
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = ops;
+		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i].chip = ops;
 	}
 }
 
Index: linux-2.6/arch/alpha/kernel/sys_wildfire.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_wildfire.c
+++ linux-2.6/arch/alpha/kernel/sys_wildfire.c
@@ -150,10 +150,10 @@ static void
 wildfire_end_irq(unsigned int irq)
 { 
 #if 0
-	if (!irq_desc(irq)->action)
+	if (!irq_desc[irq].action)
 		printk("got irq %d\n", irq);
 #endif
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		wildfire_enable_irq(irq);
 }
 
@@ -196,20 +196,17 @@ wildfire_init_irq_per_pca(int qbbno, int
 #endif
 
 	for (i = 0; i < 16; ++i) {
-		struct irq_desc *desc;
 		if (i == 2)
 			continue;
-		desc = irq_desc(i+irq_bias);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &wildfire_irq_type;
+		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
 	}
 
-	irq_desc(36+irq_bias)->status = IRQ_DISABLED | IRQ_LEVEL;
-	irq_desc(36+irq_bias)->chip = &wildfire_irq_type;
+	irq_desc[36+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
+	irq_desc[36+irq_bias].chip = &wildfire_irq_type;
 	for (i = 40; i < 64; ++i) {
-		struct irq_desc *desc = irq_desc(i+irq_bias);
-		desc->status = IRQ_DISABLED | IRQ_LEVEL;
-		desc->chip = &wildfire_irq_type;
+		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
 	}
 
 	setup_irq(32+irq_bias, &isa_enable);	
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -117,7 +117,7 @@ static void gic_set_cpu(unsigned int irq
 	u32 val;
 
 	spin_lock(&irq_controller_lock);
-	irq_desc(irq)->cpu = cpu;
+	irq_desc[irq].cpu = cpu;
 	val = readl(reg) & ~(0xff << shift);
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
Index: linux-2.6/arch/arm/common/it8152.c
===================================================================
--- linux-2.6.orig/arch/arm/common/it8152.c
+++ linux-2.6/arch/arm/common/it8152.c
@@ -70,7 +70,7 @@ static inline void it8152_irq(int irq)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	desc_handle_irq(irq, desc);
 }
 
Index: linux-2.6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.orig/arch/arm/common/locomo.c
+++ linux-2.6/arch/arm/common/locomo.c
@@ -181,8 +181,8 @@ static void locomo_handler(unsigned int
 	if (req) {
 		/* generate the next interrupt(s) */
 		irq = LOCOMO_IRQ_START;
-		d = irq_desc(irq);
-		for (i = 0; i <= 3; i++, irq++, d = irq_desc(irq)) {
+		d = irq_desc + irq;
+		for (i = 0; i <= 3; i++, d++, irq++) {
 			if (req & (0x0100 << i)) {
 				desc_handle_irq(irq, d);
 			}
@@ -226,7 +226,7 @@ static void locomo_key_handler(unsigned
 	void __iomem *mapbase = get_irq_chip_data(irq);
 
 	if (locomo_readl(mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC) & 0x0001) {
-		d = irq_desc(LOCOMO_IRQ_KEY_START);
+		d = irq_desc + LOCOMO_IRQ_KEY_START;
 		desc_handle_irq(LOCOMO_IRQ_KEY_START, d);
 	}
 }
@@ -277,8 +277,8 @@ static void locomo_gpio_handler(unsigned
 
 	if (req) {
 		irq = LOCOMO_IRQ_GPIO_START;
-		d = irq_desc(LOCOMO_IRQ_GPIO_START);
-		for (i = 0; i <= 15; i++, irq++, d = irq_desc(irq)) {
+		d = irq_desc + LOCOMO_IRQ_GPIO_START;
+		for (i = 0; i <= 15; i++, irq++, d++) {
 			if (req & (0x0001 << i)) {
 				desc_handle_irq(irq, d);
 			}
@@ -365,7 +365,7 @@ static void locomo_lt_handler(unsigned i
 	void __iomem *mapbase = get_irq_chip_data(irq);
 
 	if (locomo_readl(mapbase + LOCOMO_LTINT) & 0x0001) {
-		d = irq_desc(LOCOMO_IRQ_LT_START);
+		d = irq_desc + LOCOMO_IRQ_LT_START;
 		desc_handle_irq(LOCOMO_IRQ_LT_START, d);
 	}
 }
@@ -413,9 +413,9 @@ static void locomo_spi_handler(unsigned
 	req = locomo_readl(mapbase + LOCOMO_SPI + LOCOMO_SPIIR) & 0x000F;
 	if (req) {
 		irq = LOCOMO_IRQ_SPI_START;
-		d = irq_desc(irq);
+		d = irq_desc + irq;
 
-		for (i = 0; i <= 3; i++, irq++, d = irq_desc(irq)) {
+		for (i = 0; i <= 3; i++, irq++, d++) {
 			if (req & (0x0001 << i)) {
 				desc_handle_irq(irq, d);
 			}
Index: linux-2.6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.orig/arch/arm/common/sa1111.c
+++ linux-2.6/arch/arm/common/sa1111.c
@@ -170,11 +170,11 @@ sa1111_irq_handler(unsigned int irq, str
 
 	for (i = IRQ_SA1111_START; stat0; i++, stat0 >>= 1)
 		if (stat0 & 1)
-			handle_edge_irq(i, irq_desc(i));
+			handle_edge_irq(i, irq_desc + i);
 
 	for (i = IRQ_SA1111_START + 32; stat1; i++, stat1 >>= 1)
 		if (stat1 & 1)
-			handle_edge_irq(i, irq_desc(i));
+			handle_edge_irq(i, irq_desc + i);
 
 	/* For level-based interrupts */
 	desc->chip->unmask(irq);
Index: linux-2.6/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ecard.c
+++ linux-2.6/arch/arm/kernel/ecard.c
@@ -587,7 +587,7 @@ ecard_irq_handler(unsigned int irq, stru
 			pending = ecard_default_ops.irqpending(ec);
 
 		if (pending) {
-			struct irq_desc *d = irq_desc(ec->irq);
+			struct irq_desc *d = irq_desc + ec->irq;
 			desc_handle_irq(ec->irq, d);
 			called ++;
 		}
@@ -622,7 +622,7 @@ ecard_irqexp_handler(unsigned int irq, s
 		ecard_t *ec = slot_to_ecard(slot);
 
 		if (ec->claimed) {
-			struct irq_desc *d = irq_desc(ec->irq);
+			struct irq_desc *d = irq_desc + ec->irq;
 			/*
 			 * this ugly code is so that we can operate a
 			 * prioritorising system:
Index: linux-2.6/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/irq.c
+++ linux-2.6/arch/arm/kernel/irq.c
@@ -112,7 +112,7 @@ static struct irq_desc bad_irq_desc = {
 asmlinkage void __exception asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 
 	/*
 	 * Some hardware gives randomly wrong interrupts.  Rather
@@ -142,7 +142,7 @@ void set_irq_flags(unsigned int irq, uns
 		return;
 	}
 
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	if (iflags & IRQF_VALID)
@@ -159,7 +159,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		irq_desc(irq)->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
 	bad_irq_desc.affinity = CPU_MASK_ALL;
@@ -189,7 +189,7 @@ void migrate_irqs(void)
 	unsigned int i, cpu = smp_processor_id();
 
 	for (i = 0; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = irq_desc + i;
 
 		if (desc->cpu == cpu) {
 			unsigned int newcpu = any_online_cpu(desc->affinity);
Index: linux-2.6/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6/arch/arm/mach-at91/gpio.c
@@ -404,7 +404,7 @@ static void gpio_irq_handler(unsigned ir
 		}
 
 		pin = bank->chipbase;
-		gpio = irq_desc(pin);
+		gpio = &irq_desc[pin];
 
 		while (isr) {
 			if (isr & 1) {
@@ -515,7 +515,7 @@ void __init at91_gpio_irq_setup(void)
 		__raw_writel(~0, this->regbase + PIO_IDR);
 
 		for (i = 0, pin = this->chipbase; i < 32; i++, pin++) {
-			lockdep_set_class(&irq_desc(pin)->lock, &gpio_lock_class);
+			lockdep_set_class(&irq_desc[pin].lock, &gpio_lock_class);
 
 			/*
 			 * Can use the "simple" and not "edge" handler since it's
Index: linux-2.6/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6/arch/arm/mach-davinci/gpio.c
@@ -155,11 +155,10 @@ static void gpio_irq_enable(unsigned irq
 {
 	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
 	u32 mask = __gpio_mask(irq_to_gpio(irq));
-	struct irq_desc *desc = irq_desc(irq);
 
-	if (desc->status & IRQ_TYPE_EDGE_FALLING)
+	if (irq_desc[irq].status & IRQ_TYPE_EDGE_FALLING)
 		__raw_writel(mask, &g->set_falling);
-	if (desc->status & IRQ_TYPE_EDGE_RISING)
+	if (irq_desc[irq].status & IRQ_TYPE_EDGE_RISING)
 		__raw_writel(mask, &g->set_rising);
 }
 
@@ -167,14 +166,12 @@ static int gpio_irq_type(unsigned irq, u
 {
 	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
 	u32 mask = __gpio_mask(irq_to_gpio(irq));
-	struct irq_desc *desc;
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	desc = irq_desc(irq);
-	desc->status &= ~IRQ_TYPE_SENSE_MASK;
-	desc->status |= trigger;
+	irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
+	irq_desc[irq].status |= trigger;
 
 	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
 		     ? &g->set_falling : &g->clr_falling);
@@ -218,7 +215,7 @@ gpio_irq_handler(unsigned irq, struct ir
 
 		/* now demux them to the right lowlevel handler */
 		n = (int)get_irq_data(irq);
-		gpio = irq_desc(n);
+		gpio = &irq_desc[n];
 		while (status) {
 			res = ffs(status);
 			n += res;
Index: linux-2.6/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6/arch/arm/mach-ep93xx/core.c
@@ -192,7 +192,7 @@ static void ep93xx_gpio_ab_irq_handler(u
 	for (i = 0; i < 8; i++) {
 		if (status & (1 << i)) {
 			int gpio_irq = gpio_to_irq(EP93XX_GPIO_LINE_A(0)) + i;
-			desc = irq_desc(gpio_irq);
+			desc = irq_desc + gpio_irq;
 			desc_handle_irq(gpio_irq, desc);
 		}
 	}
@@ -201,7 +201,7 @@ static void ep93xx_gpio_ab_irq_handler(u
 	for (i = 0; i < 8; i++) {
 		if (status & (1 << i)) {
 			int gpio_irq = gpio_to_irq(EP93XX_GPIO_LINE_B(0)) + i;
-			desc = irq_desc(gpio_irq);
+			desc = irq_desc + gpio_irq;
 			desc_handle_irq(gpio_irq, desc);
 		}
 	}
@@ -217,7 +217,7 @@ static void ep93xx_gpio_f_irq_handler(un
 	int port_f_idx = ((irq + 1) & 7) ^ 4; /* {19..22,47..50} -> {0..7} */
 	int gpio_irq = gpio_to_irq(EP93XX_GPIO_LINE_F(0)) + port_f_idx;
 
-	desc_handle_irq(gpio_irq, irq_desc(gpio_irq));
+	desc_handle_irq(gpio_irq, irq_desc + gpio_irq);
 }
 
 static void ep93xx_gpio_irq_ack(unsigned int irq)
@@ -226,7 +226,7 @@ static void ep93xx_gpio_irq_ack(unsigned
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc(irq)->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+	if ((irq_desc[irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 		ep93xx_gpio_update_int_params(port);
 	}
@@ -240,7 +240,7 @@ static void ep93xx_gpio_irq_mask_ack(uns
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc(irq)->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
+	if ((irq_desc[irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 
 	gpio_int_unmasked[port] &= ~port_mask;
@@ -275,7 +275,7 @@ static void ep93xx_gpio_irq_unmask(unsig
  */
 static int ep93xx_gpio_irq_type(unsigned int irq, unsigned int type)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	const int gpio = irq_to_gpio(irq);
 	const int port = gpio >> 3;
 	const int port_mask = 1 << (gpio & 7);
Index: linux-2.6/arch/arm/mach-footbridge/isa-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/isa-irq.c
+++ linux-2.6/arch/arm/mach-footbridge/isa-irq.c
@@ -94,7 +94,7 @@ isa_irq_handler(unsigned int irq, struct
 		return;
 	}
 
-	desc = irq_desc(isa_irq);
+	desc = irq_desc + isa_irq;
 	desc_handle_irq(isa_irq, desc);
 }
 
Index: linux-2.6/arch/arm/mach-h720x/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/common.c
+++ linux-2.6/arch/arm/mach-h720x/common.c
@@ -104,7 +104,7 @@ h720x_gpio_handler(unsigned int mask, un
                  struct irq_desc *desc)
 {
 	IRQDBG("%s irq: %d\n", __func__, irq);
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	while (mask) {
 		if (mask & 1) {
 			IRQDBG("handling irq %d\n", irq);
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
@@ -120,7 +120,7 @@ h7202_timerx_demux_handler(unsigned int
 
 	mask >>= 1;
 	irq = IRQ_TIMER1;
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	while (mask) {
 		if (mask & 1)
 			desc_handle_irq(irq, desc);
Index: linux-2.6/arch/arm/mach-imx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-imx/irq.c
+++ linux-2.6/arch/arm/mach-imx/irq.c
@@ -182,7 +182,7 @@ static void
 imx_gpio_handler(unsigned int mask, unsigned int irq,
                  struct irq_desc *desc)
 {
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	while (mask) {
 		if (mask & 1) {
 			DEBUG_IRQ("handling irq %d\n", irq);
Index: linux-2.6/arch/arm/mach-integrator/integrator_cp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_cp.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_cp.c
@@ -217,7 +217,7 @@ sic_handle_irq(unsigned int irq, struct
 
 		irq += IRQ_SIC_START;
 
-		desc = irq_desc(irq);
+		desc = irq_desc + irq;
 		desc_handle_irq(irq, desc);
 	} while (status);
 }
Index: linux-2.6/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6/arch/arm/mach-iop13xx/msi.c
@@ -110,7 +110,7 @@ static void iop13xx_msi_handler(unsigned
 		do {
 			j = find_first_bit(&status, 32);
 			(write_imipr[i])(1 << j); /* write back to clear bit */
-			desc = irq_desc(IRQ_IOP13XX_MSI_0 + j + (32*i));
+			desc = irq_desc + IRQ_IOP13XX_MSI_0 + j + (32*i);
 			desc_handle_irq(IRQ_IOP13XX_MSI_0 + j + (32*i),	desc);
 			status = (read_imipr[i])();
 		} while (status);
Index: linux-2.6/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6/arch/arm/mach-ixp2000/core.c
@@ -311,7 +311,7 @@ static void ixp2000_GPIO_irq_handler(uns
 		   
 	for (i = 0; i <= 7; i++) {
 		if (status & (1<<i)) {
-			desc = irq_desc(i + IRQ_IXP2000_GPIO0);
+			desc = irq_desc + i + IRQ_IXP2000_GPIO0;
 			desc_handle_irq(i + IRQ_IXP2000_GPIO0, desc);
 		}
 	}
@@ -404,7 +404,7 @@ static void ixp2000_err_irq_handler(unsi
 
 	for(i = 31; i >= 0; i--) {
 		if(status & (1 << i)) {
-			desc = irq_desc(IRQ_IXP2000_DRAM0_MIN_ERR + i);
+			desc = irq_desc + IRQ_IXP2000_DRAM0_MIN_ERR + i;
 			desc_handle_irq(IRQ_IXP2000_DRAM0_MIN_ERR + i, desc);
 		}
 	}
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -131,7 +131,7 @@ static void ixdp2x00_irq_handler(unsigne
 		if(ex_interrupt & (1 << i))  {
 			struct irq_desc *cpld_desc;
 			int cpld_irq = IXP2000_BOARD_IRQ(0) + i;
-			cpld_desc = irq_desc(cpld_irq);
+			cpld_desc = irq_desc + cpld_irq;
 			desc_handle_irq(cpld_irq, cpld_desc);
 		}
 	}
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -81,7 +81,7 @@ static void ixdp2x01_irq_handler(unsigne
 		if (ex_interrupt & (1 << i)) {
 			struct irq_desc *cpld_desc;
 			int cpld_irq = IXP2000_BOARD_IRQ(0) + i;
-			cpld_desc = irq_desc(cpld_irq);
+			cpld_desc = irq_desc + cpld_irq;
 			desc_handle_irq(cpld_irq, cpld_desc);
 		}
 	}
Index: linux-2.6/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6/arch/arm/mach-ixp23xx/core.c
@@ -268,7 +268,7 @@ static void pci_handler(unsigned int irq
 		BUG();
 	}
 
-	int_desc = irq_desc(irqno);
+	int_desc = irq_desc + irqno;
 	desc_handle_irq(irqno, int_desc);
 
 	desc->chip->unmask(irq);
Index: linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -71,7 +71,7 @@ static void ixdp2351_inta_handler(unsign
 			struct irq_desc *cpld_desc;
 			int cpld_irq =
 				IXP23XX_MACH_IRQ(IXDP2351_INTA_IRQ_BASE + i);
-			cpld_desc = irq_desc(cpld_irq);
+			cpld_desc = irq_desc + cpld_irq;
 			desc_handle_irq(cpld_irq, cpld_desc);
 		}
 	}
@@ -108,7 +108,7 @@ static void ixdp2351_intb_handler(unsign
 			struct irq_desc *cpld_desc;
 			int cpld_irq =
 				IXP23XX_MACH_IRQ(IXDP2351_INTB_IRQ_BASE + i);
-			cpld_desc = irq_desc(cpld_irq);
+			cpld_desc = irq_desc + cpld_irq;
 			desc_handle_irq(cpld_irq, cpld_desc);
 		}
 	}
Index: linux-2.6/arch/arm/mach-lh7a40x/common.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/common.h
+++ linux-2.6/arch/arm/mach-lh7a40x/common.h
@@ -15,4 +15,4 @@ extern void lh7a404_init_irq (void);
 extern void lh7a40x_clcd_init (void);
 extern void lh7a40x_init_board_irq (void);
 
-#define IRQ_DISPATCH(irq) desc_handle_irq((irq),(irq_desc(irq)))
+#define IRQ_DISPATCH(irq) desc_handle_irq((irq),(irq_desc + irq))
Index: linux-2.6/arch/arm/mach-netx/generic.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-netx/generic.c
+++ linux-2.6/arch/arm/mach-netx/generic.c
@@ -77,7 +77,7 @@ netx_hif_demux_handler(unsigned int irq_
 	stat = ((readl(NETX_DPMAS_INT_EN) &
 		readl(NETX_DPMAS_INT_STAT)) >> 24) & 0x1f;
 
-	desc = irq_desc(NETX_IRQ_HIF_CHAINED(0));
+	desc = irq_desc + NETX_IRQ_HIF_CHAINED(0);
 
 	while (stat) {
 		if (stat & 1) {
Index: linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/board-a9m9750dev.c
+++ linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
@@ -90,7 +90,7 @@ static void a9m9750dev_fpga_demux_handle
 
 		stat &= ~(1 << irqno);
 
-		fpgadesc = irq_desc(FPGA_IRQ(irqno));
+		fpgadesc = irq_desc + FPGA_IRQ(irqno);
 
 		desc_handle_irq(FPGA_IRQ(irqno), fpgadesc);
 	}
Index: linux-2.6/arch/arm/mach-omap1/fpga.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/fpga.c
+++ linux-2.6/arch/arm/mach-omap1/fpga.c
@@ -99,7 +99,7 @@ void innovator_fpga_IRQ_demux(unsigned i
 	     (fpga_irq < OMAP_FPGA_IRQ_END) && stat;
 	     fpga_irq++, stat >>= 1) {
 		if (stat & 1) {
-			d = irq_desc(fpga_irq);
+			d = irq_desc + fpga_irq;
 			desc_handle_irq(fpga_irq, d);
 		}
 	}
Index: linux-2.6/arch/arm/mach-orion5x/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-orion5x/irq.c
+++ linux-2.6/arch/arm/mach-orion5x/irq.c
@@ -47,7 +47,7 @@
 static void orion5x_gpio_irq_ack(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc(irq)->status & IRQ_LEVEL)
+	if (irq_desc[irq].status & IRQ_LEVEL)
 		/*
 		 * Mask bit for level interrupt
 		 */
@@ -62,7 +62,7 @@ static void orion5x_gpio_irq_ack(u32 irq
 static void orion5x_gpio_irq_mask(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc(irq)->status & IRQ_LEVEL)
+	if (irq_desc[irq].status & IRQ_LEVEL)
 		orion5x_clrbits(GPIO_LEVEL_MASK, 1 << pin);
 	else
 		orion5x_clrbits(GPIO_EDGE_MASK, 1 << pin);
@@ -71,7 +71,7 @@ static void orion5x_gpio_irq_mask(u32 ir
 static void orion5x_gpio_irq_unmask(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc(irq)->status & IRQ_LEVEL)
+	if (irq_desc[irq].status & IRQ_LEVEL)
 		orion5x_setbits(GPIO_LEVEL_MASK, 1 << pin);
 	else
 		orion5x_setbits(GPIO_EDGE_MASK, 1 << pin);
@@ -88,7 +88,7 @@ static int orion5x_gpio_set_irq_type(u32
 		return -EINVAL;
 	}
 
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
@@ -155,7 +155,7 @@ static void orion5x_gpio_irq_handler(uns
 	for (pin = offs; pin < offs + 8; pin++) {
 		if (cause & (1 << pin)) {
 			irq = gpio_to_irq(pin);
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			if ((desc->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 				/* Swap polarity (race with GPIO line) */
 				u32 polarity = readl(GPIO_IN_POL);
@@ -186,7 +186,7 @@ static void __init orion5x_init_gpio_irq
 	for (i = IRQ_ORION5X_GPIO_START; i < NR_IRQS; i++) {
 		set_irq_chip(i, &orion5x_gpio_irq_chip);
 		set_irq_handler(i, handle_level_irq);
-		desc = irq_desc(i);
+		desc = irq_desc + i;
 		desc->status |= IRQ_LEVEL;
 		set_irq_flags(i, IRQF_VALID);
 	}
Index: linux-2.6/arch/arm/mach-pxa/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/gpio.c
+++ linux-2.6/arch/arm/mach-pxa/gpio.c
@@ -275,7 +275,7 @@ static void pxa_gpio_demux_handler(unsig
 			loop = 1;
 
 			n = PXA_GPIO_IRQ_BASE + bit;
-			desc_handle_irq(n, irq_desc(n));
+			desc_handle_irq(n, irq_desc + n);
 
 			bit = find_next_bit(gedr, GEDR_BITS, bit + 1);
 		}
Index: linux-2.6/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6/arch/arm/mach-pxa/lpd270.c
@@ -88,7 +88,7 @@ static void lpd270_irq_handler(unsigned
 		GEDR(0) = GPIO_bit(0);  /* clear useless edge notification */
 		if (likely(pending)) {
 			irq = LPD270_IRQ(0) + __ffs(pending);
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			desc_handle_irq(irq, desc);
 
 			pending = __raw_readw(LPD270_INT_STATUS) &
Index: linux-2.6/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6/arch/arm/mach-pxa/lubbock.c
@@ -131,7 +131,7 @@ static void lubbock_irq_handler(unsigned
 		GEDR(0) = GPIO_bit(0);	/* clear our parent irq */
 		if (likely(pending)) {
 			irq = LUBBOCK_IRQ(0) + __ffs(pending);
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			desc_handle_irq(irq, desc);
 		}
 		pending = LUB_IRQ_SET_CLR & lubbock_irq_enabled;
Index: linux-2.6/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6/arch/arm/mach-pxa/mainstone.c
@@ -162,7 +162,7 @@ static void mainstone_irq_handler(unsign
 		GEDR(0) = GPIO_bit(0);  /* clear useless edge notification */
 		if (likely(pending)) {
 			irq = MAINSTONE_IRQ(0) + __ffs(pending);
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			desc_handle_irq(irq, desc);
 		}
 		pending = MST_INTSETCLR & mainstone_irq_enabled;
Index: linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -262,7 +262,7 @@ static void pcm990_irq_handler(unsigned
 					GPIO_bit(PCM990_CTRL_INT_IRQ_GPIO);
 		if (likely(pending)) {
 			irq = PCM027_IRQ(0) + __ffs(pending);
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			desc_handle_irq(irq, desc);
 		}
 		pending = (~PCM990_INTSETCLR) & pcm990_irq_enabled;
Index: linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/bast-irq.c
+++ linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
@@ -87,7 +87,7 @@ bast_pc104_mask(unsigned int irqno)
 static void
 bast_pc104_maskack(unsigned int irqno)
 {
-	struct irq_desc *desc = irq_desc(IRQ_ISA);
+	struct irq_desc *desc = irq_desc + IRQ_ISA;
 
 	bast_pc104_mask(irqno);
 	desc->chip->ack(IRQ_ISA);
@@ -122,7 +122,7 @@ bast_irq_pc104_demux(unsigned int irq,
 	if (unlikely(stat == 0)) {
 		/* ack if we get an irq with nothing (ie, startup) */
 
-		desc = irq_desc(IRQ_ISA);
+		desc = irq_desc + IRQ_ISA;
 		desc->chip->ack(IRQ_ISA);
 	} else {
 		/* handle the IRQ */
@@ -130,7 +130,7 @@ bast_irq_pc104_demux(unsigned int irq,
 		for (i = 0; stat != 0; i++, stat >>= 1) {
 			if (stat & 1) {
 				irqno = bast_pc104_irqs[i];
-				desc = irq_desc(irqno);
+				desc = irq_desc + irqno;
 				desc_handle_irq(irqno, desc);
 			}
 		}
Index: linux-2.6/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6/arch/arm/mach-s3c2412/irq.c
@@ -123,10 +123,10 @@ static void s3c2412_irq_demux_cfsdi(unsi
 	subsrc  &= ~submsk;
 
 	if (subsrc & INTBIT(IRQ_S3C2412_SDI))
-		desc_handle_irq(IRQ_S3C2412_SDI, irq_desc(IRQ_S3C2412_SDI));
+		desc_handle_irq(IRQ_S3C2412_SDI, irq_desc + IRQ_S3C2412_SDI);
 
 	if (subsrc & INTBIT(IRQ_S3C2412_CF))
-		desc_handle_irq(IRQ_S3C2412_CF, irq_desc(IRQ_S3C2412_CF));
+		desc_handle_irq(IRQ_S3C2412_CF, irq_desc + IRQ_S3C2412_CF);
 }
 
 #define INTMSK_CFSDI	(1UL << (IRQ_S3C2412_CFSDI - IRQ_EINT0))
Index: linux-2.6/arch/arm/mach-s3c2440/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/irq.c
+++ linux-2.6/arch/arm/mach-s3c2440/irq.c
@@ -58,11 +58,11 @@ static void s3c_irq_demux_wdtac97(unsign
 
 	if (subsrc != 0) {
 		if (subsrc & 1) {
-			mydesc = irq_desc(IRQ_S3C2440_WDT);
+			mydesc = irq_desc + IRQ_S3C2440_WDT;
 			desc_handle_irq(IRQ_S3C2440_WDT, mydesc);
 		}
 		if (subsrc & 2) {
-			mydesc = irq_desc(IRQ_S3C2440_AC97);
+			mydesc = irq_desc + IRQ_S3C2440_AC97;
 			desc_handle_irq(IRQ_S3C2440_AC97, mydesc);
 		}
 	}
Index: linux-2.6/arch/arm/mach-s3c2443/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2443/irq.c
+++ linux-2.6/arch/arm/mach-s3c2443/irq.c
@@ -57,13 +57,13 @@ static inline void s3c2443_irq_demux(uns
 	subsrc  &= (1 << len)-1;
 
 	end = len + irq;
-	mydesc = irq_desc(irq);
+	mydesc = irq_desc + irq;
 
 	for (; irq < end && subsrc; irq++) {
 		if (subsrc & 1)
 			desc_handle_irq(irq, mydesc);
 
-		mydesc = irq_desc(irq);
+		mydesc++;
 		subsrc >>= 1;
 	}
 }
Index: linux-2.6/arch/arm/mach-sa1100/h3600.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/h3600.c
+++ linux-2.6/arch/arm/mach-sa1100/h3600.c
@@ -719,14 +719,14 @@ static void h3800_IRQ_demux(unsigned int
 		if (0) printk("%s KPIO 0x%08X\n", __func__, irq);
 		for (j = 0; j < H3800_KPIO_IRQ_COUNT; j++)
 			if (irq & kpio_irq_mask[j])
-				handle_edge_irq(H3800_KPIO_IRQ_COUNT + j, irq_desc(H3800_KPIO_IRQ_COUNT + j));
+				handle_edge_irq(H3800_KPIO_IRQ_COUNT + j, irq_desc + H3800_KPIO_IRQ_COUNT + j);
 
 		/* GPIO2 */
 		irq = H3800_ASIC2_GPIINTFLAG;
 		if (0) printk("%s GPIO 0x%08X\n", __func__, irq);
 		for (j = 0; j < H3800_GPIO_IRQ_COUNT; j++)
 			if (irq & gpio_irq_mask[j])
-				handle_edge_irq(H3800_GPIO_IRQ_COUNT + j, irq_desc(H3800_GPIO_IRQ_COUNT + j));
+				handle_edge_irq(H3800_GPIO_IRQ_COUNT + j, irq_desc + H3800_GPIO_IRQ_COUNT + j);
 	}
 
 	if (i >= MAX_ASIC_ISR_LOOPS)
@@ -822,17 +822,15 @@ static void __init h3800_init_irq(void)
 #if 0
 	for (i = 0; i < H3800_KPIO_IRQ_COUNT; i++) {
 		int irq = i + H3800_KPIO_IRQ_START;
-		struct irq_desc *desc = irq_desc(irq);
-		desc->valid    = 1;
-		desc->probe_ok = 1;
+		irq_desc[irq].valid    = 1;
+		irq_desc[irq].probe_ok = 1;
 		set_irq_chip(irq, &h3800_kpio_irqchip);
 	}
 
 	for (i = 0; i < H3800_GPIO_IRQ_COUNT; i++) {
 		int irq = i + H3800_GPIO_IRQ_START;
-		struct irq_desc *desc = irq_desc(irq);
-		desc->valid    = 1;
-		desc->probe_ok = 1;
+		irq_desc[irq].valid    = 1;
+		irq_desc[irq].probe_ok = 1;
 		set_irq_chip(irq, &h3800_gpio_irqchip);
 	}
 #endif
Index: linux-2.6/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6/arch/arm/mach-sa1100/irq.c
@@ -122,7 +122,7 @@ sa1100_high_gpio_handler(unsigned int ir
 		GEDR = mask;
 
 		irq = IRQ_GPIO11;
-		desc = irq_desc(irq);
+		desc = irq_desc + irq;
 		mask >>= 11;
 		do {
 			if (mask & 1)
Index: linux-2.6/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6/arch/arm/mach-sa1100/neponset.c
@@ -67,12 +67,12 @@ neponset_irq_handler(unsigned int irq, s
 			desc->chip->ack(irq);
 
 			if (irr & IRR_ETHERNET) {
-				d = irq_desc(IRQ_NEPONSET_SMC9196);
+				d = irq_desc + IRQ_NEPONSET_SMC9196;
 				desc_handle_irq(IRQ_NEPONSET_SMC9196, d);
 			}
 
 			if (irr & IRR_USAR) {
-				d = irq_desc(IRQ_NEPONSET_USAR);
+				d = irq_desc + IRQ_NEPONSET_USAR;
 				desc_handle_irq(IRQ_NEPONSET_USAR, d);
 			}
 
@@ -80,7 +80,7 @@ neponset_irq_handler(unsigned int irq, s
 		}
 
 		if (irr & IRR_SA1111) {
-			d = irq_desc(IRQ_NEPONSET_SA1111);
+			d = irq_desc + IRQ_NEPONSET_SA1111;
 			desc_handle_irq(IRQ_NEPONSET_SA1111, d);
 		}
 	}
Index: linux-2.6/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6/arch/arm/mach-versatile/core.c
@@ -95,7 +95,7 @@ sic_handle_irq(unsigned int irq, struct
 
 		irq += IRQ_SIC_START;
 
-		desc = irq_desc(irq);
+		desc = irq_desc + irq;
 		desc_handle_irq(irq, desc);
 	} while (status);
 }
Index: linux-2.6/arch/arm/oprofile/op_model_mpcore.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_mpcore.c
+++ linux-2.6/arch/arm/oprofile/op_model_mpcore.c
@@ -259,7 +259,7 @@ static void em_stop(void)
  */
 static void em_route_irq(int irq, unsigned int cpu)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	cpumask_t mask = cpumask_of_cpu(cpu);
 
 	spin_lock_irq(&desc->lock);
Index: linux-2.6/arch/arm/plat-mxc/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/gpio.c
+++ linux-2.6/arch/arm/plat-mxc/gpio.c
@@ -105,14 +105,13 @@ static void mxc_gpio_irq_handler(struct
 
 	gpio_irq_no = port->virtual_irq_start;
 	for (; irq_stat != 0; irq_stat >>= 1, gpio_irq_no++) {
-		struct irq_desc *desc;
 
 		if ((irq_stat & 1) == 0)
 			continue;
 
-		desc = irq_desc(gpio_irq_no);
-		BUG_ON(!(desc->handle_irq));
-		desc->handle_irq(gpio_irq_no, desc);
+		BUG_ON(!(irq_desc[gpio_irq_no].handle_irq));
+		irq_desc[gpio_irq_no].handle_irq(gpio_irq_no,
+				&irq_desc[gpio_irq_no]);
 	}
 }
 
Index: linux-2.6/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6/arch/arm/plat-omap/gpio.c
@@ -648,10 +648,8 @@ static int gpio_irq_type(unsigned irq, u
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
 	if (retval == 0) {
-		struct irq_desc *desc = irq_desc(irq);
-
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= type;
+		irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
+		irq_desc[irq].status |= type;
 	}
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -1057,7 +1055,7 @@ static void gpio_irq_handler(unsigned in
 
 			if (!(isr & 1))
 				continue;
-			d = irq_desc(gpio_irq);
+			d = irq_desc + gpio_irq;
 
 			desc_handle_irq(gpio_irq, d);
 		}
@@ -1505,7 +1503,7 @@ static int __init _omap_gpio_init(void)
 
 		for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + gpio_count; j++) {
-			lockdep_set_class(&irq_desc(j)->lock, &gpio_lock_class);
+			lockdep_set_class(&irq_desc[j].lock, &gpio_lock_class);
 			set_irq_chip_data(j, bank);
 			if (bank_is_mpuio(bank))
 				set_irq_chip(j, &mpuio_irq_chip);
@@ -1820,7 +1818,7 @@ static int dbg_gpio_show(struct seq_file
 
 /* FIXME for at least omap2, show pullup/pulldown state */
 
-			irqstat = irq_desc(irq)->status;
+			irqstat = irq_desc[irq].status;
 			if (is_in && ((bank->suspend_wakeup & mask)
 					|| irqstat & IRQ_TYPE_SENSE_MASK)) {
 				char	*trigger = NULL;
Index: linux-2.6/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6/arch/arm/plat-orion/irq.c
@@ -59,7 +59,7 @@ void __init orion_irq_init(unsigned int
 		set_irq_chip(irq, &orion_irq_chip);
 		set_irq_chip_data(irq, maskaddr);
 		set_irq_handler(irq, handle_level_irq);
-		irq_desc(irq)->status |= IRQ_LEVEL;
+		irq_desc[irq].status |= IRQ_LEVEL;
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6/arch/arm/plat-s3c24xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/irq.c
@@ -482,11 +482,11 @@ static void s3c_irq_demux_adc(unsigned i
 
 	if (subsrc != 0) {
 		if (subsrc & 1) {
-			mydesc = irq_desc(IRQ_TC);
+			mydesc = irq_desc + IRQ_TC;
 			desc_handle_irq(IRQ_TC, mydesc);
 		}
 		if (subsrc & 2) {
-			mydesc = irq_desc(IRQ_ADC);
+			mydesc = irq_desc + IRQ_ADC;
 			desc_handle_irq(IRQ_ADC, mydesc);
 		}
 	}
@@ -512,17 +512,17 @@ static void s3c_irq_demux_uart(unsigned
 	subsrc &= 7;
 
 	if (subsrc != 0) {
-		desc = irq_desc(start);
+		desc = irq_desc + start;
 
 		if (subsrc & 1)
 			desc_handle_irq(start, desc);
 
-		desc = irq_desc(start + 1);
+		desc++;
 
 		if (subsrc & 2)
 			desc_handle_irq(start+1, desc);
 
-		desc = irq_desc(start + 2);
+		desc++;
 
 		if (subsrc & 4)
 			desc_handle_irq(start+2, desc);
@@ -572,7 +572,7 @@ s3c_irq_demux_extint8(unsigned int irq,
 		eintpnd &= ~(1<<irq);
 
 		irq += (IRQ_EINT4 - 4);
-		desc_handle_irq(irq, irq_desc(irq));
+		desc_handle_irq(irq, irq_desc + irq);
 	}
 
 }
@@ -595,7 +595,7 @@ s3c_irq_demux_extint4t7(unsigned int irq
 
 		irq += (IRQ_EINT4 - 4);
 
-		desc_handle_irq(irq, irq_desc(irq));
+		desc_handle_irq(irq, irq_desc + irq);
 	}
 }
 
Index: linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/s3c244x-irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
@@ -58,11 +58,11 @@ static void s3c_irq_demux_cam(unsigned i
 
 	if (subsrc != 0) {
 		if (subsrc & 1) {
-			mydesc = irq_desc(IRQ_S3C2440_CAM_C);
+			mydesc = irq_desc + IRQ_S3C2440_CAM_C;
 			desc_handle_irq(IRQ_S3C2440_CAM_C, mydesc);
 		}
 		if (subsrc & 2) {
-			mydesc = irq_desc(IRQ_S3C2440_CAM_P);
+			mydesc = irq_desc + IRQ_S3C2440_CAM_P;
 			desc_handle_irq(IRQ_S3C2440_CAM_P, mydesc);
 		}
 	}
Index: linux-2.6/arch/avr32/mach-at32ap/extint.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/extint.c
+++ linux-2.6/arch/avr32/mach-at32ap/extint.c
@@ -88,6 +88,7 @@ static void eic_unmask_irq(unsigned int
 static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 {
 	struct eic *eic = get_irq_chip_data(irq);
+	struct irq_desc *desc;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
 	int ret = 0;
@@ -96,6 +97,8 @@ static int eic_set_irq_type(unsigned int
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
+	desc = &irq_desc[irq];
+
 	mode = eic_readl(eic, MODE);
 	edge = eic_readl(eic, EDGE);
 	level = eic_readl(eic, LEVEL);
@@ -123,10 +126,6 @@ static int eic_set_irq_type(unsigned int
 	}
 
 	if (ret == 0) {
-		struct irq_desc *desc;
-
-		desc = irq_desc(irq);
-
 		eic_writel(eic, MODE, mode);
 		eic_writel(eic, EDGE, edge);
 		eic_writel(eic, LEVEL, level);
Index: linux-2.6/arch/avr32/mach-at32ap/intc.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/intc.c
+++ linux-2.6/arch/avr32/mach-at32ap/intc.c
@@ -69,7 +69,7 @@ asmlinkage void do_IRQ(int level, struct
 	irq_enter();
 
 	irq = intc_readl(&intc0, INTCAUSE0 - 4 * level);
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	desc->handle_irq(irq, desc);
 
 	/*
Index: linux-2.6/arch/avr32/mach-at32ap/pio.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/pio.c
+++ linux-2.6/arch/avr32/mach-at32ap/pio.c
@@ -262,7 +262,7 @@ static void gpio_irq_handler(unsigned ir
 			isr &= ~(1 << i);
 
 			i += gpio_irq;
-			d = irq_desc(i);
+			d = &irq_desc[i];
 
 			d->handle_irq(i, d);
 		} while (isr);
Index: linux-2.6/arch/blackfin/kernel/irqchip.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/irqchip.c
+++ linux-2.6/arch/blackfin/kernel/irqchip.c
@@ -77,10 +77,8 @@ int show_interrupts(struct seq_file *p,
 	unsigned long flags;
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
 
@@ -91,7 +89,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
  unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "Err: %10lu\n", irq_err_count);
 	}
@@ -110,7 +108,7 @@ __attribute__((l1_text))
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	unsigned short pending, other_ints;
 
 	old_regs = set_irq_regs(regs);
@@ -146,7 +144,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	spin_lock_init(&irq_controller_lock);
-	for (irq = 0, desc = irq_desc(0); irq < NR_IRQS; irq++, desc = irq_desc(irq)) {
+	for (irq = 0, desc = irq_desc; irq < NR_IRQS; irq++, desc++) {
 		*desc = bad_irq_desc;
 	}
 
Index: linux-2.6/arch/blackfin/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/traps.c
+++ linux-2.6/arch/blackfin/kernel/traps.c
@@ -1003,10 +1003,8 @@ void show_regs(struct pt_regs *fp)
 	/* if no interrupts are going off, don't print this out */
 	if (fp->ipend & ~0x3F) {
 		for (i = 0; i < (NR_IRQS - 1); i++) {
-			struct irq_desc *desc = irq_desc(i);
-
-			spin_lock_irqsave(&desc->lock, flags);
-			action = desc->action;
+			spin_lock_irqsave(&irq_desc[i].lock, flags);
+			action = irq_desc[i].action;
 			if (!action)
 				goto unlock;
 
@@ -1018,7 +1016,7 @@ void show_regs(struct pt_regs *fp)
 			}
 			printk("\n");
 unlock:
-			spin_unlock_irqrestore(&desc->lock, flags);
+			spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 		}
 	}
 
Index: linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -575,7 +575,7 @@ static int __init cm_bf537_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
Index: linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/stamp.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1026,7 +1026,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
 #endif
 
 	return 0;
Index: linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -411,7 +411,7 @@ static int __init cm_bf561_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
Index: linux-2.6/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/ints-priority.c
+++ linux-2.6/arch/blackfin/mach-common/ints-priority.c
@@ -315,7 +315,7 @@ static void bfin_demux_error_irq(unsigne
 
 	if (irq) {
 		if (error_int_mask & (1L << (irq - IRQ_PPI_ERROR))) {
-			struct irq_desc *desc = irq_desc(irq);
+			struct irq_desc *desc = irq_desc + irq;
 			desc->handle_irq(irq, desc);
 		} else {
 
@@ -561,7 +561,7 @@ static void bfin_demux_gpio_irq(unsigned
 
 			while (mask) {
 				if (mask & 1) {
-					desc = irq_desc(irq);
+					desc = irq_desc + irq;
 					desc->handle_irq(irq, desc);
 				}
 				irq++;
@@ -576,7 +576,7 @@ static void bfin_demux_gpio_irq(unsigned
 
 			do {
 				if (mask & 1) {
-					desc = irq_desc(irq);
+					desc = irq_desc + irq;
 					desc->handle_irq(irq, desc);
 				}
 				irq++;
@@ -928,7 +928,7 @@ static void bfin_demux_gpio_irq(unsigned
 	while (request) {
 		if (request & 1) {
 			irq = pint2irq_lut[pint_val] + SYS_IRQS;
-			desc = irq_desc(irq);
+			desc = irq_desc + irq;
 			desc->handle_irq(irq, desc);
 		}
 		pint_val++;
Index: linux-2.6/arch/cris/arch-v10/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v10/kernel/irq.c
@@ -221,7 +221,7 @@ init_IRQ(void)
 
 	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
-		irq_desc(i)->chip = &crisv10_irq_type;
+		irq_desc[i].chip = &crisv10_irq_type;
 		set_int_vector(i, interrupt[i]);
 	}
 
Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -475,15 +475,15 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		irq_desc(j)->chip = &crisv32_irq_type;
+		irq_desc[j].chip = &crisv32_irq_type;
 		set_exception_vector(i, interrupt[j]);
 	}
 
         /* Mark Timer and IPI IRQs as CPU local */
 	irq_allocations[TIMER0_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc(TIMER0_INTR_VECT)->status |= IRQ_PER_CPU;
+	irq_desc[TIMER0_INTR_VECT].status |= IRQ_PER_CPU;
 	irq_allocations[IPI_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc(IPI_INTR_VECT)->status |= IRQ_PER_CPU;
+	irq_desc[IPI_INTR_VECT].status |= IRQ_PER_CPU;
 
 	set_exception_vector(0x00, nmi_interrupt);
 	set_exception_vector(0x30, multiple_interrupt);
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -57,10 +57,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -70,7 +68,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -78,7 +76,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
@@ -101,7 +99,7 @@ asmlinkage void do_IRQ(int irq, struct p
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
         irq_exit();
 	set_irq_regs(old_regs);
 }
Index: linux-2.6/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq.c
+++ linux-2.6/arch/frv/kernel/irq.c
@@ -69,15 +69,13 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
 				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-			seq_printf(p, " %10s", desc->chip->name ? : "-");
+			seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
 			     action;
@@ -87,7 +85,7 @@ int show_interrupts(struct seq_file *p,
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "Err: %10u\n", atomic_read(&irq_err_count));
 	}
Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -166,19 +166,17 @@ void __init init_IRQ(void)
 	setup_vector();
 
 	for (c = 0; c < NR_IRQS; c++) {
-		struct irq_desc *desc = irq_desc(c);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-		desc->chip = &h8300irq_chip;
+		irq_desc[c].status = IRQ_DISABLED;
+		irq_desc[c].action = NULL;
+		irq_desc[c].depth = 1;
+		irq_desc[c].chip = &h8300irq_chip;
 	}
 }
 
 asmlinkage void do_IRQ(int irq)
 {
 	irq_enter();
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 }
 
@@ -193,23 +191,21 @@ int show_interrupts(struct seq_file *p,
 		seq_puts(p, "           CPU0");
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-		seq_printf(p, " %14s", desc->chip->name);
-		seq_printf(p, "-%-8s", desc->name);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -44,7 +44,7 @@ hpsim_irq_init (void)
 	int i;
 
 	for (i = 0; i < NR_IRQS; ++i) {
-		idesc = irq_desc(i);
+		idesc = irq_desc + i;
 		if (idesc->chip == &no_irq_type)
 			idesc->chip = &irq_type_hp_sim;
 	}
Index: linux-2.6/arch/ia64/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/hw_irq.h
+++ linux-2.6/arch/ia64/include/asm/hw_irq.h
@@ -146,7 +146,7 @@ static inline void ia64_native_resend_ir
  * Default implementations for the irq-descriptor API:
  */
 
-extern irq_desc_t irq_descX[NR_IRQS];
+extern irq_desc_t irq_desc[NR_IRQS];
 
 #ifndef CONFIG_IA64_GENERIC
 static inline ia64_vector __ia64_irq_to_vector(int irq)
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -398,7 +398,7 @@ iosapic_end_level_irq (unsigned int irq)
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-	if (unlikely(irq_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_irq(irq);
 	}
@@ -407,7 +407,7 @@ iosapic_end_level_irq (unsigned int irq)
 		iosapic_eoi(rte->iosapic->addr, vec);
 
 	if (unlikely(do_unmask_irq)) {
-		move_masked_irq(irq, irq_desc(irq));
+		move_masked_irq(irq, &irq_desc[irq]);
 		unmask_irq(irq);
 	}
 }
@@ -449,7 +449,7 @@ iosapic_startup_edge_irq (unsigned int i
 static void
 iosapic_ack_edge_irq (unsigned int irq)
 {
-	irq_desc_t *idesc = irq_desc(irq);
+	irq_desc_t *idesc = irq_desc + irq;
 
 	irq_complete_move(irq);
 	move_native_irq(irq, idesc);
@@ -646,7 +646,7 @@ register_intr (unsigned int gsi, int irq
 
 	irq_type = iosapic_get_irq_chip(trigger);
 
-	idesc = irq_desc(irq);
+	idesc = irq_desc + irq;
 	if (irq_type != NULL && idesc->chip != irq_type) {
 		if (idesc->chip != &no_irq_type)
 			printk(KERN_WARNING
@@ -765,7 +765,6 @@ iosapic_register_intr (unsigned int gsi,
 	struct iosapic_rte_info *rte;
 	u32 low32;
 	unsigned char dmode;
-	struct irq_desc *desc;
 
 	/*
 	 * If this GSI has already been registered (i.e., it's a
@@ -793,14 +792,12 @@ iosapic_register_intr (unsigned int gsi,
 			goto unlock_iosapic_lock;
 	}
 
-	desc = irq_desc(irq);
-
-	spin_lock(&desc->lock);
+	spin_lock(&irq_desc[irq].lock);
 	dest = get_target_cpu(gsi, irq);
 	dmode = choose_dmode();
 	err = register_intr(gsi, irq, dmode, polarity, trigger);
 	if (err < 0) {
-		spin_unlock(&desc->lock);
+		spin_unlock(&irq_desc[irq].lock);
 		irq = err;
 		goto unlock_iosapic_lock;
 	}
@@ -819,7 +816,7 @@ iosapic_register_intr (unsigned int gsi,
 	       (polarity == IOSAPIC_POL_HIGH ? "high" : "low"),
 	       cpu_logical_id(dest), dest, irq_to_vector(irq));
 
-	spin_unlock(&desc->lock);
+	spin_unlock(&irq_desc[irq].lock);
  unlock_iosapic_lock:
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 	return irq;
@@ -860,7 +857,7 @@ iosapic_unregister_intr (unsigned int gs
 	if (--rte->refcnt > 0)
 		goto out;
 
-	idesc = irq_desc(irq);
+	idesc = irq_desc + irq;
 	rte->refcnt = NO_REF_RTE;
 
 	/* Mask the interrupt */
Index: linux-2.6/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq.c
+++ linux-2.6/arch/ia64/kernel/irq.c
@@ -71,10 +71,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -85,7 +83,7 @@ int show_interrupts(struct seq_file *p,
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		}
 #endif
-		seq_printf(p, " %14s", desc->chip->name);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -93,7 +91,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS)
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	return 0;
@@ -109,7 +107,7 @@ void set_irq_affinity_info (unsigned int
 	cpu_set(cpu_logical_id(hwid), mask);
 
 	if (irq < NR_IRQS) {
-		irq_desc(irq)->affinity = mask;
+		irq_desc[irq].affinity = mask;
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
@@ -140,7 +138,7 @@ static void migrate_irqs(void)
 	int 		irq, new_cpu;
 
 	for (irq=0; irq < NR_IRQS; irq++) {
-		desc = irq_desc(irq);
+		desc = irq_desc + irq;
 
 		if (desc->status == IRQ_DISABLED)
 			continue;
@@ -154,7 +152,7 @@ static void migrate_irqs(void)
 		if (desc->status == IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, desc->affinity, cpu_online_map);
+		cpus_and(mask, irq_desc[irq].affinity, cpu_online_map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			/*
 			 * Save it for phase 2 processing
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -343,7 +343,7 @@ static irqreturn_t smp_irq_move_cleanup_
 		if (irq < 0)
 			continue;
 
-		desc = irq_desc(irq);
+		desc = irq_desc + irq;
 		cfg = irq_cfg + irq;
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
@@ -495,9 +495,9 @@ ia64_handle_irq (ia64_vector vector, str
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_irqs_this_cpu(irq_desc(vector))++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_irqs_this_cpu(irq_desc(vector))++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		else {
 			int irq = local_vector_to_irq(vector);
 
@@ -553,9 +553,9 @@ void ia64_process_pending_intr(void)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_irqs_this_cpu(irq_desc(vector))++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_irqs_this_cpu(irq_desc(vector))++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 			int irq = local_vector_to_irq(vector);
@@ -629,7 +629,7 @@ ia64_native_register_percpu_irq (ia64_ve
 
 	irq = vec;
 	BUG_ON(bind_irq_vector(irq, vec, CPU_MASK_ALL));
-	desc = irq_desc(irq);
+	desc = irq_desc + irq;
 	desc->status |= IRQ_PER_CPU;
 	desc->chip = &irq_type_ia64_lsapic;
 	if (action)
Index: linux-2.6/arch/ia64/kernel/mca.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/mca.c
+++ linux-2.6/arch/ia64/kernel/mca.c
@@ -2101,7 +2101,7 @@ ia64_mca_late_init(void)
 			irq = local_vector_to_irq(cpe_vector);
 			if (irq > 0) {
 				cpe_poll_enabled = 0;
-				desc = irq_desc(irq);
+				desc = irq_desc + irq;
 				desc->status |= IRQ_PER_CPU;
 				setup_irq(irq, &mca_cpe_irqaction);
 				ia64_cpe_irq = irq;
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -73,7 +73,7 @@ static void ia64_set_msi_irq_affinity(un
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
 }
 #endif /* CONFIG_SMP */
 
@@ -120,7 +120,7 @@ void ia64_teardown_msi_irq(unsigned int
 static void ia64_ack_msi_irq(unsigned int irq)
 {
 	irq_complete_move(irq);
-	move_native_irq(irq, irq_desc(irq));
+	move_native_irq(irq, &irq_desc[irq]);
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -701,7 +701,7 @@ int migrate_platform_irqs(unsigned int c
 			new_cpei_cpu = any_online_cpu(cpu_online_map);
 			mask = cpumask_of_cpu(new_cpei_cpu);
 			set_cpei_target_cpu(new_cpei_cpu);
-			desc = irq_desc(ia64_cpe_irq);
+			desc = irq_desc + ia64_cpe_irq;
 			/*
 			 * Switch for now, immediately, we need to do fake intr
 			 * as other interrupts, but need to study CPEI behaviour with
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -110,7 +110,7 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq, irq_desc(irq));
+	move_native_irq(irq, &irq_desc[irq]);
 }
 
 static void sn_end_irq(unsigned int irq)
@@ -293,15 +293,14 @@ unsigned int sn_local_vector_to_irq(u8 v
 void sn_irq_init(void)
 {
 	int i;
-	irq_desc_t *desc;
+	irq_desc_t *base_desc = irq_desc;
 
 	ia64_first_device_vector = IA64_SN2_FIRST_DEVICE_VECTOR;
 	ia64_last_device_vector = IA64_SN2_LAST_DEVICE_VECTOR;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		desc = irq_desc(i);
-		if (desc->chip == &no_irq_type) {
-			desc->chip = &irq_type_sn;
+		if (base_desc[i].chip == &no_irq_type) {
+			base_desc[i].chip = &irq_type_sn;
 		}
 	}
 }
@@ -430,7 +429,7 @@ sn_call_force_intr_provider(struct sn_ir
 	pci_provider = sn_pci_provider[sn_irq_info->irq_bridge_type];
 
 	/* Don't force an interrupt if the irq has been disabled */
-	if (!(irq_desc(sn_irq_info->irq_irq)->status & IRQ_DISABLED) &&
+	if (!(irq_desc[sn_irq_info->irq_irq].status & IRQ_DISABLED) &&
 	    pci_provider && pci_provider->force_interrupt)
 		(*pci_provider->force_interrupt)(sn_irq_info);
 }
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -204,13 +204,13 @@ static void sn_set_msi_irq_affinity(unsi
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	irq_desc(irq)->affinity = cpu_mask;
+	irq_desc[irq].affinity = cpu_mask;
 }
 #endif /* CONFIG_SMP */
 
 static void sn_ack_msi_irq(unsigned int irq)
 {
-	move_native_irq(irq, irq_desc(irq));
+	move_native_irq(irq, &irq_desc[irq]);
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/m32r/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/irq.c
+++ linux-2.6/arch/m32r/kernel/irq.c
@@ -43,10 +43,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -56,7 +54,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -64,7 +62,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
@@ -86,7 +84,7 @@ asmlinkage unsigned int do_IRQ(int irq,
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* FIXME M32R */
 #endif
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 	set_irq_regs(old_regs);
 
Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -77,7 +77,6 @@ static struct hw_interrupt_type m32104ut
 void __init init_IRQ(void)
 {
 	static int once = 0;
-	struct irq_desc *desc;
 
 	if (once)
 		return;
@@ -86,40 +85,36 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	desc = irq_desc(M32R_IRQ_INT0);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32104ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT0].chip = &m32104ut_irq_type;
+	irq_desc[M32R_IRQ_INT0].action = 0;
+	irq_desc[M32R_IRQ_INT0].depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11; /* "H" level sense */
 	disable_m32104ut_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	desc = irq_desc(M32R_IRQ_MFT2);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32104ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &m32104ut_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	desc = irq_desc(M32R_IRQ_SIO0_R);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32104ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &m32104ut_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	desc = irq_desc(M32R_IRQ_SIO0_S);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32104ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &m32104ut_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -297,117 +297,103 @@ static struct hw_interrupt_type m32700ut
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	desc = irq_desc(M32700UT_LAN_IRQ_LAN);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32700UT_LAN_IRQ_LAN].status = IRQ_DISABLED;
+	irq_desc[M32700UT_LAN_IRQ_LAN].chip = &m32700ut_lanpld_irq_type;
+	irq_desc[M32700UT_LAN_IRQ_LAN].action = 0;
+	irq_desc[M32700UT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	desc = irq_desc(M32R_IRQ_MFT2);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32700ut_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	desc = irq_desc(M32R_IRQ_SIO0_R);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	desc = irq_desc(M32R_IRQ_SIO0_S);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	desc = irq_desc(M32R_IRQ_SIO1_R);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	desc = irq_desc(M32R_IRQ_SIO1_S);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	desc = irq_desc(M32R_IRQ_DMA1)
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_DMA1].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_DMA1].action = 0;
+	irq_desc[M32R_IRQ_DMA1].depth = 1;
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	desc = irq_desc(PLD_IRQ_SIO0_RCV);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_SIO0_RCV].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
+	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	desc = irq_desc(PLD_IRQ_SIO0_SND);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_SIO0_SND].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
+	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	desc = irq_desc(PLD_IRQ_CFIREQ);
-	desc->status = IRQ_DISABLED;
-	desc->hip = &m32700ut_pld_irq_type;
-	desc->ction = 0;
-	desc->epth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFIREQ].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_CFIREQ].action = 0;
+	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	desc = irq_desc(PLD_IRQ_CFC_INSERT);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_INSERT].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
+	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	desc = irq_desc(PLD_IRQ_CFC_EJECT);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_EJECT].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
+	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -427,13 +413,13 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-	desc = irq_desc(M32700UT_LCD_IRQ_USB_INT1);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_lcdpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
-	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-	disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
+
+    irq_desc[M32700UT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
+    irq_desc[M32700UT_LCD_IRQ_USB_INT1].chip = &m32700ut_lcdpld_irq_type;
+    irq_desc[M32700UT_LCD_IRQ_USB_INT1].action = 0;
+    irq_desc[M32700UT_LCD_IRQ_USB_INT1].depth = 1;
+    lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+    disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -446,11 +432,10 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	desc = irq_desc(M32R_IRQ_INT3);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT3].chip = &m32700ut_irq_type;
+	irq_desc[M32R_IRQ_INT3].action = 0;
+	irq_desc[M32R_IRQ_INT3].depth = 1;
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_m32700ut_irq(M32R_IRQ_INT3);
 #endif	/* CONFIG_VIDEO_M32R_AR */
Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -45,7 +45,7 @@ static void mask_and_ack_mappi(unsigned
 
 static void end_mappi_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_mappi_irq(irq);
 }
 
@@ -77,8 +77,6 @@ static struct hw_interrupt_type mappi_ir
 void __init init_IRQ(void)
 {
 	static int once = 0;
-	struct irq_desc *desc;
-	unsigned irq;
 
 	if (once)
 		return;
@@ -87,86 +85,70 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	irq = M32R_IRQ_INT0;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT0].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_INT0].action = NULL;
+	irq_desc[M32R_IRQ_INT0].depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = NULL;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = NULL;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = NULL;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = NULL;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = NULL;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	irq = M32R_IRQ_INT1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT1].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_INT1].action = NULL;
+	irq_desc[M32R_IRQ_INT1].depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	irq = M32R_IRQ_INT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = NULL;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT2].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_INT2].action = NULL;
+	irq_desc[M32R_IRQ_INT2].depth = 1;
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
 #endif /* CONFIG_M32RPCC */
Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -83,112 +83,89 @@ static struct hw_interrupt_type mappi2_i
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	unsigned int i;
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-
-	irq = M32R_IRQ_INT0;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT0].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_INT0].action = 0;
+	irq_desc[M32R_IRQ_INT0].depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq = M32R_IRQ_INT1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT1].chip = &mappi2_irq_type;
+	irq_desc[M32R_IRQ_INT1].action = 0;
+	irq_desc[M32R_IRQ_INT1].depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	irq_desc PLD_IRQ_CFIREQ;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi2_irq_type;
+	irq_desc[PLD_IRQ_CFIREQ].action = 0;
+	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	irq = PLD_IRQ_CFC_INSERT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi2_irq_type;
+	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
+	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	irq = PLD_IRQ_CFC_EJECT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi2_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_EJECT].chip = &mappi2_irq_type;
+	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
+	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
 #endif /* CONFIG_MAPPI2_CFC */
Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -83,114 +83,91 @@ static struct hw_interrupt_type mappi3_i
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	unsigned int irq;
-
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	irq = M32R_IRQ_INT0;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT0].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_INT0].action = 0;
+	irq_desc[M32R_IRQ_INT0].depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq = M32R_IRQ_INT1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT1].chip = &mappi3_irq_type;
+	irq_desc[M32R_IRQ_INT1].action = 0;
+	irq_desc[M32R_IRQ_INT1].depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	irq = PLD_IRQ_CFIREQ;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi3_irq_type;
+	irq_desc[PLD_IRQ_CFIREQ].action = 0;
+	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	irq = PLD_IRQ_CFC_INSERT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi3_irq_type;
+	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
+	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
 
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	irq = PLD_IRQ_IDEIREQ;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi3_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_IDEIREQ].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_IDEIREQ].chip = &mappi3_irq_type;
+	irq_desc[PLD_IRQ_IDEIREQ].action = 0;
+	irq_desc[PLD_IRQ_IDEIREQ].depth = 1;	/* disable nested irq */
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
 
Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -75,8 +75,6 @@ static struct hw_interrupt_type oaks32r_
 void __init init_IRQ(void)
 {
 	static int once = 0;
-	struct irq_desc *desc;
-	unsigned int irq;
 
 	if (once)
 		return;
@@ -85,64 +83,52 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	irq = M32R_IRQ_INT3;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT3].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_INT3].action = 0;
+	irq_desc[M32R_IRQ_INT3].depth = 1;
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &oaks32r_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &oaks32r_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -298,130 +298,103 @@ static struct hw_interrupt_type opsput_l
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	unsigned int irq;
-
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	irq = OPSPUT_LAN_IRQ_LAN;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[OPSPUT_LAN_IRQ_LAN].status = IRQ_DISABLED;
+	irq_desc[OPSPUT_LAN_IRQ_LAN].chip = &opsput_lanpld_irq_type;
+	irq_desc[OPSPUT_LAN_IRQ_LAN].action = 0;
+	irq_desc[OPSPUT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	irq = M32R_IRQ_DMA1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_DMA1].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_DMA1].action = 0;
+	irq_desc[M32R_IRQ_DMA1].depth = 1;
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	irq = PLD_IRQ_SIO0_RCV;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_SIO0_RCV].chip = &opsput_pld_irq_type;
+	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
+	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	irq = PLD_IRQ_SIO0_SND;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_SIO0_SND].chip = &opsput_pld_irq_type;
+	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
+	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	irq = PLD_IRQ_CFIREQ;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFIREQ].chip = &opsput_pld_irq_type;
+	irq_desc[PLD_IRQ_CFIREQ].action = 0;
+	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	irq = PLD_IRQ_CFC_INSERT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_INSERT].chip = &opsput_pld_irq_type;
+	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
+	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	irq = PLD_IRQ_CFC_EJECT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_CFC_EJECT].chip = &opsput_pld_irq_type;
+	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
+	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -436,20 +409,18 @@ void __init init_IRQ(void)
 	 * INT1# is used for UART, MMC, CF Controller in FPGA.
 	 * We enable it here.
 	 */
-	icr_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
+	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	enable_opsput_irq(M32R_IRQ_INT1);
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
 
-	irq = OPSPUT_LCD_IRQ_USB_INT1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
-	lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-	disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
+    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
+    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].chip = &opsput_lcdpld_irq_type;
+    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].action = 0;
+    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].depth = 1;
+    lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+    disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -462,12 +433,10 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	irq = M32R_IRQ_INT3;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &opsput_lanpld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;	/* disable nested irq */
+	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_INT3].chip = &opsput_irq_type;
+	irq_desc[M32R_IRQ_INT3].action = 0;
+	irq_desc[M32R_IRQ_INT3].depth = 1;
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_VIDEO_M32R_AR */
Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -149,8 +149,6 @@ void __init init_IRQ(void)
 {
 	static int once = 0;
 	int i;
-	struct irq_desc *desc;
-	unsigned int irq;
 
 	if (once)
 		return;
@@ -158,65 +156,53 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	irq = M32R_IRQ_MFT2;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_MFT2].action = 0;
+	irq_desc[M32R_IRQ_MFT2].depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
 	/* SIO0_R : uart receive data */
-	irq = M32R_IRQ_SIO0_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO0_R].action = 0;
+	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq = M32R_IRQ_SIO0_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO0_S].action = 0;
+	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq = M32R_IRQ_SIO1_R;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO1_R].action = 0;
+	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq = M32R_IRQ_SIO1_S;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &mappi_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
+	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
+	irq_desc[M32R_IRQ_SIO1_S].action = 0;
+	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_SERIAL_M32R_SIO */
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		irq = PLD_IRQ_CF0 + i;
-		desc = irq_desc(irq);
-		desc->status = IRQ_DISABLED;
-		desc->chip = &m32700ut_pld_irq_type;
-		desc->action = 0;
-		desc->depth = 1;
+		irq_desc[PLD_IRQ_CF0 + i].status = IRQ_DISABLED;
+		irq_desc[PLD_IRQ_CF0 + i].chip = &m32700ut_pld_irq_type;
+		irq_desc[PLD_IRQ_CF0 + i].action = 0;
+		irq_desc[PLD_IRQ_CF0 + i].depth = 1;	/* disable nested irq */
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
 			= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 		disable_m32700ut_pld_irq(PLD_IRQ_CF0 + i);
@@ -224,23 +210,19 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	irq = PLD_IRQ_UART0;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_UART0].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_UART0].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_UART0].action = 0;
+	irq_desc[PLD_IRQ_UART0].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	irq = PLD_IRQ_UART1;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_UART1].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_UART1].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_UART1].action = 0;
+	irq_desc[PLD_IRQ_UART1].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
@@ -248,12 +230,10 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	irq = PLD_IRQ_SNDINT;
-	desc = irq_desc(irq);
-	desc->status = IRQ_DISABLED;
-	desc->chip = &m32700ut_pld_irq_type;
-	desc->action = 0;
-	desc->depth = 1;
+	irq_desc[PLD_IRQ_SNDINT].status = IRQ_DISABLED;
+	irq_desc[PLD_IRQ_SNDINT].chip = &m32700ut_pld_irq_type;
+	irq_desc[PLD_IRQ_SNDINT].action = 0;
+	irq_desc[PLD_IRQ_SNDINT].depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);
Index: linux-2.6/arch/m68knommu/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/irq.c
+++ linux-2.6/arch/m68knommu/kernel/irq.c
@@ -23,7 +23,7 @@ asmlinkage void do_IRQ(int irq, struct p
 	struct pt_regs *oldregs = set_irq_regs(regs);
 
 	irq_enter();
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 
 	set_irq_regs(oldregs);
@@ -48,12 +48,10 @@ void __init init_IRQ(void)
 	init_vectors();
 
 	for (irq = 0; (irq < NR_IRQS); irq++) {
-		struct irq_desc *desc = irq_desc(irq);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-		desc->chip = &m_irq_chip;
+		irq_desc[irq].status = IRQ_DISABLED;
+		irq_desc[irq].action = NULL;
+		irq_desc[irq].depth = 1;
+		irq_desc[irq].chip = &m_irq_chip;
 	}
 }
 
@@ -66,13 +64,11 @@ int show_interrupts(struct seq_file *p,
 		seq_puts(p, "           CPU0\n");
 
 	if (irq < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(irq);
-
-		ap = desc->action;
+		ap = irq_desc[irq].action;
 		if (ap) {
 			seq_printf(p, "%3d: ", irq);
 			seq_printf(p, "%10u ", kstat_irqs(irq));
-			seq_printf(p, "%14s  ", desc->chip->name);
+			seq_printf(p, "%14s  ", irq_desc[irq].chip->name);
 
 			seq_printf(p, "%s", ap->name);
 			for (ap = ap->next; ap; ap = ap->next)
Index: linux-2.6/arch/mips/au1000/common/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/au1000/common/irq.c
+++ linux-2.6/arch/mips/au1000/common/irq.c
@@ -224,7 +224,7 @@ static inline void mask_and_ack_level_ir
 
 static void end_irq(unsigned int irq_nr)
 {
-	if (!(irq_desc(irq_nr)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq_nr].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		local_enable_irq(irq_nr);
 
 #if defined(CONFIG_MIPS_PB1000)
Index: linux-2.6/arch/mips/dec/ioasic-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/ioasic-irq.c
+++ linux-2.6/arch/mips/dec/ioasic-irq.c
@@ -57,7 +57,7 @@ static inline void ack_ioasic_irq(unsign
 
 static inline void end_ioasic_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		unmask_ioasic_irq(irq);
 }
 
Index: linux-2.6/arch/mips/emma2rh/markeins/irq_markeins.c
===================================================================
--- linux-2.6.orig/arch/mips/emma2rh/markeins/irq_markeins.c
+++ linux-2.6/arch/mips/emma2rh/markeins/irq_markeins.c
@@ -110,7 +110,7 @@ static void emma2rh_gpio_irq_ack(unsigne
 
 static void emma2rh_gpio_irq_end(unsigned int irq)
 {
-	if (!(irq_desc(irq)status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		ll_emma2rh_gpio_irq_enable(irq - emma2rh_gpio_irq_base);
 }
 
Index: linux-2.6/arch/mips/kernel/irq-gic.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gic.c
+++ linux-2.6/arch/mips/kernel/irq-gic.c
@@ -187,7 +187,7 @@ static void gic_set_affinity(unsigned in
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
 	}
-	irq_desc(irq)->affinity = cpumask;
+	irq_desc[irq].affinity = cpumask;
 	spin_unlock_irqrestore(&gic_lock, flags);
 
 }
Index: linux-2.6/arch/mips/kernel/irq-msc01.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-msc01.c
+++ linux-2.6/arch/mips/kernel/irq-msc01.c
@@ -79,7 +79,7 @@ static void edge_mask_and_ack_msc_irq(un
  */
 static void end_msc_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		unmask_msc_irq(irq);
 }
 
Index: linux-2.6/arch/mips/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq.c
+++ linux-2.6/arch/mips/kernel/irq.c
@@ -99,10 +99,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -112,7 +110,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->name);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -120,7 +118,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_putc(p, '\n');
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
Index: linux-2.6/arch/mips/kernel/smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smtc.c
+++ linux-2.6/arch/mips/kernel/smtc.c
@@ -663,7 +663,7 @@ void smtc_forward_irq(unsigned int irq)
 	 * and efficiency, we just pick the easiest one to find.
 	 */
 
-	target = first_cpu(irq_desc(irq)->affinity);
+	target = first_cpu(irq_desc[irq].affinity);
 
 	/*
 	 * We depend on the platform code to have correctly processed
Index: linux-2.6/arch/mips/mti-malta/malta-smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/mti-malta/malta-smtc.c
+++ linux-2.6/arch/mips/mti-malta/malta-smtc.c
@@ -138,7 +138,7 @@ void plat_set_irq_affinity(unsigned int
 		if ((cpu_data[cpu].vpe_id != 0) || !cpu_online(cpu))
 			cpu_clear(cpu, tmask);
 	}
-	irq_desc(irq)->affinity = tmask;
+	irq_desc[irq].affinity = tmask;
 
 	if (cpus_empty(tmask))
 		/*
Index: linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip32/ip32-irq.c
+++ linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
@@ -157,7 +157,7 @@ static void crime_level_mask_and_ack_irq
 
 static void crime_level_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq).status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		crime_enable_irq(irq);
 }
 
@@ -186,7 +186,7 @@ static void crime_edge_mask_and_ack_irq(
 
 static void crime_edge_end_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		crime_enable_irq(irq);
 }
 
@@ -227,7 +227,7 @@ static void disable_macepci_irq(unsigned
 
 static void end_macepci_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_macepci_irq(irq);
 }
 
@@ -340,7 +340,7 @@ static void mask_and_ack_maceisa_irq(uns
 
 static void end_maceisa_irq(unsigned irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_maceisa_irq(irq);
 }
 
@@ -376,7 +376,7 @@ static void disable_mace_irq(unsigned in
 
 static void end_mace_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_mace_irq(irq);
 }
 
Index: linux-2.6/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/irq.c
@@ -113,7 +113,7 @@ static void bcm1480_set_affinity(unsigne
 {
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 	unsigned int irq_dirty;
 
@@ -225,8 +225,9 @@ static void ack_bcm1480_irq(unsigned int
 
 static void end_bcm1480_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
+	}
 }
 
 
Index: linux-2.6/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6/arch/mips/sibyte/sb1250/irq.c
@@ -107,7 +107,7 @@ static void sb1250_set_affinity(unsigned
 {
 	int i = 0, old_cpu, cpu, int_on;
 	u64 cur_ints;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
 	i = first_cpu(mask);
@@ -209,8 +209,9 @@ static void ack_sb1250_irq(unsigned int
 
 static void end_sb1250_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
+	}
 }
 
 
Index: linux-2.6/arch/mips/sni/a20r.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/a20r.c
+++ linux-2.6/arch/mips/sni/a20r.c
@@ -181,7 +181,7 @@ static inline void mask_a20r_irq(unsigne
 
 static void end_a20r_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		a20r_ack_hwint();
 		unmask_a20r_irq(irq);
 	}
Index: linux-2.6/arch/mips/sni/pcimt.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcimt.c
+++ linux-2.6/arch/mips/sni/pcimt.c
@@ -209,7 +209,7 @@ void disable_pcimt_irq(unsigned int irq)
 
 static void end_pcimt_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_pcimt_irq(irq);
 }
 
Index: linux-2.6/arch/mips/sni/pcit.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcit.c
+++ linux-2.6/arch/mips/sni/pcit.c
@@ -171,7 +171,7 @@ void disable_pcit_irq(unsigned int irq)
 
 void end_pcit_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_pcit_irq(irq);
 }
 
Index: linux-2.6/arch/mips/sni/rm200.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/rm200.c
+++ linux-2.6/arch/mips/sni/rm200.c
@@ -443,7 +443,7 @@ void disable_rm200_irq(unsigned int irq)
 
 void end_rm200_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_rm200_irq(irq);
 }
 
Index: linux-2.6/arch/mips/vr41xx/common/icu.c
===================================================================
--- linux-2.6.orig/arch/mips/vr41xx/common/icu.c
+++ linux-2.6/arch/mips/vr41xx/common/icu.c
@@ -154,7 +154,7 @@ static inline uint16_t icu2_clear(uint8_
 
 void vr41xx_enable_piuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(PIU_IRQ);
+	struct irq_desc *desc = irq_desc + PIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -169,7 +169,7 @@ EXPORT_SYMBOL(vr41xx_enable_piuint);
 
 void vr41xx_disable_piuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(PIU_IRQ);
+	struct irq_desc *desc = irq_desc + PIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -184,7 +184,7 @@ EXPORT_SYMBOL(vr41xx_disable_piuint);
 
 void vr41xx_enable_aiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(AIU_IRQ);
+	struct irq_desc *desc = irq_desc + AIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(vr41xx_enable_aiuint);
 
 void vr41xx_disable_aiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(AIU_IRQ);
+	struct irq_desc *desc = irq_desc + AIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -214,7 +214,7 @@ EXPORT_SYMBOL(vr41xx_disable_aiuint);
 
 void vr41xx_enable_kiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(KIU_IRQ);
+	struct irq_desc *desc = irq_desc + KIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -229,7 +229,7 @@ EXPORT_SYMBOL(vr41xx_enable_kiuint);
 
 void vr41xx_disable_kiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(KIU_IRQ);
+	struct irq_desc *desc = irq_desc + KIU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4111 ||
@@ -244,7 +244,7 @@ EXPORT_SYMBOL(vr41xx_disable_kiuint);
 
 void vr41xx_enable_macint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(ETHERNET_IRQ);
+	struct irq_desc *desc = irq_desc + ETHERNET_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -256,7 +256,7 @@ EXPORT_SYMBOL(vr41xx_enable_macint);
 
 void vr41xx_disable_macint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(ETHERNET_IRQ);
+	struct irq_desc *desc = irq_desc + ETHERNET_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -268,7 +268,7 @@ EXPORT_SYMBOL(vr41xx_disable_macint);
 
 void vr41xx_enable_dsiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(DSIU_IRQ);
+	struct irq_desc *desc = irq_desc + DSIU_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -280,7 +280,7 @@ EXPORT_SYMBOL(vr41xx_enable_dsiuint);
 
 void vr41xx_disable_dsiuint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(DSIU_IRQ);
+	struct irq_desc *desc = irq_desc + DSIU_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(vr41xx_disable_dsiuint);
 
 void vr41xx_enable_firint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(FIR_IRQ);
+	struct irq_desc *desc = irq_desc + FIR_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -304,7 +304,7 @@ EXPORT_SYMBOL(vr41xx_enable_firint);
 
 void vr41xx_disable_firint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(FIR_IRQ);
+	struct irq_desc *desc = irq_desc + FIR_IRQ;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(vr41xx_disable_firint);
 
 void vr41xx_enable_pciint(void)
 {
-	struct irq_desc *desc = irq_desc(PCI_IRQ);
+	struct irq_desc *desc = irq_desc + PCI_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(vr41xx_enable_pciint);
 
 void vr41xx_disable_pciint(void)
 {
-	struct irq_desc *desc = irq_desc(PCI_IRQ);
+	struct irq_desc *desc = irq_desc + PCI_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(vr41xx_disable_pciint);
 
 void vr41xx_enable_scuint(void)
 {
-	struct irq_desc *desc = irq_desc(SCU_IRQ);
+	struct irq_desc *desc = irq_desc + SCU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -364,7 +364,7 @@ EXPORT_SYMBOL(vr41xx_enable_scuint);
 
 void vr41xx_disable_scuint(void)
 {
-	struct irq_desc *desc = irq_desc(SCU_IRQ);
+	struct irq_desc *desc = irq_desc + SCU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -380,7 +380,7 @@ EXPORT_SYMBOL(vr41xx_disable_scuint);
 
 void vr41xx_enable_csiint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(CSI_IRQ);
+	struct irq_desc *desc = irq_desc + CSI_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(vr41xx_enable_csiint);
 
 void vr41xx_disable_csiint(uint16_t mask)
 {
-	struct irq_desc *desc = irq_desc(CSI_IRQ);
+	struct irq_desc *desc = irq_desc + CSI_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -412,7 +412,7 @@ EXPORT_SYMBOL(vr41xx_disable_csiint);
 
 void vr41xx_enable_bcuint(void)
 {
-	struct irq_desc *desc = irq_desc(BCU_IRQ);
+	struct irq_desc *desc = irq_desc + BCU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -428,7 +428,7 @@ EXPORT_SYMBOL(vr41xx_enable_bcuint);
 
 void vr41xx_disable_bcuint(void)
 {
-	struct irq_desc *desc = irq_desc(BCU_IRQ);
+	struct irq_desc *desc = irq_desc + BCU_IRQ;
 	unsigned long flags;
 
 	if (current_cpu_type() == CPU_VR4122 ||
@@ -480,7 +480,7 @@ static struct irq_chip sysint2_irq_type
 
 static inline int set_sysint1_assign(unsigned int irq, unsigned char assign)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	uint16_t intassign0, intassign1;
 	unsigned int pin;
 
@@ -540,7 +540,7 @@ static inline int set_sysint1_assign(uns
 
 static inline int set_sysint2_assign(unsigned int irq, unsigned char assign)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 	uint16_t intassign2, intassign3;
 	unsigned int pin;
 
Index: linux-2.6/arch/mips/vr41xx/common/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/vr41xx/common/irq.c
+++ linux-2.6/arch/mips/vr41xx/common/irq.c
@@ -72,7 +72,7 @@ static void irq_dispatch(unsigned int ir
 	cascade = irq_cascade + irq;
 	if (cascade->get_irq != NULL) {
 		unsigned int source_irq = irq;
-		desc = irq_desc(source_irq);
+		desc = irq_desc + source_irq;
 		if (desc->chip->mask_ack)
 			desc->chip->mask_ack(source_irq);
 		else {
Index: linux-2.6/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6/arch/mn10300/kernel/irq.c
@@ -125,7 +125,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		if (irq_desc(irq)->chip == &no_irq_type)
+		if (irq_desc[irq].chip == &no_irq_type)
 			set_irq_chip_and_handler(irq, &mn10300_cpu_pic,
 						 handle_edge_irq);
 	unit_init_IRQ();
@@ -183,7 +183,6 @@ int show_interrupts(struct seq_file *p,
 	int i = *(loff_t *) v, j, cpu;
 	struct irqaction *action;
 	unsigned long flags;
-	struct irq_desc *desc;
 
 	switch (i) {
 		/* display column title bar naming CPUs */
@@ -197,15 +196,13 @@ int show_interrupts(struct seq_file *p,
 
 		/* display information rows, one per active CPU */
 	case 1 ... NR_IRQS - 1:
-		desc = irq_desc(i);
-		spin_lock_irqsave(&desc->lock, flags);
-
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
 				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-			seq_printf(p, " %14s.%u", desc->chip->name,
+			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
 			seq_printf(p, "  %s", action->name);
@@ -218,7 +215,7 @@ int show_interrupts(struct seq_file *p,
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 		break;
 
 		/* polish off with NMI and error counters */
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -120,7 +120,7 @@ int cpu_check_affinity(unsigned int irq,
 	if (CHECK_IRQ_PER_CPU(irq)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
-		irq_desc(irq)->affinity = CPU_MASK_ALL;
+		irq_desc[irq].affinity = CPU_MASK_ALL;
 		return -EINVAL;
 	}
 
@@ -136,7 +136,7 @@ static void cpu_set_affinity_irq(unsigne
 	if (cpu_check_affinity(irq, &dest))
 		return;
 
-	irq_desc(irq)->affinity = dest;
+	irq_desc[irq].affinity = dest;
 }
 #endif
 
@@ -175,10 +175,9 @@ int show_interrupts(struct seq_file *p,
 
 	if (i < NR_IRQS) {
 		struct irqaction *action;
-		struct irq_desc *desc = irq_desc(i);
 
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -189,7 +188,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
 
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 #ifndef PARISC_IRQ_CR16_COUNTS
 		seq_printf(p, "  %s", action->name);
 
@@ -221,7 +220,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
  skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 
 	return 0;
@@ -239,16 +238,14 @@ int show_interrupts(struct seq_file *p,
 
 int cpu_claim_irq(unsigned int irq, struct irq_chip *type, void *data)
 {
-	struct irq_desc *desc = irq_desc(irq);
-
-	if (desc->action)
+	if (irq_desc[irq].action)
 		return -EBUSY;
-	if (desc->chip != &cpu_interrupt_type)
+	if (irq_desc[irq].chip != &cpu_interrupt_type)
 		return -EBUSY;
 
 	if (type) {
-		desc->chip = type;
-		desc->chip_data = data;
+		irq_desc[irq].chip = type;
+		irq_desc[irq].chip_data = data;
 		cpu_interrupt_type.enable(irq);
 	}
 	return 0;
@@ -298,7 +295,7 @@ int txn_alloc_irq(unsigned int bits_wide
 unsigned long txn_affinity_addr(unsigned int irq, int cpu)
 {
 #ifdef CONFIG_SMP
-	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
 #endif
 
 	return cpu_data[cpu].txn_addr;
@@ -342,7 +339,6 @@ void do_cpu_irq_mask(struct pt_regs *reg
 	int irq, cpu = smp_processor_id();
 #ifdef CONFIG_SMP
 	cpumask_t dest;
-	struct irq_desc *desc;
 #endif
 
 	old_regs = set_irq_regs(regs);
@@ -355,9 +351,8 @@ void do_cpu_irq_mask(struct pt_regs *reg
 	irq = eirr_to_irq(eirr_val);
 
 #ifdef CONFIG_SMP
-	desc = irq_desc(irq);
-	dest = desc->affinity;
-	if (CHECK_IRQ_PER_CPU(desc->status) &&
+	dest = irq_desc[irq].affinity;
+	if (CHECK_IRQ_PER_CPU(irq_desc[irq].status) &&
 	    !cpu_isset(smp_processor_id(), dest)) {
 		int cpu = first_cpu(dest);
 
@@ -398,14 +393,14 @@ static void claim_cpu_irqs(void)
 {
 	int i;
 	for (i = CPU_IRQ_BASE; i <= CPU_IRQ_MAX; i++) {
-		irq_desc(i)->chip = &cpu_interrupt_type;
+		irq_desc[i].chip = &cpu_interrupt_type;
 	}
 
-	irq_desc(TIMER_IRQ)->action = &timer_action;
-	irq_desc(TIMER_IRQ)->status = IRQ_PER_CPU;
+	irq_desc[TIMER_IRQ].action = &timer_action;
+	irq_desc[TIMER_IRQ].status = IRQ_PER_CPU;
 #ifdef CONFIG_SMP
-	irq_desc(IPI_IRQ)->action = &ipi_action;
-	irq_desc(IPI_IRQ)->status = IRQ_PER_CPU;
+	irq_desc[IPI_IRQ].action = &ipi_action;
+	irq_desc[IPI_IRQ].status = IRQ_PER_CPU;
 #endif
 }
 
Index: linux-2.6/arch/powerpc/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/irq.h
+++ linux-2.6/arch/powerpc/include/asm/irq.h
@@ -17,7 +17,7 @@
 #include <asm/atomic.h>
 
 
-#define get_irq_desc(irq) (irq_desc(irq))
+#define get_irq_desc(irq) (&irq_desc[(irq)])
 
 /* Define a way to iterate across irqs. */
 #define for_each_irq(i) \
Index: linux-2.6/arch/powerpc/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/crash.c
+++ linux-2.6/arch/powerpc/kernel/crash.c
@@ -373,7 +373,7 @@ void default_machine_crash_shutdown(stru
 	hard_irq_disable();
 
 	for_each_irq(i) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = irq_desc + i;
 
 		if (desc->status & IRQ_INPROGRESS)
 			desc->chip->eoi(i);
Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -84,7 +84,7 @@ extern int tau_interrupts(int);
 #endif /* CONFIG_PPC32 */
 
 #ifdef CONFIG_PPC64
-EXPORT_SYMBOL(irq_descX);
+EXPORT_SYMBOL(irq_desc);
 
 int distribute_irqs = 1;
 
@@ -227,19 +227,18 @@ void fixup_irqs(cpumask_t map)
 
 	for_each_irq(irq) {
 		cpumask_t mask;
-		struct irq_desc *desc = irq_desc(irq);
 
-		if (desc->status & IRQ_PER_CPU)
+		if (irq_desc[irq].status & IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, desc->affinity, map);
+		cpus_and(mask, irq_desc[irq].affinity, map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
 		}
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, mask);
-		else if (desc->action && !(warned++))
+		if (irq_desc[irq].chip->set_affinity)
+			irq_desc[irq].chip->set_affinity(irq, mask);
+		else if (irq_desc[irq].action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
@@ -289,7 +288,7 @@ void do_IRQ(struct pt_regs *regs)
 		curtp = current_thread_info();
 		irqtp = hardirq_ctx[smp_processor_id()];
 		if (curtp != irqtp) {
-			struct irq_desc *desc = irq_desc(irq);
+			struct irq_desc *desc = irq_desc + irq;
 			void *handler = desc->handle_irq;
 			unsigned long saved_sp_limit = current->thread.ksp_limit;
 			if (handler == NULL)
Index: linux-2.6/arch/powerpc/platforms/8xx/m8xx_setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ linux-2.6/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -223,7 +223,7 @@ static void cpm_cascade(unsigned int irq
 	int cascade_irq;
 
 	if ((cascade_irq = cpm_get_irq()) >= 0) {
-		struct irq_desc *cdesc = irq_desc(cascade_irq);
+		struct irq_desc *cdesc = irq_desc + cascade_irq;
 
 		generic_handle_irq(cascade_irq);
 		cdesc->chip->eoi(cascade_irq);
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -153,7 +153,7 @@ static unsigned int pmac_startup_irq(uns
         int i = src >> 5;
 
   	spin_lock_irqsave(&pmac_pic_lock, flags);
-	if ((irq_desc(virq)->status & IRQ_LEVEL) == 0)
+	if ((irq_desc[virq].status & IRQ_LEVEL) == 0)
 		out_le32(&pmac_irq_hw[i]->ack, bit);
         __set_bit(src, ppc_cached_irq_mask);
         __pmac_set_irq_mask(src, 0);
@@ -221,7 +221,7 @@ static irqreturn_t gatwick_action(int cp
 			continue;
 		irq += __ilog2(bits);
 		spin_unlock_irqrestore(&pmac_pic_lock, flags);
-		__do_IRQ(irq, irq_desc(irq));
+		__do_IRQ(irq, &irq_desc[irq]);
 		spin_lock_irqsave(&pmac_pic_lock, flags);
 		rc = IRQ_HANDLED;
 	}
Index: linux-2.6/arch/powerpc/platforms/pseries/eeh_driver.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/eeh_driver.c
+++ linux-2.6/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -70,7 +70,7 @@ static int irq_in_use(unsigned int irq)
 {
 	int rc = 0;
 	unsigned long flags;
-   struct irq_desc *desc = irq_desc(irq);
+   struct irq_desc *desc = irq_desc + irq;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action)
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -205,7 +205,7 @@ static int get_irq_server(unsigned int v
 {
 	int server;
 	/* For the moment only implement delivery to all cpus or one cpu */
-	cpumask_t cpumask = irq_desc(virq)->affinity;
+	cpumask_t cpumask = irq_desc[virq].affinity;
 	cpumask_t tmp = CPU_MASK_NONE;
 
 	if (! cpu_isset(default_server, cpu_online_map))
@@ -808,7 +808,7 @@ void xics_migrate_irqs_away(void)
 		       virq, cpu);
 
 		/* Reset affinity to all cpus */
-		irq_desc(virq)->affinity = CPU_MASK_ALL;
+		irq_desc[virq].affinity = CPU_MASK_ALL;
 		desc->chip->set_affinity(virq, CPU_MASK_ALL);
 unlock:
 		spin_unlock_irqrestore(&desc->lock, flags);
Index: linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/cpm2_pic.c
+++ linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
@@ -117,10 +117,9 @@ static void cpm2_end_irq(unsigned int vi
 {
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
-	struct irq_desc *desc = irq_desc(irq_nr);
 
-	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS))
-			&& desc->action) {
+	if (!(irq_desc[irq_nr].status & (IRQ_DISABLED|IRQ_INPROGRESS))
+			&& irq_desc[irq_nr].action) {
 
 		bit = irq_to_siubit[irq_nr];
 		word = irq_to_siureg[irq_nr];
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -575,7 +575,7 @@ static struct mpic *mpic_find(unsigned i
 	if (irq < NUM_ISA_INTERRUPTS)
 		return NULL;
 
-	mpic = irq_desc(irq)->chip_data;
+	mpic = irq_desc[irq].chip_data;
 
 	if (is_ipi)
 		*is_ipi = (src >= mpic->ipi_vecs[0] &&
@@ -599,14 +599,14 @@ static inline u32 mpic_physmask(u32 cpum
 /* Get the mpic structure from the IPI number */
 static inline struct mpic * mpic_from_ipi(unsigned int ipi)
 {
-	return irq_desc(ipi)->chip_data;
+	return irq_desc[ipi].chip_data;
 }
 #endif
 
 /* Get the mpic structure from the irq number */
 static inline struct mpic * mpic_from_irq(unsigned int irq)
 {
-	return irq_desc(irq)->chip_data;
+	return irq_desc[irq].chip_data;
 }
 
 /* Send an EOI */
@@ -697,7 +697,7 @@ static void mpic_unmask_ht_irq(unsigned
 
 	mpic_unmask_irq(irq);
 
-	if (irq_desc(irq)->status & IRQ_LEVEL)
+	if (irq_desc[irq].status & IRQ_LEVEL)
 		mpic_ht_end_irq(mpic, src);
 }
 
@@ -707,7 +707,7 @@ static unsigned int mpic_startup_ht_irq(
 	unsigned int src = mpic_irq_to_hw(irq);
 
 	mpic_unmask_irq(irq);
-	mpic_startup_ht_interrupt(mpic, src, irq_desc(irq)->status);
+	mpic_startup_ht_interrupt(mpic, src, irq_desc[irq].status);
 
 	return 0;
 }
@@ -717,7 +717,7 @@ static void mpic_shutdown_ht_irq(unsigne
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
-	mpic_shutdown_ht_interrupt(mpic, src, irq_desc(irq)->status);
+	mpic_shutdown_ht_interrupt(mpic, src, irq_desc[irq].status);
 	mpic_mask_irq(irq);
 }
 
@@ -734,7 +734,7 @@ static void mpic_end_ht_irq(unsigned int
 	 * latched another edge interrupt coming in anyway
 	 */
 
-	if (irq_desc(irq)->status & IRQ_LEVEL)
+	if (irq_desc[irq].status & IRQ_LEVEL)
 		mpic_ht_end_irq(mpic, src);
 	mpic_eoi(mpic);
 }
@@ -1368,7 +1368,7 @@ void mpic_setup_this_cpu(void)
  	/* let the mpic know we want intrs. default affinity is 0xffffffff
 	 * until changed via /proc. That's how it's done on x86. If we want
 	 * it differently, then we should make sure we also change the default
-	 * values of irq_desc()->affinity in irq.c.
+	 * values of irq_desc[].affinity in irq.c.
  	 */
 	if (distribute_irqs) {
 	 	for (i = 0; i < mpic->num_sources ; i++)
Index: linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -189,7 +189,7 @@ static inline void qe_ic_write(volatile
 
 static inline struct qe_ic *qe_ic_from_irq(unsigned int virq)
 {
-	return irq_desc(virq)->chip_data;
+	return irq_desc[virq].chip_data;
 }
 
 #define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
Index: linux-2.6/arch/sh/boards/mach-cayman/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-cayman/irq.c
+++ linux-2.6/arch/sh/boards/mach-cayman/irq.c
@@ -96,7 +96,7 @@ static void ack_cayman_irq(unsigned int
 
 static void end_cayman_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_cayman_irq(irq);
 }
 
@@ -188,7 +188,7 @@ void init_cayman_irq(void)
 	}
 
 	for (i=0; i<NR_EXT_IRQS; i++) {
-		irq_desc(START_EXT_IRQS + i)->chip = &cayman_irq_type;
+		irq_desc[START_EXT_IRQS + i].chip = &cayman_irq_type;
 	}
 
 	/* Setup the SMSC interrupt */
Index: linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-dreamcast/irq.c
+++ linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
@@ -86,7 +86,7 @@ static void ack_systemasic_irq(unsigned
 /* After a IRQ has been ack'd and responded to, it needs to be renabled */
 static void end_systemasic_irq(unsigned int irq)
 {
-        if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
                 enable_systemasic_irq(irq);
 }
 
Index: linux-2.6/arch/sh/boards/mach-dreamcast/setup.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-dreamcast/setup.c
+++ linux-2.6/arch/sh/boards/mach-dreamcast/setup.c
@@ -47,7 +47,7 @@ static void __init dreamcast_setup(char
 
 	/* Assign all virtual IRQs to the System ASIC int. handler */
 	for (i = HW_EVENT_IRQ_BASE; i < HW_EVENT_IRQ_MAX; i++)
-		irq_desc(i)->chip = &systemasic_int;
+		irq_desc[i].chip = &systemasic_int;
 
 	board_time_init = aica_time_init;
 
Index: linux-2.6/arch/sh/boards/mach-microdev/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-microdev/irq.c
+++ linux-2.6/arch/sh/boards/mach-microdev/irq.c
@@ -134,7 +134,7 @@ static void enable_microdev_irq(unsigned
 static void __init make_microdev_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc(irq)->chip = &microdev_irq_type;
+	irq_desc[irq].chip = &microdev_irq_type;
 	disable_microdev_irq(irq);
 }
 
@@ -145,7 +145,7 @@ static void mask_and_ack_microdev(unsign
 
 static void end_microdev_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_microdev_irq(irq);
 }
 
Index: linux-2.6/arch/sh/boards/mach-se/7206/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7206/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7206/irq.c
@@ -90,7 +90,7 @@ static void eoi_se7206_irq(unsigned int
 {
 	unsigned short sts0,sts1;
 
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_se7206_irq(irq);
 	/* FPGA isr clear */
 	sts0 = ctrl_inw(INTSTS0);
Index: linux-2.6/arch/sh/boards/mach-se/7343/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7343/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7343/irq.c
@@ -45,7 +45,7 @@ static void se7343_irq_demux(unsigned in
 
 	while (intv) {
 		if (intv & 1) {
-			ext_desc = irq_desc(ext_irq);
+			ext_desc = irq_desc + ext_irq;
 			handle_level_irq(ext_irq, ext_desc);
 		}
 		intv >>= 1;
Index: linux-2.6/arch/sh/boards/mach-se/7722/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7722/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7722/irq.c
@@ -45,7 +45,7 @@ static void se7722_irq_demux(unsigned in
 
 	while (intv) {
 		if (intv & 1) {
-			ext_desc = irq_desc(ext_irq);
+			ext_desc = irq_desc + ext_irq;
 			handle_level_irq(ext_irq, ext_desc);
 		}
 		intv >>= 1;
Index: linux-2.6/arch/sh/boards/mach-systemh/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-systemh/irq.c
+++ linux-2.6/arch/sh/boards/mach-systemh/irq.c
@@ -88,14 +88,14 @@ static void mask_and_ack_systemh(unsigne
 
 static void end_systemh_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_systemh_irq(irq);
 }
 
 void make_systemh_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc(irq)->chip = &systemh_irq_type;
+	irq_desc[irq].chip = &systemh_irq_type;
 	disable_systemh_irq(irq);
 }
 
Index: linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
===================================================================
--- linux-2.6.orig/arch/sh/cchips/hd6446x/hd64461.c
+++ linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
@@ -48,7 +48,7 @@ static void mask_and_ack_hd64461(unsigne
 
 static void end_hd64461_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_hd64461_irq(irq);
 }
 
@@ -153,7 +153,7 @@ int __init setup_hd64461(void)
 
 	/*  IRQ 80 -> 95 belongs to HD64461  */
 	for (i = HD64461_IRQBASE; i < HD64461_IRQBASE + 16; i++) {
-		irq_desc(i)->chip = &hd64461_irq_type;
+		irq_desc[i].chip = &hd64461_irq_type;
 	}
 
 	setup_irq(CONFIG_HD64461_IRQ, &irq0);
Index: linux-2.6/arch/sh/cchips/hd6446x/hd64465/setup.c
===================================================================
--- linux-2.6.orig/arch/sh/cchips/hd6446x/hd64465/setup.c
+++ linux-2.6/arch/sh/cchips/hd6446x/hd64465/setup.c
@@ -50,7 +50,7 @@ static void mask_and_ack_hd64465(unsigne
 
 static void end_hd64465_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_hd64465_irq(irq);
 }
 
@@ -164,7 +164,7 @@ static int __init setup_hd64465(void)
 	outw(0xffff, HD64465_REG_NIMR);	/* mask all interrupts */
 
 	for (i = 0; i < HD64465_IRQ_NUM ; i++) {
-		irq_desc(HD64465_IRQ_BASE + i)->chip = &hd64465_irq_type;
+		irq_desc[HD64465_IRQ_BASE + i].chip = &hd64465_irq_type;
 	}
 
 	setup_irq(CONFIG_HD64465_IRQ, &irq0);
Index: linux-2.6/arch/sh/kernel/cpu/irq/imask.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/imask.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/imask.c
@@ -96,7 +96,7 @@ static void mask_and_ack_imask(unsigned
 
 static void end_imask_irq(unsigned int irq)
 {
-	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_imask_irq(irq);
 }
 
@@ -108,6 +108,6 @@ static void shutdown_imask_irq(unsigned
 void make_imask_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc(irq)->chip = &imask_irq_type;
+	irq_desc[irq].chip = &imask_irq_type;
 	enable_irq(irq);
 }
Index: linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -156,7 +156,7 @@ static void end_intc_irq(unsigned int ir
 void make_intc_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc(irq)->chip = &intc_irq_type;
+	irq_desc[irq].chip = &intc_irq_type;
 	disable_intc_irq(irq);
 }
 
@@ -196,7 +196,7 @@ void __init plat_irq_setup(void)
 
 	/* Set default: per-line enable/disable, priority driven ack/eoi */
 	for (i = 0; i < NR_INTC_IRQS; i++)
-		irq_desc(i)->chip = &intc_irq_type;
+		irq_desc[i].chip = &intc_irq_type;
 
 
 	/* Disable all interrupts and set all priorities to 0 to avoid trouble */
Index: linux-2.6/arch/sh/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/irq.c
+++ linux-2.6/arch/sh/kernel/irq.c
@@ -45,24 +45,22 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < sh_mv.mv_nr_irqs) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-		seq_printf(p, " %14s", desc->chip->name);
-		seq_printf(p, "-%-8s", desc->name);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == sh_mv.mv_nr_irqs)
 		seq_printf(p, "Err: %10u\n", atomic_read(&irq_err_count));
 
Index: linux-2.6/arch/sparc64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/irq.c
+++ linux-2.6/arch/sparc64/kernel/irq.c
@@ -176,10 +176,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -189,7 +187,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %9s", desc->chip->typename);
+		seq_printf(p, " %9s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -197,7 +195,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
@@ -249,7 +247,7 @@ struct irq_handler_data {
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc(virt_irq)->affinity;
+	cpumask_t mask = irq_desc[virt_irq].affinity;
 	int cpuid;
 
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
@@ -335,7 +333,7 @@ static void sun4u_irq_disable(unsigned i
 static void sun4u_irq_eoi(unsigned int virt_irq)
 {
 	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
-	struct irq_desc *desc = irq_desc(virt_irq);
+	struct irq_desc *desc = irq_desc + virt_irq;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		return;
@@ -390,7 +388,7 @@ static void sun4v_irq_disable(unsigned i
 static void sun4v_irq_eoi(unsigned int virt_irq)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
-	struct irq_desc *desc = irq_desc(virt_irq);
+	struct irq_desc *desc = irq_desc + virt_irq;
 	int err;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
@@ -466,7 +464,7 @@ static void sun4v_virq_disable(unsigned
 
 static void sun4v_virq_eoi(unsigned int virt_irq)
 {
-	struct irq_desc *desc = irq_desc(virt_irq);
+	struct irq_desc *desc = irq_desc + virt_irq;
 	unsigned long dev_handle, dev_ino;
 	int err;
 
@@ -524,7 +522,7 @@ void irq_install_pre_handler(int virt_ir
 			     void *arg1, void *arg2)
 {
 	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
-	struct irq_desc *desc = irq_desc(virt_irq);
+	struct irq_desc *desc = irq_desc + virt_irq;
 
 	data->pre_handler = func;
 	data->arg1 = arg1;
@@ -650,7 +648,7 @@ unsigned int sun4v_build_virq(u32 devhan
 	 * especially wrt. locking, we do not let request_irq() enable
 	 * the interrupt.
 	 */
-	desc = irq_desc(virt_irq);
+	desc = irq_desc + virt_irq;
 	desc->status |= IRQ_NOAUTOEN;
 
 	set_irq_chip_data(virt_irq, data);
@@ -738,7 +736,7 @@ void handler_irq(int irq, struct pt_regs
 		virt_irq = bucket_get_virt_irq(bucket_pa);
 		bucket_clear_chain_pa(bucket_pa);
 
-		desc = irq_desc(virt_irq);
+		desc = irq_desc + virt_irq;
 
 		desc->handle_irq(virt_irq, desc);
 
@@ -784,16 +782,15 @@ void fixup_irqs(void)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		unsigned long flags;
-		struct irq_desc *desc = irq_desc(irq);
 
-		spin_lock_irqsave(&desc->lock, flags);
-		if (desc->action &&
-		    !(desc->status & IRQ_PER_CPU)) {
-			if (desc->chip->set_affinity)
-				desc->chip->set_affinity(irq,
-					desc->affinity);
+		spin_lock_irqsave(&irq_desc[irq].lock, flags);
+		if (irq_desc[irq].action &&
+		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
+			if (irq_desc[irq].chip->set_affinity)
+				irq_desc[irq].chip->set_affinity(irq,
+					irq_desc[irq].affinity);
 		}
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
 }
 #endif
@@ -1035,5 +1032,5 @@ void __init init_IRQ(void)
 			     : "i" (PSTATE_IE)
 			     : "g1");
 
-	irq_desc(0)->action = &timer_irq_action;
+	irq_desc[0].action = &timer_irq_action;
 }
Index: linux-2.6/arch/sparc64/kernel/pci_msi.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/pci_msi.c
+++ linux-2.6/arch/sparc64/kernel/pci_msi.c
@@ -33,7 +33,7 @@ static irqreturn_t sparc64_msiq_interrup
 			unsigned int virt_irq;
 
 			virt_irq = pbm->msi_irq_table[msi - pbm->msi_first];
-			desc = irq_desc(virt_irq);
+			desc = irq_desc + virt_irq;
 
 			desc->handle_irq(virt_irq, desc);
 		}
Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -33,10 +33,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -46,7 +44,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -54,7 +52,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 
@@ -334,7 +332,7 @@ unsigned int do_IRQ(int irq, struct uml_
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
-	__do_IRQ(irq, irq_desc(irq));
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
@@ -390,20 +388,17 @@ static struct hw_interrupt_type SIGVTALR
 void __init init_IRQ(void)
 {
 	int i;
-	struct irq_desc *desc;
 
-	desc  = irq_desc(TIMER_IRQ);
-	desc->status = IRQ_DISABLED;
-	desc->action = NULL;
-	desc->depth = 1;
-	desc->chip = &SIGVTALRM_irq_type;
+	irq_desc[TIMER_IRQ].status = IRQ_DISABLED;
+	irq_desc[TIMER_IRQ].action = NULL;
+	irq_desc[TIMER_IRQ].depth = 1;
+	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
 	enable_irq(TIMER_IRQ);
 	for (i = 1; i < NR_IRQS; i++) {
-		desc = irq_desc(i);
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-		desc->chip = &normal_irq_type;
+		irq_desc[i].status = IRQ_DISABLED;
+		irq_desc[i].action = NULL;
+		irq_desc[i].depth = 1;
+		irq_desc[i].chip = &normal_irq_type;
 		enable_irq(i);
 	}
 }
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -557,7 +557,7 @@ static void set_ioapic_affinity_irq(unsi
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
 	desc->affinity = mask;
@@ -1376,9 +1376,9 @@ static void ioapic_register_intr(int irq
 
 	/* first time to use this irq_desc */
 	if (irq < 16)
-		desc = irq_desc(irq);
+		desc = to_irq_desc(irq);
 	else
-		desc = irq_desc_with_new(irq);
+		desc = to_irq_desc_with_new(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
@@ -2256,7 +2256,7 @@ static void migrate_ioapic_irq(int irq,
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
 		spin_lock_irqsave(&ioapic_lock, flags);
@@ -2285,7 +2285,7 @@ static void migrate_ioapic_irq(int irq,
 static int migrate_irq_remapped_level(int irq)
 {
 	int ret = -1;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	mask_IO_APIC_irq(irq);
 
@@ -2340,7 +2340,7 @@ static void ir_irq_migration(struct work
  */
 static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
@@ -2369,7 +2369,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
-		desc = irq_desc(irq);
+		desc = to_irq_desc(irq);
 		if (!desc)
 			continue;
 
@@ -2426,7 +2426,7 @@ static void ack_x2apic_edge(unsigned int
 
 static void ack_apic_edge(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	irq_complete_move(irq);
 	move_native_irq(irq, desc);
@@ -2444,7 +2444,7 @@ static void ack_apic_level(unsigned int
 	int i;
 #endif
 	int do_unmask_irq = 0;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -2585,7 +2585,7 @@ static inline void init_IO_APIC_traps(vo
 			if (irq < 16)
 				make_8259A_irq(irq);
 			else {
-				desc = irq_desc(irq);
+				desc = to_irq_desc(irq);
 				/* Strange. Oh, well.. */
 				desc->chip = &no_irq_chip;
 			}
@@ -2629,7 +2629,7 @@ static void lapic_register_intr(int irq)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
@@ -3189,7 +3189,7 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->affinity = mask;
 }
 
@@ -3240,7 +3240,7 @@ static void ir_set_msi_irq_affinity(unsi
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -3315,7 +3315,7 @@ static int setup_msi_irq(struct pci_dev
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_desc(irq);
+		struct irq_desc *desc = to_irq_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3469,7 +3469,7 @@ static void dmar_msi_set_affinity(unsign
 
 	dmar_msi_write(irq, &msg);
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -3541,7 +3541,7 @@ static void set_ht_irq_affinity(unsigned
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -235,7 +235,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 
 	overflow = check_stack_overflow();
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (unlikely(!desc)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
 					__func__, irq, vector, smp_processor_id());
@@ -284,7 +284,7 @@ int show_interrupts(struct seq_file *p,
 	if (i == nr_irqs)
 		tail = 1;
 	else
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 #endif
 
 	if (i == 0) {
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -89,7 +89,7 @@ int show_interrupts(struct seq_file *p,
 	if (i == nr_irqs)
 		tail = 1;
 	else
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 #endif
 
 	if (i == 0) {
@@ -223,7 +223,7 @@ asmlinkage unsigned int do_IRQ(struct pt
 	stack_overflow_check(regs);
 #endif
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (likely(desc))
 		generic_handle_irq_desc(irq, desc);
 	else {
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -70,7 +70,7 @@ void __init init_ISA_irqs (void)
 	 */
 	for (i = 0; i < 16; i++) {
 		/* first time call this irq_desc */
-		struct irq_desc *desc = irq_desc_with_new(i);
+		struct irq_desc *desc = to_irq_desc_with_new(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = NULL;
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -144,7 +144,7 @@ static void __init init_ISA_irqs (void)
 
 	for (i = 0; i < 16; i++) {
 		/* first time call this irq_desc */
-		struct irq_desc *desc = irq_desc_with_new(i);
+		struct irq_desc *desc = to_irq_desc_with_new(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = NULL;
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -484,7 +484,7 @@ static void disable_cobalt_irq(unsigned
 static unsigned int startup_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
@@ -507,7 +507,7 @@ static void ack_cobalt_irq(unsigned int
 static void end_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
@@ -628,7 +628,7 @@ static irqreturn_t piix4_master_intr(int
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	desc = irq_desc(realirq);
+	desc = to_irq_desc(realirq);
 
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
@@ -664,7 +664,7 @@ void init_VISWS_APIC_irqs(void)
 	int i;
 
 	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = 0;
Index: linux-2.6/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6/arch/x86/mach-voyager/voyager_smp.c
@@ -1481,7 +1481,7 @@ static void disable_local_vic_irq(unsign
  * the interrupt off to another CPU */
 static void before_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc(irq);
+	irq_desc_t *desc = to_irq_desc(irq);
 	__u8 cpu = smp_processor_id();
 
 	_raw_spin_lock(&vic_irq_lock);
@@ -1516,7 +1516,7 @@ static void before_handle_vic_irq(unsign
 /* Finish the VIC interrupt: basically mask */
 static void after_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc(irq);
+	irq_desc_t *desc = to_irq_desc(irq);
 
 	_raw_spin_lock(&vic_irq_lock);
 	{
Index: linux-2.6/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/irq.c
+++ linux-2.6/arch/xtensa/kernel/irq.c
@@ -44,7 +44,7 @@ void ack_bad_irq(unsigned int irq)
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc + irq;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -90,10 +90,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -103,7 +101,7 @@ int show_interrupts(struct seq_file *p,
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", desc->chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -111,7 +109,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -588,7 +588,7 @@ static struct timer_rand_state *get_time
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 
 	if (!desc)
 		return NULL;
@@ -600,7 +600,7 @@ static void set_timer_rand_state(unsigne
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 
 	if (!desc)
 		return;
Index: linux-2.6/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -1058,7 +1058,7 @@ static void gpiolib_dbg_show(struct seq_
 
 		if (!is_out) {
 			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_desc(irq);
+			struct irq_desc	*desc = to_irq_desc(irq);
 
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
-					desc = irq_desc(irqnr);
+					desc = to_irq_desc(irqnr);
 					desc->handle_irq(irqnr, desc);
 					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
@@ -137,7 +137,7 @@ static void asic3_irq_demux(unsigned int
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc(asic->irq_base + i);
+				desc = to_irq_desc(asic->irq_base + i);
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
-		desc = irq_desc(irq);
+		desc = to_irq_desc(irq);
 		desc->handle_irq(irq, desc);
 	}
 }
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -298,7 +298,7 @@ struct pci_port_ops dino_port_ops = {
 
 static void dino_disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
@@ -311,7 +311,7 @@ static void dino_disable_irq(unsigned in
 
 static void dino_enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
@@ -389,7 +389,7 @@ ilr_again:
 	do {
 		int local_irq = __ffs(mask);
 		int irq = dino_dev->global_irq[local_irq];
-		struct irq_desc *desc = irq_desc(irq);
+		struct irq_desc *desc = to_irq_desc(irq);
 		DBG(KERN_DEBUG "%s(%d, %p) mask 0x%x\n",
 			__func__, irq, intr_dev, mask);
 		__do_IRQ(irq, desc);
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -234,7 +234,7 @@ static irqreturn_t eisa_irq(int wax_irq,
 	}
 	spin_unlock_irqrestore(&eisa_irq_lock, flags);
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	__do_IRQ(irq, desc);
    
 	spin_lock_irqsave(&eisa_irq_lock, flags);
@@ -348,10 +348,10 @@ static int __init eisa_probe(struct pari
 	}
 	
 	/* Reserve IRQ2 */
-	irq_desc(2)->action = &irq2_action;
+	to_irq_desc(2)->action = &irq2_action;
 	
 	for (i = 0; i < 16; i++) {
-		irq_desc(i)->chip = &eisa_interrupt_type;
+		to_irq_desc(i)->chip = &eisa_interrupt_type;
 	}
 	
 	EISA_bus = 1;
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -87,7 +87,7 @@ irqreturn_t gsc_asic_intr(int gsc_asic_i
 	do {
 		int local_irq = __ffs(irr);
 		unsigned int irq = gsc_asic->global_irq[local_irq];
-		struct irq_desc *desc = irq_desc(irq);
+		struct irq_desc *desc = to_irq_desc(irq);
 		__do_IRQ(irq, desc);
 		irr &= ~(1 << local_irq);
 	} while (irr);
@@ -109,7 +109,7 @@ int gsc_find_local_irq(unsigned int irq,
 
 static void gsc_asic_disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -125,7 +125,7 @@ static void gsc_asic_disable_irq(unsigne
 
 static void gsc_asic_enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -167,7 +167,7 @@ int gsc_assign_irq(struct hw_interrupt_t
 	if (irq > GSC_IRQ_MAX)
 		return NO_IRQ;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->chip = type;
 	desc->chip_data = data;
 	return irq++;
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -619,7 +619,7 @@ iosapic_set_irt_data( struct vector_info
 
 static struct vector_info *iosapic_get_vector(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	return desc->chip_data;
 }
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -140,7 +140,7 @@ superio_interrupt(int parent_irq, void *
 	}
 
 	/* Call the appropriate device's interrupt */
-	desc = irq_desc(local_irq);
+	desc = to_irq_desc(local_irq);
 	__do_IRQ(local_irq, desc);
 
 	/* set EOI - forces a new interrupt if a lower priority device
@@ -365,7 +365,7 @@ int superio_fixup_irq(struct pci_dev *pc
 #endif
 
 	for (i = 0; i < 16; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 
 		desc->chip = &superio_interrupt_type;
 	}
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -64,7 +64,7 @@ static struct irq_2_iommu *irq_2_iommu(u
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 
 	BUG_ON(!desc);
 
@@ -76,7 +76,7 @@ static struct irq_2_iommu *irq_2_iommu_w
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 
 	BUG_ON(!desc);
 
Index: linux-2.6/drivers/pcmcia/hd64465_ss.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/hd64465_ss.c
+++ linux-2.6/drivers/pcmcia/hd64465_ss.c
@@ -241,7 +241,7 @@ static void hs_map_irq(hs_socket_t *sp,
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
     	hs_mapped_irq[irq].sock = sp;
 	/* insert ourselves as the irq controller */
 	hs_mapped_irq[irq].old_handler = desc->chip;
@@ -261,7 +261,7 @@ static void hs_unmap_irq(hs_socket_t *sp
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 		
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	/* restore the original irq controller */
 	desc->chip = hs_mapped_irq[irq].old_handler;
 }
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	to_irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -140,7 +140,7 @@ static void init_evtchn_cpu_bindings(voi
 	int i;
 	/* By default all event channels notify CPU#0. */
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 		desc->affinity = cpumask_of_cpu(0);
 	}
 #endif
@@ -640,7 +640,7 @@ static void ack_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
 
-	move_native_irq(irq, irq_desc(irq));
+	move_native_irq(irq, to_irq_desc(irq));
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
Index: linux-2.6/include/asm-mips/irq.h
===================================================================
--- linux-2.6.orig/include/asm-mips/irq.h
+++ linux-2.6/include/asm-mips/irq.h
@@ -65,7 +65,7 @@ extern void smtc_forward_irq(unsigned in
  */
 #define IRQ_AFFINITY_HOOK(irq)						\
 do {									\
-    if (!cpu_isset(smp_processor_id(), irq_desc(irq)->affinity)) {	\
+    if (!cpu_isset(smp_processor_id(), irq_desc[irq].affinity)) {	\
 	smtc_forward_irq(irq);						\
 	irq_exit();							\
 	return;								\
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -194,21 +194,21 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern struct irq_desc *irq_desc(unsigned int irq);
-extern struct irq_desc *irq_desc_with_new(unsigned int irq);
+extern struct irq_desc *to_irq_desc(unsigned int irq);
+extern struct irq_desc *to_irq_desc_with_new(unsigned int irq);
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 
 #ifndef CONFIG_HAVE_DYN_ARRAY
 /* could be removed if we get rid of all irq_desc reference */
-extern struct irq_desc irq_descX[NR_IRQS];
+extern struct irq_desc irq_desc[NR_IRQS];
 #else
-extern struct irq_desc *irq_descX;
+extern struct irq_desc *irq_desc;
 #endif
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 #define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_descX; irq < nr_irqs; irq++, desc = &irq_descX[irq])
+	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc = &irq_desc[irq])
 #endif
 
 #else
@@ -280,7 +280,7 @@ static inline int irq_balancing_disabled
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	return desc->status & IRQ_NO_BALANCING_MASK;
 }
 
@@ -325,7 +325,7 @@ static inline void generic_handle_irq_de
 
 static inline void generic_handle_irq(unsigned int irq)
 {
-	generic_handle_irq_desc(irq, irq_desc(irq));
+	generic_handle_irq_desc(irq, to_irq_desc(irq));
 }
 
 /* Handling of unhandled and spurious interrupts: */
@@ -362,7 +362,7 @@ static inline void __set_irq_handler_unl
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->handle_irq = handler;
 }
 
@@ -397,7 +397,7 @@ extern void destroy_irq(unsigned int irq
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	return desc->action != NULL;
 }
 
@@ -412,10 +412,10 @@ extern int set_irq_chip_data(unsigned in
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
-#define get_irq_chip(irq)	(irq_desc(irq)->chip)
-#define get_irq_chip_data(irq)	(irq_desc(irq)->chip_data)
-#define get_irq_data(irq)	(irq_desc(irq)->handler_data)
-#define get_irq_msi(irq)	(irq_desc(irq)->msi_desc)
+#define get_irq_chip(irq)	(to_irq_desc(irq)->chip)
+#define get_irq_chip_data(irq)	(to_irq_desc(irq)->chip_data)
+#define get_irq_data(irq)	(to_irq_desc(irq)->handler_data)
+#define get_irq_msi(irq)	(to_irq_desc(irq)->msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -39,7 +39,7 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 		if (!desc)
 			continue;
 
@@ -71,7 +71,7 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 		if (!desc)
 			continue;
 
@@ -96,7 +96,7 @@ unsigned long probe_irq_on(void)
 	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 		if (!desc)
 			continue;
 		spin_lock_irq(&desc->lock);
@@ -137,7 +137,7 @@ unsigned int probe_irq_mask(unsigned lon
 
 	mask = 0;
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 		unsigned int status;
 
 		if (!desc)
@@ -182,7 +182,7 @@ int probe_irq_off(unsigned long val)
 	int i, irq_found = 0, nr_irqs = 0;
 
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 		unsigned int status;
 
 		if (!desc)
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -28,7 +28,7 @@ void dynamic_irq_init(unsigned int irq)
 	unsigned long flags;
 
 	/* first time to use this irq_desc */
-	desc = irq_desc_with_new(irq);
+	desc = to_irq_desc_with_new(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
@@ -61,7 +61,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
@@ -93,7 +93,7 @@ int set_irq_chip(unsigned int irq, struc
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
@@ -102,7 +102,7 @@ int set_irq_chip(unsigned int irq, struc
 	if (!chip)
 		chip = &no_irq_chip;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
@@ -123,7 +123,7 @@ int set_irq_type(unsigned int irq, unsig
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
@@ -150,7 +150,7 @@ int set_irq_data(unsigned int irq, void
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
@@ -176,7 +176,7 @@ int set_irq_msi(unsigned int irq, struct
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
@@ -203,7 +203,7 @@ int set_irq_chip_data(unsigned int irq,
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install chip data for IRQ%d\n", irq);
@@ -230,7 +230,7 @@ static void default_enable(unsigned int
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
@@ -249,7 +249,7 @@ static unsigned int default_startup(unsi
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->chip->enable(irq);
 
 	return 0;
@@ -262,7 +262,7 @@ static void default_shutdown(unsigned in
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
@@ -554,7 +554,7 @@ __set_irq_handler(unsigned int irq, irq_
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
@@ -618,7 +618,7 @@ void __init set_irq_noprobe(unsigned int
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
@@ -635,7 +635,7 @@ void __init set_irq_probe(unsigned int i
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -153,7 +153,7 @@ early_param("nr_irq_desc", parse_nr_irq_
 
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
-struct irq_desc *irq_desc(unsigned int irq)
+struct irq_desc *to_irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc;
 
@@ -166,7 +166,7 @@ struct irq_desc *irq_desc(unsigned int i
 	}
 	return NULL;
 }
-struct irq_desc *irq_desc_with_new(unsigned int irq)
+struct irq_desc *to_irq_desc_with_new(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
 	int i;
@@ -245,20 +245,20 @@ struct irq_desc *irq_desc_with_new(unsig
 }
 #else
 
-struct irq_desc *irq_descX;
-DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
 
 #endif
 
 #else
 
-struct irq_desc irq_descX[NR_IRQS] __cacheline_aligned_in_smp = {
+struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
-		.lock = __SPIN_LOCK_UNLOCKED(irq_descX->lock),
+		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
 #ifdef CONFIG_SMP
 		.affinity = CPU_MASK_ALL
 #endif
@@ -268,16 +268,16 @@ struct irq_desc irq_descX[NR_IRQS] __cac
 #endif
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
-struct irq_desc *irq_desc(unsigned int irq)
+struct irq_desc *to_irq_desc(unsigned int irq)
 {
 	if (irq < nr_irqs)
-		return &irq_descX[irq];
+		return &irq_desc[irq];
 
 	return NULL;
 }
-struct irq_desc *irq_desc_with_new(unsigned int irq)
+struct irq_desc *to_irq_desc_with_new(unsigned int irq)
 {
-	return irq_desc(irq);
+	return to_irq_desc(irq);
 }
 #endif
 
@@ -289,7 +289,7 @@ static void ack_bad(unsigned int irq)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
@@ -494,7 +494,7 @@ void early_init_irq_lock_class(void)
 
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	return desc->kstat_irqs[cpu];
 }
 EXPORT_SYMBOL(kstat_irqs_cpu);
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -31,7 +31,7 @@ cpumask_t irq_default_affinity = CPU_MAS
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	unsigned int status;
 
 	if (!desc)
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(synchronize_irq);
  */
 int irq_can_set_affinity(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
 	    !desc->chip->set_affinity)
@@ -81,7 +81,7 @@ int irq_can_set_affinity(unsigned int ir
  */
 int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
@@ -116,7 +116,7 @@ int irq_select_affinity(unsigned int irq
 
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	desc->affinity = mask;
 	desc->chip->set_affinity(irq, mask);
 
@@ -142,7 +142,7 @@ void disable_irq_nosync(unsigned int irq
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -171,7 +171,7 @@ void disable_irq(unsigned int irq)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -215,7 +215,7 @@ void enable_irq(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -227,7 +227,7 @@ EXPORT_SYMBOL(enable_irq);
 
 int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
@@ -250,7 +250,7 @@ int set_irq_wake_real(unsigned int irq,
  */
 int set_irq_wake(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	unsigned long flags;
 	int ret = 0;
 
@@ -293,7 +293,7 @@ int can_request_irq(unsigned int irq, un
 	struct irq_desc *desc;
 	struct irqaction *action;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return 0;
 
@@ -357,7 +357,7 @@ int setup_irq(unsigned int irq, struct i
 	int shared = 0;
 	int ret;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return -EINVAL;
 
@@ -513,7 +513,7 @@ void free_irq(unsigned int irq, void *de
 
 	WARN_ON(in_interrupt());
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -629,7 +629,7 @@ int request_irq(unsigned int irq, irq_ha
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
 
-	desc = irq_desc(irq);
+	desc = to_irq_desc(irq);
 	if (!desc)
 		return -EINVAL;
 
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -3,7 +3,7 @@
 
 void set_pending_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -19,7 +19,7 @@ static struct proc_dir_entry *root_irq_d
 
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_desc((long)m->private);
+	struct irq_desc *desc = to_irq_desc((long)m->private);
 	cpumask_t *mask = &desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -43,7 +43,7 @@ static ssize_t irq_affinity_proc_write(s
 	cpumask_t new_value;
 	int err;
 
-	if (!irq_desc(irq)->chip->set_affinity || no_irq_affinity ||
+	if (!to_irq_desc(irq)->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
@@ -132,7 +132,7 @@ static const struct file_operations defa
 static int irq_spurious_read(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *desc = irq_desc((long) data);
+	struct irq_desc *desc = to_irq_desc((long) data);
 	return sprintf(page, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
@@ -145,7 +145,7 @@ static int irq_spurious_read(char *page,
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 	struct irqaction *action;
 	unsigned long flags;
 	int ret = 1;
@@ -165,7 +165,7 @@ static int name_unique(unsigned int irq,
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
 	char name [MAX_NAMELEN];
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
@@ -214,7 +214,7 @@ void register_irq_proc(unsigned int irq,
 void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 {
 	if (action->dir) {
-		struct irq_desc *desc = irq_desc(irq);
+		struct irq_desc *desc = to_irq_desc(irq);
 		remove_proc_entry(action->dir->name, desc->dir);
 	}
 }
Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c
+++ linux-2.6/kernel/irq/resend.c
@@ -36,7 +36,7 @@ static void resend_irqs(unsigned long ar
 	while (!bitmap_empty(irqs_resend, nr_irqs)) {
 		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
-		desc = irq_desc(irq);
+		desc = to_irq_desc(irq);
 		local_irq_disable();
 		desc->handle_irq(irq, desc);
 		local_irq_enable();
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -97,7 +97,7 @@ static int misrouted_irq(int irq)
 		if (i == irq)	/* Already tried */
 			continue;
 
-		desc = irq_desc(i);
+		desc = to_irq_desc(i);
 		if (try_one_irq(i, desc))
 			ok = 1;
 	}
@@ -109,7 +109,7 @@ static void poll_spurious_irqs(unsigned
 {
 	int i;
 	for (i = 1; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		struct irq_desc *desc = to_irq_desc(i);
 		unsigned int status;
 
 		/* Racy but it doesn't matter */
Index: linux-2.6/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-int.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-int.c
@@ -164,7 +164,7 @@ static void indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_irqs_this_cpu(irq_desc(irq))++;
+	kstat_irqs_this_cpu(&irq_desc[irq])++;
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
Index: linux-2.6/arch/mips/sgi-ip22/ip22-time.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-time.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-time.c
@@ -186,7 +186,7 @@ void indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_irqs_this_cpu(irq_desc(irq))++;
+	kstat_irqs_this_cpu(&irq_desc[irq])++;
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
Index: linux-2.6/arch/mips/sibyte/bcm1480/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/smp.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/smp.c
@@ -180,7 +180,7 @@ void bcm1480_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	irq_desc(K_BCM1480_INT_MBOX_0_0).kstat_irqs[cpu]++;
+	irq_desc[K_BCM1480_INT_MBOX_0_0].kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
Index: linux-2.6/arch/mips/sibyte/sb1250/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/smp.c
+++ linux-2.6/arch/mips/sibyte/sb1250/smp.c
@@ -168,7 +168,7 @@ void sb1250_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	irq_desc(K_INT_MBOX_0)->kstat_irqs[cpu]++;
+	irq_desc[K_INT_MBOX_0].kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
Index: linux-2.6/arch/sparc64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/time.c
+++ linux-2.6/arch/sparc64/kernel/time.c
@@ -943,7 +943,7 @@ void timer_interrupt(int irq, struct pt_
 
 	irq_enter();
 
-	irq_desc(0)->kstat_irqs[0]++;
+	irq_desc[0].kstat_irqs[0]++;
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
