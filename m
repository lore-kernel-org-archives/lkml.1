Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0CBXBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:01:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:52838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0CBXBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:01:38 -0500
Date: Tue, 2 Mar 2010 22:58:54 GMT
Message-Id: <201003022258.o22MwsOK030412@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/irq and x86/apic changes for v2.6.34
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alok N Kataria <akataria@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <bphilips@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Gary Hade <garyhade@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jiri Slaby <jslaby@suse.cz>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ollie Wild <aaw@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
       Tony Luck <tony.luck@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Zach Amsden <zach@vmware.com>, Len Brown <len.brown@intel.com>,
       stable@kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 22:58:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The APIC- and IRQ-related changes from the x86 tree for v2.6.34 are
available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

Brandon Phiilps (1):
      x86: Avoid race condition in pci_enable_msix()

Brandon Philips (1):
      x86, irq: Keep chip_data in create_irq_nr and destroy_irq

Eric W. Biederman (2):
      xen: Remove unnecessary arch specific xen irq functions.
      x86: Fix out of order of gsi

H. Peter Anvin (4):
      x86, apic: Reclaim IDT vectors 0x20-0x2f
      x86, apic: Don't waste a vector to improve vector spread
      Merge branch 'x86/urgent' into x86/irq
      Merge branch 'x86/irq' into x86/apic

Ingo Molnar (1):
      x86: apic: Fix mismerge, add arch_probe_nr_irqs() again

Jiri Slaby (1):
      x86, ia32_aout: do not kill argument mapping

Justin P. Mattock (1):
      x86: Add iMac9,1 to pci_reboot_dmi_table

Suresh Siddha (5):
      x86, vmi: Fix vmi_get_timer_vector() to use IRQ0_VECTOR
      x86, irq: Use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
      x86, irq: Don't block IRQ0_VECTOR..IRQ15_VECTOR's on all cpu's
      x86, irq: Update the vector domain for legacy irqs handled by io-apic
      x86, irq: Move __setup_vector_irq() before the first irq enable in cpu online path

Thomas Gleixner (3):
      x86: Convert ioapic_lock and vector_lock to raw_spinlock
      x86: Convert nmi_lock to raw_spinlock
      x86: Convert i8259_lock to raw_spinlock

Yinghai Lu (8):
      x86: Increase NR_IRQS and nr_irqs
      x86: Fix SCI on IOAPIC != 0
      irq: Remove unnecessary bootmem code
      init: Move radix_tree_init() early
      sparseirq: Change irq_desc_ptrs to static
      sparseirq: Use radix_tree instead of ptrs array
      x86, irq: Remove arch_probe_nr_irqs
      smp: Use nr_cpus= to set nr_cpu_ids early

 Documentation/kernel-parameters.txt |    6 +
 arch/ia64/include/asm/xen/events.h  |    4 -
 arch/ia64/kernel/acpi.c             |    4 +-
 arch/x86/ia32/ia32_aout.c           |    1 -
 arch/x86/include/asm/i8259.h        |    2 +-
 arch/x86/include/asm/io_apic.h      |    1 +
 arch/x86/include/asm/irq.h          |    1 +
 arch/x86/include/asm/irq_vectors.h  |   48 +++----
 arch/x86/include/asm/system.h       |    4 +-
 arch/x86/kernel/acpi/boot.c         |   14 +-
 arch/x86/kernel/apic/apic.c         |   17 ---
 arch/x86/kernel/apic/io_apic.c      |  258 ++++++++++++++++++++---------------
 arch/x86/kernel/apic/nmi.c          |    6 +-
 arch/x86/kernel/apic/probe_32.c     |   29 ++++-
 arch/x86/kernel/apic/probe_64.c     |    2 +-
 arch/x86/kernel/i8259.c             |   30 ++--
 arch/x86/kernel/irqinit.c           |   35 +++---
 arch/x86/kernel/mpparse.c           |    7 -
 arch/x86/kernel/reboot.c            |    8 +
 arch/x86/kernel/smpboot.c           |   15 ++-
 arch/x86/kernel/time.c              |    4 +-
 arch/x86/kernel/visws_quirks.c      |    6 +-
 arch/x86/kernel/vmiclock_32.c       |    6 +-
 arch/x86/mm/gup.c                   |    2 +-
 drivers/acpi/numa.c                 |    4 +-
 drivers/char/agp/amd64-agp.c        |    5 +-
 drivers/xen/events.c                |    8 +-
 include/linux/irq.h                 |    2 +
 init/main.c                         |   16 ++-
 kernel/irq/chip.c                   |   52 ++++++--
 kernel/irq/handle.c                 |   58 ++++----
 kernel/irq/internals.h              |    6 +-
 kernel/irq/numa_migrate.c           |    4 +-
 33 files changed, 380 insertions(+), 285 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fbcddc5..d80930d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1794,6 +1794,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
 
+	nr_cpus=	[SMP] Maximum number of processors that	an SMP kernel
+			could support.  nr_cpus=n : n >= 1 limits the kernel to
+			supporting 'n' processors. Later in runtime you can not
+			use hotplug cpu feature to put more cpu back to online.
+			just like you compile the kernel NR_CPUS=n
+
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
diff --git a/arch/ia64/include/asm/xen/events.h b/arch/ia64/include/asm/xen/events.h
index b8370c8..baa74c8 100644
--- a/arch/ia64/include/asm/xen/events.h
+++ b/arch/ia64/include/asm/xen/events.h
@@ -36,10 +36,6 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
 	return !(ia64_psr(regs)->i);
 }
 
-static inline void handle_irq(int irq, struct pt_regs *regs)
-{
-	__do_IRQ(irq);
-}
 #define irq_ctx_init(cpu)	do { } while (0)
 
 #endif /* _ASM_IA64_XEN_EVENTS_H */
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c16fb03..a7ca07f 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -852,8 +852,8 @@ __init void prefill_possible_map(void)
 
 	possible = available_cpus + additional_cpus;
 
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (possible > nr_cpu_ids)
+		possible = nr_cpu_ids;
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max((possible - available_cpus), 0));
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 9046e4a..280c019 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -327,7 +327,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 58d7091..7ec65b1 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -24,7 +24,7 @@ extern unsigned int cached_irq_mask;
 #define SLAVE_ICW4_DEFAULT	0x01
 #define PIC_ICW4_AEOI		2
 
-extern spinlock_t i8259A_lock;
+extern raw_spinlock_t i8259A_lock;
 
 extern void init_8259A(int auto_eoi);
 extern void enable_8259A_irq(unsigned int irq);
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c7c16c..5f61f6e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -160,6 +160,7 @@ extern int io_apic_get_redir_entries(int ioapic);
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
+void setup_IO_APIC_irq_extra(u32 gsi);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..2622927 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -48,5 +48,6 @@ extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
+extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4611f08..8767d99 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -28,28 +28,33 @@
 #define MCE_VECTOR			0x12
 
 /*
- * IDT vectors usable for external interrupt sources start
- * at 0x20:
+ * IDT vectors usable for external interrupt sources start at 0x20.
+ * (0x80 is the syscall vector, 0x30-0x3f are for ISA)
  */
 #define FIRST_EXTERNAL_VECTOR		0x20
-
-#ifdef CONFIG_X86_32
-# define SYSCALL_VECTOR			0x80
-# define IA32_SYSCALL_VECTOR		0x80
-#else
-# define IA32_SYSCALL_VECTOR		0x80
-#endif
+/*
+ * We start allocating at 0x21 to spread out vectors evenly between
+ * priority levels. (0x80 is the syscall vector)
+ */
+#define VECTOR_OFFSET_START		1
 
 /*
- * Reserve the lowest usable priority level 0x20 - 0x2f for triggering
- * cleanup after irq migration.
+ * Reserve the lowest usable vector (and hence lowest priority)  0x20 for
+ * triggering cleanup after irq migration. 0x21-0x2f will still be used
+ * for device interrupts.
  */
 #define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
+#define IA32_SYSCALL_VECTOR		0x80
+#ifdef CONFIG_X86_32
+# define SYSCALL_VECTOR			0x80
+#endif
+
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
+ *   round up to the next 16-vector boundary
  */
-#define IRQ0_VECTOR			(FIRST_EXTERNAL_VECTOR + 0x10)
+#define IRQ0_VECTOR			((FIRST_EXTERNAL_VECTOR + 16) & ~15)
 
 #define IRQ1_VECTOR			(IRQ0_VECTOR +  1)
 #define IRQ2_VECTOR			(IRQ0_VECTOR +  2)
@@ -120,13 +125,6 @@
  */
 #define MCE_SELF_VECTOR			0xeb
 
-/*
- * First APIC vector available to drivers: (vectors 0x30-0xee) we
- * start at 0x31(0x41) to spread out vectors evenly between priority
- * levels. (0x80 is the syscall vector)
- */
-#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 2)
-
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
@@ -154,21 +152,21 @@ static inline int invalid_vm86_irq(int irq)
 
 #define NR_IRQS_LEGACY			  16
 
-#define CPU_VECTOR_LIMIT		(  8 * NR_CPUS      )
 #define IO_APIC_VECTOR_LIMIT		( 32 * MAX_IO_APICS )
 
 #ifdef CONFIG_X86_IO_APIC
 # ifdef CONFIG_SPARSE_IRQ
+#  define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
 #  define NR_IRQS					\
 	(CPU_VECTOR_LIMIT > IO_APIC_VECTOR_LIMIT ?	\
 		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
 		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
 # else
-#  if NR_CPUS < MAX_IO_APICS
-#   define NR_IRQS 			(NR_VECTORS + 4*CPU_VECTOR_LIMIT)
-#  else
-#   define NR_IRQS			(NR_VECTORS + IO_APIC_VECTOR_LIMIT)
-#  endif
+#  define CPU_VECTOR_LIMIT		(32 * NR_CPUS)
+#  define NR_IRQS					\
+	(CPU_VECTOR_LIMIT < IO_APIC_VECTOR_LIMIT ?	\
+		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
+		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
 # endif
 #else /* !CONFIG_X86_IO_APIC: */
 # define NR_IRQS			NR_IRQS_LEGACY
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index f957030..738fcb6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -447,6 +447,12 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi;
+
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		setup_IO_APIC_irq_extra(gsi);
+#endif
+
 	return 0;
 }
 
@@ -474,7 +480,8 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	acpi_gsi_to_irq(plat_gsi, &irq);
+	irq = plat_gsi;
+
 	return irq;
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6bdd2c7..14862f1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -73,8 +73,8 @@
  */
 int sis_apic_bug = -1;
 
-static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+static DEFINE_RAW_SPINLOCK(ioapic_lock);
+static DEFINE_RAW_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -94,8 +94,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* Number of legacy interrupts */
-static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
@@ -140,27 +138,10 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[] = {
+static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 #else
-static struct irq_cfg irq_cfgx[NR_IRQS] = {
+static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
-	[0]  = { .vector = IRQ0_VECTOR,  },
-	[1]  = { .vector = IRQ1_VECTOR,  },
-	[2]  = { .vector = IRQ2_VECTOR,  },
-	[3]  = { .vector = IRQ3_VECTOR,  },
-	[4]  = { .vector = IRQ4_VECTOR,  },
-	[5]  = { .vector = IRQ5_VECTOR,  },
-	[6]  = { .vector = IRQ6_VECTOR,  },
-	[7]  = { .vector = IRQ7_VECTOR,  },
-	[8]  = { .vector = IRQ8_VECTOR,  },
-	[9]  = { .vector = IRQ9_VECTOR,  },
-	[10] = { .vector = IRQ10_VECTOR, },
-	[11] = { .vector = IRQ11_VECTOR, },
-	[12] = { .vector = IRQ12_VECTOR, },
-	[13] = { .vector = IRQ13_VECTOR, },
-	[14] = { .vector = IRQ14_VECTOR, },
-	[15] = { .vector = IRQ15_VECTOR, },
-};
 
 void __init io_apic_disable_legacy(void)
 {
@@ -185,8 +166,14 @@ int __init arch_early_irq_init(void)
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
-		if (i < nr_legacy_irqs)
-			cpumask_setall(cfg[i].domain);
+		/*
+		 * For legacy IRQ's, start with assigning irq0 to irq15 to
+		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
+		 */
+		if (i < nr_legacy_irqs) {
+			cfg[i].vector = IRQ0_VECTOR + i;
+			cpumask_set_cpu(0, cfg[i].domain);
+		}
 	}
 
 	return 0;
@@ -406,7 +393,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	struct irq_pin_list *entry;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		int pin;
@@ -415,11 +402,11 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
 		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			spin_unlock_irqrestore(&ioapic_lock, flags);
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return false;
 }
@@ -433,10 +420,10 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
 	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return eu.entry;
 }
 
@@ -459,9 +446,9 @@ __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(apic, pin, e);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 /*
@@ -474,10 +461,10 @@ static void ioapic_mask_entry(int apic, int pin)
 	unsigned long flags;
 	union entry_union eu = { .entry.mask = 1 };
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
 	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 /*
@@ -604,9 +591,9 @@ static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 
 	BUG_ON(!cfg);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__mask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
@@ -614,9 +601,9 @@ static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__unmask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void mask_IO_APIC_irq(unsigned int irq)
@@ -1140,12 +1127,12 @@ void lock_vector_lock(void)
 	/* Used to the online set of cpus does not change
 	 * during assign_irq_vector.
 	 */
-	spin_lock(&vector_lock);
+	raw_spin_lock(&vector_lock);
 }
 
 void unlock_vector_lock(void)
 {
-	spin_unlock(&vector_lock);
+	raw_spin_unlock(&vector_lock);
 }
 
 static int
@@ -1162,7 +1149,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
+	static int current_offset = VECTOR_OFFSET_START % 8;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
@@ -1198,7 +1186,7 @@ next:
 		if (vector >= first_system_vector) {
 			/* If out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
-			vector = FIRST_DEVICE_VECTOR + offset;
+			vector = FIRST_EXTERNAL_VECTOR + offset;
 		}
 		if (unlikely(current_vector == vector))
 			continue;
@@ -1232,9 +1220,9 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	int err;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	err = __assign_irq_vector(irq, cfg, mask);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
@@ -1268,11 +1256,16 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
-	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 
+	/*
+	 * vector_lock will make sure that we don't run into irq vector
+	 * assignments that might be happening on another cpu in parallel,
+	 * while we setup our initial vector to irq mappings.
+	 */
+	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
@@ -1291,6 +1284,7 @@ void __setup_vector_irq(int cpu)
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
+	raw_spin_unlock(&vector_lock);
 }
 
 static struct irq_chip ioapic_chip;
@@ -1440,6 +1434,14 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	cfg = desc->chip_data;
 
+	/*
+	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
+	 * controllers like 8259. Now that IO-APIC can handle this irq, update
+	 * the cfg->domain.
+	 */
+	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
+		apic->vector_allocation_domain(0, cfg->domain);
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
@@ -1473,7 +1475,7 @@ static struct {
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id = 0, pin, idx, irq;
+	int apic_id, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1481,14 +1483,7 @@ static void __init setup_IO_APIC_irqs(void)
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
-
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (idx == -1) {
@@ -1510,6 +1505,9 @@ static void __init setup_IO_APIC_irqs(void)
 
 		irq = pin_2_irq(idx, apic_id, pin);
 
+		if ((apic_id > 0) && (irq > 16))
+			continue;
+
 		/*
 		 * Skip the timer IRQ if there's a quirk handler
 		 * installed and if it returns 1:
@@ -1539,6 +1537,56 @@ static void __init setup_IO_APIC_irqs(void)
 }
 
 /*
+ * for the gsit that is not in first ioapic
+ * but could not use acpi_register_gsi()
+ * like some special sci in IBM x3330
+ */
+void setup_IO_APIC_irq_extra(u32 gsi)
+{
+	int apic_id = 0, pin, idx, irq;
+	int node = cpu_to_node(boot_cpu_id);
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	apic_id = mp_find_ioapic(gsi);
+	if (apic_id < 0)
+		return;
+
+	pin = mp_find_ioapic_pin(apic_id, gsi);
+	idx = find_irq_entry(apic_id, pin, mp_INT);
+	if (idx == -1)
+		return;
+
+	irq = pin_2_irq(idx, apic_id, pin);
+#ifdef CONFIG_SPARSE_IRQ
+	desc = irq_to_desc(irq);
+	if (desc)
+		return;
+#endif
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		return;
+	}
+
+	cfg = desc->chip_data;
+	add_pin_to_irq_node(cfg, node, apic_id, pin);
+
+	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[apic_id].apicid, pin);
+		return;
+	}
+	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+
+	setup_IO_APIC_irq(apic_id, pin, irq, desc,
+			irq_trigger(idx), irq_polarity(idx));
+}
+
+/*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
@@ -1601,14 +1649,14 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(apic, 0);
 	reg_01.raw = io_apic_read(apic, 1);
 	if (reg_01.bits.version >= 0x10)
 		reg_02.raw = io_apic_read(apic, 2);
 	if (reg_01.bits.version >= 0x20)
 		reg_03.raw = io_apic_read(apic, 3);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
@@ -1830,7 +1878,7 @@ __apicdebuginit(void) print_PIC(void)
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	v = inb(0xa1) << 8 | inb(0x21);
 	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
@@ -1844,7 +1892,7 @@ __apicdebuginit(void) print_PIC(void)
 	outb(0x0a,0xa0);
 	outb(0x0a,0x20);
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
 
@@ -1903,9 +1951,9 @@ void __init enable_IO_APIC(void)
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_01.raw = io_apic_read(apic, 1);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
 
@@ -2045,9 +2093,9 @@ void __init setup_ioapic_ids_from_mpc(void)
 	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
 
 		/* Read the register 0 value */
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		old_id = mp_ioapics[apic_id].apicid;
 
@@ -2106,16 +2154,16 @@ void __init setup_ioapic_ids_from_mpc(void)
 			mp_ioapics[apic_id].apicid);
 
 		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic_id, 0, reg_00.raw);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
 			printk("could not set ID!\n");
 		else
@@ -2198,7 +2246,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < nr_legacy_irqs) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
@@ -2206,7 +2254,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	}
 	cfg = irq_cfg(irq);
 	__unmask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
@@ -2217,9 +2265,9 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
 }
@@ -2312,14 +2360,14 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	irq = desc->irq;
 	cfg = desc->chip_data;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	ret = set_desc_affinity(desc, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return ret;
 }
@@ -2554,9 +2602,9 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 	irq = desc->irq;
 	cfg = desc->chip_data;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ack_apic_level(unsigned int irq)
@@ -3138,13 +3186,13 @@ static int ioapic_resume(struct sys_device *dev)
 	data = container_of(dev, struct sysfs_ioapic_data, dev);
 	entry = data->entry;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
 	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
 		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
 		ioapic_write_entry(dev->id, i, entry[i]);
 
@@ -3207,7 +3255,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	if (irq_want < nr_irqs_gsi)
 		irq_want = nr_irqs_gsi;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
 		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
@@ -3226,14 +3274,11 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 			irq = new;
 		break;
 	}
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	if (irq > 0)
+		dynamic_irq_init_keep_chip_data(irq);
 
-	if (irq > 0) {
-		dynamic_irq_init(irq);
-		/* restore it, in case dynamic_irq_init clear it */
-		if (desc_new)
-			desc_new->chip_data = cfg_new;
-	}
 	return irq;
 }
 
@@ -3255,20 +3300,13 @@ int create_irq(void)
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
-	/* store it, in case dynamic_irq_cleanup clear it */
-	desc = irq_to_desc(irq);
-	cfg = desc->chip_data;
-	dynamic_irq_cleanup(irq);
-	/* connect back irq_cfg */
-	desc->chip_data = cfg;
+	dynamic_irq_cleanup_keep_chip_data(irq);
 
 	free_irte(irq);
-	spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, cfg);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	__clear_irq_vector(irq, get_irq_chip_data(irq));
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
 /*
@@ -3805,9 +3843,9 @@ int __init io_apic_get_redir_entries (int ioapic)
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return reg_01.bits.entries;
 }
@@ -3969,9 +4007,9 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	if (physids_empty(apic_id_map))
 		apic->ioapic_phys_id_map(&phys_cpu_present_map, &apic_id_map);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic, 0);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	if (apic_id >= get_physical_broadcast()) {
 		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
@@ -4005,10 +4043,10 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	if (reg_00.bits.ID != apic_id) {
 		reg_00.bits.ID = apic_id;
 
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(ioapic, 0, reg_00.raw);
 		reg_00.raw = io_apic_read(ioapic, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/* Sanity check */
 		if (reg_00.bits.ID != apic_id) {
@@ -4029,9 +4067,9 @@ int __init io_apic_get_version(int ioapic)
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return reg_01.bits.version;
 }
@@ -4063,27 +4101,23 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic = 0, irq, irq_entry;
+	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		ioapic = mp_find_ioapic(0);
-		if (ioapic < 0)
-			ioapic = 0;
-	}
-#endif
-
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
 	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
 		irq = pin_2_irq(irq_entry, ioapic, pin);
 
+		if ((ioapic > 0) && (irq > 16))
+			continue;
+
 		desc = irq_to_desc(irq);
 
 		/*
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 0159a69..24e7742 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -416,13 +416,13 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
+		static DEFINE_RAW_SPINLOCK(lock); /* Serialise the printks */
 
-		spin_lock(&lock);
+		raw_spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
 		dump_stack();
-		spin_unlock(&lock);
+		raw_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
 		rc = 1;
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index df89102..8c93a84 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -32,7 +32,7 @@
  */
 
 static int i8259A_auto_eoi;
-DEFINE_SPINLOCK(i8259A_lock);
+DEFINE_RAW_SPINLOCK(i8259A_lock);
 static void mask_and_ack_8259A(unsigned int);
 
 struct irq_chip i8259A_chip = {
@@ -68,13 +68,13 @@ void disable_8259A_irq(unsigned int irq)
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask |= mask;
 	if (irq & 8)
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
 		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void enable_8259A_irq(unsigned int irq)
@@ -82,13 +82,13 @@ void enable_8259A_irq(unsigned int irq)
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask &= mask;
 	if (irq & 8)
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
 		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 int i8259A_irq_pending(unsigned int irq)
@@ -97,12 +97,12 @@ int i8259A_irq_pending(unsigned int irq)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	if (irq < 8)
 		ret = inb(PIC_MASTER_CMD) & mask;
 	else
 		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	return ret;
 }
@@ -150,7 +150,7 @@ static void mask_and_ack_8259A(unsigned int irq)
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	/*
 	 * Lightweight spurious IRQ detection. We do not want
 	 * to overdo spurious IRQ handling - it's usually a sign
@@ -183,7 +183,7 @@ handle_real_irq:
 		outb(cached_master_mask, PIC_MASTER_IMR);
 		outb(0x60+irq, PIC_MASTER_CMD);	/* 'Specific EOI to master */
 	}
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
 
 spurious_8259A_irq:
@@ -285,24 +285,24 @@ void mask_8259A(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void unmask_8259A(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void init_8259A(int auto_eoi)
@@ -311,7 +311,7 @@ void init_8259A(int auto_eoi)
 
 	i8259A_auto_eoi = auto_eoi;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
@@ -356,5 +356,5 @@ void init_8259A(int auto_eoi)
 	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d593222..fce55d5 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -84,24 +84,7 @@ static struct irqaction irq2 = {
 };
 
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
+	[0 ... NR_VECTORS - 1] = -1,
 };
 
 int vector_used_by_percpu_irq(unsigned int vector)
@@ -116,6 +99,9 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
+/* Number of legacy interrupts */
+int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
+
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -142,6 +128,19 @@ void __init init_ISA_irqs(void)
 
 void __init init_IRQ(void)
 {
+	int i;
+
+	/*
+	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
+	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
+	 * then this configuration will likely be static after the boot. If
+	 * these IRQ's are handled by more mordern controllers like IO-APIC,
+	 * then this vector space can be freed and re-used dynamically as the
+	 * irq's migrate etc.
+	 */
+	for (i = 0; i < nr_legacy_irqs; i++)
+		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
+
 	x86_init.irqs.intr_init();
 }
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 704bddc..8e1aac8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -461,6 +461,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9b44011..a435c76 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -241,6 +241,11 @@ static void __cpuinit smp_callin(void)
 	map_cpu_to_logical_apicid();
 
 	notify_cpu_starting(cpuid);
+
+	/*
+	 * Need to setup vector mappings before we enable interrupts.
+	 */
+	__setup_vector_irq(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
@@ -315,7 +320,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	ipi_call_lock();
 	lock_vector_lock();
-	__setup_vector_irq(smp_processor_id());
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
 	ipi_call_unlock();
@@ -1212,11 +1216,12 @@ __init void prefill_possible_map(void)
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
 
-	if (possible > CONFIG_NR_CPUS) {
+	/* nr_cpu_ids could be reduced via nr_cpus= */
+	if (possible > nr_cpu_ids) {
 		printk(KERN_WARNING
 			"%d Processors exceeds NR_CPUS limit of %d\n",
-			possible, CONFIG_NR_CPUS);
-		possible = CONFIG_NR_CPUS;
+			possible, nr_cpu_ids);
+		possible = nr_cpu_ids;
 	}
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index be25734..fb5cc5e 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -70,11 +70,11 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		 * manually to deassert NMI lines for the watchdog if run
 		 * on an 82489DX-based system.
 		 */
-		spin_lock(&i8259A_lock);
+		raw_spin_lock(&i8259A_lock);
 		outb(0x0c, PIC_MASTER_OCW3);
 		/* Ack the IRQ; AEOI will end it automatically. */
 		inb(PIC_MASTER_POLL);
-		spin_unlock(&i8259A_lock);
+		raw_spin_unlock(&i8259A_lock);
 	}
 
 	global_clock_event->event_handler(global_clock_event);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 34a279a..ab38ce0 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -559,7 +559,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	/* Find out what's interrupting in the PIIX4 master 8259 */
 	outb(0x0c, 0x20);		/* OCW3 Poll command */
@@ -596,7 +596,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 		outb(0x60 + realirq, 0x20);
 	}
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	desc = irq_to_desc(realirq);
 
@@ -614,7 +614,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 
 out_unlock:
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 	return IRQ_NONE;
 }
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 74c92bb..2f1ca56 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -79,11 +79,7 @@ unsigned long vmi_tsc_khz(void)
 
 static inline unsigned int vmi_get_timer_vector(void)
 {
-#ifdef CONFIG_X86_IO_APIC
-	return FIRST_DEVICE_VECTOR;
-#else
-	return FIRST_EXTERNAL_VECTOR;
-#endif
+	return IRQ0_VECTOR;
 }
 
 /** vmi clockchip */
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 7ad48df..b872546 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -279,9 +279,9 @@ int __init acpi_numa_init(void)
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				      acpi_parse_x2apic_affinity, NR_CPUS);
+				     acpi_parse_x2apic_affinity, nr_cpu_ids);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				      acpi_parse_processor_affinity, NR_CPUS);
+				     acpi_parse_processor_affinity, nr_cpu_ids);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..2f84137 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -649,9 +649,13 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 				int bit_idx = __ffs(pending_bits);
 				int port = (word_idx * BITS_PER_LONG) + bit_idx;
 				int irq = evtchn_to_irq[port];
+				struct irq_desc *desc;
 
-				if (irq != -1)
-					handle_irq(irq, regs);
+				if (irq != -1) {
+					desc = irq_to_desc(irq);
+					if (desc)
+						generic_handle_irq_desc(irq, desc);
+				}
 			}
 		}
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d13492d..707ab12 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -400,7 +400,9 @@ static inline int irq_has_action(unsigned int irq)
 
 /* Dynamic irq helper functions */
 extern void dynamic_irq_init(unsigned int irq);
+void dynamic_irq_init_keep_chip_data(unsigned int irq);
 extern void dynamic_irq_cleanup(unsigned int irq);
+void dynamic_irq_cleanup_keep_chip_data(unsigned int irq);
 
 /* Set/get chip/data for an IRQ: */
 extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
diff --git a/init/main.c b/init/main.c
index c75dcd6..1809815 100644
--- a/init/main.c
+++ b/init/main.c
@@ -149,6 +149,20 @@ static int __init nosmp(char *str)
 
 early_param("nosmp", nosmp);
 
+/* this is hard limit */
+static int __init nrcpus(char *str)
+{
+	int nr_cpus;
+
+	get_option(&str, &nr_cpus);
+	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
+		nr_cpu_ids = nr_cpus;
+
+	return 0;
+}
+
+early_param("nr_cpus", nrcpus);
+
 static int __init maxcpus(char *str)
 {
 	get_option(&str, &setup_max_cpus);
@@ -586,6 +600,7 @@ asmlinkage void __init start_kernel(void)
 		local_irq_disable();
 	}
 	rcu_init();
+	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
@@ -659,7 +674,6 @@ asmlinkage void __init start_kernel(void)
 	proc_caches_init();
 	buffer_init();
 	key_init();
-	radix_tree_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
 	signals_init();
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index ecc3fa2..d70394f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -18,11 +18,7 @@
 
 #include "internals.h"
 
-/**
- *	dynamic_irq_init - initialize a dynamically allocated irq
- *	@irq:	irq number to initialize
- */
-void dynamic_irq_init(unsigned int irq)
+static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -41,7 +37,8 @@ void dynamic_irq_init(unsigned int irq)
 	desc->depth = 1;
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -55,10 +52,26 @@ void dynamic_irq_init(unsigned int irq)
 }
 
 /**
- *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
+ *	dynamic_irq_init - initialize a dynamically allocated irq
  *	@irq:	irq number to initialize
  */
-void dynamic_irq_cleanup(unsigned int irq)
+void dynamic_irq_init(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, false);
+}
+
+/**
+ *	dynamic_irq_init_keep_chip_data - initialize a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ *
+ *	does not set irq_to_desc(irq)->chip_data to NULL
+ */
+void dynamic_irq_init_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, true);
+}
+
+static void dynamic_irq_cleanup_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -77,7 +90,8 @@ void dynamic_irq_cleanup(unsigned int irq)
 	}
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
 	desc->name = NULL;
@@ -85,6 +99,26 @@ void dynamic_irq_cleanup(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+/**
+ *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ */
+void dynamic_irq_cleanup(unsigned int irq)
+{
+	dynamic_irq_cleanup_x(irq, false);
+}
+
+/**
+ *	dynamic_irq_cleanup_keep_chip_data - cleanup a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ *
+ *	does not set irq_to_desc(irq)->chip_data to NULL
+ */
+void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_cleanup_x(irq, true);
+}
+
 
 /**
  *	set_irq_chip - set the irq chip for an irq
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 814940e..76d5a67 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -19,7 +19,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
-#include <linux/bootmem.h>
+#include <linux/radix-tree.h>
 #include <trace/events/irq.h>
 
 #include "internals.h"
@@ -87,12 +87,8 @@ void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
 	void *ptr;
 
-	if (slab_is_available())
-		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
-				   GFP_ATOMIC, node);
-	else
-		ptr = alloc_bootmem_node(NODE_DATA(node),
-				nr * sizeof(*desc->kstat_irqs));
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+			   GFP_ATOMIC, node);
 
 	/*
 	 * don't overwite if can not get new one
@@ -132,7 +128,26 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
  */
 DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 
-struct irq_desc **irq_desc_ptrs __read_mostly;
+static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
+
+static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	radix_tree_insert(&irq_desc_tree, irq, desc);
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return radix_tree_lookup(&irq_desc_tree, irq);
+}
+
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	void **ptr;
+
+	ptr = radix_tree_lookup_slot(&irq_desc_tree, irq);
+	if (ptr)
+		radix_tree_replace_slot(ptr, desc);
+}
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -164,9 +179,6 @@ int __init early_irq_init(void)
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 	node = first_online_node;
 
-	/* allocate irq_desc_ptrs array based on nr_irqs */
-	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
-
 	/* allocate based on nr_cpu_ids */
 	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
 					  sizeof(int), GFP_NOWAIT, node);
@@ -180,23 +192,12 @@ int __init early_irq_init(void)
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
 		init_desc_masks(&desc[i]);
-		irq_desc_ptrs[i] = desc + i;
+		set_irq_desc(i, &desc[i]);
 	}
 
-	for (i = legacy_count; i < nr_irqs; i++)
-		irq_desc_ptrs[i] = NULL;
-
 	return arch_early_irq_init();
 }
 
-struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	if (irq_desc_ptrs && irq < nr_irqs)
-		return irq_desc_ptrs[irq];
-
-	return NULL;
-}
-
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
@@ -208,21 +209,18 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 		return NULL;
 	}
 
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 	if (desc)
 		return desc;
 
 	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 	if (desc)
 		goto out_unlock;
 
-	if (slab_is_available())
-		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	else
-		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 
 	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
@@ -231,7 +229,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	}
 	init_one_irq_desc(irq, desc, node);
 
-	irq_desc_ptrs[irq] = desc;
+	set_irq_desc(irq, desc);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b2821f0..c63f3bc 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -21,11 +21,7 @@ extern void clear_kstat_irqs(struct irq_desc *desc);
 extern raw_spinlock_t sparse_irq_lock;
 
 #ifdef CONFIG_SPARSE_IRQ
-/* irq_desc_ptrs allocated at boot time */
-extern struct irq_desc **irq_desc_ptrs;
-#else
-/* irq_desc_ptrs is a fixed size array */
-extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc);
 #endif
 
 #ifdef CONFIG_PROC_FS
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 26bac9d..963559d 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -70,7 +70,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 
 	if (desc && old_desc != desc)
 		goto out_unlock;
@@ -90,7 +90,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 		goto out_unlock;
 	}
 
-	irq_desc_ptrs[irq] = desc;
+	replace_irq_desc(irq, desc);
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	/* free the old one */
