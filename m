Return-Path: <linux-kernel-owner+w=401wt.eu-S1751111AbXJSH4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbXJSH4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934767AbXJSH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:56:21 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57823 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966292AbXJSH4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:56:18 -0400
Date: Fri, 19 Oct 2007 03:56:16 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 3/9] irq-remove: arch trivial
Message-ID: <20071019075616.GD6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit bbf90280966a9661e1a5357f9ee8a94450132d71
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:46:37 2007 -0400

    [IRQ ARG REMOVAL] trivial arch updates

 arch/frv/kernel/dma.c                        |    2 +-
 arch/frv/kernel/irq-mb93091.c                |    2 +-
 arch/frv/kernel/irq-mb93093.c                |    2 +-
 arch/frv/kernel/irq-mb93493.c                |    2 +-
 arch/frv/kernel/time.c                       |    4 ++--
 arch/ia64/kernel/irq_ia64.c                  |    4 ++--
 arch/ia64/kernel/machvec.c                   |    2 +-
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/time.c                      |    2 +-
 arch/ia64/sn/pci/tioca_provider.c            |    2 +-
 arch/ia64/sn/pci/tioce_provider.c            |    2 +-
 arch/mips/kernel/time.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-reset.c              |    2 +-
 arch/powerpc/platforms/cell/interrupt.c      |    2 +-
 arch/powerpc/platforms/powermac/low_i2c.c    |    2 +-
 arch/powerpc/platforms/powermac/pfunc_base.c |    2 +-
 arch/powerpc/platforms/pseries/ras.c         |    8 ++++----
 arch/powerpc/platforms/pseries/xics.c        |    4 ++--
 arch/powerpc/sysdev/mpic.c                   |    2 +-
 arch/sparc/kernel/irq.c                      |    2 +-
 arch/x86/kernel/i8259_32.c                   |    2 +-
 arch/x86/kernel/time_32.c                    |    2 +-
 arch/x86/kernel/vmiclock_32.c                |    2 +-
 arch/x86/mach-visws/visws_apic.c             |    2 +-
 arch/x86/mach-voyager/voyager_basic.c        |    2 +-
 arch/x86/xen/smp.c                           |    6 +++---
 arch/x86/xen/time.c                          |    2 +-
 include/asm-m68k/floppy.h                    |    6 +++---
 include/asm-m68k/sun3xflop.h                 |    6 +++---
 include/asm-parisc/floppy.h                  |    6 +++---
 include/asm-ppc/floppy.h                     |    7 +++----
 include/asm-sh/floppy.h                      |    6 +++---
 include/asm-sparc64/floppy.h                 |    8 ++++----
 include/asm-x86/arch_hooks.h                 |    2 +-
 include/asm-x86/floppy.h                     |    6 +++---
 include/asm-x86/hpet.h                       |    2 +-
 36 files changed, 59 insertions(+), 60 deletions(-)

bbf90280966a9661e1a5357f9ee8a94450132d71
diff --git a/arch/frv/kernel/dma.c b/arch/frv/kernel/dma.c
index 156184e..ecb6b67 100644
--- a/arch/frv/kernel/dma.c
+++ b/arch/frv/kernel/dma.c
@@ -121,7 +121,7 @@ unsigned long frv_dma_inprogress;
 /*
  * DMA irq handler - determine channel involved, grab status and call real handler
  */
-static irqreturn_t dma_irq_handler(int irq, void *_channel)
+static irqreturn_t dma_irq_handler(void *_channel)
 {
 	struct frv_dma_channel *channel = _channel;
 
diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index ad753c1..94c306f 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -80,7 +80,7 @@ static struct irq_chip frv_fpga_pic = {
 /*
  * FPGA PIC interrupt handler
  */
-static irqreturn_t fpga_interrupt(int irq, void *_mask)
+static irqreturn_t fpga_interrupt(void *_mask)
 {
 	uint16_t imr, mask = (unsigned long) _mask;
 
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index e0983f6..e55d376 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -79,7 +79,7 @@ static struct irq_chip frv_fpga_pic = {
 /*
  * FPGA PIC interrupt handler
  */
-static irqreturn_t fpga_interrupt(int irq, void *_mask)
+static irqreturn_t fpga_interrupt(void *_mask)
 {
 	uint16_t imr, mask = (unsigned long) _mask;
 
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index c157eef..1e617f6 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -90,7 +90,7 @@ static struct irq_chip frv_mb93493_pic = {
 /*
  * MB93493 PIC interrupt handler
  */
-static irqreturn_t mb93493_interrupt(int irq, void *_piqsr)
+static irqreturn_t mb93493_interrupt(void *_piqsr)
 {
 	volatile void *piqsr = _piqsr;
 	uint32_t iqsr;
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index e83e0bc..0a2bca5 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -40,7 +40,7 @@ unsigned long __nongprelbss __dsu_clock_speed_HZ;
 unsigned long __nongprelbss __serial_clock_speed_HZ;
 unsigned long __delay_loops_MHz;
 
-static irqreturn_t timer_interrupt(int irq, void *dummy);
+static irqreturn_t timer_interrupt(void *dummy);
 
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
@@ -58,7 +58,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-static irqreturn_t timer_interrupt(int irq, void *dummy)
+static irqreturn_t timer_interrupt(void *dummy)
 {
 	/* last time the cmos clock got updated */
 	static long last_rtc_update = 0;
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 00a4599..9bb7f83 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -529,11 +529,11 @@ void ia64_process_pending_intr(void)
 
 #ifdef CONFIG_SMP
 
-static irqreturn_t dummy_handler (int irq, void *dev_id)
+static irqreturn_t dummy_handler (void *dev_id)
 {
 	BUG();
 }
-extern irqreturn_t handle_IPI (int irq, void *dev_id);
+extern irqreturn_t handle_IPI (void *dev_id);
 
 static struct irqaction ipi_irqaction = {
 	.handler =	handle_IPI,
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index 7ccb228..42ff99a 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -69,7 +69,7 @@ machvec_setup (char **arg)
 EXPORT_SYMBOL(machvec_setup);
 
 void
-machvec_timer_interrupt (int irq, void *dev_id)
+machvec_timer_interrupt (void *dev_id)
 {
 }
 EXPORT_SYMBOL(machvec_timer_interrupt);
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index cc87025..692453b 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -502,7 +502,7 @@ int cpe_vector = -1;
 int ia64_cpe_irq = -1;
 
 static irqreturn_t
-ia64_mca_cpe_int_handler (int cpe_irq, void *arg)
+ia64_mca_cpe_int_handler (void *arg)
 {
 	static unsigned long	cpe_history[CPE_HISTORY_LENGTH];
 	static int		index;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 2bb8421..871ce32 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -60,7 +60,7 @@ static struct clocksource clocksource_itc = {
 static struct clocksource *itc_clocksource;
 
 static irqreturn_t
-timer_interrupt (int irq, void *dev_id)
+timer_interrupt (void *dev_id)
 {
 	unsigned long new_itm;
 
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index ef048a6..5e5b611 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -555,7 +555,7 @@ tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
  * defers processing to the SGI prom.
  */
 static irqreturn_t
-tioca_error_intr_handler(int irq, void *arg)
+tioca_error_intr_handler(void *arg)
 {
 	struct tioca_common *soft = arg;
 	struct ia64_sal_retval ret_stuff;
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index cee9379..5e25143 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -669,7 +669,7 @@ tioce_dma_consistent(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma
  * Handle a CE error interrupt.  Simply a wrapper around a SAL call which
  * defers processing to the SGI prom.
  */ static irqreturn_t
-tioce_error_intr_handler(int irq, void *arg)
+tioce_error_intr_handler(void *arg)
 {
 	struct tioce_common *soft = arg;
 	struct ia64_sal_retval ret_stuff;
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index ea7cfe7..5b3df89 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -100,7 +100,7 @@ int (*mips_timer_state)(void);
  * a broadcasted inter-processor interrupt which itself is triggered
  * by the global timer interrupt.
  */
-void local_timer_interrupt(int irq, void *dev_id)
+void local_timer_interrupt(void *dev_id)
 {
 	profile_tick(CPU_PROFILING);
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index a435b31..59b954d 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -169,7 +169,7 @@ static inline void volume_down_button(unsigned long data)
 	}
 }
 
-static irqreturn_t panel_int(int irq, void *dev_id)
+static irqreturn_t panel_int(void *dev_id)
 {
 	unsigned int buttons;
 
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 151fd8b..3731858 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -189,7 +189,7 @@ struct irq_host *iic_get_irq_host(int node)
 EXPORT_SYMBOL_GPL(iic_get_irq_host);
 
 
-static irqreturn_t iic_ipi_action(int irq, void *dev_id)
+static irqreturn_t iic_ipi_action(void *dev_id)
 {
 	int ipi = (int)(long)dev_id;
 
diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index da2007e..b942401 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -342,7 +342,7 @@ static void kw_i2c_handle_interrupt(struct pmac_i2c_host_kw *host, u8 isr)
 }
 
 /* Interrupt handler */
-static irqreturn_t kw_i2c_irq(int irq, void *dev_id)
+static irqreturn_t kw_i2c_irq(void *dev_id)
 {
 	struct pmac_i2c_host_kw *host = dev_id;
 	unsigned long flags;
diff --git a/arch/powerpc/platforms/powermac/pfunc_base.c b/arch/powerpc/platforms/powermac/pfunc_base.c
index 45d54b9..c3d32c9 100644
--- a/arch/powerpc/platforms/powermac/pfunc_base.c
+++ b/arch/powerpc/platforms/powermac/pfunc_base.c
@@ -15,7 +15,7 @@
 #define DBG(fmt...)
 #endif
 
-static irqreturn_t macio_gpio_irq(int irq, void *data)
+static irqreturn_t macio_gpio_irq(void *data)
 {
 	pmf_do_irq(data);
 
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 3a393c7..bebb945 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -64,8 +64,8 @@ static int ras_check_exception_token;
 #define EPOW_SENSOR_INDEX	0
 #define RAS_VECTOR_OFFSET	0x500
 
-static irqreturn_t ras_epow_interrupt(int irq, void *dev_id);
-static irqreturn_t ras_error_interrupt(int irq, void *dev_id);
+static irqreturn_t ras_epow_interrupt(void *dev_id);
+static irqreturn_t ras_error_interrupt(void *dev_id);
 
 /* #define DEBUG */
 
@@ -163,7 +163,7 @@ __initcall(init_ras_IRQ);
  * to examine the type of power failure and take appropriate action where
  * the time horizon permits something useful to be done.
  */
-static irqreturn_t ras_epow_interrupt(int irq, void *dev_id)
+static irqreturn_t ras_epow_interrupt(void *dev_id)
 {
 	int status = 0xdeadbeef;
 	int state = 0;
@@ -206,7 +206,7 @@ static irqreturn_t ras_epow_interrupt(int irq, void *dev_id)
  * For nonrecoverable errors, an error is logged and we stop all processing
  * as quickly as possible in order to prevent propagation of the failure.
  */
-static irqreturn_t ras_error_interrupt(int irq, void *dev_id)
+static irqreturn_t ras_error_interrupt(void *dev_id)
 {
 	struct rtas_error_log *rtas_elog;
 	int status = 0xdeadbeef;
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 66e7d68..7153e4b 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -359,7 +359,7 @@ static irqreturn_t xics_ipi_dispatch(int cpu)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t xics_ipi_action_direct(int irq, void *dev_id)
+static irqreturn_t xics_ipi_action_direct(void *dev_id)
 {
 	int cpu = smp_processor_id();
 
@@ -368,7 +368,7 @@ static irqreturn_t xics_ipi_action_direct(int irq, void *dev_id)
 	return xics_ipi_dispatch(cpu);
 }
 
-static irqreturn_t xics_ipi_action_lpar(int irq, void *dev_id)
+static irqreturn_t xics_ipi_action_lpar(void *dev_id)
 {
 	int cpu = smp_processor_id();
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index e479388..6ea628f 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -612,7 +612,7 @@ static inline void mpic_eoi(struct mpic *mpic)
 }
 
 #ifdef CONFIG_SMP
-static irqreturn_t mpic_ipi_action(int irq, void *dev_id)
+static irqreturn_t mpic_ipi_action(void *dev_id)
 {
 	struct mpic *mpic;
 
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index e1e24f3..d2449cf 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -490,7 +490,7 @@ void sparc_floppy_irq(int irq, void *dev_id, struct pt_regs *regs)
 	disable_pil_irq(irq);
 	irq_enter();
 	kstat_cpu(cpu).irqs[irq]++;
-	floppy_irq_handler(irq, dev_id);
+	floppy_irq_handler(dev_id);
 	irq_exit();
 	enable_pil_irq(irq);
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index d34a10c..ef31cd3 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -335,7 +335,7 @@ void init_8259A(int auto_eoi)
  */
  
 
-static irqreturn_t math_error_irq(int cpl, void *dev_id)
+static irqreturn_t math_error_irq(void *dev_id)
 {
 	extern void math_error(void __user *);
 	outb(0,0xF0);
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 8a322c9..117ae64 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(profile_pc);
  * Time Stamp Counter value at the time of the timer interrupt, so that
  * we later on can estimate the time of day more exactly.
  */
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+irqreturn_t timer_interrupt(void *dev_id)
 {
 	/* Keep nmi watchdog up to date */
 	per_cpu(irq_stat, smp_processor_id()).irq0_irqs++;
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index b1b5ab0..4e41bdc 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -194,7 +194,7 @@ static struct clock_event_device vmi_clockevent = {
 	.irq		= 0,
 };
 
-static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
+static irqreturn_t vmi_timer_interrupt(void *dev_id)
 {
 	struct clock_event_device *evt = &__get_cpu_var(local_events);
 	evt->event_handler(evt);
diff --git a/arch/x86/mach-visws/visws_apic.c b/arch/x86/mach-visws/visws_apic.c
index 710faf7..05c7300 100644
--- a/arch/x86/mach-visws/visws_apic.c
+++ b/arch/x86/mach-visws/visws_apic.c
@@ -189,7 +189,7 @@ static struct irq_chip piix4_virtual_irq_type = {
  * enable_irq gets the right irq. This 'master' irq is never directly
  * manipulated by any driver.
  */
-static irqreturn_t piix4_master_intr(int irq, void *dev_id)
+static irqreturn_t piix4_master_intr(void *dev_id)
 {
 	int realirq;
 	irq_desc_t *desc;
diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 9b77b39..cf24bc0 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -87,7 +87,7 @@ voyager_detect(struct voyager_bios_info *bios)
 }
 
 void
-voyager_system_interrupt(int cpl, void *dev_id)
+voyager_system_interrupt(void *dev_id)
 {
 	printk("Voyager: detected system interrupt\n");
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c1b131b..1ea7ad7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -53,7 +53,7 @@ struct call_data_struct {
 	int wait;
 };
 
-static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
+static irqreturn_t xen_call_function_interrupt(void *dev_id);
 
 static struct call_data_struct *call_data;
 
@@ -62,7 +62,7 @@ static struct call_data_struct *call_data;
  * all the work is done automatically when
  * we return from the interrupt.
  */
-static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
+static irqreturn_t xen_reschedule_interrupt(void *dev_id)
 {
 	return IRQ_HANDLED;
 }
@@ -339,7 +339,7 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 		xen_send_IPI_one(cpu, vector);
 }
 
-static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
+static irqreturn_t xen_call_function_interrupt(void *dev_id)
 {
 	void (*func) (void *info) = call_data->func;
 	void *info = call_data->info;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index d083ff5..651f9a8 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -524,7 +524,7 @@ static const struct clock_event_device *xen_clockevent =
 	&xen_timerop_clockevent;
 static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events);
 
-static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
+static irqreturn_t xen_timer_interrupt(void *dev_id)
 {
 	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events);
 	irqreturn_t ret;
diff --git a/include/asm-m68k/floppy.h b/include/asm-m68k/floppy.h
index 697d503..2cefe11 100644
--- a/include/asm-m68k/floppy.h
+++ b/include/asm-m68k/floppy.h
@@ -180,7 +180,7 @@ static void fd_disable_dma(void)
 
 /* this is the only truly Q40 specific function */
 
-asmlinkage irqreturn_t floppy_hardint(int irq, void *dev_id)
+asmlinkage irqreturn_t floppy_hardint(void *dev_id)
 {
 	register unsigned char st;
 
@@ -193,7 +193,7 @@ asmlinkage irqreturn_t floppy_hardint(int irq, void *dev_id)
 	static int dma_wait=0;
 #endif
 	if(!doing_pdma) {
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 
@@ -241,7 +241,7 @@ asmlinkage irqreturn_t floppy_hardint(int irq, void *dev_id)
 		dma_wait=0;
 #endif
 		doing_pdma = 0;
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 #ifdef TRACE_FLPY_INT
diff --git a/include/asm-m68k/sun3xflop.h b/include/asm-m68k/sun3xflop.h
index 32c45f8..9cdece3 100644
--- a/include/asm-m68k/sun3xflop.h
+++ b/include/asm-m68k/sun3xflop.h
@@ -111,7 +111,7 @@ static void sun3x_82072_fd_outb(unsigned char value, int port)
 }
 
 
-asmlinkage irqreturn_t sun3xflop_hardint(int irq, void *dev_id)
+asmlinkage irqreturn_t sun3xflop_hardint(void *dev_id)
 {
 	register unsigned char st;
 
@@ -124,7 +124,7 @@ asmlinkage irqreturn_t sun3xflop_hardint(int irq, void *dev_id)
 	static int dma_wait=0;
 #endif
 	if(!doing_pdma) {
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 
@@ -188,7 +188,7 @@ asmlinkage irqreturn_t sun3xflop_hardint(int irq, void *dev_id)
 		dma_wait=0;
 #endif
 
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 
diff --git a/include/asm-parisc/floppy.h b/include/asm-parisc/floppy.h
index 4ca69f5..08dc6e0 100644
--- a/include/asm-parisc/floppy.h
+++ b/include/asm-parisc/floppy.h
@@ -62,7 +62,7 @@ static char *virtual_dma_addr=0;
 static int virtual_dma_mode=0;
 static int doing_pdma=0;
 
-static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
+static void floppy_hardint(void *dev_id)
 {
 	register unsigned char st;
 
@@ -74,7 +74,7 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 	static int dma_wait=0;
 #endif
 	if (!doing_pdma) {
-		floppy_interrupt(irq, dev_id, regs);
+		floppy_interrupt(dev_id);
 		return;
 	}
 
@@ -119,7 +119,7 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 		dma_wait=0;
 #endif
 		doing_pdma = 0;
-		floppy_interrupt(irq, dev_id, regs);
+		floppy_interrupt(dev_id);
 		return;
 	}
 #ifdef TRACE_FLPY_INT
diff --git a/include/asm-ppc/floppy.h b/include/asm-ppc/floppy.h
index 7d9b3f4..7224723 100644
--- a/include/asm-ppc/floppy.h
+++ b/include/asm-ppc/floppy.h
@@ -38,15 +38,14 @@ static int virtual_dma_mode;
 static int doing_vdma;
 static struct fd_dma_ops *fd_ops;
 
-static irqreturn_t floppy_hardint(int irq, void *dev_id)
+static irqreturn_t floppy_hardint(void *dev_id)
 {
 	unsigned char st;
 	int lcount;
 	char *lptr;
 
 	if (!doing_vdma)
-		return floppy_interrupt(irq, dev_id);
-
+		return floppy_interrupt(dev_id);
 
 	st = 1;
 	for (lcount=virtual_dma_count, lptr=virtual_dma_addr;
@@ -69,7 +68,7 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 		virtual_dma_residue += virtual_dma_count;
 		virtual_dma_count=0;
 		doing_vdma = 0;
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 	return IRQ_HANDLED;
diff --git a/include/asm-sh/floppy.h b/include/asm-sh/floppy.h
index 59fbfdc..aa18e14 100644
--- a/include/asm-sh/floppy.h
+++ b/include/asm-sh/floppy.h
@@ -52,7 +52,7 @@ static char *virtual_dma_addr;
 static int virtual_dma_mode;
 static int doing_pdma;
 
-static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
+static irqreturn_t floppy_hardint(void *dev_id)
 {
 	register unsigned char st;
 
@@ -64,7 +64,7 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 	static int dma_wait=0;
 #endif
 	if(!doing_pdma) {
-		floppy_interrupt(irq, dev_id, regs);
+		floppy_interrupt(dev_id);
 		return;
 	}
 
@@ -109,7 +109,7 @@ static void floppy_hardint(int irq, void *dev_id, struct pt_regs * regs)
 		dma_wait=0;
 #endif
 		doing_pdma = 0;
-		floppy_interrupt(irq, dev_id, regs);
+		floppy_interrupt(dev_id);
 		return;
 	}
 #ifdef TRACE_FLPY_INT
diff --git a/include/asm-sparc64/floppy.h b/include/asm-sparc64/floppy.h
index c47f58d..653faa3 100644
--- a/include/asm-sparc64/floppy.h
+++ b/include/asm-sparc64/floppy.h
@@ -206,7 +206,7 @@ static void sun_fd_enable_dma(void)
 	pdma_areasize = pdma_size;
 }
 
-irqreturn_t sparc_floppy_irq(int irq, void *dev_cookie)
+irqreturn_t sparc_floppy_irq(void *dev_cookie)
 {
 	if (likely(doing_pdma)) {
 		void __iomem *stat = (void __iomem *) fdc_status;
@@ -253,7 +253,7 @@ irqreturn_t sparc_floppy_irq(int irq, void *dev_cookie)
 	}
 
 main_interrupt:
-	return floppy_interrupt(irq, dev_cookie);
+	return floppy_interrupt(dev_cookie);
 }
 
 static int sun_fd_request_irq(void)
@@ -309,7 +309,7 @@ struct sun_pci_dma_op {
 static struct sun_pci_dma_op sun_pci_dma_current = { -1U, 0, 0, NULL};
 static struct sun_pci_dma_op sun_pci_dma_pending = { -1U, 0, 0, NULL};
 
-extern irqreturn_t floppy_interrupt(int irq, void *dev_id);
+extern irqreturn_t floppy_interrupt(void *dev_id);
 
 static unsigned char sun_pci_fd_inb(unsigned long port)
 {
@@ -444,7 +444,7 @@ static int sun_pci_fd_eject(int drive)
 
 void sun_pci_fd_dma_callback(struct ebus_dma_info *p, int event, void *cookie)
 {
-	floppy_interrupt(0, NULL);
+	floppy_interrupt(NULL);
 }
 
 /*
diff --git a/include/asm-x86/arch_hooks.h b/include/asm-x86/arch_hooks.h
index a8c1fca..255a84e 100644
--- a/include/asm-x86/arch_hooks.h
+++ b/include/asm-x86/arch_hooks.h
@@ -14,7 +14,7 @@
 extern void init_ISA_irqs(void);
 extern void apic_intr_init(void);
 extern void smp_intr_init(void);
-extern irqreturn_t timer_interrupt(int irq, void *dev_id);
+extern irqreturn_t timer_interrupt(void *dev_id);
 
 /* these are the defined hooks */
 extern void intr_init_hook(void);
diff --git a/include/asm-x86/floppy.h b/include/asm-x86/floppy.h
index a48d715..eb8e280 100644
--- a/include/asm-x86/floppy.h
+++ b/include/asm-x86/floppy.h
@@ -50,7 +50,7 @@ static char *virtual_dma_addr;
 static int virtual_dma_mode;
 static int doing_pdma;
 
-static irqreturn_t floppy_hardint(int irq, void *dev_id)
+static irqreturn_t floppy_hardint(void *dev_id)
 {
 	register unsigned char st;
 
@@ -62,7 +62,7 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 	static int dma_wait=0;
 #endif
 	if (!doing_pdma)
-		return floppy_interrupt(irq, dev_id);
+		return floppy_interrupt(dev_id);
 
 #ifdef TRACE_FLPY_INT
 	if(!calls)
@@ -105,7 +105,7 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 		dma_wait=0;
 #endif
 		doing_pdma = 0;
-		floppy_interrupt(irq, dev_id);
+		floppy_interrupt(dev_id);
 		return IRQ_HANDLED;
 	}
 #ifdef TRACE_FLPY_INT
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index d4ab6db..968bc0d 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -80,7 +80,7 @@ extern int hpet_set_alarm_time(unsigned char hrs, unsigned char min,
 extern int hpet_set_periodic_freq(unsigned long freq);
 extern int hpet_rtc_dropped_irq(void);
 extern int hpet_rtc_timer_init(void);
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+extern irqreturn_t hpet_rtc_interrupt(void *dev_id);
 
 #endif /* CONFIG_HPET_EMULATE_RTC */
 
