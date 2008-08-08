Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbYHHWEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbYHHWEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762193AbYHHVyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761781AbYHHVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vZg2W47gVh0jLzApboXCOq/u6tWzgWp9IJRtDdS6xAaZibuVFjVdzxUboL949URfZh
         E2Y5EAKnihMGga1Cs1WC/nDGnkEISy9TZAlXmAKpNU0VQFqgsVDYujBSOYsd5U2b6Khr
         KqcLofhh3g3NvvEkBrCgR0EOrvC0qt2eMS2ZY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 26/42] x86_64: use irq_desc() together with dyn_array
Date: Fri,  8 Aug 2008 14:52:32 -0700
Message-Id: <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add CONFIG_HAVE_SPARSE_IRQ to for use condensed array
preallocate 32 irq_desc, and irq_desc() will try to get more.

v2: accrording to Eric, change get_irq_desc() to irq_desc()

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/Kconfig                                    |    4 +
 arch/alpha/kernel/irq.c                         |   19 ++-
 arch/alpha/kernel/irq_alpha.c                   |    5 +-
 arch/alpha/kernel/irq_i8259.c                   |    8 +-
 arch/alpha/kernel/irq_pyxis.c                   |    9 +-
 arch/alpha/kernel/irq_srm.c                     |    9 +-
 arch/alpha/kernel/sys_alcor.c                   |    9 +-
 arch/alpha/kernel/sys_cabriolet.c               |    8 +-
 arch/alpha/kernel/sys_dp264.c                   |    9 +-
 arch/alpha/kernel/sys_eb64p.c                   |    8 +-
 arch/alpha/kernel/sys_eiger.c                   |    7 +-
 arch/alpha/kernel/sys_jensen.c                  |   21 ++--
 arch/alpha/kernel/sys_marvel.c                  |   20 ++-
 arch/alpha/kernel/sys_mikasa.c                  |    8 +-
 arch/alpha/kernel/sys_noritake.c                |    8 +-
 arch/alpha/kernel/sys_rawhide.c                 |    8 +-
 arch/alpha/kernel/sys_rx164.c                   |    8 +-
 arch/alpha/kernel/sys_sable.c                   |    8 +-
 arch/alpha/kernel/sys_takara.c                  |    8 +-
 arch/alpha/kernel/sys_titan.c                   |    8 +-
 arch/alpha/kernel/sys_wildfire.c                |   19 ++--
 arch/arm/common/gic.c                           |    2 +-
 arch/arm/kernel/irq.c                           |   12 +-
 arch/arm/mach-at91/gpio.c                       |    4 +-
 arch/arm/mach-davinci/gpio.c                    |   13 ++-
 arch/arm/mach-ep93xx/core.c                     |    4 +-
 arch/arm/mach-orion5x/irq.c                     |    8 +-
 arch/arm/mach-sa1100/h3600.c                    |   10 +-
 arch/arm/plat-mxc/gpio.c                        |    7 +-
 arch/arm/plat-omap/gpio.c                       |   10 +-
 arch/arm/plat-orion/irq.c                       |    2 +-
 arch/avr32/kernel/irq.c                         |   10 +-
 arch/avr32/mach-at32ap/extint.c                 |    7 +-
 arch/avr32/mach-at32ap/pio.c                    |    2 +-
 arch/blackfin/kernel/irqchip.c                  |    8 +-
 arch/blackfin/kernel/traps.c                    |    8 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c      |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c         |    2 +-
 arch/cris/arch-v10/kernel/irq.c                 |    2 +-
 arch/cris/arch-v32/kernel/irq.c                 |    6 +-
 arch/cris/kernel/irq.c                          |   10 +-
 arch/frv/kernel/irq.c                           |   10 +-
 arch/h8300/kernel/irq.c                         |   22 ++--
 arch/ia64/kernel/iosapic.c                      |   11 +-
 arch/ia64/kernel/irq.c                          |   16 ++-
 arch/ia64/kernel/msi_ia64.c                     |    2 +-
 arch/ia64/sn/kernel/irq.c                       |    2 +-
 arch/ia64/sn/kernel/msi_sn.c                    |    2 +-
 arch/m32r/kernel/irq.c                          |   10 +-
 arch/m32r/platforms/m32104ut/setup.c            |   37 +++---
 arch/m32r/platforms/m32700ut/setup.c            |  133 +++++++++++---------
 arch/m32r/platforms/mappi/setup.c               |   84 ++++++++-----
 arch/m32r/platforms/mappi2/setup.c              |  103 ++++++++++------
 arch/m32r/platforms/mappi3/setup.c              |  103 ++++++++++------
 arch/m32r/platforms/oaks32r/setup.c             |   62 ++++++----
 arch/m32r/platforms/opsput/setup.c              |  149 ++++++++++++++---------
 arch/m32r/platforms/usrv/setup.c                |   92 +++++++++------
 arch/m68knommu/kernel/irq.c                     |   16 ++-
 arch/mips/au1000/common/irq.c                   |    2 +-
 arch/mips/dec/ioasic-irq.c                      |    2 +-
 arch/mips/emma2rh/markeins/irq_markeins.c       |    2 +-
 arch/mips/kernel/irq-gic.c                      |    2 +-
 arch/mips/kernel/irq-msc01.c                    |    2 +-
 arch/mips/kernel/irq.c                          |   10 +-
 arch/mips/kernel/smtc.c                         |    2 +-
 arch/mips/mti-malta/malta-smtc.c                |    2 +-
 arch/mips/sgi-ip32/ip32-irq.c                   |   10 +-
 arch/mips/sibyte/bcm1480/irq.c                  |    2 +-
 arch/mips/sibyte/sb1250/irq.c                   |    2 +-
 arch/mips/sni/a20r.c                            |    2 +-
 arch/mips/sni/pcimt.c                           |    2 +-
 arch/mips/sni/pcit.c                            |    2 +-
 arch/mips/sni/rm200.c                           |    2 +-
 arch/mn10300/kernel/irq.c                       |   12 +-
 arch/parisc/kernel/irq.c                        |   41 ++++---
 arch/powerpc/kernel/irq.c                       |   11 +-
 arch/powerpc/platforms/powermac/pic.c           |    2 +-
 arch/powerpc/platforms/pseries/xics.c           |    4 +-
 arch/powerpc/sysdev/cpm2_pic.c                  |    5 +-
 arch/powerpc/sysdev/mpic.c                      |   16 ++--
 arch/powerpc/sysdev/qe_lib/qe_ic.c              |    2 +-
 arch/sh/boards/cayman/irq.c                     |    4 +-
 arch/sh/boards/dreamcast/irq.c                  |    2 +-
 arch/sh/boards/dreamcast/setup.c                |    2 +-
 arch/sh/boards/renesas/systemh/irq.c            |    4 +-
 arch/sh/boards/se/7206/irq.c                    |    2 +-
 arch/sh/boards/superh/microdev/irq.c            |    4 +-
 arch/sh/cchips/hd6446x/hd64461.c                |    4 +-
 arch/sh/cchips/hd6446x/hd64465/setup.c          |    4 +-
 arch/sh/kernel/cpu/irq/imask.c                  |    4 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c               |    4 +-
 arch/sh/kernel/irq.c                            |   12 +-
 arch/sparc64/kernel/irq.c                       |   31 +++--
 arch/um/kernel/irq.c                            |   29 +++--
 arch/x86/Kconfig                                |    1 +
 arch/x86/kernel/io_apic_32.c                    |   46 +++++--
 arch/x86/kernel/io_apic_64.c                    |   75 ++++++++----
 arch/x86/kernel/irq_32.c                        |   24 ++--
 arch/x86/kernel/irq_64.c                        |   35 +++---
 arch/x86/kernel/irqinit_64.c                    |   10 +-
 arch/x86/kernel/visws_quirks.c                  |   30 +++--
 arch/x86/mach-voyager/voyager_smp.c             |    4 +-
 arch/xtensa/kernel/irq.c                        |   10 +-
 drivers/gpio/gpiolib.c                          |    2 +-
 drivers/mfd/asic3.c                             |    4 +-
 drivers/mfd/htc-egpio.c                         |    2 +-
 drivers/parisc/dino.c                           |    6 +-
 drivers/parisc/eisa.c                           |    4 +-
 drivers/parisc/gsc.c                            |   12 ++-
 drivers/parisc/iosapic.c                        |    4 +-
 drivers/parisc/superio.c                        |    4 +-
 drivers/pcmcia/hd64465_ss.c                     |   12 ++-
 drivers/xen/events.c                            |    8 +-
 include/asm-ia64/hw_irq.h                       |    2 +-
 include/asm-mips/irq.h                          |    2 +-
 include/asm-powerpc/irq.h                       |    2 +-
 include/linux/irq.h                             |   34 ++++--
 kernel/irq/autoprobe.c                          |   10 +-
 kernel/irq/chip.c                               |   32 +++--
 kernel/irq/handle.c                             |  144 +++++++++++++++++++---
 kernel/irq/manage.c                             |   35 +++---
 kernel/irq/migration.c                          |   14 +-
 kernel/irq/proc.c                               |   36 +++---
 kernel/irq/resend.c                             |    2 +-
 kernel/irq/spurious.c                           |    5 +-
 133 files changed, 1271 insertions(+), 795 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index c1f9feb..b367622 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -105,3 +105,7 @@ config HAVE_CLK
 
 config HAVE_DYN_ARRAY
 	def_bool n
+
+config HAVE_SPARSE_IRQ
+	def_bool n
+
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index c626a82..85d7173 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -46,16 +46,19 @@ int irq_select_affinity(unsigned int irq)
 {
 	static int last_cpu;
 	int cpu = last_cpu + 1;
+	struct irq_desc *desc;
 
-	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
+	desc = irq_desc(irq);
+
+	if (!desc->chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
 	while (!cpu_possible(cpu) || !cpu_isset(cpu, irq_default_affinity))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
-	irq_desc[irq].chip->set_affinity(irq, cpumask_of_cpu(cpu));
+	desc->affinity = cpumask_of_cpu(cpu);
+	desc->chip->set_affinity(irq, cpumask_of_cpu(cpu));
 	return 0;
 }
 #endif /* CONFIG_SMP */
@@ -80,8 +83,10 @@ show_interrupts(struct seq_file *p, void *v)
 #endif
 
 	if (irq < ACTUAL_NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[irq].lock, flags);
-		action = irq_desc[irq].action;
+		struct irq_desc *desc = irq_desc(irq);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action) 
 			goto unlock;
 		seq_printf(p, "%3d: ", irq);
@@ -91,7 +96,7 @@ show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[irq]);
 #endif
-		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %c%s",
 			(action->flags & IRQF_DISABLED)?'+':' ',
 			action->name);
@@ -104,7 +109,7 @@ show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (irq == ACTUAL_NR_IRQS) {
 #ifdef CONFIG_SMP
 		seq_puts(p, "IPI: ");
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index e16aeb6..feddec7 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -240,8 +240,9 @@ static struct hw_interrupt_type rtc_irq_type = {
 void __init
 init_rtc_irq(void)
 {
-	irq_desc[RTC_IRQ].status = IRQ_DISABLED;
-	irq_desc[RTC_IRQ].chip = &rtc_irq_type;
+	struct irq_desc *desc = irq_desc(RTC_IRQ);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &rtc_irq_type;
 	setup_irq(RTC_IRQ, &timer_irqaction);
 }
 
diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
index 9405bee..39ba6f6 100644
--- a/arch/alpha/kernel/irq_i8259.c
+++ b/arch/alpha/kernel/irq_i8259.c
@@ -79,7 +79,7 @@ i8259a_startup_irq(unsigned int irq)
 void
 i8259a_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		i8259a_enable_irq(irq);
 }
 
@@ -107,8 +107,10 @@ init_i8259a_irqs(void)
 	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
 
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].chip = &i8259a_irq_type;
+		struct irq_desc *desc;
+		desc = irq_desc(i);
+		desc->status = IRQ_DISABLED;
+		desc->chip = &i8259a_irq_type;
 	}
 
 	setup_irq(2, &cascade);
diff --git a/arch/alpha/kernel/irq_pyxis.c b/arch/alpha/kernel/irq_pyxis.c
index d53edbc..8fa2440 100644
--- a/arch/alpha/kernel/irq_pyxis.c
+++ b/arch/alpha/kernel/irq_pyxis.c
@@ -50,7 +50,7 @@ pyxis_startup_irq(unsigned int irq)
 static void
 pyxis_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		pyxis_enable_irq(irq);
 }
 
@@ -117,10 +117,13 @@ init_pyxis_irqs(unsigned long ignore_mask)
 	*(vuip) CIA_IACK_SC;
 
 	for (i = 16; i < 48; ++i) {
+		struct irq_desc *desc;
+
 		if ((ignore_mask >> i) & 1)
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &pyxis_irq_type;
+		desc = irq_desc(i);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &pyxis_irq_type;
 	}
 
 	setup_irq(16+7, &isa_cascade_irqaction);
diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index 3221201..bceac72 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -43,7 +43,7 @@ srm_startup_irq(unsigned int irq)
 static void
 srm_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		srm_enable_irq(irq);
 }
 
@@ -64,10 +64,13 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 	long i;
 
 	for (i = 16; i < max; ++i) {
+		struct irq_desc *desc;
+
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &srm_irq_type;
+		desc = irq_desc(i);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &srm_irq_type;
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index e53a1e1..31dab12 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -85,7 +85,7 @@ alcor_isa_mask_and_ack_irq(unsigned int irq)
 static void
 alcor_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		alcor_enable_irq(irq);
 }
 
@@ -137,13 +137,16 @@ alcor_init_irq(void)
 	*(vuip)GRU_INT_CLEAR = 0; mb();			/* all clear */
 
 	for (i = 16; i < 48; ++i) {
+		struct irq_desc *desc;
+
 		/* On Alcor, at least, lines 20..30 are not connected
 		   and can generate spurious interrupts if we turn them
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &alcor_irq_type;
+		desc = irq_desc(i);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &alcor_irq_type;
 	}
 	i8259a_irq_type.ack = alcor_isa_mask_and_ack_irq;
 
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index ace475c..71c25d5 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -67,7 +67,7 @@ cabriolet_startup_irq(unsigned int irq)
 static void
 cabriolet_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		cabriolet_enable_irq(irq);
 }
 
@@ -122,8 +122,10 @@ common_init_irq(void (*srm_dev_int)(unsigned long v))
 		outb(0xff, 0x806);
 
 		for (i = 16; i < 35; ++i) {
-			irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-			irq_desc[i].chip = &cabriolet_irq_type;
+			struct irq_desc *desc = irq_desc(i);
+
+			desc->status = IRQ_DISABLED | IRQ_LEVEL;
+			desc->chip = &cabriolet_irq_type;
 		}
 	}
 
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index c71b0fd..5cbd892 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -125,7 +125,7 @@ dp264_startup_irq(unsigned int irq)
 static void
 dp264_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		dp264_enable_irq(irq);
 }
 
@@ -157,7 +157,7 @@ clipper_startup_irq(unsigned int irq)
 static void
 clipper_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		clipper_enable_irq(irq);
 }
 
@@ -298,8 +298,9 @@ init_tsunami_irqs(struct hw_interrupt_type * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = ops;
+		struct irq_desc *desc = irq_desc(i);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = ops;
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index 9c5a306..ca0b1ce 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -65,7 +65,7 @@ eb64p_startup_irq(unsigned int irq)
 static void
 eb64p_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eb64p_enable_irq(irq);
 }
 
@@ -135,8 +135,10 @@ eb64p_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &eb64p_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &eb64p_irq_type;
 	}		
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index 7ef3b6f..48fc15c 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -76,7 +76,7 @@ eiger_startup_irq(unsigned int irq)
 static void
 eiger_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eiger_enable_irq(irq);
 }
 
@@ -153,8 +153,9 @@ eiger_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &eiger_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &eiger_irq_type;
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 2c3de97..1dda32e 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -68,13 +68,16 @@ jensen_local_startup(unsigned int irq)
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
 		i8259a_startup_irq(1);
-	else
+	else {
+		struct irq_desc *desc = irq_desc(irq);
+
 		/*
 		 * For all true local interrupts, set the flag that prevents
 		 * the IPL from being dropped during handler processing.
 		 */
-		if (irq_desc[irq].action)
-			irq_desc[irq].action->flags |= IRQF_DISABLED;
+		if (desc->action)
+			desc->action->flags |= IRQF_DISABLED;
+	}
 	return 0;
 }
 
@@ -158,7 +161,7 @@ jensen_device_interrupt(unsigned long vector)
 	}
 
 	/* If there is no handler yet... */
-	if (irq_desc[irq].action == NULL) {
+	if (irq_desc(irq)->action == NULL) {
 	    /* If it is a local interrupt that cannot be masked... */
 	    if (vector >= 0x900)
 	    {
@@ -206,11 +209,11 @@ jensen_init_irq(void)
 {
 	init_i8259a_irqs();
 
-	irq_desc[1].chip = &jensen_local_irq_type;
-	irq_desc[4].chip = &jensen_local_irq_type;
-	irq_desc[3].chip = &jensen_local_irq_type;
-	irq_desc[7].chip = &jensen_local_irq_type;
-	irq_desc[9].chip = &jensen_local_irq_type;
+	irq_desc(1)->chip = &jensen_local_irq_type;
+	irq_desc(4)->chip = &jensen_local_irq_type;
+	irq_desc(3)->chip = &jensen_local_irq_type;
+	irq_desc(7)->chip = &jensen_local_irq_type;
+	irq_desc(9)->chip = &jensen_local_irq_type;
 
 	common_init_isa_dma();
 }
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 828449c..ce0eb28 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -152,7 +152,7 @@ io7_startup_irq(unsigned int irq)
 static void
 io7_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		io7_enable_irq(irq);
 }
 
@@ -303,8 +303,10 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
-		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[base + i].chip = lsi_ops;
+		struct irq_desc *desc = irq_desc(base + i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = lsi_ops;
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -317,8 +319,10 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
-		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[base + i].chip = msi_ops;
+		struct irq_desc *desc = irq_desc(base + i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = msi_ops;
 	}
 
 	for (i = 0; i < 16; ++i)
@@ -335,8 +339,10 @@ marvel_init_irq(void)
 
 	/* Reserve the legacy irqs.  */
 	for (i = 0; i < 16; ++i) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].chip = &marvel_legacy_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->chip = &marvel_legacy_irq_type;
 	}
 
 	/* Init the io7 irqs.  */
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index 8d3e942..8499125 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -64,7 +64,7 @@ mikasa_startup_irq(unsigned int irq)
 static void
 mikasa_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		mikasa_enable_irq(irq);
 }
 
@@ -115,8 +115,10 @@ mikasa_init_irq(void)
 	mikasa_update_irq_hw(0);
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &mikasa_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &mikasa_irq_type;
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index eb2a1d6..e4d975a 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -69,7 +69,7 @@ noritake_startup_irq(unsigned int irq)
 static void
 noritake_end_irq(unsigned int irq)
 {
-        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+        if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
                 noritake_enable_irq(irq);
 }
 
@@ -144,8 +144,10 @@ noritake_init_irq(void)
 	outw(0, 0x54c);
 
 	for (i = 16; i < 48; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &noritake_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &noritake_irq_type;
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index 672cb2d..26b044c 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -131,7 +131,7 @@ rawhide_startup_irq(unsigned int irq)
 static void
 rawhide_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rawhide_enable_irq(irq);
 }
 
@@ -194,8 +194,10 @@ rawhide_init_irq(void)
 	}
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &rawhide_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &rawhide_irq_type;
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index ce1faa6..1956d74 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -68,7 +68,7 @@ rx164_startup_irq(unsigned int irq)
 static void
 rx164_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rx164_enable_irq(irq);
 }
 
@@ -116,8 +116,10 @@ rx164_init_irq(void)
 
 	rx164_update_irq_hw(0);
 	for (i = 16; i < 40; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &rx164_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &rx164_irq_type;
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index 99a7f19..5873ca1 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -484,7 +484,7 @@ sable_lynx_startup_irq(unsigned int irq)
 static void
 sable_lynx_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		sable_lynx_enable_irq(irq);
 }
 
@@ -535,8 +535,10 @@ sable_lynx_init_irq(int nr_irqs)
 	long i;
 
 	for (i = 0; i < nr_irqs; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &sable_lynx_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->hip = &sable_lynx_irq_type;
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index 9bd9a31..9601b52 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -70,7 +70,7 @@ takara_startup_irq(unsigned int irq)
 static void
 takara_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		takara_enable_irq(irq);
 }
 
@@ -153,8 +153,10 @@ takara_init_irq(void)
 		takara_update_irq_hw(i, -1);
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &takara_irq_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &takara_irq_type;
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 52c91cc..9ee1a50 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -139,7 +139,7 @@ titan_startup_irq(unsigned int irq)
 static void
 titan_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		titan_enable_irq(irq);
 }
 
@@ -187,8 +187,10 @@ init_titan_irqs(struct hw_interrupt_type * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = ops;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = ops;
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index 42c3eed..bdfbd41 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -150,10 +150,10 @@ static void
 wildfire_end_irq(unsigned int irq)
 { 
 #if 0
-	if (!irq_desc[irq].action)
+	if (!irq_desc(irq)->action)
 		printk("got irq %d\n", irq);
 #endif
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		wildfire_enable_irq(irq);
 }
 
@@ -196,17 +196,20 @@ wildfire_init_irq_per_pca(int qbbno, int pcano)
 #endif
 
 	for (i = 0; i < 16; ++i) {
+		struct irq_desc *desc;
 		if (i == 2)
 			continue;
-		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
+		desc = irq_desc(i+irq_bias);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		irq_desc->chip = &wildfire_irq_type;
 	}
 
-	irq_desc[36+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-	irq_desc[36+irq_bias].chip = &wildfire_irq_type;
+	irq_desc(36+irq_bias)->status = IRQ_DISABLED | IRQ_LEVEL;
+	irq_desc(36+irq_bias)->chip = &wildfire_irq_type;
 	for (i = 40; i < 64; ++i) {
-		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
+		struct irq_desc *desc = irq_desc(i+irq_bias);
+		desc->status = IRQ_DISABLED | IRQ_LEVEL;
+		desc->chip = &wildfire_irq_type;
 	}
 
 	setup_irq(32+irq_bias, &isa_enable);	
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 0c89bd3..cf75345 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -117,7 +117,7 @@ static void gic_set_cpu(unsigned int irq, cpumask_t mask_val)
 	u32 val;
 
 	spin_lock(&irq_controller_lock);
-	irq_desc[irq].cpu = cpu;
+	irq_desc(irq)->cpu = cpu;
 	val = readl(reg) & ~(0xff << shift);
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 11dcd52..a542c8d 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -68,22 +68,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
 			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-		seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
+		seq_printf(p, " %10s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 #ifdef CONFIG_ARCH_ACORN
 		show_fiq_list(p, v);
@@ -158,7 +160,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+		irq_desc(irq)->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
 	bad_irq_desc.affinity = CPU_MASK_ALL;
diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index ee4964a..66db024 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -404,7 +404,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		}
 
 		pin = bank->chipbase;
-		gpio = &irq_desc[pin];
+		gpio = irq_desc(pin);
 
 		while (isr) {
 			if (isr & 1) {
@@ -515,7 +515,7 @@ void __init at91_gpio_irq_setup(void)
 		__raw_writel(~0, this->regbase + PIO_IDR);
 
 		for (i = 0, pin = this->chipbase; i < 32; i++, pin++) {
-			lockdep_set_class(&irq_desc[pin].lock, &gpio_lock_class);
+			lockdep_set_class(&irq_desc(pin)->lock, &gpio_lock_class);
 
 			/*
 			 * Can use the "simple" and not "edge" handler since it's
diff --git a/arch/arm/mach-davinci/gpio.c b/arch/arm/mach-davinci/gpio.c
index 9c67886..0eb53dc 100644
--- a/arch/arm/mach-davinci/gpio.c
+++ b/arch/arm/mach-davinci/gpio.c
@@ -155,10 +155,11 @@ static void gpio_irq_enable(unsigned irq)
 {
 	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
 	u32 mask = __gpio_mask(irq_to_gpio(irq));
+	struct irq_desc *desc = irq_desc(irq);
 
-	if (irq_desc[irq].status & IRQ_TYPE_EDGE_FALLING)
+	if (desc->status & IRQ_TYPE_EDGE_FALLING)
 		__raw_writel(mask, &g->set_falling);
-	if (irq_desc[irq].status & IRQ_TYPE_EDGE_RISING)
+	if (desc->status & IRQ_TYPE_EDGE_RISING)
 		__raw_writel(mask, &g->set_rising);
 }
 
@@ -166,12 +167,14 @@ static int gpio_irq_type(unsigned irq, unsigned trigger)
 {
 	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
 	u32 mask = __gpio_mask(irq_to_gpio(irq));
+	struct irq_desc *desc;
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
-	irq_desc[irq].status |= trigger;
+	desc = irq_desc(irq);
+	desc->status &= ~IRQ_TYPE_SENSE_MASK;
+	desc->status |= trigger;
 
 	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
 		     ? &g->set_falling : &g->clr_falling);
@@ -215,7 +218,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 
 		/* now demux them to the right lowlevel handler */
 		n = (int)get_irq_data(irq);
-		gpio = &irq_desc[n];
+		gpio = irq_desc(n);
 		while (status) {
 			res = ffs(status);
 			n += res;
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 5fed576..43fbb85 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -226,7 +226,7 @@ static void ep93xx_gpio_irq_ack(unsigned int irq)
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc[irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+	if ((irq_desc(irq)->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 		ep93xx_gpio_update_int_params(port);
 	}
@@ -240,7 +240,7 @@ static void ep93xx_gpio_irq_mask_ack(unsigned int irq)
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc[irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
+	if ((irq_desc(irq)->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 
 	gpio_int_unmasked[port] &= ~port_mask;
diff --git a/arch/arm/mach-orion5x/irq.c b/arch/arm/mach-orion5x/irq.c
index 9ae3f6d..9c087ad 100644
--- a/arch/arm/mach-orion5x/irq.c
+++ b/arch/arm/mach-orion5x/irq.c
@@ -47,7 +47,7 @@
 static void orion5x_gpio_irq_ack(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_desc(irq)->status & IRQ_LEVEL)
 		/*
 		 * Mask bit for level interrupt
 		 */
@@ -62,7 +62,7 @@ static void orion5x_gpio_irq_ack(u32 irq)
 static void orion5x_gpio_irq_mask(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_desc(irq)->status & IRQ_LEVEL)
 		orion5x_clrbits(GPIO_LEVEL_MASK, 1 << pin);
 	else
 		orion5x_clrbits(GPIO_EDGE_MASK, 1 << pin);
@@ -71,7 +71,7 @@ static void orion5x_gpio_irq_mask(u32 irq)
 static void orion5x_gpio_irq_unmask(u32 irq)
 {
 	int pin = irq_to_gpio(irq);
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_desc(irq)->status & IRQ_LEVEL)
 		orion5x_setbits(GPIO_LEVEL_MASK, 1 << pin);
 	else
 		orion5x_setbits(GPIO_EDGE_MASK, 1 << pin);
@@ -88,7 +88,7 @@ static int orion5x_gpio_set_irq_type(u32 irq, u32 type)
 		return -EINVAL;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
diff --git a/arch/arm/mach-sa1100/h3600.c b/arch/arm/mach-sa1100/h3600.c
index b34ff42..08ace7e 100644
--- a/arch/arm/mach-sa1100/h3600.c
+++ b/arch/arm/mach-sa1100/h3600.c
@@ -822,15 +822,17 @@ static void __init h3800_init_irq(void)
 #if 0
 	for (i = 0; i < H3800_KPIO_IRQ_COUNT; i++) {
 		int irq = i + H3800_KPIO_IRQ_START;
-		irq_desc[irq].valid    = 1;
-		irq_desc[irq].probe_ok = 1;
+		struct irq_desc *desc = irq_desc(irq);
+		desc->valid    = 1;
+		desc->probe_ok = 1;
 		set_irq_chip(irq, &h3800_kpio_irqchip);
 	}
 
 	for (i = 0; i < H3800_GPIO_IRQ_COUNT; i++) {
 		int irq = i + H3800_GPIO_IRQ_START;
-		irq_desc[irq].valid    = 1;
-		irq_desc[irq].probe_ok = 1;
+		struct irq_desc *desc = irq_desc(irq);
+		desc->valid    = 1;
+		desc->probe_ok = 1;
 		set_irq_chip(irq, &h3800_gpio_irqchip);
 	}
 #endif
diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
index 318b268..17f8734 100644
--- a/arch/arm/plat-mxc/gpio.c
+++ b/arch/arm/plat-mxc/gpio.c
@@ -105,13 +105,14 @@ static void mxc_gpio_irq_handler(struct mxc_gpio_port *port, u32 irq_stat)
 
 	gpio_irq_no = port->virtual_irq_start;
 	for (; irq_stat != 0; irq_stat >>= 1, gpio_irq_no++) {
+		struct irq_desc *desc;
 
 		if ((irq_stat & 1) == 0)
 			continue;
 
-		BUG_ON(!(irq_desc[gpio_irq_no].handle_irq));
-		irq_desc[gpio_irq_no].handle_irq(gpio_irq_no,
-				&irq_desc[gpio_irq_no]);
+		desc = irq_desc(gpio_irq_no);
+		BUG_ON(!(desc->handle_irq));
+		desc->handle_irq(gpio_irq_no, desc);
 	}
 }
 
diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 63e0943..4e4ec0b 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -648,8 +648,10 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
 	if (retval == 0) {
-		irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
-		irq_desc[irq].status |= type;
+		struct irq_desc *desc = irq_desc(irq);
+
+		desc->status &= ~IRQ_TYPE_SENSE_MASK;
+		desc->status |= type;
 	}
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -1503,7 +1505,7 @@ static int __init _omap_gpio_init(void)
 
 		for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + gpio_count; j++) {
-			lockdep_set_class(&irq_desc[j].lock, &gpio_lock_class);
+			lockdep_set_class(&irq_desc(j)->lock, &gpio_lock_class);
 			set_irq_chip_data(j, bank);
 			if (bank_is_mpuio(bank))
 				set_irq_chip(j, &mpuio_irq_chip);
@@ -1818,7 +1820,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 
 /* FIXME for at least omap2, show pullup/pulldown state */
 
-			irqstat = irq_desc[irq].status;
+			irqstat = irq_desc(irq)->status;
 			if (is_in && ((bank->suspend_wakeup & mask)
 					|| irqstat & IRQ_TYPE_SENSE_MASK)) {
 				char	*trigger = NULL;
diff --git a/arch/arm/plat-orion/irq.c b/arch/arm/plat-orion/irq.c
index fe66a18..01007f8 100644
--- a/arch/arm/plat-orion/irq.c
+++ b/arch/arm/plat-orion/irq.c
@@ -59,7 +59,7 @@ void __init orion_irq_init(unsigned int irq_start, void __iomem *maskaddr)
 		set_irq_chip(irq, &orion_irq_chip);
 		set_irq_chip_data(irq, maskaddr);
 		set_irq_handler(irq, handle_level_irq);
-		irq_desc[irq].status |= IRQ_LEVEL;
+		irq_desc(irq)->status |= IRQ_LEVEL;
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index a8e767d..28d5d03 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -51,22 +51,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
 			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+		seq_printf(p, " %8s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 	unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	return 0;
diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index c36a6d5..a98eb7a 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -88,7 +88,6 @@ static void eic_unmask_irq(unsigned int irq)
 static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 {
 	struct eic *eic = get_irq_chip_data(irq);
-	struct irq_desc *desc;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
 	int ret = 0;
@@ -97,8 +96,6 @@ static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	desc = &irq_desc[irq];
-
 	mode = eic_readl(eic, MODE);
 	edge = eic_readl(eic, EDGE);
 	level = eic_readl(eic, LEVEL);
@@ -126,6 +123,10 @@ static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 	}
 
 	if (ret == 0) {
+		struct irq_desc *desc;
+
+		desc = irq_desc(irq);
+
 		eic_writel(eic, MODE, mode);
 		eic_writel(eic, EDGE, edge);
 		eic_writel(eic, LEVEL, level);
diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 296294f..79bb503 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -262,7 +262,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			isr &= ~(1 << i);
 
 			i += gpio_irq;
-			d = &irq_desc[i];
+			d = irq_desc(i);
 
 			d->handle_irq(i, d);
 		} while (isr);
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 07402f5..62b6caf 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -77,8 +77,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	unsigned long flags;
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
@@ -89,7 +91,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
  unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "Err: %10lu\n", irq_err_count);
 	}
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index ad922ab..28501eb 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -985,8 +985,10 @@ void show_regs(struct pt_regs *fp)
 	/* if no interrupts are going off, don't print this out */
 	if (fp->ipend & ~0x3F) {
 		for (i = 0; i < (NR_IRQS - 1); i++) {
-			spin_lock_irqsave(&irq_desc[i].lock, flags);
-			action = irq_desc[i].action;
+			struct irq_desc *desc = irq_desc(i);
+
+			spin_lock_irqsave(&desc->lock, flags);
+			action = desc->action;
 			if (!action)
 				goto unlock;
 
@@ -998,7 +1000,7 @@ void show_regs(struct pt_regs *fp)
 			}
 			printk("\n");
 unlock:
-			spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
 
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 0b26ae2..08ad8ad 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -989,7 +989,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 689b69c..66e770d 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -1024,7 +1024,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index ed2b0b8..49b02ec 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -418,7 +418,7 @@ static int __init cm_bf533_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 079389c..0b9c3a6 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -426,7 +426,7 @@ static int __init ezkit_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 13ae495..1bb6d18 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -627,7 +627,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 73f2142..999af68 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -521,7 +521,7 @@ static int __init cm_bf537_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 01b63e2..6f57f09 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -733,7 +733,7 @@ static int __init stamp_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 6dbc76f..555b68f 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1026,7 +1026,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 
 	return 0;
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 466ef59..54ce4cc 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -411,7 +411,7 @@ static int __init cm_bf561_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index bc6fede..8cdc0ad 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -540,7 +540,7 @@ static int __init ezkit_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/irq.c
index 65ed803..a5e6e8c 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -221,7 +221,7 @@ init_IRQ(void)
 
 	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
-		irq_desc[i].chip = &crisv10_irq_type;
+		irq_desc(i)->chip = &crisv10_irq_type;
 		set_int_vector(i, interrupt[i]);
 	}
 
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 173c141..5b45bac 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -475,15 +475,15 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		irq_desc[j].chip = &crisv32_irq_type;
+		irq_desc(j)->chip = &crisv32_irq_type;
 		set_exception_vector(i, interrupt[j]);
 	}
 
         /* Mark Timer and IPI IRQs as CPU local */
 	irq_allocations[TIMER0_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc[TIMER0_INTR_VECT].status |= IRQ_PER_CPU;
+	irq_desc(TIMER0_INTR_VECT)->status |= IRQ_PER_CPU;
 	irq_allocations[IPI_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc[IPI_INTR_VECT].status |= IRQ_PER_CPU;
+	irq_desc(IPI_INTR_VECT)->status |= IRQ_PER_CPU;
 
 	set_exception_vector(0x00, nmi_interrupt);
 	set_exception_vector(0x30, multiple_interrupt);
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 2dfac8c..b280e0a 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -57,8 +57,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -68,7 +70,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -76,7 +78,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 73abae7..4770219 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -69,13 +69,15 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
 				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-			seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
+			seq_printf(p, " %10s", desc->chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
 			     action;
@@ -85,7 +87,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "Err: %10u\n", atomic_read(&irq_err_count));
 	}
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index ef4f004..6c2e213 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -166,10 +166,12 @@ void __init init_IRQ(void)
 	setup_vector();
 
 	for (c = 0; c < NR_IRQS; c++) {
-		irq_desc[c].status = IRQ_DISABLED;
-		irq_desc[c].action = NULL;
-		irq_desc[c].depth = 1;
-		irq_desc[c].chip = &h8300irq_chip;
+		struct irq_desc *desc = irq_desc(c);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+		desc->chip = &h8300irq_chip;
 	}
 }
 
@@ -191,21 +193,23 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_puts(p, "           CPU0");
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %14s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 3bc2fa6..d373290 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -398,7 +398,7 @@ iosapic_end_level_irq (unsigned int irq)
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_irq(irq);
 	}
@@ -765,6 +765,7 @@ iosapic_register_intr (unsigned int gsi,
 	struct iosapic_rte_info *rte;
 	u32 low32;
 	unsigned char dmode;
+	struct irq_desc *desc;
 
 	/*
 	 * If this GSI has already been registered (i.e., it's a
@@ -792,12 +793,14 @@ iosapic_register_intr (unsigned int gsi,
 			goto unlock_iosapic_lock;
 	}
 
-	spin_lock(&irq_desc[irq].lock);
+	desc = irq_desc(irq);
+
+	spin_lock(&desc->lock);
 	dest = get_target_cpu(gsi, irq);
 	dmode = choose_dmode();
 	err = register_intr(gsi, irq, dmode, polarity, trigger);
 	if (err < 0) {
-		spin_unlock(&irq_desc[irq].lock);
+		spin_unlock(&desc->lock);
 		irq = err;
 		goto unlock_iosapic_lock;
 	}
@@ -816,7 +819,7 @@ iosapic_register_intr (unsigned int gsi,
 	       (polarity == IOSAPIC_POL_HIGH ? "high" : "low"),
 	       cpu_logical_id(dest), dest, irq_to_vector(irq));
 
-	spin_unlock(&irq_desc[irq].lock);
+	spin_unlock(&desc->lock);
  unlock_iosapic_lock:
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 	return irq;
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 7fd18f5..b9290c6 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -71,8 +71,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -83,7 +85,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 		}
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", desc->chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -91,7 +93,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS)
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	return 0;
@@ -107,7 +109,7 @@ void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 	cpu_set(cpu_logical_id(hwid), mask);
 
 	if (irq < NR_IRQS) {
-		irq_desc[irq].affinity = mask;
+		irq_desc(irq)->affinity = mask;
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
@@ -138,7 +140,7 @@ static void migrate_irqs(void)
 	int 		irq, new_cpu;
 
 	for (irq=0; irq < NR_IRQS; irq++) {
-		desc = irq_desc + irq;
+		desc = irq_desc(irq);
 
 		if (desc->status == IRQ_DISABLED)
 			continue;
@@ -152,7 +154,7 @@ static void migrate_irqs(void)
 		if (desc->status == IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, cpu_online_map);
+		cpus_and(mask, desc->affinity, cpu_online_map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			/*
 			 * Save it for phase 2 processing
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 60c6ef6..8199eb2 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -73,7 +73,7 @@ static void ia64_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 96c31b4..98d4d83 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -429,7 +429,7 @@ sn_call_force_intr_provider(struct sn_irq_info *sn_irq_info)
 	pci_provider = sn_pci_provider[sn_irq_info->irq_bridge_type];
 
 	/* Don't force an interrupt if the irq has been disabled */
-	if (!(irq_desc[sn_irq_info->irq_irq].status & IRQ_DISABLED) &&
+	if (!(irq_desc(sn_irq_info->irq_irq)->status & IRQ_DISABLED) &&
 	    pci_provider && pci_provider->force_interrupt)
 		(*pci_provider->force_interrupt)(sn_irq_info);
 }
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 83f190f..51f66d8 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -204,7 +204,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = cpu_mask;
+	irq_desc(irq)->affinity = cpu_mask;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index d0c5b0b..d9c2a00 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -43,8 +43,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -54,7 +56,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -62,7 +64,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 98138b4..b923269 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -77,6 +77,7 @@ static struct hw_interrupt_type m32104ut_irq_type =
 void __init init_IRQ(void)
 {
 	static int once = 0;
+	struct irq_desc *desc;
 
 	if (once)
 		return;
@@ -85,36 +86,40 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	desc = irq_desc(M32R_IRQ_INT0);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32104ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11; /* "H" level sense */
 	disable_m32104ut_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	desc = irq_desc(M32R_IRQ_MFT2);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32104ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO0_R);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32104ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO0_S);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32104ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 77b0ae9..c82e44d 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -297,103 +297,117 @@ static struct hw_interrupt_type m32700ut_lcdpld_irq_type =
 
 void __init init_IRQ(void)
 {
+	struct irq_desc *desc;
+
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	irq_desc[M32700UT_LAN_IRQ_LAN].status = IRQ_DISABLED;
-	irq_desc[M32700UT_LAN_IRQ_LAN].chip = &m32700ut_lanpld_irq_type;
-	irq_desc[M32700UT_LAN_IRQ_LAN].action = 0;
-	irq_desc[M32700UT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
+	desc = irq_desc(M32700UT_LAN_IRQ_LAN);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	desc = irq_desc(M32R_IRQ_MFT2);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32700ut_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO0_R);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO0_S);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO1_R);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	desc = irq_desc(M32R_IRQ_SIO1_S);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_DMA1].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_DMA1].action = 0;
-	irq_desc[M32R_IRQ_DMA1].depth = 1;
+	desc = irq_desc(M32R_IRQ_DMA1)
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_RCV].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
-	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
+	desc = irq_desc(PLD_IRQ_SIO0_RCV);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_SND].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
-	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
+	desc = irq_desc(PLD_IRQ_SIO0_SND);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	desc = irq_desc(PLD_IRQ_CFIREQ);
+	desc->status = IRQ_DISABLED;
+	desc->hip = &m32700ut_pld_irq_type;
+	desc->ction = 0;
+	desc->epth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	desc = irq_desc(PLD_IRQ_CFC_INSERT);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	desc = irq_desc(PLD_IRQ_CFC_EJECT);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -413,13 +427,13 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].chip = &m32700ut_lcdpld_irq_type;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].action = 0;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].depth = 1;
-    lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-    disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
+	desc = irq_desc(M32700UT_LCD_IRQ_USB_INT1);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_lcdpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
+	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+	disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -432,10 +446,11 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	desc = irq_desc(M32R_IRQ_INT3);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_m32700ut_irq(M32R_IRQ_INT3);
 #endif	/* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index 3ec087f..5912218 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -45,7 +45,7 @@ static void mask_and_ack_mappi(unsigned int irq)
 
 static void end_mappi_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_mappi_irq(irq);
 }
 
@@ -77,6 +77,8 @@ static struct hw_interrupt_type mappi_irq_type =
 void __init init_IRQ(void)
 {
 	static int once = 0;
+	struct irq_desc *desc;
+	unsigned irq;
 
 	if (once)
 		return;
@@ -85,70 +87,86 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = NULL;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	irq = M32R_IRQ_INT0;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = NULL;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = NULL;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = NULL;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = NULL;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = NULL;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = NULL;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	irq = M32R_IRQ_INT1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	irq_desc[M32R_IRQ_INT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT2].action = NULL;
-	irq_desc[M32R_IRQ_INT2].depth = 1;
+	irq = M32R_IRQ_INT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = NULL;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
 #endif /* CONFIG_M32RPCC */
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index d87969c..0018ef6 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -83,89 +83,112 @@ static struct hw_interrupt_type mappi2_irq_type =
 
 void __init init_IRQ(void)
 {
+	struct irq_desc *desc;
+	unsigned int i;
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+
+	irq = M32R_IRQ_INT0;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = 0;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	irq = M32R_IRQ_INT1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	irq_desc PLD_IRQ_CFIREQ;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFC_INSERT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFC_EJECT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi2_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
 #endif /* CONFIG_MAPPI2_CFC */
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index 785b4bd..80e1f5f 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -83,91 +83,114 @@ static struct hw_interrupt_type mappi3_irq_type =
 
 void __init init_IRQ(void)
 {
+	struct irq_desc *desc;
+	unsigned int irq;
+
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	irq = M32R_IRQ_INT0;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = 0;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	irq = M32R_IRQ_INT1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFIREQ;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFC_INSERT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
 
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	irq_desc[PLD_IRQ_IDEIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_IDEIREQ].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_IDEIREQ].action = 0;
-	irq_desc[PLD_IRQ_IDEIREQ].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_IDEIREQ;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi3_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
 
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index 6faa5db..4fd7f0f 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -75,6 +75,8 @@ static struct hw_interrupt_type oaks32r_irq_type =
 void __init init_IRQ(void)
 {
 	static int once = 0;
+	struct irq_desc *desc;
+	unsigned int irq;
 
 	if (once)
 		return;
@@ -83,52 +85,64 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	irq = M32R_IRQ_INT3;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &oaks32r_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index fab13fd..fc51ee8 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -298,103 +298,130 @@ static struct hw_interrupt_type opsput_lcdpld_irq_type =
 
 void __init init_IRQ(void)
 {
+	struct irq_desc *desc;
+	unsigned int irq;
+
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	irq_desc[OPSPUT_LAN_IRQ_LAN].status = IRQ_DISABLED;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].chip = &opsput_lanpld_irq_type;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].action = 0;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
+	irq = OPSPUT_LAN_IRQ_LAN;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_DMA1].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_DMA1].action = 0;
-	irq_desc[M32R_IRQ_DMA1].depth = 1;
+	irq = M32R_IRQ_DMA1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_RCV].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
-	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_SIO0_RCV;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_SND].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
-	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_SIO0_SND;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFIREQ;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFC_INSERT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_CFC_EJECT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -409,18 +436,20 @@ void __init init_IRQ(void)
 	 * INT1# is used for UART, MMC, CF Controller in FPGA.
 	 * We enable it here.
 	 */
-	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
+	icr_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	enable_opsput_irq(M32R_IRQ_INT1);
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
 
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].chip = &opsput_lcdpld_irq_type;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].action = 0;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].depth = 1;
-    lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-    disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
+	irq = OPSPUT_LCD_IRQ_USB_INT1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
+	lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+	disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -433,10 +462,12 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	irq = M32R_IRQ_INT3;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &opsput_lanpld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;	/* disable nested irq */
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index 89588d6..5eb0e7b 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -149,6 +149,8 @@ void __init init_IRQ(void)
 {
 	static int once = 0;
 	int i;
+	struct irq_desc *desc;
+	unsigned int irq;
 
 	if (once)
 		return;
@@ -156,53 +158,65 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	irq = M32R_IRQ_MFT2;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	irq = M32R_IRQ_SIO0_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	irq = M32R_IRQ_SIO0_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	irq = M32R_IRQ_SIO1_R;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	irq = M32R_IRQ_SIO1_S;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &mappi_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_SERIAL_M32R_SIO */
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		irq_desc[PLD_IRQ_CF0 + i].status = IRQ_DISABLED;
-		irq_desc[PLD_IRQ_CF0 + i].chip = &m32700ut_pld_irq_type;
-		irq_desc[PLD_IRQ_CF0 + i].action = 0;
-		irq_desc[PLD_IRQ_CF0 + i].depth = 1;	/* disable nested irq */
+		irq = PLD_IRQ_CF0 + i;
+		desc = irq_desc(irq);
+		desc->status = IRQ_DISABLED;
+		desc->chip = &m32700ut_pld_irq_type;
+		desc->action = 0;
+		desc->depth = 1;
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
 			= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 		disable_m32700ut_pld_irq(PLD_IRQ_CF0 + i);
@@ -210,19 +224,23 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	irq_desc[PLD_IRQ_UART0].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_UART0].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_UART0].action = 0;
-	irq_desc[PLD_IRQ_UART0].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_UART0;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	irq_desc[PLD_IRQ_UART1].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_UART1].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_UART1].action = 0;
-	irq_desc[PLD_IRQ_UART1].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_UART1;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
@@ -230,10 +248,12 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	irq_desc[PLD_IRQ_SNDINT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SNDINT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SNDINT].action = 0;
-	irq_desc[PLD_IRQ_SNDINT].depth = 1;	/* disable nested irq */
+	irq = PLD_IRQ_SNDINT;
+	desc = irq_desc(irq);
+	desc->status = IRQ_DISABLED;
+	desc->chip = &m32700ut_pld_irq_type;
+	desc->action = 0;
+	desc->depth = 1;
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);
diff --git a/arch/m68knommu/kernel/irq.c b/arch/m68knommu/kernel/irq.c
index bba1bb4..e3d7dcb 100644
--- a/arch/m68knommu/kernel/irq.c
+++ b/arch/m68knommu/kernel/irq.c
@@ -48,10 +48,12 @@ void __init init_IRQ(void)
 	init_vectors();
 
 	for (irq = 0; (irq < NR_IRQS); irq++) {
-		irq_desc[irq].status = IRQ_DISABLED;
-		irq_desc[irq].action = NULL;
-		irq_desc[irq].depth = 1;
-		irq_desc[irq].chip = &m_irq_chip;
+		struct irq_desc *desc = irq_desc(irq);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+		desc->chip = &m_irq_chip;
 	}
 }
 
@@ -64,11 +66,13 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_puts(p, "           CPU0\n");
 
 	if (irq < NR_IRQS) {
-		ap = irq_desc[irq].action;
+		struct irq_desc *desc = irq_desc(irq);
+
+		ap = desc->action;
 		if (ap) {
 			seq_printf(p, "%3d: ", irq);
 			seq_printf(p, "%10u ", kstat_irqs(irq));
-			seq_printf(p, "%14s  ", irq_desc[irq].chip->name);
+			seq_printf(p, "%14s  ", desc->chip->name);
 
 			seq_printf(p, "%s", ap->name);
 			for (ap = ap->next; ap; ap = ap->next)
diff --git a/arch/mips/au1000/common/irq.c b/arch/mips/au1000/common/irq.c
index 40c6cec..da34f64 100644
--- a/arch/mips/au1000/common/irq.c
+++ b/arch/mips/au1000/common/irq.c
@@ -224,7 +224,7 @@ static inline void mask_and_ack_level_irq(unsigned int irq_nr)
 
 static void end_irq(unsigned int irq_nr)
 {
-	if (!(irq_desc[irq_nr].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq_nr)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		local_enable_irq(irq_nr);
 
 #if defined(CONFIG_MIPS_PB1000)
diff --git a/arch/mips/dec/ioasic-irq.c b/arch/mips/dec/ioasic-irq.c
index 3acb133..f063cb0 100644
--- a/arch/mips/dec/ioasic-irq.c
+++ b/arch/mips/dec/ioasic-irq.c
@@ -57,7 +57,7 @@ static inline void ack_ioasic_irq(unsigned int irq)
 
 static inline void end_ioasic_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		unmask_ioasic_irq(irq);
 }
 
diff --git a/arch/mips/emma2rh/markeins/irq_markeins.c b/arch/mips/emma2rh/markeins/irq_markeins.c
index fba5c15..ddf4917 100644
--- a/arch/mips/emma2rh/markeins/irq_markeins.c
+++ b/arch/mips/emma2rh/markeins/irq_markeins.c
@@ -110,7 +110,7 @@ static void emma2rh_gpio_irq_ack(unsigned int irq)
 
 static void emma2rh_gpio_irq_end(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		ll_emma2rh_gpio_irq_enable(irq - emma2rh_gpio_irq_base);
 }
 
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index f0a4bb1..9d5080a 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -187,7 +187,7 @@ static void gic_set_affinity(unsigned int irq, cpumask_t cpumask)
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
 	}
-	irq_desc[irq].affinity = cpumask;
+	irq_desc(irq)->affinity = cpumask;
 	spin_unlock_irqrestore(&gic_lock, flags);
 
 }
diff --git a/arch/mips/kernel/irq-msc01.c b/arch/mips/kernel/irq-msc01.c
index 963c16d..dc581aa 100644
--- a/arch/mips/kernel/irq-msc01.c
+++ b/arch/mips/kernel/irq-msc01.c
@@ -79,7 +79,7 @@ static void edge_mask_and_ack_msc_irq(unsigned int irq)
  */
 static void end_msc_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		unmask_msc_irq(irq);
 }
 
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 6045b9a..3c2e8f0 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -94,8 +94,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -105,7 +107,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", desc->chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -113,7 +115,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_putc(p, '\n');
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index a516286..f19708b 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -663,7 +663,7 @@ void smtc_forward_irq(unsigned int irq)
 	 * and efficiency, we just pick the easiest one to find.
 	 */
 
-	target = first_cpu(irq_desc[irq].affinity);
+	target = first_cpu(irq_desc(irq)->affinity);
 
 	/*
 	 * We depend on the platform code to have correctly processed
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index 5ea705e..972d045 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -138,7 +138,7 @@ void plat_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 		if ((cpu_data[cpu].vpe_id != 0) || !cpu_online(cpu))
 			cpu_clear(cpu, tmask);
 	}
-	irq_desc[irq].affinity = tmask;
+	irq_desc(irq)->affinity = tmask;
 
 	if (cpus_empty(tmask))
 		/*
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index 0d6b666..fbedd1c 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -157,7 +157,7 @@ static void crime_level_mask_and_ack_irq(unsigned int irq)
 
 static void crime_level_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq).status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		crime_enable_irq(irq);
 }
 
@@ -186,7 +186,7 @@ static void crime_edge_mask_and_ack_irq(unsigned int irq)
 
 static void crime_edge_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		crime_enable_irq(irq);
 }
 
@@ -227,7 +227,7 @@ static void disable_macepci_irq(unsigned int irq)
 
 static void end_macepci_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_macepci_irq(irq);
 }
 
@@ -340,7 +340,7 @@ static void mask_and_ack_maceisa_irq(unsigned int irq)
 
 static void end_maceisa_irq(unsigned irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_maceisa_irq(irq);
 }
 
@@ -376,7 +376,7 @@ static void disable_mace_irq(unsigned int irq)
 
 static void end_mace_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_mace_irq(irq);
 }
 
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index db372a0..4f802d1 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -249,7 +249,7 @@ static void ack_bcm1480_irq(unsigned int irq)
 
 static void end_bcm1480_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
 	}
 }
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index eac9065..fd4d58c 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -219,7 +219,7 @@ static void ack_sb1250_irq(unsigned int irq)
 
 static void end_sb1250_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
 	}
 }
diff --git a/arch/mips/sni/a20r.c b/arch/mips/sni/a20r.c
index 3f8cf5e..33018ce 100644
--- a/arch/mips/sni/a20r.c
+++ b/arch/mips/sni/a20r.c
@@ -181,7 +181,7 @@ static inline void mask_a20r_irq(unsigned int irq)
 
 static void end_a20r_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		a20r_ack_hwint();
 		unmask_a20r_irq(irq);
 	}
diff --git a/arch/mips/sni/pcimt.c b/arch/mips/sni/pcimt.c
index 834650f..4689198 100644
--- a/arch/mips/sni/pcimt.c
+++ b/arch/mips/sni/pcimt.c
@@ -209,7 +209,7 @@ void disable_pcimt_irq(unsigned int irq)
 
 static void end_pcimt_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_pcimt_irq(irq);
 }
 
diff --git a/arch/mips/sni/pcit.c b/arch/mips/sni/pcit.c
index e5f12cf..7b000fa 100644
--- a/arch/mips/sni/pcit.c
+++ b/arch/mips/sni/pcit.c
@@ -171,7 +171,7 @@ void disable_pcit_irq(unsigned int irq)
 
 void end_pcit_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_pcit_irq(irq);
 }
 
diff --git a/arch/mips/sni/rm200.c b/arch/mips/sni/rm200.c
index 5310aa7..8490c97 100644
--- a/arch/mips/sni/rm200.c
+++ b/arch/mips/sni/rm200.c
@@ -443,7 +443,7 @@ void disable_rm200_irq(unsigned int irq)
 
 void end_rm200_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_rm200_irq(irq);
 }
 
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 761c434..38c218c 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -125,7 +125,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		if (irq_desc[irq].chip == &no_irq_type)
+		if (irq_desc(irq)->chip == &no_irq_type)
 			set_irq_chip_and_handler(irq, &mn10300_cpu_pic,
 						 handle_edge_irq);
 	unit_init_IRQ();
@@ -183,6 +183,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	int i = *(loff_t *) v, j, cpu;
 	struct irqaction *action;
 	unsigned long flags;
+	struct irq_desc *desc;
 
 	switch (i) {
 		/* display column title bar naming CPUs */
@@ -196,14 +197,15 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		/* display information rows, one per active CPU */
 	case 1 ... NR_IRQS - 1:
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		desc = irq_desc(i);
+		spin_lock_irqsave(&desc->lock, flags);
 
-		action = irq_desc[i].action;
+		action = desc->action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
 				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
+			seq_printf(p, " %14s.%u", desc->chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
 			seq_printf(p, "  %s", action->name);
@@ -216,7 +218,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 		break;
 
 		/* polish off with NMI and error counters */
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 23ef950..e8a3883 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -120,7 +120,7 @@ int cpu_check_affinity(unsigned int irq, cpumask_t *dest)
 	if (CHECK_IRQ_PER_CPU(irq)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
-		irq_desc[irq].affinity = CPU_MASK_ALL;
+		irq_desc(irq)->affinity = CPU_MASK_ALL;
 		return -EINVAL;
 	}
 
@@ -136,7 +136,7 @@ static void cpu_set_affinity_irq(unsigned int irq, cpumask_t dest)
 	if (cpu_check_affinity(irq, &dest))
 		return;
 
-	irq_desc[irq].affinity = dest;
+	irq_desc(irq)->affinity = dest;
 }
 #endif
 
@@ -175,9 +175,10 @@ int show_interrupts(struct seq_file *p, void *v)
 
 	if (i < NR_IRQS) {
 		struct irqaction *action;
+		struct irq_desc *desc = irq_desc(i);
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -188,7 +189,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
 
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 #ifndef PARISC_IRQ_CR16_COUNTS
 		seq_printf(p, "  %s", action->name);
 
@@ -220,7 +221,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
  skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	return 0;
@@ -238,14 +239,16 @@ int show_interrupts(struct seq_file *p, void *v)
 
 int cpu_claim_irq(unsigned int irq, struct irq_chip *type, void *data)
 {
-	if (irq_desc[irq].action)
+	struct irq_desc *desc = irq_desc(irq);
+
+	if (desc->action)
 		return -EBUSY;
-	if (irq_desc[irq].chip != &cpu_interrupt_type)
+	if (desc->chip != &cpu_interrupt_type)
 		return -EBUSY;
 
 	if (type) {
-		irq_desc[irq].chip = type;
-		irq_desc[irq].chip_data = data;
+		desc->chip = type;
+		desc->chip_data = data;
 		cpu_interrupt_type.enable(irq);
 	}
 	return 0;
@@ -295,7 +298,7 @@ int txn_alloc_irq(unsigned int bits_wide)
 unsigned long txn_affinity_addr(unsigned int irq, int cpu)
 {
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
 	return cpu_data[cpu].txn_addr;
@@ -339,6 +342,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 	int irq, cpu = smp_processor_id();
 #ifdef CONFIG_SMP
 	cpumask_t dest;
+	struct irq_desc *desc;
 #endif
 
 	old_regs = set_irq_regs(regs);
@@ -351,8 +355,9 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 	irq = eirr_to_irq(eirr_val);
 
 #ifdef CONFIG_SMP
-	dest = irq_desc[irq].affinity;
-	if (CHECK_IRQ_PER_CPU(irq_desc[irq].status) &&
+	desc = irq_desc(irq);
+	dest = desc->affinity;
+	if (CHECK_IRQ_PER_CPU(desc->status) &&
 	    !cpu_isset(smp_processor_id(), dest)) {
 		int cpu = first_cpu(dest);
 
@@ -393,14 +398,14 @@ static void claim_cpu_irqs(void)
 {
 	int i;
 	for (i = CPU_IRQ_BASE; i <= CPU_IRQ_MAX; i++) {
-		irq_desc[i].chip = &cpu_interrupt_type;
+		irq_desc(i)->chip = &cpu_interrupt_type;
 	}
 
-	irq_desc[TIMER_IRQ].action = &timer_action;
-	irq_desc[TIMER_IRQ].status = IRQ_PER_CPU;
+	irq_desc(TIMER_IRQ)->action = &timer_action;
+	irq_desc(TIMER_IRQ)->status = IRQ_PER_CPU;
 #ifdef CONFIG_SMP
-	irq_desc[IPI_IRQ].action = &ipi_action;
-	irq_desc[IPI_IRQ].status = IRQ_PER_CPU;
+	irq_desc(IPI_IRQ)->action = &ipi_action;
+	irq_desc(IPI_IRQ)->status = IRQ_PER_CPU;
 #endif
 }
 
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 6ac8612..0e14f8c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -244,18 +244,19 @@ void fixup_irqs(cpumask_t map)
 
 	for_each_irq(irq) {
 		cpumask_t mask;
+		struct irq_desc *desc = irq_desc(irq);
 
-		if (irq_desc[irq].status & IRQ_PER_CPU)
+		if (desc->status & IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
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
 
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 6d149ae..c29963d 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -153,7 +153,7 @@ static unsigned int pmac_startup_irq(unsigned int virq)
         int i = src >> 5;
 
   	spin_lock_irqsave(&pmac_pic_lock, flags);
-	if ((irq_desc[virq].status & IRQ_LEVEL) == 0)
+	if ((irq_desc(virq)->status & IRQ_LEVEL) == 0)
 		out_le32(&pmac_irq_hw[i]->ack, bit);
         __set_bit(src, ppc_cached_irq_mask);
         __pmac_set_irq_mask(src, 0);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 0fc830f..29c359a 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -205,7 +205,7 @@ static int get_irq_server(unsigned int virq, unsigned int strict_check)
 {
 	int server;
 	/* For the moment only implement delivery to all cpus or one cpu */
-	cpumask_t cpumask = irq_desc[virq].affinity;
+	cpumask_t cpumask = irq_desc(virq)->affinity;
 	cpumask_t tmp = CPU_MASK_NONE;
 
 	if (! cpu_isset(default_server, cpu_online_map))
@@ -808,7 +808,7 @@ void xics_migrate_irqs_away(void)
 		       virq, cpu);
 
 		/* Reset affinity to all cpus */
-		irq_desc[virq].affinity = CPU_MASK_ALL;
+		irq_desc(virq)->affinity = CPU_MASK_ALL;
 		desc->chip->set_affinity(virq, CPU_MASK_ALL);
 unlock:
 		spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index b16ca3e..f5bc534 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -117,9 +117,10 @@ static void cpm2_end_irq(unsigned int virq)
 {
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
+	struct irq_desc *desc = irq_desc(irq_nr);
 
-	if (!(irq_desc[irq_nr].status & (IRQ_DISABLED|IRQ_INPROGRESS))
-			&& irq_desc[irq_nr].action) {
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS))
+			&& desc->action) {
 
 		bit = irq_to_siubit[irq_nr];
 		word = irq_to_siureg[irq_nr];
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 8e3478c..79e6c10 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -575,7 +575,7 @@ static struct mpic *mpic_find(unsigned int irq, unsigned int *is_ipi)
 	if (irq < NUM_ISA_INTERRUPTS)
 		return NULL;
 
-	mpic = irq_desc[irq].chip_data;
+	mpic = irq_desc(irq)->chip_data;
 
 	if (is_ipi)
 		*is_ipi = (src >= mpic->ipi_vecs[0] &&
@@ -599,14 +599,14 @@ static inline u32 mpic_physmask(u32 cpumask)
 /* Get the mpic structure from the IPI number */
 static inline struct mpic * mpic_from_ipi(unsigned int ipi)
 {
-	return irq_desc[ipi].chip_data;
+	return irq_desc(ipi)->chip_data;
 }
 #endif
 
 /* Get the mpic structure from the irq number */
 static inline struct mpic * mpic_from_irq(unsigned int irq)
 {
-	return irq_desc[irq].chip_data;
+	return irq_desc(irq)->chip_data;
 }
 
 /* Send an EOI */
@@ -697,7 +697,7 @@ static void mpic_unmask_ht_irq(unsigned int irq)
 
 	mpic_unmask_irq(irq);
 
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_desc(irq)->status & IRQ_LEVEL)
 		mpic_ht_end_irq(mpic, src);
 }
 
@@ -707,7 +707,7 @@ static unsigned int mpic_startup_ht_irq(unsigned int irq)
 	unsigned int src = mpic_irq_to_hw(irq);
 
 	mpic_unmask_irq(irq);
-	mpic_startup_ht_interrupt(mpic, src, irq_desc[irq].status);
+	mpic_startup_ht_interrupt(mpic, src, irq_desc(irq)->status);
 
 	return 0;
 }
@@ -717,7 +717,7 @@ static void mpic_shutdown_ht_irq(unsigned int irq)
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
-	mpic_shutdown_ht_interrupt(mpic, src, irq_desc[irq].status);
+	mpic_shutdown_ht_interrupt(mpic, src, irq_desc(irq)->status);
 	mpic_mask_irq(irq);
 }
 
@@ -734,7 +734,7 @@ static void mpic_end_ht_irq(unsigned int irq)
 	 * latched another edge interrupt coming in anyway
 	 */
 
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_desc(irq)->status & IRQ_LEVEL)
 		mpic_ht_end_irq(mpic, src);
 	mpic_eoi(mpic);
 }
@@ -1368,7 +1368,7 @@ void mpic_setup_this_cpu(void)
  	/* let the mpic know we want intrs. default affinity is 0xffffffff
 	 * until changed via /proc. That's how it's done on x86. If we want
 	 * it differently, then we should make sure we also change the default
-	 * values of irq_desc[].affinity in irq.c.
+	 * values of irq_desc()->affinity in irq.c.
  	 */
 	if (distribute_irqs) {
 	 	for (i = 0; i < mpic->num_sources ; i++)
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 63cdf98..4dc97c3 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -189,7 +189,7 @@ static inline void qe_ic_write(volatile __be32  __iomem * base, unsigned int reg
 
 static inline struct qe_ic *qe_ic_from_irq(unsigned int virq)
 {
-	return irq_desc[virq].chip_data;
+	return irq_desc(virq)->chip_data;
 }
 
 #define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
diff --git a/arch/sh/boards/cayman/irq.c b/arch/sh/boards/cayman/irq.c
index 30ec7be..44c8794 100644
--- a/arch/sh/boards/cayman/irq.c
+++ b/arch/sh/boards/cayman/irq.c
@@ -96,7 +96,7 @@ static void ack_cayman_irq(unsigned int irq)
 
 static void end_cayman_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_cayman_irq(irq);
 }
 
@@ -188,7 +188,7 @@ void init_cayman_irq(void)
 	}
 
 	for (i=0; i<NR_EXT_IRQS; i++) {
-		irq_desc[START_EXT_IRQS + i].chip = &cayman_irq_type;
+		irq_desc(START_EXT_IRQS + i)->chip = &cayman_irq_type;
 	}
 
 	/* Setup the SMSC interrupt */
diff --git a/arch/sh/boards/dreamcast/irq.c b/arch/sh/boards/dreamcast/irq.c
index 9d0673a..39674d4 100644
--- a/arch/sh/boards/dreamcast/irq.c
+++ b/arch/sh/boards/dreamcast/irq.c
@@ -86,7 +86,7 @@ static void ack_systemasic_irq(unsigned int irq)
 /* After a IRQ has been ack'd and responded to, it needs to be renabled */
 static void end_systemasic_irq(unsigned int irq)
 {
-        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+        if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
                 enable_systemasic_irq(irq);
 }
 
diff --git a/arch/sh/boards/dreamcast/setup.c b/arch/sh/boards/dreamcast/setup.c
index 2581c8c..0eaf30d 100644
--- a/arch/sh/boards/dreamcast/setup.c
+++ b/arch/sh/boards/dreamcast/setup.c
@@ -47,7 +47,7 @@ static void __init dreamcast_setup(char **cmdline_p)
 
 	/* Assign all virtual IRQs to the System ASIC int. handler */
 	for (i = HW_EVENT_IRQ_BASE; i < HW_EVENT_IRQ_MAX; i++)
-		irq_desc[i].chip = &systemasic_int;
+		irq_desc(i)->chip = &systemasic_int;
 
 	board_time_init = aica_time_init;
 
diff --git a/arch/sh/boards/renesas/systemh/irq.c b/arch/sh/boards/renesas/systemh/irq.c
index 0ba2fe6..dcdbf9f 100644
--- a/arch/sh/boards/renesas/systemh/irq.c
+++ b/arch/sh/boards/renesas/systemh/irq.c
@@ -89,14 +89,14 @@ static void mask_and_ack_systemh(unsigned int irq)
 
 static void end_systemh_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_systemh_irq(irq);
 }
 
 void make_systemh_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc[irq].chip = &systemh_irq_type;
+	irq_desc(irq)->chip = &systemh_irq_type;
 	disable_systemh_irq(irq);
 }
 
diff --git a/arch/sh/boards/se/7206/irq.c b/arch/sh/boards/se/7206/irq.c
index 9d5bfc7..1da14a0 100644
--- a/arch/sh/boards/se/7206/irq.c
+++ b/arch/sh/boards/se/7206/irq.c
@@ -90,7 +90,7 @@ static void eoi_se7206_irq(unsigned int irq)
 {
 	unsigned short sts0,sts1;
 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_se7206_irq(irq);
 	/* FPGA isr clear */
 	sts0 = ctrl_inw(INTSTS0);
diff --git a/arch/sh/boards/superh/microdev/irq.c b/arch/sh/boards/superh/microdev/irq.c
index 4d33507..779ccbb 100644
--- a/arch/sh/boards/superh/microdev/irq.c
+++ b/arch/sh/boards/superh/microdev/irq.c
@@ -134,7 +134,7 @@ static void enable_microdev_irq(unsigned int irq)
 static void __init make_microdev_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc[irq].chip = &microdev_irq_type;
+	irq_desc(irq)->chip = &microdev_irq_type;
 	disable_microdev_irq(irq);
 }
 
@@ -145,7 +145,7 @@ static void mask_and_ack_microdev(unsigned int irq)
 
 static void end_microdev_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_microdev_irq(irq);
 }
 
diff --git a/arch/sh/cchips/hd6446x/hd64461.c b/arch/sh/cchips/hd6446x/hd64461.c
index f1a4a07..c441959 100644
--- a/arch/sh/cchips/hd6446x/hd64461.c
+++ b/arch/sh/cchips/hd6446x/hd64461.c
@@ -48,7 +48,7 @@ static void mask_and_ack_hd64461(unsigned int irq)
 
 static void end_hd64461_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_hd64461_irq(irq);
 }
 
@@ -153,7 +153,7 @@ int __init setup_hd64461(void)
 
 	/*  IRQ 80 -> 95 belongs to HD64461  */
 	for (i = HD64461_IRQBASE; i < HD64461_IRQBASE + 16; i++) {
-		irq_desc[i].chip = &hd64461_irq_type;
+		irq_desc(i)->chip = &hd64461_irq_type;
 	}
 
 	setup_irq(CONFIG_HD64461_IRQ, &irq0);
diff --git a/arch/sh/cchips/hd6446x/hd64465/setup.c b/arch/sh/cchips/hd6446x/hd64465/setup.c
index 9b8820c..0175183 100644
--- a/arch/sh/cchips/hd6446x/hd64465/setup.c
+++ b/arch/sh/cchips/hd6446x/hd64465/setup.c
@@ -50,7 +50,7 @@ static void mask_and_ack_hd64465(unsigned int irq)
 
 static void end_hd64465_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_hd64465_irq(irq);
 }
 
@@ -164,7 +164,7 @@ static int __init setup_hd64465(void)
 	outw(0xffff, HD64465_REG_NIMR);	/* mask all interrupts */
 
 	for (i = 0; i < HD64465_IRQ_NUM ; i++) {
-		irq_desc[HD64465_IRQ_BASE + i].chip = &hd64465_irq_type;
+		irq_desc(HD64465_IRQ_BASE + i)->chip = &hd64465_irq_type;
 	}
 
 	setup_irq(CONFIG_HD64465_IRQ, &irq0);
diff --git a/arch/sh/kernel/cpu/irq/imask.c b/arch/sh/kernel/cpu/irq/imask.c
index 301b505..bc56477 100644
--- a/arch/sh/kernel/cpu/irq/imask.c
+++ b/arch/sh/kernel/cpu/irq/imask.c
@@ -96,7 +96,7 @@ static void mask_and_ack_imask(unsigned int irq)
 
 static void end_imask_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_imask_irq(irq);
 }
 
@@ -108,6 +108,6 @@ static void shutdown_imask_irq(unsigned int irq)
 void make_imask_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc[irq].chip = &imask_irq_type;
+	irq_desc(irq)->chip = &imask_irq_type;
 	enable_irq(irq);
 }
diff --git a/arch/sh/kernel/cpu/irq/intc-sh5.c b/arch/sh/kernel/cpu/irq/intc-sh5.c
index 79baa47..87fbefa 100644
--- a/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ b/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -156,7 +156,7 @@ static void end_intc_irq(unsigned int irq)
 void make_intc_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-	irq_desc[irq].chip = &intc_irq_type;
+	irq_desc(irq)->chip = &intc_irq_type;
 	disable_intc_irq(irq);
 }
 
@@ -196,7 +196,7 @@ void __init plat_irq_setup(void)
 
 	/* Set default: per-line enable/disable, priority driven ack/eoi */
 	for (i = 0; i < NR_INTC_IRQS; i++)
-		irq_desc[i].chip = &intc_irq_type;
+		irq_desc(i)->chip = &intc_irq_type;
 
 
 	/* Disable all interrupts and set all priorities to 0 to avoid trouble */
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index a2a99e4..290befa 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -45,22 +45,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < sh_mv.mv_nr_irqs) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %14s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == sh_mv.mv_nr_irqs)
 		seq_printf(p, "Err: %10u\n", atomic_read(&irq_err_count));
 
diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index c481673..bbed41c 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -176,8 +176,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -187,7 +189,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %9s", irq_desc[i].chip->typename);
+		seq_printf(p, " %9s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -195,7 +197,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }
@@ -247,7 +249,7 @@ struct irq_handler_data {
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc[virt_irq].affinity;
+	cpumask_t mask = irq_desc(virt_irq)->affinity;
 	int cpuid;
 
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
@@ -730,15 +732,16 @@ void fixup_irqs(void)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		unsigned long flags;
-
-		spin_lock_irqsave(&irq_desc[irq].lock, flags);
-		if (irq_desc[irq].action &&
-		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
-			if (irq_desc[irq].chip->set_affinity)
-				irq_desc[irq].chip->set_affinity(irq,
-					irq_desc[irq].affinity);
+		struct irq_desc *desc = irq_desc(irq);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		if (desc->action &&
+		    !(desc->status & IRQ_PER_CPU)) {
+			if (desc->chip->set_affinity)
+				desc->chip->set_affinity(irq,
+					desc->affinity);
 		}
-		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 #endif
@@ -967,5 +970,5 @@ void __init init_IRQ(void)
 			     : "i" (PSTATE_IE)
 			     : "g1");
 
-	irq_desc[0].action = &timer_irq_action;
+	irq_desc(0)->action = &timer_irq_action;
 }
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3d7aad0..2a37d33 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -33,8 +33,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -44,7 +46,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -52,7 +54,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 
@@ -388,17 +390,20 @@ static struct hw_interrupt_type SIGVTALRM_irq_type = {
 void __init init_IRQ(void)
 {
 	int i;
+	struct irq_desc *desc;
 
-	irq_desc[TIMER_IRQ].status = IRQ_DISABLED;
-	irq_desc[TIMER_IRQ].action = NULL;
-	irq_desc[TIMER_IRQ].depth = 1;
-	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
+	desc  = irq_desc(TIMER_IRQ);
+	desc->status = IRQ_DISABLED;
+	desc->action = NULL;
+	desc->depth = 1;
+	desc->chip = &SIGVTALRM_irq_type;
 	enable_irq(TIMER_IRQ);
 	for (i = 1; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-		irq_desc[i].chip = &normal_irq_type;
+		desc = irq_desc(i);
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+		desc->chip = &normal_irq_type;
 		enable_irq(i);
 	}
 }
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d30b101..0d3fb7d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,6 +34,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_DYN_ARRAY
+	select HAVE_SPARSE_IRQ if X86_64
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a0ce64c..942983c 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -345,6 +345,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 	struct irq_pin_list *entry = irq_2_pin + irq;
 	unsigned int apicid_value;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, cpumask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -365,7 +366,8 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 			break;
 		entry = irq_2_pin + entry->next;
 	}
-	irq_desc[irq].affinity = cpumask;
+	desc = irq_desc(irq);
+	desc->affinity = cpumask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -475,10 +477,12 @@ static inline void balance_irq(int cpu, int irq)
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 {
 	int i, j;
+	struct irq_desc *desc;
 
 	for_each_online_cpu(i) {
 		for (j = 0; j < nr_irqs; j++) {
-			if (!irq_desc[j].action)
+			desc = irq_desc(j);
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
+			desc = irq_desc(j);
+			if (!desc->action || irq_balancing_disabled(j))
 				continue;
 			if (package_index == i)
 				IRQ_DELTA(package_index, j) = 0;
@@ -609,7 +615,8 @@ tryanotherirq:
 	selected_irq = -1;
 	for (j = 0; j < nr_irqs; j++) {
 		/* Is this an active IRQ? */
-		if (!irq_desc[j].action)
+		desc = irq_desc(j);
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
+		desc = irq_desc(i);
+		desc->pending_mask = cpumask_of_cpu(0);
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
 
@@ -1258,13 +1267,16 @@ static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
 {
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
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
@@ -2031,6 +2043,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2052,9 +2065,11 @@ static inline void init_IO_APIC_traps(void)
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else
+			else {
+				desc = irq_desc(irq);
 				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
+				desc->chip = &no_irq_chip;
+			}
 		}
 	}
 }
@@ -2093,7 +2108,10 @@ static struct irq_chip lapic_chip __read_mostly = {
 
 static void lapic_register_intr(int irq, int vector)
 {
-	irq_desc[irq].status &= ~IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 	set_intr_gate(vector, interrupt[irq]);
@@ -2560,6 +2578,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	unsigned int dest;
 	cpumask_t tmp;
 	int vector;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2579,7 +2598,8 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2653,6 +2673,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2663,7 +2684,8 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	dest = cpu_mask_to_apicid(mask);
 
 	target_ht_irq(irq, dest);
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 9bcb6c2..9dbd189 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -345,6 +345,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -361,9 +362,10 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
+	desc = irq_desc(irq);
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
+	desc = irq_desc(irq);
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
@@ -1593,10 +1598,10 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
 static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
-	int modify_ioapic_rte = desc->status & IRQ_LEVEL;
+	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 
@@ -1613,6 +1618,8 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
+	desc = irq_desc(irq);
+	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
 		spin_lock_irqsave(&ioapic_lock, flags);
 		__target_IO_APIC_irq(irq, dest, cfg->vector);
@@ -1634,12 +1641,13 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc->affinity = mask;
 }
 
 static int migrate_irq_remapped_level(int irq)
 {
 	int ret = -1;
+	struct irq_desc *desc = irq_desc(irq);
 
 	mask_IO_APIC_irq(irq);
 
@@ -1655,11 +1663,11 @@ static int migrate_irq_remapped_level(int irq)
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
@@ -1671,7 +1679,7 @@ static void ir_irq_migration(struct work_struct *work)
 	int irq;
 
 	for (irq = 0; irq < nr_irqs; irq++) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = irq_desc(irq);
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -1683,8 +1691,7 @@ static void ir_irq_migration(struct work_struct *work)
 				continue;
 			}
 
-			desc->chip->set_affinity(irq,
-					         irq_desc[irq].pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -1695,9 +1702,11 @@ static void ir_irq_migration(struct work_struct *work)
  */
 static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	if (irq_desc[irq].status & IRQ_LEVEL) {
-		irq_desc[irq].status |= IRQ_MOVE_PENDING;
-		irq_desc[irq].pending_mask = mask;
+	struct irq_desc *desc = irq_desc(irq);
+
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		desc->pending_mask = mask;
 		migrate_irq_remapped_level(irq);
 		return;
 	}
@@ -1722,7 +1731,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		if (irq >= nr_irqs)
 			continue;
 
-		desc = irq_desc + irq;
+		desc = irq_desc(irq);
 		cfg = irq_cfg + irq;
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
@@ -1788,7 +1797,7 @@ static void ack_apic_level(unsigned int irq)
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
 	}
@@ -1865,6 +1874,7 @@ static struct irq_chip ir_ioapic_chip __read_mostly = {
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1886,9 +1896,11 @@ static inline void init_IO_APIC_traps(void)
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else
+			else {
+				desc = irq_desc(irq);
 				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
+				desc->chip = &no_irq_chip;
+			}
 		}
 	}
 }
@@ -1923,7 +1935,10 @@ static struct irq_chip lapic_chip __read_mostly = {
 
 static void lapic_register_intr(int irq)
 {
-	irq_desc[irq].status &= ~IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 }
@@ -2399,6 +2414,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2418,7 +2434,8 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -2432,6 +2449,7 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2466,7 +2484,8 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -2540,7 +2559,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = irq_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -2652,6 +2671,7 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2671,7 +2691,8 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2728,6 +2749,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	struct irq_cfg *cfg = irq_cfg + irq;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2740,7 +2762,8 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	irq_desc[irq].affinity = mask;
+	desc = irq_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 0cff2f4..c6750fe 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -224,7 +224,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
 	int overflow, irq = ~regs->orig_ax;
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 
 	if (unlikely((unsigned)irq >= nr_irqs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -273,15 +273,16 @@ int show_interrupts(struct seq_file *p, void *v)
 
 	if (i < nr_irqs) {
 		unsigned any_count = 0;
+		struct irq_desc *desc = irq_desc(i);
 
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
@@ -291,8 +292,8 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -302,7 +303,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
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
+		desc = irq_desc(irq);
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
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index de94c60..5e0a938 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -83,15 +83,16 @@ int show_interrupts(struct seq_file *p, void *v)
 
 	if (i < nr_irqs) {
 		unsigned any_count = 0;
+		struct irq_desc *desc = irq_desc(i);
 
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
@@ -101,8 +102,8 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -111,7 +112,7 @@ int show_interrupts(struct seq_file *p, void *v)
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
 
+		desc = irq_desc(irq);
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
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 48674e6..583db8b 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -143,9 +143,11 @@ static void __init init_ISA_irqs (void)
 	init_8259A(0);
 
 	for (i = 0; i < nr_irqs; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
+		struct irq_desc *desc = irq_desc(i);
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
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 3059eb4..6fa3128 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -486,10 +486,11 @@ static void disable_cobalt_irq(unsigned int irq)
 static unsigned int startup_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if ((irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
-		irq_desc[irq].status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
+	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
+		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
 	enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
@@ -508,9 +509,10 @@ static void ack_cobalt_irq(unsigned int irq)
 static void end_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = irq_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
@@ -628,7 +630,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	desc = irq_desc + realirq;
+	desc = irq_desc(realirq);
 
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
@@ -664,27 +666,29 @@ void init_VISWS_APIC_irqs(void)
 	int i;
 
 	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = 0;
-		irq_desc[i].depth = 1;
+		struct irq_desc *desc = irq_desc(i);
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
 
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index ee0fba0..10840fd 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1481,7 +1481,7 @@ static void disable_local_vic_irq(unsigned int irq)
  * the interrupt off to another CPU */
 static void before_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = irq_desc(irq);
 	__u8 cpu = smp_processor_id();
 
 	_raw_spin_lock(&vic_irq_lock);
@@ -1516,7 +1516,7 @@ static void before_handle_vic_irq(unsigned int irq)
 /* Finish the VIC interrupt: basically mask */
 static void after_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = irq_desc(irq);
 
 	_raw_spin_lock(&vic_irq_lock);
 	{
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index c9ea73b..6f26802 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -90,8 +90,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -101,7 +103,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -109,7 +111,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..8157734 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1058,7 +1058,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 		if (!is_out) {
 			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_desc + irq;
+			struct irq_desc	*desc = irq_desc(irq);
 
 			/* This races with request_irq(), set_irq_type(),
 			 * and set_irq_wake() ... but those are "rare".
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index c6408a6..f612337 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -124,7 +124,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 					irqnr = asic->irq_base +
 						(ASIC3_GPIOS_PER_BANK * bank)
 						+ i;
-					desc = irq_desc + irqnr;
+					desc = irq_desc(irqnr);
 					desc->handle_irq(irqnr, desc);
 					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
@@ -137,7 +137,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc + asic->irq_base + i;
+				desc = irq_desc(asic->irq_base + i);
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index 6be4317..88f99a4 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -112,7 +112,7 @@ static void egpio_handler(unsigned int irq, struct irq_desc *desc)
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
 		irq = ei->irq_start + irqpin;
-		desc = &irq_desc[irq];
+		desc = irq_desc(irq);
 		desc->handle_irq(irq, desc);
 	}
 }
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index fd56128..6bba8e9 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -298,7 +298,8 @@ struct pci_port_ops dino_port_ops = {
 
 static void dino_disable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
 	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
@@ -310,7 +311,8 @@ static void dino_disable_irq(unsigned int irq)
 
 static void dino_enable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
 
diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index 771cef5..feb67d4 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -346,10 +346,10 @@ static int __init eisa_probe(struct parisc_device *dev)
 	}
 	
 	/* Reserve IRQ2 */
-	irq_desc[2].action = &irq2_action;
+	irq_desc(2)->action = &irq2_action;
 	
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &eisa_interrupt_type;
+		irq_desc(i)->chip = &eisa_interrupt_type;
 	}
 	
 	EISA_bus = 1;
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index f7d088b..f714f6a 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -108,7 +108,8 @@ int gsc_find_local_irq(unsigned int irq, int *global_irqs, int limit)
 
 static void gsc_asic_disable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -123,7 +124,8 @@ static void gsc_asic_disable_irq(unsigned int irq)
 
 static void gsc_asic_enable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -159,12 +161,14 @@ static struct hw_interrupt_type gsc_asic_interrupt_type = {
 int gsc_assign_irq(struct hw_interrupt_type *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
+	struct irq_desc *desc;
 
 	if (irq > GSC_IRQ_MAX)
 		return NO_IRQ;
 
-	irq_desc[irq].chip = type;
-	irq_desc[irq].chip_data = data;
+	desc = irq_desc(irq);
+	desc->chip = type;
+	desc->chip_data = data;
 	return irq++;
 }
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 6fb3f79..8928823 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -619,7 +619,9 @@ iosapic_set_irt_data( struct vector_info *vi, u32 *dp0, u32 *dp1)
 
 static struct vector_info *iosapic_get_vector(unsigned int irq)
 {
-	return irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_desc(irq);
+
+	return desc->chip_data;
 }
 
 static void iosapic_disable_irq(unsigned int irq)
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index 1e8d2d1..67e552d 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -363,7 +363,9 @@ int superio_fixup_irq(struct pci_dev *pcidev)
 #endif
 
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &superio_interrupt_type;
+		struct irq_desc *desc = irq_desc(i);
+
+		desc->chip = &superio_interrupt_type;
 	}
 
 	/*
diff --git a/drivers/pcmcia/hd64465_ss.c b/drivers/pcmcia/hd64465_ss.c
index fb2bc1f..b4c9fab 100644
--- a/drivers/pcmcia/hd64465_ss.c
+++ b/drivers/pcmcia/hd64465_ss.c
@@ -234,15 +234,18 @@ static struct hw_interrupt_type hd64465_ss_irq_type = {
  */
 static void hs_map_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_map_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 
+	desc = irq_desc(irq);
     	hs_mapped_irq[irq].sock = sp;
 	/* insert ourselves as the irq controller */
-	hs_mapped_irq[irq].old_handler = irq_desc[irq].chip;
-	irq_desc[irq].chip = &hd64465_ss_irq_type;
+	hs_mapped_irq[irq].old_handler = desc->chip;
+	desc->chip = &hd64465_ss_irq_type;
 }
 
 
@@ -251,13 +254,16 @@ static void hs_map_irq(hs_socket_t *sp, unsigned int irq)
  */
 static void hs_unmap_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_unmap_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 		
+	desc = irq_desc(irq);
 	/* restore the original irq controller */
-	irq_desc[irq].chip = hs_mapped_irq[irq].old_handler;
+	desc->chip = hs_mapped_irq[irq].old_handler;
 }
 
 /*============================================================*/
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 8e329c2..430bd90 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	irq_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -139,8 +139,10 @@ static void init_evtchn_cpu_bindings(void)
 #ifdef CONFIG_SMP
 	int i;
 	/* By default all event channels notify CPU#0. */
-	for (i = 0; i < nr_irqs; i++)
-		irq_desc[i].affinity = cpumask_of_cpu(0);
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = irq_desc(i);
+		desc->affinity = cpumask_of_cpu(0);
+	}
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
diff --git a/include/asm-ia64/hw_irq.h b/include/asm-ia64/hw_irq.h
index 5c99cbc..a38c34b 100644
--- a/include/asm-ia64/hw_irq.h
+++ b/include/asm-ia64/hw_irq.h
@@ -146,7 +146,7 @@ static inline void ia64_native_resend_irq(unsigned int vector)
  * Default implementations for the irq-descriptor API:
  */
 
-extern irq_desc_t irq_desc[NR_IRQS];
+extern irq_desc_t irq_descX[NR_IRQS];
 
 #ifndef CONFIG_IA64_GENERIC
 static inline ia64_vector __ia64_irq_to_vector(int irq)
diff --git a/include/asm-mips/irq.h b/include/asm-mips/irq.h
index a58f0ee..f24b207 100644
--- a/include/asm-mips/irq.h
+++ b/include/asm-mips/irq.h
@@ -65,7 +65,7 @@ extern void smtc_forward_irq(unsigned int irq);
  */
 #define IRQ_AFFINITY_HOOK(irq)						\
 do {									\
-    if (!cpu_isset(smp_processor_id(), irq_desc[irq].affinity)) {	\
+    if (!cpu_isset(smp_processor_id(), irq_desc(irq)->affinity)) {	\
 	smtc_forward_irq(irq);						\
 	irq_exit();							\
 	return;								\
diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
index 1ef8e30..8fd0df1 100644
--- a/include/asm-powerpc/irq.h
+++ b/include/asm-powerpc/irq.h
@@ -17,7 +17,7 @@
 #include <asm/atomic.h>
 
 
-#define get_irq_desc(irq) (&irq_desc[(irq)])
+#define get_irq_desc(irq) (irq_desc(irq))
 
 /* Define a way to iterate across irqs. */
 #define for_each_irq(i) \
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c22e870..4172140 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -154,6 +154,10 @@ struct irq_chip {
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
+	unsigned int		irq;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc		*next;
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -181,10 +185,10 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-#ifdef CONFIG_HAVE_DYN_ARRAY
-extern struct irq_desc *irq_desc;
-#else
-extern struct irq_desc irq_desc[NR_IRQS];
+extern struct irq_desc *irq_desc(unsigned int irq);
+#ifndef CONFIG_HAVE_DYN_ARRAY
+/* could be removed if we get rid of all irq_desc reference */
+extern struct irq_desc irq_descX[NR_IRQS];
 #endif
 
 /*
@@ -251,7 +255,10 @@ extern int no_irq_affinity;
 
 static inline int irq_balancing_disabled(unsigned int irq)
 {
-	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	return desc->status & IRQ_NO_BALANCING_MASK;
 }
 
 /* Handle irq action chains: */
@@ -283,7 +290,7 @@ extern unsigned int __do_IRQ(unsigned int irq);
  */
 static inline void generic_handle_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
@@ -327,7 +334,10 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 static inline void __set_irq_handler_unlocked(int irq,
 					      irq_flow_handler_t handler)
 {
-	irq_desc[irq].handle_irq = handler;
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	desc->handle_irq = handler;
 }
 
 /*
@@ -361,7 +371,7 @@ extern void destroy_irq(unsigned int irq);
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	return desc->action != NULL;
 }
 
@@ -376,10 +386,10 @@ extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
-#define get_irq_chip(irq)	(irq_desc[irq].chip)
-#define get_irq_chip_data(irq)	(irq_desc[irq].chip_data)
-#define get_irq_data(irq)	(irq_desc[irq].handler_data)
-#define get_irq_msi(irq)	(irq_desc[irq].msi_desc)
+#define get_irq_chip(irq)	(irq_desc(irq)->chip)
+#define get_irq_chip_data(irq)	(irq_desc(irq)->chip_data)
+#define get_irq_data(irq)	(irq_desc(irq)->handler_data)
+#define get_irq_msi(irq)	(irq_desc(irq)->msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index c689e98..24e1a39 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -39,7 +39,7 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc + i;
+		desc = irq_desc(i);
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -69,7 +69,7 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
-		desc = irq_desc + i;
+		desc = irq_desc(i);
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -92,7 +92,7 @@ unsigned long probe_irq_on(void)
 	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
-		desc = irq_desc + i;
+		desc = irq_desc(i);
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -131,7 +131,7 @@ unsigned int probe_irq_mask(unsigned long val)
 
 	mask = 0;
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = irq_desc(i);
 		unsigned int status;
 
 		spin_lock_irq(&desc->lock);
@@ -174,7 +174,7 @@ int probe_irq_off(unsigned long val)
 	int i, irq_found = 0, nr_irqs = 0;
 
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = irq_desc(i);
 		unsigned int status;
 
 		spin_lock_irq(&desc->lock);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 20a9307..b79337a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -33,7 +33,7 @@ void dynamic_irq_init(unsigned int irq)
 	}
 
 	/* Ensure we don't have left over values from a previous use of this irq */
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
@@ -65,7 +65,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
@@ -100,7 +100,7 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	if (!chip)
 		chip = &no_irq_chip;
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
@@ -126,7 +126,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 		return -ENODEV;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	if (desc->chip->set_type) {
 		spin_lock_irqsave(&desc->lock, flags);
 		ret = desc->chip->set_type(irq, type);
@@ -154,7 +154,7 @@ int set_irq_data(unsigned int irq, void *data)
 		return -EINVAL;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->handler_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -179,7 +179,7 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
@@ -197,9 +197,10 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
  */
 int set_irq_chip_data(unsigned int irq, void *data)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	unsigned long flags;
 
+	desc = irq_desc(irq);
 	if (irq >= nr_irqs || !desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
@@ -218,8 +219,9 @@ EXPORT_SYMBOL(set_irq_chip_data);
  */
 static void default_enable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = irq_desc(irq);
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
@@ -236,7 +238,10 @@ static void default_disable(unsigned int irq)
  */
 static unsigned int default_startup(unsigned int irq)
 {
-	irq_desc[irq].chip->enable(irq);
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	desc->chip->enable(irq);
 
 	return 0;
 }
@@ -246,8 +251,9 @@ static unsigned int default_startup(unsigned int irq)
  */
 static void default_shutdown(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = irq_desc(irq);
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
@@ -550,7 +556,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 
 	if (!handle)
 		handle = handle_bad_irq;
@@ -615,7 +621,7 @@ void __init set_irq_noprobe(unsigned int irq)
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOPROBE;
@@ -633,7 +639,7 @@ void __init set_irq_probe(unsigned int irq)
 		return;
 	}
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status &= ~IRQ_NOPROBE;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e94eeca..d75c272 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
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
@@ -50,7 +58,8 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 int nr_irqs = NR_IRQS;
 
 #ifdef CONFIG_HAVE_DYN_ARRAY
-static struct irq_desc irq_desc_init __initdata = {
+static struct irq_desc irq_desc_init = {
+	.irq = -1U,
 	.status = IRQ_DISABLED,
 	.chip = &no_irq_chip,
 	.handle_irq = handle_bad_irq,
@@ -61,6 +70,27 @@ static struct irq_desc irq_desc_init __initdata = {
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
+#ifdef CONFIG_HAVE_SPARSE_IRQ
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
@@ -70,26 +100,108 @@ static void __init init_work(void *data)
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
+static struct irq_desc *irq_descX;
+DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
+
+extern int after_bootmem;
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+			     unsigned long align,
+			     unsigned long goal);
+struct irq_desc *irq_desc(unsigned int irq)
+{
+	struct irq_desc *desc, *desc_pri;
+	int i;
+	int count = 0;
+
+	BUG_ON(irq == -1U);
+
+	desc_pri = desc = &irq_descX[0];
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
+#else
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+	int i;
+	struct  irq_desc *desc;
+
+	desc = *da->name;
+
+	for (i = 0; i < *da->nr; i++)
+		init_one_irq_desc(&desc[i]);
+
+}
+static struct irq_desc *irq_descX;
+DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+
+#endif
 
 #else
 
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
+struct irq_desc irq_descX[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
-		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+		.lock = __SPIN_LOCK_UNLOCKED(irq_descX->lock),
 #ifdef CONFIG_SMP
 		.affinity = CPU_MASK_ALL
 #endif
 	}
 };
+
+#endif
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+struct irq_desc *irq_desc(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_descX[irq];
+
+	return NULL;
+}
 #endif
 
 /*
@@ -98,7 +210,10 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
  */
 static void ack_bad(unsigned int irq)
 {
-	print_irq_desc(irq, irq_desc + irq);
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
 
@@ -195,7 +310,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  */
 unsigned int __do_IRQ(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	struct irqaction *action;
 	unsigned int status;
 
@@ -286,19 +401,16 @@ out:
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
-		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
+		lockdep_set_class(&irq_descX[i].lock, &irq_desc_lock_class);
+#endif
 }
-
 #endif
+
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3bd67c8..4a31fc8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -31,7 +31,7 @@ cpumask_t irq_default_affinity = CPU_MASK_ALL;
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	unsigned int status;
 
 	if (irq >= nr_irqs)
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(synchronize_irq);
  */
 int irq_can_set_affinity(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
 	    !desc->chip->set_affinity)
@@ -81,7 +81,7 @@ int irq_can_set_affinity(unsigned int irq)
  */
 int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
@@ -111,14 +111,16 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 int irq_select_affinity(unsigned int irq)
 {
 	cpumask_t mask;
+	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
-	irq_desc[irq].affinity = mask;
-	irq_desc[irq].chip->set_affinity(irq, mask);
+	desc = irq_desc(irq);
+	desc->affinity = mask;
+	desc->chip->set_affinity(irq, mask);
 
 	set_balance_irq_affinity(irq, mask);
 	return 0;
@@ -140,7 +142,7 @@ int irq_select_affinity(unsigned int irq)
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	unsigned long flags;
 
 	if (irq >= nr_irqs)
@@ -169,7 +171,7 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 
 	if (irq >= nr_irqs)
 		return;
@@ -211,7 +213,7 @@ static void __enable_irq(struct irq_desc *desc, unsigned int irq)
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	unsigned long flags;
 
 	if (irq >= nr_irqs)
@@ -225,7 +227,7 @@ EXPORT_SYMBOL(enable_irq);
 
 int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
@@ -248,7 +250,7 @@ int set_irq_wake_real(unsigned int irq, unsigned int on)
  */
 int set_irq_wake(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	unsigned long flags;
 	int ret = 0;
 
@@ -288,12 +290,13 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
+	struct irq_desc *desc = irq_desc(irq);
 	struct irqaction *action;
 
-	if (irq >= nr_irqs || irq_desc[irq].status & IRQ_NOREQUEST)
+	if (irq >= nr_irqs || desc->status & IRQ_NOREQUEST)
 		return 0;
 
-	action = irq_desc[irq].action;
+	action =desc->action;
 	if (action)
 		if (irqflags & action->flags & IRQF_SHARED)
 			action = NULL;
@@ -342,7 +345,7 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
  */
 int setup_irq(unsigned int irq, struct irqaction *new)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
 	unsigned long flags;
@@ -506,7 +509,7 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (irq >= nr_irqs)
 		return;
 
-	desc = irq_desc + irq;
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	p = &desc->action;
 	for (;;) {
@@ -602,6 +605,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 {
 	struct irqaction *action;
 	int retval;
+	struct irq_desc *desc;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -619,7 +623,8 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		return -EINVAL;
 	if (irq >= nr_irqs)
 		return -EINVAL;
-	if (irq_desc[irq].status & IRQ_NOREQUEST)
+	desc = irq_desc(irq);
+	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
 	if (!handler)
 		return -EINVAL;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 77b7acc..62a447c 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -3,18 +3,18 @@
 
 void set_pending_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc(irq);
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
+	struct irq_desc *desc = irq_desc(irq);
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
+	struct irq_desc *desc = irq_desc(irq);
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 74d7922..ffb6000 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -19,7 +19,7 @@ static struct proc_dir_entry *root_irq_dir;
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *desc = irq_desc + (long)data;
+	struct irq_desc *desc = irq_desc((long)data);
 	cpumask_t *mask = &desc->affinity;
 	int len;
 
@@ -45,8 +45,9 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 {
 	unsigned int irq = (int)(long)data, full_count = count, err;
 	cpumask_t new_value;
+	struct irq_desc *desc = irq_desc(irq);
 
-	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
+	if (!desc->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
@@ -112,20 +113,20 @@ static int default_affinity_write(struct file *file, const char __user *buffer,
 static int irq_spurious_read(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *d = &irq_desc[(long) data];
+	struct irq_desc *desc = irq_desc((long) data);
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
+	struct irq_desc *desc = irq_desc(irq);
 	struct irqaction *action;
 	unsigned long flags;
 	int ret = 1;
@@ -145,8 +146,9 @@ static int name_unique(unsigned int irq, struct irqaction *new_action)
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
 	char name [MAX_NAMELEN];
+	struct irq_desc *desc = irq_desc(irq);
 
-	if (!irq_desc[irq].dir || action->dir || !action->name ||
+	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
 		return;
 
@@ -154,7 +156,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
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
+	struct irq_desc *desc = irq_desc(irq);
 
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
+		struct irq_desc *desc = irq_desc(irq);
+		remove_proc_entry(action->dir->name, desc->dir);
+	}
 }
 
 void register_default_affinity_proc(void)
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index cba8aa5..7ecabac 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -36,7 +36,7 @@ static void resend_irqs(unsigned long arg)
 	while (!bitmap_empty(irqs_resend, nr_irqs)) {
 		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
-		desc = irq_desc + irq;
+		desc = irq_desc(irq);
 		local_irq_disable();
 		desc->handle_irq(irq, desc);
 		local_irq_enable();
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index e26ca1e..b9d5098 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -92,11 +92,12 @@ static int misrouted_irq(int irq)
 	int ok = 0;
 
 	for (i = 1; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc;
 
 		if (i == irq)	/* Already tried */
 			continue;
 
+		desc = irq_desc(i);
 		if (try_one_irq(i, desc))
 			ok = 1;
 	}
@@ -108,7 +109,7 @@ static void poll_spurious_irqs(unsigned long dummy)
 {
 	int i;
 	for (i = 1; i < nr_irqs; i++) {
-		struct irq_desc *desc = irq_desc + i;
+		struct irq_desc *desc = irq_desc(i);
 		unsigned int status;
 
 		/* Racy but it doesn't matter */
-- 
1.5.4.5

