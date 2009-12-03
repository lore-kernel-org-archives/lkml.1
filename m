Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLCUVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLCUVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZLCUVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:21:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44259 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZLCUVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:21:50 -0500
Date: Thu, 3 Dec 2009 21:21:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic for v2.6.33
Message-ID: <20091203202137.GA25181@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.7 required=5.9 tests=FRT_LEVITRA autolearn=no SpamAssassin version=3.2.5
	0.7 FRT_LEVITRA            BODY: ReplaceTags: Levitra
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

The changes are pretty much all over the place.

out-of-topic modifications in x86-apic-for-linus:
-------------------------------------------------
drivers/misc/sgi-xp/xpc_uv.c       # 6c2c502: x86: SGI UV: Fix irq affinity for

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, apic: Clear APIC Timer Initial Count Register on shutdown

Cyrill Gorcunov (10):
      x86, apic: Introduce the NOOP apic driver
      x86, apic: Use apic noop driver
      x86, apic: Limit apic dumping, introduce new show_lapic= setup option
      x86, apic: Explain show_lapic= in kernel parameters list
      x86: apic: Allow noop operations to be called almost at any time
      x86, apic: Use PAGE_SIZE instead of numbers
      x86, ioapic: Use snrpintf while set names for IO-APIC resourses
      x86, apic: Get rid of apicid_to_cpu_present assign on 64-bit
      x86: apic: Do not use stacked physid_mask_t
      x86: io-apic: IO-APIC MMIO should not fail on resource insertion

Dimitri Sivanich (3):
      x86: SGI UV: Fix irq affinity for hub based interrupts
      x86, apic: Move SGI UV functionality out of generic IO-APIC code
      x86: Remove asm/apicnum.h

Ingo Molnar (1):
      x86, apic: Fix prototype in hw_irq.h

Jack Steiner (1):
      x86: SGI UV: Map low MMR ranges

Maciej W. Rozycki (1):
      x86, io-apic: Move the effort of clearing remoteIRR explicitly before migrating the irq

Mikael Pettersson (1):
      x86, apic: Enable lapic nmi watchdog on AMD Family 11h

Suresh Siddha (9):
      x86: Unify fixup_irqs() for 32-bit and 64-bit kernels
      x86, intr-remap: Avoid irq_chip mask/unmask in fixup_irqs() for intr-remapping
      x86: Remove move_cleanup_count from irq_cfg
      x86: Force irq complete move during cpu offline
      x86: Use EOI register in io-apic on intel platforms
      x86: Remove local_irq_enable()/local_irq_disable() in fixup_irqs()
      x86, ioapic: Fix the EOI register detection mechanism
      x86, ioapic: Document another case when level irq is seen as an edge
      x86: Remove unnecessary mdelay() from cpu_disable_common()

Yinghai Lu (3):
      x86: apic: Remove not needed #ifdef
      x86: Re-get cfg_new in case reuse/move irq_desc
      x86: apic: Print out SRAT table APIC id in hex


 Documentation/kernel-parameters.txt    |    9 +
 arch/x86/include/asm/apic.h            |   21 +-
 arch/x86/include/asm/apicdef.h         |    6 +
 arch/x86/include/asm/apicnum.h         |   12 -
 arch/x86/include/asm/hw_irq.h          |   30 ++-
 arch/x86/include/asm/irq.h             |    1 +
 arch/x86/include/asm/mpspec.h          |   16 +-
 arch/x86/include/asm/uv/uv_irq.h       |   14 +-
 arch/x86/kernel/apic/Makefile          |    2 +-
 arch/x86/kernel/apic/apic.c            |   34 +---
 arch/x86/kernel/apic/apic_noop.c       |  200 +++++++++++++++++
 arch/x86/kernel/apic/bigsmp_32.c       |   13 +-
 arch/x86/kernel/apic/es7000_32.c       |   16 +-
 arch/x86/kernel/apic/io_apic.c         |  364 +++++++++++++++-----------------
 arch/x86/kernel/apic/numaq_32.c        |   13 +-
 arch/x86/kernel/apic/probe_32.c        |    2 +-
 arch/x86/kernel/apic/summit_32.c       |   10 +-
 arch/x86/kernel/apic/x2apic_uv_x.c     |    8 +
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 arch/x86/kernel/irq.c                  |   90 ++++++++
 arch/x86/kernel/irq_32.c               |   45 ----
 arch/x86/kernel/irq_64.c               |   58 -----
 arch/x86/kernel/smpboot.c              |    9 -
 arch/x86/kernel/uv_irq.c               |  239 ++++++++++++++++++++-
 arch/x86/kernel/visws_quirks.c         |    2 +-
 arch/x86/mm/srat_64.c                  |    4 +-
 drivers/misc/sgi-xp/xpc_uv.c           |    5 +-
 27 files changed, 808 insertions(+), 417 deletions(-)
 delete mode 100644 arch/x86/include/asm/apicnum.h
 create mode 100644 arch/x86/kernel/apic/apic_noop.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..465a786 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -345,6 +345,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
 
+	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
+			Limit apic dumping. The parameter defines the maximal
+			number of local apics being dumped. Also it is possible
+			to set it to "all" by meaning -- no limit here.
+			Format: { 1 (default) | 2 | ... | all }.
+			The parameter valid if only apic=debug or
+			apic=verbose is specified.
+			Example: apic=debug show_lapic=all
+
 	apm=		[APM] Advanced Power Management
 			See header of arch/x86/kernel/apm_32.c.
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 474d80d..b4ac2cd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -297,20 +297,20 @@ struct apic {
 	int disable_esr;
 
 	int dest_logical;
-	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
+	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
-	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
+	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
+	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int phys_apicid);
 	void (*enable_apic_mode)(void);
@@ -488,6 +488,8 @@ static inline unsigned int read_apic_id(void)
 
 extern void default_setup_apic_routing(void);
 
+extern struct apic apic_noop;
+
 #ifdef CONFIG_X86_32
 
 extern struct apic apic_default;
@@ -532,9 +534,9 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
-static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
 {
-	return physid_isset(apicid, bitmap);
+	return physid_isset(apicid, *map);
 }
 
 static inline unsigned long default_check_apicid_present(int bit)
@@ -542,9 +544,9 @@ static inline unsigned long default_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
+static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
-	return phys_map;
+	*retmap = *phys_map;
 }
 
 /* Mapping from cpu number to logical apicid */
@@ -583,11 +585,6 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
-static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 3b62da9..7fe3b30 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -11,6 +11,12 @@
 #define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
 #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
+/*
+ * This is the IO-APIC register space as specified
+ * by Intel docs:
+ */
+#define IO_APIC_SLOT_SIZE		1024
+
 #define	APIC_ID		0x20
 
 #define	APIC_LVR	0x30
diff --git a/arch/x86/include/asm/apicnum.h b/arch/x86/include/asm/apicnum.h
deleted file mode 100644
index 82f613c..0000000
--- a/arch/x86/include/asm/apicnum.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_X86_APICNUM_H
-#define _ASM_X86_APICNUM_H
-
-/* define MAX_IO_APICS */
-#ifdef CONFIG_X86_32
-# define MAX_IO_APICS 64
-#else
-# define MAX_IO_APICS 128
-# define MAX_LOCAL_APIC 32768
-#endif
-
-#endif /* _ASM_X86_APICNUM_H */
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index ba180d9..6e12426 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -79,14 +79,32 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 					int ioapic, int ioapic_pin,
 					int trigger, int polarity)
 {
-	irq_attr->ioapic     = ioapic;
-	irq_attr->ioapic_pin = ioapic_pin;
-	irq_attr->trigger    = trigger;
-	irq_attr->polarity   = polarity;
+	irq_attr->ioapic	= ioapic;
+	irq_attr->ioapic_pin	= ioapic_pin;
+	irq_attr->trigger	= trigger;
+	irq_attr->polarity	= polarity;
 }
 
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
-					struct io_apic_irq_attr *irq_attr);
+/*
+ * This is performance-critical, we want to do it O(1)
+ *
+ * Most irqs are mapped 1:1 with pins.
+ */
+struct irq_cfg {
+	struct irq_pin_list	*irq_2_pin;
+	cpumask_var_t		domain;
+	cpumask_var_t		old_domain;
+	u8			vector;
+	u8			move_in_progress : 1;
+};
+
+extern struct irq_cfg *irq_cfg(unsigned int);
+extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+extern void send_cleanup_vector(struct irq_cfg *);
+
+struct irq_desc;
+extern unsigned int set_desc_affinity(struct irq_desc *, const struct cpumask *);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ddda6cb..ffd700f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -34,6 +34,7 @@ static inline int irq_canonicalize(int irq)
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
+extern void irq_force_complete_move(int);
 #endif
 
 extern void (*generic_interrupt_extension)(void);
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 79c9450..61d90b1 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -163,14 +163,16 @@ typedef struct physid_mask physid_mask_t;
 #define physids_shift_left(d, s, n)				\
 	bitmap_shift_left((d).mask, (s).mask, n, MAX_APICS)
 
-#define physids_coerce(map)			((map).mask[0])
+static inline unsigned long physids_coerce(physid_mask_t *map)
+{
+	return map->mask[0];
+}
 
-#define physids_promote(physids)					\
-	({								\
-		physid_mask_t __physid_mask = PHYSID_MASK_NONE;		\
-		__physid_mask.mask[0] = physids;			\
-		__physid_mask;						\
-	})
+static inline void physids_promote(unsigned long physids, physid_mask_t *map)
+{
+	physids_clear(*map);
+	map->mask[0] = physids;
+}
 
 /* Note: will create very large stack frames if physid_mask_t is big */
 #define physid_mask_of_physid(physid)					\
diff --git a/arch/x86/include/asm/uv/uv_irq.h b/arch/x86/include/asm/uv/uv_irq.h
index 9613c8c..d6b17c7 100644
--- a/arch/x86/include/asm/uv/uv_irq.h
+++ b/arch/x86/include/asm/uv/uv_irq.h
@@ -25,12 +25,14 @@ struct uv_IO_APIC_route_entry {
 		dest		: 32;
 };
 
-extern struct irq_chip uv_irq_chip;
-
-extern int arch_enable_uv_irq(char *, unsigned int, int, int, unsigned long);
-extern void arch_disable_uv_irq(int, unsigned long);
+enum {
+	UV_AFFINITY_ALL,
+	UV_AFFINITY_NODE,
+	UV_AFFINITY_CPU
+};
 
-extern int uv_setup_irq(char *, int, int, unsigned long);
-extern void uv_teardown_irq(unsigned int, int, unsigned long);
+extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
+extern int uv_setup_irq(char *, int, int, unsigned long, int);
+extern void uv_teardown_irq(unsigned int);
 
 #endif /* _ASM_X86_UV_UV_IRQ_H */
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index da7b7b9..565c1bf 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,7 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o probe_$(BITS).o ipi.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 894aa97..ad8c75b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -241,28 +241,13 @@ static int modern_apic(void)
 }
 
 /*
- * bare function to substitute write operation
- * and it's _that_ fast :)
- */
-static void native_apic_write_dummy(u32 reg, u32 v)
-{
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
-}
-
-static u32 native_apic_read_dummy(u32 reg)
-{
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
-	return 0;
-}
-
-/*
- * right after this call apic->write/read doesn't do anything
- * note that there is no restore operation it works one way
+ * right after this call apic become NOOP driven
+ * so apic->write/read doesn't do anything
  */
 void apic_disable(void)
 {
-	apic->read = native_apic_read_dummy;
-	apic->write = native_apic_write_dummy;
+	pr_info("APIC: switched to apic NOOP\n");
+	apic = &apic_noop;
 }
 
 void native_apic_wait_icr_idle(void)
@@ -459,7 +444,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write(APIC_LVTT, v);
-		apic_write(APIC_TMICT, 0xffffffff);
+		apic_write(APIC_TMICT, 0);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
@@ -1392,14 +1377,11 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 	int ret, x2apic_enabled = 0;
-	int dmar_table_init_ret = 0;
+	int dmar_table_init_ret;
 
-#ifdef CONFIG_INTR_REMAP
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret)
-		pr_debug("dmar_table_init() failed with %d:\n",
-				dmar_table_init_ret);
-#endif
+	if (dmar_table_init_ret && !x2apic_supported())
+		return;
 
 	ioapic_entries = alloc_ioapic_entries();
 	if (!ioapic_entries) {
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
new file mode 100644
index 0000000..d9acc3b
--- /dev/null
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -0,0 +1,200 @@
+/*
+ * NOOP APIC driver.
+ *
+ * Does almost nothing and should be substituted by a real apic driver via
+ * probe routine.
+ *
+ * Though in case if apic is disabled (for some reason) we try
+ * to not uglify the caller's code and allow to call (some) apic routines
+ * like self-ipi, etc...
+ */
+
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <asm/fixmap.h>
+#include <asm/mpspec.h>
+#include <asm/apicdef.h>
+#include <asm/apic.h>
+#include <asm/setup.h>
+
+#include <linux/smp.h>
+#include <asm/ipi.h>
+
+#include <linux/interrupt.h>
+#include <asm/acpi.h>
+#include <asm/e820.h>
+
+static void noop_init_apic_ldr(void) { }
+static void noop_send_IPI_mask(const struct cpumask *cpumask, int vector) { }
+static void noop_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector) { }
+static void noop_send_IPI_allbutself(int vector) { }
+static void noop_send_IPI_all(int vector) { }
+static void noop_send_IPI_self(int vector) { }
+static void noop_apic_wait_icr_idle(void) { }
+static void noop_apic_icr_write(u32 low, u32 id) { }
+
+static int noop_wakeup_secondary_cpu(int apicid, unsigned long start_eip)
+{
+	return -1;
+}
+
+static u32 noop_safe_apic_wait_icr_idle(void)
+{
+	return 0;
+}
+
+static u64 noop_apic_icr_read(void)
+{
+	return 0;
+}
+
+static int noop_cpu_to_logical_apicid(int cpu)
+{
+	return 0;
+}
+
+static int noop_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return 0;
+}
+
+static unsigned int noop_get_apic_id(unsigned long x)
+{
+	return 0;
+}
+
+static int noop_probe(void)
+{
+	/*
+	 * NOOP apic should not ever be
+	 * enabled via probe routine
+	 */
+	return 0;
+}
+
+static int noop_apic_id_registered(void)
+{
+	/*
+	 * if we would be really "pedantic"
+	 * we should pass read_apic_id() here
+	 * but since NOOP suppose APIC ID = 0
+	 * lets save a few cycles
+	 */
+	return physid_isset(0, phys_cpu_present_map);
+}
+
+static const struct cpumask *noop_target_cpus(void)
+{
+	/* only BSP here */
+	return cpumask_of(0);
+}
+
+static unsigned long noop_check_apicid_used(physid_mask_t *map, int apicid)
+{
+	return physid_isset(apicid, *map);
+}
+
+static unsigned long noop_check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	if (cpu != 0)
+		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+int noop_apicid_to_node(int logical_apicid)
+{
+	/* we're always on node 0 */
+	return 0;
+}
+
+static u32 noop_apic_read(u32 reg)
+{
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
+	return 0;
+}
+
+static void noop_apic_write(u32 reg, u32 v)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+}
+
+struct apic apic_noop = {
+	.name				= "noop",
+	.probe				= noop_probe,
+	.acpi_madt_oem_check		= NULL,
+
+	.apic_id_registered		= noop_apic_id_registered,
+
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all CPUs: */
+	.irq_dest_mode			= 1,
+
+	.target_cpus			= noop_target_cpus,
+	.disable_esr			= 0,
+	.dest_logical			= APIC_DEST_LOGICAL,
+	.check_apicid_used		= noop_check_apicid_used,
+	.check_apicid_present		= noop_check_apicid_present,
+
+	.vector_allocation_domain	= noop_vector_allocation_domain,
+	.init_apic_ldr			= noop_init_apic_ldr,
+
+	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
+	.setup_apic_routing		= NULL,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= noop_apicid_to_node,
+
+	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
+
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+
+	.phys_pkg_id			= noop_phys_pkg_id,
+
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= noop_get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= 0x0F << 24,
+
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= noop_send_IPI_mask,
+	.send_IPI_mask_allbutself	= noop_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= noop_send_IPI_allbutself,
+	.send_IPI_all			= noop_send_IPI_all,
+	.send_IPI_self			= noop_send_IPI_self,
+
+	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
+
+	/* should be safe */
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+
+	.wait_for_init_deassert		= NULL,
+
+	.smp_callin_clear_local_apic	= NULL,
+	.inquire_remote_apic		= NULL,
+
+	.read				= noop_apic_read,
+	.write				= noop_apic_write,
+	.icr_read			= noop_apic_icr_read,
+	.icr_write			= noop_apic_icr_write,
+	.wait_icr_idle			= noop_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= noop_safe_apic_wait_icr_idle,
+};
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 77a0641..38dcecf 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -35,7 +35,7 @@ static const struct cpumask *bigsmp_target_cpus(void)
 #endif
 }
 
-static unsigned long bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
@@ -93,11 +93,6 @@ static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-static physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 /* Mapping from cpu number to logical apicid */
 static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 {
@@ -106,10 +101,10 @@ static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 	return cpu_physical_id(cpu);
 }
 
-static physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
+static void bigsmp_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xFFL);
+	physids_promote(0xFFL, retmap);
 }
 
 static int bigsmp_check_phys_apicid_present(int phys_apicid)
@@ -230,7 +225,7 @@ struct apic apic_bigsmp = {
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 89174f8..e85f8fb 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -466,11 +466,11 @@ static const struct cpumask *es7000_target_cpus(void)
 	return cpumask_of(smp_processor_id());
 }
 
-static unsigned long
-es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long es7000_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
+
 static unsigned long es7000_check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
@@ -539,14 +539,10 @@ static int es7000_cpu_present_to_apicid(int mps_cpu)
 
 static int cpu_id;
 
-static physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
+static void es7000_apicid_to_cpu_present(int phys_apicid, physid_mask_t *retmap)
 {
-	physid_mask_t mask;
-
-	mask = physid_mask_of_physid(cpu_id);
+	physid_set_mask_of_physid(cpu_id, retmap);
 	++cpu_id;
-
-	return mask;
 }
 
 /* Mapping from cpu number to logical apicid */
@@ -561,10 +557,10 @@ static int es7000_cpu_to_logical_apicid(int cpu)
 #endif
 }
 
-static physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
+static void es7000_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xff);
+	physids_promote(0xFFL, retmap);
 }
 
 static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dc69f28..c0b4468 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -60,8 +60,6 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
-#include <asm/uv/uv_hub.h>
-#include <asm/uv/uv_irq.h>
 
 #include <asm/apic.h>
 
@@ -140,20 +138,6 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 	return pin;
 }
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * Most irqs are mapped 1:1 with pins.
- */
-struct irq_cfg {
-	struct irq_pin_list *irq_2_pin;
-	cpumask_var_t domain;
-	cpumask_var_t old_domain;
-	unsigned move_cleanup_count;
-	u8 vector;
-	u8 move_in_progress : 1;
-};
-
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[] = {
@@ -209,7 +193,7 @@ int __init arch_early_irq_init(void)
 }
 
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg *irq_cfg(unsigned int irq)
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg = NULL;
 	struct irq_desc *desc;
@@ -361,7 +345,7 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 /* end for move_irq_desc */
 
 #else
-static struct irq_cfg *irq_cfg(unsigned int irq)
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
@@ -555,23 +539,41 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 	add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
+static void __io_apic_modify_irq(struct irq_pin_list *entry,
+				 int mask_and, int mask_or,
+				 void (*final)(struct irq_pin_list *entry))
+{
+	unsigned int reg, pin;
+
+	pin = entry->pin;
+	reg = io_apic_read(entry->apic, 0x10 + pin * 2);
+	reg &= mask_and;
+	reg |= mask_or;
+	io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
+	if (final)
+		final(entry);
+}
+
 static void io_apic_modify_irq(struct irq_cfg *cfg,
 			       int mask_and, int mask_or,
 			       void (*final)(struct irq_pin_list *entry))
 {
-	int pin;
 	struct irq_pin_list *entry;
 
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
-		reg &= mask_and;
-		reg |= mask_or;
-		io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
-		if (final)
-			final(entry);
-	}
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		__io_apic_modify_irq(entry, mask_and, mask_or, final);
+}
+
+static void __mask_and_edge_IO_APIC_irq(struct irq_pin_list *entry)
+{
+	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+			     IO_APIC_REDIR_MASKED, NULL);
+}
+
+static void __unmask_and_level_IO_APIC_irq(struct irq_pin_list *entry)
+{
+	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_MASKED,
+			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 
 static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
@@ -595,18 +597,6 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
-static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
-			IO_APIC_REDIR_MASKED, NULL);
-}
-
-static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
-			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
-}
-
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
@@ -1177,7 +1167,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+	if (cfg->move_in_progress)
 		return -EBUSY;
 
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
@@ -1237,8 +1227,7 @@ next:
 	return err;
 }
 
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
@@ -1599,9 +1588,6 @@ __apicdebuginit(void) print_IO_APIC(void)
 	struct irq_desc *desc;
 	unsigned int irq;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
@@ -1708,9 +1694,6 @@ __apicdebuginit(void) print_APIC_field(int base)
 {
 	int i;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG);
 
 	for (i = 0; i < 8; i++)
@@ -1724,9 +1707,6 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
@@ -1824,13 +1804,19 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk("\n");
 }
 
-__apicdebuginit(void) print_all_local_APICs(void)
+__apicdebuginit(void) print_local_APICs(int maxcpu)
 {
 	int cpu;
 
+	if (!maxcpu)
+		return;
+
 	preempt_disable();
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		if (cpu >= maxcpu)
+			break;
 		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	}
 	preempt_enable();
 }
 
@@ -1839,7 +1825,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
+	if (!nr_legacy_irqs)
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1866,21 +1852,41 @@ __apicdebuginit(void) print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-__apicdebuginit(int) print_all_ICs(void)
+static int __initdata show_lapic = 1;
+static __init int setup_show_lapic(char *arg)
 {
+	int num = -1;
+
+	if (strcmp(arg, "all") == 0) {
+		show_lapic = CONFIG_NR_CPUS;
+	} else {
+		get_option(&arg, &num);
+		if (num >= 0)
+			show_lapic = num;
+	}
+
+	return 1;
+}
+__setup("show_lapic=", setup_show_lapic);
+
+__apicdebuginit(int) print_ICs(void)
+{
+	if (apic_verbosity == APIC_QUIET)
+		return 0;
+
 	print_PIC();
 
 	/* don't print out if apic is not there */
 	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
-	print_all_local_APICs();
+	print_local_APICs(show_lapic);
 	print_IO_APIC();
 
 	return 0;
 }
 
-fs_initcall(print_all_ICs);
+fs_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */
@@ -2031,7 +2037,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 	 * This is broken; anything with a real cpu count has to
 	 * circumvent this idiocy regardless.
 	 */
-	phys_id_present_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
+	apic->ioapic_phys_id_map(&phys_cpu_present_map, &phys_id_present_map);
 
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
@@ -2058,7 +2064,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 		 * system must have a unique ID or we get lots of nice
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
-		if (apic->check_apicid_used(phys_id_present_map,
+		if (apic->check_apicid_used(&phys_id_present_map,
 					mp_ioapics[apic_id].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
 				apic_id, mp_ioapics[apic_id].apicid);
@@ -2073,7 +2079,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 			mp_ioapics[apic_id].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
+			apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid, &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
 					mp_ioapics[apic_id].apicid);
@@ -2228,20 +2234,16 @@ static int ioapic_retrigger_irq(unsigned int irq)
  */
 
 #ifdef CONFIG_SMP
-static void send_cleanup_vector(struct irq_cfg *cfg)
+void send_cleanup_vector(struct irq_cfg *cfg)
 {
 	cpumask_var_t cleanup_mask;
 
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
-		cfg->move_cleanup_count = 0;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			cfg->move_cleanup_count++;
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
 			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
 		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
 		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
@@ -2272,15 +2274,12 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	}
 }
 
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
-
 /*
  * Either sets desc->affinity to a valid value, and returns
  * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
  * leaves desc->affinity untouched.
  */
-static unsigned int
+unsigned int
 set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
@@ -2433,8 +2432,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
-		if (!cfg->move_cleanup_count)
-			goto unlock;
 
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
@@ -2452,7 +2449,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			goto unlock;
 		}
 		__get_cpu_var(vector_irq)[vector] = -1;
-		cfg->move_cleanup_count--;
 unlock:
 		spin_unlock(&desc->lock);
 	}
@@ -2460,21 +2456,33 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 {
 	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg = desc->chip_data;
-	unsigned vector, me;
+	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
 		return;
 
-	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
 	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
 }
+
+static void irq_complete_move(struct irq_desc **descp)
+{
+	__irq_complete_move(descp, ~get_irq_regs()->orig_ax);
+}
+
+void irq_force_complete_move(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
+
+	__irq_complete_move(&desc, cfg->vector);
+}
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
@@ -2490,6 +2498,59 @@ static void ack_apic_edge(unsigned int irq)
 
 atomic_t irq_mis_count;
 
+/*
+ * IO-APIC versions below 0x20 don't support EOI register.
+ * For the record, here is the information about various versions:
+ *     0Xh     82489DX
+ *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
+ *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
+ *     30h-FFh Reserved
+ *
+ * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
+ * version as 0x2. This is an error with documentation and these ICH chips
+ * use io-apic's of version 0x20.
+ *
+ * For IO-APIC's with EOI register, we use that to do an explicit EOI.
+ * Otherwise, we simulate the EOI message manually by changing the trigger
+ * mode to edge and then back to level, with RTE being masked during this.
+*/
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		if (mp_ioapics[entry->apic].apicver >= 0x20) {
+			/*
+			 * Intr-remapping uses pin number as the virtual vector
+			 * in the RTE. Actual vector is programmed in
+			 * intr-remapping table entry. Hence for the io-apic
+			 * EOI we use the pin number.
+			 */
+			if (irq_remapped(irq))
+				io_apic_eoi(entry->apic, entry->pin);
+			else
+				io_apic_eoi(entry->apic, cfg->vector);
+		} else {
+			__mask_and_edge_IO_APIC_irq(entry);
+			__unmask_and_level_IO_APIC_irq(entry);
+		}
+	}
+}
+
+static void eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2525,6 +2586,19 @@ static void ack_apic_level(unsigned int irq)
 	 * level-triggered interrupt.  We mask the source for the time of the
 	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
 	 * The idea is from Manfred Spraul.  --macro
+	 *
+	 * Also in the case when cpu goes offline, fixup_irqs() will forward
+	 * any unhandled interrupt on the offlined cpu to the new cpu
+	 * destination that is handling the corresponding interrupt. This
+	 * interrupt forwarding is done via IPI's. Hence, in this case also
+	 * level-triggered io-apic interrupt will be seen as an edge
+	 * interrupt in the IRR. And we can't rely on the cpu's EOI
+	 * to be broadcasted to the IO-APIC's which will clear the remoteIRR
+	 * corresponding to the level-triggered interrupt. Hence on IO-APIC's
+	 * supporting EOI register, we do an explicit EOI to clear the
+	 * remote IRR and on IO-APIC's which don't have an EOI register,
+	 * we use the above logic (mask+edge followed by unmask+level) from
+	 * Manfred Spraul to clear the remote IRR.
 	 */
 	cfg = desc->chip_data;
 	i = cfg->vector;
@@ -2536,6 +2610,19 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	/*
+	 * Tail end of clearing remote IRR bit (either by delivering the EOI
+	 * message via io-apic EOI register write or simulating it using
+	 * mask+edge followed by unnask+level logic) manually when the
+	 * level triggered interrupt is seen as the edge triggered interrupt
+	 * at the cpu.
+	 */
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+
+		eoi_ioapic_irq(desc);
+	}
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2569,41 +2656,9 @@ static void ack_apic_level(unsigned int irq)
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq_desc(desc);
 	}
-
-	/* Tail end of version 0x11 I/O APIC bug workaround */
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(cfg);
-		__unmask_and_level_IO_APIC_irq(cfg);
-		spin_unlock(&ioapic_lock);
-	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-
-	for_each_irq_pin(entry, cfg->irq_2_pin)
-		io_apic_eoi(entry->apic, entry->pin);
-}
-
-static void
-eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ir_ack_apic_edge(unsigned int irq)
 {
 	ack_APIC_irq();
@@ -3157,6 +3212,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
+		cfg_new = desc_new->chip_data;
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
@@ -3708,75 +3764,6 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 }
 #endif /* CONFIG_HT_IRQ */
 
-#ifdef CONFIG_X86_UV
-/*
- * Re-target the irq to the specified CPU and enable the specified MMR located
- * on the specified blade to allow the sending of MSIs to the specified CPU.
- */
-int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset)
-{
-	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_cfg *cfg;
-	int mmr_pnode;
-	unsigned long mmr_value;
-	struct uv_IO_APIC_route_entry *entry;
-	unsigned long flags;
-	int err;
-
-	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	cfg = irq_cfg(irq);
-
-	err = assign_irq_vector(irq, cfg, eligible_cpu);
-	if (err != 0)
-		return err;
-
-	spin_lock_irqsave(&vector_lock, flags);
-	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
-				      irq_name);
-	spin_unlock_irqrestore(&vector_lock, flags);
-
-	mmr_value = 0;
-	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	entry->vector		= cfg->vector;
-	entry->delivery_mode	= apic->irq_delivery_mode;
-	entry->dest_mode	= apic->irq_dest_mode;
-	entry->polarity		= 0;
-	entry->trigger		= 0;
-	entry->mask		= 0;
-	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
-
-	mmr_pnode = uv_blade_to_pnode(mmr_blade);
-	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
-
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	return irq;
-}
-
-/*
- * Disable the specified MMR located on the specified blade so that MSIs are
- * longer allowed to be sent.
- */
-void arch_disable_uv_irq(int mmr_blade, unsigned long mmr_offset)
-{
-	unsigned long mmr_value;
-	struct uv_IO_APIC_route_entry *entry;
-	int mmr_pnode;
-
-	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	mmr_value = 0;
-	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	entry->mask = 1;
-
-	mmr_pnode = uv_blade_to_pnode(mmr_blade);
-	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
-}
-#endif /* CONFIG_X86_64 */
-
 int __init io_apic_get_redir_entries (int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3944,7 +3931,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 */
 
 	if (physids_empty(apic_id_map))
-		apic_id_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
+		apic->ioapic_phys_id_map(&phys_cpu_present_map, &apic_id_map);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic, 0);
@@ -3960,10 +3947,10 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 * Every APIC in a system must have a unique ID or we get lots of nice
 	 * 'stuck on smp_invalidate_needed IPI wait' messages.
 	 */
-	if (apic->check_apicid_used(apic_id_map, apic_id)) {
+	if (apic->check_apicid_used(&apic_id_map, apic_id)) {
 
 		for (i = 0; i < get_physical_broadcast(); i++) {
-			if (!apic->check_apicid_used(apic_id_map, i))
+			if (!apic->check_apicid_used(&apic_id_map, i))
 				break;
 		}
 
@@ -3976,7 +3963,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 		apic_id = i;
 	}
 
-	tmp = apic->apicid_to_cpu_present(apic_id);
+	apic->apicid_to_cpu_present(apic_id, &tmp);
 	physids_or(apic_id_map, apic_id_map, tmp);
 
 	if (reg_00.bits.ID != apic_id) {
@@ -4106,7 +4093,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	for (i = 0; i < nr_ioapics; i++) {
 		res[i].name = mem;
 		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		sprintf(mem,  "IOAPIC %u", i);
+		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 	}
 
@@ -4140,18 +4127,17 @@ void __init ioapic_init_mappings(void)
 #ifdef CONFIG_X86_32
 fake_ioapic_page:
 #endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %08lx (%08lx)\n",
-			    __fix_to_virt(idx), ioapic_phys);
+		apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
+			__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+			ioapic_phys);
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
 }
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..07cdbdc 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -334,10 +334,9 @@ static inline const struct cpumask *numaq_target_cpus(void)
 	return cpu_all_mask;
 }
 
-static inline unsigned long
-numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long numaq_check_apicid_used(physid_mask_t *map, int apicid)
 {
-	return physid_isset(apicid, bitmap);
+	return physid_isset(apicid, *map);
 }
 
 static inline unsigned long numaq_check_apicid_present(int bit)
@@ -371,10 +370,10 @@ static inline int numaq_multi_timer_check(int apic, int irq)
 	return apic != 0 && irq == 0;
 }
 
-static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
+static inline void numaq_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* We don't have a good way to do this yet - hack */
-	return physids_promote(0xFUL);
+	return physids_promote(0xFUL, retmap);
 }
 
 static inline int numaq_cpu_to_logical_apicid(int cpu)
@@ -402,12 +401,12 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 	return logical_apicid >> 4;
 }
 
-static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
+static void numaq_apicid_to_cpu_present(int logical_apicid, physid_mask_t *retmap)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
 	int cpu = __ffs(logical_apicid & 0xf);
 
-	return physid_mask_of_physid(cpu + 4*node);
+	physid_set_mask_of_physid(cpu + 4*node, retmap);
 }
 
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0c0182c..1a6559f 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -108,7 +108,7 @@ struct apic apic_default = {
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 645ecc4..9b41926 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -183,7 +183,7 @@ static const struct cpumask *summit_target_cpus(void)
 	return cpumask_of(0);
 }
 
-static unsigned long summit_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long summit_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
@@ -261,15 +261,15 @@ static int summit_cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static physid_mask_t summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
+static void summit_ioapic_phys_id_map(physid_mask_t *phys_id_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0x0F);
+	physids_promote(0x0FL, retmap);
 }
 
-static physid_mask_t summit_apicid_to_cpu_present(int apicid)
+static void summit_apicid_to_cpu_present(int apicid, physid_mask_t *retmap)
 {
-	return physid_mask_of_physid(0);
+	physid_set_mask_of_physid(0, retmap);
 }
 
 static int summit_check_phys_apicid_present(int physical_apicid)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..6d42549 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -409,6 +409,12 @@ static __init void map_mmioh_high(int max_pnode)
 		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
+static __init void map_low_mmrs(void)
+{
+	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
+	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
+}
+
 static __init void uv_rtc_init(void)
 {
 	long status;
@@ -550,6 +556,8 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
+	map_low_mmrs();
+
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fab786f..898df97 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -712,7 +712,7 @@ static void probe_nmi_watchdog(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..8a82728 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -276,3 +276,93 @@ void smp_generic_interrupt(struct pt_regs *regs)
 }
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
+
+#ifdef CONFIG_HOTPLUG_CPU
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
+{
+	unsigned int irq, vector;
+	static int warned;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(irq, desc) {
+		int break_affinity = 0;
+		int set_affinity = 1;
+		const struct cpumask *affinity;
+
+		if (!desc)
+			continue;
+		if (irq == 2)
+			continue;
+
+		/* interrupt's are disabled at this point */
+		spin_lock(&desc->lock);
+
+		affinity = desc->affinity;
+		if (!irq_has_action(irq) ||
+		    cpumask_equal(affinity, cpu_online_mask)) {
+			spin_unlock(&desc->lock);
+			continue;
+		}
+
+		/*
+		 * Complete the irq move. This cpu is going down and for
+		 * non intr-remapping case, we can't wait till this interrupt
+		 * arrives at this cpu before completing the irq move.
+		 */
+		irq_force_complete_move(irq);
+
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+			break_affinity = 1;
+			affinity = cpu_all_mask;
+		}
+
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
+			desc->chip->mask(irq);
+
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, affinity);
+		else if (!(warned++))
+			set_affinity = 0;
+
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
+			desc->chip->unmask(irq);
+
+		spin_unlock(&desc->lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
+			printk("Cannot set affinity for irq %i\n", irq);
+	}
+
+	/*
+	 * We can remove mdelay() and then send spuriuous interrupts to
+	 * new cpu targets for all the irqs that were handled previously by
+	 * this cpu. While it works, I have seen spurious interrupt messages
+	 * (nothing wrong but still...).
+	 *
+	 * So for now, retain mdelay(1) and check the IRR and then send those
+	 * interrupts to new targets as this cpu is already offlined...
+	 */
+	mdelay(1);
+
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned int irr;
+
+		if (__get_cpu_var(vector_irq)[vector] < 0)
+			continue;
+
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		if (irr  & (1 << (vector % 32))) {
+			irq = __get_cpu_var(vector_irq)[vector];
+
+			desc = irq_to_desc(irq);
+			spin_lock(&desc->lock);
+			if (desc->chip->retrigger)
+				desc->chip->retrigger(irq);
+			spin_unlock(&desc->lock);
+		}
+	}
+}
+#endif
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7d35d0f..10709f2 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -211,48 +211,3 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 
 	return true;
 }
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		affinity = desc->affinity;
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			printk("Breaking affinity for irq %i\n", irq);
-			affinity = cpu_all_mask;
-		}
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action)
-			printk_once("Cannot set affinity for irq %i\n", irq);
-	}
-
-#if 0
-	barrier();
-	/* Ingo Molnar says: "after the IO-APIC masks have been redirected
-	   [note the nop - the interrupt-enable boundary on x86 is two
-	   instructions from sti] - to flush out pending hardirqs and
-	   IPIs. After this point nothing is supposed to reach this CPU." */
-	__asm__ __volatile__("sti; nop; cli");
-	barrier();
-#else
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-#endif
-}
-#endif
-
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 977d8b4..acf8fbf 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -62,64 +62,6 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	static int warned;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		int break_affinity = 0;
-		int set_affinity = 1;
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		/* interrupt's are disabled at this point */
-		spin_lock(&desc->lock);
-
-		affinity = desc->affinity;
-		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
-			spin_unlock(&desc->lock);
-			continue;
-		}
-
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			break_affinity = 1;
-			affinity = cpu_all_mask;
-		}
-
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (!(warned++))
-			set_affinity = 0;
-
-		if (desc->chip->unmask)
-			desc->chip->unmask(irq);
-
-		spin_unlock(&desc->lock);
-
-		if (break_affinity && set_affinity)
-			printk("Broke affinity for irq %i\n", irq);
-		else if (!set_affinity)
-			printk("Cannot set affinity for irq %i\n", irq);
-	}
-
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-}
-#endif
 
 extern void call_softirq(void);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 565ebc6..324f2a4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1250,16 +1250,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
-	/*
-	 * HACK:
-	 * Allow any queued timer interrupts to get serviced
-	 * This is only a temporary solution until we cleanup
-	 * fixup_irqs as we do for IA64.
-	 */
-	local_irq_enable();
-	mdelay(1);
 
-	local_irq_disable();
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index aeef529..61d805d 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -9,10 +9,25 @@
  */
 
 #include <linux/module.h>
+#include <linux/rbtree.h>
 #include <linux/irq.h>
 
 #include <asm/apic.h>
 #include <asm/uv/uv_irq.h>
+#include <asm/uv/uv_hub.h>
+
+/* MMR offset and pnode of hub sourcing interrupts for a given irq */
+struct uv_irq_2_mmr_pnode{
+	struct rb_node		list;
+	unsigned long		offset;
+	int			pnode;
+	int			irq;
+};
+
+static spinlock_t		uv_irq_lock;
+static struct rb_root		uv_irq_root;
+
+static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
 
 static void uv_noop(unsigned int irq)
 {
@@ -39,25 +54,214 @@ struct irq_chip uv_irq_chip = {
 	.unmask		= uv_noop,
 	.eoi		= uv_ack_apic,
 	.end		= uv_noop,
+	.set_affinity	= uv_set_irq_affinity,
 };
 
 /*
+ * Add offset and pnode information of the hub sourcing interrupts to the
+ * rb tree for a specific irq.
+ */
+static int uv_set_irq_2_mmr_info(int irq, unsigned long offset, unsigned blade)
+{
+	struct rb_node **link = &uv_irq_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct uv_irq_2_mmr_pnode *n;
+	struct uv_irq_2_mmr_pnode *e;
+	unsigned long irqflags;
+
+	n = kmalloc_node(sizeof(struct uv_irq_2_mmr_pnode), GFP_KERNEL,
+				uv_blade_to_memory_nid(blade));
+	if (!n)
+		return -ENOMEM;
+
+	n->irq = irq;
+	n->offset = offset;
+	n->pnode = uv_blade_to_pnode(blade);
+	spin_lock_irqsave(&uv_irq_lock, irqflags);
+	/* Find the right place in the rbtree: */
+	while (*link) {
+		parent = *link;
+		e = rb_entry(parent, struct uv_irq_2_mmr_pnode, list);
+
+		if (unlikely(irq == e->irq)) {
+			/* irq entry exists */
+			e->pnode = uv_blade_to_pnode(blade);
+			e->offset = offset;
+			spin_unlock_irqrestore(&uv_irq_lock, irqflags);
+			kfree(n);
+			return 0;
+		}
+
+		if (irq < e->irq)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	/* Insert the node into the rbtree. */
+	rb_link_node(&n->list, parent, link);
+	rb_insert_color(&n->list, &uv_irq_root);
+
+	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
+	return 0;
+}
+
+/* Retrieve offset and pnode information from the rb tree for a specific irq */
+int uv_irq_2_mmr_info(int irq, unsigned long *offset, int *pnode)
+{
+	struct uv_irq_2_mmr_pnode *e;
+	struct rb_node *n;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&uv_irq_lock, irqflags);
+	n = uv_irq_root.rb_node;
+	while (n) {
+		e = rb_entry(n, struct uv_irq_2_mmr_pnode, list);
+
+		if (e->irq == irq) {
+			*offset = e->offset;
+			*pnode = e->pnode;
+			spin_unlock_irqrestore(&uv_irq_lock, irqflags);
+			return 0;
+		}
+
+		if (irq < e->irq)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
+	return -1;
+}
+
+/*
+ * Re-target the irq to the specified CPU and enable the specified MMR located
+ * on the specified blade to allow the sending of MSIs to the specified CPU.
+ */
+static int
+arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
+		       unsigned long mmr_offset, int restrict)
+{
+	const struct cpumask *eligible_cpu = cpumask_of(cpu);
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg;
+	int mmr_pnode;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	int err;
+
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
+			sizeof(unsigned long));
+
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, eligible_cpu);
+	if (err != 0)
+		return err;
+
+	if (restrict == UV_AFFINITY_CPU)
+		desc->status |= IRQ_NO_BALANCING;
+	else
+		desc->status |= IRQ_MOVE_PCNTXT;
+
+	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
+				      irq_name);
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	entry->vector		= cfg->vector;
+	entry->delivery_mode	= apic->irq_delivery_mode;
+	entry->dest_mode	= apic->irq_dest_mode;
+	entry->polarity		= 0;
+	entry->trigger		= 0;
+	entry->mask		= 0;
+	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return irq;
+}
+
+/*
+ * Disable the specified MMR located on the specified blade so that MSIs are
+ * longer allowed to be sent.
+ */
+static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
+{
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
+			sizeof(unsigned long));
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	entry->mask = 1;
+
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+}
+
+static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
+	unsigned int dest;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	unsigned long mmr_offset;
+	unsigned mmr_pnode;
+
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
+		return -1;
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+
+	entry->vector		= cfg->vector;
+	entry->delivery_mode	= apic->irq_delivery_mode;
+	entry->dest_mode	= apic->irq_dest_mode;
+	entry->polarity		= 0;
+	entry->trigger		= 0;
+	entry->mask		= 0;
+	entry->dest		= dest;
+
+	/* Get previously stored MMR and pnode of hub sourcing interrupts */
+	if (uv_irq_2_mmr_info(irq, &mmr_offset, &mmr_pnode))
+		return -1;
+
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return 0;
+}
+
+/*
  * Set up a mapping of an available irq and vector, and enable the specified
  * MMR that defines the MSI that is to be sent to the specified CPU when an
  * interrupt is raised.
  */
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
-		 unsigned long mmr_offset)
+		 unsigned long mmr_offset, int restrict)
 {
-	int irq;
-	int ret;
+	int irq, ret;
+
+	irq = create_irq_nr(NR_IRQS_LEGACY, uv_blade_to_memory_nid(mmr_blade));
 
-	irq = create_irq();
 	if (irq <= 0)
 		return -EBUSY;
 
-	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset);
-	if (ret != irq)
+	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
+		restrict);
+	if (ret == irq)
+		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
+	else
 		destroy_irq(irq);
 
 	return ret;
@@ -71,9 +275,28 @@ EXPORT_SYMBOL_GPL(uv_setup_irq);
  *
  * Set mmr_blade and mmr_offset to what was passed in on uv_setup_irq().
  */
-void uv_teardown_irq(unsigned int irq, int mmr_blade, unsigned long mmr_offset)
+void uv_teardown_irq(unsigned int irq)
 {
-	arch_disable_uv_irq(mmr_blade, mmr_offset);
+	struct uv_irq_2_mmr_pnode *e;
+	struct rb_node *n;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&uv_irq_lock, irqflags);
+	n = uv_irq_root.rb_node;
+	while (n) {
+		e = rb_entry(n, struct uv_irq_2_mmr_pnode, list);
+		if (e->irq == irq) {
+			arch_disable_uv_irq(e->pnode, e->offset);
+			rb_erase(n, &uv_irq_root);
+			kfree(e);
+			break;
+		}
+		if (irq < e->irq)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
 	destroy_irq(irq);
 }
 EXPORT_SYMBOL_GPL(uv_teardown_irq);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..cff70c8 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -183,7 +183,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 		return;
 	}
 
-	apic_cpus = apic->apicid_to_cpu_present(m->apicid);
+	apic->apicid_to_cpu_present(m->apicid, &apic_cpus);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..9d7ce96 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -136,7 +136,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
@@ -170,7 +170,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index c76677a..b5bbe59 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -106,7 +106,8 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq, int cpu, char *irq_name)
 	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
 
 #if defined CONFIG_X86_64
-	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset);
+	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
+			UV_AFFINITY_CPU);
 	if (mq->irq < 0) {
 		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
 			-mq->irq);
@@ -136,7 +137,7 @@ static void
 xpc_release_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq)
 {
 #if defined CONFIG_X86_64
-	uv_teardown_irq(mq->irq, mq->mmr_blade, mq->mmr_offset);
+	uv_teardown_irq(mq->irq);
 
 #elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
 	int mmr_pnode;
