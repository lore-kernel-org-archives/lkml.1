Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYBIKCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYBIKCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYBIKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:02:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39117 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbYBIKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:02:40 -0500
Date: Sat, 9 Feb 2008 11:02:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] kbuild updates
Message-ID: <20080209100242.GA5301@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull from kbuild.git:

ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

Only noteworthy change is the introduction of HAVE_IDE.
Adding HAVE_IDE touches all arch Kconfig files as seen in
the diffstat. The win is that we can avoid a particular ugly
conditional in arm and we are much closer to introduce
drivers/Kconfig for arm.

Following archs do not yet use drivers/Kconfig:
arm, cris, h8300 (soon to be deleted I think), um, v850

And I assume at least arm and cris will be fixed soon.

I am aware of outstanding issues around section type
conflict errors but that will wait until the
kids are healthy and I can get some sleep :-(
I hope to address most issues in the rc1 window.

	Sam



Geert Uytterhoeven (1):
      kbuild/modpost: Use warn() for announcing section mismatches

Michal Sojka (1):
      Kbuild: Fix deb-pkg target to work with kernel versions ending with -<text-without-digit>

Mike Frysinger (1):
      kbuild: silence CHK/UPD messages according to $(quiet)

Sam Ravnborg (3):
      kbuild/modpost: improve warnings if symbol is unknown
      scsi: fix makefile for aic7(3*x)
      ide: introduce HAVE_IDE

Uwe Kleine-König (1):
      Add binoffset to gitignore

 arch/alpha/Kconfig            |    1 +
 arch/arm/Kconfig              |   19 ++++++++++++++-----
 arch/avr32/Kconfig            |    1 +
 arch/blackfin/Kconfig         |    1 +
 arch/cris/Kconfig             |    1 +
 arch/frv/Kconfig              |    1 +
 arch/h8300/Kconfig            |    1 +
 arch/ia64/Kconfig             |    1 +
 arch/m32r/Kconfig             |    1 +
 arch/m68k/Kconfig             |    1 +
 arch/m68knommu/Kconfig        |    1 +
 arch/mips/Kconfig             |    1 +
 arch/parisc/Kconfig           |    1 +
 arch/powerpc/Kconfig          |    1 +
 arch/ppc/Kconfig              |    1 +
 arch/sh/Kconfig               |    1 +
 arch/sparc/Kconfig            |    1 +
 arch/sparc64/Kconfig          |    1 +
 arch/v850/Kconfig             |    1 +
 arch/x86/Kconfig              |    1 +
 arch/xtensa/Kconfig           |    1 +
 drivers/ide/Kconfig           |    6 +++++-
 drivers/pcmcia/Kconfig        |    1 +
 drivers/scsi/aic7xxx/Makefile |    4 ++--
 init/Makefile                 |    4 +++-
 scripts/.gitignore            |    1 +
 scripts/Kbuild.include        |    8 ++++++--
 scripts/mod/modpost.c         |   37 ++++++++++++++++++++++---------------
 scripts/package/builddeb      |    3 ++-
 29 files changed, 76 insertions(+), 27 deletions(-)
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5b7dcd5..002703b 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4127af9..9619c43 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -222,6 +222,7 @@ config ARCH_CLPS7500
 	select TIMER_ACORN
 	select ISA
 	select NO_IOPORT
+	select HAVE_IDE
 	help
 	  Support for the Cirrus Logic PS7500FE system-on-a-chip.
 
@@ -234,6 +235,7 @@ config ARCH_CO285
 	bool "Co-EBSA285"
 	select FOOTBRIDGE
 	select FOOTBRIDGE_ADDIN
+	select HAVE_IDE
 	help
 	  Support for Intel's EBSA285 companion chip.
 
@@ -258,6 +260,7 @@ config ARCH_EP93XX
 config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select FOOTBRIDGE
+	select HAVE_IDE
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -296,6 +299,7 @@ config ARCH_IOP32X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
+	select HAVE_IDE
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -305,12 +309,14 @@ config ARCH_IOP33X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
+	select HAVE_IDE
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
 config ARCH_IXP23XX
  	bool "IXP23XX-based"
 	depends on MMU
+	select HAVE_IDE
  	select PCI
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
@@ -328,12 +334,14 @@ config ARCH_IXP4XX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_IDE
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
 
 config ARCH_L7200
 	bool "LinkUp-L7200"
 	select FIQ
+	select HAVE_IDE
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -388,6 +396,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
+	select HAVE_IDE
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -403,6 +412,7 @@ config ARCH_RPC
 	select ARCH_MAY_HAVE_PC_FDC
 	select ISA_DMA_API
 	select NO_IOPORT
+	select HAVE_IDE
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -414,12 +424,14 @@ config ARCH_SA1100
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
 	select GENERIC_TIME
+	select HAVE_IDE
 	help
 	  Support for StrongARM 11x0 based boards.
 
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
+	select HAVE_IDE
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -427,6 +439,7 @@ config ARCH_S3C2410
 
 config ARCH_SHARK
 	bool "Shark"
+	select HAVE_IDE
 	select ISA
 	select ISA_DMA
 	select PCI
@@ -436,6 +449,7 @@ config ARCH_SHARK
 
 config ARCH_LH7A40X
 	bool "Sharp LH7A40X"
+	select HAVE_IDE
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -1093,12 +1107,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/misc/Kconfig"
 
-if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
-	|| ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
-	|| ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
-	|| ARCH_IXP23XX
 source "drivers/ide/Kconfig"
-endif
 
 source "drivers/scsi/Kconfig"
 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 28e0caf..c75d708 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 368bc7f..589c6ac 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 config ZONE_DMA
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 8456bc8..9389d38 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -54,6 +54,7 @@ config FORCE_MAX_ZONEORDER
 config CRIS
 	bool
 	default y
+	select HAVE_IDE
 
 config HZ
 	int
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 9e561ed..a5aac1b 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -5,6 +5,7 @@
 config FRV
 	bool
 	default y
+	select HAVE_IDE
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index f69e5ea..085dc6e 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -8,6 +8,7 @@ mainmenu "uClinux/h8300 (w/o MMU) Kernel Configuration"
 config H8300
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index b0de113..2d4fcd0 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index d4679ab..de153de 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuration"
 config M32R
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 config SBUS
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2b0ed89..65db226 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -5,6 +5,7 @@
 config M68K
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 548a7b3..07eb4c4 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -8,6 +8,7 @@ mainmenu "uClinux/68k (w/o MMU) Kernel Configuration"
 config M68K
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ec78a57..ade230d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index d929ac8..bc7a19d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configuration"
 
 config PARISC
 	def_bool y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 26b963c..485513c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,6 +87,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index 531156f..abc877f 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -42,6 +42,7 @@ config GENERIC_CALIBRATE_DELAY
 config PPC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6e035d1..d87d4bf 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configuration"
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 7c674a3..c40343c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -69,6 +69,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 # Identify this as a Sparc32 build
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index b810f2b..8107556 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -14,6 +14,7 @@ config SPARC
 config SPARC64
 	bool
 	default y
+	select HAVE_IDE
 	help
 	  SPARC is a family of RISC microprocessors designed and marketed by
 	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index 7b6d371..4379f43 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -78,6 +78,7 @@ config MCA
 config V850
 	bool
 	default y
+	select HAVE_IDE
 
 menu "Processor type and features"
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 65a70b7..3bd42da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -18,6 +18,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index fd36764..9fc8551 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -14,6 +14,7 @@ config ZONE_DMA
 config XTENSA
 	bool
 	default y
+	select HAVE_IDE
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index ab8fb25..043c34a 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -4,10 +4,14 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
+# Select HAVE_IDE if IDE is supported
+config HAVE_IDE
+	def_bool n
+
 menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on HAVE_IDE
 	depends on BLOCK
-	depends on HAS_IOMEM
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 519b4ff..8b22281 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,6 +38,7 @@ config PCMCIA_DEBUG
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
+	select HAVE_IDE
 	default y
 	---help---
 	   This option enables support for 16-bit PCMCIA cards. Most older
diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 4c54954..741d818 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -44,8 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 
 # Dependencies for generated files need to be listed explicitly
 
-$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
-$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
+$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
 aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c
diff --git a/init/Makefile b/init/Makefile
index 633392f..c5f157c 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -27,7 +27,9 @@ $(obj)/version.o: include/linux/compile.h
 # mkcompile_h will make sure to only update the
 # actual file if its content has changed.
 
+ quiet_chk_compile.h = echo '  CHK     $@'
+silent_chk_compile.h = :
 include/linux/compile.h: FORCE
-	@echo '  CHK     $@'
+	@$($(quiet)chk_compile.h)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
 	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(KBUILD_CFLAGS)"
diff --git a/scripts/.gitignore b/scripts/.gitignore
index a1f52cb..b939fbd 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -6,3 +6,4 @@ kallsyms
 pnmtologo
 bin2c
 unifdef
+binoffset
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index b96ea8d..da3559e 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -39,15 +39,19 @@ escsq = $(subst $(squote),'\$(squote)',$1)
 # - If they are equal no change, and no timestamp update
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
+ quiet_chk_filechk = echo '  CHK     $@'
+silent_chk_filechk = :
+ quiet_upd_filechk = echo '  UPD     $@'
+silent_upd_filechk = :
 define filechk
 	$(Q)set -e;				\
-	echo '  CHK     $@';			\
+	$($(quiet)chk_filechk);			\
 	mkdir -p $(dir $@);			\
 	$(filechk_$(1)) < $< > $@.tmp;		\
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
 		rm -f $@.tmp;			\
 	else					\
-		echo '  UPD     $@';		\
+		$($(quiet)upd_filechk);		\
 		mv -f $@.tmp $@;		\
 	fi
 endef
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5d54646..dbe1fb5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -613,7 +613,7 @@ static const char *sym_name(struct elf_info *elf, Elf_Sym *sym)
 	if (sym)
 		return elf->strtab + sym->st_name;
 	else
-		return "";
+		return "(unknown)";
 }
 
 static const char *sec_name(struct elf_info *elf, int shndx)
@@ -1102,7 +1102,7 @@ static int is_function(Elf_Sym *sym)
 	if (sym)
 		return ELF_ST_TYPE(sym->st_info) == STT_FUNC;
 	else
-		return 0;
+		return -1;
 }
 
 /*
@@ -1120,24 +1120,31 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 {
 	const char *from, *from_p;
 	const char *to, *to_p;
-	from = from_is_func ? "function" : "variable";
-	from_p = from_is_func ? "()" : "";
-	to = to_is_func ? "function" : "variable";
-	to_p = to_is_func ? "()" : "";
+
+	switch (from_is_func) {
+	case 0: from = "variable"; from_p = "";   break;
+	case 1: from = "function"; from_p = "()"; break;
+	default: from = "(unknown reference)"; from_p = ""; break;
+	}
+	switch (to_is_func) {
+	case 0: to = "variable"; to_p = "";   break;
+	case 1: to = "function"; to_p = "()"; break;
+	default: to = "(unknown reference)"; to_p = ""; break;
+	}
 
 	sec_mismatch_count++;
 	if (!sec_mismatch_verbose)
 		return;
 
-	fprintf(stderr, "WARNING: %s(%s+0x%llx): Section mismatch in"
-	                " reference from the %s %s%s to the %s %s:%s%s\n",
-                        modname, fromsec, fromaddr, from, fromsym, from_p,
-	                to, tosec, tosym, to_p);
+	warn("%s(%s+0x%llx): Section mismatch in reference from the %s %s%s "
+	     "to the %s %s:%s%s\n",
+	     modname, fromsec, fromaddr, from, fromsym, from_p, to, tosec,
+	     tosym, to_p);
 
 	switch (mismatch) {
 	case TEXT_TO_INIT:
 		fprintf(stderr,
-		"The function %s %s() references\n"
+		"The function %s%s() references\n"
 		"the %s %s%s%s.\n"
 		"This is often because %s lacks a %s\n"
 		"annotation or the annotation of %s is wrong.\n",
@@ -1938,10 +1945,10 @@ int main(int argc, char **argv)
 	if (dump_write)
 		write_dump(dump_write);
 	if (sec_mismatch_count && !sec_mismatch_verbose)
-		fprintf(stderr, "modpost: Found %d section mismatch(es).\n"
-		        "To see full details build your kernel with:\n"
-		        "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
-		        sec_mismatch_count);
+		warn("modpost: Found %d section mismatch(es).\n"
+		     "To see full details build your kernel with:\n"
+		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
+		     sec_mismatch_count);
 
 	return err;
 }
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 0f657b5..ba6bf5d 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -13,6 +13,7 @@ set -e
 
 # Some variables and settings used throughout the script
 version=$KERNELRELEASE
+revision=`cat .version`
 tmpdir="$objtree/debian/tmp"
 packagename=linux-$version
 
@@ -65,7 +66,7 @@ done
 name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
-linux ($version) unstable; urgency=low
+linux ($version-$revision) unstable; urgency=low
 
   * A standard release
 
