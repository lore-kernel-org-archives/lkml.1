Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXH0Vm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXH0Vm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXH0Va0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:30:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58885 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932575AbXH0V37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:59 -0400
Date: Mon, 27 Aug 2007 23:29:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kumar Gala <galak@freescale.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [2.6 patch] ppc: remove APUS support
Message-ID: <20070827212953.GK26410@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Current status of APUS:
- arch/powerpc/: removed in 2.6.23
- arch/ppc/: marked BROKEN since 2 years

This patch therefore removes the remaining parts of APUS support.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 29 Jul 2007
- 1 Jul 2007

Due to a charset problem that might corrupt the patch (a comment 
contains a non UTF-8 character) the same patch is also attached 
compressed.

 arch/m68k/amiga/chipram.c           |    2 
 arch/powerpc/kernel/setup_32.c      |    1 
 arch/ppc/Kconfig                    |  148 ----
 arch/ppc/Makefile                   |    1 
 arch/ppc/amiga/Makefile             |    8 
 arch/ppc/amiga/amiga_ksyms.c        |    1 
 arch/ppc/amiga/amiints.c            |  322 ---------
 arch/ppc/amiga/amisound.c           |    1 
 arch/ppc/amiga/bootinfo.c           |   78 --
 arch/ppc/amiga/chipram.c            |    1 
 arch/ppc/amiga/cia.c                |  176 -----
 arch/ppc/amiga/config.c             |  953 ----------------------------
 arch/ppc/amiga/ints.c               |  158 ----
 arch/ppc/amiga/pcmcia.c             |    1 
 arch/ppc/amiga/time.c               |   57 -
 arch/ppc/configs/apus_defconfig     |  920 ---------------------------
 arch/ppc/kernel/head.S              |  117 ---
 arch/ppc/kernel/ppc_ksyms.c         |    3 
 arch/ppc/kernel/setup.c             |    1 
 arch/ppc/mm/pgtable.c               |   38 -
 arch/ppc/platforms/Makefile         |    4 
 arch/ppc/platforms/apus_pci.c       |  207 ------
 arch/ppc/platforms/apus_pci.h       |   34 
 arch/ppc/platforms/apus_setup.c     |  798 -----------------------
 drivers/ide/ide-probe.c             |    8 
 drivers/isdn/hisax/avm_pci.c        |    8 
 drivers/scsi/a2091.c                |    3 
 drivers/scsi/a3000.c                |    3 
 drivers/scsi/gvp11.c                |    3 
 drivers/scsi/oktagon_esp.c          |    2 
 drivers/scsi/oktagon_io.S           |   72 --
 drivers/video/console/fbcon.c       |    2 
 drivers/video/console/fonts.c       |    4 
 include/asm-m68k/pgtable.h          |    2 
 include/asm-powerpc/ide.h           |    2 
 include/asm-powerpc/reg.h           |    4 
 include/asm-ppc/amigahw.h           |   16 
 include/asm-ppc/amigaints.h         |  133 ---
 include/asm-ppc/amigappc.h          |   85 --
 include/asm-ppc/bootinfo.h          |    5 
 include/asm-ppc/io.h                |   48 -
 include/asm-ppc/machdep.h           |    4 
 include/asm-ppc/page.h              |   44 -
 include/asm-ppc/pgtable.h           |    8 
 sound/oss/dmasound/Kconfig          |    2 
 sound/oss/dmasound/dmasound_paula.c |    4 
 46 files changed, 24 insertions(+), 4468 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/ppc/Kconfig.old	2007-06-30 00:50:49.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/Kconfig	2007-06-30 01:37:18.000000000 +0200
@@ -573,24 +573,9 @@ choice
 
 	  Select PReP if configuring for a PReP machine.
 
-	  Select Gemini if configuring for a Synergy Microsystems' Gemini
-	  series Single Board Computer.  More information is available at:
-	  <http://www.synergymicro.com/PressRel/97_10_15.html>.
-
-	  Select APUS if configuring for a PowerUP Amiga.  More information is
-	  available at: <http://linux-apus.sourceforge.net/>.
-
 config PPC_PREP
 	bool "PReP"
 
-config APUS
-	bool "Amiga-APUS"
-	depends on BROKEN
-	help
-	  Select APUS if configuring for a PowerUP Amiga.
-	  More information is available at:
-	  <http://linux-apus.sourceforge.net/>.
-
 config KATANA
 	bool "Artesyn-Katana"
 	help
@@ -1027,132 +1012,6 @@ config CMDLINE
 	  some command-line options at build time by entering them here.  In
 	  most cases you will need to specify the root device here.
 
-config AMIGA
-	bool
-	depends on APUS
-	default y
-	help
-	  This option enables support for the Amiga series of computers.
-
-config ZORRO
-	bool
-	depends on APUS
-	default y
-	help
-	  This enables support for the Zorro bus in the Amiga. If you have
-	  expansion cards in your Amiga that conform to the Amiga
-	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
-	  expansion cards that do not fit in the Zorro slots but fit in e.g.
-	  the CPU slot may fall in this category, so you have to say Y to let
-	  Linux use these.
-
-config ABSTRACT_CONSOLE
-	bool
-	depends on APUS
-	default y
-
-config APUS_FAST_EXCEPT
-	bool
-	depends on APUS
-	default y
-
-config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support"
-	depends on APUS && EXPERIMENTAL
-	help
-	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
-	  600. If you intend to use pcmcia cards say Y; otherwise say N.
-
-config AMIGA_BUILTIN_SERIAL
-	tristate "Amiga builtin serial support"
-	depends on APUS
-	help
-	  If you want to use your Amiga's built-in serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on APUS
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on APUS
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config A2232
-	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && APUS
-	---help---
-	  This option supports the 2232 7-port serial card shipped with the
-	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
-	  a max of 19,200 bps, the ports are served by a 6551 ACIA UART chip
-	  each, plus a 8520 CIA, and a master 6502 CPU and buffer as well. The
-	  ports were connected with 8 pin DIN connectors on the card bracket,
-	  for which 8 pin to DB25 adapters were supplied. The card also had
-	  jumpers internally to toggle various pinning configurations.
-
-	  This driver can be built as a module; but then "generic_serial"
-	  will also be built as a module. This has to be loaded before
-	  "ser_a2232". If you want to do this, answer M here.
-
-config WHIPPET_SERIAL
-	tristate "Hisoft Whippet PCMCIA serial support"
-	depends on AMIGA_PCMCIA
-	help
-	  HiSoft has a web page at <http://www.hisoft.co.uk/>, but there
-	  is no listing for the Whippet in their Amiga section.
-
-config APNE
-	tristate "PCMCIA NE2000 support"
-	depends on AMIGA_PCMCIA
-	help
-	  If you have a PCMCIA NE2000 compatible adapter, say Y.  Otherwise,
-	  say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called apne.
-
-config SERIAL_CONSOLE
-	bool "Support for serial port console"
-	depends on APUS && (AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y)
-
-config HEARTBEAT
-	bool "Use power LED as a heartbeat"
-	depends on APUS
-	help
-	  Use the power-on LED on your machine as a load meter.  The exact
-	  behavior is platform-dependent, but normally the flash frequency is
-	  a hyperbolic function of the 5-minute load average.
-
-config PROC_HARDWARE
-	bool "/proc/hardware support"
-	depends on APUS
-
-source "drivers/zorro/Kconfig"
-
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
@@ -1227,8 +1086,7 @@ config MCA
 
 config PCI
 	bool "PCI support" if 40x || CPM2 || 83xx || 85xx || PPC_MPC52xx
-	default y if !40x && !CPM2 && !8xx && !APUS && !83xx && !85xx
-	default PCI_PERMEDIA if !4xx && !CPM2 && !8xx && APUS
+	default y if !40x && !CPM2 && !8xx && !83xx && !85xx
 	default PCI_QSPAN if !4xx && !CPM2 && 8xx
 	help
 	  Find out whether your system includes a PCI bus. PCI is the name of
@@ -1282,10 +1140,6 @@ config 8260_PCI9_IDMA4
 
 endchoice
 
-config PCI_PERMEDIA
-	bool "PCI for Permedia2"
-	depends on !4xx && !8xx && APUS
-
 source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
--- linux-2.6.22-rc6-mm1/sound/oss/dmasound/Kconfig.old	2007-06-30 00:59:18.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/oss/dmasound/Kconfig	2007-06-30 00:59:31.000000000 +0200
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA && SOUND
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answer
--- linux-2.6.22-rc6-mm1/arch/m68k/amiga/chipram.c.old	2007-06-30 01:01:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/m68k/amiga/chipram.c	2007-06-30 01:01:08.000000000 +0200
@@ -29,12 +29,10 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
 
-#ifndef CONFIG_APUS_FAST_EXCEPT
     /*
      *  Remove the first 4 pages where PPC exception handlers will be located
      */
     amiga_chip_size -= 0x4000;
-#endif
     chipram_res.end = amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
 
--- linux-2.6.22-rc6-mm1/arch/ppc/Makefile.old	2007-06-30 01:01:52.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/Makefile	2007-06-30 01:01:57.000000000 +0200
@@ -69,7 +69,6 @@ core-$(CONFIG_83xx)		+= arch/ppc/platfor
 core-$(CONFIG_85xx)		+= arch/ppc/platforms/85xx/
 core-$(CONFIG_MATH_EMULATION)	+= arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+= arch/ppc/xmon/
-core-$(CONFIG_APUS)		+= arch/ppc/amiga/
 drivers-$(CONFIG_8xx)		+= arch/ppc/8xx_io/
 drivers-$(CONFIG_4xx)		+= arch/ppc/4xx_io/
 drivers-$(CONFIG_CPM2)		+= arch/ppc/8260_io/
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/head.S.old	2007-06-30 01:03:15.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/head.S	2007-06-30 01:04:54.000000000 +0200
@@ -32,10 +32,6 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
 /* 601 only have IBAT; cr0.eq is set on 601 when using this macro */
 #define LOAD_BAT(n, reg, RA, RB)	\
 	/* see the comment for clear_bats() -- Cort */ \
@@ -128,14 +124,6 @@ __start:
  */
 	bl	early_init
 
-#ifdef CONFIG_APUS
-/* On APUS the __va/__pa constants need to be set to the correct
- * values before continuing.
- */
-	mr	r4,r30
-	bl	fix_mem_constants
-#endif /* CONFIG_APUS */
-
 /* Switch MMU off, clear BATs and flush TLB. At this point, r3 contains
  * the physical address we are running at, returned by early_init()
  */
@@ -145,7 +133,7 @@ __after_mmu_off:
 	bl	flush_tlbs
 
 	bl	initial_bats
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 	bl	setup_disp_bat
 #endif
 
@@ -161,7 +149,6 @@ __after_mmu_off:
 #endif /* CONFIG_6xx */
 
 
-#ifndef CONFIG_APUS
 /*
  * We need to run with _start at physical address 0.
  * If the MMU is already turned on, we copy stuff to KERNELBASE,
@@ -172,7 +159,7 @@ __after_mmu_off:
 	addis	r4,r3,KERNELBASE@h	/* current address of _start */
 	cmpwi	0,r4,0			/* are we already running at 0? */
 	bne	relocate_kernel
-#endif /* CONFIG_APUS */
+
 /*
  * we now have the 1st 16M of ram mapped with the bats.
  * prep needs the mmu to be turned on here, but pmac already has it on.
@@ -812,85 +799,6 @@ copy_and_flush:
 	addi	r6,r6,4
 	blr
 
-#ifdef CONFIG_APUS
-/*
- * On APUS the physical base address of the kernel is not known at compile
- * time, which means the __pa/__va constants used are incorrect. In the
- * __init section is recorded the virtual addresses of instructions using
- * these constants, so all that has to be done is fix these before
- * continuing the kernel boot.
- *
- * r4 = The physical address of the kernel base.
- */
-fix_mem_constants:
-	mr	r10,r4
-	addis	r10,r10,-KERNELBASE@h    /* virt_to_phys constant */
-	neg	r11,r10	                 /* phys_to_virt constant */
-
-	lis	r12,__vtop_table_begin@h
-	ori	r12,r12,__vtop_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__vtop_table_end@h
-	ori	r13,r13,__vtop_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r10,16,16,31         /* half of vp const in low half */
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-	sync				/* additional sync needed on g4 */
-	isync
-
-/*
- * Map the memory where the exception handlers will
- * be copied to when hash constants have been patched.
- */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r8,0xfff0
-#else
-	lis	r8,0
-#endif
-	ori	r8,r8,0x2		/* 128KB, supervisor */
-	mtspr	SPRN_DBAT3U,r8
-	mtspr	SPRN_DBAT3L,r8
-
-	lis	r12,__ptov_table_begin@h
-	ori	r12,r12,__ptov_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__ptov_table_end@h
-	ori	r13,r13,__ptov_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r11,16,16,31         /* half of pv const in low half*/
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-
-	sync				/* additional sync needed on g4 */
-	isync				/* No speculative loading until now */
-	blr
-
-/***********************************************************************
- *  Please note that on APUS the exception handlers are located at the
- *  physical address 0xfff0000. For this reason, the exception handlers
- *  cannot use relative branches to access the code below.
- ***********************************************************************/
-#endif /* CONFIG_APUS */
-
 #ifdef CONFIG_SMP
 	.globl	__secondary_start_pmac_0
 __secondary_start_pmac_0:
@@ -1043,19 +951,6 @@ start_here:
 	bl	machine_init
 	bl	MMU_init
 
-#ifdef CONFIG_APUS
-	/* Copy exception code to exception vector base on APUS. */
-	lis	r4,KERNELBASE@h
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r3,0xfff0		/* Copy to 0xfff00000 */
-#else
-	lis	r3,0			/* Copy to 0x00000000 */
-#endif
-	li	r5,0x4000		/* # bytes of memory to copy */
-	li	r6,0
-	bl	copy_and_flush		/* copy the first 0x4000 bytes */
-#endif  /* CONFIG_APUS */
-
 /*
  * Go back to running unmapped so we can load up new values
  * for SDR1 (hash table pointer) and the segment registers
@@ -1232,11 +1127,7 @@ initial_bats:
 #else
 	ori	r8,r8,2			/* R/W access */
 #endif /* CONFIG_SMP */
-#ifdef CONFIG_APUS
-	ori	r11,r11,BL_8M<<2|0x2	/* set up 8MB BAT registers for 604 */
-#else
 	ori	r11,r11,BL_256M<<2|0x2	/* set up BAT registers for 604 */
-#endif /* CONFIG_APUS */
 
 	mtspr	SPRN_DBAT0L,r8		/* N.B. 6xx (not 601) have valid */
 	mtspr	SPRN_DBAT0U,r11		/* bit in upper BAT register */
@@ -1245,7 +1136,7 @@ initial_bats:
 	isync
 	blr
 
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 setup_disp_bat:
 	/*
 	 * setup the display bat prepared for us in prom.c
@@ -1268,7 +1159,7 @@ setup_disp_bat:
 	mtspr	SPRN_IBAT3U,r11
 	blr
 
-#endif /* !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT) */
+#endif /* defined(CONFIG_BOOTX_TEXT) */
 
 #ifdef CONFIG_8260
 /* Jump into the system reset for the rom.
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/Makefile.old	2007-06-30 01:05:05.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/platforms/Makefile	2007-06-30 01:05:19.000000000 +0200
@@ -2,10 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-obj-$(CONFIG_APUS)		+= apus_setup.o
-ifeq ($(CONFIG_APUS),y)
-obj-$(CONFIG_PCI)		+= apus_pci.o
-endif
 obj-$(CONFIG_PPC_PREP)		+= prep_pci.o prep_setup.o
 obj-$(CONFIG_PREP_RESIDUAL)	+= residual.o
 obj-$(CONFIG_PQ2ADS)		+= pq2ads.o
--- linux-2.6.22-rc6-mm1/drivers/ide/ide-probe.c.old	2007-06-30 01:06:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/ide/ide-probe.c	2007-06-30 01:07:23.000000000 +0200
@@ -1096,9 +1096,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq != hwif->irq) {
 		int sa = IRQF_DISABLED;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa = IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
 
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset)) {
 			sa = IRQF_SHARED;
@@ -1141,7 +1141,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_unlock_irq(&ide_lock);
 	}
 
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1149,7 +1149,7 @@ static int init_irq (ide_hwif_t *hwif)
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
-#endif /* __mc68000__ && CONFIG_APUS */
+#endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
--- linux-2.6.22-rc6-mm1/drivers/isdn/hisax/avm_pci.c.old	2007-06-30 01:07:31.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/isdn/hisax/avm_pci.c	2007-06-30 01:07:48.000000000 +0200
@@ -264,11 +264,7 @@ hdlc_empty_fifo(struct BCState *bcs, int
 		outl(idx, cs->hw.avm.cfg_reg + 4);
 		while (cnt < count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			*ptr++ = in_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#else
 			*ptr++ = in_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#endif /* CONFIG_APUS */
 #else
 			*ptr++ = inl(cs->hw.avm.isac);
 #endif /* __powerpc__ */
@@ -329,11 +325,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 	if (cs->subtyp == AVM_FRITZ_PCI) {
 		while (cnt<count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			out_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#else
 			out_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#endif /* CONFIG_APUS */
 #else
 			outl(*ptr++, cs->hw.avm.isac);
 #endif /* __powerpc__ */
--- linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_esp.c.old	2007-06-30 01:07:59.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_esp.c	2007-06-30 01:08:10.000000000 +0200
@@ -7,7 +7,7 @@
  */
 
 
-#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
+#if defined(CONFIG_AMIGA)
 #define USE_BOTTOM_HALF
 #endif
 
--- linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_io.S.old	2007-06-30 01:08:38.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_io.S	2007-06-30 01:09:05.000000000 +0200
@@ -24,77 +24,6 @@ int oktag_from_io(long *addr,long *paddr
  */
 
 
-#ifdef CONFIG_APUS
-
-	.file	"oktagon_io.c"
-
-gcc2_compiled.:
-/*
-	.section ".text"
-*/
-	.align 2
-	.globl oktag_to_io
-	.type	 oktag_to_io,@function
-oktag_to_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	mr 3,4
-	addi 5,5,-1
-	bc 12,6,.L3
-.L5:
-	cmpwi 1,5,0
-	lwz 0,0(3)
-	addi 3,3,4
-	addi 5,5,-1
-exp1:	stw 0,0(9)
-	bc 4,6,.L5
-.L3:
-ret1:	subf 3,4,3
-	srawi 3,3,2
-	blr
-.Lfe1:
-	.size	 oktag_to_io,.Lfe1-oktag_to_io
-	.align 2
-	.globl oktag_from_io
-	.type	 oktag_from_io,@function
-oktag_from_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	addi 5,5,-1
-	bc 12,6,.L9
-.L11:
-	cmpwi 1,5,0
-exp2:	lwz 0,0(4)
-	addi 5,5,-1
-	stw 0,0(3)
-	addi 3,3,4
-	bc 4,6,.L11
-.L9:
-ret2:	subf 3,9,3
-	srawi 3,3,2
-	blr
-.Lfe2:
-	.size	 oktag_from_io,.Lfe2-oktag_from_io
-	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
-
-/*
- * Exception table.
- * Second longword shows where to jump when an exception at the addr the first
- * longword is pointing to is caught.
- */
-
-.section __ex_table,"a"
-	.align	2
-oktagon_except:
-	.long	exp1,ret1
-	.long	exp2,ret2
-
-#else
-
 /*
 The code which follows is for 680x0 based assembler and is meant for
 Linux/m68k. It was created by cross compiling the code using the
@@ -191,4 +120,3 @@ oktagon_except:
 	.long	exp2,ret2
 
 #endif
-#endif
--- linux-2.6.22-rc6-mm1/drivers/video/console/fbcon.c.old	2007-06-30 01:09:16.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/console/fbcon.c	2007-06-30 01:09:23.000000000 +0200
@@ -85,7 +85,7 @@
 #ifdef CONFIG_MAC
 #include <asm/macints.h>
 #endif
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
 #endif
--- linux-2.6.22-rc6-mm1/drivers/video/console/fonts.c.old	2007-06-30 01:09:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/console/fonts.c	2007-06-30 01:09:44.000000000 +0200
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/setup.h>
 #endif
 #include <linux/font.h>
@@ -120,7 +120,7 @@ const struct font_desc *get_default_font
     for(i=0; i<num_fonts; i++) {
 	f = fonts[i];
 	c = f->pref;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #ifdef CONFIG_FONT_PEARL_8x8
 	if (MACH_IS_AMIGA && f->idx == PEARL8x8_IDX)
 	    c = 100;
--- linux-2.6.22-rc6-mm1/include/asm-powerpc/ide.h.old	2007-06-30 01:10:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-powerpc/ide.h	2007-06-30 01:10:14.000000000 +0200
@@ -67,7 +67,7 @@ static __inline__ unsigned long ide_defa
 #define ide_init_default_irq(base)	ide_default_irq(base)
 #endif
 
-#if (defined CONFIG_APUS || defined CONFIG_BLK_DEV_MPC8xx_IDE )
+#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
 #define IDE_ARCH_ACK_INTR  1
 #define ide_ack_intr(hwif) (hwif->hw.ack_intr ? hwif->hw.ack_intr(hwif) : 1)
 #endif
--- linux-2.6.22-rc6-mm1/include/asm-powerpc/reg.h.old	2007-06-30 01:10:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-powerpc/reg.h	2007-06-30 01:10:31.000000000 +0200
@@ -102,12 +102,8 @@
 #else /* 32-bit */
 /* Default MSR for kernel mode. */
 #ifndef MSR_KERNEL	/* reg_booke.h also defines this */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define MSR_KERNEL	(MSR_ME|MSR_IP|MSR_RI|MSR_IR|MSR_DR)
-#else
 #define MSR_KERNEL	(MSR_ME|MSR_RI|MSR_IR|MSR_DR)
 #endif
-#endif
 
 #define MSR_USER	(MSR_KERNEL|MSR_PR|MSR_EE)
 #endif
--- linux-2.6.22-rc6-mm1/include/asm-ppc/bootinfo.h.old	2007-06-30 01:12:56.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/bootinfo.h	2007-06-30 01:13:07.000000000 +0200
@@ -11,10 +11,6 @@
 
 #include <asm/page.h>
 
-#if defined(CONFIG_APUS) && !defined(__BOOTER__)
-#include <asm-m68k/bootinfo.h>
-#else
-
 struct bi_record {
 	unsigned long tag;		/* tag ID */
 	unsigned long size;		/* size of record (in bytes) */
@@ -44,7 +40,6 @@ bootinfo_addr(unsigned long offset)
 	return (struct bi_record *)_ALIGN((offset) + (1 << 20) - 1,
 					  (1 << 20));
 }
-#endif /* CONFIG_APUS */
 
 
 #endif /* _PPC_BOOTINFO_H */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/io.h.old	2007-06-30 01:13:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/io.h	2007-06-30 02:00:34.000000000 +0200
@@ -30,7 +30,7 @@
 #include <asm/mpc8xx.h>
 #elif defined(CONFIG_8260)
 #include <asm/mpc8260.h>
-#elif defined(CONFIG_APUS) || !defined(CONFIG_PCI)
+#elif !defined(CONFIG_PCI)
 #define _IO_BASE	0
 #define _ISA_MEM_BASE	0
 #define PCI_DRAM_OFFSET 0
@@ -145,24 +145,7 @@ static inline void writeb(__u8 b, volati
 }
 #endif
 
-#if defined(CONFIG_APUS)
-static inline __u16 readw(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u16 *)(addr);
-}
-static inline __u32 readl(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u32 *)(addr);
-}
-static inline void writew(__u16 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u16 *)(addr) = b;
-}
-static inline void writel(__u32 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u32 *)(addr) = b;
-}
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* Use macros if PCI9 workaround enabled */
 #define readw(addr) in_le16((volatile u16 *)(addr))
 #define readl(addr) in_le32((volatile u32 *)(addr))
@@ -185,7 +168,7 @@ static inline void writel(__u32 b, volat
 {
 	out_le32(addr, b);
 }
-#endif /* CONFIG_APUS */
+#endif /* CONFIG_8260_PCI9 */
 
 #define readb_relaxed(addr) readb(addr)
 #define readw_relaxed(addr) readw(addr)
@@ -300,13 +283,7 @@ extern __inline__ void name(unsigned int
 }
 
 __do_out_asm(outb, "stbx")
-#ifdef CONFIG_APUS
-__do_in_asm(inb, "lbzx")
-__do_in_asm(inw, "lhz%U1%X1")
-__do_in_asm(inl, "lwz%U1%X1")
-__do_out_asm(outl,"stw%U0%X0")
-__do_out_asm(outw, "sth%U0%X0")
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* in asm cannot be defined if PCI9 workaround is used */
 #define inb(port)		in_8((port)+___IO_BASE)
 #define inw(port)		in_le16((port)+___IO_BASE)
@@ -371,7 +348,6 @@ extern void __iomem *ioremap64(unsigned 
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
 extern void iounmap(volatile void __iomem *addr);
 extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
 extern void io_block_mapping(unsigned long virt, phys_addr_t phys,
 			     unsigned int size, int flags);
 
@@ -384,24 +360,16 @@ extern void io_block_mapping(unsigned lo
  */
 extern inline unsigned long virt_to_bus(volatile void * address)
 {
-#ifndef CONFIG_APUS
         if (address == (void *)0)
 		return 0;
         return (unsigned long)address - KERNELBASE + PCI_DRAM_OFFSET;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
 
 extern inline void * bus_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
         if (address == 0)
 		return NULL;
         return (void *)(address - PCI_DRAM_OFFSET + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
 
 /*
@@ -410,20 +378,12 @@ extern inline void * bus_to_virt(unsigne
  */
 extern inline unsigned long virt_to_phys(volatile void * address)
 {
-#ifndef CONFIG_APUS
 	return (unsigned long) address - KERNELBASE;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
 
 extern inline void * phys_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
 	return (void *) (address + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
 
 /*
--- linux-2.6.22-rc6-mm1/include/asm-ppc/machdep.h.old	2007-06-30 01:14:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/machdep.h	2007-06-30 01:14:31.000000000 +0200
@@ -8,10 +8,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 
-#ifdef CONFIG_APUS
-#include <asm-m68k/machdep.h>
-#endif
-
 struct pt_regs;
 struct pci_bus;	
 struct pci_dev;
--- linux-2.6.22-rc6-mm1/include/asm-ppc/page.h.old	2007-06-30 01:14:41.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/page.h	2007-06-30 01:20:35.000000000 +0200
@@ -97,62 +97,22 @@ extern void clear_user_page(void *page, 
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 			   struct page *pg);
 
-#ifndef CONFIG_APUS
 #define PPC_MEMSTART	0
-#define PPC_PGSTART	0
 #define PPC_MEMOFFSET	PAGE_OFFSET
-#else
-extern unsigned long ppc_memstart;
-extern unsigned long ppc_pgstart;
-extern unsigned long ppc_memoffset;
-#define PPC_MEMSTART	ppc_memstart
-#define PPC_PGSTART	ppc_pgstart
-#define PPC_MEMOFFSET	ppc_memoffset
-#endif
-
-#if defined(CONFIG_APUS) && !defined(MODULE)
-/* map phys->virtual and virtual->phys for RAM pages */
-static inline unsigned long ___pa(unsigned long v)
-{
-	unsigned long p;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".vtop_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=r" (p)
-		      : "b" (v), "K" (((-PAGE_OFFSET) >> 16) & 0xffff));
 
-	return p;
-}
-static inline void* ___va(unsigned long p)
-{
-	unsigned long v;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".ptov_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=r" (v)
-		      : "b" (p), "K" (((PAGE_OFFSET) >> 16) & 0xffff));
-
-	return (void*) v;
-}
-#else
 #define ___pa(vaddr) ((vaddr)-PPC_MEMOFFSET)
 #define ___va(paddr) ((paddr)+PPC_MEMOFFSET)
-#endif
 
 extern int page_is_ram(unsigned long pfn);
 
 #define __pa(x) ___pa((unsigned long)(x))
 #define __va(x) ((void *)(___va((unsigned long)(x))))
 
-#define ARCH_PFN_OFFSET		(PPC_PGSTART)
+#define ARCH_PFN_OFFSET		0
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_virt(page)	__va(page_to_pfn(page) << PAGE_SHIFT)
 
-#define pfn_valid(pfn)		(((pfn) - PPC_PGSTART) < max_mapnr)
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 /* Pure 2^n version of get_order */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/pgtable.h.old	2007-06-30 01:22:25.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/pgtable.h	2007-06-30 01:58:12.000000000 +0200
@@ -772,14 +772,6 @@ extern void paging_init(void);
 #define pte_to_pgoff(pte)	(pte_val(pte) >> 3)
 #define pgoff_to_pte(off)	((pte_t) { ((off) << 3) | _PAGE_FILE })
 
-/* CONFIG_APUS */
-/* For virtual address to physical address conversion */
-extern void cache_clear(__u32 addr, int length);
-extern void cache_push(__u32 addr, int length);
-extern int mm_end_of_chunk (unsigned long addr, int len);
-extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
-
 /* Values for nocacheflag and cmode */
 /* These are not used by the APUS kernel_map, but prevents
    compilation errors. */
--- linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h.old	2007-06-30 01:23:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h	2007-06-30 01:23:43.000000000 +0200
@@ -107,8 +107,6 @@ extern void *empty_zero_page;
 /* 64-bit machines, beware!  SRB. */
 #define SIZEOF_PTR_LOG2			       2
 
-#define mm_end_of_chunk(addr, len)	0
-
 extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
 
 /*
--- linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c.old	2007-06-30 01:23:53.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c	2007-06-30 01:24:08.000000000 +0200
@@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *c
     struct Scsi_Host *instance = cmd->device->host;
 
     /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A2091_XFER_MASK)
     {
 	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c.old	2007-06-30 01:24:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c	2007-06-30 01:24:26.000000000 +0200
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
      * end of a physical memory chunk, then allocate a bounce
      * buffer
      */
-    if (addr & A3000_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A3000_XFER_MASK)
     {
 	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c.old	2007-06-30 01:24:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c	2007-06-30 01:24:46.000000000 +0200
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
     static int scsi_alloc_out_of_range = 0;
 
     /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
     {
 	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/sound/oss/dmasound/dmasound_paula.c.old	2007-06-30 01:26:29.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/oss/dmasound/dmasound_paula.c	2007-06-30 01:26:54.000000000 +0200
@@ -91,10 +91,6 @@ static irqreturn_t AmiInterrupt(int irq,
      *  power LED are controlled by the same line.
      */
 
-#ifdef CONFIG_APUS
-#define mach_heartbeat	ppc_md.heartbeat
-#endif
-
 static void (*saved_heartbeat)(int) = NULL;
 
 static inline void disable_heartbeat(void)
--- linux-2.6.22-rc6-mm1/arch/powerpc/kernel/setup_32.c.old	2007-06-30 01:49:26.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/powerpc/kernel/setup_32.c	2007-06-30 01:49:35.000000000 +0200
@@ -24,7 +24,6 @@
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/setup.c.old	2007-06-30 01:49:46.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/setup.c	2007-06-30 01:49:50.000000000 +0200
@@ -25,7 +25,6 @@
 #include <asm/pgtable.h>
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/ppc_ksyms.c.old	2007-06-30 01:55:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/ppc_ksyms.c	2007-06-30 01:55:10.000000000 +0200
@@ -60,6 +60,4 @@
 long long __lshrdi3(long long, int);
 
-extern unsigned long mm_ptov (unsigned long paddr);
-
 EXPORT_SYMBOL(clear_pages);
 EXPORT_SYMBOL(clear_user_page);
@@ -119,7 +117,6 @@ EXPORT_SYMBOL(_outsw_ns);
 EXPORT_SYMBOL(_insl_ns);
 EXPORT_SYMBOL(_outsl_ns);
 EXPORT_SYMBOL(iopa);
-EXPORT_SYMBOL(mm_ptov);
 EXPORT_SYMBOL(ioremap);
 #ifdef CONFIG_44x
 EXPORT_SYMBOL(ioremap64);
--- linux-2.6.22-rc6-mm1/arch/ppc/mm/pgtable.c.old	2007-06-30 01:55:21.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/mm/pgtable.c	2007-06-30 01:55:31.000000000 +0200
@@ -426,41 +426,3 @@ unsigned long iopa(unsigned long addr)
 	return(pa);
 }
 
-/* This is will find the virtual address for a physical one....
- * Swiped from APUS, could be dangerous :-).
- * This is only a placeholder until I really find a way to make this
- * work.  -- Dan
- */
-unsigned long
-mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-#if 0
-	if (paddr < 16*1024*1024)
-		ret = ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i = 0; i < kmap_chunk_count;){
-			unsigned long phys = kmap_chunks[i++];
-			unsigned long size = kmap_chunks[i++];
-			unsigned long virt = kmap_chunks[i++];
-			if (paddr >= phys
-			    && paddr < (phys + size)){
-				ret = virt + paddr - phys;
-				goto exit;
-			}
-		}
-	
-		ret = (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=%lx\n", paddr, ret);
-#endif
-#else
-	ret = (unsigned long)paddr + KERNELBASE;
-#endif
-	return ret;
-}
-
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amiga_ksyms.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amiga_ksyms.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/chipram.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/chipram.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/Makefile	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,8 +0,0 @@
-#
-# Makefile for Linux arch/m68k/amiga source directory
-#
-
-obj-y		:= config.o amiints.o cia.o time.o bootinfo.o amisound.o \
-			chipram.o amiga_ksyms.o
-
-obj-$(CONFIG_AMIGA_PCMCIA) += pcmcia.o
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amiints.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,322 +0,0 @@
-/*
- * Amiga Linux interrupt handling code
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- *
- * 11/07/96: rewritten interrupt handling, irq lists are exists now only for
- *           this sources where it makes sense (VERTB/PORTS/EXTER) and you must
- *           be careful that dev_id for this sources is unique since this the
- *           only possibility to distinguish between different handlers for
- *           free_irq. irq lists also have different irq flags:
- *           - IRQ_FLG_FAST: handler is inserted at top of list (after other
- *                           fast handlers)
- *           - IRQ_FLG_SLOW: handler is inserted at bottom of list and before
- *                           they're executed irq level is set to the previous
- *                           one, but handlers don't need to be reentrant, if
- *                           reentrance occurred, slow handlers will be just
- *                           called again.
- *           The whole interrupt handling for CIAs is moved to cia.c
- *           /Roman Zippel
- *
- * 07/08/99: rewamp of the interrupt handling - we now have two types of
- *           interrupts, normal and fast handlers, fast handlers being
- *           marked with SA_INTERRUPT and runs with all other interrupts
- *           disabled. Normal interrupts disable their own source but
- *           run with all other interrupt sources enabled.
- *           PORTS and EXTER interrupts are always shared even if the
- *           drivers do not explicitly mark this when calling
- *           request_irq which they really should do.
- *           This is similar to the way interrupts are handled on all
- *           other architectures and makes a ton of sense besides
- *           having the advantage of making it easier to share
- *           drivers.
- *           /Jes
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amipcmcia.h>
-
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
-extern void cia_init_IRQ(struct ciabase *base);
-
-unsigned short ami_intena_vals[AMI_STD_IRQS] = {
-	IF_VERTB, IF_COPER, IF_AUD0, IF_AUD1, IF_AUD2, IF_AUD3, IF_BLIT,
-	IF_DSKSYN, IF_DSKBLK, IF_RBF, IF_TBE, IF_SOFT, IF_PORTS, IF_EXTER
-};
-static const unsigned char ami_servers[AMI_STD_IRQS] = {
-	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
-};
-
-static short ami_ablecount[AMI_IRQS];
-
-static void ami_badint(int irq, void *dev_id, struct pt_regs *fp)
-{
-/*	num_spurious += 1;*/
-}
-
-/*
- * void amiga_init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the amiga IRQ handling routines.
- */
-
-__init
-void amiga_init_IRQ(void)
-{
-	int i;
-
-	for (i = 0; i < AMI_IRQS; i++)
-		ami_ablecount[i] = 0;
-
-	/* turn off PCMCIA interrupts */
-	if (AMIGAHW_PRESENT(PCMCIA))
-		gayle.inten = GAYLE_IRQ_IDE;
-
-	/* turn off all interrupts... */
-	amiga_custom.intena = 0x7fff;
-	amiga_custom.intreq = 0x7fff;
-
-#ifdef CONFIG_APUS
-	/* Clear any inter-CPU interrupt requests. Circumvents bug in
-           Blizzard IPL emulation HW (or so it appears). */
-	APUS_WRITE(APUS_INT_LVL, INTLVL_SETRESET | INTLVL_MASK);
-
-	/* Init IPL emulation. */
-	APUS_WRITE(APUS_REG_INT, REGINT_INTMASTER | REGINT_ENABLEIPL);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET | IPLEMU_IPLMASK);
-#endif
-	/* ... and enable the master interrupt bit */
-	amiga_custom.intena = IF_SETCLR | IF_INTEN;
-
-	cia_init_IRQ(&ciaa_base);
-	cia_init_IRQ(&ciab_base);
-}
-
-/*
- * Enable/disable a particular machine specific interrupt source.
- * Note that this may affect other interrupts in case of a shared interrupt.
- * This function should only be called for a _very_ short time to change some
- * internal data, that may not be changed by the interrupt at the same time.
- * ami_(enable|disable)_irq calls may also be nested.
- */
-
-void amiga_enable_irq(unsigned int irq)
-{
-	if (irq >= AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	ami_ablecount[irq]--;
-	if (ami_ablecount[irq]<0)
-		ami_ablecount[irq]=0;
-	else if (ami_ablecount[irq])
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >= IRQ_AMIGA_AUTO){
-		printk("%s: Trying to enable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >= IRQ_AMIGA_CIAA) {
-		cia_set_irq(irq, 0);
-		cia_able_irq(irq, 1);
-		return;
-	}
-
-	/* enable the interrupt */
-	amiga_custom.intena = IF_SETCLR | ami_intena_vals[irq];
-}
-
-void amiga_disable_irq(unsigned int irq)
-{
-	if (irq >= AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (ami_ablecount[irq]++)
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >= IRQ_AMIGA_AUTO) {
-		printk("%s: Trying to disable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >= IRQ_AMIGA_CIAA) {
-		cia_able_irq(irq, 0);
-		return;
-	}
-
-	/* disable the interrupt */
-	amiga_custom.intena = ami_intena_vals[irq];
-}
-
-inline void amiga_do_irq(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc = irq_desc + irq;
-	struct irqaction *action = desc->action;
-
-	kstat_cpu(0).irqs[irq]++;
-	action->handler(irq, action->dev_id, fp);
-}
-
-void amiga_do_irq_list(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc = irq_desc + irq;
-	struct irqaction *action;
-
-	kstat_cpu(0).irqs[irq]++;
-
-	amiga_custom.intreq = ami_intena_vals[irq];
-
-	for (action = desc->action; action; action = action->next)
-		action->handler(irq, action->dev_id, fp);
-}
-
-/*
- * The builtin Amiga hardware interrupt handlers.
- */
-
-static void ami_int1(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial transmit buffer empty, interrupt */
-	if (ints & IF_TBE) {
-		amiga_custom.intreq = IF_TBE;
-		amiga_do_irq(IRQ_AMIGA_TBE, fp);
-	}
-
-	/* if floppy disk transfer complete, interrupt */
-	if (ints & IF_DSKBLK) {
-		amiga_custom.intreq = IF_DSKBLK;
-		amiga_do_irq(IRQ_AMIGA_DSKBLK, fp);
-	}
-
-	/* if software interrupt set, interrupt */
-	if (ints & IF_SOFT) {
-		amiga_custom.intreq = IF_SOFT;
-		amiga_do_irq(IRQ_AMIGA_SOFT, fp);
-	}
-}
-
-static void ami_int3(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if a blitter interrupt */
-	if (ints & IF_BLIT) {
-		amiga_custom.intreq = IF_BLIT;
-		amiga_do_irq(IRQ_AMIGA_BLIT, fp);
-	}
-
-	/* if a copper interrupt */
-	if (ints & IF_COPER) {
-		amiga_custom.intreq = IF_COPER;
-		amiga_do_irq(IRQ_AMIGA_COPPER, fp);
-	}
-
-	/* if a vertical blank interrupt */
-	if (ints & IF_VERTB)
-		amiga_do_irq_list(IRQ_AMIGA_VERTB, fp);
-}
-
-static void ami_int4(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if audio 0 interrupt */
-	if (ints & IF_AUD0) {
-		amiga_custom.intreq = IF_AUD0;
-		amiga_do_irq(IRQ_AMIGA_AUD0, fp);
-	}
-
-	/* if audio 1 interrupt */
-	if (ints & IF_AUD1) {
-		amiga_custom.intreq = IF_AUD1;
-		amiga_do_irq(IRQ_AMIGA_AUD1, fp);
-	}
-
-	/* if audio 2 interrupt */
-	if (ints & IF_AUD2) {
-		amiga_custom.intreq = IF_AUD2;
-		amiga_do_irq(IRQ_AMIGA_AUD2, fp);
-	}
-
-	/* if audio 3 interrupt */
-	if (ints & IF_AUD3) {
-		amiga_custom.intreq = IF_AUD3;
-		amiga_do_irq(IRQ_AMIGA_AUD3, fp);
-	}
-}
-
-static void ami_int5(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial receive buffer full interrupt */
-	if (ints & IF_RBF) {
-		/* acknowledge of IF_RBF must be done by the serial interrupt */
-		amiga_do_irq(IRQ_AMIGA_RBF, fp);
-	}
-
-	/* if a disk sync interrupt */
-	if (ints & IF_DSKSYN) {
-		amiga_custom.intreq = IF_DSKSYN;
-		amiga_do_irq(IRQ_AMIGA_DSKSYN, fp);
-	}
-}
-
-static void ami_int7(int irq, void *dev_id, struct pt_regs *fp)
-{
-	panic ("level 7 interrupt received\n");
-}
-
-#ifdef CONFIG_APUS
-/* The PPC irq handling links all handlers requested on the same vector
-   and executes them in a loop. Having ami_badint at the end of the chain
-   is a bad idea. */
-struct irqaction amiga_sys_irqaction[AUTO_IRQS] = {
-	{ .handler = ami_badint, .name = "spurious int" },
-	{ .handler = ami_int1, .name = "int1 handler" },
-	{ 0, /* CIAA */ },
-	{ .handler = ami_int3, .name = "int3 handler" },
-	{ .handler = ami_int4, .name = "int4 handler" },
-	{ .handler = ami_int5, .name = "int5 handler" },
-	{ 0, /* CIAB */ },
-	{ .handler = ami_int7, .name = "int7 handler" },
-};
-#else
-void (*amiga_default_handler[SYS_IRQS])(int, void *, struct pt_regs *) = {
-	ami_badint, ami_int1, ami_badint, ami_int3,
-	ami_int4, ami_int5, ami_badint, ami_int7
-};
-#endif
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/cia.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,176 +0,0 @@
-/*
- *  Copyright (C) 1996 Roman Zippel
- *
- *  The concept of some functions bases on the original Amiga OS function
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/irq.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-
-struct ciabase {
-	volatile struct CIA *cia;
-	u_char icr_mask, icr_data;
-	u_short int_mask;
-	int handler_irq, cia_irq, server_irq;
-	char *name;
-} ciaa_base = {
-	&ciaa, 0, 0, IF_PORTS,
-	IRQ_AMIGA_AUTO_2, IRQ_AMIGA_CIAA,
-	IRQ_AMIGA_PORTS,
-	"CIAA handler"
-}, ciab_base = {
-	&ciab, 0, 0, IF_EXTER,
-	IRQ_AMIGA_AUTO_6, IRQ_AMIGA_CIAB,
-	IRQ_AMIGA_EXTER,
-	"CIAB handler"
-};
-
-#define CIA_SET_BASE_ADJUST_IRQ(base, irq)	\
-do {						\
-	if (irq >= IRQ_AMIGA_CIAB) {		\
-		base = &ciab_base;		\
-		irq -= IRQ_AMIGA_CIAB;		\
-	} else {				\
-		base = &ciaa_base;		\
-		irq -= IRQ_AMIGA_CIAA;		\
-	}					\
-} while (0)
-
-/*
- *  Cause or clear CIA interrupts, return old interrupt status.
- */
-
-static unsigned char cia_set_irq_private(struct ciabase *base,
-					 unsigned char mask)
-{
-	u_char old;
-
-	old = (base->icr_data |= base->cia->icr);
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_data |= mask;
-	else
-		base->icr_data &= ~mask;
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq = IF_SETCLR | base->int_mask;
-	return old & base->icr_mask;
-}
-
-unsigned char cia_set_irq(unsigned int irq, int set)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >= IRQ_AMIGA_CIAB)
-		mask = (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask = (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |= (set) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_set_irq_private(base, mask);
-}
-
-unsigned char cia_get_irq_mask(unsigned int irq)
-{
-	struct ciabase *base;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return base->cia->icr;
-}
-
-/*
- *  Enable or disable CIA interrupts, return old interrupt mask.
- */
-
-static unsigned char cia_able_irq_private(struct ciabase *base,
-					  unsigned char mask)
-{
-	u_char old;
-
-	old = base->icr_mask;
-	base->icr_data |= base->cia->icr;
-	base->cia->icr = mask;
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_mask |= mask;
-	else
-		base->icr_mask &= ~mask;
-	base->icr_mask &= CIA_ICR_ALL;
-
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq = IF_SETCLR | base->int_mask;
-	return old;
-}
-
-unsigned char cia_able_irq(unsigned int irq, int enable)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >= IRQ_AMIGA_CIAB)
-		mask = (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask = (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |= (enable) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_able_irq_private(base, mask);
-}
-
-static void cia_handler(int irq, void *dev_id, struct pt_regs *fp)
-{
-	struct ciabase *base = (struct ciabase *)dev_id;
-	irq_desc_t *desc;
-	struct irqaction *action;
-	int i;
-	unsigned char ints;
-
-	irq = base->cia_irq;
-	desc = irq_desc + irq;
-	ints = cia_set_irq_private(base, CIA_ICR_ALL);
-	amiga_custom.intreq = base->int_mask;
-	for (i = 0; i < CIA_IRQS; i++, irq++) {
-		if (ints & 1) {
-			kstat_cpu(0).irqs[irq]++;
-			action = desc->action;
-			action->handler(irq, action->dev_id, fp);
-		}
-		ints >>= 1;
-		desc++;
-	}
-	amiga_do_irq_list(base->server_irq, fp);
-}
-
-void __init cia_init_IRQ(struct ciabase *base)
-{
-	extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-	struct irqaction *action;
-
-	/* clear any pending interrupt and turn off all interrupts */
-	cia_set_irq_private(base, CIA_ICR_ALL);
-	cia_able_irq_private(base, CIA_ICR_ALL);
-
-	/* install CIA handler */
-	action = &amiga_sys_irqaction[base->handler_irq-IRQ_AMIGA_AUTO];
-	action->handler = cia_handler;
-	action->dev_id = base;
-	action->name = base->name;
-	setup_irq(base->handler_irq, &amiga_sys_irqaction[base->handler_irq-IRQ_AMIGA_AUTO]);
-
-	amiga_custom.intena = IF_SETCLR | base->int_mask;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/pcmcia.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/pcmcia.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amisound.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amisound.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/time.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,57 +0,0 @@
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-
-#include <asm/machdep.h>
-#include <asm/io.h>
-
-#include <linux/timex.h>
-
-unsigned long m68k_get_rtc_time(void)
-{
-	unsigned int year, mon, day, hour, min, sec;
-
-	extern void arch_gettod(int *year, int *mon, int *day, int *hour,
-				int *min, int *sec);
-
-	arch_gettod (&year, &mon, &day, &hour, &min, &sec);
-
-	if ((year += 1900) < 1970)
-		year += 100;
-
-	return mktime(year, mon, day, hour, min, sec);
-}
-
-int m68k_set_rtc_time(unsigned long nowtime)
-{
-  if (mach_set_clock_mmss)
-    return mach_set_clock_mmss (nowtime);
-  return -1;
-}
-
-void apus_heartbeat (void)
-{
-#ifdef CONFIG_HEARTBEAT
-	static unsigned cnt = 0, period = 0, dist = 0;
-
-	if (cnt == 0 || cnt == dist)
-                mach_heartbeat( 1 );
-	else if (cnt == 7 || cnt == dist+7)
-                mach_heartbeat( 0 );
-
-	if (++cnt > period) {
-                cnt = 0;
-                /* The hyperbolic function below modifies the heartbeat period
-                 * length in dependency of the current (5min) load. It goes
-                 * through the points f(0)=126, f(1)=86, f(5)=51,
-                 * f(inf)->30. */
-                period = ((672<<FSHIFT)/(5*avenrun[0]+(7<<FSHIFT))) + 30;
-                dist = period / 4;
-	}
-#endif
-	/* should be made smarter */
-	ppc_md.heartbeat_count = 1;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/bootinfo.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,78 +0,0 @@
-/*
- *  Extracted from arch/m68k/kernel/setup.c.
- *  Should be properly generalized and put somewhere else.
- *                              Jesper
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/bootinfo.h>
-
-extern char cmd_line[CL_SIZE];
-
-extern int num_memory;
-extern int m68k_realnum_memory;
-extern struct mem_info memory[NUM_MEMINFO];
-extern struct mem_info m68k_memory[NUM_MEMINFO];
-extern struct mem_info ramdisk;
-
-extern int amiga_parse_bootinfo(const struct bi_record *);
-extern int atari_parse_bootinfo(const struct bi_record *);
-extern int mac_parse_bootinfo(const struct bi_record *);
-
-void __init parse_bootinfo(const struct bi_record *record)
-{
-    while (record->tag != BI_LAST) {
-	int unknown = 0;
-	const u_long *data = record->data;
-	switch (record->tag) {
-	    case BI_MACHTYPE:
-	    case BI_CPUTYPE:
-	    case BI_FPUTYPE:
-	    case BI_MMUTYPE:
-		/* Already set up by head.S */
-		break;
-
-	    case BI_MEMCHUNK:
-		if (num_memory < NUM_MEMINFO) {
-		    memory[num_memory].addr = data[0];
-		    memory[num_memory].size = data[1];
-		    num_memory++;
-
-		    /* FIXME: duplicate for m68k drivers. */
-		    m68k_memory[m68k_realnum_memory].addr = data[0];
-		    m68k_memory[m68k_realnum_memory].size = data[1];
-		    m68k_realnum_memory++;
-		} else
-		    printk("parse_bootinfo: too many memory chunks\n");
-		break;
-
-	    case BI_RAMDISK:
-		ramdisk.addr = data[0];
-		ramdisk.size = data[1];
-		break;
-
-	    case BI_COMMAND_LINE:
-		strlcpy(cmd_line, (const char *)data, sizeof(cmd_line));
-		break;
-
-	    default:
-		if (MACH_IS_AMIGA)
-		    unknown = amiga_parse_bootinfo(record);
-		else if (MACH_IS_ATARI)
-		    unknown = atari_parse_bootinfo(record);
-		else if (MACH_IS_MAC)
-		    unknown = mac_parse_bootinfo(record);
-		else
-		    unknown = 1;
-	}
-	if (unknown)
-	    printk("parse_bootinfo: unknown tag 0x%04x ignored\n",
-		   record->tag);
-	record = (struct bi_record *)((u_long)record+record->size);
-    }
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/ints.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,158 +0,0 @@
-/*
- *  Linux/m68k general interrupt handling code from arch/m68k/kernel/ints.c
- *  Needed to drive the m68k emulating IRQ hardware on the PowerUp boards.
- */
-
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/seq_file.h>
-
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/page.h>
-#include <asm/machdep.h>
-
-/* table for system interrupt handlers */
-static irq_handler_t irq_list[SYS_IRQS];
-
-static const char *default_names[SYS_IRQS] = {
-	"spurious int", "int1 handler", "int2 handler", "int3 handler",
-	"int4 handler", "int5 handler", "int6 handler", "int7 handler"
-};
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-#define NUM_IRQ_NODES 100
-static irq_node_t nodes[NUM_IRQ_NODES];
-
-
-/*
- * void init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the IRQ handling routines.
- */
-
-__init
-void m68k_init_IRQ(void)
-{
-	int i;
-
-	for (i = 0; i < SYS_IRQS; i++) {
-		if (mach_default_handler)
-			irq_list[i].handler = (*mach_default_handler)[i];
-		irq_list[i].flags   = 0;
-		irq_list[i].dev_id  = NULL;
-		irq_list[i].devname = default_names[i];
-	}
-
-	for (i = 0; i < NUM_IRQ_NODES; i++)
-		nodes[i].handler = NULL;
-
-	mach_init_IRQ ();
-}
-
-irq_node_t *new_irq_node(void)
-{
-	irq_node_t *node;
-	short i;
-
-	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--)
-		if (!node->handler)
-			return node;
-
-	printk ("new_irq_node: out of nodes\n");
-	return NULL;
-}
-
-int sys_request_irq(unsigned int irq,
-                    void (*handler)(int, void *, struct pt_regs *),
-                    unsigned long flags, const char *devname, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-#if 0
-	if (!(irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk("%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (!(flags & IRQ_FLG_REPLACE)) {
-			printk("%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-#endif
-
-	irq_list[irq].handler = handler;
-	irq_list[irq].flags   = flags;
-	irq_list[irq].dev_id  = dev_id;
-	irq_list[irq].devname = devname;
-	return 0;
-}
-
-void sys_free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id != dev_id)
-		printk("%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	irq_list[irq].handler = (*mach_default_handler)[irq];
-	irq_list[irq].flags   = 0;
-	irq_list[irq].dev_id  = NULL;
-	irq_list[irq].devname = default_names[irq];
-}
-
-asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
-{
-	if (vec >= VEC_INT1 && vec <= VEC_INT7 && !MACH_IS_BVME6000) {
-		vec -= VEC_SPUR;
-		kstat_cpu(0).irqs[vec]++;
-		irq_list[vec].handler(vec, irq_list[vec].dev_id, fp);
-	} else {
-		if (mach_process_int)
-			mach_process_int(vec, fp);
-		else
-			panic("Can't process interrupt vector %ld\n", vec);
-		return;
-	}
-}
-
-int m68k_get_irq_list(struct seq_file *p, void *v)
-{
-	int i;
-
-	/* autovector interrupts */
-	if (mach_default_handler) {
-		for (i = 0; i < SYS_IRQS; i++) {
-			seq_printf(p, "auto %2d: %10u ", i,
-			               i ? kstat_cpu(0).irqs[i] : num_spurious);
-			seq_puts(p, "  ");
-			seq_printf(p, "%s\n", irq_list[i].devname);
-		}
-	}
-
-	mach_get_irq_list(p, v);
-	return 0;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/configs/apus_defconfig	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,920 +0,0 @@
-#
-# Automatically generated make config: don't edit
-#
-CONFIG_MMU=y
-CONFIG_RWSEM_XCHGADD_ALGORITHM=y
-CONFIG_HAVE_DEC_LOCK=y
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=y
-
-#
-# General setup
-#
-CONFIG_SWAP=y
-CONFIG_SYSVIPC=y
-# CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_EMBEDDED is not set
-CONFIG_FUTEX=y
-CONFIG_EPOLL=y
-
-#
-# Loadable module support
-#
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_MODULE_FORCE_UNLOAD=y
-CONFIG_OBSOLETE_MODPARM=y
-# CONFIG_MODVERSIONS is not set
-CONFIG_KMOD=y
-
-#
-# Platform support
-#
-CONFIG_PPC=y
-CONFIG_PPC32=y
-CONFIG_6xx=y
-# CONFIG_40x is not set
-# CONFIG_POWER3 is not set
-# CONFIG_8xx is not set
-
-#
-# IBM 4xx options
-#
-# CONFIG_8260 is not set
-CONFIG_GENERIC_ISA_DMA=y
-CONFIG_PPC_STD_MMU=y
-CONFIG_SERIAL_CONSOLE=y
-# CONFIG_PPC_MULTIPLATFORM is not set
-CONFIG_APUS=y
-# CONFIG_WILLOW_2 is not set
-# CONFIG_PCORE is not set
-# CONFIG_POWERPMC250 is not set
-# CONFIG_EV64260 is not set
-# CONFIG_SPRUCE is not set
-# CONFIG_LOPEC is not set
-# CONFIG_MCPN765 is not set
-# CONFIG_MVME5100 is not set
-# CONFIG_PPLUS is not set
-# CONFIG_PRPMC750 is not set
-# CONFIG_PRPMC800 is not set
-# CONFIG_SANDPOINT is not set
-# CONFIG_ADIR is not set
-# CONFIG_K2 is not set
-# CONFIG_PAL4 is not set
-# CONFIG_GEMINI is not set
-# CONFIG_SMP is not set
-# CONFIG_PREEMPT is not set
-# CONFIG_ALTIVEC is not set
-# CONFIG_TAU is not set
-# CONFIG_CPU_FREQ is not set
-
-#
-# General setup
-#
-# CONFIG_HIGHMEM is not set
-CONFIG_PCI=y
-CONFIG_PCI_DOMAINS=y
-CONFIG_PCI_PERMEDIA=y
-CONFIG_KCORE_ELF=y
-CONFIG_BINFMT_ELF=y
-CONFIG_KERNEL_ELF=y
-CONFIG_BINFMT_MISC=m
-CONFIG_PCI_LEGACY_PROC=y
-CONFIG_PCI_NAMES=y
-# CONFIG_HOTPLUG is not set
-
-#
-# Parallel port support
-#
-CONFIG_PARPORT=m
-# CONFIG_PARPORT_PC is not set
-CONFIG_PARPORT_AMIGA=m
-# CONFIG_PARPORT_MFC3 is not set
-# CONFIG_PARPORT_OTHER is not set
-# CONFIG_PARPORT_1284 is not set
-CONFIG_PPC601_SYNC_FIX=y
-# CONFIG_CMDLINE_BOOL is not set
-CONFIG_AMIGA=y
-CONFIG_ZORRO=y
-CONFIG_ABSTRACT_CONSOLE=y
-CONFIG_APUS_FAST_EXCEPT=y
-CONFIG_AMIGA_PCMCIA=y
-CONFIG_AMIGA_BUILTIN_SERIAL=y
-CONFIG_GVPIOEXT=y
-CONFIG_GVPIOEXT_LP=m
-CONFIG_GVPIOEXT_PLIP=m
-CONFIG_MULTIFACE_III_TTY=y
-CONFIG_A2232=y
-CONFIG_WHIPPET_SERIAL=y
-CONFIG_APNE=y
-CONFIG_HEARTBEAT=y
-CONFIG_PROC_HARDWARE=y
-CONFIG_ZORRO_NAMES=y
-
-#
-# Advanced setup
-#
-# CONFIG_ADVANCED_OPTIONS is not set
-
-#
-# Default settings for advanced configuration options are used
-#
-CONFIG_HIGHMEM_START=0xfe000000
-CONFIG_LOWMEM_SIZE=0x30000000
-CONFIG_KERNEL_START=0xc0000000
-CONFIG_TASK_SIZE=0x80000000
-CONFIG_BOOT_LOAD=0x00800000
-
-#
-# Memory Technology Devices (MTD)
-#
-# CONFIG_MTD is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNP is not set
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_FD is not set
-CONFIG_AMIGA_FLOPPY=y
-CONFIG_AMIGA_Z2RAM=m
-# CONFIG_PARIDE is not set
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_UMEM is not set
-CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_NBD=m
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_INITRD=y
-
-#
-# Multi-device support (RAID and LVM)
-#
-CONFIG_MD=y
-CONFIG_BLK_DEV_MD=m
-CONFIG_MD_LINEAR=m
-CONFIG_MD_RAID0=m
-CONFIG_MD_RAID1=m
-CONFIG_MD_RAID5=m
-# CONFIG_MD_MULTIPATH is not set
-CONFIG_BLK_DEV_DM=m
-
-#
-# ATA/IDE/MFM/RLL support
-#
-CONFIG_IDE=y
-
-#
-# IDE, ATA and ATAPI Block devices
-#
-CONFIG_BLK_DEV_IDE=y
-
-#
-# Please see Documentation/ide.txt for help/info on IDE drives
-#
-# CONFIG_BLK_DEV_HD is not set
-CONFIG_BLK_DEV_IDEDISK=y
-# CONFIG_IDEDISK_MULTI_MODE is not set
-# CONFIG_IDEDISK_STROKE is not set
-CONFIG_BLK_DEV_IDECD=y
-CONFIG_BLK_DEV_IDEFLOPPY=y
-CONFIG_BLK_DEV_IDESCSI=m
-# CONFIG_IDE_TASK_IOCTL is not set
-
-#
-# IDE chipset support/bugfixes
-#
-# CONFIG_BLK_DEV_IDEPCI is not set
-CONFIG_BLK_DEV_GAYLE=y
-CONFIG_BLK_DEV_IDEDOUBLER=y
-CONFIG_BLK_DEV_BUDDHA=y
-
-#
-# SCSI support
-#
-CONFIG_SCSI=y
-
-#
-# SCSI support type (disk, tape, CD-ROM)
-#
-CONFIG_BLK_DEV_SD=y
-CONFIG_CHR_DEV_ST=m
-CONFIG_CHR_DEV_OSST=m
-CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
-CONFIG_CHR_DEV_SG=m
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
-# CONFIG_SCSI_MULTI_LUN is not set
-# CONFIG_SCSI_REPORT_LUNS is not set
-CONFIG_SCSI_CONSTANTS=y
-CONFIG_SCSI_LOGGING=y
-
-#
-# SCSI low-level drivers
-#
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ADVANSYS is not set
-# CONFIG_SCSI_IN2000 is not set
-# CONFIG_SCSI_AM53C974 is not set
-# CONFIG_SCSI_MEGARAID is not set
-# CONFIG_SCSI_BUSLOGIC is not set
-# CONFIG_SCSI_CPQFCTS is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_EATA is not set
-# CONFIG_SCSI_EATA_PIO is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_GDTH is not set
-# CONFIG_SCSI_GENERIC_NCR5380 is not set
-# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_PPA is not set
-# CONFIG_SCSI_IMM is not set
-# CONFIG_SCSI_NCR53C7xx is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_NCR53C8XX is not set
-# CONFIG_SCSI_SYM53C8XX is not set
-# CONFIG_SCSI_PCI2000 is not set
-# CONFIG_SCSI_PCI2220I is not set
-# CONFIG_SCSI_QLOGIC_ISP is not set
-# CONFIG_SCSI_QLOGIC_FC is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_U14_34F is not set
-# CONFIG_SCSI_NSP32 is not set
-# CONFIG_SCSI_DEBUG is not set
-CONFIG_A3000_SCSI=y
-CONFIG_A4000T_SCSI=y
-CONFIG_A2091_SCSI=y
-CONFIG_GVP11_SCSI=y
-CONFIG_CYBERSTORM_SCSI=y
-CONFIG_CYBERSTORMII_SCSI=y
-CONFIG_BLZ2060_SCSI=y
-CONFIG_BLZ1230_SCSI=y
-CONFIG_FASTLANE_SCSI=y
-CONFIG_A4091_SCSI=y
-CONFIG_WARPENGINE_SCSI=y
-CONFIG_BLZ603EPLUS_SCSI=y
-CONFIG_OKTAGON_SCSI=y
-
-#
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support (EXPERIMENTAL)
-#
-# CONFIG_IEEE1394 is not set
-
-#
-# I2O device support
-#
-# CONFIG_I2O is not set
-
-#
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=m
-CONFIG_PACKET_MMAP=y
-CONFIG_NETLINK_DEV=m
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_INET_ECN is not set
-CONFIG_SYN_COOKIES=y
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-
-#
-# IP: Netfilter Configuration
-#
-CONFIG_IP_NF_CONNTRACK=m
-CONFIG_IP_NF_FTP=m
-CONFIG_IP_NF_IRC=m
-CONFIG_IP_NF_TFTP=m
-CONFIG_IP_NF_AMANDA=m
-CONFIG_IP_NF_QUEUE=m
-CONFIG_IP_NF_IPTABLES=m
-CONFIG_IP_NF_MATCH_LIMIT=m
-CONFIG_IP_NF_MATCH_MAC=m
-# CONFIG_IP_NF_MATCH_PKTTYPE is not set
-CONFIG_IP_NF_MATCH_MARK=m
-CONFIG_IP_NF_MATCH_MULTIPORT=m
-CONFIG_IP_NF_MATCH_TOS=m
-# CONFIG_IP_NF_MATCH_ECN is not set
-# CONFIG_IP_NF_MATCH_DSCP is not set
-# CONFIG_IP_NF_MATCH_AH_ESP is not set
-CONFIG_IP_NF_MATCH_LENGTH=m
-CONFIG_IP_NF_MATCH_TTL=m
-CONFIG_IP_NF_MATCH_TCPMSS=m
-CONFIG_IP_NF_MATCH_HELPER=m
-CONFIG_IP_NF_MATCH_STATE=m
-CONFIG_IP_NF_MATCH_CONNTRACK=m
-CONFIG_IP_NF_MATCH_UNCLEAN=m
-CONFIG_IP_NF_MATCH_OWNER=m
-CONFIG_IP_NF_FILTER=m
-CONFIG_IP_NF_TARGET_REJECT=m
-CONFIG_IP_NF_TARGET_MIRROR=m
-CONFIG_IP_NF_NAT=m
-CONFIG_IP_NF_NAT_NEEDED=y
-CONFIG_IP_NF_TARGET_MASQUERADE=m
-CONFIG_IP_NF_TARGET_REDIRECT=m
-CONFIG_IP_NF_NAT_SNMP_BASIC=m
-CONFIG_IP_NF_NAT_IRC=m
-CONFIG_IP_NF_NAT_FTP=m
-CONFIG_IP_NF_NAT_TFTP=m
-CONFIG_IP_NF_NAT_AMANDA=m
-CONFIG_IP_NF_MANGLE=m
-CONFIG_IP_NF_TARGET_TOS=m
-CONFIG_IP_NF_TARGET_ECN=m
-CONFIG_IP_NF_TARGET_DSCP=m
-CONFIG_IP_NF_TARGET_MARK=m
-CONFIG_IP_NF_TARGET_LOG=m
-CONFIG_IP_NF_TARGET_ULOG=m
-CONFIG_IP_NF_TARGET_TCPMSS=m
-CONFIG_IP_NF_ARPTABLES=m
-CONFIG_IP_NF_ARPFILTER=m
-CONFIG_IP_NF_COMPAT_IPCHAINS=m
-# CONFIG_IP_NF_COMPAT_IPFWADM is not set
-# CONFIG_IPV6 is not set
-# CONFIG_XFRM_USER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-CONFIG_IPV6_SCTP__=y
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_LLC is not set
-# CONFIG_DECNET is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_HW_FLOWCONTROL is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-CONFIG_NETDEVICES=y
-
-#
-# ARCnet devices
-#
-# CONFIG_ARCNET is not set
-CONFIG_DUMMY=m
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-CONFIG_TUN=m
-# CONFIG_ETHERTAP is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
-CONFIG_NET_ETHERNET=y
-# CONFIG_MII is not set
-# CONFIG_OAKNET is not set
-CONFIG_ARIADNE=y
-# CONFIG_ZORRO8390 is not set
-CONFIG_A2065=y
-CONFIG_HYDRA=y
-# CONFIG_HAPPYMEAL is not set
-# CONFIG_SUNGEM is not set
-# CONFIG_NET_VENDOR_3COM is not set
-
-#
-# Tulip family network device support
-#
-# CONFIG_NET_TULIP is not set
-# CONFIG_HP100 is not set
-# CONFIG_NET_PCI is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-# CONFIG_ACENIC is not set
-# CONFIG_DL2K is not set
-# CONFIG_E1000 is not set
-# CONFIG_NS83820 is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_R8169 is not set
-# CONFIG_SK98LIN is not set
-# CONFIG_TIGON3 is not set
-
-#
-# Ethernet (10000 Mbit)
-#
-# CONFIG_IXGB is not set
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
-CONFIG_PLIP=m
-CONFIG_PPP=y
-CONFIG_PPP_MULTILINK=y
-CONFIG_PPP_FILTER=y
-CONFIG_PPP_ASYNC=y
-CONFIG_PPP_SYNC_TTY=y
-CONFIG_PPP_DEFLATE=y
-CONFIG_PPP_BSDCOMP=y
-CONFIG_PPPOE=y
-CONFIG_SLIP=y
-CONFIG_SLIP_COMPRESSED=y
-CONFIG_SLIP_SMART=y
-CONFIG_SLIP_MODE_SLIP6=y
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Token Ring devices (depends on LLC=y)
-#
-# CONFIG_NET_FC is not set
-# CONFIG_RCPCI is not set
-# CONFIG_SHAPER is not set
-
-#
-# Wan interfaces
-#
-# CONFIG_WAN is not set
-
-#
-# Amateur Radio support
-#
-# CONFIG_HAMRADIO is not set
-
-#
-# IrDA (infrared) support
-#
-# CONFIG_IRDA is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN_BOOL is not set
-
-#
-# Graphics support
-#
-CONFIG_FB=y
-# CONFIG_FB_CIRRUS is not set
-CONFIG_FB_PM2=y
-# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
-# CONFIG_FB_PM2_PCI is not set
-CONFIG_FB_PM2_CVPPC=y
-CONFIG_FB_CYBER2000=y
-CONFIG_FB_AMIGA=y
-CONFIG_FB_AMIGA_OCS=y
-CONFIG_FB_AMIGA_ECS=y
-CONFIG_FB_AMIGA_AGA=y
-CONFIG_FB_CYBER=y
-CONFIG_FB_VIRGE=y
-CONFIG_FB_RETINAZ3=y
-CONFIG_FB_FM2=y
-# CONFIG_FB_CT65550 is not set
-# CONFIG_FB_IMSTT is not set
-# CONFIG_FB_S3TRIO is not set
-# CONFIG_FB_VGA16 is not set
-# CONFIG_FB_RIVA is not set
-# CONFIG_FB_MATROX is not set
-# CONFIG_FB_RADEON is not set
-# CONFIG_FB_ATY128 is not set
-# CONFIG_FB_ATY is not set
-# CONFIG_FB_SIS is not set
-# CONFIG_FB_NEOMAGIC is not set
-# CONFIG_FB_3DFX is not set
-# CONFIG_FB_VOODOO1 is not set
-# CONFIG_FB_TRIDENT is not set
-# CONFIG_FB_PM3 is not set
-# CONFIG_FB_VIRTUAL is not set
-
-#
-# Logo configuration
-#
-CONFIG_LOGO=y
-CONFIG_LOGO_LINUX_MONO=y
-CONFIG_LOGO_LINUX_VGA16=y
-CONFIG_LOGO_LINUX_CLUT224=y
-
-#
-# Old CD-ROM drivers (not SCSI, not IDE)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
-# Input device support
-#
-CONFIG_INPUT=m
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=m
-CONFIG_INPUT_MOUSEDEV_PSAUX=y
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-CONFIG_INPUT_JOYDEV=m
-# CONFIG_INPUT_TSDEV is not set
-CONFIG_INPUT_EVDEV=m
-CONFIG_INPUT_EVBUG=m
-
-#
-# Input I/O drivers
-#
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
-CONFIG_SERIO=y
-# CONFIG_SERIO_I8042 is not set
-CONFIG_SERIO_SERPORT=y
-# CONFIG_SERIO_CT82C710 is not set
-# CONFIG_SERIO_PARKBD is not set
-
-#
-# Input Device Drivers
-#
-CONFIG_INPUT_KEYBOARD=y
-CONFIG_KEYBOARD_ATKBD=m
-# CONFIG_KEYBOARD_SUNKBD is not set
-# CONFIG_KEYBOARD_XTKBD is not set
-# CONFIG_KEYBOARD_NEWTON is not set
-CONFIG_KEYBOARD_AMIGA=m
-CONFIG_INPUT_MOUSE=y
-CONFIG_MOUSE_PS2=m
-CONFIG_MOUSE_SERIAL=m
-CONFIG_MOUSE_AMIGA=m
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-CONFIG_INPUT_MISC=y
-# CONFIG_INPUT_PCSPKR is not set
-CONFIG_INPUT_UINPUT=m
-
-#
-# Macintosh device drivers
-#
-
-#
-# Character devices
-#
-# CONFIG_SERIAL_NONSTANDARD is not set
-
-#
-# Serial drivers
-#
-# CONFIG_SERIAL_8250 is not set
-
-#
-# Non-8250 serial port support
-#
-CONFIG_UNIX98_PTYS=y
-CONFIG_UNIX98_PTY_COUNT=256
-CONFIG_PRINTER=m
-# CONFIG_LP_CONSOLE is not set
-# CONFIG_PPDEV is not set
-# CONFIG_TIPAR is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# I2C Hardware Sensors Mainboard support
-#
-
-#
-# I2C Hardware Sensors Chip support
-#
-# CONFIG_I2C_SENSOR is not set
-
-#
-# Mice
-#
-CONFIG_BUSMOUSE=y
-# CONFIG_QIC02_TAPE is not set
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
-# CONFIG_NVRAM is not set
-CONFIG_GEN_RTC=y
-# CONFIG_GEN_RTC_X is not set
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_FTAPE is not set
-# CONFIG_AGP is not set
-# CONFIG_DRM is not set
-# CONFIG_RAW_DRIVER is not set
-# CONFIG_HANGCHECK_TIMER is not set
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-
-#
-# File systems
-#
-CONFIG_EXT2_FS=y
-# CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=y
-CONFIG_EXT3_FS_XATTR=y
-# CONFIG_EXT3_FS_POSIX_ACL is not set
-# CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=y
-# CONFIG_JBD_DEBUG is not set
-CONFIG_FS_MBCACHE=y
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_XFS_FS is not set
-CONFIG_MINIX_FS=y
-CONFIG_ROMFS_FS=y
-# CONFIG_QUOTA is not set
-CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
-
-#
-# CD-ROM/DVD Filesystems
-#
-CONFIG_ISO9660_FS=y
-CONFIG_JOLIET=y
-# CONFIG_ZISOFS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-CONFIG_FAT_FS=y
-CONFIG_MSDOS_FS=y
-CONFIG_VFAT_FS=y
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-# CONFIG_DEVFS_FS is not set
-CONFIG_DEVPTS_FS=y
-# CONFIG_DEVPTS_FS_XATTR is not set
-CONFIG_TMPFS=y
-CONFIG_RAMFS=y
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-CONFIG_AFFS_FS=y
-CONFIG_HFS_FS=y
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_CRAMFS=y
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V4 is not set
-CONFIG_NFSD=m
-CONFIG_NFSD_V3=y
-# CONFIG_NFSD_V4 is not set
-# CONFIG_NFSD_TCP is not set
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_EXPORTFS=m
-CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_GSS is not set
-CONFIG_SMB_FS=m
-# CONFIG_SMB_NLS_DEFAULT is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-CONFIG_CODA_FS=m
-# CONFIG_INTERMEZZO_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-CONFIG_PARTITION_ADVANCED=y
-# CONFIG_ACORN_PARTITION is not set
-# CONFIG_OSF_PARTITION is not set
-CONFIG_AMIGA_PARTITION=y
-CONFIG_ATARI_PARTITION=y
-# CONFIG_MAC_PARTITION is not set
-CONFIG_MSDOS_PARTITION=y
-CONFIG_BSD_DISKLABEL=y
-# CONFIG_MINIX_SUBPARTITION is not set
-CONFIG_SOLARIS_X86_PARTITION=y
-CONFIG_UNIXWARE_DISKLABEL=y
-# CONFIG_LDM_PARTITION is not set
-# CONFIG_NEC98_PARTITION is not set
-# CONFIG_SGI_PARTITION is not set
-# CONFIG_ULTRIX_PARTITION is not set
-# CONFIG_SUN_PARTITION is not set
-# CONFIG_EFI_PARTITION is not set
-CONFIG_SMB_NLS=y
-CONFIG_NLS=y
-
-#
-# Native Language Support
-#
-CONFIG_NLS_DEFAULT="iso8859-1"
-CONFIG_NLS_CODEPAGE_437=m
-CONFIG_NLS_CODEPAGE_737=m
-CONFIG_NLS_CODEPAGE_775=m
-CONFIG_NLS_CODEPAGE_850=m
-CONFIG_NLS_CODEPAGE_852=m
-CONFIG_NLS_CODEPAGE_855=m
-CONFIG_NLS_CODEPAGE_857=m
-CONFIG_NLS_CODEPAGE_860=m
-CONFIG_NLS_CODEPAGE_861=m
-CONFIG_NLS_CODEPAGE_862=m
-CONFIG_NLS_CODEPAGE_863=m
-CONFIG_NLS_CODEPAGE_864=m
-CONFIG_NLS_CODEPAGE_865=m
-CONFIG_NLS_CODEPAGE_866=m
-CONFIG_NLS_CODEPAGE_869=m
-CONFIG_NLS_CODEPAGE_936=m
-CONFIG_NLS_CODEPAGE_950=m
-CONFIG_NLS_CODEPAGE_932=m
-CONFIG_NLS_CODEPAGE_949=m
-CONFIG_NLS_CODEPAGE_874=m
-CONFIG_NLS_ISO8859_8=m
-# CONFIG_NLS_CODEPAGE_1250 is not set
-CONFIG_NLS_CODEPAGE_1251=m
-CONFIG_NLS_ISO8859_1=m
-CONFIG_NLS_ISO8859_2=m
-CONFIG_NLS_ISO8859_3=m
-CONFIG_NLS_ISO8859_4=m
-CONFIG_NLS_ISO8859_5=m
-CONFIG_NLS_ISO8859_6=m
-CONFIG_NLS_ISO8859_7=m
-CONFIG_NLS_ISO8859_9=m
-CONFIG_NLS_ISO8859_13=m
-CONFIG_NLS_ISO8859_14=m
-CONFIG_NLS_ISO8859_15=m
-CONFIG_NLS_KOI8_R=m
-CONFIG_NLS_KOI8_U=m
-CONFIG_NLS_UTF8=m
-
-#
-# Sound
-#
-CONFIG_SOUND=y
-CONFIG_DMASOUND_PAULA=m
-CONFIG_DMASOUND=m
-
-#
-# Advanced Linux Sound Architecture
-#
-# CONFIG_SND is not set
-
-#
-# Open Sound System
-#
-CONFIG_SOUND_PRIME=m
-# CONFIG_SOUND_BT878 is not set
-# CONFIG_SOUND_CMPCI is not set
-# CONFIG_SOUND_EMU10K1 is not set
-# CONFIG_SOUND_FUSION is not set
-# CONFIG_SOUND_CS4281 is not set
-# CONFIG_SOUND_ES1370 is not set
-# CONFIG_SOUND_ES1371 is not set
-# CONFIG_SOUND_ESSSOLO1 is not set
-# CONFIG_SOUND_MAESTRO is not set
-# CONFIG_SOUND_MAESTRO3 is not set
-# CONFIG_SOUND_ICH is not set
-# CONFIG_SOUND_RME96XX is not set
-# CONFIG_SOUND_SONICVIBES is not set
-# CONFIG_SOUND_TRIDENT is not set
-# CONFIG_SOUND_MSNDCLAS is not set
-# CONFIG_SOUND_MSNDPIN is not set
-# CONFIG_SOUND_VIA82CXXX is not set
-CONFIG_SOUND_OSS=m
-CONFIG_SOUND_TRACEINIT=y
-CONFIG_SOUND_DMAP=y
-# CONFIG_SOUND_AD1816 is not set
-# CONFIG_SOUND_SGALAXY is not set
-# CONFIG_SOUND_ADLIB is not set
-# CONFIG_SOUND_ACI_MIXER is not set
-# CONFIG_SOUND_CS4232 is not set
-# CONFIG_SOUND_SSCAPE is not set
-# CONFIG_SOUND_GUS is not set
-CONFIG_SOUND_VMIDI=m
-# CONFIG_SOUND_TRIX is not set
-# CONFIG_SOUND_MSS is not set
-# CONFIG_SOUND_MPU401 is not set
-# CONFIG_SOUND_NM256 is not set
-# CONFIG_SOUND_MAD16 is not set
-# CONFIG_SOUND_PAS is not set
-# CONFIG_SOUND_PSS is not set
-# CONFIG_SOUND_SB is not set
-# CONFIG_SOUND_AWE32_SYNTH is not set
-# CONFIG_SOUND_WAVEFRONT is not set
-# CONFIG_SOUND_MAUI is not set
-# CONFIG_SOUND_YM3812 is not set
-# CONFIG_SOUND_OPL3SA1 is not set
-# CONFIG_SOUND_OPL3SA2 is not set
-# CONFIG_SOUND_YMFPCI is not set
-# CONFIG_SOUND_UART6850 is not set
-# CONFIG_SOUND_AEDSP16 is not set
-
-#
-# USB support
-#
-# CONFIG_USB is not set
-# CONFIG_USB_GADGET is not set
-
-#
-# Bluetooth support
-#
-# CONFIG_BT is not set
-
-#
-# Library routines
-#
-# CONFIG_CRC32 is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-
-#
-# Kernel hacking
-#
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_KALLSYMS is not set
-
-#
-# Security options
-#
-# CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
-# CONFIG_CRYPTO is not set
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/apus_pci.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,34 +0,0 @@
-/*
- * Phase5 CybervisionPPC (TVP4020) definitions for the Permedia2 framebuffer
- * driver.
- *
- * Copyright (c) 1998-1999 Ilario Nardinocchi (nardinoc@CS.UniBO.IT)
- * --------------------------------------------------------------------------
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file README.legal in the main directory of this archive
- * for more details.
- */
-
-#ifndef APUS_PCI_H
-#define APUS_PCI_H
-
-
-#define CSPPC_PCI_BRIDGE		0xfffe0000
-#define CSPPC_BRIDGE_ENDIAN		0x0000
-#define CSPPC_BRIDGE_INT		0x0010
-
-#define	CVPPC_PCI_CONFIG		0xfffc0000
-#define CVPPC_ROM_ADDRESS		0xe2000001
-#define CVPPC_REGS_REGION		0xef000000
-#define CVPPC_FB_APERTURE_ONE		0xe0000000
-#define CVPPC_FB_APERTURE_TWO		0xe1000000
-#define CVPPC_FB_SIZE			0x00800000
-
-/* CVPPC_BRIDGE_ENDIAN */
-#define CSPPCF_BRIDGE_BIG_ENDIAN	0x02
-
-/* CVPPC_BRIDGE_INT */
-#define CSPPCF_BRIDGE_ACTIVE_INT2	0x01
-
-
-#endif	/* APUS_PCI_H */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigahw.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,16 +0,0 @@
-#ifdef __KERNEL__
-#ifndef __ASMPPC_AMIGAHW_H
-#define __ASMPPC_AMIGAHW_H
-
-#include <asm-m68k/amigahw.h>
-
-#undef CHIP_PHYSADDR
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define CHIP_PHYSADDR      (0x000000)
-#else
-#define CHIP_PHYSADDR      (0x004000)
-#endif
-
-
-#endif /* __ASMPPC_AMIGAHW_H */
-#endif /* __KERNEL__ */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigaints.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,133 +0,0 @@
-/*
-** amigaints.h -- Amiga Linux interrupt handling structs and prototypes
-**
-** Copyright 1992 by Greg Harp
-**
-** This file is subject to the terms and conditions of the GNU General Public
-** License.  See the file COPYING in the main directory of this archive
-** for more details.
-**
-** Created 10/2/92 by Greg Harp
-*/
-
-#ifdef __KERNEL__
-#ifndef _ASMm68k_AMIGAINTS_H_
-#define _ASMm68k_AMIGAINTS_H_
-
-/*
-** Amiga Interrupt sources.
-**
-*/
-
-#define AUTO_IRQS           (8)
-#define AMI_STD_IRQS        (14)
-#define CIA_IRQS            (5)
-#define AMI_IRQS            (32) /* AUTO_IRQS+AMI_STD_IRQS+2*CIA_IRQS */
-
-/* vertical blanking interrupt */
-#define IRQ_AMIGA_VERTB     0
-
-/* copper interrupt */
-#define IRQ_AMIGA_COPPER    1
-
-/* Audio interrupts */
-#define IRQ_AMIGA_AUD0	    2
-#define IRQ_AMIGA_AUD1	    3
-#define IRQ_AMIGA_AUD2	    4
-#define IRQ_AMIGA_AUD3	    5
-
-/* Blitter done interrupt */
-#define IRQ_AMIGA_BLIT	    6
-
-/* floppy disk interrupts */
-#define IRQ_AMIGA_DSKSYN    7
-#define IRQ_AMIGA_DSKBLK    8
-
-/* builtin serial port interrupts */
-#define IRQ_AMIGA_RBF	    9
-#define IRQ_AMIGA_TBE	    10
-
-/* software interrupts */
-#define IRQ_AMIGA_SOFT      11
-
-/* interrupts from external hardware */
-#define IRQ_AMIGA_PORTS	    12
-#define IRQ_AMIGA_EXTER	    13
-
-/* CIA interrupt sources */
-#define IRQ_AMIGA_CIAA      14
-#define IRQ_AMIGA_CIAA_TA   14
-#define IRQ_AMIGA_CIAA_TB   15
-#define IRQ_AMIGA_CIAA_ALRM 16
-#define IRQ_AMIGA_CIAA_SP   17
-#define IRQ_AMIGA_CIAA_FLG  18
-#define IRQ_AMIGA_CIAB      19
-#define IRQ_AMIGA_CIAB_TA   19
-#define IRQ_AMIGA_CIAB_TB   20
-#define IRQ_AMIGA_CIAB_ALRM 21
-#define IRQ_AMIGA_CIAB_SP   22
-#define IRQ_AMIGA_CIAB_FLG  23
-
-/* auto-vector interrupts */
-#define IRQ_AMIGA_AUTO      24
-#define IRQ_AMIGA_AUTO_0    24 /* This is just a dummy */
-#define IRQ_AMIGA_AUTO_1    25
-#define IRQ_AMIGA_AUTO_2    26
-#define IRQ_AMIGA_AUTO_3    27
-#define IRQ_AMIGA_AUTO_4    28
-#define IRQ_AMIGA_AUTO_5    29
-#define IRQ_AMIGA_AUTO_6    30
-#define IRQ_AMIGA_AUTO_7    31
-
-#define IRQ_FLOPPY	    IRQ_AMIGA_DSKBLK
-
-/* INTREQR masks */
-#define IRQ1_MASK   0x0007	/* INTREQR mask for IRQ 1 */
-#define IRQ2_MASK   0x0008	/* INTREQR mask for IRQ 2 */
-#define IRQ3_MASK   0x0070	/* INTREQR mask for IRQ 3 */
-#define IRQ4_MASK   0x0780	/* INTREQR mask for IRQ 4 */
-#define IRQ5_MASK   0x1800	/* INTREQR mask for IRQ 5 */
-#define IRQ6_MASK   0x2000	/* INTREQR mask for IRQ 6 */
-#define IRQ7_MASK   0x4000	/* INTREQR mask for IRQ 7 */
-
-#define IF_SETCLR   0x8000      /* set/clr bit */
-#define IF_INTEN    0x4000	/* master interrupt bit in INT* registers */
-#define IF_EXTER    0x2000	/* external level 6 and CIA B interrupt */
-#define IF_DSKSYN   0x1000	/* disk sync interrupt */
-#define IF_RBF	    0x0800	/* serial receive buffer full interrupt */
-#define IF_AUD3     0x0400	/* audio channel 3 done interrupt */
-#define IF_AUD2     0x0200	/* audio channel 2 done interrupt */
-#define IF_AUD1     0x0100	/* audio channel 1 done interrupt */
-#define IF_AUD0     0x0080	/* audio channel 0 done interrupt */
-#define IF_BLIT     0x0040	/* blitter done interrupt */
-#define IF_VERTB    0x0020	/* vertical blanking interrupt */
-#define IF_COPER    0x0010	/* copper interrupt */
-#define IF_PORTS    0x0008	/* external level 2 and CIA A interrupt */
-#define IF_SOFT     0x0004	/* software initiated interrupt */
-#define IF_DSKBLK   0x0002	/* diskblock DMA finished */
-#define IF_TBE	    0x0001	/* serial transmit buffer empty interrupt */
-
-extern void amiga_do_irq(int irq, struct pt_regs *fp);
-extern void amiga_do_irq_list(int irq, struct pt_regs *fp);
-
-/* CIA interrupt control register bits */
-
-#define CIA_ICR_TA	0x01
-#define CIA_ICR_TB	0x02
-#define CIA_ICR_ALRM	0x04
-#define CIA_ICR_SP	0x08
-#define CIA_ICR_FLG	0x10
-#define CIA_ICR_ALL	0x1f
-#define CIA_ICR_SETCLR	0x80
-
-/* to access the interrupt control registers of CIA's use only
-** these functions, they behave exactly like the amiga os routines
-*/
-
-extern struct ciabase ciaa_base, ciab_base;
-
-extern unsigned char cia_set_irq(unsigned int irq, int set);
-extern unsigned char cia_able_irq(unsigned int irq, int enable);
-
-#endif /* asm-m68k/amigaints.h */
-#endif /* __KERNEL__ */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigappc.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,85 +0,0 @@
-/*
-** asm-ppc/amigappc.h -- This header defines some values and pointers for
-**                        the Phase 5 PowerUp card.
-**
-** Copyright 1997, 1998 by Phase5, Germany.
-**
-** This file is subject to the terms and conditions of the GNU General Public
-** License.  See the file COPYING in the main directory of this archive
-** for more details.
-**
-** Created: 7/22/97 by Jesper Skov
-*/
-
-#ifdef __KERNEL__
-#ifndef _M68K_AMIGAPPC_H
-#define _M68K_AMIGAPPC_H
-
-#ifndef __ASSEMBLY__
-
-/* #include <asm/system.h> */
-#define mb()  __asm__ __volatile__ ("sync" : : : "memory")
-
-#define APUS_WRITE(_a_, _v_)				\
-do {							\
-	(*((volatile unsigned char *)(_a_)) = (_v_));	\
-	mb();						\
-} while (0)
-
-#define APUS_READ(_a_, _v_)				\
-do {							\
-	(_v_) = (*((volatile unsigned char *)(_a_)));	\
-	mb();						\
-} while (0)
-#endif /* ndef __ASSEMBLY__ */
-
-/* Maybe add a [#ifdef WANT_ZTWOBASE] condition to amigahw.h? */
-#define zTwoBase (0x80000000)
-
-#define APUS_IPL_BASE   	(zTwoBase + 0x00f60000)
-#define APUS_REG_RESET    	(APUS_IPL_BASE + 0x00)
-#define APUS_REG_WAITSTATE    	(APUS_IPL_BASE + 0x10)
-#define APUS_REG_SHADOW    	(APUS_IPL_BASE + 0x18)
-#define APUS_REG_LOCK		(APUS_IPL_BASE + 0x20)
-#define APUS_REG_INT    	(APUS_IPL_BASE + 0x28)
-#define APUS_IPL_EMU		(APUS_IPL_BASE + 0x30)
-#define APUS_INT_LVL		(APUS_IPL_BASE + 0x38)
-
-#define REGSHADOW_SETRESET	(0x80)
-#define REGSHADOW_SELFRESET	(0x40)
-
-#define REGLOCK_SETRESET	(0x80)
-#define REGLOCK_BLACKMAGICK1	(0x40)
-#define REGLOCK_BLACKMAGICK2	(0x20)
-#define REGLOCK_BLACKMAGICK3	(0x10)
-
-#define REGWAITSTATE_SETRESET	(0x80)
-#define REGWAITSTATE_PPCW	(0x08)
-#define REGWAITSTATE_PPCR	(0x04)
-
-#define REGRESET_SETRESET	(0x80)
-#define REGRESET_PPCRESET	(0x10)
-#define REGRESET_M68KRESET	(0x08)
-#define REGRESET_AMIGARESET	(0x04)
-#define REGRESET_AUXRESET	(0x02)
-#define REGRESET_SCSIRESET	(0x01)
-
-#define REGINT_SETRESET		(0x80)
-#define REGINT_ENABLEIPL	(0x02)
-#define REGINT_INTMASTER	(0x01)
-
-#define IPLEMU_SETRESET		(0x80)
-#define IPLEMU_DISABLEINT	(0x40)
-#define IPLEMU_IPL2		(0x20)
-#define IPLEMU_IPL1		(0x10)
-#define IPLEMU_IPL0		(0x08)
-#define IPLEMU_PPCIPL2		(0x04)
-#define IPLEMU_PPCIPL1		(0x02)
-#define IPLEMU_PPCIPL0		(0x01)
-#define IPLEMU_IPLMASK		(IPLEMU_PPCIPL2|IPLEMU_PPCIPL1|IPLEMU_PPCIPL0)
-
-#define INTLVL_SETRESET         (0x80)
-#define INTLVL_MASK             (0x7f)
-
-#endif /* _M68k_AMIGAPPC_H */
-#endif /* __KERNEL__ */

--- linux-2.6/arch/ppc/amiga/config.c	2006-06-30 19:23:06.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,953 +0,0 @@
-#define m68k_debug_device debug_device
-
-/*
- *  Copyright (C) 1993 Hamish Macdonald
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-/*
- * Miscellaneous Amiga stuff
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/kd.h>
-#include <linux/tty.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#ifdef CONFIG_ZORRO
-#include <linux/zorro.h>
-#endif
-
-#include <asm/bootinfo.h>
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/pgtable.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/irq.h>
-#include <asm/machdep.h>
-#include <asm/io.h>
-
-unsigned long powerup_PCI_present;
-unsigned long powerup_BPPCPLUS_present;
-unsigned long amiga_model;
-unsigned long amiga_eclock;
-unsigned long amiga_masterclock;
-unsigned long amiga_colorclock;
-unsigned long amiga_chipset;
-unsigned char amiga_vblank;
-unsigned char amiga_psfreq;
-struct amiga_hw_present amiga_hw_present;
-
-static char s_a500[] __initdata = "A500";
-static char s_a500p[] __initdata = "A500+";
-static char s_a600[] __initdata = "A600";
-static char s_a1000[] __initdata = "A1000";
-static char s_a1200[] __initdata = "A1200";
-static char s_a2000[] __initdata = "A2000";
-static char s_a2500[] __initdata = "A2500";
-static char s_a3000[] __initdata = "A3000";
-static char s_a3000t[] __initdata = "A3000T";
-static char s_a3000p[] __initdata = "A3000+";
-static char s_a4000[] __initdata = "A4000";
-static char s_a4000t[] __initdata = "A4000T";
-static char s_cdtv[] __initdata = "CDTV";
-static char s_cd32[] __initdata = "CD32";
-static char s_draco[] __initdata = "Draco";
-static char *amiga_models[] __initdata = {
-    s_a500, s_a500p, s_a600, s_a1000, s_a1200, s_a2000, s_a2500, s_a3000,
-    s_a3000t, s_a3000p, s_a4000, s_a4000t, s_cdtv, s_cd32, s_draco,
-};
-
-static char amiga_model_name[13] = "Amiga ";
-
-extern char m68k_debug_device[];
-
-static void amiga_sched_init(irqreturn_t (*handler)(int, void *, struct pt_regs *));
-/* amiga specific irq functions */
-extern void amiga_init_IRQ (void);
-extern void (*amiga_default_handler[]) (int, void *, struct pt_regs *);
-extern int amiga_request_irq (unsigned int irq,
-			      void (*handler)(int, void *, struct pt_regs *),
-                              unsigned long flags, const char *devname,
-			      void *dev_id);
-extern void amiga_free_irq (unsigned int irq, void *dev_id);
-extern void amiga_enable_irq (unsigned int);
-extern void amiga_disable_irq (unsigned int);
-static void amiga_get_model(char *model);
-static int amiga_get_hardware_list(char *buffer);
-/* amiga specific timer functions */
-static unsigned long amiga_gettimeoffset (void);
-static void a3000_gettod (int *, int *, int *, int *, int *, int *);
-static void a2000_gettod (int *, int *, int *, int *, int *, int *);
-static int amiga_hwclk (int, struct hwclk_time *);
-static int amiga_set_clock_mmss (unsigned long);
-static void amiga_reset (void);
-extern void amiga_init_sound(void);
-static void amiga_savekmsg_init(void);
-static void amiga_mem_console_write(struct console *co, const char *b,
-				    unsigned int count);
-void amiga_serial_console_write(struct console *co, const char *s,
-				unsigned int count);
-static void amiga_debug_init(void);
-#ifdef CONFIG_HEARTBEAT
-static void amiga_heartbeat(int on);
-#endif
-
-static struct console amiga_console_driver = {
-	.name =		"debug",
-	.flags =	CON_PRINTBUFFER,
-	.index =	-1,
-};
-
-
-    /*
-     *  Motherboard Resources present in all Amiga models
-     */
-
-static struct {
-    struct resource _ciab, _ciaa, _custom, _kickstart;
-} mb_resources = {
-//    { "Ranger Memory", 0x00c00000, 0x00c7ffff },
-    ._ciab =	  { "CIA B", 0x00bfd000, 0x00bfdfff },
-    ._ciaa =	  { "CIA A", 0x00bfe000, 0x00bfefff },
-    ._custom =	  { "Custom I/O", 0x00dff000, 0x00dfffff },
-    ._kickstart = { "Kickstart ROM", 0x00f80000, 0x00ffffff }
-};
-
-static struct resource rtc_resource = {
-    NULL, 0x00dc0000, 0x00dcffff
-};
-
-static struct resource ram_resource[NUM_MEMINFO];
-
-
-    /*
-     *  Parse an Amiga-specific record in the bootinfo
-     */
-
-int amiga_parse_bootinfo(const struct bi_record *record)
-{
-    int unknown = 0;
-    const unsigned long *data = record->data;
-
-    switch (record->tag) {
-	case BI_AMIGA_MODEL:
-	{
-		unsigned long d = *data;
-
-		powerup_PCI_present = d & 0x100;
-		amiga_model = d & 0xff;
-	}
-	break;
-
-	case BI_AMIGA_ECLOCK:
-	    amiga_eclock = *data;
-	    break;
-
-	case BI_AMIGA_CHIPSET:
-	    amiga_chipset = *data;
-	    break;
-
-	case BI_AMIGA_CHIP_SIZE:
-	    amiga_chip_size = *(const int *)data;
-	    break;
-
-	case BI_AMIGA_VBLANK:
-	    amiga_vblank = *(const unsigned char *)data;
-	    break;
-
-	case BI_AMIGA_PSFREQ:
-	    amiga_psfreq = *(const unsigned char *)data;
-	    break;
-
-	case BI_AMIGA_AUTOCON:
-#ifdef CONFIG_ZORRO
-	    if (zorro_num_autocon < ZORRO_NUM_AUTO) {
-		const struct ConfigDev *cd = (struct ConfigDev *)data;
-		struct zorro_dev *dev = &zorro_autocon[zorro_num_autocon++];
-		dev->rom = cd->cd_Rom;
-		dev->slotaddr = cd->cd_SlotAddr;
-		dev->slotsize = cd->cd_SlotSize;
-		dev->resource.start = (unsigned long)cd->cd_BoardAddr;
-		dev->resource.end = dev->resource.start+cd->cd_BoardSize-1;
-	    } else
-		printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
-#endif /* CONFIG_ZORRO */
-	    break;
-
-	case BI_AMIGA_SERPER:
-	    /* serial port period: ignored here */
-	    break;
-
-	case BI_AMIGA_PUP_BRIDGE:
-	    powerup_PCI_present = *(const unsigned short *)data;
-	    break;
-
-	case BI_AMIGA_BPPC_SCSI:
-	    powerup_BPPCPLUS_present = *(const unsigned short *)data;
-	    break;
-
-	default:
-	    unknown = 1;
-    }
-    return(unknown);
-}
-
-    /*
-     *  Identify builtin hardware
-     */
-
-static void __init amiga_identify(void)
-{
-  /* Fill in some default values, if necessary */
-  if (amiga_eclock == 0)
-    amiga_eclock = 709379;
-
-  memset(&amiga_hw_present, 0, sizeof(amiga_hw_present));
-
-  printk("Amiga hardware found: ");
-  if (amiga_model >= AMI_500 && amiga_model <= AMI_DRACO) {
-    printk("[%s] ", amiga_models[amiga_model-AMI_500]);
-    strcat(amiga_model_name, amiga_models[amiga_model-AMI_500]);
-  }
-
-  switch(amiga_model) {
-  case AMI_UNKNOWN:
-    goto Generic;
-
-  case AMI_600:
-  case AMI_1200:
-    AMIGAHW_SET(A1200_IDE);
-    AMIGAHW_SET(PCMCIA);
-  case AMI_500:
-  case AMI_500PLUS:
-  case AMI_1000:
-  case AMI_2000:
-  case AMI_2500:
-    AMIGAHW_SET(A2000_CLK);	/* Is this correct for all models? */
-    goto Generic;
-
-  case AMI_3000:
-  case AMI_3000T:
-    AMIGAHW_SET(AMBER_FF);
-    AMIGAHW_SET(MAGIC_REKICK);
-    /* fall through */
-  case AMI_3000PLUS:
-    AMIGAHW_SET(A3000_SCSI);
-    AMIGAHW_SET(A3000_CLK);
-    AMIGAHW_SET(ZORRO3);
-    goto Generic;
-
-  case AMI_4000T:
-    AMIGAHW_SET(A4000_SCSI);
-    /* fall through */
-  case AMI_4000:
-    AMIGAHW_SET(A4000_IDE);
-    AMIGAHW_SET(A3000_CLK);
-    AMIGAHW_SET(ZORRO3);
-    goto Generic;
-
-  case AMI_CDTV:
-  case AMI_CD32:
-    AMIGAHW_SET(CD_ROM);
-    AMIGAHW_SET(A2000_CLK);             /* Is this correct? */
-    goto Generic;
-
-  Generic:
-    AMIGAHW_SET(AMI_VIDEO);
-    AMIGAHW_SET(AMI_BLITTER);
-    AMIGAHW_SET(AMI_AUDIO);
-    AMIGAHW_SET(AMI_FLOPPY);
-    AMIGAHW_SET(AMI_KEYBOARD);
-    AMIGAHW_SET(AMI_MOUSE);
-    AMIGAHW_SET(AMI_SERIAL);
-    AMIGAHW_SET(AMI_PARALLEL);
-    AMIGAHW_SET(CHIP_RAM);
-    AMIGAHW_SET(PAULA);
-
-    switch(amiga_chipset) {
-    case CS_OCS:
-    case CS_ECS:
-    case CS_AGA:
-      switch (amiga_custom.deniseid & 0xf) {
-      case 0x0c:
-	AMIGAHW_SET(DENISE_HR);
-	break;
-      case 0x08:
-	AMIGAHW_SET(LISA);
-	break;
-      }
-      break;
-    default:
-      AMIGAHW_SET(DENISE);
-      break;
-    }
-    switch ((amiga_custom.vposr>>8) & 0x7f) {
-    case 0x00:
-      AMIGAHW_SET(AGNUS_PAL);
-      break;
-    case 0x10:
-      AMIGAHW_SET(AGNUS_NTSC);
-      break;
-    case 0x20:
-    case 0x21:
-      AMIGAHW_SET(AGNUS_HR_PAL);
-      break;
-    case 0x30:
-    case 0x31:
-      AMIGAHW_SET(AGNUS_HR_NTSC);
-      break;
-    case 0x22:
-    case 0x23:
-      AMIGAHW_SET(ALICE_PAL);
-      break;
-    case 0x32:
-    case 0x33:
-      AMIGAHW_SET(ALICE_NTSC);
-      break;
-    }
-    AMIGAHW_SET(ZORRO);
-    break;
-
-  case AMI_DRACO:
-    panic("No support for Draco yet");
-
-  default:
-    panic("Unknown Amiga Model");
-  }
-
-#define AMIGAHW_ANNOUNCE(name, str)			\
-  if (AMIGAHW_PRESENT(name))				\
-    printk(str)
-
-  AMIGAHW_ANNOUNCE(AMI_VIDEO, "VIDEO ");
-  AMIGAHW_ANNOUNCE(AMI_BLITTER, "BLITTER ");
-  AMIGAHW_ANNOUNCE(AMBER_FF, "AMBER_FF ");
-  AMIGAHW_ANNOUNCE(AMI_AUDIO, "AUDIO ");
-  AMIGAHW_ANNOUNCE(AMI_FLOPPY, "FLOPPY ");
-  AMIGAHW_ANNOUNCE(A3000_SCSI, "A3000_SCSI ");
-  AMIGAHW_ANNOUNCE(A4000_SCSI, "A4000_SCSI ");
-  AMIGAHW_ANNOUNCE(A1200_IDE, "A1200_IDE ");
-  AMIGAHW_ANNOUNCE(A4000_IDE, "A4000_IDE ");
-  AMIGAHW_ANNOUNCE(CD_ROM, "CD_ROM ");
-  AMIGAHW_ANNOUNCE(AMI_KEYBOARD, "KEYBOARD ");
-  AMIGAHW_ANNOUNCE(AMI_MOUSE, "MOUSE ");
-  AMIGAHW_ANNOUNCE(AMI_SERIAL, "SERIAL ");
-  AMIGAHW_ANNOUNCE(AMI_PARALLEL, "PARALLEL ");
-  AMIGAHW_ANNOUNCE(A2000_CLK, "A2000_CLK ");
-  AMIGAHW_ANNOUNCE(A3000_CLK, "A3000_CLK ");
-  AMIGAHW_ANNOUNCE(CHIP_RAM, "CHIP_RAM ");
-  AMIGAHW_ANNOUNCE(PAULA, "PAULA ");
-  AMIGAHW_ANNOUNCE(DENISE, "DENISE ");
-  AMIGAHW_ANNOUNCE(DENISE_HR, "DENISE_HR ");
-  AMIGAHW_ANNOUNCE(LISA, "LISA ");
-  AMIGAHW_ANNOUNCE(AGNUS_PAL, "AGNUS_PAL ");
-  AMIGAHW_ANNOUNCE(AGNUS_NTSC, "AGNUS_NTSC ");
-  AMIGAHW_ANNOUNCE(AGNUS_HR_PAL, "AGNUS_HR_PAL ");
-  AMIGAHW_ANNOUNCE(AGNUS_HR_NTSC, "AGNUS_HR_NTSC ");
-  AMIGAHW_ANNOUNCE(ALICE_PAL, "ALICE_PAL ");
-  AMIGAHW_ANNOUNCE(ALICE_NTSC, "ALICE_NTSC ");
-  AMIGAHW_ANNOUNCE(MAGIC_REKICK, "MAGIC_REKICK ");
-  AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA ");
-  if (AMIGAHW_PRESENT(ZORRO))
-    printk("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");
-  printk("\n");
-
-#undef AMIGAHW_ANNOUNCE
-}
-
-    /*
-     *  Setup the Amiga configuration info
-     */
-
-void __init config_amiga(void)
-{
-  int i;
-
-  amiga_debug_init();
-  amiga_identify();
-
-  /* Some APUS boxes may have PCI memory, but ... */
-  iomem_resource.name = "Memory";
-  for (i = 0; i < 4; i++)
-    request_resource(&iomem_resource, &((struct resource *)&mb_resources)[i]);
-
-  mach_sched_init      = amiga_sched_init;
-  mach_init_IRQ        = amiga_init_IRQ;
-#ifndef CONFIG_APUS
-  mach_default_handler = &amiga_default_handler;
-  mach_request_irq     = amiga_request_irq;
-  mach_free_irq        = amiga_free_irq;
-  enable_irq           = amiga_enable_irq;
-  disable_irq          = amiga_disable_irq;
-#endif
-  mach_get_model       = amiga_get_model;
-  mach_get_hardware_list = amiga_get_hardware_list;
-  mach_gettimeoffset   = amiga_gettimeoffset;
-  if (AMIGAHW_PRESENT(A3000_CLK)){
-    mach_gettod  = a3000_gettod;
-    rtc_resource.name = "A3000 RTC";
-    request_resource(&iomem_resource, &rtc_resource);
-  }
-  else{ /* if (AMIGAHW_PRESENT(A2000_CLK)) */
-    mach_gettod  = a2000_gettod;
-    rtc_resource.name = "A2000 RTC";
-    request_resource(&iomem_resource, &rtc_resource);
-  }
-
-  mach_max_dma_address = 0xffffffff; /*
-				      * default MAX_DMA=0xffffffff
-				      * on all machines. If we don't
-				      * do so, the SCSI code will not
-				      * be able to allocate any mem
-				      * for transfers, unless we are
-				      * dealing with a Z2 mem only
-				      * system.                  /Jes
-				      */
-
-  mach_hwclk           = amiga_hwclk;
-  mach_set_clock_mmss  = amiga_set_clock_mmss;
-  mach_reset           = amiga_reset;
-#ifdef CONFIG_HEARTBEAT
-  mach_heartbeat = amiga_heartbeat;
-#endif
-
-  /* Fill in the clock values (based on the 700 kHz E-Clock) */
-  amiga_masterclock = 40*amiga_eclock;	/* 28 MHz */
-  amiga_colorclock = 5*amiga_eclock;	/* 3.5 MHz */
-
-  /* clear all DMA bits */
-  amiga_custom.dmacon = DMAF_ALL;
-  /* ensure that the DMA master bit is set */
-  amiga_custom.dmacon = DMAF_SETCLR | DMAF_MASTER;
-
-  /* request all RAM */
-  for (i = 0; i < m68k_num_memory; i++) {
-    ram_resource[i].name =
-      (m68k_memory[i].addr >= 0x01000000) ? "32-bit Fast RAM" :
-      (m68k_memory[i].addr < 0x00c00000) ? "16-bit Fast RAM" :
-      "16-bit Slow RAM";
-    ram_resource[i].start = m68k_memory[i].addr;
-    ram_resource[i].end = m68k_memory[i].addr+m68k_memory[i].size-1;
-    request_resource(&iomem_resource, &ram_resource[i]);
-  }
-
-  /* initialize chipram allocator */
-  amiga_chip_init ();
-
-  /* debugging using chipram */
-  if (!strcmp( m68k_debug_device, "mem" )){
-	  if (!AMIGAHW_PRESENT(CHIP_RAM))
-		  printk("Warning: no chipram present for debugging\n");
-	  else {
-		  amiga_savekmsg_init();
-		  amiga_console_driver.write = amiga_mem_console_write;
-		  register_console(&amiga_console_driver);
-	  }
-  }
-
-  /* our beloved beeper */
-  if (AMIGAHW_PRESENT(AMI_AUDIO))
-	  amiga_init_sound();
-
-  /*
-   * if it is an A3000, set the magic bit that forces
-   * a hard rekick
-   */
-  if (AMIGAHW_PRESENT(MAGIC_REKICK))
-	  *(unsigned char *)ZTWO_VADDR(0xde0002) |= 0x80;
-}
-
-static unsigned short jiffy_ticks;
-
-static void __init amiga_sched_init(irqreturn_t (*timer_routine)(int, void *,
-						struct pt_regs *))
-{
-	static struct resource sched_res = {
-	    "timer", 0x00bfd400, 0x00bfd5ff,
-	};
-	jiffy_ticks = (amiga_eclock+HZ/2)/HZ;
-
-	if (request_resource(&mb_resources._ciab, &sched_res))
-	    printk("Cannot allocate ciab.ta{lo,hi}\n");
-	ciab.cra &= 0xC0;   /* turn off timer A, continuous mode, from Eclk */
-	ciab.talo = jiffy_ticks % 256;
-	ciab.tahi = jiffy_ticks / 256;
-
-	/* install interrupt service routine for CIAB Timer A
-	 *
-	 * Please don't change this to use ciaa, as it interferes with the
-	 * SCSI code. We'll have to take a look at this later
-	 */
-	request_irq(IRQ_AMIGA_CIAB_TA, timer_routine, 0, "timer", NULL);
-	/* start timer */
-	ciab.cra |= 0x11;
-}
-
-#define TICK_SIZE 10000
-
-extern unsigned char cia_get_irq_mask(unsigned int irq);
-
-/* This is always executed with interrupts disabled.  */
-static unsigned long amiga_gettimeoffset (void)
-{
-	unsigned short hi, lo, hi2;
-	unsigned long ticks, offset = 0;
-
-	/* read CIA B timer A current value */
-	hi  = ciab.tahi;
-	lo  = ciab.talo;
-	hi2 = ciab.tahi;
-
-	if (hi != hi2) {
-		lo = ciab.talo;
-		hi = hi2;
-	}
-
-	ticks = hi << 8 | lo;
-
-	if (ticks > jiffy_ticks / 2)
-		/* check for pending interrupt */
-		if (cia_get_irq_mask(IRQ_AMIGA_CIAB) & CIA_ICR_TA)
-			offset = 10000;
-
-	ticks = jiffy_ticks - ticks;
-	ticks = (10000 * ticks) / jiffy_ticks;
-
-	return ticks + offset;
-}
-
-static void a3000_gettod (int *yearp, int *monp, int *dayp,
-			  int *hourp, int *minp, int *secp)
-{
-	volatile struct tod3000 *tod = TOD_3000;
-
-	tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-	*secp  = tod->second1 * 10 + tod->second2;
-	*minp  = tod->minute1 * 10 + tod->minute2;
-	*hourp = tod->hour1   * 10 + tod->hour2;
-	*dayp  = tod->day1    * 10 + tod->day2;
-	*monp  = tod->month1  * 10 + tod->month2;
-	*yearp = tod->year1   * 10 + tod->year2;
-
-	tod->cntrl1 = TOD3000_CNTRL1_FREE;
-}
-
-static void a2000_gettod (int *yearp, int *monp, int *dayp,
-			  int *hourp, int *minp, int *secp)
-{
-	volatile struct tod2000 *tod = TOD_2000;
-
-	tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-
-	while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-		;
-
-	*secp  = tod->second1     * 10 + tod->second2;
-	*minp  = tod->minute1     * 10 + tod->minute2;
-	*hourp = (tod->hour1 & 3) * 10 + tod->hour2;
-	*dayp  = tod->day1        * 10 + tod->day2;
-	*monp  = tod->month1      * 10 + tod->month2;
-	*yearp = tod->year1       * 10 + tod->year2;
-
-	if (!(tod->cntrl3 & TOD2000_CNTRL3_24HMODE)){
-		if (!(tod->hour1 & TOD2000_HOUR1_PM) && *hourp == 12)
-			*hourp = 0;
-		else if ((tod->hour1 & TOD2000_HOUR1_PM) && *hourp != 12)
-			*hourp += 12;
-	}
-
-	tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-}
-
-static int amiga_hwclk(int op, struct hwclk_time *t)
-{
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		volatile struct tod3000 *tod = TOD_3000;
-
-		tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-		if (!op) { /* read */
-			t->sec  = tod->second1 * 10 + tod->second2;
-			t->min  = tod->minute1 * 10 + tod->minute2;
-			t->hour = tod->hour1   * 10 + tod->hour2;
-			t->day  = tod->day1    * 10 + tod->day2;
-			t->wday = tod->weekday;
-			t->mon  = tod->month1  * 10 + tod->month2 - 1;
-			t->year = tod->year1   * 10 + tod->year2;
-			if (t->year <= 69)
-				t->year += 100;
-		} else {
-			tod->second1 = t->sec / 10;
-			tod->second2 = t->sec % 10;
-			tod->minute1 = t->min / 10;
-			tod->minute2 = t->min % 10;
-			tod->hour1   = t->hour / 10;
-			tod->hour2   = t->hour % 10;
-			tod->day1    = t->day / 10;
-			tod->day2    = t->day % 10;
-			if (t->wday != -1)
-				tod->weekday = t->wday;
-			tod->month1  = (t->mon + 1) / 10;
-			tod->month2  = (t->mon + 1) % 10;
-			if (t->year >= 100)
-				t->year -= 100;
-			tod->year1   = t->year / 10;
-			tod->year2   = t->year % 10;
-		}
-
-		tod->cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		volatile struct tod2000 *tod = TOD_2000;
-
-		tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-	
-		while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-			;
-
-		if (!op) { /* read */
-			t->sec  = tod->second1     * 10 + tod->second2;
-			t->min  = tod->minute1     * 10 + tod->minute2;
-			t->hour = (tod->hour1 & 3) * 10 + tod->hour2;
-			t->day  = tod->day1        * 10 + tod->day2;
-			t->wday = tod->weekday;
-			t->mon  = tod->month1      * 10 + tod->month2 - 1;
-			t->year = tod->year1       * 10 + tod->year2;
-			if (t->year <= 69)
-				t->year += 100;
-
-			if (!(tod->cntrl3 & TOD2000_CNTRL3_24HMODE)){
-				if (!(tod->hour1 & TOD2000_HOUR1_PM) && t->hour == 12)
-					t->hour = 0;
-				else if ((tod->hour1 & TOD2000_HOUR1_PM) && t->hour != 12)
-					t->hour += 12;
-			}
-		} else {
-			tod->second1 = t->sec / 10;
-			tod->second2 = t->sec % 10;
-			tod->minute1 = t->min / 10;
-			tod->minute2 = t->min % 10;
-			if (tod->cntrl3 & TOD2000_CNTRL3_24HMODE)
-				tod->hour1 = t->hour / 10;
-			else if (t->hour >= 12)
-				tod->hour1 = TOD2000_HOUR1_PM +
-					(t->hour - 12) / 10;
-			else
-				tod->hour1 = t->hour / 10;
-			tod->hour2   = t->hour % 10;
-			tod->day1    = t->day / 10;
-			tod->day2    = t->day % 10;
-			if (t->wday != -1)
-				tod->weekday = t->wday;
-			tod->month1  = (t->mon + 1) / 10;
-			tod->month2  = (t->mon + 1) % 10;
-			if (t->year >= 100)
-				t->year -= 100;
-			tod->year1   = t->year / 10;
-			tod->year2   = t->year % 10;
-		}
-
-		tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-	}
-
-	return 0;
-}
-
-static int amiga_set_clock_mmss (unsigned long nowtime)
-{
-	short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
-
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		volatile struct tod3000 *tod = TOD_3000;
-
-		tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-		tod->second1 = real_seconds / 10;
-		tod->second2 = real_seconds % 10;
-		tod->minute1 = real_minutes / 10;
-		tod->minute2 = real_minutes % 10;
-
-		tod->cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		volatile struct tod2000 *tod = TOD_2000;
-
-		tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-	
-		while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-			;
-
-		tod->second1 = real_seconds / 10;
-		tod->second2 = real_seconds % 10;
-		tod->minute1 = real_minutes / 10;
-		tod->minute2 = real_minutes % 10;
-
-		tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-	}
-
-	return 0;
-}
-
-static NORET_TYPE void amiga_reset( void )
-    ATTRIB_NORET;
-
-static void amiga_reset (void)
-{
-  for (;;);
-}
-
-
-    /*
-     *  Debugging
-     */
-
-#define SAVEKMSG_MAXMEM		128*1024
-
-#define SAVEKMSG_MAGIC1		0x53415645	/* 'SAVE' */
-#define SAVEKMSG_MAGIC2		0x4B4D5347	/* 'KMSG' */
-
-struct savekmsg {
-    unsigned long magic1;		/* SAVEKMSG_MAGIC1 */
-    unsigned long magic2;		/* SAVEKMSG_MAGIC2 */
-    unsigned long magicptr;		/* address of magic1 */
-    unsigned long size;
-    char data[0];
-};
-
-static struct savekmsg *savekmsg = NULL;
-
-static void amiga_mem_console_write(struct console *co, const char *s,
-				    unsigned int count)
-{
-    if (savekmsg->size+count <= SAVEKMSG_MAXMEM-sizeof(struct savekmsg)) {
-        memcpy(savekmsg->data+savekmsg->size, s, count);
-        savekmsg->size += count;
-    }
-}
-
-static void amiga_savekmsg_init(void)
-{
-    static struct resource debug_res = { "Debug" };
-
-    savekmsg = amiga_chip_alloc_res(SAVEKMSG_MAXMEM, &debug_res);
-    savekmsg->magic1 = SAVEKMSG_MAGIC1;
-    savekmsg->magic2 = SAVEKMSG_MAGIC2;
-    savekmsg->magicptr = virt_to_phys(savekmsg);
-    savekmsg->size = 0;
-}
-
-static void amiga_serial_putc(char c)
-{
-    amiga_custom.serdat = (unsigned char)c | 0x100;
-    mb();
-    while (!(amiga_custom.serdatr & 0x2000))
-       ;
-}
-
-void amiga_serial_console_write(struct console *co, const char *s,
-				       unsigned int count)
-{
-#if 0 /* def CONFIG_KGDB */
-	/* FIXME:APUS GDB doesn't seem to like O-packages before it is
-           properly connected with the target. */
-	__gdb_output_string (s, count);
-#else
-	while (count--) {
-		if (*s == '\n')
-			amiga_serial_putc('\r');
-		amiga_serial_putc(*s++);
-	}
-#endif
-}
-
-#ifdef CONFIG_SERIAL_CONSOLE
-void amiga_serial_puts(const char *s)
-{
-    amiga_serial_console_write(NULL, s, strlen(s));
-}
-
-int amiga_serial_console_wait_key(struct console *co)
-{
-    int ch;
-
-    while (!(amiga_custom.intreqr & IF_RBF))
-	barrier();
-    ch = amiga_custom.serdatr & 0xff;
-    /* clear the interrupt, so that another character can be read */
-    amiga_custom.intreq = IF_RBF;
-    return ch;
-}
-
-void amiga_serial_gets(struct console *co, char *s, int len)
-{
-    int ch, cnt = 0;
-
-    while (1) {
-	ch = amiga_serial_console_wait_key(co);
-
-	/* Check for backspace. */
-	if (ch == 8 || ch == 127) {
-	    if (cnt == 0) {
-		amiga_serial_putc('\007');
-		continue;
-	    }
-	    cnt--;
-	    amiga_serial_puts("\010 \010");
-	    continue;
-	}
-
-	/* Check for enter. */
-	if (ch == 10 || ch == 13)
-	    break;
-
-	/* See if line is too long. */
-	if (cnt >= len + 1) {
-	    amiga_serial_putc(7);
-	    cnt--;
-	    continue;
-	}
-
-	/* Store and echo character. */
-	s[cnt++] = ch;
-	amiga_serial_putc(ch);
-    }
-    /* Print enter. */
-    amiga_serial_puts("\r\n");
-    s[cnt] = 0;
-}
-#endif
-
-static void __init amiga_debug_init(void)
-{
-	if (!strcmp( m68k_debug_device, "ser" )) {
-		/* no initialization required (?) */
-		amiga_console_driver.write = amiga_serial_console_write;
-		register_console(&amiga_console_driver);
-	}
-}
-
-#ifdef CONFIG_HEARTBEAT
-static void amiga_heartbeat(int on)
-{
-    if (on)
-	ciaa.pra &= ~2;
-    else
-	ciaa.pra |= 2;
-}
-#endif
-
-    /*
-     *  Amiga specific parts of /proc
-     */
-
-static void amiga_get_model(char *model)
-{
-    strcpy(model, amiga_model_name);
-}
-
-
-static int amiga_get_hardware_list(char *buffer)
-{
-    int len = 0;
-
-    if (AMIGAHW_PRESENT(CHIP_RAM))
-	len += sprintf(buffer+len, "Chip RAM:\t%ldK\n", amiga_chip_size>>10);
-    len += sprintf(buffer+len, "PS Freq:\t%dHz\nEClock Freq:\t%ldHz\n",
-		   amiga_psfreq, amiga_eclock);
-    if (AMIGAHW_PRESENT(AMI_VIDEO)) {
-	char *type;
-	switch(amiga_chipset) {
-	    case CS_OCS:
-		type = "OCS";
-		break;
-	    case CS_ECS:
-		type = "ECS";
-		break;
-	    case CS_AGA:
-		type = "AGA";
-		break;
-	    default:
-		type = "Old or Unknown";
-		break;
-	}
-	len += sprintf(buffer+len, "Graphics:\t%s\n", type);
-    }
-
-#define AMIGAHW_ANNOUNCE(name, str)			\
-    if (AMIGAHW_PRESENT(name))				\
-	len += sprintf (buffer+len, "\t%s\n", str)
-
-    len += sprintf (buffer + len, "Detected hardware:\n");
-
-    AMIGAHW_ANNOUNCE(AMI_VIDEO, "Amiga Video");
-    AMIGAHW_ANNOUNCE(AMI_BLITTER, "Blitter");
-    AMIGAHW_ANNOUNCE(AMBER_FF, "Amber Flicker Fixer");
-    AMIGAHW_ANNOUNCE(AMI_AUDIO, "Amiga Audio");
-    AMIGAHW_ANNOUNCE(AMI_FLOPPY, "Floppy Controller");
-    AMIGAHW_ANNOUNCE(A3000_SCSI, "SCSI Controller WD33C93 (A3000 style)");
-    AMIGAHW_ANNOUNCE(A4000_SCSI, "SCSI Controller NCR53C710 (A4000T style)");
-    AMIGAHW_ANNOUNCE(A1200_IDE, "IDE Interface (A1200 style)");
-    AMIGAHW_ANNOUNCE(A4000_IDE, "IDE Interface (A4000 style)");
-    AMIGAHW_ANNOUNCE(CD_ROM, "Internal CD ROM drive");
-    AMIGAHW_ANNOUNCE(AMI_KEYBOARD, "Keyboard");
-    AMIGAHW_ANNOUNCE(AMI_MOUSE, "Mouse Port");
-    AMIGAHW_ANNOUNCE(AMI_SERIAL, "Serial Port");
-    AMIGAHW_ANNOUNCE(AMI_PARALLEL, "Parallel Port");
-    AMIGAHW_ANNOUNCE(A2000_CLK, "Hardware Clock (A2000 style)");
-    AMIGAHW_ANNOUNCE(A3000_CLK, "Hardware Clock (A3000 style)");
-    AMIGAHW_ANNOUNCE(CHIP_RAM, "Chip RAM");
-    AMIGAHW_ANNOUNCE(PAULA, "Paula 8364");
-    AMIGAHW_ANNOUNCE(DENISE, "Denise 8362");
-    AMIGAHW_ANNOUNCE(DENISE_HR, "Denise 8373");
-    AMIGAHW_ANNOUNCE(LISA, "Lisa 8375");
-    AMIGAHW_ANNOUNCE(AGNUS_PAL, "Normal/Fat PAL Agnus 8367/8371");
-    AMIGAHW_ANNOUNCE(AGNUS_NTSC, "Normal/Fat NTSC Agnus 8361/8370");
-    AMIGAHW_ANNOUNCE(AGNUS_HR_PAL, "Fat Hires PAL Agnus 8372");
-    AMIGAHW_ANNOUNCE(AGNUS_HR_NTSC, "Fat Hires NTSC Agnus 8372");
-    AMIGAHW_ANNOUNCE(ALICE_PAL, "PAL Alice 8374");
-    AMIGAHW_ANNOUNCE(ALICE_NTSC, "NTSC Alice 8374");
-    AMIGAHW_ANNOUNCE(MAGIC_REKICK, "Magic Hard Rekick");
-    AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA Slot");
-    if (AMIGAHW_PRESENT(ZORRO))
-	len += sprintf(buffer+len, "\tZorro II%s AutoConfig: %d Expansion "
-				   "Device%s\n",
-		       AMIGAHW_PRESENT(ZORRO3) ? "I" : "",
-		       zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
-
-#undef AMIGAHW_ANNOUNCE
-
-    return(len);
-}
-
-#ifdef CONFIG_APUS
-int get_hardware_list(char *buffer)
-{
-	extern int get_cpuinfo(char *buffer);
-	int len = 0;
-	char model[80];
-	u_long mem;
-	int i;
-
-	if (mach_get_model)
-		mach_get_model(model);
-	else
-		strcpy(model, "Unknown PowerPC");
-
-	len += sprintf(buffer+len, "Model:\t\t%s\n", model);
-	len += get_cpuinfo(buffer+len);
-	for (mem = 0, i = 0; i < m68k_realnum_memory; i++)
-		mem += m68k_memory[i].size;
-	len += sprintf(buffer+len, "System Memory:\t%ldK\n", mem>>10);
-
-	if (mach_get_hardware_list)
-		len += mach_get_hardware_list(buffer+len);
-
-	return(len);
-}
-#endif
--- linux-2.6/arch/ppc/platforms/apus_setup.c	2006-10-11 04:56:59.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,798 +0,0 @@
-/*
- *  Copyright (C) 1998, 1999  Jesper Skov
- *
- *  Basically what is needed to replace functionality found in
- *  arch/m68k allowing Amiga drivers to work under APUS.
- *  Bits of code and/or ideas from arch/m68k and arch/ppc files.
- *
- * TODO:
- *  This file needs a *really* good cleanup. Restructure and optimize.
- *  Make sure it can be compiled for non-APUS configs. Begin to move
- *  Amiga specific stuff into mach/amiga.
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/initrd.h>
-#include <linux/seq_file.h>
-
-/* Needs INITSERIAL call in head.S! */
-#undef APUS_DEBUG
-
-#include <asm/bootinfo.h>
-#include <asm/setup.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amigappc.h>
-#include <asm/pgtable.h>
-#include <asm/dma.h>
-#include <asm/machdep.h>
-#include <asm/time.h>
-
-unsigned long m68k_machtype;
-char debug_device[6] = "";
-
-extern void amiga_init_IRQ(void);
-
-extern void apus_setup_pci_ptrs(void);
-
-void (*mach_sched_init) (void (*handler)(int, void *, struct pt_regs *)) __initdata = NULL;
-/* machine dependent irq functions */
-void (*mach_init_IRQ) (void) __initdata = NULL;
-void (*(*mach_default_handler)[]) (int, void *, struct pt_regs *) = NULL;
-void (*mach_get_model) (char *model) = NULL;
-int (*mach_get_hardware_list) (char *buffer) = NULL;
-int (*mach_get_irq_list) (struct seq_file *, void *) = NULL;
-void (*mach_process_int) (int, struct pt_regs *) = NULL;
-/* machine dependent timer functions */
-unsigned long (*mach_gettimeoffset) (void);
-void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
-int (*mach_hwclk) (int, struct hwclk_time*) = NULL;
-int (*mach_set_clock_mmss) (unsigned long) = NULL;
-void (*mach_reset)( void );
-long mach_max_dma_address = 0x00ffffff; /* default set to the lower 16MB */
-#ifdef CONFIG_HEARTBEAT
-void (*mach_heartbeat) (int) = NULL;
-extern void apus_heartbeat (void);
-#endif
-
-extern unsigned long amiga_model;
-extern unsigned decrementer_count;/* count value for 1e6/HZ microseconds */
-extern unsigned count_period_num; /* 1 decrementer count equals */
-extern unsigned count_period_den; /* count_period_num / count_period_den us */
-
-int num_memory = 0;
-struct mem_info memory[NUM_MEMINFO];/* memory description */
-/* FIXME: Duplicate memory data to avoid conflicts with m68k shared code. */
-int m68k_realnum_memory = 0;
-struct mem_info m68k_memory[NUM_MEMINFO];/* memory description */
-
-struct mem_info ramdisk;
-
-extern void config_amiga(void);
-
-static int __60nsram = 0;
-
-/* for cpuinfo */
-static int __bus_speed = 0;
-static int __speed_test_failed = 0;
-
-/********************************************** COMPILE PROTECTION */
-/* Provide some stubs that links to Amiga specific functions.
- * This allows CONFIG_APUS to be removed from generic PPC files while
- * preventing link errors for other PPC targets.
- */
-unsigned long apus_get_rtc_time(void)
-{
-#ifdef CONFIG_APUS
-	extern unsigned long m68k_get_rtc_time(void);
-
-	return m68k_get_rtc_time ();
-#else
-	return 0;
-#endif
-}
-
-int apus_set_rtc_time(unsigned long nowtime)
-{
-#ifdef CONFIG_APUS
-	extern int m68k_set_rtc_time(unsigned long nowtime);
-
-	return m68k_set_rtc_time (nowtime);
-#else
-	return 0;
-#endif
-}
-
-/*********************************************************** SETUP */
-/* From arch/m68k/kernel/setup.c. */
-void __init apus_setup_arch(void)
-{
-#ifdef CONFIG_APUS
-	extern char cmd_line[];
-	int i;
-	char *p, *q;
-
-	/* Let m68k-shared code know it should do the Amiga thing. */
-	m68k_machtype = MACH_AMIGA;
-
-	/* Parse the command line for arch-specific options.
-	 * For the m68k, this is currently only "debug=xxx" to enable printing
-	 * certain kernel messages to some machine-specific device.  */
-	for( p = cmd_line; p && *p; ) {
-	    i = 0;
-	    if (!strncmp( p, "debug=", 6 )) {
-		    strlcpy( debug_device, p+6, sizeof(debug_device) );
-		    if ((q = strchr( debug_device, ' ' ))) *q = 0;
-		    i = 1;
-	    } else if (!strncmp( p, "60nsram", 7 )) {
-		    APUS_WRITE (APUS_REG_WAITSTATE,
-				REGWAITSTATE_SETRESET
-				|REGWAITSTATE_PPCR
-				|REGWAITSTATE_PPCW);
-		    __60nsram = 1;
-		    i = 1;
-	    }
-
-	    if (i) {
-		/* option processed, delete it */
-		if ((q = strchr( p, ' ' )))
-		    strcpy( p, q+1 );
-		else
-		    *p = 0;
-	    } else {
-		if ((p = strchr( p, ' ' ))) ++p;
-	    }
-	}
-
-	config_amiga();
-
-#if 0 /* Enable for logging - also include logging.o in Makefile rule */
-	{
-#define LOG_SIZE 4096
-		void* base;
-
-		/* Throw away some memory - the P5 firmare stomps on top
-		 * of CHIP memory during bootup.
-		 */
-		amiga_chip_alloc(0x1000);
-
-		base = amiga_chip_alloc(LOG_SIZE+sizeof(klog_data_t));
-		LOG_INIT(base, base+sizeof(klog_data_t), LOG_SIZE);
-	}
-#endif
-#endif
-}
-
-int
-apus_show_cpuinfo(struct seq_file *m)
-{
-	extern int __map_without_bats;
-	extern unsigned long powerup_PCI_present;
-
-	seq_printf(m, "machine\t\t: Amiga\n");
-	seq_printf(m, "bus speed\t: %d%s", __bus_speed,
-		   (__speed_test_failed) ? " [failed]\n" : "\n");
-	seq_printf(m, "using BATs\t: %s\n",
-		   (__map_without_bats) ? "No" : "Yes");
-	seq_printf(m, "ram speed\t: %dns\n", (__60nsram) ? 60 : 70);
-	seq_printf(m, "PCI bridge\t: %s\n",
-		   (powerup_PCI_present) ? "Yes" : "No");
-	return 0;
-}
-
-static void get_current_tb(unsigned long long *time)
-{
-	__asm __volatile ("1:mftbu 4      \n\t"
-			  "  mftb  5      \n\t"
-			  "  mftbu 6      \n\t"
-			  "  cmpw  4,6    \n\t"
-			  "  bne   1b     \n\t"
-			  "  stw   4,0(%0)\n\t"
-			  "  stw   5,4(%0)\n\t"
-			  :
-			  : "r" (time)
-			  : "r4", "r5", "r6");
-}
-
-
-void apus_calibrate_decr(void)
-{
-#ifdef CONFIG_APUS
-	unsigned long freq;
-
-	/* This algorithm for determining the bus speed was
-           contributed by Ralph Schmidt. */
-	unsigned long long start, stop;
-	int bus_speed;
-	int speed_test_failed = 0;
-
-	{
-		unsigned long loop = amiga_eclock / 10;
-
-		get_current_tb (&start);
-		while (loop--) {
-			unsigned char tmp;
-
-			tmp = ciaa.pra;
-		}
-		get_current_tb (&stop);
-	}
-
-	bus_speed = (((unsigned long)(stop-start))*10*4) / 1000000;
-	if (AMI_1200 == amiga_model)
-		bus_speed /= 2;
-
-	if ((bus_speed >= 47) && (bus_speed < 53)) {
-		bus_speed = 50;
-		freq = 12500000;
-	} else if ((bus_speed >= 57) && (bus_speed < 63)) {
-		bus_speed = 60;
-		freq = 15000000;
-	} else if ((bus_speed >= 63) && (bus_speed < 69)) {
-		bus_speed = 67;
-		freq = 16666667;
-	} else {
-		printk ("APUS: Unable to determine bus speed (%d). "
-			"Defaulting to 50MHz", bus_speed);
-		bus_speed = 50;
-		freq = 12500000;
-		speed_test_failed = 1;
-	}
-
-	/* Ease diagnostics... */
-	{
-		extern int __map_without_bats;
-		extern unsigned long powerup_PCI_present;
-
-		printk ("APUS: BATs=%d, BUS=%dMHz",
-			(__map_without_bats) ? 0 : 1,
-			bus_speed);
-		if (speed_test_failed)
-			printk ("[FAILED - please report]");
-
-		printk (", RAM=%dns, PCI bridge=%d\n",
-			(__60nsram) ? 60 : 70,
-			(powerup_PCI_present) ? 1 : 0);
-
-		/* print a bit more if asked politely... */
-		if (!(ciaa.pra & 0x40)){
-			extern unsigned int bat_addrs[4][3];
-			int b;
-			for (b = 0; b < 4; ++b) {
-				printk ("APUS: BAT%d ", b);
-				printk ("%08x-%08x -> %08x\n",
-					bat_addrs[b][0],
-					bat_addrs[b][1],
-					bat_addrs[b][2]);
-			}
-		}
-
-	}
-
-        printk("time_init: decrementer frequency = %lu.%.6lu MHz\n",
-	       freq/1000000, freq%1000000);
-	tb_ticks_per_jiffy = freq / HZ;
-	tb_to_us = mulhwu_scale_factor(freq, 1000000);
-
-	__bus_speed = bus_speed;
-	__speed_test_failed = speed_test_failed;
-#endif
-}
-
-void arch_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-#ifdef CONFIG_APUS
-	if (mach_gettod)
-		mach_gettod(year, mon, day, hour, min, sec);
-	else
-		*year = *mon = *day = *hour = *min = *sec = 0;
-#endif
-}
-
-/* for "kbd-reset" cmdline param */
-__init
-void kbd_reset_setup(char *str, int *ints)
-{
-}
-
-/*********************************************************** MEMORY */
-#define KMAP_MAX 32
-unsigned long kmap_chunks[KMAP_MAX*3];
-int kmap_chunk_count = 0;
-
-/* From pgtable.h */
-static __inline__ pte_t *my_find_pte(struct mm_struct *mm,unsigned long va)
-{
-	pgd_t *dir = 0;
-	pmd_t *pmd = 0;
-	pte_t *pte = 0;
-
-	va &= PAGE_MASK;
-
-	dir = pgd_offset( mm, va );
-	if (dir)
-	{
-		pmd = pmd_offset(dir, va & PAGE_MASK);
-		if (pmd && pmd_present(*pmd))
-		{
-			pte = pte_offset(pmd, va);
-		}
-	}
-	return pte;
-}
-
-
-/* Again simulating an m68k/mm/kmap.c function. */
-void kernel_set_cachemode( unsigned long address, unsigned long size,
-			   unsigned int cmode )
-{
-	unsigned long mask, flags;
-
-	switch (cmode)
-	{
-	case IOMAP_FULL_CACHING:
-		mask = ~(_PAGE_NO_CACHE | _PAGE_GUARDED);
-		flags = 0;
-		break;
-	case IOMAP_NOCACHE_SER:
-		mask = ~0;
-		flags = (_PAGE_NO_CACHE | _PAGE_GUARDED);
-		break;
-	default:
-		panic ("kernel_set_cachemode() doesn't support mode %d\n",
-		       cmode);
-		break;
-	}
-
-	size /= PAGE_SIZE;
-	address &= PAGE_MASK;
-	while (size--)
-	{
-		pte_t *pte;
-
-		pte = my_find_pte(&init_mm, address);
-		if ( !pte )
-		{
-			printk("pte NULL in kernel_set_cachemode()\n");
-			return;
-		}
-
-                pte_val (*pte) &= mask;
-                pte_val (*pte) |= flags;
-                flush_tlb_page(find_vma(&init_mm,address),address);
-
-		address += PAGE_SIZE;
-	}
-}
-
-unsigned long mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-	if (paddr < 16*1024*1024)
-		ret = ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i = 0; i < kmap_chunk_count;){
-			unsigned long phys = kmap_chunks[i++];
-			unsigned long size = kmap_chunks[i++];
-			unsigned long virt = kmap_chunks[i++];
-			if (paddr >= phys
-			    && paddr < (phys + size)){
-				ret = virt + paddr - phys;
-				goto exit;
-			}
-		}
-
-		ret = (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=%lx\n", paddr, ret);
-#endif
-	return ret;
-}
-
-int mm_end_of_chunk (unsigned long addr, int len)
-{
-	if (memory[0].addr + memory[0].size == addr + len)
-		return 1;
-	return 0;
-}
-
-/*********************************************************** CACHE */
-
-#define L1_CACHE_BYTES 32
-#define MAX_CACHE_SIZE 8192
-void cache_push(__u32 addr, int length)
-{
-	addr = mm_ptov(addr);
-
-	if (MAX_CACHE_SIZE < length)
-		length = MAX_CACHE_SIZE;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       : : "r" (addr));
-		addr += L1_CACHE_BYTES;
-		length -= L1_CACHE_BYTES;
-	}
-	/* Also flush trailing block */
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       : : "r" (addr));
-}
-
-void cache_clear(__u32 addr, int length)
-{
-	if (MAX_CACHE_SIZE < length)
-		length = MAX_CACHE_SIZE;
-
-	addr = mm_ptov(addr);
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-
-	addr += L1_CACHE_BYTES;
-	length -= L1_CACHE_BYTES;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       "sync \n\t"
-		       "icbi 0,%0 \n\t"
-		       "isync \n\t"
-		       : : "r" (addr));
-		addr += L1_CACHE_BYTES;
-		length -= L1_CACHE_BYTES;
-	}
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-}
-
-/****************************************************** from setup.c */
-void
-apus_restart(char *cmd)
-{
-	local_irq_disable();
-
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK2);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK2|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_SHADOW, REGSHADOW_SELFRESET);
-	APUS_WRITE(APUS_REG_RESET, REGRESET_AMIGARESET);
-	for(;;);
-}
-
-void
-apus_power_off(void)
-{
-	for (;;);
-}
-
-void
-apus_halt(void)
-{
-   apus_restart(NULL);
-}
-
-/****************************************************** IRQ stuff */
-
-static unsigned char last_ipl[8];
-
-int apus_get_irq(void)
-{
-	unsigned char ipl_emu, mask;
-	unsigned int level;
-
-	APUS_READ(APUS_IPL_EMU, ipl_emu);
-	level = (ipl_emu >> 3) & IPLEMU_IPLMASK;
-	mask = IPLEMU_SETRESET|IPLEMU_DISABLEINT|level;
-	level ^= 7;
-
-	/* Save previous IPL value */
-	if (last_ipl[level])
-		return -2;
-	last_ipl[level] = ipl_emu;
-
-	/* Set to current IPL value */
-	APUS_WRITE(APUS_IPL_EMU, mask);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|level);
-
-
-#ifdef __INTERRUPT_DEBUG
-	printk("<%d:%d>", level, ~ipl_emu & IPLEMU_IPLMASK);
-#endif
-	return level + IRQ_AMIGA_AUTO;
-}
-
-void apus_end_irq(unsigned int irq)
-{
-	unsigned char ipl_emu;
-	unsigned int level = irq - IRQ_AMIGA_AUTO;
-#ifdef __INTERRUPT_DEBUG
-	printk("{%d}", ~last_ipl[level] & IPLEMU_IPLMASK);
-#endif
-	/* Restore IPL to the previous value */
-	ipl_emu = last_ipl[level] & IPLEMU_IPLMASK;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET|IPLEMU_DISABLEINT|ipl_emu);
-	last_ipl[level] = 0;
-	ipl_emu ^= 7;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|ipl_emu);
-}
-
-/****************************************************** debugging */
-
-/* some serial hardware definitions */
-#define SDR_OVRUN   (1<<15)
-#define SDR_RBF     (1<<14)
-#define SDR_TBE     (1<<13)
-#define SDR_TSRE    (1<<12)
-
-#define AC_SETCLR   (1<<15)
-#define AC_UARTBRK  (1<<11)
-
-#define SER_DTR     (1<<7)
-#define SER_RTS     (1<<6)
-#define SER_DCD     (1<<5)
-#define SER_CTS     (1<<4)
-#define SER_DSR     (1<<3)
-
-static __inline__ void ser_RTSon(void)
-{
-    ciab.pra &= ~SER_RTS; /* active low */
-}
-
-int __debug_ser_out( unsigned char c )
-{
-	amiga_custom.serdat = c | 0x100;
-	mb();
-	while (!(amiga_custom.serdatr & 0x2000))
-		barrier();
-	return 1;
-}
-
-unsigned char __debug_ser_in( void )
-{
-	unsigned char c;
-
-	/* XXX: is that ok?? derived from amiga_ser.c... */
-	while( !(amiga_custom.intreqr & IF_RBF) )
-		barrier();
-	c = amiga_custom.serdatr;
-	/* clear the interrupt, so that another character can be read */
-	amiga_custom.intreq = IF_RBF;
-	return c;
-}
-
-int __debug_serinit( void )
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	/* turn off Rx and Tx interrupts */
-	amiga_custom.intena = IF_RBF | IF_TBE;
-
-	/* clear any pending interrupt */
-	amiga_custom.intreq = IF_RBF | IF_TBE;
-
-	local_irq_restore(flags);
-
-	/*
-	 * set the appropriate directions for the modem control flags,
-	 * and clear RTS and DTR
-	 */
-	ciab.ddra |= (SER_DTR | SER_RTS);   /* outputs */
-	ciab.ddra &= ~(SER_DCD | SER_CTS | SER_DSR);  /* inputs */
-
-#ifdef CONFIG_KGDB
-	/* turn Rx interrupts on for GDB */
-	amiga_custom.intena = IF_SETCLR | IF_RBF;
-	ser_RTSon();
-#endif
-
-	return 0;
-}
-
-void __debug_print_hex(unsigned long x)
-{
-	int i;
-	char hexchars[] = "0123456789ABCDEF";
-
-	for (i = 0; i < 8; i++) {
-		__debug_ser_out(hexchars[(x >> 28) & 15]);
-		x <<= 4;
-	}
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-void __debug_print_string(char* s)
-{
-	unsigned char c;
-	while((c = *s++))
-		__debug_ser_out(c);
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-static void apus_progress(char *s, unsigned short value)
-{
-	__debug_print_string(s);
-}
-
-/****************************************************** init */
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-
-
-extern void amiga_enable_irq(unsigned int irq);
-extern void amiga_disable_irq(unsigned int irq);
-
-struct hw_interrupt_type amiga_sys_irqctrl = {
-	.typename = "Amiga IPL",
-	.end = apus_end_irq,
-};
-
-struct hw_interrupt_type amiga_irqctrl = {
-	.typename = "Amiga    ",
-	.enable = amiga_enable_irq,
-	.disable = amiga_disable_irq,
-};
-
-#define HARDWARE_MAPPED_SIZE (512*1024)
-unsigned long __init apus_find_end_of_memory(void)
-{
-	int shadow = 0;
-	unsigned long total;
-
-	/* The memory size reported by ADOS excludes the 512KB
-	   reserved for PPC exception registers and possibly 512KB
-	   containing a shadow of the ADOS ROM. */
-	{
-		unsigned long size = memory[0].size;
-
-		/* If 2MB aligned, size was probably user
-                   specified. We can't tell anything about shadowing
-                   in this case so skip shadow assignment. */
-		if (0 != (size & 0x1fffff)){
-			/* Align to 512KB to ensure correct handling
-			   of both memfile and system specified
-			   sizes. */
-			size = ((size+0x0007ffff) & 0xfff80000);
-			/* If memory is 1MB aligned, assume
-                           shadowing. */
-			shadow = !(size & 0x80000);
-		}
-
-		/* Add the chunk that ADOS does not see. by aligning
-                   the size to the nearest 2MB limit upwards.  */
-		memory[0].size = ((size+0x001fffff) & 0xffe00000);
-	}
-
-	ppc_memstart = memory[0].addr;
-	ppc_memoffset = PAGE_OFFSET - PPC_MEMSTART;
-	total = memory[0].size;
-
-	/* Remove the memory chunks that are controlled by special
-           Phase5 hardware. */
-
-	/* Remove the upper 512KB if it contains a shadow of
-	   the ADOS ROM. FIXME: It might be possible to
-	   disable this shadow HW. Check the booter
-	   (ppc_boot.c) */
-	if (shadow)
-		total -= HARDWARE_MAPPED_SIZE;
-
-	/* Remove the upper 512KB where the PPC exception
-	   vectors are mapped. */
-	total -= HARDWARE_MAPPED_SIZE;
-
-	/* Linux/APUS only handles one block of memory -- the one on
-	   the PowerUP board. Other system memory is horrible slow in
-	   comparison. The user can use other memory for swapping
-	   using the z2ram device. */
-	return total;
-}
-
-static void __init
-apus_map_io(void)
-{
-	/* Map PPC exception vectors. */
-	io_block_mapping(0xfff00000, 0xfff00000, 0x00020000, _PAGE_KERNEL);
-	/* Map chip and ZorroII memory */
-	io_block_mapping(zTwoBase,   0x00000000, 0x01000000, _PAGE_IO);
-}
-
-__init
-void apus_init_IRQ(void)
-{
-	struct irqaction *action;
-	int i;
-
-#ifdef CONFIG_PCI
-        apus_setup_pci_ptrs();
-#endif
-
-	for ( i = 0 ; i < AMI_IRQS; i++ ) {
-		irq_desc[i].status = IRQ_LEVEL;
-		if (i < IRQ_AMIGA_AUTO) {
-			irq_desc[i].chip = &amiga_irqctrl;
-		} else {
-			irq_desc[i].chip = &amiga_sys_irqctrl;
-			action = &amiga_sys_irqaction[i-IRQ_AMIGA_AUTO];
-			if (action->name)
-				setup_irq(i, action);
-		}
-	}
-
-	amiga_init_IRQ();
-
-}
-
-__init
-void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
-		   unsigned long r6, unsigned long r7)
-{
-	extern int parse_bootinfo(const struct bi_record *);
-	extern char _end[];
-
-	/* Parse bootinfo. The bootinfo is located right after
-           the kernel bss */
-	parse_bootinfo((const struct bi_record *)&_end);
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Take care of initrd if we have one. Use data from
-	   bootinfo to avoid the need to initialize PPC
-	   registers when kernel is booted via a PPC reset. */
-	if ( ramdisk.addr ) {
-		initrd_start = (unsigned long) __va(ramdisk.addr);
-		initrd_end = (unsigned long)
-			__va(ramdisk.size + ramdisk.addr);
-	}
-#endif /* CONFIG_BLK_DEV_INITRD */
-
-	ISA_DMA_THRESHOLD = 0x00ffffff;
-
-	ppc_md.setup_arch     = apus_setup_arch;
-	ppc_md.show_cpuinfo   = apus_show_cpuinfo;
-	ppc_md.init_IRQ       = apus_init_IRQ;
-	ppc_md.get_irq        = apus_get_irq;
-
-#ifdef CONFIG_HEARTBEAT
-	ppc_md.heartbeat      = apus_heartbeat;
-	ppc_md.heartbeat_count = 1;
-#endif
-#ifdef APUS_DEBUG
-	__debug_serinit();
-	ppc_md.progress       = apus_progress;
-#endif
-	ppc_md.init           = NULL;
-
-	ppc_md.restart        = apus_restart;
-	ppc_md.power_off      = apus_power_off;
-	ppc_md.halt           = apus_halt;
-
-	ppc_md.time_init      = NULL;
-	ppc_md.set_rtc_time   = apus_set_rtc_time;
-	ppc_md.get_rtc_time   = apus_get_rtc_time;
-	ppc_md.calibrate_decr = apus_calibrate_decr;
-
-	ppc_md.find_end_of_memory = apus_find_end_of_memory;
-	ppc_md.setup_io_mappings = apus_map_io;
-}
--- linux-2.6/arch/ppc/platforms/apus_pci.c	2007-07-25 23:27:44.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,207 +0,0 @@
-/*
- * Copyright (C) Michel D�nzer <michdaen@iiic.ethz.ch>
- *
- * APUS PCI routines.
- *
- * Currently, only B/CVisionPPC cards (Permedia2) are supported.
- *
- * Thanks to Geert Uytterhoeven for the idea:
- * Read values from given config space(s) for the first devices, -1 otherwise
- *
- */
-
-#ifdef CONFIG_AMIGA
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/pci-bridge.h>
-#include <asm/machdep.h>
-
-#include "apus_pci.h"
-
-
-/* These definitions are mostly adapted from pm2fb.c */
-
-#undef APUS_PCI_MASTER_DEBUG
-#ifdef APUS_PCI_MASTER_DEBUG
-#define DPRINTK(a,b...)	printk(KERN_DEBUG "apus_pci: %s: " a, __FUNCTION__ , ## b)
-#else
-#define DPRINTK(a,b...)
-#endif
-
-/*
- * The _DEFINITIVE_ memory mapping/unmapping functions.
- * This is due to the fact that they're changing soooo often...
- */
-#define DEFW()		wmb()
-#define DEFR()		rmb()
-#define DEFRW()		mb()
-
-#define DEVNO(d)	((d)>>3)
-#define FNNO(d)		((d)&7)
-
-
-extern unsigned long powerup_PCI_present;
-
-static struct pci_controller *apus_hose;
-
-
-void *pci_io_base(unsigned int bus)
-{
-	return 0;
-}
-
-
-int
-apus_pcibios_read_config(struct pci_bus *bus, int devfn, int offset,
-			 int len, u32 *val)
-{
-	int fnno = FNNO(devfn);
-	int devno = DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno != 1) {
-		*val = ~0;
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data = apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		*val = readb(cfg_data);
-		break;
-	case 2:
-		*val = readw(cfg_data);
-		break;
-	default:
-		*val = readl(cfg_data);
-		break;
-	}
-
-	DPRINTK("read b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, *val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-int
-apus_pcibios_write_config(struct pci_bus *bus, int devfn, int offset,
-			  int len, u32 *val)
-{
-	int fnno = FNNO(devfn);
-	int devno = DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno != 1) {
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data = apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		writeb(val, cfg_data); DEFW();
-		break;
-	case 2:
-		writew(val, cfg_data); DEFW();
-		break;
-	default:
-		writel(val, cfg_data); DEFW();
-		break;
-	}
-
-	DPRINTK("write b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static struct pci_ops apus_pci_ops = {
-	apus_pcibios_read_config,
-	apus_pcibios_write_config
-};
-
-static struct resource pci_mem = { "B/CVisionPPC PCI mem", CVPPC_FB_APERTURE_ONE, CVPPC_PCI_CONFIG, IORESOURCE_MEM };
-
-void __init
-apus_pcibios_fixup(void)
-{
-/*	struct pci_dev *dev = pci_find_slot(0, 1<<3);
-	unsigned int reg, val, offset;*/
-
-	/* FIXME: interrupt? */
-	/*dev->interrupt = xxx;*/
-
-        request_resource(&iomem_resource, &pci_mem);
-    	printk("%s: PCI mem resource requested\n", __FUNCTION__);
-}
-
-static void __init apus_pcibios_fixup_bus(struct pci_bus *bus)
-{
-        bus->resource[1] = &pci_mem;
-}
-
-
-/*
- * This is from pm2fb.c again
- *
- * Check if PCI (B/CVisionPPC) is available, initialize it and set up
- * the pcibios_* pointers
- */
-
-
-void __init
-apus_setup_pci_ptrs(void)
-{
-	if (!powerup_PCI_present) {
-		DPRINTK("no PCI bridge detected\n");
-		return;
-	}
-	DPRINTK("Phase5 B/CVisionPPC PCI bridge detected.\n");
-
-	apus_hose = pcibios_alloc_controller();
-	if (!apus_hose) {
-		printk("apus_pci: Can't allocate PCI controller structure\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_data = ioremap(CVPPC_PCI_CONFIG, 256))) {
-		printk("apus_pci: unable to map PCI config region\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_addr = ioremap(CSPPC_PCI_BRIDGE, 256))) {
-		printk("apus_pci: unable to map PCI bridge\n");
-		return;
-	}
-
-	writel(CSPPCF_BRIDGE_BIG_ENDIAN, apus_hose->cfg_addr + CSPPC_BRIDGE_ENDIAN);
-	DEFW();
-
-	writel(CVPPC_REGS_REGION,  apus_hose->cfg_data+ PCI_BASE_ADDRESS_0);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_ONE, apus_hose->cfg_data + PCI_BASE_ADDRESS_1);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_TWO, apus_hose->cfg_data + PCI_BASE_ADDRESS_2);
-	DEFW();
-	writel(CVPPC_ROM_ADDRESS, apus_hose->cfg_data + PCI_ROM_ADDRESS);
-	DEFW();
-
-	writel(0xef000000 | PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-		PCI_COMMAND_MASTER, apus_hose->cfg_data + PCI_COMMAND);
-	DEFW();
-
-	apus_hose->first_busno = 0;
-	apus_hose->last_busno = 0;
-	apus_hose->ops = &apus_pci_ops;
-	ppc_md.pcibios_fixup = apus_pcibios_fixup;
-	ppc_md.pcibios_fixup_bus = apus_pcibios_fixup_bus;
-
-	return;
-}
-
-#endif /* CONFIG_AMIGA */




--ikeVEW9yuYc//A+q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="patch-remove-apus.gz"
Content-Transfer-Encoding: base64

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
5xwNdkxSnRvEl7WTPAmJ7v8DHHPsI/wNAgA=

--ikeVEW9yuYc//A+q--
