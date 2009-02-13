Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZBMHAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZBMHAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZBMHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:00:06 -0500
Received: from ozlabs.org ([203.10.76.45]:56381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZBMHAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:00:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cpumask: remove references to struct irqaction's mask field.
Date: Fri, 13 Feb 2009 12:38:52 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131238.52419.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused, since about 1995.  So remove all initialization of it in
preparation for actually removing the field.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/cris/arch-v10/kernel/time.c          |    1 -
 arch/cris/arch-v32/kernel/smp.c           |    1 -
 arch/cris/arch-v32/kernel/time.c          |    1 -
 arch/frv/kernel/irq-mb93091.c             |    4 ----
 arch/frv/kernel/irq-mb93093.c             |    1 -
 arch/frv/kernel/irq-mb93493.c             |    2 --
 arch/frv/kernel/time.c                    |    1 -
 arch/h8300/kernel/timer/itu.c             |    1 -
 arch/h8300/kernel/timer/timer16.c         |    1 -
 arch/h8300/kernel/timer/timer8.c          |    1 -
 arch/h8300/kernel/timer/tpu.c             |    1 -
 arch/m32r/kernel/time.c                   |    1 -
 arch/mips/cobalt/irq.c                    |    1 -
 arch/mips/emma/markeins/irq.c             |    1 -
 arch/mips/jazz/irq.c                      |    1 -
 arch/mips/kernel/cevt-bcm1480.c           |    1 -
 arch/mips/kernel/cevt-sb1250.c            |    1 -
 arch/mips/kernel/i8253.c                  |    2 --
 arch/mips/kernel/i8259.c                  |    1 -
 arch/mips/lasat/interrupt.c               |    1 -
 arch/mips/lemote/lm2e/irq.c               |    1 -
 arch/mips/sgi-ip32/ip32-irq.c             |    2 --
 arch/mips/sni/rm200.c                     |    3 ++-
 arch/mips/vr41xx/common/irq.c             |    1 -
 arch/mn10300/kernel/time.c                |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_cds.c |    1 -
 arch/powerpc/platforms/8xx/m8xx_setup.c   |    1 -
 arch/powerpc/platforms/chrp/setup.c       |    1 -
 arch/powerpc/platforms/powermac/pic.c     |    2 --
 arch/powerpc/platforms/powermac/smp.c     |    1 -
 arch/powerpc/sysdev/cpm1.c                |    1 -
 arch/sh/kernel/time_64.c                  |    1 -
 arch/sh/kernel/timers/timer-cmt.c         |    1 -
 arch/sh/kernel/timers/timer-mtu2.c        |    1 -
 arch/sh/kernel/timers/timer-tmu.c         |    1 -
 arch/sparc/kernel/irq_32.c                |    2 --
 arch/sparc/kernel/sun4d_irq.c             |    1 -
 arch/x86/kernel/irqinit_32.c              |    1 -
 arch/x86/kernel/irqinit_64.c              |    1 -
 arch/x86/kernel/mfgpt_32.c                |    1 -
 arch/x86/kernel/time_64.c                 |    2 --
 arch/x86/kernel/vmiclock_32.c             |    1 -
 arch/x86/mach-default/setup.c             |    3 ---
 arch/x86/mach-voyager/setup.c             |    3 ---
 kernel/irq/manage.c                       |    1 -
 45 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -261,7 +261,6 @@ static struct irqaction irq2  = {
 static struct irqaction irq2  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_SHARED | IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -65,7 +65,6 @@ static struct irqaction irq_ipi  = {
 static struct irqaction irq_ipi  = {
 	.handler = crisv32_ipi_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "ipi",
 };
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -267,7 +267,6 @@ static struct irqaction irq_timer = {
 static struct irqaction irq_timer = {
 	.handler = timer_interrupt,
 	.flags = IRQF_SHARED | IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -109,28 +109,24 @@ static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -108,7 +108,6 @@ static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -120,14 +120,12 @@ static struct irqaction mb93493_irq[2]  
 	[0] = {
 		.handler	= mb93493_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
 	}
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -45,7 +45,6 @@ static struct irqaction timer_irq  = {
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -60,7 +60,6 @@ static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -55,7 +55,6 @@ static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -75,7 +75,6 @@ static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {8, 64, 8192};
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -65,7 +65,6 @@ static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 const static int __initdata divide_rate[] = {
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -230,7 +230,6 @@ static struct irqaction irq0 = {
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "MFT2",
 };
 
diff --git a/arch/mips/cobalt/irq.c b/arch/mips/cobalt/irq.c
--- a/arch/mips/cobalt/irq.c
+++ b/arch/mips/cobalt/irq.c
@@ -47,7 +47,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -194,7 +194,6 @@ static struct irqaction irq_cascade = {
 static struct irqaction irq_cascade = {
 	   .handler = no_action,
 	   .flags = 0,
-	   .mask = CPU_MASK_NONE,
 	   .name = "cascade",
 	   .dev_id = NULL,
 	   .next = NULL,
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -134,7 +134,6 @@ static struct irqaction r4030_timer_irqa
 static struct irqaction r4030_timer_irqaction = {
 	.handler	= r4030_timer_interrupt,
 	.flags		= IRQF_DISABLED,
-	.mask		= CPU_MASK_CPU0,
 	.name		= "R4030 timer",
 };
 
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -144,7 +144,6 @@ void __cpuinit sb1480_clockevent_init(vo
 
 	action->handler	= sibyte_counter_handler;
 	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
-	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -143,7 +143,6 @@ void __cpuinit sb1250_clockevent_init(vo
 
 	action->handler	= sibyte_counter_handler;
 	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
-	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -98,7 +98,6 @@ static struct irqaction irq0  = {
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
@@ -121,7 +120,6 @@ void __init setup_pit_timer(void)
 	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
 	clockevents_register_device(cd);
 
-	irq0.mask = cpumask_of_cpu(cpu);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -306,7 +306,6 @@ static void init_8259A(int auto_eoi)
  */
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
diff --git a/arch/mips/lasat/interrupt.c b/arch/mips/lasat/interrupt.c
--- a/arch/mips/lasat/interrupt.c
+++ b/arch/mips/lasat/interrupt.c
@@ -104,7 +104,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
--- a/arch/mips/lemote/lm2e/irq.c
+++ b/arch/mips/lemote/lm2e/irq.c
@@ -92,7 +92,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade_irqaction = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -115,14 +115,12 @@ struct irqaction memerr_irq = {
 struct irqaction memerr_irq = {
 	.handler = crime_memerr_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "CRIME memory error",
 };
 
 struct irqaction cpuerr_irq = {
 	.handler = crime_cpuerr_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "CRIME CPU error",
 };
 
diff --git a/arch/mips/sni/rm200.c b/arch/mips/sni/rm200.c
--- a/arch/mips/sni/rm200.c
+++ b/arch/mips/sni/rm200.c
@@ -359,7 +359,8 @@ void sni_rm200_init_8259A(void)
  * IRQ2 is cascade interrupt to second interrupt controller
  */
 static struct irqaction sni_rm200_irq2 = {
-	no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL
+	.handler = no_action,
+	.name = "cascade",
 };
 
 static struct resource sni_rm200_pic1_resource = {
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -32,7 +32,6 @@ static irq_cascade_t irq_cascade[NR_IRQS
 
 static struct irqaction cascade_irqaction = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -37,7 +37,6 @@ static struct irqaction timer_irq = {
 static struct irqaction timer_irq = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 	.name		= "timer",
 };
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -179,7 +179,6 @@ static struct irqaction mpc85xxcds_8259_
 static struct irqaction mpc85xxcds_8259_irqaction = {
 	.handler = mpc85xx_8259_cascade_action,
 	.flags = IRQF_SHARED,
-	.mask = CPU_MASK_NONE,
 	.name = "8259 cascade",
 };
 #endif /* PPC_I8259 */
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -44,7 +44,6 @@ static irqreturn_t timebase_interrupt(in
 
 static struct irqaction tbint_irqaction = {
 	.handler = timebase_interrupt,
-	.mask = CPU_MASK_NONE,
 	.name = "tbint",
 };
 
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -472,7 +472,6 @@ static void __init chrp_find_openpic(voi
 #if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 static struct irqaction xmon_irqaction = {
 	.handler = xmon_irq,
-	.mask = CPU_MASK_NONE,
 	.name = "XMON break",
 };
 #endif
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -266,7 +266,6 @@ static struct irqaction xmon_action = {
 static struct irqaction xmon_action = {
 	.handler	= xmon_irq,
 	.flags		= 0,
-	.mask		= CPU_MASK_NONE,
 	.name		= "NMI - XMON"
 };
 #endif
@@ -274,7 +273,6 @@ static struct irqaction gatwick_cascade_
 static struct irqaction gatwick_cascade_action = {
 	.handler	= gatwick_action,
 	.flags		= IRQF_DISABLED,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -385,7 +385,6 @@ static struct irqaction psurge_irqaction
 static struct irqaction psurge_irqaction = {
 	.handler = psurge_primary_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "primary IPI",
 };
 
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -119,7 +119,6 @@ static irqreturn_t cpm_error_interrupt(i
 
 static struct irqaction cpm_error_irqaction = {
 	.handler = cpm_error_interrupt,
-	.mask = CPU_MASK_NONE,
 	.name = "error",
 };
 
diff --git a/arch/sh/kernel/time_64.c b/arch/sh/kernel/time_64.c
--- a/arch/sh/kernel/time_64.c
+++ b/arch/sh/kernel/time_64.c
@@ -284,7 +284,6 @@ static struct irqaction irq0  = {
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/sh/kernel/timers/timer-cmt.c b/arch/sh/kernel/timers/timer-cmt.c
--- a/arch/sh/kernel/timers/timer-cmt.c
+++ b/arch/sh/kernel/timers/timer-cmt.c
@@ -109,7 +109,6 @@ static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static void cmt_clk_init(struct clk *clk)
diff --git a/arch/sh/kernel/timers/timer-mtu2.c b/arch/sh/kernel/timers/timer-mtu2.c
--- a/arch/sh/kernel/timers/timer-mtu2.c
+++ b/arch/sh/kernel/timers/timer-mtu2.c
@@ -114,7 +114,6 @@ static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static unsigned int divisors[] = { 1, 4, 16, 64, 1, 1, 256 };
diff --git a/arch/sh/kernel/timers/timer-tmu.c b/arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c
+++ b/arch/sh/kernel/timers/timer-tmu.c
@@ -155,7 +155,6 @@ static struct irqaction tmu0_irq = {
 	.name		= "periodic/oneshot timer",
 	.handler	= tmu_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static void __init tmu_clk_init(struct clk *clk)
diff --git a/arch/sparc/kernel/irq_32.c b/arch/sparc/kernel/irq_32.c
--- a/arch/sparc/kernel/irq_32.c
+++ b/arch/sparc/kernel/irq_32.c
@@ -439,7 +439,6 @@ static int request_fast_irq(unsigned int
 	flush_cache_all();
 
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->dev_id = NULL;
 	action->next = NULL;
@@ -574,7 +573,6 @@ int request_irq(unsigned int irq,
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
 	action->dev_id = dev_id;
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -326,7 +326,6 @@ int sun4d_request_irq(unsigned int irq,
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
 	action->dev_id = dev_id;
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -50,7 +50,6 @@ static irqreturn_t math_error_irq(int cp
  */
 static struct irqaction fpu_irq = {
 	.handler = math_error_irq,
-	.mask = CPU_MASK_NONE,
 	.name = "fpu",
 };
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -45,7 +45,6 @@
 
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -348,7 +348,6 @@ static struct irqaction mfgptirq  = {
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask = CPU_MASK_NONE,
 	.name = "mfgpt-timer"
 };
 
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -116,7 +116,6 @@ static struct irqaction irq0 = {
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
-	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
 
@@ -125,7 +124,6 @@ void __init hpet_time_init(void)
 	if (!hpet_enable())
 		setup_pit_timer();
 
-	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -203,7 +203,6 @@ static struct irqaction vmi_clock_action
 	.name 		= "vmi-timer",
 	.handler 	= vmi_timer_interrupt,
 	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask 		= CPU_MASK_ALL,
 };
 
 static void __devinit vmi_time_init_clockevent(void)
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -43,7 +43,6 @@ void __init pre_intr_init_hook(void)
  */
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
@@ -97,7 +96,6 @@ static struct irqaction irq0  = {
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
@@ -130,7 +128,6 @@ void __init time_init_hook(void)
 			return;
 	}
 
-	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -20,7 +20,6 @@ void __init pre_intr_init_hook(void)
  */
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
@@ -57,13 +56,11 @@ static struct irqaction irq0 = {
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
 void __init time_init_hook(void)
 {
-	irq0.mask = cpumask_of_cpu(safe_smp_processor_id());
 	setup_irq(0, &irq0);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -715,7 +715,6 @@ int request_irq(unsigned int irq, irq_ha
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
 	action->dev_id = dev_id;
