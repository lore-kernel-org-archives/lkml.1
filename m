Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbZFJVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbZFJVi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZFJViR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:38:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760890AbZFJViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:38:09 -0400
Date: Wed, 10 Jun 2009 23:37:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] IRQ changes for v2.6.31
Message-ID: <20090610213730.GA1142@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-for-linus

Quite branched out activities in this cycle: irq-desc/NUMA 
optimizations/cleanups, irqinit unification on x86, GSI cleanup, 
removal of irq-vector-compression hack - and more.

PCI IRQ changes were acked by Jesse, ACPI IRQ changes were acked by 
Len.

The ->set_affinity() genirq method prototype was changed, this 
touched a number of architectures, trivially. This branch had about 
three regressions.

 Thanks,

	Ingo

------------------>
Alexander van Heukelum (1):
      x86: fix function definitions after: x86: apic - introduce imcr_ helpers

Andreas Herrmann (1):
      x86: display extended apic registers with print_local_APIC and cpu_debug code

Cyrill Gorcunov (12):
      x86: irq.c - tiny cleanup
      x86: apic - introduce imcr_ helpers
      x86: apic - introduce dummy apic operations
      x86: smp.c - align smp_ops assignments
      x86: smpboot - wakeup_secondary should be done via __cpuinit section
      x86: es7000, uv - use __cpuinit for kicking secondary cpus
      x86, apic: use pr_ macro
      x86: uv io-apic - use BUILD_BUG_ON instead of BUG_ON
      x86: uv - prevent NULL dereference in uv_system_init()
      x86: apic: Fixmap apic address even if apic disabled
      x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector(), fix
      x86, apic: Fix dummy apic read operation together with broken MP handling

Gary Hade (1):
      x86: consolidate SMP code in io_apic.c

Ingo Molnar (2):
      x86, irqinit: preempt merge conflicts
      irq: change ->set_affinity() to return status, fix

Jaswinder Singh Rajput (1):
      x86: cpufeature.h fix name for X86_FEATURE_MCE

Jiri Slaby (1):
      x86, apic: Restore irqs on fail paths

Naga Chumbalkar (1):
      x86: Print real IOAPIC version for x86-64

Paul Mundt (1):
      sparseirq: Allow early irq_desc allocation

Pekka Enberg (13):
      x86: move x86_quirk_pre_intr_init() to irqinit_32.c
      x86: move init_ISA_irqs() in irqinit_32.c to match ordering in irqinit_64.c
      x86: introduce smp_intr_init() in irqinit_32.c
      x86: introduce apic_intr_init() in irqinit_32.c
      x86: use identical loop constructs in 32-bit and 64-bit native_init_IRQ()
      x86: unify smp_intr_init() in irqinit_{32,64}.h
      x86: unify init_ISA_irqs() in irqinit_{32,64}.c
      x86: unify native_init_IRQ() in irqinit_{32,64}.c
      x86: unify trivial differences in irqinit_{32,64}.c
      x86: unify apic_intr_init() in irqinit_{32,64}.c
      x86: unify irqinit_{32,64}.c into irqinit.c
      x86: define IA32_SYSCALL_VECTOR on 32-bit to reduce ifdefs
      x86: remove some ifdefs from native_init_IRQ()

Suresh Siddha (5):
      x86: x2apic, IR: Clean up X86_X2APIC and INTR_REMAP config checks
      x86: x2apic, IR: Move eoi_ioapic_irq() into a CONFIG_INTR_REMAP section
      x86: x2apic, IR: Clean up panic() with nox2apic boot option
      x86: x2apic, IR: Make config X86_UV dependent on X86_X2APIC
      x86: x2apic, IR: remove reinit_intr_remapped_IO_APIC()

Weidong Han (5):
      docs, x86: add nox2apic back to kernel-parameters.txt
      x86, intr-remap: fix ack for interrupt remapping
      x86, intr-remap: enable interrupt remapping early
      x86, intr-remap: add option to disable interrupt remapping
      x86, intr-remap: fix x2apic/intr-remap resume

Yinghai Lu (32):
      x86: make wakeup_secondary_cpu_via_init static
      x86: consistent about warm_reset_vector for UN_NON_UNIQUE_APIC
      x86: use used_vectors in init_IRQ()
      x86: apic: Remove duplicated macros
      x86: Use dmi check in apic_is_clustered() on 64-bit to mark the TSC unstable
      irq, cpumask: correct CPUMASKS_OFFSTACK typo and fix fallout
      x86/irq: remove leftover code from NUMA_MIGRATE_IRQ_DESC
      irq: change ->set_affinity() to return status
      irq: only update affinity if ->set_affinity() is sucessfull
      x86/irq: change irq_desc_alloc() to take node instead of cpu
      irq: change ACPI GSI APIs to also take a device argument
      irq: change io_apic_set_pci_routing() to use device parameter
      x86/irq: change MSI irq_desc to be more numa aware
      irq: make ht irq_desc more numa aware
      x86/irq: use move_irq_desc() in create_irq_nr()
      x86/acpi: remove irq-compression trick on 32-bit
      x86: fix alloc_mptable()
      x86/acpi: call mp_config_acpi_gsi() in mp_register_gsi()
      x86/acpi: move pin_programmed bit map to io_apic.c
      x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector()
      x86/acpi: move setup io apic routing out of CONFIG_ACPI scope
      x86/pci: update pirq_enable_irq() to setup io apic routing
      x86: apic: Check rev 3 fadt correctly for physical_apic bit
      x86: clean up and fix setup_clear/force_cpu_cap handling
      x86: read apic ID in the !acpi_lapic case
      x86: read apic ID in the !acpi_lapic case
      x86, apic: introduce io_apic_irq_attr
      x86: don't call read_apic_id if !cpu_has_apic
      x86, irq: update_mptable needs pci_routeirq
      x86, irq: don't call mp_config_acpi_gsi() if update_mptable is not enabled
      x86, io-apic: Don't mark pin_programmed early
      x86: enable_update_mptable should be a macro


 Documentation/kernel-parameters.txt         |    3 +
 arch/alpha/kernel/sys_dp264.c               |    8 +-
 arch/alpha/kernel/sys_titan.c               |    4 +-
 arch/arm/common/gic.c                       |    4 +-
 arch/cris/arch-v32/kernel/irq.c             |    4 +-
 arch/ia64/hp/sim/hpsim_irq.c                |    3 +-
 arch/ia64/kernel/acpi.c                     |    5 +-
 arch/ia64/kernel/iosapic.c                  |   10 +-
 arch/ia64/kernel/msi_ia64.c                 |   16 +-
 arch/ia64/sn/kernel/irq.c                   |    4 +-
 arch/ia64/sn/kernel/msi_sn.c                |    8 +-
 arch/mips/cavium-octeon/octeon-irq.c        |    8 +-
 arch/mips/include/asm/irq.h                 |    2 +-
 arch/mips/kernel/irq-gic.c                  |    5 +-
 arch/mips/mti-malta/malta-smtc.c            |    4 +-
 arch/mips/sibyte/bcm1480/irq.c              |    8 +-
 arch/mips/sibyte/sb1250/irq.c               |    8 +-
 arch/parisc/kernel/irq.c                    |    6 +-
 arch/powerpc/platforms/pseries/xics.c       |   12 +-
 arch/powerpc/sysdev/mpic.c                  |    4 +-
 arch/powerpc/sysdev/mpic.h                  |    2 +-
 arch/sparc/kernel/irq_64.c                  |   12 +-
 arch/x86/Kconfig                            |   12 +-
 arch/x86/configs/x86_64_defconfig           |    1 -
 arch/x86/include/asm/apic.h                 |   28 +-
 arch/x86/include/asm/apicdef.h              |    8 +-
 arch/x86/include/asm/cpufeature.h           |    6 +-
 arch/x86/include/asm/hw_irq.h               |   21 +-
 arch/x86/include/asm/i8259.h                |    4 -
 arch/x86/include/asm/io_apic.h              |    9 +-
 arch/x86/include/asm/irq_remapping.h        |    2 +-
 arch/x86/include/asm/irq_vectors.h          |    1 +
 arch/x86/include/asm/mpspec.h               |   15 +-
 arch/x86/include/asm/processor.h            |    3 +-
 arch/x86/include/asm/setup.h                |    1 -
 arch/x86/include/asm/smp.h                  |    2 +-
 arch/x86/kernel/Makefile                    |    2 +-
 arch/x86/kernel/acpi/boot.c                 |  156 ++---
 arch/x86/kernel/apic/apic.c                 |  311 ++++++----
 arch/x86/kernel/apic/apic_flat_64.c         |    4 +-
 arch/x86/kernel/apic/es7000_32.c            |    2 +-
 arch/x86/kernel/apic/io_apic.c              |  901 +++++++++++++--------------
 arch/x86/kernel/apic/probe_64.c             |    2 +-
 arch/x86/kernel/apic/summit_32.c            |    7 -
 arch/x86/kernel/apic/x2apic_uv_x.c          |    5 +-
 arch/x86/kernel/cpu/amd.c                   |    2 +-
 arch/x86/kernel/cpu/common.c                |   23 +-
 arch/x86/kernel/cpu/cpu_debug.c             |   14 +-
 arch/x86/kernel/cpu/intel.c                 |    6 +-
 arch/x86/kernel/irq.c                       |   19 +-
 arch/x86/kernel/{irqinit_32.c => irqinit.c} |  149 ++++--
 arch/x86/kernel/irqinit_64.c                |  177 ------
 arch/x86/kernel/mpparse.c                   |   34 +-
 arch/x86/kernel/setup.c                     |   18 -
 arch/x86/kernel/smp.c                       |   20 +-
 arch/x86/kernel/smpboot.c                   |   22 +-
 arch/x86/kernel/traps.c                     |    5 +-
 arch/x86/lguest/boot.c                      |    2 +-
 arch/x86/pci/irq.c                          |   84 +--
 drivers/acpi/pci_irq.c                      |    5 +-
 drivers/char/hpet.c                         |    4 +-
 drivers/parisc/iosapic.c                    |    6 +-
 drivers/pci/hotplug/ibmphp_core.c           |   54 +-
 drivers/pci/htirq.c                         |    4 +-
 drivers/pci/intel-iommu.c                   |    9 -
 drivers/pci/intr_remapping.c                |   54 +-
 drivers/pnp/pnpacpi/rsparser.c              |    2 +-
 drivers/xen/events.c                        |   14 +-
 include/linux/acpi.h                        |    2 +-
 include/linux/dmar.h                        |    3 +
 include/linux/interrupt.h                   |    2 +-
 include/linux/irq.h                         |   58 +-
 kernel/irq/Makefile                         |    2 +-
 kernel/irq/chip.c                           |   12 +-
 kernel/irq/handle.c                         |   58 +-
 kernel/irq/internals.h                      |    5 +-
 kernel/irq/manage.c                         |   17 +-
 kernel/irq/migration.c                      |   14 +-
 kernel/irq/numa_migrate.c                   |   38 +-
 kernel/softirq.c                            |    2 +-
 80 files changed, 1260 insertions(+), 1323 deletions(-)
 rename arch/x86/kernel/{irqinit_32.c => irqinit.c} (68%)
 delete mode 100644 arch/x86/kernel/irqinit_64.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd5cac0..11648c1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1575,6 +1575,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	noinitrd	[RAM] Tells the kernel not to load any configured
 			initial RAM disk.
 
+	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
+			remapping.
+
 	nointroute	[IA-64]
 
 	nojitter	[IA64] Disables jitter checking for ITC timers.
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 9c9d1fd..5bd5259 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -176,22 +176,26 @@ cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 	}
 }
 
-static void
+static int
 dp264_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
+
+	return 0;
 }
 
-static void
+static int
 clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq - 16, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
+
+	return 0;
 }
 
 static struct hw_interrupt_type dp264_irq_type = {
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 27f840a..8dd239e 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -157,13 +157,15 @@ titan_cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 
 }
 
-static void
+static int
 titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&titan_irq_lock);
 	titan_cpu_set_irq_affinity(irq - 16, *affinity);
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
+
+	return 0;
 }
 
 static void
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 3e1714c..664c7b8 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -109,7 +109,7 @@ static void gic_unmask_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
+static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
@@ -122,6 +122,8 @@ static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
 	spin_unlock(&irq_controller_lock);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index df3925c..d70b445 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -325,12 +325,14 @@ static void end_crisv32_irq(unsigned int irq)
 {
 }
 
-void set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
+int set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&irq_lock, flags);
 	irq_allocations[irq - FIRST_IRQ].mask = *dest;
 	spin_unlock_irqrestore(&irq_lock, flags);
+
+	return 0;
 }
 
 static struct irq_chip crisv32_irq_type = {
diff --git a/arch/ia64/hp/sim/hpsim_irq.c b/arch/ia64/hp/sim/hpsim_irq.c
index cc0a318..acb5047 100644
--- a/arch/ia64/hp/sim/hpsim_irq.c
+++ b/arch/ia64/hp/sim/hpsim_irq.c
@@ -21,9 +21,10 @@ hpsim_irq_noop (unsigned int irq)
 {
 }
 
-static void
+static int
 hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
 {
+	return 0;
 }
 
 static struct hw_interrupt_type irq_type_hp_sim = {
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 5510317..baec6f0 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -636,7 +636,7 @@ void __init acpi_numa_arch_fixup(void)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
 		return gsi;
@@ -678,7 +678,8 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
 	fadt = (struct acpi_table_fadt *)fadt_header;
 
-	acpi_register_gsi(fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW);
+	acpi_register_gsi(NULL, fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE,
+				 ACPI_ACTIVE_LOW);
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 166e0d8..f92cef4 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -329,7 +329,7 @@ unmask_irq (unsigned int irq)
 }
 
 
-static void
+static int
 iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
@@ -343,15 +343,15 @@ iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cpu = cpumask_first_and(cpu_online_mask, mask);
 	if (cpu >= nr_cpu_ids)
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	dest = cpu_physical_id(cpu);
 
 	if (!iosapic_intr_info[irq].count)
-		return;			/* not an IOSAPIC interrupt */
+		return -1;			/* not an IOSAPIC interrupt */
 
 	set_irq_affinity_info(irq, dest, redir);
 
@@ -376,7 +376,9 @@ iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 		iosapic_write(iosapic, IOSAPIC_RTE_HIGH(rte_index), high32);
 		iosapic_write(iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
+
 #endif
+	return 0;
 }
 
 /*
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 2b15e23..0f8ade9 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -12,7 +12,7 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static void ia64_set_msi_irq_affinity(unsigned int irq,
+static int ia64_set_msi_irq_affinity(unsigned int irq,
 				      const cpumask_t *cpu_mask)
 {
 	struct msi_msg msg;
@@ -20,10 +20,10 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 	int cpu = first_cpu(*cpu_mask);
 
 	if (!cpu_online(cpu))
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	read_msi_msg(irq, &msg);
 
@@ -39,6 +39,8 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -130,17 +132,17 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
 	int cpu = cpumask_first(mask);
 
 	if (!cpu_online(cpu))
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	dmar_msi_read(irq, &msg);
 
@@ -151,6 +153,8 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dmar_msi_write(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 66fd705..764f26a 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -227,7 +227,7 @@ finish_up:
 	return new_irq_info;
 }
 
-static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
+static int sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
@@ -239,6 +239,8 @@ static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
+
+	return 0;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 81e4289..fbbfb97 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -151,7 +151,7 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 }
 
 #ifdef CONFIG_SMP
-static void sn_set_msi_irq_affinity(unsigned int irq,
+static int sn_set_msi_irq_affinity(unsigned int irq,
 				    const struct cpumask *cpu_mask)
 {
 	struct msi_msg msg;
@@ -168,7 +168,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 	cpu = cpumask_first(cpu_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
-		return;
+		return -1;
 
 	/*
 	 * Release XIO resources for the old MSI PCI address
@@ -189,7 +189,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 	new_irq_info = sn_retarget_vector(sn_irq_info, nasid, slice);
 	sn_msi_info[irq].sn_irq_info = new_irq_info;
 	if (new_irq_info == NULL)
-		return;
+		return -1;
 
 	/*
 	 * Map the xio address into bus space
@@ -206,6 +206,8 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 1c19af8..d3a0c81 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -177,7 +177,7 @@ static void octeon_irq_ciu0_disable(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
@@ -199,6 +199,8 @@ static void octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
 	write_unlock(&octeon_irq_ciu0_rwlock);
+
+	return 0;
 }
 #endif
 
@@ -292,7 +294,7 @@ static void octeon_irq_ciu1_disable(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
@@ -315,6 +317,8 @@ static void octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1));
 	write_unlock(&octeon_irq_ciu1_rwlock);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 3214ade..4f1eed1 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -49,7 +49,7 @@ static inline void smtc_im_ack_irq(unsigned int irq)
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
 #include <linux/cpumask.h>
 
-extern void plat_set_irq_affinity(unsigned int irq,
+extern int plat_set_irq_affinity(unsigned int irq,
 				  const struct cpumask *affinity);
 extern void smtc_forward_irq(unsigned int irq);
 
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 87deb8f..3f43c2e 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -155,7 +155,7 @@ static void gic_unmask_irq(unsigned int irq)
 
 static DEFINE_SPINLOCK(gic_lock);
 
-static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+static int gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
@@ -166,7 +166,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
-		return;
+		return -1;
 
 	/* Assumption : cpumask refers to a single CPU */
 	spin_lock_irqsave(&gic_lock, flags);
@@ -190,6 +190,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	cpumask_copy(irq_desc[irq].affinity, cpumask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index 5ba3188..499ffe5 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -114,7 +114,7 @@ struct plat_smp_ops msmtc_smp_ops = {
  */
 
 
-void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
+int plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 {
 	cpumask_t tmask;
 	int cpu = 0;
@@ -156,5 +156,7 @@ void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 
 	/* Do any generic SMTC IRQ affinity setup */
 	smtc_set_irq_affinity(irq, tmask);
+
+	return 0;
 }
 #endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index c147c4b..690de06 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -50,7 +50,7 @@ static void enable_bcm1480_irq(unsigned int irq);
 static void disable_bcm1480_irq(unsigned int irq);
 static void ack_bcm1480_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_PCI
@@ -109,7 +109,7 @@ void bcm1480_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
@@ -118,7 +118,7 @@ static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	if (cpumask_weight(mask) != 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 	i = cpumask_first(mask);
 
@@ -152,6 +152,8 @@ static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 		}
 	}
 	spin_unlock_irqrestore(&bcm1480_imr_lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 38cb998..409dec7 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -50,7 +50,7 @@ static void enable_sb1250_irq(unsigned int irq);
 static void disable_sb1250_irq(unsigned int irq);
 static void ack_sb1250_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_SIBYTE_HAS_LDT
@@ -103,7 +103,7 @@ void sb1250_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on;
 	u64 cur_ints;
@@ -113,7 +113,7 @@ static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	if (cpumask_weight(mask) > 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 
 	/* Convert logical CPU to physical CPU */
@@ -143,6 +143,8 @@ static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 					R_IMR_INTERRUPT_MASK));
 	}
 	spin_unlock_irqrestore(&sb1250_imr_lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 4ea4229..8007f1e 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -130,15 +130,17 @@ int cpu_check_affinity(unsigned int irq, const struct cpumask *dest)
 	return cpu_dest;
 }
 
-static void cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
+static int cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu_dest;
 
 	cpu_dest = cpu_check_affinity(irq, dest);
 	if (cpu_dest < 0)
-		return;
+		return -1;
 
 	cpumask_copy(&irq_desc[irq].affinity, dest);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 80b5134..be3581a 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -333,7 +333,7 @@ static void xics_eoi_lpar(unsigned int virq)
 	lpar_xirr_info_set((0xff << 24) | irq);
 }
 
-static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
+static int xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 {
 	unsigned int irq;
 	int status;
@@ -342,14 +342,14 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 
 	irq = (unsigned int)irq_map[virq].hwirq;
 	if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
-		return;
+		return -1;
 
 	status = rtas_call(ibm_get_xive, 1, 3, xics_status, irq);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,get-xive irq=%u returns %d\n",
 			__func__, irq, status);
-		return;
+		return -1;
 	}
 
 	/*
@@ -363,7 +363,7 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
-		return;
+		return -1;
 	}
 
 	status = rtas_call(ibm_set_xive, 3, 1, NULL,
@@ -372,8 +372,10 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 	if (status) {
 		printk(KERN_ERR "%s: ibm,set-xive irq=%u returns %d\n",
 			__func__, irq, status);
-		return;
+		return -1;
 	}
+
+	return 0;
 }
 
 static struct irq_chip xics_pic_direct = {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 0efc12d..352d8c3 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -807,7 +807,7 @@ static void mpic_end_ipi(unsigned int irq)
 
 #endif /* CONFIG_SMP */
 
-void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -824,6 +824,8 @@ void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
 			       mpic_physmask(cpus_addr(tmp)[0]));
 	}
+
+	return 0;
 }
 
 static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)
diff --git a/arch/powerpc/sysdev/mpic.h b/arch/powerpc/sysdev/mpic.h
index 3cef2af..eff433c 100644
--- a/arch/powerpc/sysdev/mpic.h
+++ b/arch/powerpc/sysdev/mpic.h
@@ -36,6 +36,6 @@ static inline int mpic_pasemi_msi_init(struct mpic *mpic)
 
 extern int mpic_set_irq_type(unsigned int virq, unsigned int flow_type);
 extern void mpic_set_vector(unsigned int virq, unsigned int vector);
-extern void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 
 #endif /* _POWERPC_SYSDEV_MPIC_H */
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 5deabe9..e5e78f9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -318,10 +318,12 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 	}
 }
 
-static void sun4u_set_affinity(unsigned int virt_irq,
+static int sun4u_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
 	sun4u_irq_enable(virt_irq);
+
+	return 0;
 }
 
 /* Don't do anything.  The desc->status check for IRQ_DISABLED in
@@ -377,7 +379,7 @@ static void sun4v_irq_enable(unsigned int virt_irq)
 		       ino, err);
 }
 
-static void sun4v_set_affinity(unsigned int virt_irq,
+static int sun4v_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
@@ -388,6 +390,8 @@ static void sun4v_set_affinity(unsigned int virt_irq,
 	if (err != HV_EOK)
 		printk(KERN_ERR "sun4v_intr_settarget(%x,%lu): "
 		       "err(%d)\n", ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_irq_disable(unsigned int virt_irq)
@@ -445,7 +449,7 @@ static void sun4v_virq_enable(unsigned int virt_irq)
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virt_set_affinity(unsigned int virt_irq,
+static int sun4v_virt_set_affinity(unsigned int virt_irq,
 				    const struct cpumask *mask)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
@@ -461,6 +465,8 @@ static void sun4v_virt_set_affinity(unsigned int virt_irq,
 		printk(KERN_ERR "sun4v_vintr_set_target(%lx,%lx,%lu): "
 		       "err(%d)\n",
 		       dev_handle, dev_ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_virq_disable(unsigned int virt_irq)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..b1d3f60 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -274,15 +274,9 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say N.
 
-config NUMA_MIGRATE_IRQ_DESC
-	bool "Move irq desc when changing irq smp_affinity"
+config NUMA_IRQ_DESC
+	def_bool y
 	depends on SPARSE_IRQ && NUMA
-	depends on BROKEN
-	default n
-	---help---
-	  This enables moving irq_desc to cpu/node that irq will use handled.
-
-	  If you don't know what to do here, say N.
 
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
@@ -355,7 +349,7 @@ config X86_UV
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
-	select X86_X2APIC
+	depends on X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9fe5d21..27b8ce0 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -195,7 +195,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_SPARSE_IRQ=y
-# CONFIG_NUMA_MIGRATE_IRQ_DESC is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 # CONFIG_X86_ELAN is not set
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..3738438 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -107,8 +107,7 @@ extern u32 native_safe_apic_wait_icr_idle(void);
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
-#define EIM_8BIT_APIC_ID	0
-#define EIM_32BIT_APIC_ID	1
+extern int x2apic_mode;
 
 #ifdef CONFIG_X86_X2APIC
 /*
@@ -166,10 +165,9 @@ static inline u64 native_x2apic_icr_read(void)
 	return val;
 }
 
-extern int x2apic, x2apic_phys;
+extern int x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
-extern void enable_IR_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
@@ -183,6 +181,8 @@ static inline int x2apic_enabled(void)
 		return 1;
 	return 0;
 }
+
+#define x2apic_supported()	(cpu_has_x2apic)
 #else
 static inline void check_x2apic(void)
 {
@@ -190,28 +190,20 @@ static inline void check_x2apic(void)
 static inline void enable_x2apic(void)
 {
 }
-static inline void enable_IR_x2apic(void)
-{
-}
 static inline int x2apic_enabled(void)
 {
 	return 0;
 }
 
-#define	x2apic	0
-
+#define	x2apic_preenabled 0
+#define	x2apic_supported()	0
 #endif
 
-extern int get_physical_broadcast(void);
+extern void enable_IR_x2apic(void);
 
-#ifdef CONFIG_X86_X2APIC
-static inline void ack_x2APIC_irq(void)
-{
-	/* Docs say use 0 for future compatibility */
-	native_apic_msr_write(APIC_EOI, 0);
-}
-#endif
+extern int get_physical_broadcast(void);
 
+extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -252,7 +244,7 @@ static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
-
+static inline void apic_disable(void) { }
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index bc9514f..7ddb36a 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -22,6 +22,7 @@
 #  define	APIC_INTEGRATED(x)	(1)
 #endif
 #define		APIC_XAPIC(x)		((x) >= 0x14)
+#define		APIC_EXT_SPACE(x)	((x) & 0x80000000)
 #define	APIC_TASKPRI	0x80
 #define		APIC_TPRI_MASK		0xFFu
 #define	APIC_ARBPRI	0x90
@@ -116,7 +117,9 @@
 #define		APIC_TDR_DIV_32		0x8
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
-#define	APIC_EILVT0     0x500
+#define	APIC_EFEAT	0x400
+#define	APIC_ECTRL	0x410
+#define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
 #define		APIC_EILVT_LVTOFF(x)	(((x) >> 4) & 0xF)
@@ -125,9 +128,6 @@
 #define		APIC_EILVT_MSG_NMI	0x4
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
-#define	APIC_EILVT1     0x510
-#define	APIC_EILVT2     0x520
-#define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..13cc6a5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -22,7 +22,7 @@
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
 #define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
+#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
 #define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
 #define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
@@ -192,11 +192,11 @@ extern const char * const x86_power_flags[32];
 #define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
 #define setup_clear_cpu_cap(bit) do { \
 	clear_cpu_cap(&boot_cpu_data, bit);	\
-	set_bit(bit, (unsigned long *)cleared_cpu_caps); \
+	set_bit(bit, (unsigned long *)cpu_caps_cleared); \
 } while (0)
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, (unsigned long *)cleared_cpu_caps);	\
+	set_bit(bit, (unsigned long *)cpu_caps_set);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b762ea4..a7d14bb 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -63,7 +63,26 @@ extern unsigned long io_apic_irqs;
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
+
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic     = ioapic;
+	irq_attr->ioapic_pin = ioapic_pin;
+	irq_attr->trigger    = trigger;
+	irq_attr->polarity   = polarity;
+}
+
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
+					struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 1a99e6c..58d7091 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -60,8 +60,4 @@ extern struct irq_chip i8259A_chip;
 extern void mask_8259A(void);
 extern void unmask_8259A(void);
 
-#ifdef CONFIG_X86_32
-extern void init_ISA_irqs(void);
-#endif
-
 #endif /* _ASM_X86_I8259_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..daf866e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -154,22 +154,19 @@ extern int timer_through_8259;
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
-				   int edge_level, int active_high_low);
 #endif /* CONFIG_ACPI */
 
+struct io_apic_irq_attr;
+extern int io_apic_set_pci_routing(struct device *dev, int irq,
+		 struct io_apic_irq_attr *irq_attr);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
-#ifdef CONFIG_X86_64
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries);
-#endif
 
 extern void probe_nr_irqs_gsi(void);
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 0396760..f275e22 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_X86_IRQ_REMAPPING_H
 #define _ASM_X86_IRQ_REMAPPING_H
 
-#define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
+#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3cbd79b..910b5a3 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -34,6 +34,7 @@
 
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
+# define IA32_SYSCALL_VECTOR		0x80
 #else
 # define IA32_SYSCALL_VECTOR		0x80
 #endif
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 642fc7f..e2a1bb6 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -61,9 +61,11 @@ extern void get_smp_config(void);
 #ifdef CONFIG_X86_MPPARSE
 extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
+extern int enable_update_mptable;
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
+#define enable_update_mptable 0
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
@@ -72,20 +74,13 @@ extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
-extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+struct device;
+extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
+				 int active_high_low);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
-extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-				u32 gsi, int triggering, int polarity);
 extern int mp_find_ioapic(int gsi);
 extern int mp_find_ioapic_pin(int ioapic, int gsi);
-#else
-static inline int
-mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-		   u32 gsi, int triggering, int polarity)
-{
-	return 0;
-}
 #endif
 #else /* !CONFIG_ACPI: */
 static inline int acpi_probe_gsi(void)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..fed93fe 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -135,7 +135,8 @@ extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
 extern struct tss_struct	doublefault_tss;
-extern __u32			cleared_cpu_caps[NCAPINTS];
+extern __u32			cpu_caps_cleared[NCAPINTS];
+extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index bdc2ada..4093d1e 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -33,7 +33,6 @@ struct x86_quirks {
 	int (*setup_ioapic_ids)(void);
 };
 
-extern void x86_quirk_pre_intr_init(void);
 extern void x86_quirk_intr_init(void);
 
 extern void x86_quirk_trap_init(void);
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19e0d88..6a84ed1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -180,7 +180,7 @@ extern int safe_smp_processor_id(void);
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
+	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 }
 
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 88d1bfc..235f592 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -28,7 +28,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o i8259.o irqinit_$(BITS).o
+obj-y			+= setup.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 723989d..6310861 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
@@ -522,7 +523,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
@@ -532,14 +533,14 @@ int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
 	 */
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
-		if (triggering == ACPI_LEVEL_SENSITIVE)
+		if (trigger == ACPI_LEVEL_SENSITIVE)
 			eisa_set_level_irq(gsi);
 	}
 #endif
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
-		plat_gsi = mp_register_gsi(gsi, triggering, polarity);
+		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
 	acpi_gsi_to_irq(plat_gsi, &irq);
@@ -903,10 +904,8 @@ extern int es7000_plat;
 #endif
 
 static struct {
-	int apic_id;
 	int gsi_base;
 	int gsi_end;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
 int mp_find_ioapic(int gsi)
@@ -986,16 +985,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
-#ifdef CONFIG_X86_32
 	mp_ioapics[idx].apicver = io_apic_get_version(idx);
-#else
-	mp_ioapics[idx].apicver = 0;
-#endif
+
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
@@ -1158,26 +1153,52 @@ void __init mp_config_acpi_legacy_irqs(void)
 	}
 }
 
-int mp_register_gsi(u32 gsi, int triggering, int polarity)
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
+			int polarity)
 {
+#ifdef CONFIG_X86_MPPARSE
+	struct mpc_intsrc mp_irq;
+	struct pci_dev *pdev;
+	unsigned char number;
+	unsigned int devfn;
 	int ioapic;
-	int ioapic_pin;
-#ifdef CONFIG_X86_32
-#define MAX_GSI_NUM	4096
-#define IRQ_COMPRESSION_START	64
+	u8 pin;
 
-	static int pci_irq = IRQ_COMPRESSION_START;
-	/*
-	 * Mapping between Global System Interrupts, which
-	 * represent all possible interrupts, and IRQs
-	 * assigned to actual devices.
-	 */
-	static int gsi_to_irq[MAX_GSI_NUM];
-#else
+	if (!acpi_ioapic)
+		return 0;
+	if (!dev)
+		return 0;
+	if (dev->bus != &pci_bus_type)
+		return 0;
+
+	pdev = to_pci_dev(dev);
+	number = pdev->bus->number;
+	devfn = pdev->devfn;
+	pin = pdev->pin;
+	/* print the entry should happen on mptable identically */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	ioapic = mp_find_ioapic(gsi);
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
+	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
+
+	save_mp_irq(&mp_irq);
+#endif
+	return 0;
+}
+
+int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+{
+	int ioapic;
+	int ioapic_pin;
+	struct io_apic_irq_attr irq_attr;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
-#endif
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
@@ -1196,93 +1217,22 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		gsi = ioapic_renumber_irq(ioapic, gsi);
 #endif
 
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
 		return gsi;
 	}
-	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-#ifdef CONFIG_X86_32
-		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
-#else
-		return gsi;
-#endif
-	}
-
-	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
-#ifdef CONFIG_X86_32
-	/*
-	 * For GSI >= 64, use IRQ compression
-	 */
-	if ((gsi >= IRQ_COMPRESSION_START)
-	    && (triggering == ACPI_LEVEL_SENSITIVE)) {
-		/*
-		 * For PCI devices assign IRQs in order, avoiding gaps
-		 * due to unused I/O APIC pins.
-		 */
-		int irq = gsi;
-		if (gsi < MAX_GSI_NUM) {
-			/*
-			 * Retain the VIA chipset work-around (gsi > 15), but
-			 * avoid a problem where the 8254 timer (IRQ0) is setup
-			 * via an override (so it's not on pin 0 of the ioapic),
-			 * and at the same time, the pin 0 interrupt is a PCI
-			 * type.  The gsi > 15 test could cause these two pins
-			 * to be shared as IRQ0, and they are not shareable.
-			 * So test for this condition, and if necessary, avoid
-			 * the pin collision.
-			 */
-			gsi = pci_irq++;
-			/*
-			 * Don't assign IRQ used by ACPI SCI
-			 */
-			if (gsi == acpi_gbl_FADT.sci_interrupt)
-				gsi = pci_irq++;
-			gsi_to_irq[irq] = gsi;
-		} else {
-			printk(KERN_ERR "GSI %u is too high\n", gsi);
-			return gsi;
-		}
-	}
-#endif
-	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
-				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
-				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	return gsi;
-}
 
-int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-			u32 gsi, int triggering, int polarity)
-{
-#ifdef CONFIG_X86_MPPARSE
-	struct mpc_intsrc mp_irq;
-	int ioapic;
+	if (enable_update_mptable)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
-	if (!acpi_ioapic)
-		return 0;
+	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
+			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
+			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	io_apic_set_pci_routing(dev, gsi, &irq_attr);
 
-	/* print the entry should happen on mptable identically */
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
-				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.srcbus = number;
-	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
-	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
-
-	save_mp_irq(&mp_irq);
-#endif
-	return 0;
+	return gsi;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..a4c9cf0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -98,6 +98,29 @@ early_param("lapic", parse_lapic);
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
 
+/*
+ * Handle interrupt mode configuration register (IMCR).
+ * This register controls whether the interrupt signals
+ * that reach the BSP come from the master PIC or from the
+ * local APIC. Before entering Symmetric I/O Mode, either
+ * the BIOS or the operating system must switch out of
+ * PIC Mode by changing the IMCR.
+ */
+static inline void imcr_pic_to_apic(void)
+{
+	/* select IMCR register */
+	outb(0x70, 0x22);
+	/* NMI and 8259 INTR go through APIC */
+	outb(0x01, 0x23);
+}
+
+static inline void imcr_apic_to_pic(void)
+{
+	/* select IMCR register */
+	outb(0x70, 0x22);
+	/* NMI and 8259 INTR go directly to BSP */
+	outb(0x00, 0x23);
+}
 #endif
 
 #ifdef CONFIG_X86_64
@@ -111,13 +134,19 @@ static __init int setup_apicpmtimer(char *s)
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
+int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
-int x2apic;
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
 static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
+	if (x2apic_enabled()) {
+		pr_warning("Bios already enabled x2apic, "
+			   "can't enforce nox2apic");
+		return 0;
+	}
+
 	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
@@ -209,6 +238,31 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * bare function to substitute write operation
+ * and it's _that_ fast :)
+ */
+static void native_apic_write_dummy(u32 reg, u32 v)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+}
+
+static u32 native_apic_read_dummy(u32 reg)
+{
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
+	return 0;
+}
+
+/*
+ * right after this call apic->write/read doesn't do anything
+ * note that there is no restore operation it works one way
+ */
+void apic_disable(void)
+{
+	apic->read = native_apic_read_dummy;
+	apic->write = native_apic_write_dummy;
+}
+
 void native_apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
@@ -348,7 +402,7 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 
 static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned long reg = (lvt_off << 4) + APIC_EILVTn(0);
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
 
 	apic_write(reg, v);
@@ -815,7 +869,7 @@ void clear_local_APIC(void)
 	u32 v;
 
 	/* APIC hasn't been mapped yet */
-	if (!x2apic && !apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	maxlvt = lapic_get_maxlvt();
@@ -1287,7 +1341,7 @@ void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic = 1;
+		x2apic_preenabled = x2apic_mode = 1;
 	}
 }
 
@@ -1295,7 +1349,7 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
-	if (!x2apic)
+	if (!x2apic_mode)
 		return;
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
@@ -1304,6 +1358,7 @@ void enable_x2apic(void)
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
+#endif /* CONFIG_X86_X2APIC */
 
 void __init enable_IR_x2apic(void)
 {
@@ -1312,32 +1367,21 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
-	if (!cpu_has_x2apic)
-		return;
-
-	if (!x2apic_preenabled && disable_x2apic) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of nox2apic\n");
-		return;
+	ret = dmar_table_init();
+	if (ret) {
+		pr_debug("dmar_table_init() failed with %d:\n", ret);
+		goto ir_failed;
 	}
 
-	if (x2apic_preenabled && disable_x2apic)
-		panic("Bios already enabled x2apic, can't enforce nox2apic");
-
-	if (!x2apic_preenabled && skip_ioapic_setup) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of skipping io-apic setup\n");
-		return;
+	if (!intr_remapping_supported()) {
+		pr_debug("intr-remapping not supported\n");
+		goto ir_failed;
 	}
 
-	ret = dmar_table_init();
-	if (ret) {
-		pr_info("dmar_table_init() failed with %d:\n", ret);
 
-		if (x2apic_preenabled)
-			panic("x2apic enabled by bios. But IR enabling failed");
-		else
-			pr_info("Not enabling x2apic,Intr-remapping\n");
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		pr_info("Skipped enabling intr-remap because of skipping "
+			"io-apic setup\n");
 		return;
 	}
 
@@ -1357,19 +1401,16 @@ void __init enable_IR_x2apic(void)
 	mask_IO_APIC_setup(ioapic_entries);
 	mask_8259A();
 
-	ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
-
-	if (ret && x2apic_preenabled) {
-		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
-	}
-
+	ret = enable_intr_remapping(x2apic_supported());
 	if (ret)
 		goto end_restore;
 
-	if (!x2apic) {
-		x2apic = 1;
+	pr_info("Enabled Interrupt-remapping\n");
+
+	if (x2apic_supported() && !x2apic_mode) {
+		x2apic_mode = 1;
 		enable_x2apic();
+		pr_info("Enabled x2apic\n");
 	}
 
 end_restore:
@@ -1378,37 +1419,34 @@ end_restore:
 		 * IR enabling failed
 		 */
 		restore_IO_APIC_setup(ioapic_entries);
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
 
 	unmask_8259A();
 	local_irq_restore(flags);
 
 end:
-	if (!ret) {
-		if (!x2apic_preenabled)
-			pr_info("Enabled x2apic and interrupt-remapping\n");
-		else
-			pr_info("Enabled Interrupt-remapping\n");
-	} else
-		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
 	if (ioapic_entries)
 		free_ioapic_entries(ioapic_entries);
+
+	if (!ret)
+		return;
+
+ir_failed:
+	if (x2apic_preenabled)
+		panic("x2apic enabled by bios. But IR enabling failed");
+	else if (cpu_has_x2apic)
+		pr_info("Not enabling x2apic,Intr-remapping\n");
 #else
 	if (!cpu_has_x2apic)
 		return;
 
 	if (x2apic_preenabled)
 		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_INTR_REMAP");
-
-	pr_info("Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-		" and x2apic\n");
+		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
 #endif
 
 	return;
 }
-#endif /* CONFIG_X86_X2APIC */
+
 
 #ifdef CONFIG_X86_64
 /*
@@ -1425,7 +1463,6 @@ static int __init detect_init_APIC(void)
 	}
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-	boot_cpu_physical_apicid = 0;
 	return 0;
 }
 #else
@@ -1539,32 +1576,49 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
-	if (x2apic) {
+	unsigned int new_apicid;
+
+	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
 
-	/*
-	 * If no local APIC can be found then set up a fake all
-	 * zeroes page to simulate the local APIC and another
-	 * one for the IO-APIC.
-	 */
+	/* If no local APIC can be found return early */
 	if (!smp_found_config && detect_init_APIC()) {
-		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
-		apic_phys = __pa(apic_phys);
-	} else
+		/* lets NOP'ify apic operations */
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+	} else {
 		apic_phys = mp_lapic_addr;
 
-	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-				APIC_BASE, apic_phys);
+		/*
+		 * acpi lapic path already maps that address in
+		 * acpi_register_lapic_address()
+		 */
+		if (!acpi_lapic)
+			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+
+		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
+					APIC_BASE, apic_phys);
+	}
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = read_apic_id();
+	new_apicid = read_apic_id();
+	if (boot_cpu_physical_apicid != new_apicid) {
+		boot_cpu_physical_apicid = new_apicid;
+		/*
+		 * yeah -- we lie about apic_version
+		 * in case if apic was disabled via boot option
+		 * but it's not a problem for SMP compiled kernel
+		 * since smp_sanity_check is prepared for such a case
+		 * and disable smp mode
+		 */
+		apic_version[new_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+	}
 }
 
 /*
@@ -1733,8 +1787,7 @@ void __init connect_bsp_APIC(void)
 		 */
 		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
 				"enabling APIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x01, 0x23);
+		imcr_pic_to_apic();
 	}
 #endif
 	if (apic->enable_apic_mode)
@@ -1762,8 +1815,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 		 */
 		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
 				"entering PIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x00, 0x23);
+		imcr_apic_to_pic();
 		return;
 	}
 #endif
@@ -1969,10 +2021,10 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 
 	local_irq_save(flags);
 	disable_local_APIC();
-#ifdef CONFIG_INTR_REMAP
+
 	if (intr_remapping_enabled)
 		disable_intr_remapping();
-#endif
+
 	local_irq_restore(flags);
 	return 0;
 }
@@ -1982,42 +2034,34 @@ static int lapic_resume(struct sys_device *dev)
 	unsigned int l, h;
 	unsigned long flags;
 	int maxlvt;
-
-#ifdef CONFIG_INTR_REMAP
-	int ret;
+	int ret = 0;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
 		return 0;
 
 	local_irq_save(flags);
-	if (x2apic) {
+	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto restore;
 		}
 
 		ret = save_IO_APIC_setup(ioapic_entries);
 		if (ret) {
 			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
 			free_ioapic_entries(ioapic_entries);
-			return ret;
+			goto restore;
 		}
 
 		mask_IO_APIC_setup(ioapic_entries);
 		mask_8259A();
-		enable_x2apic();
 	}
-#else
-	if (!apic_pm_state.active)
-		return 0;
 
-	local_irq_save(flags);
-	if (x2apic)
+	if (x2apic_mode)
 		enable_x2apic();
-#endif
-
 	else {
 		/*
 		 * Make sure the APICBASE points to the right address
@@ -2055,21 +2099,16 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-#ifdef CONFIG_INTR_REMAP
-	if (intr_remapping_enabled)
-		reenable_intr_remapping(EIM_32BIT_APIC_ID);
-
-	if (x2apic) {
+	if (intr_remapping_enabled) {
+		reenable_intr_remapping(x2apic_mode);
 		unmask_8259A();
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
 	}
-#endif
-
+restore:
 	local_irq_restore(flags);
 
-
-	return 0;
+	return ret;
 }
 
 /*
@@ -2117,31 +2156,14 @@ static void apic_pm_activate(void) { }
 #endif	/* CONFIG_PM */
 
 #ifdef CONFIG_X86_64
-/*
- * apic_is_clustered_box() -- Check if we can expect good TSC
- *
- * Thus far, the major user of this is IBM's Summit2 series:
- *
- * Clustered boxes may have unsynced TSC problems if they are
- * multi-chassis. Use available data to take a good guess.
- * If in doubt, go HPET.
- */
-__cpuinit int apic_is_clustered_box(void)
+
+static int __cpuinit apic_cluster_num(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
 	u16 *bios_cpu_apicid;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
-	/*
-	 * there is not this kind of box with AMD CPU yet.
-	 * Some AMD box with quadcore cpu and 8 sockets apicid
-	 * will be [4, 0x23] or [8, 0x27] could be thought to
-	 * vsmp box still need checking...
-	 */
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
-		return 0;
-
 	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
@@ -2177,18 +2199,67 @@ __cpuinit int apic_is_clustered_box(void)
 			++zeros;
 	}
 
-	/* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
-	 * not guaranteed to be synced between boards
-	 */
-	if (is_vsmp_box() && clusters > 1)
+	return clusters;
+}
+
+static int __cpuinitdata multi_checked;
+static int __cpuinitdata multi;
+
+static int __cpuinit set_multi(const struct dmi_system_id *d)
+{
+	if (multi)
+		return 0;
+	pr_info("APIC: %s detected, Multi Chassis\n", d->ident);
+	multi = 1;
+	return 0;
+}
+
+static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
+	{
+		.callback = set_multi,
+		.ident = "IBM System Summit2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Summit2"),
+		},
+	},
+	{}
+};
+
+static void __cpuinit dmi_check_multi(void)
+{
+	if (multi_checked)
+		return;
+
+	dmi_check_system(multi_dmi_table);
+	multi_checked = 1;
+}
+
+/*
+ * apic_is_clustered_box() -- Check if we can expect good TSC
+ *
+ * Thus far, the major user of this is IBM's Summit2 series:
+ * Clustered boxes may have unsynced TSC problems if they are
+ * multi-chassis.
+ * Use DMI to check them
+ */
+__cpuinit int apic_is_clustered_box(void)
+{
+	dmi_check_multi();
+	if (multi)
 		return 1;
 
+	if (!is_vsmp_box())
+		return 0;
+
 	/*
-	 * If clusters > 2, then should be multi-chassis.
-	 * May have to revisit this when multi-core + hyperthreaded CPUs come
-	 * out, but AFAIK this will work even for them.
+	 * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
+	 * not guaranteed to be synced between boards
 	 */
-	return (clusters > 2);
+	if (apic_cluster_num() > 1)
+		return 1;
+
+	return 0;
 }
 #endif
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 306e5e8..d0c99ab 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -161,7 +161,7 @@ static int flat_apic_id_registered(void)
 
 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
-	return hard_smp_processor_id() >> index_msb;
+	return initial_apic_id >> index_msb;
 }
 
 struct apic apic_flat =  {
@@ -235,7 +235,7 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	 * regardless of how many processors are present (x86_64 ES7000
 	 * is an example).
 	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 3029477..69328ac 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -145,7 +145,7 @@ es7000_rename_gsi(int ioapic, int gsi)
 	return gsi;
 }
 
-static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
+static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..f712f8f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -129,12 +129,9 @@ struct irq_pin_list {
 	struct irq_pin_list *next;
 };
 
-static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
+static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 {
 	struct irq_pin_list *pin;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
 
@@ -148,9 +145,6 @@ struct irq_cfg {
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-	u8 move_desc_pending : 1;
-#endif
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -212,12 +206,9 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
 	return cfg;
 }
 
-static struct irq_cfg *get_one_free_irq_cfg(int cpu)
+static struct irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
 	if (cfg) {
@@ -238,13 +229,13 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int cpu)
+int arch_init_chip_data(struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 
 	cfg = desc->chip_data;
 	if (!cfg) {
-		desc->chip_data = get_one_free_irq_cfg(cpu);
+		desc->chip_data = get_one_free_irq_cfg(node);
 		if (!desc->chip_data) {
 			printk(KERN_ERR "can not alloc irq_cfg\n");
 			BUG_ON(1);
@@ -254,10 +245,9 @@ int arch_init_chip_data(struct irq_desc *desc, int cpu)
 	return 0;
 }
 
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-
+/* for move_irq_desc */
 static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
+init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
 {
 	struct irq_pin_list *old_entry, *head, *tail, *entry;
 
@@ -266,7 +256,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 	if (!old_entry)
 		return;
 
-	entry = get_one_free_irq_2_pin(cpu);
+	entry = get_one_free_irq_2_pin(node);
 	if (!entry)
 		return;
 
@@ -276,7 +266,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 	tail		= entry;
 	old_entry	= old_entry->next;
 	while (old_entry) {
-		entry = get_one_free_irq_2_pin(cpu);
+		entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			entry = head;
 			while (entry) {
@@ -316,12 +306,12 @@ static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
 }
 
 void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int cpu)
+				 struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 	struct irq_cfg *old_cfg;
 
-	cfg = get_one_free_irq_cfg(cpu);
+	cfg = get_one_free_irq_cfg(node);
 
 	if (!cfg)
 		return;
@@ -332,7 +322,7 @@ void arch_init_copy_chip_data(struct irq_desc *old_desc,
 
 	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
 
-	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
 static void free_irq_cfg(struct irq_cfg *old_cfg)
@@ -356,19 +346,7 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 		old_desc->chip_data = NULL;
 	}
 }
-
-static void
-set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg = desc->chip_data;
-
-	if (!cfg->move_in_progress) {
-		/* it means that domain is not changed */
-		if (!cpumask_intersects(desc->affinity, mask))
-			cfg->move_desc_pending = 1;
-	}
-}
-#endif
+/* end for move_irq_desc */
 
 #else
 static struct irq_cfg *irq_cfg(unsigned int irq)
@@ -378,13 +356,6 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
 
 #endif
 
-#ifndef CONFIG_NUMA_MIGRATE_IRQ_DESC
-static inline void
-set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-}
-#endif
-
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -518,132 +489,18 @@ static void ioapic_mask_entry(int apic, int pin)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-#ifdef CONFIG_SMP
-static void send_cleanup_vector(struct irq_cfg *cfg)
-{
-	cpumask_var_t cleanup_mask;
-
-	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
-		unsigned int i;
-		cfg->move_cleanup_count = 0;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			cfg->move_cleanup_count++;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
-	} else {
-		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
-		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		free_cpumask_var(cleanup_mask);
-	}
-	cfg->move_in_progress = 0;
-}
-
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-	u8 vector = cfg->vector;
-
-	entry = cfg->irq_2_pin;
-	for (;;) {
-		unsigned int reg;
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		/*
-		 * With interrupt-remapping, destination information comes
-		 * from interrupt-remapping table entry.
-		 */
-		if (!irq_remapped(irq))
-			io_apic_write(apic, 0x11 + pin*2, dest);
-		reg = io_apic_read(apic, 0x10 + pin*2);
-		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
-		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = entry->next;
-	}
-}
-
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
-
-/*
- * Either sets desc->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
- * leaves desc->affinity untouched.
- */
-static unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg;
-	unsigned int irq;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return BAD_APICID;
-
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
-
-	cpumask_copy(desc->affinity, mask);
-
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
-}
-
-static void
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int dest;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	dest = set_desc_affinity(desc, mask);
-	if (dest != BAD_APICID) {
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, cfg);
-	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-static void
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	set_ioapic_affinity_irq_desc(desc, mask);
-}
-#endif /* CONFIG_SMP */
-
 /*
  * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
+static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list *entry;
 
 	entry = cfg->irq_2_pin;
 	if (!entry) {
-		entry = get_one_free_irq_2_pin(cpu);
+		entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
 					apic, pin);
@@ -663,7 +520,7 @@ static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(cpu);
+	entry->next = get_one_free_irq_2_pin(node);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -672,7 +529,7 @@ static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
+static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -692,7 +549,7 @@ static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
+		add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(struct irq_cfg *cfg,
@@ -850,7 +707,6 @@ static int __init ioapic_pirq_setup(char *str)
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-#ifdef CONFIG_INTR_REMAP
 struct IO_APIC_route_entry **alloc_ioapic_entries(void)
 {
 	int apic;
@@ -948,20 +804,6 @@ int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
 	return 0;
 }
 
-void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries)
-
-{
-	/*
-	 * for now plain restore of previous settings.
-	 * TBD: In the case of OS enabling interrupt-remapping,
-	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
-	 * table entries. for now, do a plain restore, and wait for
-	 * the setup_IO_APIC_irqs() to do proper initialization.
-	 */
-	restore_IO_APIC_setup(ioapic_entries);
-}
-
 void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
 {
 	int apic;
@@ -971,7 +813,6 @@ void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
 
 	kfree(ioapic_entries);
 }
-#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
@@ -1032,54 +873,6 @@ static int __init find_isa_irq_apic(int irq, int type)
 	return -1;
 }
 
-/*
- * Find a specific PCI IRQ entry.
- * Not an __init, possibly needed by modules
- */
-static int pin_2_irq(int idx, int apic, int pin);
-
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
-{
-	int apic, i, best_guess = -1;
-
-	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
-		bus, slot, pin);
-	if (test_bit(bus, mp_bus_not_pci)) {
-		apic_printk(APIC_VERBOSE, "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
-		return -1;
-	}
-	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].srcbus;
-
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
-			    mp_irqs[i].dstapic == MP_APIC_ALL)
-				break;
-
-		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].irqtype &&
-		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
-
-			if (!(apic || IO_APIC_IRQ(irq)))
-				continue;
-
-			if (pin == (mp_irqs[i].srcbusirq & 3))
-				return irq;
-			/*
-			 * Use the first all-but-pin matching entry as a
-			 * best-guess fuzzy result for broken mptables.
-			 */
-			if (best_guess < 0)
-				best_guess = irq;
-		}
-	}
-	return best_guess;
-}
-
-EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
-
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 /*
  * EISA Edge/Level control register, ELCR
@@ -1298,6 +1091,64 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
+/*
+ * Find a specific PCI IRQ entry.
+ * Not an __init, possibly needed by modules
+ */
+int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
+				struct io_apic_irq_attr *irq_attr)
+{
+	int apic, i, best_guess = -1;
+
+	apic_printk(APIC_DEBUG,
+		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
+		    bus, slot, pin);
+	if (test_bit(bus, mp_bus_not_pci)) {
+		apic_printk(APIC_VERBOSE,
+			    "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
+		return -1;
+	}
+	for (i = 0; i < mp_irq_entries; i++) {
+		int lbus = mp_irqs[i].srcbus;
+
+		for (apic = 0; apic < nr_ioapics; apic++)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			    mp_irqs[i].dstapic == MP_APIC_ALL)
+				break;
+
+		if (!test_bit(lbus, mp_bus_not_pci) &&
+		    !mp_irqs[i].irqtype &&
+		    (bus == lbus) &&
+		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+
+			if (!(apic || IO_APIC_IRQ(irq)))
+				continue;
+
+			if (pin == (mp_irqs[i].srcbusirq & 3)) {
+				set_io_apic_irq_attr(irq_attr, apic,
+						     mp_irqs[i].dstirq,
+						     irq_trigger(i),
+						     irq_polarity(i));
+				return irq;
+			}
+			/*
+			 * Use the first all-but-pin matching entry as a
+			 * best-guess fuzzy result for broken mptables.
+			 */
+			if (best_guess < 0) {
+				set_io_apic_irq_attr(irq_attr, apic,
+						     mp_irqs[i].dstirq,
+						     irq_trigger(i),
+						     irq_polarity(i));
+				best_guess = irq;
+			}
+		}
+	}
+	return best_guess;
+}
+EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
+
 void lock_vector_lock(void)
 {
 	/* Used to the online set of cpus does not change
@@ -1628,58 +1479,70 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id, pin, idx, irq;
+	int apic_id = 0, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
-
-			idx = find_irq_entry(apic_id, pin, mp_INT);
-			if (idx == -1) {
-				if (!notcon) {
-					notcon = 1;
-					apic_printk(APIC_VERBOSE,
-						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic_id].apicid, pin);
-				} else
-					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic_id].apicid, pin);
-				continue;
-			}
-			if (notcon) {
-				apic_printk(APIC_VERBOSE,
-					" (apicid-pin) not connected\n");
-				notcon = 0;
-			}
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic) {
+		apic_id = mp_find_ioapic(0);
+		if (apic_id < 0)
+			apic_id = 0;
+	}
+#endif
 
-			irq = pin_2_irq(idx, apic_id, pin);
+	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+		idx = find_irq_entry(apic_id, pin, mp_INT);
+		if (idx == -1) {
+			if (!notcon) {
+				notcon = 1;
+				apic_printk(APIC_VERBOSE,
+					KERN_DEBUG " %d-%d",
+					mp_ioapics[apic_id].apicid, pin);
+			} else
+				apic_printk(APIC_VERBOSE, " %d-%d",
+					mp_ioapics[apic_id].apicid, pin);
+			continue;
+		}
+		if (notcon) {
+			apic_printk(APIC_VERBOSE,
+				" (apicid-pin) not connected\n");
+			notcon = 0;
+		}
 
-			/*
-			 * Skip the timer IRQ if there's a quirk handler
-			 * installed and if it returns 1:
-			 */
-			if (apic->multi_timer_check &&
-					apic->multi_timer_check(apic_id, irq))
-				continue;
+		irq = pin_2_irq(idx, apic_id, pin);
 
-			desc = irq_to_desc_alloc_cpu(irq, cpu);
-			if (!desc) {
-				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
-				continue;
-			}
-			cfg = desc->chip_data;
-			add_pin_to_irq_cpu(cfg, cpu, apic_id, pin);
+		/*
+		 * Skip the timer IRQ if there's a quirk handler
+		 * installed and if it returns 1:
+		 */
+		if (apic->multi_timer_check &&
+				apic->multi_timer_check(apic_id, irq))
+			continue;
 
-			setup_IO_APIC_irq(apic_id, pin, irq, desc,
-					irq_trigger(idx), irq_polarity(idx));
+		desc = irq_to_desc_alloc_node(irq, node);
+		if (!desc) {
+			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+			continue;
 		}
+		cfg = desc->chip_data;
+		add_pin_to_irq_node(cfg, node, apic_id, pin);
+		/*
+		 * don't mark it in pin_programmed, so later acpi could
+		 * set it correctly when irq < 16
+		 */
+		setup_IO_APIC_irq(apic_id, pin, irq, desc,
+				irq_trigger(idx), irq_polarity(idx));
 	}
 
 	if (notcon)
@@ -1869,7 +1732,7 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
-	unsigned int v, ver, maxlvt;
+	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1957,6 +1820,18 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
 	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		v = apic_read(APIC_EFEAT);
+		maxlvt = (v >> 16) & 0xff;
+		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
+		v = apic_read(APIC_ECTRL);
+		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
+		for (i = 0; i < maxlvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
+		}
+	}
 	printk("\n");
 }
 
@@ -2005,6 +1880,11 @@ __apicdebuginit(void) print_PIC(void)
 __apicdebuginit(int) print_all_ICs(void)
 {
 	print_PIC();
+
+	/* don't print out if apic is not there */
+	if (!cpu_has_apic || disable_apic)
+		return 0;
+
 	print_all_local_APICs();
 	print_IO_APIC();
 
@@ -2360,6 +2240,118 @@ static int ioapic_retrigger_irq(unsigned int irq)
  */
 
 #ifdef CONFIG_SMP
+static void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	cpumask_var_t cleanup_mask;
+
+	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
+		unsigned int i;
+		cfg->move_cleanup_count = 0;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			cfg->move_cleanup_count++;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
+	} else {
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
+		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		free_cpumask_var(cleanup_mask);
+	}
+	cfg->move_in_progress = 0;
+}
+
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+	u8 vector = cfg->vector;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+		unsigned int reg;
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(irq))
+			io_apic_write(apic, 0x11 + pin*2, dest);
+		reg = io_apic_read(apic, 0x10 + pin*2);
+		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
+		reg |= vector;
+		io_apic_modify(apic, 0x10 + pin*2, reg);
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+}
+
+static int
+assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
+
+/*
+ * Either sets desc->affinity to a valid value, and returns
+ * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
+ * leaves desc->affinity untouched.
+ */
+static unsigned int
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned int irq;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return BAD_APICID;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
+		return BAD_APICID;
+
+	cpumask_copy(desc->affinity, mask);
+
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+}
+
+static int
+set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int dest;
+	unsigned int irq;
+	int ret = -1;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	dest = set_desc_affinity(desc, mask);
+	if (dest != BAD_APICID) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, cfg);
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return ret;
+}
+
+static int
+set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	return set_ioapic_affinity_irq_desc(desc, mask);
+}
 
 #ifdef CONFIG_INTR_REMAP
 
@@ -2374,26 +2366,25 @@ static int ioapic_retrigger_irq(unsigned int irq)
  * Real vector that is used for interrupting cpu will be coming from
  * the interrupt-remapping table entry.
  */
-static void
+static int
 migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
 	unsigned int dest;
 	unsigned int irq;
+	int ret = -1;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
+		return ret;
 
 	irq = desc->irq;
 	if (get_irte(irq, &irte))
-		return;
+		return ret;
 
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
+		return ret;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
@@ -2409,27 +2400,30 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 		send_cleanup_vector(cfg);
 
 	cpumask_copy(desc->affinity, mask);
+
+	return 0;
 }
 
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 					    const struct cpumask *mask)
 {
-	migrate_ioapic_irq_desc(desc, mask);
+	return migrate_ioapic_irq_desc(desc, mask);
 }
-static void set_ir_ioapic_affinity_irq(unsigned int irq,
+static int set_ir_ioapic_affinity_irq(unsigned int irq,
 				       const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	set_ir_ioapic_affinity_irq_desc(desc, mask);
+	return set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #else
-static inline void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static inline int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 						   const struct cpumask *mask)
 {
+	return 0;
 }
 #endif
 
@@ -2491,86 +2485,19 @@ static void irq_complete_move(struct irq_desc **descp)
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		if (likely(!cfg->move_desc_pending))
-			return;
-
-		/* domain has not changed, but affinity did */
-		me = smp_processor_id();
-		if (cpumask_test_cpu(me, desc->affinity)) {
-			*descp = desc = move_irq_desc(desc, me);
-			/* get the new one */
-			cfg = desc->chip_data;
-			cfg->move_desc_pending = 0;
-		}
-#endif
+	if (likely(!cfg->move_in_progress))
 		return;
-	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		*descp = desc = move_irq_desc(desc, me);
-		/* get the new one */
-		cfg = desc->chip_data;
-#endif
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
-	}
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-
-	entry = cfg->irq_2_pin;
-	for (;;) {
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		io_apic_eoi(apic, pin);
-		entry = entry->next;
-	}
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
-#ifdef CONFIG_X86_X2APIC
-static void ack_x2apic_level(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	ack_x2APIC_irq();
-	eoi_ioapic_irq(desc);
-}
-
-static void ack_x2apic_edge(unsigned int irq)
-{
-	ack_x2APIC_irq();
-}
-#endif
-
 static void ack_apic_edge(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2634,9 +2561,6 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
-	if (irq_remapped(irq))
-		eoi_ioapic_irq(desc);
-
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2683,22 +2607,50 @@ static void ack_apic_level(unsigned int irq)
 }
 
 #ifdef CONFIG_INTR_REMAP
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		io_apic_eoi(apic, pin);
+		entry = entry->next;
+	}
+}
+
+static void
+eoi_ioapic_irq(struct irq_desc *desc)
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
 static void ir_ack_apic_edge(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_edge(irq);
-#endif
-       return ack_apic_edge(irq);
+	ack_APIC_irq();
 }
 
 static void ir_ack_apic_level(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_level(irq);
-#endif
-       return ack_apic_level(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	ack_APIC_irq();
+	eoi_ioapic_irq(desc);
 }
 #endif /* CONFIG_INTR_REMAP */
 
@@ -2903,7 +2855,7 @@ static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2969,7 +2921,7 @@ static inline void __init check_timer(void)
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
+			add_pin_to_irq_node(cfg, node, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		} else {
 			/* for edge trigger, setup_IO_APIC_irq already
@@ -3006,7 +2958,7 @@ static inline void __init check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
@@ -3218,14 +3170,13 @@ static int nr_irqs_gsi = NR_IRQS_LEGACY;
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int irq_want)
+unsigned int create_irq_nr(unsigned int irq_want, int node)
 {
 	/* Allocate an unused irq */
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int cpu = boot_cpu_id;
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3234,7 +3185,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
@@ -3243,6 +3194,9 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 		if (cfg_new->vector != 0)
 			continue;
+
+		desc_new = move_irq_desc(desc_new, node);
+
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
@@ -3260,11 +3214,12 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 int create_irq(void)
 {
+	int node = cpu_to_node(boot_cpu_id);
 	unsigned int irq_want;
 	int irq;
 
 	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
+	irq = create_irq_nr(irq_want, node);
 
 	if (irq == 0)
 		irq = -1;
@@ -3366,7 +3321,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3375,7 +3330,7 @@ static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3387,13 +3342,15 @@ static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg_desc(desc, &msg);
+
+	return 0;
 }
 #ifdef CONFIG_INTR_REMAP
 /*
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void
+static int
 ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -3402,11 +3359,11 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct irte irte;
 
 	if (get_irte(irq, &irte))
-		return;
+		return -1;
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3423,6 +3380,8 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	 */
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
+
+	return 0;
 }
 
 #endif
@@ -3518,15 +3477,17 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	unsigned int irq_want;
 	struct intel_iommu *iommu = NULL;
 	int index = 0;
+	int node;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
+	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want);
+		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
@@ -3576,7 +3537,7 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3585,7 +3546,7 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3597,6 +3558,8 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3630,7 +3593,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3639,7 +3602,7 @@ static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3651,6 +3614,8 @@ static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3707,7 +3672,7 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3715,11 +3680,13 @@ static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
 	target_ht_irq(irq, dest, cfg->vector);
+
+	return 0;
 }
 
 #endif
@@ -3794,6 +3761,8 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	unsigned long flags;
 	int err;
 
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
 	cfg = irq_cfg(irq);
 
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
@@ -3807,15 +3776,13 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	entry->vector = cfg->vector;
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode = apic->irq_dest_mode;
-	entry->polarity = 0;
-	entry->trigger = 0;
-	entry->mask = 0;
-	entry->dest = apic->cpu_mask_to_apicid(eligible_cpu);
+	entry->vector		= cfg->vector;
+	entry->delivery_mode	= apic->irq_delivery_mode;
+	entry->dest_mode	= apic->irq_dest_mode;
+	entry->polarity		= 0;
+	entry->trigger		= 0;
+	entry->mask		= 0;
+	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
@@ -3833,10 +3800,10 @@ void arch_disable_uv_irq(int mmr_blade, unsigned long mmr_offset)
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode;
 
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
 	entry->mask = 1;
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
@@ -3900,6 +3867,71 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
+static int __io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *irq_attr)
+{
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int node;
+	int ioapic, pin;
+	int trigger, polarity;
+
+	ioapic = irq_attr->ioapic;
+	if (!IO_APIC_IRQ(irq)) {
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
+			ioapic);
+		return -EINVAL;
+	}
+
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+		return 0;
+	}
+
+	pin = irq_attr->ioapic_pin;
+	trigger = irq_attr->trigger;
+	polarity = irq_attr->polarity;
+
+	/*
+	 * IRQs < 16 are already in the irq_2_pin[] map
+	 */
+	if (irq >= NR_IRQS_LEGACY) {
+		cfg = desc->chip_data;
+		add_pin_to_irq_node(cfg, node, ioapic, pin);
+	}
+
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, trigger, polarity);
+
+	return 0;
+}
+
+int io_apic_set_pci_routing(struct device *dev, int irq,
+				struct io_apic_irq_attr *irq_attr)
+{
+	int ioapic, pin;
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
+	ioapic = irq_attr->ioapic;
+	pin = irq_attr->ioapic_pin;
+	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[ioapic].apicid, pin);
+		return 0;
+	}
+	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
+
+	return __io_apic_set_pci_routing(dev, irq, irq_attr);
+}
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
@@ -3980,6 +4012,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 
 	return apic_id;
 }
+#endif
 
 int __init io_apic_get_version(int ioapic)
 {
@@ -3992,39 +4025,6 @@ int __init io_apic_get_version(int ioapic)
 
 	return reg_01.bits.version;
 }
-#endif
-
-int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
-{
-	struct irq_desc *desc;
-	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
-
-	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			ioapic);
-		return -EINVAL;
-	}
-
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
-	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc %d\n", irq);
-		return 0;
-	}
-
-	/*
-	 * IRQs < 16 are already in the irq_2_pin[] map
-	 */
-	if (irq >= NR_IRQS_LEGACY) {
-		cfg = desc->chip_data;
-		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
-	}
-
-	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
-
-	return 0;
-}
-
 
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
@@ -4055,51 +4055,44 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic, irq, irq_entry;
+	int pin, ioapic = 0, irq, irq_entry;
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
-		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
-			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-			if (irq_entry == -1)
-				continue;
-			irq = pin_2_irq(irq_entry, ioapic, pin);
-
-			/* setup_IO_APIC_irqs could fail to get vector for some device
-			 * when you have too many devices, because at that time only boot
-			 * cpu is online.
-			 */
-			desc = irq_to_desc(irq);
-			cfg = desc->chip_data;
-			if (!cfg->vector) {
-				setup_IO_APIC_irq(ioapic, pin, irq, desc,
-						  irq_trigger(irq_entry),
-						  irq_polarity(irq_entry));
-				continue;
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic) {
+		ioapic = mp_find_ioapic(0);
+		if (ioapic < 0)
+			ioapic = 0;
+	}
+#endif
 
-			}
+	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
+		if (irq_entry == -1)
+			continue;
+		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-			/*
-			 * Honour affinities which have been set in early boot
-			 */
-			if (desc->status &
-			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = desc->affinity;
-			else
-				mask = apic->target_cpus();
+		desc = irq_to_desc(irq);
 
-			if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq_desc(desc, mask);
-			else
-				set_ioapic_affinity_irq_desc(desc, mask);
-		}
+		/*
+		 * Honour affinities which have been set in early boot
+		 */
+		if (desc->status &
+		    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
+			mask = desc->affinity;
+		else
+			mask = apic->target_cpus();
 
+		if (intr_remapping_enabled)
+			set_ir_ioapic_affinity_irq_desc(desc, mask);
+		else
+			set_ioapic_affinity_irq_desc(desc, mask);
 	}
+
 }
 #endif
 
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 1783652..bc3e880 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -50,7 +50,7 @@ static struct apic *apic_probe[] __initdata = {
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (x2apic && (apic != &apic_x2apic_phys &&
+	if (x2apic_mode && (apic != &apic_x2apic_phys &&
 #ifdef CONFIG_X86_UV
 		       apic != &apic_x2apic_uv_x &&
 #endif
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9cfe1f4..344eee4 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -173,13 +173,6 @@ static inline int is_WPEG(struct rio_detail *rio){
 		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
 }
 
-
-/* In clustered mode, the high nibble of APIC ID is a cluster number.
- * The low nibble is a 4-bit bitmap. */
-#define XAPIC_DEST_CPUS_SHIFT	4
-#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
-#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
-
 #define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
 static const struct cpumask *summit_target_cpus(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2bda693..780a733 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -105,7 +105,7 @@ static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 #ifdef CONFIG_SMP
 	unsigned long val;
@@ -583,15 +583,18 @@ void __init uv_system_init(void)
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_blade_info);
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
 	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_node_to_blade);
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
 	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_cpu_to_blade);
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..728b375 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -272,7 +272,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = hard_smp_processor_id();
+	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 77848d9..b0517aa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -299,7 +299,8 @@ static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
 
 void load_percpu_segment(int cpu)
 {
@@ -768,6 +769,12 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
+	/* Clear/Set all flags overriden by options, after probe */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 #ifdef CONFIG_X86_64
 	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
 #endif
@@ -813,6 +820,16 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 
 	init_hypervisor(c);
+
+	/*
+	 * Clear/Set all flags overriden by options, need do it
+	 * before following smp all cpus cap AND.
+	 */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -825,10 +842,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..2fc4f6b 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -588,8 +588,20 @@ static void print_apic(void *arg)
 	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
 	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
 	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
-#endif /* CONFIG_X86_LOCAL_APIC */
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int i, v, maxeilvt;
+
+		v = apic_read(APIC_EFEAT);
+		maxeilvt = (v >> 16) & 0xff;
+		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
+		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
 
+		for (i = 0; i < maxeilvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
+		}
+	}
+#endif /* CONFIG_X86_LOCAL_APIC */
 	seq_printf(seq, "\n MSR\t:\n");
 }
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7437fa1..daed39b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -229,12 +229,12 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 }
 #endif
 
-static void __cpuinit srat_detect_node(void)
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	unsigned node;
 	int cpu = smp_processor_id();
-	int apicid = hard_smp_processor_id();
+	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
@@ -400,7 +400,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	}
 
 	/* Work around errata */
-	srat_detect_node();
+	srat_detect_node(c);
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3fe010..c1739ac 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -24,9 +24,9 @@ void (*generic_interrupt_extension)(void) = NULL;
  */
 void ack_bad_irq(unsigned int irq)
 {
-	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+	if (printk_ratelimit())
+		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
 	 * We _must_ ack these because every local APIC has only N
@@ -36,9 +36,7 @@ void ack_bad_irq(unsigned int irq)
 	 * completely.
 	 * But only ack when the APIC is enabled -AK
 	 */
-	if (cpu_has_apic)
-		ack_APIC_irq();
-#endif
+	ack_APIC_irq();
 }
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
@@ -178,7 +176,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_thermal_count;
 # ifdef CONFIG_X86_64
 	sum += irq_stats(cpu)->irq_threshold_count;
-#endif
+# endif
 #endif
 	return sum;
 }
@@ -213,14 +211,11 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
-		if (!disable_apic)
-			ack_APIC_irq();
-#endif
+		ack_APIC_irq();
 
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
-			       __func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
+				__func__, smp_processor_id(), vector, irq);
 	}
 
 	irq_exit();
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit.c
similarity index 68%
rename from arch/x86/kernel/irqinit_32.c
rename to arch/x86/kernel/irqinit.c
index 368b0a8..2e08b10 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit.c
@@ -1,20 +1,25 @@
+#include <linux/linkage.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
+#include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/kprobes.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/delay.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
+#include <asm/hw_irq.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
@@ -22,7 +27,23 @@
 #include <asm/i8259.h>
 #include <asm/traps.h>
 
+/*
+ * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
+ * (these are usually mapped to vectors 0x30-0x3f)
+ */
+
+/*
+ * The IO-APIC gives us many more interrupt sources. Most of these
+ * are unused but an SMP system is supposed to have enough memory ...
+ * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
+ * across the spectrum, so we really want to be prepared to get all
+ * of these. Plus, more powerful systems might have more than 64
+ * IO-APIC registers.
+ *
+ * (these are usually mapped into the 0x30-0xff vector range)
+ */
 
+#ifdef CONFIG_X86_32
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
  * as the irq is unreliable, and exception 16 works correctly
@@ -52,30 +73,7 @@ static struct irqaction fpu_irq = {
 	.handler = math_error_irq,
 	.name = "fpu",
 };
-
-void __init init_ISA_irqs(void)
-{
-	int i;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	init_bsp_APIC();
 #endif
-	init_8259A(0);
-
-	/*
-	 * 16 old-style INTA-cycle interrupts:
-	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					      handle_level_irq, "XT");
-	}
-}
 
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
@@ -118,29 +116,37 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-void __init native_init_IRQ(void)
+static void __init init_ISA_irqs(void)
 {
 	int i;
 
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
+	init_bsp_APIC();
+#endif
+	init_8259A(0);
 
 	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
+	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					      handle_level_irq, "XT");
 	}
+}
 
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+static void __init smp_intr_init(void)
+{
+#ifdef CONFIG_SMP
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -160,16 +166,27 @@ void __init native_init_IRQ(void)
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
-	/* IPI for single call function */
+	/* IPI for generic single function call */
 	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				 call_function_single_interrupt);
+			call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
+#endif /* CONFIG_SMP */
+}
+
+static void __init apic_intr_init(void)
+{
+	smp_intr_init();
+
+#ifdef CONFIG_X86_64
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+#endif
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -179,16 +196,67 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+	/* Performance monitoring interrupts: */
+# ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
+# endif
+
 #endif
 
+#ifdef CONFIG_X86_32
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#endif
+}
+
+/**
+ * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
+ *
+ * Description:
+ *	Perform any necessary interrupt initialisation prior to setting up
+ *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
+ *	interrupts should be initialised here if the machine emulates a PC
+ *	in any way.
+ **/
+static void __init x86_quirk_pre_intr_init(void)
+{
+#ifdef CONFIG_X86_32
+	if (x86_quirks->arch_pre_intr_init) {
+		if (x86_quirks->arch_pre_intr_init())
+			return;
+	}
+#endif
+	init_ISA_irqs();
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
+
+	apic_intr_init();
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
+		if (!test_bit(i, used_vectors))
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Call quirks after call gates are initialised (usually add in
 	 * the architecture specific gates):
@@ -203,4 +271,5 @@ void __init native_init_IRQ(void)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
 	irq_ctx_init(smp_processor_id());
+#endif
 }
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
deleted file mode 100644
index 8cd1053..0000000
--- a/arch/x86/kernel/irqinit_64.c
+++ /dev/null
@@ -1,177 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
-#include <linux/random.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
-#include <linux/bitops.h>
-#include <linux/acpi.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <asm/hw_irq.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/apic.h>
-#include <asm/i8259.h>
-
-/*
- * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x30-0x3f)
- */
-
-/*
- * The IO-APIC gives us many more interrupt sources. Most of these
- * are unused but an SMP system is supposed to have enough memory ...
- * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
- * across the spectrum, so we really want to be prepared to get all
- * of these. Plus, more powerful systems might have more than 64
- * IO-APIC registers.
- *
- * (these are usually mapped into the 0x30-0xff vector range)
- */
-
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.name = "cascade",
-};
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
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
-};
-
-int vector_used_by_percpu_irq(unsigned int vector)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
-			return 1;
-	}
-
-	return 0;
-}
-
-static void __init init_ISA_irqs(void)
-{
-	int i;
-
-	init_bsp_APIC();
-	init_8259A(0);
-
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		/*
-		 * 16 old-style INTA-cycle interrupts:
-		 */
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-						      handle_level_irq, "XT");
-	}
-}
-
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-static void __init smp_intr_init(void)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for generic single function call */
-	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-			call_function_single_interrupt);
-
-	/* Low priority IPI to cleanup after moving an irq */
-	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
-	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
-#endif
-}
-
-static void __init apic_intr_init(void)
-{
-	smp_intr_init();
-
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
-
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* generic IPI for platform specific use */
-	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-}
-
-void __init native_init_IRQ(void)
-{
-	int i;
-
-	init_ISA_irqs();
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
-	}
-
-	apic_intr_init();
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-}
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 70fd7e4..651c93b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -17,6 +17,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/pci.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -870,24 +871,17 @@ static
 inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */
 
-static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
-		      int count)
+static int
+check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	if (!mpc_new_phys) {
-		pr_info("No spare slots, try to append...take your risk, "
-			"new mpc_length %x\n", count);
-	} else {
-		if (count <= mpc_new_length)
-			pr_info("No spare slots, try to append..., "
-				"new mpc_length %x\n", count);
-		else {
-			pr_err("mpc_new_length %lx is too small\n",
-				mpc_new_length);
-			return -1;
-		}
+	int ret = 0;
+
+	if (!mpc_new_phys || count <= mpc_new_length) {
+		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
+		return -1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
@@ -946,7 +940,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
@@ -963,11 +957,14 @@ out:
 	return 0;
 }
 
-static int __initdata enable_update_mptable;
+int enable_update_mptable;
 
 static int __init update_mptable_setup(char *str)
 {
 	enable_update_mptable = 1;
+#ifdef CONFIG_PCI
+	pci_routeirq = 1;
+#endif
 	return 0;
 }
 early_param("update_mptable", update_mptable_setup);
@@ -980,6 +977,9 @@ static int __initdata alloc_mptable;
 static int __init parse_alloc_mptable_opt(char *p)
 {
 	enable_update_mptable = 1;
+#ifdef CONFIG_PCI
+	pci_routeirq = 1;
+#endif
 	alloc_mptable = 1;
 	if (!p)
 		return 0;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..523bb69 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -997,24 +997,6 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 
 /**
- * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-void __init x86_quirk_pre_intr_init(void)
-{
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-	init_ISA_irqs();
-}
-
-/**
  * x86_quirk_intr_init - post gate setup interrupt initialisation
  *
  * Description:
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..f6db48c 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -193,19 +193,19 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 }
 
 struct smp_ops smp_ops = {
-	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
-	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.smp_cpus_done = native_smp_cpus_done,
+	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
+	.smp_prepare_cpus	= native_smp_prepare_cpus,
+	.smp_cpus_done		= native_smp_cpus_done,
 
-	.smp_send_stop = native_smp_send_stop,
-	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_send_stop		= native_smp_send_stop,
+	.smp_send_reschedule	= native_smp_send_reschedule,
 
-	.cpu_up = native_cpu_up,
-	.cpu_die = native_cpu_die,
-	.cpu_disable = native_cpu_disable,
-	.play_dead = native_play_dead,
+	.cpu_up			= native_cpu_up,
+	.cpu_die		= native_cpu_die,
+	.cpu_disable		= native_cpu_disable,
+	.play_dead		= native_play_dead,
 
-	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_ipi	= native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..7c80007 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -504,7 +504,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __devinit
+int __cpuinit
 wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-int __devinit
+static int __cpuinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -822,10 +822,12 @@ do_rest:
 	/* mark "stuck" area as not stuck */
 	*((volatile unsigned long *)trampoline_base) = 0;
 
-	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
+	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
 
 	return boot_error;
 }
@@ -990,10 +992,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
 	    !cpu_has_apic) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_physical_apicid);
-		printk(KERN_ERR "... forcing use of dummy APIC emulation."
+		if (!disable_apic) {
+			pr_err("BIOS bug, local APIC #%d not detected!...\n",
+				boot_cpu_physical_apicid);
+			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
+		}
 		smpboot_clear_io_apic();
 		arch_disable_smp_support();
 		return -1;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..2310700 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -969,11 +969,8 @@ void __init trap_init(void)
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
-#ifdef CONFIG_X86_64
 	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
-#else
-	set_bit(SYSCALL_VECTOR, used_vectors);
-#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index ca7ec44..45acbcf 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -636,7 +636,7 @@ static void __init lguest_init_IRQ(void)
 
 void lguest_setup_irq(unsigned int irq)
 {
-	irq_to_desc_alloc_cpu(irq, 0);
+	irq_to_desc_alloc_node(irq, 0);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index fecbce6..0696d50 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -889,6 +889,9 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		return 0;
 	}
 
+	if (io_apic_assign_pci_irqs)
+		return 0;
+
 	/* Find IRQ routing entry */
 
 	if (!pirq_table)
@@ -1039,56 +1042,15 @@ static void __init pcibios_fixup_irqs(void)
 		pirq_penalty[dev->irq]++;
 	}
 
+	if (io_apic_assign_pci_irqs)
+		return;
+
 	dev = NULL;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 		if (!pin)
 			continue;
 
-#ifdef CONFIG_X86_IO_APIC
-		/*
-		 * Recalculate IRQ numbers if we use the I/O APIC.
-		 */
-		if (io_apic_assign_pci_irqs) {
-			int irq;
-
-			/*
-			 * interrupt pins are numbered starting from 1
-			 */
-			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-				PCI_SLOT(dev->devfn), pin - 1);
-			/*
-			 * Busses behind bridges are typically not listed in the
-			 * MP-table.  In this case we have to look up the IRQ
-			 * based on the parent bus, parent slot, and pin number.
-			 * The SMP code detects such bridged busses itself so we
-			 * should get into this branch reliably.
-			 */
-			if (irq < 0 && dev->bus->parent) {
-				/* go back to the bridge */
-				struct pci_dev *bridge = dev->bus->self;
-				int bus;
-
-				pin = pci_swizzle_interrupt_pin(dev, pin);
-				bus = bridge->bus->number;
-				irq = IO_APIC_get_PCI_irq_vector(bus,
-						PCI_SLOT(bridge->devfn), pin - 1);
-				if (irq >= 0)
-					dev_warn(&dev->dev,
-						"using bridge %s INT %c to "
-							"get IRQ %d\n",
-						 pci_name(bridge),
-						 'A' + pin - 1, irq);
-			}
-			if (irq >= 0) {
-				dev_info(&dev->dev,
-					"PCI->APIC IRQ transform: INT %c "
-						"-> IRQ %d\n",
-					'A' + pin - 1, irq);
-				dev->irq = irq;
-			}
-		}
-#endif
 		/*
 		 * Still no IRQ? Try to lookup one...
 		 */
@@ -1183,6 +1145,19 @@ int __init pcibios_irq_init(void)
 	pcibios_enable_irq = pirq_enable_irq;
 
 	pcibios_fixup_irqs();
+
+	if (io_apic_assign_pci_irqs && pci_routeirq) {
+		struct pci_dev *dev = NULL;
+		/*
+		 * PCI IRQ routing is set up by pci_enable_device(), but we
+		 * also do it here in case there are still broken drivers that
+		 * don't use pci_enable_device().
+		 */
+		printk(KERN_INFO "PCI: Routing PCI interrupts for all devices because \"pci=routeirq\" specified\n");
+		for_each_pci_dev(dev)
+			pirq_enable_irq(dev);
+	}
+
 	return 0;
 }
 
@@ -1213,16 +1188,23 @@ void pcibios_penalize_isa_irq(int irq, int active)
 static int pirq_enable_irq(struct pci_dev *dev)
 {
 	u8 pin;
-	struct pci_dev *temp_dev;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-	if (pin && !pcibios_lookup_irq(dev, 1) && !dev->irq) {
+	if (pin && !pcibios_lookup_irq(dev, 1)) {
 		char *msg = "";
 
+		if (!io_apic_assign_pci_irqs && dev->irq)
+			return 0;
+
 		if (io_apic_assign_pci_irqs) {
+#ifdef CONFIG_X86_IO_APIC
+			struct pci_dev *temp_dev;
 			int irq;
+			struct io_apic_irq_attr irq_attr;
 
-			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number, PCI_SLOT(dev->devfn), pin - 1);
+			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+						PCI_SLOT(dev->devfn),
+						pin - 1, &irq_attr);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1235,7 +1217,8 @@ static int pirq_enable_irq(struct pci_dev *dev)
 
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
-						PCI_SLOT(bridge->devfn), pin - 1);
+						PCI_SLOT(bridge->devfn),
+						pin - 1, &irq_attr);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
@@ -1245,12 +1228,15 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
+				io_apic_set_pci_routing(&dev->dev, irq,
+							 &irq_attr);
+				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
-				dev->irq = irq;
 				return 0;
 			} else
 				msg = "; probably buggy MP table";
+#endif
 		} else if (pci_probe & PCI_BIOS_IRQ_SCAN)
 			msg = "";
 		else
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 51b9f82..2faa9e2 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -401,7 +401,8 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
-			acpi_register_gsi(dev->irq, ACPI_LEVEL_SENSITIVE,
+			acpi_register_gsi(&dev->dev, dev->irq,
+					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
 		} else {
@@ -410,7 +411,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		}
 	}
 
-	rc = acpi_register_gsi(gsi, triggering, polarity);
+	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (rc < 0) {
 		dev_warn(&dev->dev, "PCI INT %c: failed to register GSI\n",
 			 pin_name(pin));
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 340ba4f..4a9f349 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -224,7 +224,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 			break;
 		}
 
-		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+		gsi = acpi_register_gsi(NULL, irq, ACPI_LEVEL_SENSITIVE,
 					ACPI_ACTIVE_LOW);
 		if (gsi > 0)
 			break;
@@ -939,7 +939,7 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		irqp = &res->data.extended_irq;
 
 		for (i = 0; i < irqp->interrupt_count; i++) {
-			irq = acpi_register_gsi(irqp->interrupts[i],
+			irq = acpi_register_gsi(NULL, irqp->interrupts[i],
 				      irqp->triggering, irqp->polarity);
 			if (irq < 0)
 				return AE_ERROR;
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 73348c4..4a9cc92 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -702,7 +702,7 @@ static unsigned int iosapic_startup_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void iosapic_set_affinity_irq(unsigned int irq,
+static int iosapic_set_affinity_irq(unsigned int irq,
 				     const struct cpumask *dest)
 {
 	struct vector_info *vi = iosapic_get_vector(irq);
@@ -712,7 +712,7 @@ static void iosapic_set_affinity_irq(unsigned int irq,
 
 	dest_cpu = cpu_check_affinity(irq, dest);
 	if (dest_cpu < 0)
-		return;
+		return -1;
 
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(dest_cpu));
 	vi->txn_addr = txn_affinity_addr(irq, dest_cpu);
@@ -724,6 +724,8 @@ static void iosapic_set_affinity_irq(unsigned int irq,
 	iosapic_set_irt_data(vi, &dummy_d0, &d1);
 	iosapic_wr_irt_entry(vi, d0, d1);
 	spin_unlock_irqrestore(&iosapic_lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index dd18f85..42e4260 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -153,45 +153,47 @@ int ibmphp_init_devno(struct slot **cur_slot)
 		return -1;
 	}
 	for (loop = 0; loop < len; loop++) {
-		if ((*cur_slot)->number == rtable->slots[loop].slot) {
-		if ((*cur_slot)->bus == rtable->slots[loop].bus) {
+		if ((*cur_slot)->number == rtable->slots[loop].slot &&
+		    (*cur_slot)->bus == rtable->slots[loop].bus) {
+			struct io_apic_irq_attr irq_attr;
+
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i);
-
-				debug("(*cur_slot)->irq[0] = %x\n",
-						(*cur_slot)->irq[0]);
-				debug("(*cur_slot)->irq[1] = %x\n",
-						(*cur_slot)->irq[1]);
-				debug("(*cur_slot)->irq[2] = %x\n",
-						(*cur_slot)->irq[2]);
-				debug("(*cur_slot)->irq[3] = %x\n",
-						(*cur_slot)->irq[3]);
-
-				debug("rtable->exlusive_irqs = %x\n",
+						(int) (*cur_slot)->device, i,
+						&irq_attr);
+
+			debug("(*cur_slot)->irq[0] = %x\n",
+					(*cur_slot)->irq[0]);
+			debug("(*cur_slot)->irq[1] = %x\n",
+					(*cur_slot)->irq[1]);
+			debug("(*cur_slot)->irq[2] = %x\n",
+					(*cur_slot)->irq[2]);
+			debug("(*cur_slot)->irq[3] = %x\n",
+					(*cur_slot)->irq[3]);
+
+			debug("rtable->exlusive_irqs = %x\n",
 					rtable->exclusive_irqs);
-				debug("rtable->slots[loop].irq[0].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[0].bitmap = %x\n",
 					rtable->slots[loop].irq[0].bitmap);
-				debug("rtable->slots[loop].irq[1].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[1].bitmap = %x\n",
 					rtable->slots[loop].irq[1].bitmap);
-				debug("rtable->slots[loop].irq[2].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[2].bitmap = %x\n",
 					rtable->slots[loop].irq[2].bitmap);
-				debug("rtable->slots[loop].irq[3].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[3].bitmap = %x\n",
 					rtable->slots[loop].irq[3].bitmap);
 
-				debug("rtable->slots[loop].irq[0].link = %x\n",
+			debug("rtable->slots[loop].irq[0].link = %x\n",
 					rtable->slots[loop].irq[0].link);
-				debug("rtable->slots[loop].irq[1].link = %x\n",
+			debug("rtable->slots[loop].irq[1].link = %x\n",
 					rtable->slots[loop].irq[1].link);
-				debug("rtable->slots[loop].irq[2].link = %x\n",
+			debug("rtable->slots[loop].irq[2].link = %x\n",
 					rtable->slots[loop].irq[2].link);
-				debug("rtable->slots[loop].irq[3].link = %x\n",
+			debug("rtable->slots[loop].irq[3].link = %x\n",
 					rtable->slots[loop].irq[3].link);
-				debug("end of init_devno\n");
-				kfree(rtable);
-				return 0;
-			}
+			debug("end of init_devno\n");
+			kfree(rtable);
+			return 0;
 		}
 	}
 
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 6808d83..737a1c4 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -98,6 +98,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	int max_irq;
 	int pos;
 	int irq;
+	int node;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,7 +126,8 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	irq = create_irq();
+	node = dev_to_node(&dev->dev);
+	irq = create_irq_nr(0, node);
 
 	if (irq <= 0) {
 		kfree(cfg);
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a563fbe..cd38916 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1972,15 +1972,6 @@ static int __init init_dmars(void)
 		}
 	}
 
-#ifdef CONFIG_INTR_REMAP
-	if (!intr_remapping_enabled) {
-		ret = enable_intr_remapping(0);
-		if (ret)
-			printk(KERN_ERR
-			       "IOMMU: enable interrupt remapping failed\n");
-	}
-#endif
-
 	/*
 	 * For each rmrr
 	 *   for each dev attached to rmrr
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f5e0ea7..3a0cb0b 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -15,6 +15,14 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
+static int disable_intremap;
+static __init int setup_nointremap(char *str)
+{
+	disable_intremap = 1;
+	return 0;
+}
+early_param("nointremap", setup_nointremap);
+
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -23,15 +31,12 @@ struct irq_2_iommu {
 };
 
 #ifdef CONFIG_GENERIC_HARDIRQS
-static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int node)
 {
 	struct irq_2_iommu *iommu;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	iommu = kzalloc_node(sizeof(*iommu), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "alloc irq_2_iommu on cpu %d node %d\n", cpu, node);
+	printk(KERN_DEBUG "alloc irq_2_iommu on node %d\n", node);
 
 	return iommu;
 }
@@ -48,7 +53,7 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
@@ -56,7 +61,7 @@ static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
 	/*
 	 * alloc irq desc if not allocated already.
 	 */
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -65,14 +70,14 @@ static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
 	irq_iommu = desc->irq_2_iommu;
 
 	if (!irq_iommu)
-		desc->irq_2_iommu = get_one_free_irq_2_iommu(cpu);
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(node);
 
 	return desc->irq_2_iommu;
 }
 
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
-	return irq_2_iommu_alloc_cpu(irq, boot_cpu_id);
+	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
 }
 
 #else /* !CONFIG_SPARSE_IRQ */
@@ -423,20 +428,6 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 		      readl, (sts & DMA_GSTS_IRTPS), sts);
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 
-	if (mode == 0) {
-		spin_lock_irqsave(&iommu->register_lock, flags);
-
-		/* enable comaptiblity format interrupt pass through */
-		cmd = iommu->gcmd | DMA_GCMD_CFI;
-		iommu->gcmd |= DMA_GCMD_CFI;
-		writel(cmd, iommu->reg + DMAR_GCMD_REG);
-
-		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
-			      readl, (sts & DMA_GSTS_CFIS), sts);
-
-		spin_unlock_irqrestore(&iommu->register_lock, flags);
-	}
-
 	/*
 	 * global invalidation of interrupt entry cache before enabling
 	 * interrupt-remapping.
@@ -516,6 +507,23 @@ end:
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
+int __init intr_remapping_supported(void)
+{
+	struct dmar_drhd_unit *drhd;
+
+	if (disable_intremap)
+		return 0;
+
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			return 0;
+	}
+
+	return 1;
+}
+
 int __init enable_intr_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index adf1785..7f207f3 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -123,7 +123,7 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
 	}
 
 	flags = irq_flags(triggering, polarity, shareable);
-	irq = acpi_register_gsi(gsi, triggering, polarity);
+	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (irq >= 0)
 		pcibios_penalize_isa_irq(irq, 1);
 	else
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..be437c2 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -335,7 +335,7 @@ static int find_unbound_irq(void)
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	desc = irq_to_desc_alloc_cpu(irq, 0);
+	desc = irq_to_desc_alloc_node(irq, 0);
 	if (WARN_ON(desc == NULL))
 		return -1;
 
@@ -688,13 +688,13 @@ void rebind_evtchn_irq(int evtchn, int irq)
 }
 
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
+static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
 
 	if (!VALID_EVTCHN(evtchn))
-		return;
+		return -1;
 
 	/* Send future instances of this interrupt to other vcpu. */
 	bind_vcpu.port = evtchn;
@@ -707,13 +707,15 @@ static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	 */
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
-}
 
+	return 0;
+}
 
-static void set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
-	rebind_irq_to_cpu(irq, tcpu);
+
+	return rebind_irq_to_cpu(irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 88be890..51b4b0a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -119,7 +119,7 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
-int acpi_register_gsi (u32 gsi, int triggering, int polarity);
+int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index e397dc3..10ff5c4 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -108,6 +108,7 @@ struct irte {
 };
 #ifdef CONFIG_INTR_REMAP
 extern int intr_remapping_enabled;
+extern int intr_remapping_supported(void);
 extern int enable_intr_remapping(int);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
@@ -157,6 +158,8 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
 }
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
+#define disable_intr_remapping()	(0)
+#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
 #endif
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 91bb76f..ff374ce 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -566,6 +566,6 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..eedbb8e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -117,7 +117,7 @@ struct irq_chip {
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq,
+	int		(*set_affinity)(unsigned int irq,
 					const struct cpumask *dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
@@ -187,7 +187,7 @@ struct irq_desc {
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
-	unsigned int		cpu;
+	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
@@ -201,26 +201,23 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int cpu);
+					struct irq_desc *desc, int node);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-#else /* CONFIG_SPARSE_IRQ */
-extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
-#endif /* CONFIG_SPARSE_IRQ */
-
-extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+#endif
 
-static inline struct irq_desc *
-irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
-{
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-	return irq_to_desc(irq);
+#ifdef CONFIG_NUMA_IRQ_DESC
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
 #else
+static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
+{
 	return desc;
-#endif
 }
+#endif
+
+extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 /*
  * Migration helpers for obsolete names, they will go away:
@@ -386,7 +383,7 @@ extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want);
+extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
@@ -424,47 +421,48 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
 #ifdef CONFIG_SMP
 /**
- * init_alloc_desc_masks - allocate cpumasks for irq_desc
+ * alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
  * @cpu:	cpu which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
  * Returns true if successful (or not required).
- * Side effect: affinity has all bits set, pending_mask has all bits clear.
  */
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 								bool boot)
 {
-	int node;
-
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	if (boot) {
 		alloc_bootmem_cpumask_var(&desc->affinity);
-		cpumask_setall(desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 		alloc_bootmem_cpumask_var(&desc->pending_mask);
-		cpumask_clear(desc->pending_mask);
 #endif
 		return true;
 	}
 
-	node = cpu_to_node(cpu);
-
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
-	cpumask_setall(desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
 		free_cpumask_var(desc->affinity);
 		return false;
 	}
-	cpumask_clear(desc->pending_mask);
+#endif
 #endif
 	return true;
 }
 
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
+}
+
 /**
  * init_copy_desc_masks - copy cpumasks for irq_desc
  * @old_desc:	pointer to old irq_desc struct
@@ -478,7 +476,7 @@ static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
-#ifdef CONFIG_CPUMASKS_OFFSTACK
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	cpumask_copy(new_desc->affinity, old_desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -499,12 +497,16 @@ static inline void free_desc_masks(struct irq_desc *old_desc,
 
 #else /* !CONFIG_SMP */
 
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 								bool boot)
 {
 	return true;
 }
 
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+}
+
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 3394f8f..7d04780 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -3,5 +3,5 @@ obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_NUMA_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c687ba4..13c68e7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -359,7 +359,6 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -438,7 +437,6 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	spin_unlock(&desc->lock);
 }
@@ -475,7 +473,6 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
 		mask_ack_irq(desc, irq);
-		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -483,7 +480,6 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	/* Start handling the irq */
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -544,10 +540,8 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi) {
+	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
 }
 
 void
@@ -582,10 +576,8 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip) {
+		if (desc->chip != &no_irq_chip)
 			mask_ack_irq(desc, irq);
-			desc = irq_remap_to_desc(irq, desc);
-		}
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 26e0875..18041a2 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
@@ -81,45 +82,48 @@ static struct irq_desc irq_desc_init = {
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
-void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
+void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
-	int node;
 	void *ptr;
 
-	node = cpu_to_node(cpu);
-	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
+	if (slab_is_available())
+		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+				   GFP_ATOMIC, node);
+	else
+		ptr = alloc_bootmem_node(NODE_DATA(node),
+				nr * sizeof(*desc->kstat_irqs));
 
 	/*
 	 * don't overwite if can not get new one
 	 * init_copy_kstat_irqs() could still use old one
 	 */
 	if (ptr) {
-		printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n",
-			 cpu, node);
+		printk(KERN_DEBUG "  alloc kstat_irqs on node %d\n", node);
 		desc->kstat_irqs = ptr;
 	}
 }
 
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
 	spin_lock_init(&desc->lock);
 	desc->irq = irq;
 #ifdef CONFIG_SMP
-	desc->cpu = cpu;
+	desc->node = node;
 #endif
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_kstat_irqs(desc, cpu, nr_cpu_ids);
+	init_kstat_irqs(desc, node, nr_cpu_ids);
 	if (!desc->kstat_irqs) {
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, node, false)) {
 		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
 		BUG_ON(1);
 	}
-	arch_init_chip_data(desc, cpu);
+	init_desc_masks(desc);
+	arch_init_chip_data(desc, node);
 }
 
 /*
@@ -169,7 +173,8 @@ int __init early_irq_init(void)
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		irq_desc_ptrs[i] = desc + i;
 	}
 
@@ -187,11 +192,10 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
-	int node;
 
 	if (irq >= nr_irqs) {
 		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
@@ -210,15 +214,17 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 	if (desc)
 		goto out_unlock;
 
-	node = cpu_to_node(cpu);
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc irq_desc for %d on cpu %d node %d\n",
-		 irq, cpu, node);
+	if (slab_is_available())
+		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	else
+		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+
+	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	init_one_irq_desc(irq, desc, cpu);
+	init_one_irq_desc(irq, desc, node);
 
 	irq_desc_ptrs[irq] = desc;
 
@@ -256,7 +262,8 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];
 	}
 	return arch_early_irq_init();
@@ -267,7 +274,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	return irq_to_desc(irq);
 }
@@ -453,11 +460,8 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack) {
+		if (desc->chip->ack)
 			desc->chip->ack(irq);
-			/* get new one */
-			desc = irq_remap_to_desc(irq, desc);
-		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -468,10 +472,8 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack) {
+	if (desc->chip->ack)
 		desc->chip->ack(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 01ce20e..7346825 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -16,7 +16,7 @@ extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
-extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 extern void clear_kstat_irqs(struct irq_desc *desc);
 extern spinlock_t sparse_irq_lock;
 
@@ -42,6 +42,9 @@ static inline void unregister_handler_proc(unsigned int irq,
 
 extern int irq_select_affinity_usr(unsigned int irq);
 
+extern void
+irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
+
 /*
  * Debugging printout:
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..aaf5c9d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -80,7 +80,7 @@ int irq_can_set_affinity(unsigned int irq)
 	return 1;
 }
 
-static void
+void
 irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
 	struct irqaction *action = desc->action;
@@ -109,17 +109,22 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT)
-		desc->chip->set_affinity(irq, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT) {
+		if (!desc->chip->set_affinity(irq, cpumask)) {
+			cpumask_copy(desc->affinity, cpumask);
+			irq_set_thread_affinity(desc, cpumask);
+		}
+	}
 	else {
 		desc->status |= IRQ_MOVE_PENDING;
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	cpumask_copy(desc->affinity, cpumask);
-	desc->chip->set_affinity(irq, cpumask);
+	if (!desc->chip->set_affinity(irq, cpumask)) {
+		cpumask_copy(desc->affinity, cpumask);
+		irq_set_thread_affinity(desc, cpumask);
+	}
 #endif
-	irq_set_thread_affinity(desc, cpumask);
 	desc->status |= IRQ_AFFINITY_SET;
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index e05ad9b..cfe767c 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -1,5 +1,8 @@
 
 #include <linux/irq.h>
+#include <linux/interrupt.h>
+
+#include "internals.h"
 
 void move_masked_irq(int irq)
 {
@@ -39,11 +42,12 @@ void move_masked_irq(int irq)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids)) {
-		cpumask_and(desc->affinity,
-			    desc->pending_mask, cpu_online_mask);
-		desc->chip->set_affinity(irq, desc->affinity);
-	}
+		   < nr_cpu_ids))
+		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+			cpumask_copy(desc->affinity, desc->pending_mask);
+			irq_set_thread_affinity(desc, desc->pending_mask);
+		}
+
 	cpumask_clear(desc->pending_mask);
 }
 
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 44bbdcb..2f69bee 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -15,9 +15,9 @@
 
 static void init_copy_kstat_irqs(struct irq_desc *old_desc,
 				 struct irq_desc *desc,
-				 int cpu, int nr)
+				 int node, int nr)
 {
-	init_kstat_irqs(desc, cpu, nr);
+	init_kstat_irqs(desc, node, nr);
 
 	if (desc->kstat_irqs != old_desc->kstat_irqs)
 		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
@@ -34,20 +34,20 @@ static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
 }
 
 static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
-		 struct irq_desc *desc, int cpu)
+		 struct irq_desc *desc, int node)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, node, false)) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
 				"for migration.\n", irq);
 		return false;
 	}
 	spin_lock_init(&desc->lock);
-	desc->cpu = cpu;
+	desc->node = node;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
 	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, cpu);
+	arch_init_copy_chip_data(old_desc, desc, node);
 	return true;
 }
 
@@ -59,12 +59,11 @@ static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
 }
 
 static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
-						int cpu)
+						int node)
 {
 	struct irq_desc *desc;
 	unsigned int irq;
 	unsigned long flags;
-	int node;
 
 	irq = old_desc->irq;
 
@@ -76,7 +75,6 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	if (desc && old_desc != desc)
 		goto out_unlock;
 
-	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 	if (!desc) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc "
@@ -85,7 +83,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 		desc = old_desc;
 		goto out_unlock;
 	}
-	if (!init_copy_one_irq_desc(irq, old_desc, desc, cpu)) {
+	if (!init_copy_one_irq_desc(irq, old_desc, desc, node)) {
 		/* still use old one */
 		kfree(desc);
 		desc = old_desc;
@@ -97,9 +95,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 
 	/* free the old one */
 	free_one_irq_desc(old_desc, desc);
-	spin_unlock(&old_desc->lock);
 	kfree(old_desc);
-	spin_lock(&desc->lock);
 
 	return desc;
 
@@ -109,24 +105,14 @@ out_unlock:
 	return desc;
 }
 
-struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
+struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
-	int old_cpu;
-	int node, old_node;
-
 	/* those all static, do move them */
 	if (desc->irq < NR_IRQS_LEGACY)
 		return desc;
 
-	old_cpu = desc->cpu;
-	if (old_cpu != cpu) {
-		node = cpu_to_node(cpu);
-		old_node = cpu_to_node(old_cpu);
-		if (old_node != node)
-			desc = __real_move_irq_desc(desc, cpu);
-		else
-			desc->cpu = cpu;
-	}
+	if (desc->node != node)
+		desc = __real_move_irq_desc(desc, node);
 
 	return desc;
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b525dd3..f674f33 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -828,7 +828,7 @@ int __init __weak arch_early_irq_init(void)
 	return 0;
 }
 
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int node)
 {
 	return 0;
 }
