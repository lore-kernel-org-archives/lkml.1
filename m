Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZIUM7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZIUM7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZIUM7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:59:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57055 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZIUM7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:59:34 -0400
Date: Mon, 21 Sep 2009 14:59:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 fixes
Message-ID: <20090921125920.GA18445@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This bit:

  out-of-topic modifications in x86-fixes-for-linus:
  --------------------------------------------------
  drivers/acpi/acpica/tbfadt.c       # 878f4f5: x86: Trivial whitespace cleanups

Came with an x86 patch and looked trivial enough (a oneliner) to keep in 
one piece. Len, do you mind it going this way?

 Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86: Print the hypervisor returned tsc_khz during boot

Andi Kleen (1):
      x86: Remove final bits of CONFIG_X86_OLD_MCE

Andreas Herrmann (1):
      x86, mce: Fix compile warning in case of CONFIG_SMP=n

Cyrill Gorcunov (1):
      x86, apic: Fix missed handling of discrete apics

Daniel Walker (1):
      x86: apic: Convert BUG() to BUG_ON()

Felipe Contreras (1):
      x86: Trivial whitespace cleanups

Huang Weiyi (1):
      x86/i386: Remove duplicated #include

Jack Steiner (3):
      x86: SGI UV: Fix IPI macros
      x86: SGI UV: Add volatile semantics to macros that access chipset registers
      x86: SGI UV: Map MMIO-High memory range

Jan Beulich (3):
      x86: Increase timeout for EHCI debug port reset completion in early printk
      x86: cpuinit-annotate SMP boot trampolines properly
      x86: Correct segment permission flags in 64-bit linker script

Joe Perches (1):
      x86, mtrr: Convert loop to a while based construct, avoid naked semicolon

Sergey Senozhatsky (1):
      x86: Fix uaccess_32.h typo

Suresh Siddha (1):
      x86, apic: Use logical flat on intel with <= 8 logical cpus

Yinghai Lu (1):
      Revert 'x86: Fix system crash when loading with "reservetop" parameter'


 arch/x86/include/asm/apic.h          |   13 +++++++++++++
 arch/x86/include/asm/string_32.h     |    1 -
 arch/x86/include/asm/uaccess_32.h    |    2 +-
 arch/x86/include/asm/uv/uv_hub.h     |   19 ++++++++++---------
 arch/x86/kernel/apic/apic.c          |   31 ++++++++++---------------------
 arch/x86/kernel/apic/io_apic.c       |    4 ++--
 arch/x86/kernel/apic/probe_64.c      |   15 +++++++++++----
 arch/x86/kernel/apic/x2apic_uv_x.c   |   11 +++++++++++
 arch/x86/kernel/cpu/common.c         |    1 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
 arch/x86/kernel/cpu/mtrr/if.c        |   12 ++++++------
 arch/x86/kernel/cpu/vmware.c         |    6 ++++++
 arch/x86/kernel/early_printk.c       |    2 +-
 arch/x86/kernel/setup.c              |   30 +++++++++++++++---------------
 arch/x86/kernel/trampoline.c         |    4 ++--
 arch/x86/kernel/trampoline_32.S      |    8 ++------
 arch/x86/kernel/trampoline_64.S      |    5 +++--
 arch/x86/kernel/tsc.c                |    2 +-
 arch/x86/kernel/vmlinux.lds.S        |    4 ++--
 arch/x86/power/cpu.c                 |    4 ----
 drivers/acpi/acpica/tbfadt.c         |    1 -
 21 files changed, 98 insertions(+), 80 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c6d21b1..474d80d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -66,6 +66,19 @@ static inline void default_inquire_remote_apic(int apicid)
 }
 
 /*
+ * With 82489DX we can't rely on apic feature bit
+ * retrieved via cpuid but still have to deal with
+ * such an apic chip so we assume that SMP configuration
+ * is found from MP table (64bit case uses ACPI mostly
+ * which set smp presence flag as well so we are safe
+ * to use this helper too).
+ */
+static inline bool apic_from_smp_config(void)
+{
+	return smp_found_config && !disable_apic;
+}
+
+/*
  * Basic functions accessing APICs.
  */
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index c86f452..ae907e6 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -65,7 +65,6 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 	case 4:
 		*(int *)to = *(int *)from;
 		return to;
-
 	case 3:
 		*(short *)to = *(short *)from;
 		*((char *)to + 2) = *((char *)from + 2);
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 5e06259..632fb44 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -33,7 +33,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
  * The caller should also make sure he pins the user space address
- * so that the we don't result in page fault and sleep.
+ * so that we don't result in page fault and sleep.
  *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 77a6850..04eb6c9 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -15,6 +15,7 @@
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
+#include <linux/io.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
@@ -258,13 +259,13 @@ static inline unsigned long *uv_global_mmr32_address(int pnode,
 static inline void uv_write_global_mmr32(int pnode, unsigned long offset,
 				 unsigned long val)
 {
-	*uv_global_mmr32_address(pnode, offset) = val;
+	writeq(val, uv_global_mmr32_address(pnode, offset));
 }
 
 static inline unsigned long uv_read_global_mmr32(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr32_address(pnode, offset);
+	return readq(uv_global_mmr32_address(pnode, offset));
 }
 
 /*
@@ -281,13 +282,13 @@ static inline unsigned long *uv_global_mmr64_address(int pnode,
 static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
 				unsigned long val)
 {
-	*uv_global_mmr64_address(pnode, offset) = val;
+	writeq(val, uv_global_mmr64_address(pnode, offset));
 }
 
 static inline unsigned long uv_read_global_mmr64(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr64_address(pnode, offset);
+	return readq(uv_global_mmr64_address(pnode, offset));
 }
 
 /*
@@ -301,22 +302,22 @@ static inline unsigned long *uv_local_mmr_address(unsigned long offset)
 
 static inline unsigned long uv_read_local_mmr(unsigned long offset)
 {
-	return *uv_local_mmr_address(offset);
+	return readq(uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr(unsigned long offset, unsigned long val)
 {
-	*uv_local_mmr_address(offset) = val;
+	writeq(val, uv_local_mmr_address(offset));
 }
 
 static inline unsigned char uv_read_local_mmr8(unsigned long offset)
 {
-	return *((unsigned char *)uv_local_mmr_address(offset));
+	return readb(uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
 {
-	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+	writeb(val, uv_local_mmr_address(offset));
 }
 
 /*
@@ -422,7 +423,7 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 	unsigned long val;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a34601f..a58ef98 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,7 +62,7 @@ unsigned int boot_cpu_physical_apicid = -1U;
 /*
  * The highest APIC ID seen during enumeration.
  *
- * This determines the messaging protocol we can use: if all APIC IDs
+ * On AMD, this determines the messaging protocol we can use: if all APIC IDs
  * are in the 0 ... 7 range, then we can use logical addressing which
  * has some performance advantages (better broadcasting).
  *
@@ -979,7 +979,7 @@ void lapic_shutdown(void)
 {
 	unsigned long flags;
 
-	if (!cpu_has_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return;
 
 	local_irq_save(flags);
@@ -1197,8 +1197,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
-	if (!apic->apic_id_registered())
-		BUG();
+	BUG_ON(!apic->apic_id_registered());
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
@@ -1917,24 +1916,14 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	/*
-	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
-	 * but we need to work other dependencies like SMP_SUSPEND etc
-	 * before this can be done without some confusion.
-	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
-	 *       - Ashok Raj <ashok.raj@intel.com>
-	 */
-	if (max_physical_apicid >= 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (num_processors > 8)
+			def_to_bigsmp = 1;
+		break;
+	case X86_VENDOR_AMD:
+		if (max_physical_apicid >= 8)
 			def_to_bigsmp = 1;
-		}
 	}
 #endif
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 809e1cf..64970b9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1874,7 +1874,7 @@ __apicdebuginit(int) print_all_ICs(void)
 	print_PIC();
 
 	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
 	print_all_local_APICs();
@@ -1999,7 +1999,7 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	if (cpu_has_apic)
+	if (cpu_has_apic || apic_from_smp_config())
 		disconnect_bsp_APIC(!intr_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 65edc18..c4cbd30 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -64,16 +64,23 @@ void __init default_setup_apic_routing(void)
 			apic = &apic_x2apic_phys;
 		else
 			apic = &apic_x2apic_cluster;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 #endif
 
 	if (apic == &apic_flat) {
-		if (max_physical_apicid >= 8)
-			apic = &apic_physflat;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (num_processors > 8)
+				apic = &apic_physflat;
+			break;
+		case X86_VENDOR_AMD:
+			if (max_physical_apicid >= 8)
+				apic = &apic_physflat;
+		}
 	}
 
+	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 6011593..f5f5886 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -389,6 +389,16 @@ static __init void map_gru_high(int max_pnode)
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
+static __init void map_mmr_high(int max_pnode)
+{
+	union uvh_rh_gam_mmr_overlay_config_mmr_u mmr;
+	int shift = UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT;
+
+	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
+	if (mmr.s.enable)
+		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+}
+
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
@@ -643,6 +653,7 @@ void __init uv_system_init(void)
 	}
 
 	map_gru_high(max_pnode);
+	map_mmr_high(max_pnode);
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2055fc2..2fea97e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -34,7 +34,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
-#include <linux/smp.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 8cd5224..83a3d1f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -489,8 +489,9 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
+#ifdef CONFIG_SMP
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
+#endif
 
 	sprintf(name, "threshold_bank%i", bank);
 
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 08b6ea4..f04e725 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -126,8 +126,8 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 
 	base = simple_strtoull(line + 5, &ptr, 0);
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
@@ -135,14 +135,14 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	size = simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	if (strncmp(ptr, "type=", 5))
 		return -EINVAL;
 	ptr += 5;
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 0a46b4d..1cbed97 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -58,6 +58,9 @@ static unsigned long vmware_get_tsc_khz(void)
 	tsc_hz = eax | (((uint64_t)ebx) << 32);
 	do_div(tsc_hz, 1000);
 	BUG_ON(tsc_hz >> 32);
+	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
+			 (unsigned long) tsc_hz / 1000,
+			 (unsigned long) tsc_hz % 1000);
 	return tsc_hz;
 }
 
@@ -69,6 +72,9 @@ void __init vmware_platform_setup(void)
 
 	if (ebx != UINT_MAX)
 		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
+	else
+		printk(KERN_WARNING
+		       "Failed to get TSC freq from the hypervisor\n");
 }
 
 /*
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 335f049..b11cab3 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -624,7 +624,7 @@ try_next_port:
 		return -1;
 	}
 
-	loop = 10;
+	loop = 100000;
 	/* Reset the EHCI controller */
 	cmd = readl(&ehci_regs->command);
 	cmd |= CMD_RESET;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a55f660..f327bcc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -697,21 +697,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-#ifdef CONFIG_X86_64
-	/*
-	 * Must call this twice: Once just to detect whether hardware doesn't
-	 * support NX (so that the early EHCI debug console setup can safely
-	 * call set_fixmap(), and then again after parsing early parameters to
-	 * honor the respective command line option.
-	 */
-	check_efer();
-#endif
-
-	parse_early_param();
-
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
@@ -794,6 +779,21 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Must call this twice: Once just to detect whether hardware doesn't
+	 * support NX (so that the early EHCI debug console setup can safely
+	 * call set_fixmap(), and then again after parsing early parameters to
+	 * honor the respective command line option.
+	 */
+	check_efer();
+#endif
+
+	parse_early_param();
+
 #ifdef CONFIG_X86_64
 	check_efer();
 #endif
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index 808031a..699f7ee 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -4,7 +4,7 @@
 #include <asm/e820.h>
 
 /* ready for x86_64 and x86 */
-unsigned char *trampoline_base = __va(TRAMPOLINE_BASE);
+unsigned char *__cpuinitdata trampoline_base = __va(TRAMPOLINE_BASE);
 
 void __init reserve_trampoline_memory(void)
 {
@@ -26,7 +26,7 @@ void __init reserve_trampoline_memory(void)
  * bootstrap into the page concerned. The caller
  * has made sure it's suitably aligned.
  */
-unsigned long setup_trampoline(void)
+unsigned long __cpuinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 66d874e..8508237 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -28,16 +28,12 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
-#ifndef CONFIG_HOTPLUG_CPU
-.section ".cpuinit.data","aw",@progbits
-#else
-.section .rodata,"a",@progbits
-#endif
-
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index cddfb8d..596d54c 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -25,14 +25,15 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/pgtable_types.h>
 #include <asm/page_types.h>
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
-.section .rodata, "a", @progbits
-
+/* We can free up the trampoline after bootup if cpu hotplug is not supported. */
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 17409e8..cd982f4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -666,7 +666,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
 			(val == CPUFREQ_RESUMECHANGE)) {
-		*lpj = 	cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
+		*lpj = cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0ccb57d..a46accc 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -45,9 +45,9 @@ PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(7);          /* RWE */
 #ifdef CONFIG_X86_64
-	user PT_LOAD FLAGS(7);          /* RWE */
+	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);        /* RWE */
+	percpu PT_LOAD FLAGS(6);        /* RW_ */
 #endif
 	init PT_LOAD FLAGS(7);          /* RWE */
 #endif
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 417c9f5..8aa85f1 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -243,10 +243,6 @@ static void __restore_processor_state(struct saved_context *ctxt)
 
 	do_fpu_end();
 	mtrr_bp_restore();
-
-#ifdef CONFIG_X86_OLD_MCE
-	mcheck_init(&boot_cpu_data);
-#endif
 }
 
 /* Needed by apm.c */
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 82b02dc..c016335 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -275,7 +275,6 @@ void acpi_tb_parse_fadt(u32 table_index)
 
 void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 {
-
 	/*
 	 * Check if the FADT is larger than the largest table that we expect
 	 * (the ACPI 2.0/3.0 version). If so, truncate the table, and issue
