Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968476Ab0B0PCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:02:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab0B0PCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:02:43 -0500
Date: Sat, 27 Feb 2010 16:02:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups changes for v2.6.34
Message-ID: <20100227150230.GA2874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, mtrr: Remove unused mtrr/state.c

Frans Pop (1):
      x86: Remove trailing spaces in messages

Thadeu Lima de Souza Cascardo (1):
      x86, trivial: Fix grammo in tsc comment about Geode TSC reliability


 arch/x86/boot/mkcpustr.c          |    2 +-
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/apic/io_apic.c    |    2 +-
 arch/x86/kernel/apic/numaq_32.c   |    2 +-
 arch/x86/kernel/apm_32.c          |    4 +-
 arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
 arch/x86/kernel/cpu/mtrr/state.c  |   94 -------------------------------------
 arch/x86/kernel/efi.c             |    2 +-
 arch/x86/kernel/microcode_intel.c |    2 +-
 arch/x86/kernel/tsc.c             |    2 +-
 arch/x86/kernel/uv_sysfs.c        |    6 +-
 arch/x86/tools/test_get_len.c     |    4 +-
 12 files changed, 15 insertions(+), 109 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/mtrr/state.c

diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 8ef60f2..919257f 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -22,7 +22,7 @@ int main(void)
 	int i, j;
 	const char *str;
 
-	printf("static const char x86_cap_strs[] = \n");
+	printf("static const char x86_cap_strs[] =\n");
 
 	for (i = 0; i < NCAPINTS; i++) {
 		for (j = 0; j < 32; j++) {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e80f291..71c4443 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -587,7 +587,7 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
 		res = (((u64)(*deltatsc)) * pm_100ms);
 		do_div(res, deltapm);
 		apic_printk(APIC_VERBOSE, "TSC delta adjusted to "
-					  "PM-Timer: %lu (%ld) \n",
+					  "PM-Timer: %lu (%ld)\n",
 					(unsigned long)res, *deltatsc);
 		*deltatsc = (long)res;
 	}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53243ca..6bdd2c7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1647,7 +1647,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
 	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			  " Stat Dmod Deli Vect:   \n");
+			  " Stat Dmod Deli Vect:\n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 98c4665..47dd856 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -225,7 +225,7 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 
 	mpc_record = 0;
 	printk(KERN_INFO
-		"Found an OEM MPC table at %8p - parsing it ... \n", oemtable);
+		"Found an OEM MPC table at %8p - parsing it...\n", oemtable);
 
 	if (memcmp(oemtable->signature, MPC_OEM_SIGNATURE, 4)) {
 		printk(KERN_WARNING
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index b5b6b23..031aa88 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1992,8 +1992,8 @@ static int __init apm_is_horked_d850md(const struct dmi_system_id *d)
 		apm_info.disabled = 1;
 		printk(KERN_INFO "%s machine detected. "
 		       "Disabling APM.\n", d->ident);
-		printk(KERN_INFO "This bug is fixed in bios P15 which is available for \n");
-		printk(KERN_INFO "download from support.intel.com \n");
+		printk(KERN_INFO "This bug is fixed in bios P15 which is available for\n");
+		printk(KERN_INFO "download from support.intel.com\n");
 	}
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..ad9e5ed 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,3 @@
-obj-y		:= main.o if.o generic.o state.o cleanup.o
+obj-y		:= main.o if.o generic.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
 
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
deleted file mode 100644
index dfc80b4..0000000
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ /dev/null
@@ -1,94 +0,0 @@
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/mm.h>
-
-#include <asm/processor-cyrix.h>
-#include <asm/processor-flags.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-
-#include "mtrr.h"
-
-/* Put the processor into a state where MTRRs can be safely set */
-void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
-{
-	unsigned int cr0;
-
-	/* Disable interrupts locally */
-	local_irq_save(ctxt->flags);
-
-	if (use_intel() || is_cpu(CYRIX)) {
-
-		/* Save value of CR4 and clear Page Global Enable (bit 7) */
-		if (cpu_has_pge) {
-			ctxt->cr4val = read_cr4();
-			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
-		}
-
-		/*
-		 * Disable and flush caches. Note that wbinvd flushes the TLBs
-		 * as a side-effect
-		 */
-		cr0 = read_cr0() | X86_CR0_CD;
-		wbinvd();
-		write_cr0(cr0);
-		wbinvd();
-
-		if (use_intel()) {
-			/* Save MTRR state */
-			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		} else {
-			/*
-			 * Cyrix ARRs -
-			 * everything else were excluded at the top
-			 */
-			ctxt->ccr3 = getCx86(CX86_CCR3);
-		}
-	}
-}
-
-void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
-{
-	if (use_intel()) {
-		/* Disable MTRRs, and set the default type to uncached */
-		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
-		      ctxt->deftype_hi);
-	} else {
-		if (is_cpu(CYRIX)) {
-			/* Cyrix ARRs - everything else were excluded at the top */
-			setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
-		}
-	}
-}
-
-/* Restore the processor after a set_mtrr_prepare */
-void set_mtrr_done(struct set_mtrr_context *ctxt)
-{
-	if (use_intel() || is_cpu(CYRIX)) {
-
-		/* Flush caches and TLBs */
-		wbinvd();
-
-		/* Restore MTRRdefType */
-		if (use_intel()) {
-			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
-				   ctxt->deftype_hi);
-		} else {
-			/*
-			 * Cyrix ARRs -
-			 * everything else was excluded at the top
-			 */
-			setCx86(CX86_CCR3, ctxt->ccr3);
-		}
-
-		/* Enable caches */
-		write_cr0(read_cr0() & 0xbfffffff);
-
-		/* Restore value of CR4 */
-		if (cpu_has_pge)
-			write_cr4(ctxt->cr4val);
-	}
-	/* Re-enable interrupts locally (if enabled previously) */
-	local_irq_restore(ctxt->flags);
-}
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index cdcfb12..c2fa9b8 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -362,7 +362,7 @@ void __init efi_init(void)
 		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
 	early_iounmap(tmp, 2);
 
-	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
+	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index ebd193e..85a343e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -328,7 +328,7 @@ static int apply_microcode(int cpu)
 		       cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
-	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x \n",
+	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
 		cpu_num, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..23066ec 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -806,7 +806,7 @@ static void __init check_system_tsc_reliable(void)
 	unsigned long res_low, res_high;
 
 	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
-	/* Geode_LX - the OLPC CPU has a possibly a very reliable TSC */
+	/* Geode_LX - the OLPC CPU has a very reliable TSC */
 	if (res_low & RTSC_SUSP)
 		tsc_clocksource_reliable = 1;
 #endif
diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/kernel/uv_sysfs.c
index 36afb98..309c70f 100644
--- a/arch/x86/kernel/uv_sysfs.c
+++ b/arch/x86/kernel/uv_sysfs.c
@@ -54,19 +54,19 @@ static int __init sgi_uv_sysfs_init(void)
 	if (!sgi_uv_kobj)
 		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
 	if (!sgi_uv_kobj) {
-		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed \n");
+		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed\n");
 		return -EINVAL;
 	}
 
 	ret = sysfs_create_file(sgi_uv_kobj, &partition_id_attr.attr);
 	if (ret) {
-		printk(KERN_WARNING "sysfs_create_file partition_id failed \n");
+		printk(KERN_WARNING "sysfs_create_file partition_id failed\n");
 		return ret;
 	}
 
 	ret = sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);
 	if (ret) {
-		printk(KERN_WARNING "sysfs_create_file coherence_id failed \n");
+		printk(KERN_WARNING "sysfs_create_file coherence_id failed\n");
 		return ret;
 	}
 
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index bee8d6a..13403fc 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -43,7 +43,7 @@ static int x86_64;
 static void usage(void)
 {
 	fprintf(stderr, "Usage: objdump -d a.out | awk -f distill.awk |"
-		" %s [-y|-n] [-v] \n", prog);
+		" %s [-y|-n] [-v]\n", prog);
 	fprintf(stderr, "\t-y	64bit mode\n");
 	fprintf(stderr, "\t-n	32bit mode\n");
 	fprintf(stderr, "\t-v	verbose mode\n");
@@ -69,7 +69,7 @@ static void dump_field(FILE *fp, const char *name, const char *indent,
 
 static void dump_insn(FILE *fp, struct insn *insn)
 {
-	fprintf(fp, "Instruction = { \n");
+	fprintf(fp, "Instruction = {\n");
 	dump_field(fp, "prefixes", "\t",	&insn->prefixes);
 	dump_field(fp, "rex_prefix", "\t",	&insn->rex_prefix);
 	dump_field(fp, "vex_prefix", "\t",	&insn->vex_prefix);
