Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKWJrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKWJrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXKWJrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:47:25 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:9486 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXKWJrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:47:10 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44106182:sNHT260485694"
Subject: [GIT PULL] Blackfin arch bug fixing and cleanup
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Analog Devices, Inc.
Date: Fri, 23 Nov 2007 17:46:54 +0800
Message-Id: <1195811214.24101.8.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 23 Nov 2007 09:47:03.0322 (UTC) FILETIME=[CD16E7A0:01C82DB5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This Blackfin GIT patch set is mostly consist of bug fixing from our
Blackfin kernel bug tracker and also some code cleanup. Although it
looks a little bigger, big change is a board defconfig file and related
things. At end of 2007, we are little busy in the Blackfin Linux code
freezing (mainly doing bug fixing), so I missed sending out GIT patch
for -rc3.

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |  314 +-----
 arch/blackfin/Kconfig.debug                       |  178 ++++
 arch/blackfin/Makefile                            |    2 +
 arch/blackfin/configs/BF527-EZKIT_defconfig       |   27 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |   41 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |   41 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |   83 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |   30 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |   49 +-
 arch/blackfin/configs/H8606_defconfig             | 1160 +++++++++++++++++++++
 arch/blackfin/configs/PNAV-10_defconfig           |   75 +-
 arch/blackfin/kernel/bfin_dma_5xx.c               |    1 +
 arch/blackfin/kernel/bfin_ksyms.c                 |    7 +-
 arch/blackfin/kernel/cplbinit.c                   |   73 +-
 arch/blackfin/kernel/early_printk.c               |    3 +-
 arch/blackfin/kernel/process.c                    |   66 --
 arch/blackfin/kernel/setup.c                      |    9 +-
 arch/blackfin/kernel/traps.c                      |  147 ++--
 arch/blackfin/lib/Makefile                        |    2 +-
 arch/blackfin/lib/ins.S                           |   19 +
 arch/blackfin/lib/strcmp.c                        |   11 +-
 arch/blackfin/lib/strcpy.c                        |   11 +-
 arch/blackfin/lib/strncmp.c                       |   11 +-
 arch/blackfin/lib/strncpy.c                       |   11 +-
 arch/blackfin/lib/udivdi3.S                       |  375 -------
 arch/blackfin/mach-bf527/Kconfig                  |    2 +
 arch/blackfin/mach-bf527/boards/Kconfig           |   12 +
 arch/blackfin/mach-bf527/boards/Makefile          |    6 +-
 arch/blackfin/mach-bf527/boards/eth_mac.c         |   50 -
 arch/blackfin/mach-bf527/boards/ezkit.c           |   37 +-
 arch/blackfin/mach-bf533/Kconfig                  |    2 +
 arch/blackfin/mach-bf533/boards/H8606.c           |   12 +-
 arch/blackfin/mach-bf533/boards/Kconfig           |   34 +
 arch/blackfin/mach-bf533/boards/Makefile          |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    4 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    4 +-
 arch/blackfin/mach-bf533/boards/generic_board.c   |    4 -
 arch/blackfin/mach-bf533/boards/stamp.c           |    4 +-
 arch/blackfin/mach-bf537/Kconfig                  |    2 +
 arch/blackfin/mach-bf537/boards/Kconfig           |   29 +
 arch/blackfin/mach-bf537/boards/Makefile          |    9 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |   11 +-
 arch/blackfin/mach-bf537/boards/eth_mac.c         |   50 -
 arch/blackfin/mach-bf537/boards/generic_board.c   |   13 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |   15 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |   50 +-
 arch/blackfin/mach-bf548/Kconfig                  |    2 +
 arch/blackfin/mach-bf548/boards/Kconfig           |   12 +
 arch/blackfin/mach-bf548/boards/Makefile          |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |   20 +-
 arch/blackfin/mach-bf548/head.S                   |   21 +
 arch/blackfin/mach-bf561/Kconfig                  |    4 +-
 arch/blackfin/mach-bf561/boards/Kconfig           |   27 +
 arch/blackfin/mach-bf561/boards/Makefile          |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    4 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |   29 +
 arch/blackfin/mach-bf561/boards/generic_board.c   |    4 -
 arch/blackfin/mach-bf561/boards/tepla.c           |    4 -
 arch/blackfin/mach-common/cplbinfo.c              |    2 +-
 arch/blackfin/mach-common/cplbmgr.S               |   25 +-
 arch/blackfin/mach-common/entry.S                 |   54 +-
 arch/blackfin/mach-common/interrupt.S             |    1 -
 arch/blackfin/mach-common/ints-priority-dc.c      |   21 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |   28 +-
 arch/blackfin/mach-common/irqpanic.c              |   14 +-
 arch/blackfin/mm/blackfin_sram.c                  |    1 -
 drivers/input/serio/Kconfig                       |    2 +-
 drivers/net/bfin_mac.c                            |    2 +-
 drivers/net/bfin_mac.h                            |    2 +-
 drivers/rtc/Kconfig                               |    2 +-
 drivers/serial/Kconfig                            |    2 +-
 drivers/spi/Kconfig                               |    2 +-
 drivers/video/console/Kconfig                     |    2 +-
 include/asm-blackfin/bfin-global.h                |    5 +-
 include/asm-blackfin/cplbinit.h                   |   33 +-
 include/asm-blackfin/delay.h                      |   66 +-
 include/asm-blackfin/io.h                         |    1 +
 include/asm-blackfin/mach-bf527/irq.h             |    4 -
 include/asm-blackfin/mach-bf527/mem_map.h         |    3 +-
 include/asm-blackfin/mach-bf533/irq.h             |    4 -
 include/asm-blackfin/mach-bf533/mem_map.h         |    4 +-
 include/asm-blackfin/mach-bf537/irq.h             |    4 -
 include/asm-blackfin/mach-bf537/mem_map.h         |    3 +-
 include/asm-blackfin/mach-bf548/bf548.h           |   34 +-
 include/asm-blackfin/mach-bf548/defBF544.h        |    2 +-
 include/asm-blackfin/mach-bf548/defBF548.h        |    2 +-
 include/asm-blackfin/mach-bf548/irq.h             |    4 -
 include/asm-blackfin/mach-bf548/mem_map.h         |   18 +-
 include/asm-blackfin/mach-bf561/bf561.h           |   19 -
 include/asm-blackfin/mach-bf561/defBF561.h        |   15 +-
 include/asm-blackfin/mach-bf561/irq.h             |    4 -
 include/asm-blackfin/mach-bf561/mem_map.h         |    7 +-
 include/asm-blackfin/mach-common/def_LPBlackfin.h |    8 +-
 include/asm-blackfin/page_offset.h                |    2 +-
 include/asm-blackfin/string.h                     |    2 +
 include/asm-blackfin/traps.h                      |   96 ++-
 init/Kconfig                                      |    2 +-
 lib/Kconfig.debug                                 |    4 +-
 98 files changed, 2325 insertions(+), 1410 deletions(-)
 create mode 100644 arch/blackfin/Kconfig.debug
 create mode 100644 arch/blackfin/configs/H8606_defconfig
 delete mode 100644 arch/blackfin/lib/udivdi3.S
 create mode 100644 arch/blackfin/mach-bf527/boards/Kconfig
 delete mode 100644 arch/blackfin/mach-bf527/boards/eth_mac.c
 create mode 100644 arch/blackfin/mach-bf533/boards/Kconfig
 create mode 100644 arch/blackfin/mach-bf537/boards/Kconfig
 delete mode 100644 arch/blackfin/mach-bf537/boards/eth_mac.c
 create mode 100644 arch/blackfin/mach-bf548/boards/Kconfig
 create mode 100644 arch/blackfin/mach-bf561/boards/Kconfig

Adrian Bunk (2):
      Blackfin arch: remove dump_thread()
      Blackfin arch: unexport get_wchan

Bernd Schmidt (2):
      Blackfin arch: fix bug kernel not to boot up with mtd filesystems
      Blackfin arch: Need to specify ax with the .init.text section,

Bryan Wu (1):
      Blackfin arch: move hard coded pin_req to board file

Cliff Cai (1):
      Blackfin arch: export symbol get_dma_curr_desc_ptr for driver usage

Javier Herrero (1):
      Blackfin arch: Default config for HV Sistemas H8606 board

Jie Zhang (1):
      Blackfin arch: More explicitly describe what the instructions do in inline assembly.

Michael Hennerich (4):
      Blackfin arch: fix AD7877 bus_num and add support for WM8731 SPI control interface
      Blackfin arch: Dont use cs_change_per_word, since the AD7877 driver doesnt require it anymore; fix bus numbers, fix typos
      Blackfin arch: Add assembly function insl_16
      Blackfin arch: add AXIS AX88180 Gigabit Ethernet Hardware and Driver to board files

Mike Frysinger (32):
      Blackfin arch: remove mention of uClinux/no-mmu ... we are just Blackfin Linux
      Blackfin arch: add a compatible DOUBLE_FAULT define to enable resets on double faults in either core
      Blackfin arch: fix silicon rev display and selection for BF52x/BF54x
      Blackfin arch: split board selection off into mach subdirs
      Blackfin arch: fix indentation -- use tabs, not spaces
      Blackfin arch: punt CONFIG_BFIN -- we already have CONFIG_BLACKFIN
      Blackfin arch: split debug stuff off into Kconfig.debug like everyone else
      Blackfin arch: add BF547 to list of accepted procs
      Blackfin arch: fix missing newline to file
      Blackfin arch: remove useless CONFIG_IRQCHIP_DEMUX_GPIO
      Blackfin arch: fix double fault definition for BF561 core A and core B
      Blackfin arch: sharing the board-specific MAC function does not make sense so move it into board-specific files
      Blackfin arch: change get_bf537_ether_addr() to bfin_get_ether_addr() since this is not BF537 specific and to better match other Blackfin-specific conventions
      Blackfin arch: do not include linux/autoconf.h
      Blackfin arch: the usb_sl811.h header has been moved to usb/sl811.h so lets use that version now
      Blackfin arch: relocate linux/usb_isp1362.h to linux/usb/isp1362.h like in newer linux trees
      Blackfin arch: fix spurious newline in header
      Blackfin arch: use do_div() for the 64bit division as pointed out by Bernd
      Blackfin arch: move EXPORT_SYMBOL() to C files where the symbol is actually defined
      Blackfin arch: rename _return_from_exception to _bfin_return_from_exception and export it
      Blackfin arch: fix building for BF542 processors which only have 1 TWI
      Blackfin arch: cleanup BF54x header file and add BF547 definition
      Blackfin arch: add support for working around anomaly 05000312
      Blackfin arch: fix broken on BF52x, remove silly checks on processors for L1_SCRATCH defines
      Blackfin arch: cleanup the cplb declares
      Blackfin arch: cplb and map header file cleanup
      Blackfin arch: add defines for the on-chip L1 ROM of BF54x
      Blackfin arch: convert READY to DMA_READY as it causes build errors in common sound code otherwise
      Blackfin arch: Fix typo, and add ENDPROC - no functional changes
      Blackfin arch: update defconfig files
      Blackfin arch: use common __INIT/__FINIT defines rather than setting the .section ourselves to .init.text
      Blackfin arch: split apart dump_bfin_regs and merge/remove show_regs from process.c, which was largely duplicated

Robert P. J. Day (1):
      Blackfin arch: Typo: "CONFIG_RTC_BFIN_MODULE" -> "CONFIG_RTC_DRV_BFIN_MODULE"

Robin Getz (9):
      Blackfin arch: ensure we work around ANOMALY_05000261 for null pointers
      Blackfin arch: fix bux - only reset the PC when necessary, otherwise gdb gets confused
      Blackfin arch: fix bug cplbmgr.S does not exit properly on error condition
      Blackfin arch: move the init sections to the end of memory to help decrease memory fragementation
      Blackfin arch: print out modules that are loaded if we get a kernel oops
      Blackfin arch: cleanup kernel exception message, don't insult the customer.
      Blackfin arch: Update Kconfig to latest Blackfin silicon datasheets
      Blackfin arch: Ensure we printk out strings with the proper loglevel
      Blackfin arch: fix bug when sending signals with the wrong PC, cause gdb get confused

Sonic Zhang (2):
      Blackfin arch: fix bug NOR Flash MTD mount fail
      Blackfin arch: fix bug when enable uart1 with uart0 disabled => no initial console

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9f9de3e..2a3a7ea 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -3,7 +3,7 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "uClinux/Blackfin (w/o MMU) Kernel Configuration"
+mainmenu "Blackfin Kernel Configuration"
 
 config MMU
 	bool
@@ -29,10 +29,6 @@ config ZONE_DMA
 	bool
 	default y
 
-config BFIN
-	bool
-	default y
-
 config SEMAPHORE_SLEEPERS
 	bool
 	default y
@@ -50,7 +46,7 @@ config GENERIC_HARDIRQS
 	default y
 
 config GENERIC_IRQ_PROBE
-        bool
+	bool
 	default y
 
 config GENERIC_TIME
@@ -69,11 +65,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config IRQCHIP_DEMUX_GPIO
-	bool
-	depends on (BF52x || BF53x || BF561 || BF54x)
-	default y
-
 source "init/Kconfig"
 source "kernel/Kconfig.preempt"
 
@@ -140,6 +131,11 @@ config BF544
 	help
 	  BF544 Processor Support.
 
+config BF547
+	bool "BF547"
+	help
+	  BF547 Processor Support.
+
 config BF548
 	bool "BF548"
 	help
@@ -166,11 +162,11 @@ choice
 
 config BF_REV_0_0
 	bool "0.0"
-	depends on (BF549 || BF527)
+	depends on (BF52x || BF54x)
 
 config BF_REV_0_1
-	bool "0.2"
-	depends on (BF549 || BF527)
+	bool "0.1"
+	depends on (BF52x || BF54x)
 
 config BF_REV_0_2
 	bool "0.2"
@@ -208,7 +204,7 @@ config BF53x
 
 config BF54x
 	bool
-	depends on (BF542 || BF544 || BF548 || BF549)
+	depends on (BF542 || BF544 || BF547 || BF548 || BF549)
 	default y
 
 config BFIN_DUAL_CORE
@@ -221,95 +217,6 @@ config BFIN_SINGLE_CORE
 	depends on !BFIN_DUAL_CORE
 	default y
 
-choice
-	prompt "System type"
-	default BFIN533_STAMP
-	help
-	  Do NOT change the board here.  Please use the top level
-	  configuration to ensure that all the other settings are
-	  correct.
-
-config BFIN527_EZKIT
-	bool "BF527-EZKIT"
-	depends on (BF522 || BF525 || BF527)
-	help
-	  BF533-EZKIT-LITE board Support.
-
-config BFIN533_EZKIT
-	bool "BF533-EZKIT"
-	depends on (BF533 || BF532 || BF531)
-	help
-	  BF533-EZKIT-LITE board Support.
-
-config  BFIN533_STAMP
-	bool "BF533-STAMP"
-	depends on (BF533 || BF532 || BF531)
-	help
-	  BF533-STAMP board Support.
-
-config BFIN537_STAMP
-	bool "BF537-STAMP"
-	depends on (BF537 || BF536 || BF534)
-	help
-	  BF537-STAMP board Support.
-
-config BFIN533_BLUETECHNIX_CM
-	bool "Bluetechnix CM-BF533"
-	depends on (BF533)
-	help
-	  CM-BF533 support for EVAL- and DEV-Board.
-
-config BFIN537_BLUETECHNIX_CM
-	bool "Bluetechnix CM-BF537"
-	depends on (BF537)
-	help
-	  CM-BF537 support for EVAL- and DEV-Board.
-
-config BFIN548_EZKIT
-	bool "BF548-EZKIT"
-	depends on (BF548 || BF549)
-	  help
-	  BFIN548-EZKIT board Support.
-
-config BFIN561_BLUETECHNIX_CM
-	bool "Bluetechnix CM-BF561"
-	depends on (BF561)
-	help
-	  CM-BF561 support for EVAL- and DEV-Board.
-
-config BFIN561_EZKIT
-	bool "BF561-EZKIT"
-	depends on (BF561)
-	help
-	  BF561-EZKIT-LITE board Support.
-
-config BFIN561_TEPLA
-	bool "BF561-TEPLA"
-	depends on (BF561)
-	help
-	 BF561-TEPLA board Support.
-
-config PNAV10
-	bool "PNAV 1.0 board"
-	depends on (BF537)
-	help
-	  PNAV 1.0 board Support.
-
-config H8606_HVSISTEMAS
-        bool "HV Sistemas H8606"
-        depends on (BF532)
-        help
-          HV Sistemas H8606 board support.
-
-config GENERIC_BOARD
-	bool "Custom"
-	depends on (BF537 || BF536 \
-		|| BF534 || BF561 || BF535 || BF533 || BF532 || BF531)
-	help
-	  GENERIC or Custom board Support.
-
-endchoice
-
 config MEM_GENERIC_BOARD
 	bool
 	depends on GENERIC_BOARD
@@ -389,9 +296,9 @@ config BFIN_KERNEL_CLOCK
 	  configuration.
 
 config PLL_BYPASS
-        bool "Bypass PLL"
-        depends on BFIN_KERNEL_CLOCK
-        default n
+	bool "Bypass PLL"
+	depends on BFIN_KERNEL_CLOCK
+	default n
 
 config CLKIN_HALF
 	bool "Half Clock In"
@@ -468,11 +375,11 @@ config MAX_VCO_HZ
 	default 500000000 if BF534
 	default 400000000 if BF536
 	default 600000000 if BF537
-	default 533000000 if BF538
-	default 533000000 if BF539
+	default 533333333 if BF538
+	default 533333333 if BF539
 	default 600000000 if BF542
-	default 533000000 if BF544
-	default 533000000 if BF549
+	default 533333333 if BF544
+	default 533333333 if BF549
 	default 600000000 if BF561
 
 config MIN_VCO_HZ
@@ -481,7 +388,7 @@ config MIN_VCO_HZ
 
 config MAX_SCLK_HZ
 	int
-	default 133000000
+	default 133333333
 
 config MIN_SCLK_HZ
 	int
@@ -959,6 +866,20 @@ config BANK_3
 	default 0x99B3
 endmenu
 
+config EBIU_MBSCTLVAL
+	hex "EBIU Bank Select Control Register"
+	depends on BF54x
+	default 0
+
+config EBIU_MODEVAL
+	hex "Flash Memory Mode Control Register"
+	depends on BF54x
+	default 1
+
+config EBIU_FCTLVAL
+	hex "Flash Memory Bank Control Register"
+	depends on BF54x
+	default 6
 endmenu
 
 #############################################################################
@@ -1075,174 +996,7 @@ source "fs/Kconfig"
 
 source "kernel/Kconfig.instrumentation"
 
-menu "Kernel hacking"
-
-source "lib/Kconfig.debug"
-
-config DEBUG_HWERR
-	bool "Hardware error interrupt debugging"
-	depends on DEBUG_KERNEL
-	help
-	  When enabled, the hardware error interrupt is never disabled, and
-	  will happen immediately when an error condition occurs.  This comes
-	  at a slight cost in code size, but is necessary if you are getting
-	  hardware error interrupts and need to know where they are coming
-	  from.
-
-config DEBUG_ICACHE_CHECK
-	bool "Check Instruction cache coherency"
-	depends on DEBUG_KERNEL
-	depends on DEBUG_HWERR
-	help
-	  Say Y here if you are getting weird unexplained errors. This will
-	  ensure that icache is what SDRAM says it should be by doing a
-	  byte wise comparison between SDRAM and instruction cache. This
-	  also relocates the irq_panic() function to L1 memory, (which is
-	  un-cached).
-
-config DEBUG_HUNT_FOR_ZERO
-	bool "Catch NULL pointer reads/writes"
-	default y
-	help
-	  Say Y here to catch reads/writes to anywhere in the memory range
-	  from 0x0000 - 0x0FFF (the first 4k) of memory.  This is useful in
-	  catching common programming errors such as NULL pointer dereferences.
-
-	  Misbehaving applications will be killed (generate a SEGV) while the
-	  kernel will trigger a panic.
-
-	  Enabling this option will take up an extra entry in CPLB table.
-	  Otherwise, there is no extra overhead.
-
-config DEBUG_BFIN_HWTRACE_ON
-	bool "Turn on Blackfin's Hardware Trace"
-	default y
-	help
-	  All Blackfins include a Trace Unit which stores a history of the last
-	  16 changes in program flow taken by the program sequencer. The history
-	  allows the user to recreate the program sequencerâs recent path. This
-	  can be handy when an application dies - we print out the execution
-	  path of how it got to the offending instruction.
-
-	  By turning this off, you may save a tiny amount of power.
-
-choice
-	prompt "Omit loop Tracing"
-	default DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
-	depends on DEBUG_BFIN_HWTRACE_ON
-	help
-	  The trace buffer can be configured to omit recording of changes in
-	  program flow that match either the last entry or one of the last
-	  two entries. Omitting one of these entries from the record prevents
-	  the trace buffer from overflowing because of any sort of loop (for, do
-	  while, etc) in the program.
-
-	  Because zero-overhead Hardware loops are not recorded in the trace buffer,
-	  this feature can be used to prevent trace overflow from loops that
-	  are nested four deep.
-
-config DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
-	bool "Trace all Loops"
-	help
-	  The trace buffer records all changes of flow 
-
-config DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
-	bool "Compress single-level loops"
-	help
-	  The trace buffer does not record single loops - helpful if trace 
-	  is spinning on a while or do loop.
-
-config DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
-	bool "Compress two-level loops"
-	help
-	  The trace buffer does not record loops two levels deep. Helpful if
-	  the trace is spinning in a nested loop
-
-endchoice
-
-config DEBUG_BFIN_HWTRACE_COMPRESSION
-	int
-	depends on DEBUG_BFIN_HWTRACE_ON
-	default 0 if DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
-	default 1 if DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
-	default 2 if DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
-
-
-config DEBUG_BFIN_HWTRACE_EXPAND
-	bool "Expand Trace Buffer greater than 16 entries"
-	depends on DEBUG_BFIN_HWTRACE_ON
-	default n
-	help
-	  By selecting this option, every time the 16 hardware entries in
-	  the Blackfin's HW Trace buffer are full, the kernel will move them
-	  into a software buffer, for dumping when there is an issue. This 
-	  has a great impact on performance, (an interrupt every 16 change of 
-	  flows) and should normally be turned off, except in those nasty
-	  debugging sessions
-
-config DEBUG_BFIN_HWTRACE_EXPAND_LEN
-	int "Size of Trace buffer (in power of 2k)"
-	range 0 4
-	depends on DEBUG_BFIN_HWTRACE_EXPAND
-	default 1
-	help
-	  This sets the size of the software buffer that the trace information
-	  is kept in.
-	  0 for (2^0)  1k, or 256 entries,
-	  1 for (2^1)  2k, or 512 entries,
-	  2 for (2^2)  4k, or 1024 entries,
-	  3 for (2^3)  8k, or 2048 entries,
-	  4 for (2^4) 16k, or 4096 entries
-
-config DEBUG_BFIN_NO_KERN_HWTRACE
-	bool "Trace user apps (turn off hwtrace in kernel)"
-	depends on DEBUG_BFIN_HWTRACE_ON
-	default n
-	help
-	  Some pieces of the kernel contain a lot of flow changes which can
-	  quickly fill up the hardware trace buffer.  When debugging crashes,
-	  the hardware trace may indicate that the problem lies in kernel
-	  space when in reality an application is buggy.
-
-	  Say Y here to disable hardware tracing in some known "jumpy" pieces
-	  of code so that the trace buffer will extend further back.
-
-config EARLY_PRINTK
-	bool "Early printk" 
-	default n
-	help
-	  This option enables special console drivers which allow the kernel
-	  to print messages very early in the bootup process.
-
-	  This is useful for kernel debugging when your machine crashes very
-	  early before the console code is initialized. After enabling this
-	  feature, you must add "earlyprintk=serial,uart0,57600" to the
-	  command line (bootargs). It is safe to say Y here in all cases, as
-	  all of this lives in the init section and is thrown away after the
-	  kernel boots completely.
-
-config DUAL_CORE_TEST_MODULE
-	tristate "Dual Core Test Module"
-	depends on (BF561)
-	default n
-	help
-	  Say Y here to build-in dual core test module for dual core test.
-
-config CPLB_INFO
-	bool "Display the CPLB information"
-	help
-	  Display the CPLB information.
-
-config ACCESS_CHECK
-	bool "Check the user pointer address"
-	default y
-	help
-	  Usually the pointer transfer from user space is checked to see if its
-	  address is in the kernel space.
-
-	  Say N here to disable that check to improve the performance.
-
-endmenu
+source "arch/blackfin/Kconfig.debug"
 
 source "security/Kconfig"
 
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
new file mode 100644
index 0000000..59b87a4
--- /dev/null
+++ b/arch/blackfin/Kconfig.debug
@@ -0,0 +1,178 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config DEBUG_MMRS
+	bool "Generate Blackfin MMR tree"
+	select DEBUG_FS
+	help
+	  Create a tree of Blackfin MMRs via the debugfs tree.  If
+	  you enable this, you will find all MMRs laid out in the
+	  /sys/kernel/debug/blackfin/ directory where you can read/write
+	  MMRs directly from userspace.  This is obviously just a debug
+	  feature.
+
+config DEBUG_HWERR
+	bool "Hardware error interrupt debugging"
+	depends on DEBUG_KERNEL
+	help
+	  When enabled, the hardware error interrupt is never disabled, and
+	  will happen immediately when an error condition occurs.  This comes
+	  at a slight cost in code size, but is necessary if you are getting
+	  hardware error interrupts and need to know where they are coming
+	  from.
+
+config DEBUG_ICACHE_CHECK
+	bool "Check Instruction cache coherency"
+	depends on DEBUG_KERNEL
+	depends on DEBUG_HWERR
+	help
+	  Say Y here if you are getting weird unexplained errors. This will
+	  ensure that icache is what SDRAM says it should be by doing a
+	  byte wise comparison between SDRAM and instruction cache. This
+	  also relocates the irq_panic() function to L1 memory, (which is
+	  un-cached).
+
+config DEBUG_HUNT_FOR_ZERO
+	bool "Catch NULL pointer reads/writes"
+	default y
+	help
+	  Say Y here to catch reads/writes to anywhere in the memory range
+	  from 0x0000 - 0x0FFF (the first 4k) of memory.  This is useful in
+	  catching common programming errors such as NULL pointer dereferences.
+
+	  Misbehaving applications will be killed (generate a SEGV) while the
+	  kernel will trigger a panic.
+
+	  Enabling this option will take up an extra entry in CPLB table.
+	  Otherwise, there is no extra overhead.
+
+config DEBUG_BFIN_HWTRACE_ON
+	bool "Turn on Blackfin's Hardware Trace"
+	default y
+	help
+	  All Blackfins include a Trace Unit which stores a history of the last
+	  16 changes in program flow taken by the program sequencer. The history
+	  allows the user to recreate the program sequencerâs recent path. This
+	  can be handy when an application dies - we print out the execution
+	  path of how it got to the offending instruction.
+
+	  By turning this off, you may save a tiny amount of power.
+
+choice
+	prompt "Omit loop Tracing"
+	default DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	depends on DEBUG_BFIN_HWTRACE_ON
+	help
+	  The trace buffer can be configured to omit recording of changes in
+	  program flow that match either the last entry or one of the last
+	  two entries. Omitting one of these entries from the record prevents
+	  the trace buffer from overflowing because of any sort of loop (for, do
+	  while, etc) in the program.
+
+	  Because zero-overhead Hardware loops are not recorded in the trace buffer,
+	  this feature can be used to prevent trace overflow from loops that
+	  are nested four deep.
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	bool "Trace all Loops"
+	help
+	  The trace buffer records all changes of flow 
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
+	bool "Compress single-level loops"
+	help
+	  The trace buffer does not record single loops - helpful if trace 
+	  is spinning on a while or do loop.
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
+	bool "Compress two-level loops"
+	help
+	  The trace buffer does not record loops two levels deep. Helpful if
+	  the trace is spinning in a nested loop
+
+endchoice
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION
+	int
+	depends on DEBUG_BFIN_HWTRACE_ON
+	default 0 if DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	default 1 if DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
+	default 2 if DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
+
+
+config DEBUG_BFIN_HWTRACE_EXPAND
+	bool "Expand Trace Buffer greater than 16 entries"
+	depends on DEBUG_BFIN_HWTRACE_ON
+	default n
+	help
+	  By selecting this option, every time the 16 hardware entries in
+	  the Blackfin's HW Trace buffer are full, the kernel will move them
+	  into a software buffer, for dumping when there is an issue. This 
+	  has a great impact on performance, (an interrupt every 16 change of 
+	  flows) and should normally be turned off, except in those nasty
+	  debugging sessions
+
+config DEBUG_BFIN_HWTRACE_EXPAND_LEN
+	int "Size of Trace buffer (in power of 2k)"
+	range 0 4
+	depends on DEBUG_BFIN_HWTRACE_EXPAND
+	default 1
+	help
+	  This sets the size of the software buffer that the trace information
+	  is kept in.
+	  0 for (2^0)  1k, or 256 entries,
+	  1 for (2^1)  2k, or 512 entries,
+	  2 for (2^2)  4k, or 1024 entries,
+	  3 for (2^3)  8k, or 2048 entries,
+	  4 for (2^4) 16k, or 4096 entries
+
+config DEBUG_BFIN_NO_KERN_HWTRACE
+	bool "Trace user apps (turn off hwtrace in kernel)"
+	depends on DEBUG_BFIN_HWTRACE_ON
+	default n
+	help
+	  Some pieces of the kernel contain a lot of flow changes which can
+	  quickly fill up the hardware trace buffer.  When debugging crashes,
+	  the hardware trace may indicate that the problem lies in kernel
+	  space when in reality an application is buggy.
+
+	  Say Y here to disable hardware tracing in some known "jumpy" pieces
+	  of code so that the trace buffer will extend further back.
+
+config EARLY_PRINTK
+	bool "Early printk" 
+	default n
+	help
+	  This option enables special console drivers which allow the kernel
+	  to print messages very early in the bootup process.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. After enabling this
+	  feature, you must add "earlyprintk=serial,uart0,57600" to the
+	  command line (bootargs). It is safe to say Y here in all cases, as
+	  all of this lives in the init section and is thrown away after the
+	  kernel boots completely.
+
+config DUAL_CORE_TEST_MODULE
+	tristate "Dual Core Test Module"
+	depends on (BF561)
+	default n
+	help
+	  Say Y here to build-in dual core test module for dual core test.
+
+config CPLB_INFO
+	bool "Display the CPLB information"
+	help
+	  Display the CPLB information.
+
+config ACCESS_CHECK
+	bool "Check the user pointer address"
+	default y
+	help
+	  Usually the pointer transfer from user space is checked to see if its
+	  address is in the kernel space.
+
+	  Say N here to disable that check to improve the performance.
+
+endmenu
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index f7cac7c..c47e000 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -31,6 +31,7 @@ machine-$(CONFIG_BF536) := bf537
 machine-$(CONFIG_BF537) := bf537
 machine-$(CONFIG_BF542) := bf548
 machine-$(CONFIG_BF544) := bf548
+machine-$(CONFIG_BF547) := bf548
 machine-$(CONFIG_BF548) := bf548
 machine-$(CONFIG_BF549) := bf548
 machine-$(CONFIG_BF561) := bf561
@@ -48,6 +49,7 @@ cpu-$(CONFIG_BF536) := bf536
 cpu-$(CONFIG_BF537) := bf537
 cpu-$(CONFIG_BF542) := bf542
 cpu-$(CONFIG_BF544) := bf544
+cpu-$(CONFIG_BF547) := bf547
 cpu-$(CONFIG_BF548) := bf548
 cpu-$(CONFIG_BF549) := bf549
 cpu-$(CONFIG_BF561) := bf561
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 1f6a93d..fa6eb4e 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.9
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -127,6 +125,7 @@ CONFIG_BF527=y
 # CONFIG_BF537 is not set
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 # CONFIG_BF561 is not set
@@ -140,19 +139,8 @@ CONFIG_BF_REV_0_0=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF52x=y
 CONFIG_BFIN_SINGLE_CORE=y
-CONFIG_BFIN527_EZKIT=y
-# CONFIG_BFIN533_EZKIT is not set
-# CONFIG_BFIN533_STAMP is not set
-# CONFIG_BFIN537_STAMP is not set
-# CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC32M16A2TG_75=y
+CONFIG_BFIN527_EZKIT=y
 
 #
 # BF527 Specific Configuration
@@ -244,7 +232,7 @@ CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -301,6 +289,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -322,7 +311,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -548,6 +537,7 @@ CONFIG_BFIN_NAND_CLE=2
 CONFIG_BFIN_NAND_ALE=1
 CONFIG_BFIN_NAND_READY=3
 CONFIG_MTD_NAND_IDS=m
+# CONFIG_MTD_NAND_BF5XX is not set
 # CONFIG_MTD_NAND_DISKONCHIP is not set
 # CONFIG_MTD_NAND_NANDSIM is not set
 # CONFIG_MTD_NAND_PLATFORM is not set
@@ -637,6 +627,7 @@ CONFIG_BFIN_MAC_RMII=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -708,7 +699,7 @@ CONFIG_INPUT_MISC=y
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 9e9b420..4fdb493 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -64,7 +62,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
@@ -117,6 +114,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 CONFIG_BF533=y
@@ -125,10 +125,12 @@ CONFIG_BF533=y
 # CONFIG_BF537 is not set
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 # CONFIG_BF561 is not set
 # CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
 # CONFIG_BF_REV_0_2 is not set
 CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_0_4 is not set
@@ -137,18 +139,12 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
 CONFIG_BFIN_SINGLE_CORE=y
+CONFIG_MEM_MT48LC16M16A2TG_75=y
 CONFIG_BFIN533_EZKIT=y
 # CONFIG_BFIN533_STAMP is not set
-# CONFIG_BFIN537_STAMP is not set
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_GENERIC_BOARD is not set
-CONFIG_MEM_MT48LC16M16A2TG_75=y
+# CONFIG_H8606_HVSISTEMAS is not set
+# CONFIG_GENERIC_BF533_BOARD is not set
 
 #
 # BF533/2/1 Specific Configuration
@@ -198,7 +194,7 @@ CONFIG_CLKIN_HZ=27000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -255,6 +251,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -276,7 +273,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -526,14 +523,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_BF5xx=m
 CONFIG_BFIN_FLASH_SIZE=0x400000
 CONFIG_EBIU_FLASH_BASE=0x20000000
-
-#
-# FLASH_EBIU_AMBCTL Control
-#
-CONFIG_BFIN_FLASH_BANK_0=0x7BB0
-CONFIG_BFIN_FLASH_BANK_1=0x7BB0
-CONFIG_BFIN_FLASH_BANK_2=0x7BB0
-CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 # CONFIG_MTD_UCLINUX is not set
 # CONFIG_MTD_PLATRAM is not set
 
@@ -622,6 +611,7 @@ CONFIG_SMC91X=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -683,9 +673,9 @@ CONFIG_INPUT_EVDEV=m
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
@@ -708,6 +698,7 @@ CONFIG_SERIAL_BFIN_DMA=y
 # CONFIG_SERIAL_BFIN_PIO is not set
 CONFIG_SERIAL_BFIN_UART0=y
 # CONFIG_BFIN_UART0_CTSRTS is not set
+# CONFIG_SERIAL_BFIN_UART1 is not set
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index f59ade9..b04e8e5 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -64,7 +62,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
@@ -117,6 +114,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 CONFIG_BF533=y
@@ -125,10 +125,12 @@ CONFIG_BF533=y
 # CONFIG_BF537 is not set
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 # CONFIG_BF561 is not set
 # CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
 # CONFIG_BF_REV_0_2 is not set
 CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_0_4 is not set
@@ -137,19 +139,13 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
 CONFIG_BFIN_SINGLE_CORE=y
+CONFIG_MEM_MT48LC64M4A2FB_7E=y
+CONFIG_BFIN_SHARED_FLASH_ENET=y
 # CONFIG_BFIN533_EZKIT is not set
 CONFIG_BFIN533_STAMP=y
-# CONFIG_BFIN537_STAMP is not set
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_GENERIC_BOARD is not set
-CONFIG_MEM_MT48LC64M4A2FB_7E=y
-CONFIG_BFIN_SHARED_FLASH_ENET=y
+# CONFIG_H8606_HVSISTEMAS is not set
+# CONFIG_GENERIC_BF533_BOARD is not set
 
 #
 # BF533/2/1 Specific Configuration
@@ -199,7 +195,7 @@ CONFIG_CLKIN_HZ=11059200
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -267,6 +263,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -288,7 +285,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -634,6 +631,7 @@ CONFIG_SMC91X=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -704,9 +702,9 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=39
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
@@ -732,6 +730,7 @@ CONFIG_SERIAL_BFIN_DMA=y
 # CONFIG_SERIAL_BFIN_PIO is not set
 CONFIG_SERIAL_BFIN_UART0=y
 # CONFIG_BFIN_UART0_CTSRTS is not set
+# CONFIG_SERIAL_BFIN_UART1 is not set
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
@@ -925,6 +924,7 @@ CONFIG_NTSC=y
 # CONFIG_PAL_YCBCR is not set
 CONFIG_ADV7393_1XMEM=y
 # CONFIG_ADV7393_2XMEM is not set
+# CONFIG_FB_BFIN_T350MCQB is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_LOGO is not set
@@ -979,11 +979,6 @@ CONFIG_SND_BFIN_AD73311_SE=4
 # CONFIG_SND_SOC is not set
 
 #
-# SoC Audio for the ADI Blackfin
-#
-# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
-
-#
 # Open Sound System
 #
 # CONFIG_SOUND_PRIME is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 07eb63d..f812b66 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -64,7 +62,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
@@ -117,6 +114,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
@@ -125,10 +125,12 @@ CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_BF537=y
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 # CONFIG_BF561 is not set
 # CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
 CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
@@ -137,33 +139,8 @@ CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
 CONFIG_BFIN_SINGLE_CORE=y
-# CONFIG_BFIN533_EZKIT is not set
-# CONFIG_BFIN533_STAMP is not set
-CONFIG_BFIN537_STAMP=y
-# CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC32M8A2_75=y
 CONFIG_IRQ_PLL_WAKEUP=7
-
-#
-# BF537 Specific Configuration
-#
-
-#
-# Interrupt Priority Assignment
-#
-
-#
-# Priority
-#
-CONFIG_IRQ_DMA_ERROR=7
-CONFIG_IRQ_ERROR=7
 CONFIG_IRQ_RTC=8
 CONFIG_IRQ_PPI=8
 CONFIG_IRQ_SPORT0_RX=9
@@ -176,8 +153,6 @@ CONFIG_IRQ_UART0_RX=10
 CONFIG_IRQ_UART0_TX=10
 CONFIG_IRQ_UART1_RX=10
 CONFIG_IRQ_UART1_TX=10
-CONFIG_IRQ_CAN_RX=11
-CONFIG_IRQ_CAN_TX=11
 CONFIG_IRQ_MAC_RX=11
 CONFIG_IRQ_MAC_TX=11
 CONFIG_IRQ_TMR0=12
@@ -188,11 +163,31 @@ CONFIG_IRQ_TMR4=12
 CONFIG_IRQ_TMR5=12
 CONFIG_IRQ_TMR6=12
 CONFIG_IRQ_TMR7=12
-CONFIG_IRQ_PROG_INTA=12
 CONFIG_IRQ_PORTG_INTB=12
 CONFIG_IRQ_MEM_DMA0=13
 CONFIG_IRQ_MEM_DMA1=13
 CONFIG_IRQ_WATCH=13
+CONFIG_BFIN537_STAMP=y
+# CONFIG_BFIN537_BLUETECHNIX_CM is not set
+# CONFIG_PNAV10 is not set
+# CONFIG_GENERIC_BF537_BOARD is not set
+
+#
+# BF537 Specific Configuration
+#
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_IRQ_DMA_ERROR=7
+CONFIG_IRQ_ERROR=7
+CONFIG_IRQ_CAN_RX=11
+CONFIG_IRQ_CAN_TX=11
+CONFIG_IRQ_PROG_INTA=12
 
 #
 # Board customizations
@@ -206,7 +201,7 @@ CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -263,6 +258,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -284,7 +280,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -534,14 +530,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_BF5xx=m
 CONFIG_BFIN_FLASH_SIZE=0x400000
 CONFIG_EBIU_FLASH_BASE=0x20000000
-
-#
-# FLASH_EBIU_AMBCTL Control
-#
-CONFIG_BFIN_FLASH_BANK_0=0x7BB0
-CONFIG_BFIN_FLASH_BANK_1=0x7BB0
-CONFIG_BFIN_FLASH_BANK_2=0x7BB0
-CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 # CONFIG_MTD_UCLINUX is not set
 # CONFIG_MTD_PLATRAM is not set
 
@@ -660,6 +648,7 @@ CONFIG_BFIN_RX_DESC_NUM=20
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -730,9 +719,9 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=72
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
@@ -967,6 +956,7 @@ CONFIG_FB_BF537_LQ035=m
 CONFIG_LQ035_SLAVE_ADDR=0x58
 # CONFIG_FB_BFIN_LANDSCAPE is not set
 # CONFIG_FB_BFIN_BGR is not set
+# CONFIG_FB_BFIN_T350MCQB is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_LOGO is not set
@@ -1021,11 +1011,6 @@ CONFIG_SND_BFIN_AD73311_SE=4
 # CONFIG_SND_SOC is not set
 
 #
-# SoC Audio for the ADI Blackfin
-#
-# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
-
-#
 # Open Sound System
 #
 # CONFIG_SOUND_PRIME is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 0dd3d22..48367cc 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,7 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.10
-# Sat Oct 27 02:34:07 2007
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -9,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -19,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -128,6 +125,7 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF537 is not set
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 CONFIG_BF549=y
 # CONFIG_BF561 is not set
@@ -141,19 +139,6 @@ CONFIG_BF_REV_0_0=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF54x=y
 CONFIG_BFIN_SINGLE_CORE=y
-# CONFIG_BFIN527_EZKIT is not set
-# CONFIG_BFIN533_EZKIT is not set
-# CONFIG_BFIN533_STAMP is not set
-# CONFIG_BFIN537_STAMP is not set
-# CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-CONFIG_BFIN548_EZKIT=y
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_H8606_HVSISTEMAS is not set
-# CONFIG_GENERIC_BOARD is not set
 CONFIG_IRQ_PLL_WAKEUP=7
 CONFIG_IRQ_RTC=8
 CONFIG_IRQ_SPORT0_RX=9
@@ -180,6 +165,7 @@ CONFIG_IRQ_TIMER7=11
 CONFIG_IRQ_TIMER8=11
 CONFIG_IRQ_TIMER9=11
 CONFIG_IRQ_TIMER10=11
+CONFIG_BFIN548_EZKIT=y
 
 #
 # BF548 Specific Configuration
@@ -279,9 +265,9 @@ CONFIG_PINT3_ASSIGN=0x02020303
 #
 CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
-CONFIG_MAX_VCO_HZ=533333333
+CONFIG_MAX_VCO_HZ=533000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -376,6 +362,9 @@ CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x5554
 CONFIG_BANK_2=0x7BB0
 CONFIG_BANK_3=0x99B3
+CONFIG_EBUI_MBSCTLVAL=0x0
+CONFIG_EBUI_MODEVAL=0x1
+CONFIG_EBUI_FCTLVAL=0x6
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
@@ -702,6 +691,7 @@ CONFIG_SMSC911X=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -1058,6 +1048,8 @@ CONFIG_SND_SOC=y
 CONFIG_SND_BF5XX_SOC=y
 CONFIG_SND_BF5XX_SOC_AC97=y
 CONFIG_SND_BF5XX_SOC_BF548_EZKIT=y
+# CONFIG_SND_BF5XX_SOC_WM8750 is not set
+# CONFIG_SND_BF5XX_SOC_WM8731 is not set
 CONFIG_SND_BF5XX_SPORT_NUM=0
 # CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
 CONFIG_SND_SOC_AD1980=y
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 277d72d..e9f100b 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -64,7 +62,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
@@ -117,6 +114,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
@@ -125,10 +125,12 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF537 is not set
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 CONFIG_BF561=y
 # CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
 # CONFIG_BF_REV_0_2 is not set
 CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_0_4 is not set
@@ -136,18 +138,15 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BFIN_DUAL_CORE=y
-# CONFIG_BFIN533_EZKIT is not set
-# CONFIG_BFIN533_STAMP is not set
-# CONFIG_BFIN537_STAMP is not set
-# CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
+CONFIG_MEM_MT48LC16M16A2TG_75=y
+CONFIG_IRQ_PLL_WAKEUP=7
+CONFIG_IRQ_SPORT0_ERROR=7
+CONFIG_IRQ_SPORT1_ERROR=7
+CONFIG_IRQ_SPI_ERROR=7
 CONFIG_BFIN561_EZKIT=y
 # CONFIG_BFIN561_TEPLA is not set
-# CONFIG_PNAV10 is not set
-# CONFIG_GENERIC_BOARD is not set
-CONFIG_MEM_MT48LC16M16A2TG_75=y
+# CONFIG_BFIN561_BLUETECHNIX_CM is not set
+# CONFIG_GENERIC_BF561_BOARD is not set
 
 #
 # BF561 Specific Configuration
@@ -170,15 +169,11 @@ CONFIG_BF561_COREB_RESET=y
 #
 # Priority
 #
-CONFIG_IRQ_PLL_WAKEUP=7
 CONFIG_IRQ_DMA1_ERROR=7
 CONFIG_IRQ_DMA2_ERROR=7
 CONFIG_IRQ_IMDMA_ERROR=7
 CONFIG_IRQ_PPI0_ERROR=7
 CONFIG_IRQ_PPI1_ERROR=7
-CONFIG_IRQ_SPORT0_ERROR=7
-CONFIG_IRQ_SPORT1_ERROR=7
-CONFIG_IRQ_SPI_ERROR=7
 CONFIG_IRQ_UART_ERROR=7
 CONFIG_IRQ_RESERVED_ERROR=7
 CONFIG_IRQ_DMA1_0=8
@@ -243,7 +238,7 @@ CONFIG_CLKIN_HZ=30000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -300,6 +295,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -321,7 +317,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -564,14 +560,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_BF5xx=m
 CONFIG_BFIN_FLASH_SIZE=0x0400000
 CONFIG_EBIU_FLASH_BASE=0x20000000
-
-#
-# FLASH_EBIU_AMBCTL Control
-#
-CONFIG_BFIN_FLASH_BANK_0=0x7BB0
-CONFIG_BFIN_FLASH_BANK_1=0x7BB0
-CONFIG_BFIN_FLASH_BANK_2=0x7BB0
-CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 # CONFIG_MTD_UCLINUX is not set
 # CONFIG_MTD_PLATRAM is not set
 
@@ -660,6 +648,7 @@ CONFIG_SMC91X=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -721,9 +710,9 @@ CONFIG_INPUT_EVDEV=m
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
new file mode 100644
index 0000000..18cbb8c
--- /dev/null
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -0,0 +1,1160 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.22.12
+#
+# CONFIG_MMU is not set
+# CONFIG_FPU is not set
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
+CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+# CONFIG_GENERIC_TIME is not set
+CONFIG_GENERIC_GPIO=y
+CONFIG_FORCE_MAX_ZONEORDER=14
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# Code maturity level options
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+
+#
+# General setup
+#
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+# CONFIG_BLK_DEV_INITRD is not set
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
+# CONFIG_NP2 is not set
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+
+#
+# Loadable module support
+#
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_DEADLINE is not set
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="anticipatory"
+CONFIG_PREEMPT_NONE=y
+# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT is not set
+
+#
+# Blackfin Processor Options
+#
+
+#
+# Processor and Board Settings
+#
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
+# CONFIG_BF531 is not set
+CONFIG_BF532=y
+# CONFIG_BF533 is not set
+# CONFIG_BF534 is not set
+# CONFIG_BF536 is not set
+# CONFIG_BF537 is not set
+# CONFIG_BF542 is not set
+# CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
+# CONFIG_BF548 is not set
+# CONFIG_BF549 is not set
+# CONFIG_BF561 is not set
+# CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
+# CONFIG_BF_REV_0_2 is not set
+# CONFIG_BF_REV_0_3 is not set
+# CONFIG_BF_REV_0_4 is not set
+CONFIG_BF_REV_0_5=y
+# CONFIG_BF_REV_ANY is not set
+# CONFIG_BF_REV_NONE is not set
+CONFIG_BF53x=y
+CONFIG_BFIN_SINGLE_CORE=y
+CONFIG_MEM_MT48LC16M16A2TG_75=y
+# CONFIG_BFIN533_EZKIT is not set
+# CONFIG_BFIN533_STAMP is not set
+# CONFIG_BFIN533_BLUETECHNIX_CM is not set
+CONFIG_H8606_HVSISTEMAS=y
+# CONFIG_GENERIC_BF533_BOARD is not set
+
+#
+# BF533/2/1 Specific Configuration
+#
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_UART_ERROR=7
+CONFIG_SPORT0_ERROR=7
+CONFIG_SPI_ERROR=7
+CONFIG_SPORT1_ERROR=7
+CONFIG_PPI_ERROR=7
+CONFIG_DMA_ERROR=7
+CONFIG_PLLWAKE_ERROR=7
+CONFIG_RTC_ERROR=8
+CONFIG_DMA0_PPI=8
+CONFIG_DMA1_SPORT0RX=9
+CONFIG_DMA2_SPORT0TX=9
+CONFIG_DMA3_SPORT1RX=9
+CONFIG_DMA4_SPORT1TX=9
+CONFIG_DMA5_SPI=10
+CONFIG_DMA6_UARTRX=10
+CONFIG_DMA7_UARTTX=10
+CONFIG_TIMER0=11
+CONFIG_TIMER1=11
+CONFIG_TIMER2=11
+CONFIG_PFA=12
+CONFIG_PFB=12
+CONFIG_MEMDMA0=13
+CONFIG_MEMDMA1=13
+CONFIG_WDTIMER=13
+
+#
+# Board customizations
+#
+# CONFIG_CMDLINE_BOOL is not set
+
+#
+# Clock/PLL Setup
+#
+CONFIG_CLKIN_HZ=25000000
+# CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_VCO_HZ=400000000
+CONFIG_MIN_VCO_HZ=50000000
+CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MIN_SCLK_HZ=27000000
+
+#
+# Kernel Timer/Scheduler
+#
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+
+#
+# Memory Setup
+#
+CONFIG_MEM_SIZE=32
+CONFIG_MEM_ADD_WIDTH=9
+CONFIG_BOOT_LOAD=0x1000
+CONFIG_BFIN_SCRATCH_REG_RETN=y
+# CONFIG_BFIN_SCRATCH_REG_RETE is not set
+# CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
+
+#
+# Blackfin Kernel Optimizations
+#
+
+#
+# Memory Optimizations
+#
+CONFIG_I_ENTRY_L1=y
+CONFIG_EXCPT_IRQ_SYSC_L1=y
+CONFIG_DO_IRQ_L1=y
+CONFIG_CORE_TIMER_IRQ_L1=y
+CONFIG_IDLE_L1=y
+CONFIG_SCHEDULE_L1=y
+CONFIG_ARITHMETIC_OPS_L1=y
+CONFIG_ACCESS_OK_L1=y
+CONFIG_MEMSET_L1=y
+CONFIG_MEMCPY_L1=y
+CONFIG_SYS_BFIN_SPINLOCK_L1=y
+# CONFIG_IP_CHECKSUM_L1 is not set
+# CONFIG_CACHELINE_ALIGNED_L1 is not set
+# CONFIG_SYSCALL_TAB_L1 is not set
+# CONFIG_CPLB_SWITCH_TAB_L1 is not set
+CONFIG_RAMKERNEL=y
+# CONFIG_ROMKERNEL is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_LARGE_ALLOCS=y
+CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_2M is not set
+CONFIG_DMA_UNCACHED_1M=y
+# CONFIG_DMA_UNCACHED_NONE is not set
+
+#
+# Cache Support
+#
+CONFIG_BFIN_ICACHE=y
+CONFIG_BFIN_DCACHE=y
+# CONFIG_BFIN_DCACHE_BANKA is not set
+CONFIG_BFIN_ICACHE_LOCK=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
+CONFIG_L1_MAX_PIECE=16
+
+#
+# Asynchonous Memory Configuration
+#
+
+#
+# EBIU_AMGCTL Global Control
+#
+CONFIG_C_AMCKEN=y
+CONFIG_C_CDPRIO=y
+# CONFIG_C_AMBEN is not set
+# CONFIG_C_AMBEN_B0 is not set
+# CONFIG_C_AMBEN_B0_B1 is not set
+# CONFIG_C_AMBEN_B0_B1_B2 is not set
+CONFIG_C_AMBEN_ALL=y
+
+#
+# EBIU_AMBCTL Control
+#
+CONFIG_BANK_0=0x7BB0
+CONFIG_BANK_1=0x7BB0
+CONFIG_BANK_2=0x7BB0
+CONFIG_BANK_3=0x99B3
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+
+#
+# PCCARD (PCMCIA/CardBus) support
+#
+# CONFIG_PCCARD is not set
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF_FDPIC=y
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+# CONFIG_BINFMT_SHARED_FLAT is not set
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+CONFIG_PM=y
+CONFIG_PM_LEGACY=y
+# CONFIG_PM_DEBUG is not set
+# CONFIG_PM_SYSFS_DEPRECATED is not set
+CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
+# CONFIG_PM_WAKEUP_BY_GPIO is not set
+# CONFIG_PM_WAKEUP_GPIO_API is not set
+CONFIG_PM_WAKEUP_SIC_IWR=0x100000
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+# CONFIG_IP_PNP_DHCP is not set
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETLABEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+CONFIG_IRDA=m
+
+#
+# IrDA protocols
+#
+CONFIG_IRLAN=m
+CONFIG_IRCOMM=m
+# CONFIG_IRDA_ULTRA is not set
+
+#
+# IrDA options
+#
+CONFIG_IRDA_CACHE_LAST_LSAP=y
+# CONFIG_IRDA_FAST_RR is not set
+# CONFIG_IRDA_DEBUG is not set
+
+#
+# Infrared-port device drivers
+#
+
+#
+# SIR device drivers
+#
+CONFIG_IRTTY_SIR=m
+
+#
+# Dongle support
+#
+# CONFIG_DONGLE is not set
+
+#
+# Old SIR device drivers
+#
+# CONFIG_IRPORT_SIR is not set
+
+#
+# Old Serial dongle support
+#
+
+#
+# FIR device drivers
+#
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+# CONFIG_MTD_CFI is not set
+# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+CONFIG_MTD_RAM=y
+CONFIG_MTD_ROM=y
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_BF5xx is not set
+# CONFIG_MTD_UCLINUX is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_DATAFLASH is not set
+CONFIG_MTD_M25P80=y
+CONFIG_M25PXX_USE_FAST_READ=y
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+
+#
+# Parallel port support
+#
+# CONFIG_PARPORT is not set
+
+#
+# Plug and Play support
+#
+# CONFIG_PNPACPI is not set
+
+#
+# Block devices
+#
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# Misc devices
+#
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+
+#
+# Multi-device support (RAID and LVM)
+#
+# CONFIG_MD is not set
+
+#
+# Network device support
+#
+CONFIG_NETDEVICES=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_PHYLIB is not set
+
+#
+# Ethernet (10 or 100Mbit)
+#
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_SMC91X is not set
+# CONFIG_SMSC911X is not set
+CONFIG_DM9000=y
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+
+#
+# ISDN subsystem
+#
+# CONFIG_ISDN is not set
+
+#
+# Telephony Support
+#
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+CONFIG_INPUT_EVDEV=m
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+CONFIG_INPUT_MISC=y
+# CONFIG_INPUT_ATI_REMOTE is not set
+# CONFIG_INPUT_ATI_REMOTE2 is not set
+# CONFIG_INPUT_KEYSPAN_REMOTE is not set
+# CONFIG_INPUT_POWERMATE is not set
+# CONFIG_INPUT_YEALINK is not set
+# CONFIG_INPUT_UINPUT is not set
+# CONFIG_BF53X_PFBUTTONS is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_AD9960 is not set
+# CONFIG_SPI_ADC_BF533 is not set
+CONFIG_BF5xx_PFLAGS=y
+# CONFIG_BF5xx_PFLAGS_PROC is not set
+# CONFIG_BF5xx_PPIFCD is not set
+CONFIG_BFIN_SIMPLE_TIMER=y
+# CONFIG_BF5xx_PPI is not set
+CONFIG_BFIN_SPORT=y
+CONFIG_BFIN_TIMER_LATENCY=y
+# CONFIG_AD5304 is not set
+# CONFIG_BF5xx_FBDMA is not set
+# CONFIG_VT is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_BFIN=y
+CONFIG_SERIAL_BFIN_CONSOLE=y
+CONFIG_SERIAL_BFIN_DMA=y
+# CONFIG_SERIAL_BFIN_PIO is not set
+CONFIG_SERIAL_BFIN_UART0=y
+# CONFIG_BFIN_UART0_CTSRTS is not set
+# CONFIG_SERIAL_BFIN_UART1 is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_BFIN_SPORT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+
+#
+# CAN, the car bus and industrial fieldbus
+#
+# CONFIG_CAN4LINUX is not set
+
+#
+# IPMI
+#
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+# CONFIG_BFIN_WDT is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_GEN_RTC is not set
+CONFIG_BLACKFIN_DPMC=y
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+
+#
+# TPM devices
+#
+# CONFIG_TCG_TPM is not set
+# CONFIG_I2C is not set
+
+#
+# SPI support
+#
+CONFIG_SPI=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+CONFIG_SPI_AT25=y
+CONFIG_SPI_SPIDEV=y
+
+#
+# Dallas's 1-wire bus
+#
+# CONFIG_W1 is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+CONFIG_DAB=y
+
+#
+# Graphics support
+#
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_VGASTATE is not set
+# CONFIG_FB is not set
+
+#
+# Sound
+#
+CONFIG_SOUND=m
+
+#
+# Advanced Linux Sound Architecture
+#
+CONFIG_SND=m
+CONFIG_SND_TIMER=m
+CONFIG_SND_PCM=m
+# CONFIG_SND_SEQUENCER is not set
+CONFIG_SND_OSSEMUL=y
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+CONFIG_SND_PCM_OSS_PLUGINS=y
+# CONFIG_SND_DYNAMIC_MINORS is not set
+CONFIG_SND_SUPPORT_OLD_API=y
+CONFIG_SND_VERBOSE_PROCFS=y
+# CONFIG_SND_VERBOSE_PRINTK is not set
+# CONFIG_SND_DEBUG is not set
+
+#
+# Generic devices
+#
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
+# ALSA Blackfin devices
+#
+CONFIG_SND_BLACKFIN_AD1836=m
+CONFIG_SND_BLACKFIN_AD1836_TDM=y
+# CONFIG_SND_BLACKFIN_AD1836_I2S is not set
+CONFIG_SND_BLACKFIN_AD1836_MULSUB=y
+# CONFIG_SND_BLACKFIN_AD1836_5P1 is not set
+CONFIG_SND_BLACKFIN_SPORT=0
+CONFIG_SND_BLACKFIN_SPI_PFBIT=4
+# CONFIG_SND_BFIN_AD73311 is not set
+
+#
+# System on Chip audio support
+#
+# CONFIG_SND_SOC is not set
+
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
+
+#
+# HID Devices
+#
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+
+#
+# USB support
+#
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+# CONFIG_USB is not set
+
+#
+# Enable Host or Gadget support to see Inventra options
+#
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
+# USB Gadget Support
+#
+# CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
+# InfiniBand support
+#
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+CONFIG_RTC_INTF_DEV_UIE_EMUL=y
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+
+#
+# SPI RTC drivers
+#
+# CONFIG_RTC_DRV_RS5C348 is not set
+# CONFIG_RTC_DRV_MAX6902 is not set
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_BFIN=y
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
+
+#
+# PBX support
+#
+# CONFIG_PBX is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+# CONFIG_EXT2_FS_POSIX_ACL is not set
+# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_YAFFS_FS is not set
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Network File Systems
+#
+CONFIG_NFS_FS=m
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=m
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=m
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+
+#
+# Native Language Support
+#
+CONFIG_NLS=m
+CONFIG_NLS_DEFAULT="iso8859-1"
+# CONFIG_NLS_CODEPAGE_437 is not set
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_UTF8 is not set
+
+#
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
+# Profiling support
+#
+# CONFIG_PROFILING is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_MMRS is not set
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
+CONFIG_DEBUG_BFIN_HWTRACE_ON=y
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_TWO is not set
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION=0
+# CONFIG_DEBUG_BFIN_HWTRACE_EXPAND is not set
+# CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
+# CONFIG_EARLY_PRINTK is not set
+CONFIG_CPLB_INFO=y
+CONFIG_ACCESS_CHECK=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+CONFIG_SECURITY=y
+# CONFIG_SECURITY_NETWORK is not set
+CONFIG_SECURITY_CAPABILITIES=y
+
+#
+# Cryptographic options
+#
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_CRC_CCITT=m
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 3d403e0..25709f5 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.12
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -8,7 +8,6 @@ CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
 CONFIG_ZONE_DMA=y
-CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
@@ -18,7 +17,6 @@ CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -62,7 +60,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=9
@@ -115,6 +112,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
@@ -123,10 +123,12 @@ CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_BF537=y
 # CONFIG_BF542 is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
 # CONFIG_BF548 is not set
 # CONFIG_BF549 is not set
 # CONFIG_BF561 is not set
 # CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
 CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
@@ -135,33 +137,8 @@ CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
 CONFIG_BFIN_SINGLE_CORE=y
-# CONFIG_BFIN533_EZKIT is not set
-# CONFIG_BFIN533_STAMP is not set
-# CONFIG_BFIN537_STAMP is not set
-# CONFIG_BFIN533_BLUETECHNIX_CM is not set
-# CONFIG_BFIN537_BLUETECHNIX_CM is not set
-# CONFIG_BFIN548_EZKIT is not set
-# CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_BFIN561_EZKIT is not set
-# CONFIG_BFIN561_TEPLA is not set
-CONFIG_PNAV10=y
-# CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC32M8A2_75=y
 CONFIG_IRQ_PLL_WAKEUP=7
-
-#
-# BF537 Specific Configuration
-#
-
-#
-# Interrupt Priority Assignment
-#
-
-#
-# Priority
-#
-CONFIG_IRQ_DMA_ERROR=7
-CONFIG_IRQ_ERROR=7
 CONFIG_IRQ_RTC=8
 CONFIG_IRQ_PPI=8
 CONFIG_IRQ_SPORT0_RX=9
@@ -174,8 +151,6 @@ CONFIG_IRQ_UART0_RX=10
 CONFIG_IRQ_UART0_TX=10
 CONFIG_IRQ_UART1_RX=10
 CONFIG_IRQ_UART1_TX=10
-CONFIG_IRQ_CAN_RX=11
-CONFIG_IRQ_CAN_TX=11
 CONFIG_IRQ_MAC_RX=11
 CONFIG_IRQ_MAC_TX=11
 CONFIG_IRQ_TMR0=12
@@ -186,11 +161,31 @@ CONFIG_IRQ_TMR4=12
 CONFIG_IRQ_TMR5=12
 CONFIG_IRQ_TMR6=12
 CONFIG_IRQ_TMR7=12
-CONFIG_IRQ_PROG_INTA=12
 CONFIG_IRQ_PORTG_INTB=12
 CONFIG_IRQ_MEM_DMA0=13
 CONFIG_IRQ_MEM_DMA1=13
 CONFIG_IRQ_WATCH=13
+# CONFIG_BFIN537_STAMP is not set
+# CONFIG_BFIN537_BLUETECHNIX_CM is not set
+CONFIG_PNAV10=y
+# CONFIG_GENERIC_BF537_BOARD is not set
+
+#
+# BF537 Specific Configuration
+#
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_IRQ_DMA_ERROR=7
+CONFIG_IRQ_ERROR=7
+CONFIG_IRQ_CAN_RX=11
+CONFIG_IRQ_CAN_TX=11
+CONFIG_IRQ_PROG_INTA=12
 
 #
 # Board customizations
@@ -204,7 +199,7 @@ CONFIG_CLKIN_HZ=24576000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MAX_SCLK_HZ=133000000
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -261,6 +256,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -282,7 +278,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 CONFIG_C_CDPRIO=y
@@ -593,6 +589,7 @@ CONFIG_BFIN_MAC_RMII=y
 # CONFIG_DM9000 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
+# CONFIG_AX88180 is not set
 
 #
 # Wireless LAN
@@ -675,9 +672,9 @@ CONFIG_INPUT_UINPUT=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
@@ -897,6 +894,7 @@ CONFIG_FB_BF537_LQ035=y
 CONFIG_LQ035_SLAVE_ADDR=0x58
 CONFIG_FB_BFIN_LANDSCAPE=y
 # CONFIG_FB_BFIN_BGR is not set
+# CONFIG_FB_BFIN_T350MCQB is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_LOGO is not set
@@ -939,11 +937,6 @@ CONFIG_SND=m
 # CONFIG_SND_SOC is not set
 
 #
-# SoC Audio for the ADI Blackfin
-#
-# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
-
-#
 # Open Sound System
 #
 CONFIG_SOUND_PRIME=y
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 503eef4..b544460 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -436,6 +436,7 @@ unsigned long get_dma_curr_desc_ptr(unsigned int channel)
 
 	return dma_ch[channel].regs->curr_desc_ptr;
 }
+EXPORT_SYMBOL(get_dma_curr_desc_ptr);
 
 unsigned long get_dma_curr_addr(unsigned int channel)
 {
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 2198afe..0bfbb26 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -37,9 +37,6 @@
 /* platform dependent support */
 
 EXPORT_SYMBOL(__ioremap);
-EXPORT_SYMBOL(strcmp);
-EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(dump_thread);
 
 EXPORT_SYMBOL(ip_fast_csum);
 
@@ -51,6 +48,7 @@ EXPORT_SYMBOL(__down_trylock);
 EXPORT_SYMBOL(__down_interruptible);
 
 EXPORT_SYMBOL(is_in_rom);
+EXPORT_SYMBOL(bfin_return_from_exception);
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy);
@@ -60,13 +58,11 @@ EXPORT_SYMBOL(csum_partial_copy);
  * their interface isn't gonna change any time soon now, so
  * it's OK to leave it out of version control.
  */
-EXPORT_SYMBOL(strcpy);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcmp);
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memchr);
-EXPORT_SYMBOL(get_wchan);
 
 /*
  * libgcc functions - functions that are used internally by the
@@ -102,6 +98,7 @@ EXPORT_SYMBOL(outsw);
 EXPORT_SYMBOL(insw);
 EXPORT_SYMBOL(outsl);
 EXPORT_SYMBOL(insl);
+EXPORT_SYMBOL(insl_16);
 EXPORT_SYMBOL(irq_flags);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(blackfin_dcache_invalidate_range);
diff --git a/arch/blackfin/kernel/cplbinit.c b/arch/blackfin/kernel/cplbinit.c
index f2db6a5..6320bc4 100644
--- a/arch/blackfin/kernel/cplbinit.c
+++ b/arch/blackfin/kernel/cplbinit.c
@@ -26,29 +26,22 @@
 #include <asm/cplb.h>
 #include <asm/cplbinit.h>
 
-u_long icplb_table[MAX_CPLBS+1];
-u_long dcplb_table[MAX_CPLBS+1];
+u_long icplb_table[MAX_CPLBS + 1];
+u_long dcplb_table[MAX_CPLBS + 1];
 
 #ifdef CONFIG_CPLB_SWITCH_TAB_L1
-u_long ipdt_table[MAX_SWITCH_I_CPLBS+1]__attribute__((l1_data));
-u_long dpdt_table[MAX_SWITCH_D_CPLBS+1]__attribute__((l1_data));
-
-#ifdef CONFIG_CPLB_INFO
-u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS]__attribute__((l1_data));
-u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS]__attribute__((l1_data));
-#endif /* CONFIG_CPLB_INFO */
-
+# define PDT_ATTR __attribute__((l1_data))
 #else
+# define PDT_ATTR
+#endif
 
-u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
-u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
+u_long ipdt_table[MAX_SWITCH_I_CPLBS + 1] PDT_ATTR;
+u_long dpdt_table[MAX_SWITCH_D_CPLBS + 1] PDT_ATTR;
 
 #ifdef CONFIG_CPLB_INFO
-u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
-u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
-#endif /* CONFIG_CPLB_INFO */
-
-#endif /*CONFIG_CPLB_SWITCH_TAB_L1*/
+u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS] PDT_ATTR;
+u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS] PDT_ATTR;
+#endif
 
 struct s_cplb {
 	struct cplb_tab init_i;
@@ -71,7 +64,7 @@ static struct cplb_desc cplb_data[] = {
 #else
 		.valid = 0,
 #endif
-		.name = "ZERO Pointer Saveguard",
+		.name = "Zero Pointer Guard Page",
 	},
 	{
 		.start = L1_CODE_START,
@@ -102,20 +95,20 @@ static struct cplb_desc cplb_data[] = {
 		.end = 0,  /* dynamic */
 		.psize = 0,
 		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DGENERIC,
+		.i_conf = SDRAM_IGENERIC,
+		.d_conf = SDRAM_DGENERIC,
 		.valid = 1,
-		.name = "SDRAM Kernel",
+		.name = "Kernel Memory",
 	},
 	{
 		.start = 0, /* dynamic */
 		.end = 0, /* dynamic */
 		.psize = 0,
 		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DNON_CHBL,
+		.i_conf = SDRAM_IGENERIC,
+		.d_conf = SDRAM_DNON_CHBL,
 		.valid = 1,
-		.name = "SDRAM RAM MTD",
+		.name = "uClinux MTD Memory",
 	},
 	{
 		.start = 0, /* dynamic */
@@ -124,7 +117,7 @@ static struct cplb_desc cplb_data[] = {
 		.attr = INITIAL_T | SWITCH_T | D_CPLB,
 		.d_conf = SDRAM_DNON_CHBL,
 		.valid = 1,
-		.name = "SDRAM Uncached DMA ZONE",
+		.name = "Uncached DMA Zone",
 	},
 	{
 		.start = 0, /* dynamic */
@@ -134,7 +127,7 @@ static struct cplb_desc cplb_data[] = {
 		.i_conf = 0, /* dynamic */
 		.d_conf = 0, /* dynamic */
 		.valid = 1,
-		.name = "SDRAM Reserved Memory",
+		.name = "Reserved Memory",
 	},
 	{
 		.start = ASYNC_BANK0_BASE,
@@ -143,14 +136,14 @@ static struct cplb_desc cplb_data[] = {
 		.attr = SWITCH_T | D_CPLB,
 		.d_conf = SDRAM_EBIU,
 		.valid = 1,
-		.name = "ASYNC Memory",
+		.name = "Asynchronous Memory Banks",
 	},
 	{
-#if defined(CONFIG_BF561)
-		.start = L2_SRAM,
-		.end = L2_SRAM_END,
+#ifdef L2_START
+		.start = L2_START,
+		.end = L2_START + L2_LENGTH,
 		.psize = SIZE_1M,
-		.attr = SWITCH_T | D_CPLB,
+		.attr = SWITCH_T | I_CPLB | D_CPLB,
 		.i_conf = L2_MEMORY,
 		.d_conf = L2_MEMORY,
 		.valid = 1,
@@ -158,13 +151,23 @@ static struct cplb_desc cplb_data[] = {
 		.valid = 0,
 #endif
 		.name = "L2 Memory",
-	}
+	},
+	{
+		.start = BOOT_ROM_START,
+		.end = BOOT_ROM_START + BOOT_ROM_LENGTH,
+		.psize = SIZE_1M,
+		.attr = SWITCH_T | I_CPLB | D_CPLB,
+		.i_conf = SDRAM_IGENERIC,
+		.d_conf = SDRAM_DGENERIC,
+		.valid = 1,
+		.name = "On-Chip BootROM",
+	},
 };
 
 static u16 __init lock_kernel_check(u32 start, u32 end)
 {
-	if ((start <= (u32) _stext && end >= (u32) _end)
-	    || (start >= (u32) _stext && end <= (u32) _end))
+	if ((end   <= (u32) _end && end   >= (u32)_stext) ||
+	    (start <= (u32) _end && start >= (u32)_stext))
 		return IN_KERNEL;
 	return 0;
 }
@@ -350,7 +353,7 @@ void __init generate_cpl_tables(void)
 	else
 		cplb_data[RES_MEM].i_conf = SDRAM_INON_CHBL;
 
-	for (i = ZERO_P; i <= L2_MEM; i++) {
+	for (i = ZERO_P; i < ARRAY_SIZE(cplb_data); ++i) {
 		if (!cplb_data[i].valid)
 			continue;
 
diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 6ec518a..724f4a5 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -205,7 +205,8 @@ asmlinkage void __init early_trap_c(struct pt_regs *fp, void *retaddr)
 	if (likely(early_console == NULL))
 		setup_early_printk(DEFAULT_EARLY_PORT);
 
-	dump_bfin_regs(fp, retaddr);
+	dump_bfin_mem((void *)fp->retx);
+	show_regs(fp);
 	dump_bfin_trace_buffer();
 
 	panic("Died early");
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9124467..5bf1512 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -134,27 +134,6 @@ void cpu_idle(void)
 	}
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	printk(KERN_NOTICE "\n");
-	printk(KERN_NOTICE
-	       "PC: %08lu  Status: %04lu  SysStatus: %04lu  RETS: %08lu\n",
-	       regs->pc, regs->astat, regs->seqstat, regs->rets);
-	printk(KERN_NOTICE
-	       "A0.x: %08lx  A0.w: %08lx  A1.x: %08lx  A1.w: %08lx\n",
-	       regs->a0x, regs->a0w, regs->a1x, regs->a1w);
-	printk(KERN_NOTICE "P0: %08lx  P1: %08lx  P2: %08lx  P3: %08lx\n",
-	       regs->p0, regs->p1, regs->p2, regs->p3);
-	printk(KERN_NOTICE "P4: %08lx  P5: %08lx\n", regs->p4, regs->p5);
-	printk(KERN_NOTICE "R0: %08lx  R1: %08lx  R2: %08lx  R3: %08lx\n",
-	       regs->r0, regs->r1, regs->r2, regs->r3);
-	printk(KERN_NOTICE "R4: %08lx  R5: %08lx  R6: %08lx  R7: %08lx\n",
-	       regs->r4, regs->r5, regs->r6, regs->r7);
-
-	if (!regs->ipend)
-		printk(KERN_NOTICE "USP: %08lx\n", rdusp());
-}
-
 /* Fill in the fpu structure for a core dump.  */
 
 int dump_fpu(struct pt_regs *regs, elf_fpregset_t * fpregs)
@@ -239,51 +218,6 @@ copy_thread(int nr, unsigned long clone_flags,
 }
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs *regs, struct user *dump)
-{
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long)current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long)(current->mm->brk +
-					 (PAGE_SIZE - 1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize =
-		    ((unsigned long)(TASK_SIZE -
-				     dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
-
-	dump->regs.r0 = regs->r0;
-	dump->regs.r1 = regs->r1;
-	dump->regs.r2 = regs->r2;
-	dump->regs.r3 = regs->r3;
-	dump->regs.r4 = regs->r4;
-	dump->regs.r5 = regs->r5;
-	dump->regs.r6 = regs->r6;
-	dump->regs.r7 = regs->r7;
-	dump->regs.p0 = regs->p0;
-	dump->regs.p1 = regs->p1;
-	dump->regs.p2 = regs->p2;
-	dump->regs.p3 = regs->p3;
-	dump->regs.p4 = regs->p4;
-	dump->regs.p5 = regs->p5;
-	dump->regs.orig_p0 = regs->orig_p0;
-	dump->regs.a0w = regs->a0w;
-	dump->regs.a1w = regs->a1w;
-	dump->regs.a0x = regs->a0x;
-	dump->regs.a1x = regs->a1x;
-	dump->regs.rets = regs->rets;
-	dump->regs.astat = regs->astat;
-	dump->regs.pc = regs->pc;
-}
-
-/*
  * sys_execve() executes a new program.
  */
 
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 934234f..d282201 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
 #include <asm/cplbinit.h>
+#include <asm/div64.h>
 #include <asm/fixed_code.h>
 #include <asm/early_printk.h>
 
@@ -504,13 +505,17 @@ EXPORT_SYMBOL(get_sclk);
 
 unsigned long sclk_to_usecs(unsigned long sclk)
 {
-	return (USEC_PER_SEC * (u64)sclk) / get_sclk();
+	u64 tmp = USEC_PER_SEC * (u64)sclk;
+	do_div(tmp, get_sclk());
+	return tmp;
 }
 EXPORT_SYMBOL(sclk_to_usecs);
 
 unsigned long usecs_to_sclk(unsigned long usecs)
 {
-	return (get_sclk() * (u64)usecs) / USEC_PER_SEC;
+	u64 tmp = get_sclk() * (u64)usecs;
+	do_div(tmp, USEC_PER_SEC);
+	return tmp;
 }
 EXPORT_SYMBOL(usecs_to_sclk);
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index cfa0543..21a55ef 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -158,7 +158,7 @@ static void decode_address(char *buf, unsigned long address)
 	}
 
 	/* we were unable to find this address anywhere */
-	sprintf(buf, "[<0x%p>]", (void *)address);
+	sprintf(buf, "<0x%p> /* unknown address */", (void *)address);
 
 done:
 	write_unlock_irqrestore(&tasklist_lock, flags);
@@ -169,7 +169,9 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 	console_verbose();
 	oops_in_progress = 1;
 	printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
-	dump_bfin_regs(fp, (void *)fp->retx);
+	dump_bfin_process(fp);
+	dump_bfin_mem((void *)fp->retx);
+	show_regs(fp);
 	panic("Double Fault - unrecoverable event\n");
 
 }
@@ -250,7 +252,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_EXCPT03:
 		info.si_code = SEGV_STACKFLOW;
 		sig = SIGSEGV;
-		printk(KERN_NOTICE EXC_0x03);
+		printk(KERN_NOTICE EXC_0x03(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x04 - User Defined, Caught by default */
@@ -279,7 +281,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_OVFLOW:
 		info.si_code = TRAP_TRACEFLOW;
 		sig = SIGTRAP;
-		printk(KERN_NOTICE EXC_0x11);
+		printk(KERN_NOTICE EXC_0x11(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x12 - Reserved, Caught by default */
@@ -301,36 +303,35 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_UNDEF_I:
 		info.si_code = ILL_ILLOPC;
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x21);
+		printk(KERN_NOTICE EXC_0x21(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x22 - Illegal Instruction Combination, handled here */
 	case VEC_ILGAL_I:
 		info.si_code = ILL_ILLPARAOP;
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x22);
+		printk(KERN_NOTICE EXC_0x22(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
-	/* 0x23 - Data CPLB Protection Violation,
-		 normal case is handled in _cplb_hdr */
+	/* 0x23 - Data CPLB protection violation, handled here */
 	case VEC_CPLB_VL:
 		info.si_code = ILL_CPLB_VI;
-		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x23);
+		sig = SIGBUS;
+		printk(KERN_NOTICE EXC_0x23(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x24 - Data access misaligned, handled here */
 	case VEC_MISALI_D:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_NOTICE EXC_0x24);
+		printk(KERN_NOTICE EXC_0x24(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x25 - Unrecoverable Event, handled here */
 	case VEC_UNCOV:
 		info.si_code = ILL_ILLEXCPT;
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x25);
+		printk(KERN_NOTICE EXC_0x25(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x26 - Data CPLB Miss, normal case is handled in _cplb_hdr,
@@ -338,7 +339,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_CPLB_M:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_NOTICE EXC_0x26);
+		printk(KERN_NOTICE EXC_0x26(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero, handled here */
@@ -349,7 +350,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		printk(KERN_NOTICE "NULL pointer access (probably)\n");
 #else
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x27);
+		printk(KERN_NOTICE EXC_0x27(KERN_NOTICE));
 #endif
 		CHK_DEBUGGER_TRAP();
 		break;
@@ -357,7 +358,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_WATCH:
 		info.si_code = TRAP_WATCHPT;
 		sig = SIGTRAP;
-		pr_debug(EXC_0x28);
+		pr_debug(EXC_0x28(KERN_DEBUG));
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a watchpoint in kernel space */
 		if (fp->ipend & 0xffc0)
@@ -379,22 +380,21 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_MISALI_I:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_NOTICE EXC_0x2A);
+		printk(KERN_NOTICE EXC_0x2A(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
-	/* 0x2B - Instruction CPLB protection Violation,
-		handled in _cplb_hdr */
+	/* 0x2B - Instruction CPLB protection violation, handled here */
 	case VEC_CPLB_I_VL:
 		info.si_code = ILL_CPLB_VI;
-		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x2B);
+		sig = SIGBUS;
+		printk(KERN_NOTICE EXC_0x2B(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2C - Instruction CPLB miss, handled in _cplb_hdr */
 	case VEC_CPLB_I_M:
 		info.si_code = ILL_CPLB_MISS;
 		sig = SIGBUS;
-		printk(KERN_NOTICE EXC_0x2C);
+		printk(KERN_NOTICE EXC_0x2C(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2D - Instruction CPLB Multiple Hits, handled here */
@@ -405,7 +405,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		printk(KERN_NOTICE "Jump to address 0 - 0x0fff\n");
 #else
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x2D);
+		printk(KERN_NOTICE EXC_0x2D(KERN_NOTICE));
 #endif
 		CHK_DEBUGGER_TRAP();
 		break;
@@ -413,7 +413,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_ILL_RES:
 		info.si_code = ILL_PRVOPC;
 		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x2E);
+		printk(KERN_NOTICE EXC_0x2E(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2F - Reserved, Caught by default */
@@ -446,7 +446,9 @@ asmlinkage void trap_c(struct pt_regs *fp)
 
 	if (sig != SIGTRAP) {
 		unsigned long stack;
-		dump_bfin_regs(fp, (void *)fp->retx);
+		dump_bfin_process(fp);
+		dump_bfin_mem((void *)fp->retx);
+		show_regs(fp);
 
 		/* Print out the trace buffer if it makes sense */
 #ifndef CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE
@@ -460,22 +462,25 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		show_stack(current, &stack);
 		if (oops_in_progress) {
 #ifndef CONFIG_ACCESS_CHECK
-			printk(KERN_EMERG "Hey - dork - please turn on "
-				"CONFIG_ACCESS_CHECK\n");
+			printk(KERN_EMERG "Please turn on "
+			       "CONFIG_ACCESS_CHECK\n");
 #endif
 			panic("Kernel exception");
 		}
-
-		/* Ensure that bad return addresses don't end up in an infinite
-		 * loop, due to speculative loads/reads
-		 */
-		fp->pc = SAFE_USER_INSTRUCTION;
 	}
+
 	info.si_signo = sig;
 	info.si_errno = 0;
 	info.si_addr = (void *)fp->pc;
 	force_sig_info(sig, &info, current);
 
+	/* Ensure that bad return addresses don't end up in an infinite
+	 * loop, due to speculative loads/reads. This needs to be done after
+	 * the signal has been sent.
+	 */
+	if (trapnr == VEC_CPLB_I_M && sig != SIGTRAP)
+		fp->pc = SAFE_USER_INSTRUCTION;
+
 	trace_buffer_restore(j);
 	return;
 }
@@ -600,37 +605,48 @@ void dump_stack(void)
 	show_stack(current, &stack);
 	trace_buffer_restore(tflags);
 }
-
 EXPORT_SYMBOL(dump_stack);
 
-void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
+void dump_bfin_process(struct pt_regs *fp)
 {
-	char buf [150];
+	/* We should be able to look at fp->ipend, but we don't push it on the
+	 * stack all the time, so do this until we fix that */
+	unsigned int context = bfin_read_IPEND();
+
+	if (oops_in_progress)
+		printk(KERN_EMERG "Kernel OOPS in progress\n");
+
+	if (context & 0x0020)
+		printk(KERN_NOTICE "Deferred excecption or HW Error context\n");
+	else if (context & 0x3FC0)
+		printk(KERN_NOTICE "Interrupt context\n");
+	else if (context & 0x4000)
+		printk(KERN_NOTICE "Deferred Interrupt context\n");
+	else if (context & 0x8000)
+		printk(KERN_NOTICE "Kernel process context\n");
+
+	if (current->pid && current->mm) {
+		printk(KERN_NOTICE "CURRENT PROCESS:\n");
+		printk(KERN_NOTICE "COMM=%s PID=%d\n",
+			current->comm, current->pid);
+
+		printk(KERN_NOTICE "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
+			KERN_NOTICE "BSS = 0x%p-0x%p   USER-STACK = 0x%p\n"
+			KERN_NOTICE "\n",
+			(void *)current->mm->start_code,
+			(void *)current->mm->end_code,
+			(void *)current->mm->start_data,
+			(void *)current->mm->end_data,
+			(void *)current->mm->end_data,
+			(void *)current->mm->brk,
+			(void *)current->mm->start_stack);
+	} else
+		printk(KERN_NOTICE "\n" KERN_NOTICE
+		     "No Valid process in current context\n");
+}
 
-	if (!oops_in_progress) {
-		if (current->pid && current->mm) {
-			printk(KERN_NOTICE "\n" KERN_NOTICE "CURRENT PROCESS:\n");
-			printk(KERN_NOTICE "COMM=%s PID=%d\n",
-				current->comm, current->pid);
-
-			printk(KERN_NOTICE "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
-				KERN_NOTICE "BSS = 0x%p-0x%p   USER-STACK = 0x%p\n"
-				KERN_NOTICE "\n",
-				(void *)current->mm->start_code,
-				(void *)current->mm->end_code,
-				(void *)current->mm->start_data,
-				(void *)current->mm->end_data,
-				(void *)current->mm->end_data,
-				(void *)current->mm->brk,
-				(void *)current->mm->start_stack);
-		} else {
-			printk (KERN_NOTICE "\n" KERN_NOTICE
-			     "No Valid pid - Either things are really messed up,"
-			     " or you are in the kernel\n");
-		}
-	} else {
-		printk(KERN_NOTICE "Kernel or interrupt exception\n");
-	}
+void dump_bfin_mem(void *retaddr)
+{
 
 	if (retaddr >= (void *)FIXED_CODE_START  && retaddr < (void *)physical_mem_end
 #if L1_CODE_LENGTH != 0
@@ -671,8 +687,13 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 		printk("\n");
 	} else
 		printk("\n" KERN_NOTICE
-			"Cannot look at the [PC] for it is"
-			" in unreadable memory - sorry\n");
+			"Cannot look at the [PC] <%p> for it is"
+			" in unreadable memory - sorry\n", retaddr);
+}
+
+void show_regs(struct pt_regs *fp)
+{
+	char buf [150];
 
 	printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\n");
 	printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
@@ -686,6 +707,8 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 	printk(KERN_NOTICE " RETX: %s\n", buf);
 	decode_address(buf, fp->rets);
 	printk(KERN_NOTICE " RETS: %s\n", buf);
+	decode_address(buf, fp->pc);
+	printk(KERN_NOTICE " PC: %s\n", buf);
 
 	if ((long)fp->seqstat & SEQSTAT_EXCAUSE) {
 		decode_address(buf, bfin_read_DCPLB_FAULT_ADDR());
@@ -800,7 +823,9 @@ void panic_cplb_error(int cplb_panic, struct pt_regs *fp)
 
 	printk(KERN_EMERG "DCPLB_FAULT_ADDR=%p\n", (void *)bfin_read_DCPLB_FAULT_ADDR());
 	printk(KERN_EMERG "ICPLB_FAULT_ADDR=%p\n", (void *)bfin_read_ICPLB_FAULT_ADDR());
-	dump_bfin_regs(fp, (void *)fp->retx);
+	dump_bfin_process(fp);
+	dump_bfin_mem((void *)fp->retx);
+	show_regs(fp);
 	dump_stack();
 	panic("Unrecoverable event\n");
 }
diff --git a/arch/blackfin/lib/Makefile b/arch/blackfin/lib/Makefile
index bfdad52..635288f 100644
--- a/arch/blackfin/lib/Makefile
+++ b/arch/blackfin/lib/Makefile
@@ -4,7 +4,7 @@
 
 lib-y := \
 	ashldi3.o ashrdi3.o lshrdi3.o \
-	muldi3.o divsi3.o udivsi3.o udivdi3.o modsi3.o umodsi3.o \
+	muldi3.o divsi3.o udivsi3.o modsi3.o umodsi3.o \
 	checksum.o memcpy.o memset.o memcmp.o memchr.o memmove.o \
 	strcmp.o strcpy.o strncmp.o strncpy.o \
 	umulsi3_highpart.o smulsi3_highpart.o \
diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index a17cc77..df7b883 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -77,3 +77,22 @@ ENTRY(_insb)
 	sti R3;
 	RTS;
 ENDPROC(_insb)
+
+
+
+ENTRY(_insl_16)
+	P0 = R0;	/* P0 = port */
+	cli R3;
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Llong16_loop_s, .Llong16_loop_e) LC0 = P2;
+.Llong16_loop_s:  R0 = [P0];
+		  W[P1++] = R0;
+		  R0 = R0 >> 16;
+		  W[P1++] = R0;
+		  NOP;
+.Llong16_loop_e:  NOP;
+	sti R3;
+	RTS;
+ENDPROC(_insl_16)
diff --git a/arch/blackfin/lib/strcmp.c b/arch/blackfin/lib/strcmp.c
index 4eeefd8..fde39a1 100644
--- a/arch/blackfin/lib/strcmp.c
+++ b/arch/blackfin/lib/strcmp.c
@@ -1,10 +1,19 @@
-#include <linux/types.h>
+/*
+ * Provide symbol in case str func is not inlined.
+ *
+ * Copyright (c) 2006-2007 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
 
 #define strcmp __inline_strcmp
 #include <asm/string.h>
 #undef strcmp
 
+#include <linux/module.h>
+
 int strcmp(const char *dest, const char *src)
 {
 	return __inline_strcmp(dest, src);
 }
+EXPORT_SYMBOL(strcmp);
diff --git a/arch/blackfin/lib/strcpy.c b/arch/blackfin/lib/strcpy.c
index 534589d..2a8836b 100644
--- a/arch/blackfin/lib/strcpy.c
+++ b/arch/blackfin/lib/strcpy.c
@@ -1,10 +1,19 @@
-#include <linux/types.h>
+/*
+ * Provide symbol in case str func is not inlined.
+ *
+ * Copyright (c) 2006-2007 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
 
 #define strcpy __inline_strcpy
 #include <asm/string.h>
 #undef strcpy
 
+#include <linux/module.h>
+
 char *strcpy(char *dest, const char *src)
 {
 	return __inline_strcpy(dest, src);
 }
+EXPORT_SYMBOL(strcpy);
diff --git a/arch/blackfin/lib/strncmp.c b/arch/blackfin/lib/strncmp.c
index d791f12..2aaae78 100644
--- a/arch/blackfin/lib/strncmp.c
+++ b/arch/blackfin/lib/strncmp.c
@@ -1,10 +1,19 @@
-#include <linux/types.h>
+/*
+ * Provide symbol in case str func is not inlined.
+ *
+ * Copyright (c) 2006-2007 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
 
 #define strncmp __inline_strncmp
 #include <asm/string.h>
 #undef strncmp
 
+#include <linux/module.h>
+
 int strncmp(const char *cs, const char *ct, size_t count)
 {
 	return __inline_strncmp(cs, ct, count);
 }
+EXPORT_SYMBOL(strncmp);
diff --git a/arch/blackfin/lib/strncpy.c b/arch/blackfin/lib/strncpy.c
index 1fecb5c..ea1dc6b 100644
--- a/arch/blackfin/lib/strncpy.c
+++ b/arch/blackfin/lib/strncpy.c
@@ -1,10 +1,19 @@
-#include <linux/types.h>
+/*
+ * Provide symbol in case str func is not inlined.
+ *
+ * Copyright (c) 2006-2007 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
 
 #define strncpy __inline_strncpy
 #include <asm/string.h>
 #undef strncpy
 
+#include <linux/module.h>
+
 char *strncpy(char *dest, const char *src, size_t n)
 {
 	return __inline_strncpy(dest, src, n);
 }
+EXPORT_SYMBOL(strncpy);
diff --git a/arch/blackfin/lib/udivdi3.S b/arch/blackfin/lib/udivdi3.S
deleted file mode 100644
index ad1ebee..0000000
--- a/arch/blackfin/lib/udivdi3.S
+++ /dev/null
@@ -1,375 +0,0 @@
-/*
- * udivdi3.S - unsigned long long division
- *
- * Copyright 2003-2007 Analog Devices Inc.
- * Enter bugs at http://blackfin.uclinux.org/
- *
- * Licensed under the GPLv2 or later.
- */
-
-#include <linux/linkage.h>
-
-#define CARRY AC0
-
-#ifdef CONFIG_ARITHMETIC_OPS_L1
-.section .l1.text
-#else
-.text
-#endif
-
-
-ENTRY(___udivdi3)
-   R3 = [SP + 12];
-   [--SP] = (R7:4, P5:3);
-
-   /* Attempt to use divide primitive first; these will handle
-   **  most cases, and they're quick - avoids stalls incurred by
-   ** testing for identities.
-   */
-
-   R4 = R2 | R3;
-   CC = R4 == 0;
-   IF CC JUMP .LDIV_BY_ZERO;
-
-   R4.H = 0x8000;
-   R4 >>>= 16;                  // R4 now 0xFFFF8000
-   R5 = R0 | R2;                // If either dividend or
-   R4 = R5 & R4;                // divisor have bits in
-   CC = R4;                     // top half or low half's sign
-   IF CC JUMP .LIDENTS;          // bit, skip builtins.
-   R4 = R1 | R3;                // Also check top halves
-   CC = R4;
-   IF CC JUMP .LIDENTS;
-
-   /* Can use the builtins. */
-
-   AQ = CC;                     // Clear AQ (CC==0)
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   DIVQ(R0, R2);
-   R0 = R0.L (Z);
-   R1 = 0;
-   (R7:4, P5:3) = [SP++];
-   RTS;
-
-.LIDENTS:
-   /* Test for common identities. Value to be returned is
-   ** placed in R6,R7.
-   */
-                                // Check for 0/y, return 0
-   R4 = R0 | R1;
-   CC = R4 == 0;
-   IF CC JUMP .LRETURN_R0;
-
-                                // Check for x/x, return 1
-   R6 = R0 - R2;                // If x == y, then both R6 and R7 will be zero
-   R7 = R1 - R3;
-   R4 = R6 | R7;                // making R4 zero.
-   R6 += 1;                     // which would now make R6:R7==1.
-   CC = R4 == 0;
-   IF CC JUMP .LRETURN_IDENT;
-
-                                // Check for x/1, return x
-   R6 = R0;
-   R7 = R1;
-   CC = R3 == 0;
-   IF !CC JUMP .Lnexttest;
-   CC = R2 == 1;
-   IF CC JUMP .LRETURN_IDENT;
-
-.Lnexttest:
-   R4.L = ONES R2;              // check for div by power of two which
-   R5.L = ONES R3;              // can be done using a shift
-   R6 = PACK (R5.L, R4.L);
-   CC = R6 == 1;
-   IF CC JUMP .Lpower_of_two_upper_zero;
-   R6 = PACK (R4.L, R5.L);
-   CC = R6 == 1;
-   IF CC JUMP .Lpower_of_two_lower_zero;
-
-                                // Check for x < y, return 0
-   R6 = 0;
-   R7 = R6;
-   CC = R1 < R3 (IU);
-   IF CC JUMP .LRETURN_IDENT;
-   CC = R1 == R3;
-   IF !CC JUMP .Lno_idents;
-   CC = R0 < R2 (IU);
-   IF CC JUMP .LRETURN_IDENT;
-
-.Lno_idents:                    // Idents don't match. Go for the full operation
-
-
-   // If X, or X and Y have high bit set, it'll affect the
-   // results, so shift right one to stop this. Note: we've already
-   // checked that X >= Y, so Y's msb won't be set unless X's
-   // is.
-
-   R4 = 0;
-   CC = R1 < 0;
-   IF !CC JUMP .Lx_msb_clear;
-   CC = !CC;                   // 1 -> 0;
-   R1 = ROT R1 BY -1;          // Shift X >> 1
-   R0 = ROT R0 BY -1;          // lsb -> CC
-   BITSET(R4,31);              // to record only x msb was set
-   CC = R3 < 0;
-   IF !CC JUMP .Ly_msb_clear;
-   CC = !CC;
-   R3 = ROT R3 BY -1;          // Shift Y >> 1
-   R2 = ROT R2 BY -1;
-   BITCLR(R4,31);              // clear bit to record only x msb was set
-
-.Ly_msb_clear:
-.Lx_msb_clear:
-   // Bit 31 in R4 indicates X msb set, but Y msb wasn't, and no bits
-   // were lost, so we should shift result left by one.
-
-   [--SP] = R4;                // save for later
-
-   // In the loop that follows, each iteration we add
-   // either Y' or -Y' to the Remainder. We compute the
-   // negated Y', and store, for convenience. Y' goes
-   // into P0:P1, while -Y' goes into P2:P3.
-
-   P0 = R2;
-   P1 = R3;
-   R2 = -R2;
-   CC = CARRY;
-   CC = !CC;
-   R4 = CC;
-   R3 = -R3;
-   R3 = R3 - R4;
-
-   R6 = 0;                     // remainder = 0
-   R7 = R6;
-
-   [--SP] = R2; P2 = SP;
-   [--SP] = R3; P3 = SP;
-   [--SP] = R6; P5 = SP;       // AQ = 0
-   [--SP] = P1;
-
-   /* In the loop that follows, we use the following
-   ** register assignments:
-   ** R0,R1 X, workspace
-   ** R2,R3 Y, workspace
-   ** R4,R5 partial Div
-   ** R6,R7 partial remainder
-   ** P5 AQ
-   ** The remainder and div form a 128-bit number, with
-   ** the remainder in the high 64-bits.
-   */
-   R4 = R0;                    // Div = X'
-   R5 = R1;
-   R3 = 0;
-
-   P4 = 64;                    // Iterate once per bit
-   LSETUP(.LULST,.LULEND) LC0 = P4;
-.LULST:
-        /* Shift Div and remainder up by one. The bit shifted
-        ** out of the top of the quotient is shifted into the bottom
-        ** of the remainder.
-        */
-        CC = R3;
-        R4 = ROT R4 BY 1;
-        R5 = ROT R5 BY 1 ||        // low q to high q
-             R2 = [P5];            // load saved AQ
-        R6 = ROT R6 BY 1 ||        // high q to low r
-             R0 = [P2];            // load -Y'
-        R7 = ROT R7 BY 1 ||        // low r to high r
-             R1 = [P3];
-
-                                   // Assume add -Y'
-        CC = R2 < 0;               // But if AQ is set...
-        IF CC R0 = P0;             // then add Y' instead
-        IF CC R1 = P1;
-
-        R6 = R6 + R0;              // Rem += (Y' or -Y')
-        CC = CARRY;
-        R0 = CC;
-        R7 = R7 + R1;
-        R7 = R7 + R0 (NS) ||
-             R1 = [SP];
-                                   // Set the next AQ bit
-        R1 = R7 ^ R1;              // from Remainder and Y'
-        R1 = R1 >> 31 ||           // Negate AQ's value, and
-             [P5] = R1;            // save next AQ
-        BITTGL(R1, 0);             // add neg AQ  to the Div
-.LULEND: R4 = R4 + R1;
-
-   R6 = [SP + 16];
-
-   R0 = R4;
-   R1 = R5;
-   CC = BITTST(R6,30);         // Just set CC=0
-   R4 = ROT R0 BY 1;           // but if we had to shift X,
-   R5 = ROT R1 BY 1;           // and didn't shift any bits out,
-   CC = BITTST(R6,31);         // then the result will be half as
-   IF CC R0 = R4;              // much as required, so shift left
-   IF CC R1 = R5;              // one space.
-
-   SP += 20;
-   (R7:4, P5:3) = [SP++];
-   RTS;
-
-.Lpower_of_two:
-   /* Y has a single bit set, which means it's a power of two.
-   ** That means we can perform the division just by shifting
-   ** X to the right the appropriate number of bits
-   */
-
-   /* signbits returns the number of sign bits, minus one.
-   ** 1=>30, 2=>29, ..., 0x40000000=>0. Which means we need
-   ** to shift right n-signbits spaces. It also means 0x80000000
-   ** is a special case, because that *also* gives a signbits of 0
-   */
-.Lpower_of_two_lower_zero:
-   R7 = 0;
-   R6 = R1 >> 31;
-   CC = R3 < 0;
-   IF CC JUMP .LRETURN_IDENT;
-
-   R2.L = SIGNBITS R3;
-   R2 = R2.L (Z);
-   R2 += -62;
-   (R7:4, P5:3) = [SP++];
-   JUMP ___lshftli;
-
-.Lpower_of_two_upper_zero:
-   CC = R2 < 0;
-   IF CC JUMP .Lmaxint_shift;
-
-   R2.L = SIGNBITS R2;
-   R2 = R2.L (Z);
-   R2 += -30;
-   (R7:4, P5:3) = [SP++];
-   JUMP ___lshftli;
-
-.Lmaxint_shift:
-   R2 = -31;
-   (R7:4, P5:3) = [SP++];
-   JUMP ___lshftli;
-
-.LRETURN_IDENT:
-   R0 = R6;
-   R1 = R7;
-.LRETURN_R0:
-   (R7:4, P5:3) = [SP++];
-   RTS;
-.LDIV_BY_ZERO:
-   R0 = ~R2;
-   R1 = R0;
-   (R7:4, P5:3) = [SP++];
-   RTS;
-
-ENDPROC(___udivdi3)
-
-
-ENTRY(___lshftli)
-	CC = R2 == 0;
-	IF CC JUMP .Lfinished;	// nothing to do
-	CC = R2 < 0;
-	IF CC JUMP .Lrshift;
-	R3 = 64;
-	CC = R2 < R3;
-	IF !CC JUMP .Lretzero;
-
-	// We're shifting left, and it's less than 64 bits, so
-	// a valid result will be returned.
-
-	R3 >>= 1;	// R3 now 32
-	CC = R2 < R3;
-
-	IF !CC JUMP .Lzerohalf;
-
-	// We're shifting left, between 1 and 31 bits, which means
-	// some of the low half will be shifted into the high half.
-	// Work out how much.
-
-	R3 = R3 - R2;
-
-	// Save that much data from the bottom half.
-
-	P1 = R7;
-	R7 = R0;
-	R7 >>= R3;
-
-	// Adjust both parts of the parameter.
-
-	R0 <<= R2;
-	R1 <<= R2;
-
-	// And include the bits moved across.
-
-	R1 = R1 | R7;
-	R7 = P1;
-	RTS;
-
-.Lzerohalf:
-	// We're shifting left, between 32 and 63 bits, so the
-	// bottom half will become zero, and the top half will
-	// lose some bits. How many?
-
-	R2 = R2 - R3;	// N - 32
-	R1 = LSHIFT R0 BY R2.L;
-	R0 = R0 - R0;
-	RTS;
-
-.Lretzero:
-	R0 = R0 - R0;
-	R1 = R0;
-.Lfinished:
-	RTS;
-
-.Lrshift:
-	// We're shifting right, but by how much?
-	R2 = -R2;
-	R3 = 64;
-	CC = R2 < R3;
-	IF !CC JUMP .Lretzero;
-
-	// Shifting right less than 64 bits, so some result bits will
-	// be retained.
-
-	R3 >>= 1;	// R3 now 32
-	CC = R2 < R3;
-	IF !CC JUMP .Lsignhalf;
-
-	// Shifting right between 1 and 31 bits, so need to copy
-	// data across words.
-
-	P1 = R7;
-	R3 = R3 - R2;
-	R7 = R1;
-	R7 <<= R3;
-	R1 >>= R2;
-	R0 >>= R2;
-	R0 = R7 | R0;
-	R7 = P1;
-	RTS;
-
-.Lsignhalf:
-	// Shifting right between 32 and 63 bits, so the top half
-	// will become all zero-bits, and the bottom half is some
-	// of the top half. But how much?
-
-	R2 = R2 - R3;
-	R0 = R1;
-	R0 >>= R2;
-	R1 = 0;
-	RTS;
-
-ENDPROC(___lshftli)
diff --git a/arch/blackfin/mach-bf527/Kconfig b/arch/blackfin/mach-bf527/Kconfig
index 50321f7..5c73683 100644
--- a/arch/blackfin/mach-bf527/Kconfig
+++ b/arch/blackfin/mach-bf527/Kconfig
@@ -1,5 +1,7 @@
 if (BF52x)
 
+source "arch/blackfin/mach-bf527/boards/Kconfig"
+
 menu "BF527 Specific Configuration"
 
 comment "Alternative Multiplexing Scheme"
diff --git a/arch/blackfin/mach-bf527/boards/Kconfig b/arch/blackfin/mach-bf527/boards/Kconfig
new file mode 100644
index 0000000..6a570ad
--- /dev/null
+++ b/arch/blackfin/mach-bf527/boards/Kconfig
@@ -0,0 +1,12 @@
+choice
+	prompt "System type"
+	default BFIN527_EZKIT
+	help
+	  Select your board!
+
+config BFIN527_EZKIT
+	bool "BF527-EZKIT"
+	help
+	  BF527-EZKIT-LITE board support.
+
+endchoice
diff --git a/arch/blackfin/mach-bf527/boards/Makefile b/arch/blackfin/mach-bf527/boards/Makefile
index 912ac8e..7277d35 100644
--- a/arch/blackfin/mach-bf527/boards/Makefile
+++ b/arch/blackfin/mach-bf527/boards/Makefile
@@ -1,7 +1,5 @@
 #
-# arch/blackfin/mach-bf532/boards/Makefile
+# arch/blackfin/mach-bf527/boards/Makefile
 #
 
-obj-y					+= eth_mac.o
-obj-$(CONFIG_BFIN527_EZKIT)		+= ezkit.o
-
+obj-$(CONFIG_BFIN527_EZKIT)            += ezkit.o
diff --git a/arch/blackfin/mach-bf527/boards/eth_mac.c b/arch/blackfin/mach-bf527/boards/eth_mac.c
deleted file mode 100644
index a725cc8..0000000
--- a/arch/blackfin/mach-bf527/boards/eth_mac.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- *  arch/blackfin/mach-bf537/board/eth_mac.c
- *
- *  Copyright (C) 2007 Analog Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/module.h>
-#include <asm/blackfin.h>
-
-#if	defined(CONFIG_GENERIC_BOARD) || defined(CONFIG_BFIN537_STAMP)
-
-/*
- * Currently the MAC address is saved in Flash by U-Boot
- */
-#define FLASH_MAC	0x203f0000
-
-void get_bf537_ether_addr(char *addr)
-{
-	unsigned int flash_mac = (unsigned int) FLASH_MAC;
-	*(u32 *)(&(addr[0])) = bfin_read32(flash_mac);
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = bfin_read16(flash_mac);
-}
-
-#else
-
-/*
- * Provide MAC address function for other specific board setting
- */
-void get_bf537_ether_addr(char *addr)
-{
-	printk(KERN_WARNING "%s: No valid Ethernet MAC address found\n", __FILE__);
-}
-
-#endif
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index bf1bedc..003e2ac 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -35,17 +35,18 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/usb_sl811.h>
+#include <linux/usb/sl811.h>
 #include <asm/cplb.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
 #include <asm/nand.h>
+#include <asm/portmux.h>
 #include <linux/spi/ad7877.h>
 
 /*
@@ -450,6 +451,13 @@ static const struct ad7877_platform_data bfin_ad7877_ts_info = {
 };
 #endif
 
+#if defined(CONFIG_SND_SOC_WM8731) || defined(CONFIG_SND_SOC_WM8731_MODULE) \
+	 && defined(CONFIG_SND_SOC_WM8731_SPI)
+static struct bfin5xx_spi_chip spi_wm8731_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
@@ -551,17 +559,29 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.platform_data		= &bfin_ad7877_ts_info,
 		.irq			= IRQ_PF6,
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num	= 1,
+		.bus_num	= 0,
 		.chip_select  = 1,
 		.controller_data = &spi_ad7877_chip_info,
 	},
 #endif
+#if defined(CONFIG_SND_SOC_WM8731) || defined(CONFIG_SND_SOC_WM8731_MODULE) \
+	 && defined(CONFIG_SND_SOC_WM8731_SPI)
+	{
+		.modalias	= "wm8731",
+		.max_speed_hz	= 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num	= 0,
+		.chip_select    = 5,
+		.controller_data = &spi_wm8731_chip_info,
+		.mode = SPI_MODE_0,
+	},
+#endif
 };
 
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 /* SPI (0) */
@@ -788,3 +808,14 @@ void native_machine_restart(char *cmd)
 	if ((bfin_read_SYSCR() & 0x7) == 0x3)
 		bfin_gpio_reset_spi0_ssel1();
 }
+
+/*
+ * Currently the MAC address is saved in Flash by U-Boot
+ */
+#define FLASH_MAC	0x203f0000
+void bfin_get_ether_addr(char *addr)
+{
+	*(u32 *)(&(addr[0])) = bfin_read32(FLASH_MAC);
+	*(u16 *)(&(addr[4])) = bfin_read16(FLASH_MAC + 4);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf533/Kconfig b/arch/blackfin/mach-bf533/Kconfig
index 14297b3..76beb75 100644
--- a/arch/blackfin/mach-bf533/Kconfig
+++ b/arch/blackfin/mach-bf533/Kconfig
@@ -1,5 +1,7 @@
 if (BF533 || BF532 || BF531)
 
+source "arch/blackfin/mach-bf533/boards/Kconfig"
+
 menu "BF533/2/1 Specific Configuration"
 
 comment "Interrupt Priority Assignment"
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index b941550..6bcf404 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -36,20 +36,21 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
  */
 const char bfin_board_name[] = "HV Sistemas H8606";
 
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_BFIN_MODULE)
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
 	.id   = -1,
@@ -93,10 +94,6 @@ static struct resource smc91x_resources[] = {
 		.end = IRQ_PROG_INTB,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
 	}, {
-		/*
-		 *  denotes the flag pin and is used directly if
-		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
-		 */
 		.start = IRQ_PF7,
 		.end = IRQ_PF7,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
@@ -269,6 +266,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
@@ -342,4 +340,4 @@ static int __init H8606_init(void)
 	return 0;
 }
 
-arch_initcall(H8606_init);
\ No newline at end of file
+arch_initcall(H8606_init);
diff --git a/arch/blackfin/mach-bf533/boards/Kconfig b/arch/blackfin/mach-bf533/boards/Kconfig
new file mode 100644
index 0000000..751de51
--- /dev/null
+++ b/arch/blackfin/mach-bf533/boards/Kconfig
@@ -0,0 +1,34 @@
+choice
+	prompt "System type"
+	default BFIN533_STAMP
+	help
+	  Select your board!
+
+config BFIN533_EZKIT
+	bool "BF533-EZKIT"
+	help
+	  BF533-EZKIT-LITE board support.
+
+config BFIN533_STAMP
+	bool "BF533-STAMP"
+	help
+	  BF533-STAMP board support.
+
+config BFIN533_BLUETECHNIX_CM
+	bool "Bluetechnix CM-BF533"
+	depends on (BF533)
+	help
+	  CM-BF533 support for EVAL- and DEV-Board.
+
+config H8606_HVSISTEMAS
+	bool "HV Sistemas H8606"
+	depends on (BF532)
+	help
+	  HV Sistemas H8606 board support.
+
+config GENERIC_BF533_BOARD
+	bool "Generic"
+	help
+	  Generic or Custom board support.
+
+endchoice
diff --git a/arch/blackfin/mach-bf533/boards/Makefile b/arch/blackfin/mach-bf533/boards/Makefile
index 2452b45..54f57fb 100644
--- a/arch/blackfin/mach-bf533/boards/Makefile
+++ b/arch/blackfin/mach-bf533/boards/Makefile
@@ -2,7 +2,7 @@
 # arch/blackfin/mach-bf533/boards/Makefile
 #
 
-obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
+obj-$(CONFIG_GENERIC_BF533_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN533_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN533_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN533_BLUETECHNIX_CM)   += cm_bf533.o
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index a863522..21df2f3 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -33,11 +33,12 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -175,6 +176,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 34b6392..be85203 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -34,11 +34,12 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -187,6 +188,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
diff --git a/arch/blackfin/mach-bf533/boards/generic_board.c b/arch/blackfin/mach-bf533/boards/generic_board.c
index 310b777..e359a0d 100644
--- a/arch/blackfin/mach-bf533/boards/generic_board.c
+++ b/arch/blackfin/mach-bf533/boards/generic_board.c
@@ -58,10 +58,6 @@ static struct resource smc91x_resources[] = {
 		.end = IRQ_PROG_INTB,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
 	}, {
-		/*
-		 *  denotes the flag pin and is used directly if
-		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
-		 */
 		.start = IRQ_PF7,
 		.end = IRQ_PF7,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 62ffa50..8fde8d8 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -35,13 +35,14 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -286,6 +287,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
diff --git a/arch/blackfin/mach-bf537/Kconfig b/arch/blackfin/mach-bf537/Kconfig
index e6648db..8255374 100644
--- a/arch/blackfin/mach-bf537/Kconfig
+++ b/arch/blackfin/mach-bf537/Kconfig
@@ -1,5 +1,7 @@
 if (BF537 || BF534 || BF536)
 
+source "arch/blackfin/mach-bf537/boards/Kconfig"
+
 menu "BF537 Specific Configuration"
 
 comment "Interrupt Priority Assignment"
diff --git a/arch/blackfin/mach-bf537/boards/Kconfig b/arch/blackfin/mach-bf537/boards/Kconfig
new file mode 100644
index 0000000..96a1519
--- /dev/null
+++ b/arch/blackfin/mach-bf537/boards/Kconfig
@@ -0,0 +1,29 @@
+choice
+	prompt "System type"
+	default BFIN537_STAMP
+	help
+	  Select your board!
+
+config BFIN537_STAMP
+	bool "BF537-STAMP"
+	help
+	  BF537-STAMP board support.
+
+config BFIN537_BLUETECHNIX_CM
+	bool "Bluetechnix CM-BF537"
+	depends on (BF537)
+	help
+	  CM-BF537 support for EVAL- and DEV-Board.
+
+config PNAV10
+	bool "PNAV board"
+	depends on (BF537)
+	help
+	  PNAV board support.
+
+config GENERIC_BF537_BOARD
+	bool "Generic"
+	help
+	  Generic or Custom board support.
+
+endchoice
diff --git a/arch/blackfin/mach-bf537/boards/Makefile b/arch/blackfin/mach-bf537/boards/Makefile
index 23323ca..94a8517 100644
--- a/arch/blackfin/mach-bf537/boards/Makefile
+++ b/arch/blackfin/mach-bf537/boards/Makefile
@@ -2,8 +2,7 @@
 # arch/blackfin/mach-bf537/boards/Makefile
 #
 
-obj-y					+= eth_mac.o
-obj-$(CONFIG_GENERIC_BOARD)		+= generic_board.o
-obj-$(CONFIG_BFIN537_STAMP)		+= stamp.o led.o
-obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)	+= cm_bf537.o
-obj-$(CONFIG_PNAV10)			+= pnav10.o
+obj-$(CONFIG_GENERIC_BF537_BOARD)      += generic_board.o
+obj-$(CONFIG_BFIN537_STAMP)            += stamp.o led.o
+obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)   += cm_bf537.o
+obj-$(CONFIG_PNAV10)                   += pnav10.o
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 2915931..c0fb06d 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -34,11 +34,12 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -194,6 +195,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
@@ -425,3 +427,10 @@ static int __init cm_bf537_init(void)
 }
 
 arch_initcall(cm_bf537_init);
+
+void bfin_get_ether_addr(char *addr)
+{
+	random_ether_addr(addr);
+	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n", __FILE__, __func__);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf537/boards/eth_mac.c b/arch/blackfin/mach-bf537/boards/eth_mac.c
deleted file mode 100644
index a725cc8..0000000
--- a/arch/blackfin/mach-bf537/boards/eth_mac.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- *  arch/blackfin/mach-bf537/board/eth_mac.c
- *
- *  Copyright (C) 2007 Analog Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/module.h>
-#include <asm/blackfin.h>
-
-#if	defined(CONFIG_GENERIC_BOARD) || defined(CONFIG_BFIN537_STAMP)
-
-/*
- * Currently the MAC address is saved in Flash by U-Boot
- */
-#define FLASH_MAC	0x203f0000
-
-void get_bf537_ether_addr(char *addr)
-{
-	unsigned int flash_mac = (unsigned int) FLASH_MAC;
-	*(u32 *)(&(addr[0])) = bfin_read32(flash_mac);
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = bfin_read16(flash_mac);
-}
-
-#else
-
-/*
- * Provide MAC address function for other specific board setting
- */
-void get_bf537_ether_addr(char *addr)
-{
-	printk(KERN_WARNING "%s: No valid Ethernet MAC address found\n", __FILE__);
-}
-
-#endif
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 255da7a..09f4bfb 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -35,7 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
@@ -44,6 +44,7 @@
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
+#include <asm/portmux.h>
 #include <linux/spi/ad7877.h>
 
 /*
@@ -502,7 +503,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.platform_data		= &bfin_ad7877_ts_info,
 		.irq			= IRQ_PF6,
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num	= 1,
+		.bus_num	= 0,
 		.chip_select  = 1,
 		.controller_data = &spi_ad7877_chip_info,
 	},
@@ -513,6 +514,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 /* SPI (0) */
@@ -730,3 +732,10 @@ void native_machine_restart(char *cmd)
 	if ((bfin_read_SYSCR() & 0x7) == 0x3)
 		bfin_gpio_reset_spi0_ssel1();
 }
+
+void bfin_get_ether_addr(char *addr)
+{
+	random_ether_addr(addr);
+	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n", __FILE__, __func__);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 87b8089..fd5f4a6 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -35,11 +35,12 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 #include <linux/usb/sl811.h>
 
 #include <linux/spi/ad7877.h>
@@ -295,7 +296,7 @@ static struct bfin5xx_spi_chip spi_mmc_chip_info = {
 
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.cs_change_per_word = 1,
+	.cs_change_per_word = 0,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -387,7 +388,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	.platform_data		= &bfin_ad7877_ts_info,
 	.irq			= IRQ_PF2,
 	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
-	.bus_num		= 1,
+	.bus_num		= 0,
 	.chip_select  		= 5,
 	.controller_data = &spi_ad7877_chip_info,
 },
@@ -413,6 +414,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
@@ -508,3 +510,10 @@ static int __init stamp_init(void)
 }
 
 arch_initcall(stamp_init);
+
+void bfin_get_ether_addr(char *addr)
+{
+	random_ether_addr(addr);
+	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n", __FILE__, __func__);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 5f7b91f..07b0dc2 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -35,7 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #endif
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
@@ -44,6 +44,7 @@
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
+#include <asm/portmux.h>
 #include <linux/spi/ad7877.h>
 
 /*
@@ -182,6 +183,28 @@ static struct platform_device dm9000_device = {
 };
 #endif
 
+#if defined(CONFIG_AX88180) || defined(CONFIG_AX88180_MODULE)
+static struct resource ax88180_resources[] = {
+	[0] = {
+		.start	= 0x20300000,
+		.end	= 0x20300000 + 0x8000,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PF7,
+		.end	= IRQ_PF7,
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL),
+	},
+};
+
+static struct platform_device ax88180_device = {
+	.name		= "ax88180",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ax88180_resources),
+	.resource	= ax88180_resources,
+};
+#endif
+
 #if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
 static struct resource sl811_hcd_resources[] = {
 	{
@@ -502,7 +525,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.platform_data		= &bfin_ad7877_ts_info,
 		.irq			= IRQ_PF6,
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num	= 1,
+		.bus_num	= 0,
 		.chip_select  = 1,
 		.controller_data = &spi_ad7877_chip_info,
 	},
@@ -513,6 +536,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 /* SPI (0) */
@@ -554,15 +578,20 @@ static struct platform_device bfin_fb_adv7393_device = {
 
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
+#ifdef CONFIG_SERIAL_BFIN_UART0
 	{
 		.start = 0xFFC00400,
 		.end = 0xFFC004FF,
 		.flags = IORESOURCE_MEM,
-	}, {
+	},
+#endif
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	{
 		.start = 0xFFC02000,
 		.end = 0xFFC020FF,
 		.flags = IORESOURCE_MEM,
 	},
+#endif
 };
 
 static struct platform_device bfin_uart_device = {
@@ -669,6 +698,10 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&dm9000_device,
 #endif
 
+#if defined(CONFIG_AX88180) || defined(CONFIG_AX88180_MODULE)
+	&ax88180_device,
+#endif
+
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 	&bfin_mac_device,
 #endif
@@ -730,3 +763,14 @@ void native_machine_restart(char *cmd)
 	if ((bfin_read_SYSCR() & 0x7) == 0x3)
 		bfin_gpio_reset_spi0_ssel1();
 }
+
+/*
+ * Currently the MAC address is saved in Flash by U-Boot
+ */
+#define FLASH_MAC	0x203f0000
+void bfin_get_ether_addr(char *addr)
+{
+	*(u32 *)(&(addr[0])) = bfin_read32(FLASH_MAC);
+	*(u16 *)(&(addr[4])) = bfin_read16(FLASH_MAC + 4);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index 08d8dc8..d8bd3b4 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -1,5 +1,7 @@
 if (BF54x)
 
+source "arch/blackfin/mach-bf548/boards/Kconfig"
+
 menu "BF548 Specific Configuration"
 
 config DEB_DMA_URGENT
diff --git a/arch/blackfin/mach-bf548/boards/Kconfig b/arch/blackfin/mach-bf548/boards/Kconfig
new file mode 100644
index 0000000..0571290
--- /dev/null
+++ b/arch/blackfin/mach-bf548/boards/Kconfig
@@ -0,0 +1,12 @@
+choice
+	prompt "System type"
+	default BFIN548_EZKIT
+	help
+	  Select your board!
+
+config BFIN548_EZKIT
+	bool "BF548-EZKIT"
+	help
+	  BFIN548-EZKIT board support.
+
+endchoice
diff --git a/arch/blackfin/mach-bf548/boards/Makefile b/arch/blackfin/mach-bf548/boards/Makefile
index 486e07c..a444cc7 100644
--- a/arch/blackfin/mach-bf548/boards/Makefile
+++ b/arch/blackfin/mach-bf548/boards/Makefile
@@ -2,4 +2,4 @@
 # arch/blackfin/mach-bf548/boards/Makefile
 #
 
-obj-$(CONFIG_BFIN548_EZKIT)		+= ezkit.o led.o
+obj-$(CONFIG_BFIN548_EZKIT)            += ezkit.o led.o
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 6b6490e..d37d665 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -42,6 +42,7 @@
 #include <asm/dma.h>
 #include <asm/gpio.h>
 #include <asm/nand.h>
+#include <asm/portmux.h>
 #include <asm/mach/bf54x_keys.h>
 #include <linux/input.h>
 #include <linux/spi/ad7877.h>
@@ -377,7 +378,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.cs_change_per_word = 1,
+	.cs_change_per_word = 0,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -453,9 +454,10 @@ static struct resource bfin_spi1_resource[] = {
 };
 
 /* SPI controller data */
-static struct bfin5xx_spi_master bf54x_spi_master_info = {
+static struct bfin5xx_spi_master bf54x_spi_master_info0 = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bf54x_spi_master0 = {
@@ -464,17 +466,23 @@ static struct platform_device bf54x_spi_master0 = {
 	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
 	.resource = bfin_spi0_resource,
 	.dev = {
-		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		.platform_data = &bf54x_spi_master_info0, /* Passed to driver */
 		},
 };
 
+static struct bfin5xx_spi_master bf54x_spi_master_info1 = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
+};
+
 static struct platform_device bf54x_spi_master1 = {
 	.name = "bfin-spi",
 	.id = 1, /* Bus number */
 	.num_resources = ARRAY_SIZE(bfin_spi1_resource),
 	.resource = bfin_spi1_resource,
 	.dev = {
-		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		.platform_data = &bf54x_spi_master_info1, /* Passed to driver */
 		},
 };
 #endif  /* spi master and devices */
@@ -500,6 +508,7 @@ static struct platform_device i2c_bfin_twi0_device = {
 	.resource = bfin_twi0_resource,
 };
 
+#if !defined(CONFIG_BF542)	/* The BF542 only has 1 TWI */
 static struct resource bfin_twi1_resource[] = {
 	[0] = {
 		.start = TWI1_REGBASE,
@@ -520,6 +529,7 @@ static struct platform_device i2c_bfin_twi1_device = {
 	.resource = bfin_twi1_resource,
 };
 #endif
+#endif
 
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
@@ -569,8 +579,10 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 #if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
 	&i2c_bfin_twi0_device,
+#if !defined(CONFIG_BF542)
 	&i2c_bfin_twi1_device,
 #endif
+#endif
 };
 
 static int __init stamp_init(void)
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 3071c24..74b34c7 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -158,6 +158,27 @@ ENTRY(__stext)
 	w[p2] = r0;
 	ssync;
 
+	p2.h = hi(EBIU_MBSCTL);
+	p2.l = lo(EBIU_MBSCTL);
+	r0.h = hi(CONFIG_EBIU_MBSCTLVAL);
+	r0.l = lo(CONFIG_EBIU_MBSCTLVAL);
+	[p2] = r0;
+	ssync;
+
+	p2.h = hi(EBIU_MODE);
+	p2.l = lo(EBIU_MODE);
+	r0.h = hi(CONFIG_EBIU_MODEVAL);
+	r0.l = lo(CONFIG_EBIU_MODEVAL);
+	[p2] = r0;
+	ssync;
+
+	p2.h = hi(EBIU_FCTL);
+	p2.l = lo(EBIU_FCTL);
+	r0.h = hi(CONFIG_EBIU_FCTLVAL);
+	r0.l = lo(CONFIG_EBIU_FCTLVAL);
+	[p2] = r0;
+	ssync;
+
 	/* This section keeps the processor in supervisor mode
 	 * during kernel boot.  Switches to user mode at end of boot.
 	 * See page 3-9 of Hardware Reference manual for documentation.
diff --git a/arch/blackfin/mach-bf561/Kconfig b/arch/blackfin/mach-bf561/Kconfig
index 0a17c4c..3f48954 100644
--- a/arch/blackfin/mach-bf561/Kconfig
+++ b/arch/blackfin/mach-bf561/Kconfig
@@ -1,4 +1,6 @@
-if BF561
+if (BF561)
+
+source "arch/blackfin/mach-bf561/boards/Kconfig"
 
 menu "BF561 Specific Configuration"
 
diff --git a/arch/blackfin/mach-bf561/boards/Kconfig b/arch/blackfin/mach-bf561/boards/Kconfig
new file mode 100644
index 0000000..e41a67b
--- /dev/null
+++ b/arch/blackfin/mach-bf561/boards/Kconfig
@@ -0,0 +1,27 @@
+choice
+	prompt "System type"
+	default BFIN561_EZKIT
+	help
+	  Select your board!
+
+config BFIN561_EZKIT
+	bool "BF561-EZKIT"
+	help
+	  BF561-EZKIT-LITE board support.
+
+config BFIN561_TEPLA
+	bool "BF561-TEPLA"
+	help
+	 BF561-TEPLA board support.
+
+config BFIN561_BLUETECHNIX_CM
+	bool "Bluetechnix CM-BF561"
+	help
+	  CM-BF561 support for EVAL- and DEV-Board.
+
+config GENERIC_BF561_BOARD
+	bool "Generic"
+	help
+	  Generic or Custom board support.
+
+endchoice
diff --git a/arch/blackfin/mach-bf561/boards/Makefile b/arch/blackfin/mach-bf561/boards/Makefile
index 495a1cf..04add01 100644
--- a/arch/blackfin/mach-bf561/boards/Makefile
+++ b/arch/blackfin/mach-bf561/boards/Makefile
@@ -2,7 +2,7 @@
 # arch/blackfin/mach-bf561/boards/Makefile
 #
 
-obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
+obj-$(CONFIG_GENERIC_BF561_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN561_BLUETECHNIX_CM)   += cm_bf561.o
 obj-$(CONFIG_BFIN561_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN561_TEPLA)            += tepla.o
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 97aeb43..c19cd29 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -33,11 +33,12 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/usb_isp1362.h>
+#include <linux/usb/isp1362.h>
 #include <linux/pata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -182,6 +183,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 059d516..4ff8f6e 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -35,6 +35,7 @@
 #include <linux/pata_platform.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -115,6 +116,28 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
+#if defined(CONFIG_AX88180) || defined(CONFIG_AX88180_MODULE)
+static struct resource ax88180_resources[] = {
+	[0] = {
+		.start	= 0x2c000000,
+		.end	= 0x2c000000 + 0x8000,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PF10,
+		.end	= IRQ_PF10,
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL),
+	},
+};
+
+static struct platform_device ax88180_device = {
+	.name		= "ax88180",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ax88180_resources),
+	.resource	= ax88180_resources,
+};
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
 	{
@@ -160,6 +183,7 @@ static struct resource bfin_spi0_resource[] = {
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
 
 static struct platform_device bfin_spi0_device = {
@@ -226,6 +250,11 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 	&smc91x_device,
 #endif
+
+#if defined(CONFIG_AX88180) || defined(CONFIG_AX88180_MODULE)
+	&ax88180_device,
+#endif
+
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bfin_spi0_device,
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/generic_board.c b/arch/blackfin/mach-bf561/boards/generic_board.c
index 46816be..fc80c5d 100644
--- a/arch/blackfin/mach-bf561/boards/generic_board.c
+++ b/arch/blackfin/mach-bf561/boards/generic_board.c
@@ -48,10 +48,6 @@ static struct resource smc91x_resources[] = {
 		.end = IRQ_PROG_INTB,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
 	}, {
-		/*
-		 *  denotes the flag pin and is used directly if
-		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
-		 */
 		.start = IRQ_PF9,
 		.end = IRQ_PF9,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
diff --git a/arch/blackfin/mach-bf561/boards/tepla.c b/arch/blackfin/mach-bf561/boards/tepla.c
index 4a17c6d..ec6a220 100644
--- a/arch/blackfin/mach-bf561/boards/tepla.c
+++ b/arch/blackfin/mach-bf561/boards/tepla.c
@@ -31,10 +31,6 @@ static struct resource smc91x_resources[] = {
 		.end	= IRQ_PROG_INTB,
 		.flags	= IORESOURCE_IRQ|IORESOURCE_IRQ_HIGHLEVEL,
 	}, {
-		/*
-		 *  denotes the flag pin and is used directly if
-		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
-		 */
 		.start	= IRQ_PF7,
 		.end	= IRQ_PF7,
 		.flags	= IORESOURCE_IRQ|IORESOURCE_IRQ_HIGHLEVEL,
diff --git a/arch/blackfin/mach-common/cplbinfo.c b/arch/blackfin/mach-common/cplbinfo.c
index 785ca98..a4f0b42 100644
--- a/arch/blackfin/mach-common/cplbinfo.c
+++ b/arch/blackfin/mach-common/cplbinfo.c
@@ -91,7 +91,7 @@ static char *cplb_print_entry(char *buf, int type)
 	} else
 		buf += sprintf(buf, "Data CPLB entry:\n");
 
-	buf += sprintf(buf, "Address\t\tData\tSize\tValid\tLocked\tSwapin\n\tiCount\toCount\n");
+	buf += sprintf(buf, "Address\t\tData\tSize\tValid\tLocked\tSwapin\tiCount\toCount\n");
 
 	while (*p_addr != 0xffffffff) {
 		entry = cplb_find_entry(cplb_addr, cplb_data, *p_addr, *p_data);
diff --git a/arch/blackfin/mach-common/cplbmgr.S b/arch/blackfin/mach-common/cplbmgr.S
index 946703e..6f909cb 100644
--- a/arch/blackfin/mach-common/cplbmgr.S
+++ b/arch/blackfin/mach-common/cplbmgr.S
@@ -73,7 +73,7 @@ ENTRY(_cplb_mgr)
 	/* ICPLB Miss Exception. We need to choose one of the
 	* currently-installed CPLBs, and replace it with one
 	* from the configuration table.
- 	*/
+	*/
 
 	P4.L = LO(ICPLB_FAULT_ADDR);
 	P4.H = HI(ICPLB_FAULT_ADDR);
@@ -222,7 +222,7 @@ ENTRY(_cplb_mgr)
 
 	/* See if failed address > start address */
 	CC = R4 <= R0(IU);
- 	IF !CC JUMP .Linext;
+	IF !CC JUMP .Linext;
 
 	/* extract page size (17:16)*/
 	R3 = EXTRACT(R2, R1.L) (Z);
@@ -271,16 +271,27 @@ ENTRY(_cplb_mgr)
 
 /* FAILED CASES*/
 .Lno_page_in_table:
-	( R7:4,P5:3 ) = [SP++];
 	R0 = CPLB_NO_ADDR_MATCH;
-	RTS;
+	JUMP .Lfail_ret;
+
 .Lall_locked:
-	( R7:4,P5:3 ) = [SP++];
 	R0 = CPLB_NO_UNLOCKED;
-	RTS;
+	JUMP .Lfail_ret;
+
 .Lprot_violation:
-	( R7:4,P5:3 ) = [SP++];
 	R0 = CPLB_PROT_VIOL;
+
+.Lfail_ret:
+	/* Make sure we turn protection/cache back on, even in the failing case */
+	BITSET(R5,ENICPLB_P);
+	CLI R2;
+	SSYNC;          /* SSYNC required before writing to IMEM_CONTROL. */
+	.align 8;
+	[P4] = R5;
+	SSYNC;
+	STI R2;
+
+	( R7:4,P5:3 ) = [SP++];
 	RTS;
 
 .Ldcplb_write:
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 1b13fa4..dc9d3ee 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -33,7 +33,7 @@
  * after a timer-interrupt and after each system call.
  */
 
-
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/unistd.h>
 #include <asm/blackfin.h>
@@ -71,25 +71,44 @@ ENDPROC(_safe_speculative_execution)
  * This one does not lower the level to IRQ5, and thus can be used to
  * patch up CPLB misses on the kernel stack.
  */
-ENTRY(_ex_dcplb)
 #if ANOMALY_05000261
+#define _ex_dviol _ex_workaround_261
+#define _ex_dmiss _ex_workaround_261
+#define _ex_dmult _ex_workaround_261
+
+ENTRY(_ex_workaround_261)
 	/*
 	 * Work around an anomaly: if we see a new DCPLB fault, return
 	 * without doing anything.  Then, if we get the same fault again,
 	 * handle it.
 	 */
+	P4 = R7;	/* Store EXCAUSE */
 	p5.l = _last_cplb_fault_retx;
 	p5.h = _last_cplb_fault_retx;
 	r7 = [p5];
 	r6 = retx;
 	[p5] = r6;
 	cc = r6 == r7;
-	if !cc jump _return_from_exception;
+	if !cc jump _bfin_return_from_exception;
 	/* fall through */
+	R7 = P4;
+	R6 = 0x26;	/* Data CPLB Miss */
+	cc = R6 == R7;
+	if cc jump _ex_dcplb_miss (BP);
+	/* Handle 0x23 Data CPLB Protection Violation
+	 * and Data CPLB Multiple Hits - Linux Trap Zero
+	 */
+	jump _ex_trap_c;
+ENDPROC(_ex_workaround_261)
+
+#else
+#define _ex_dviol _ex_trap_c
+#define _ex_dmiss _ex_dcplb_miss
+#define _ex_dmult _ex_trap_c
 #endif
-ENDPROC(_ex_dcplb)
 
-ENTRY(_ex_icplb)
+ENTRY(_ex_dcplb_miss)
+ENTRY(_ex_icplb_miss)
 	(R7:6,P5:4) = [sp++];
 	ASTAT = [sp++];
 	SAVE_ALL_SYS
@@ -98,7 +117,7 @@ ENTRY(_ex_icplb)
 	RESTORE_ALL_SYS
 	SP = EX_SCRATCH_REG;
 	rtx;
-ENDPROC(_ex_icplb)
+ENDPROC(_ex_icplb_miss)
 
 ENTRY(_ex_syscall)
 	DEBUG_START_HWTRACE(p5, r7)
@@ -120,7 +139,7 @@ ENTRY(_ex_single_step)
 	r7 = retx;
 	r6 = reti;
 	cc = r7 == r6;
-	if cc jump _return_from_exception
+	if cc jump _bfin_return_from_exception
 	r7 = syscfg;
 	bitclr (r7, 0);
 	syscfg = R7;
@@ -137,8 +156,9 @@ ENTRY(_ex_single_step)
 	r7 = [p4];
 	cc = r6 == r7;
 	if !cc jump _ex_trap_c;
+ENDPROC(_ex_single_step)
 
-ENTRY(_return_from_exception)
+ENTRY(_bfin_return_from_exception)
 	DEBUG_START_HWTRACE(p5, r7)
 #if ANOMALY_05000257
 	R7=LC0;
@@ -150,7 +170,7 @@ ENTRY(_return_from_exception)
 	ASTAT = [sp++];
 	sp = EX_SCRATCH_REG;
 	rtx;
-ENDPROC(_ex_soft_bp)
+ENDPROC(_bfin_return_from_exception)
 
 ENTRY(_handle_bad_cplb)
 	/* To get here, we just tried and failed to change a CPLB
@@ -843,7 +863,7 @@ ENTRY(_ex_trace_buff_full)
 	LC0 = [sp++];
 	P2 = [sp++];
 	P3 = [sp++];
-	jump _return_from_exception;
+	jump _bfin_return_from_exception;
 ENDPROC(_ex_trace_buff_full)
 
 #if CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN == 4
@@ -861,7 +881,7 @@ ENTRY(_software_trace_buff)
 #endif /* CONFIG_DEBUG_BFIN_HWTRACE_EXPAND */
 
 #if CONFIG_EARLY_PRINTK
-.section .init.text
+__INIT
 ENTRY(_early_trap)
 	SAVE_ALL_SYS
 	trace_buffer_stop(p0,r0);
@@ -896,6 +916,7 @@ ENTRY(_early_trap)
 	call _early_trap_c;
 	SP += 12;
 ENDPROC(_early_trap)
+__FINIT
 #endif /* CONFIG_EARLY_PRINTK */
 
 /*
@@ -908,6 +929,7 @@ ENDPROC(_early_trap)
 #else
 .data
 #endif
+
 ENTRY(_ex_table)
 	/* entry for each EXCAUSE[5:0]
 	 * This table must be in sync with the table in ./kernel/traps.c
@@ -952,16 +974,16 @@ ENTRY(_ex_table)
 	.long _ex_trap_c        /* 0x20 - Reserved */
 	.long _ex_trap_c        /* 0x21 - Undefined Instruction */
 	.long _ex_trap_c        /* 0x22 - Illegal Instruction Combination */
-	.long _ex_dcplb         /* 0x23 - Data CPLB Protection Violation */
+	.long _ex_dviol         /* 0x23 - Data CPLB Protection Violation */
 	.long _ex_trap_c        /* 0x24 - Data access misaligned */
 	.long _ex_trap_c        /* 0x25 - Unrecoverable Event */
-	.long _ex_dcplb         /* 0x26 - Data CPLB Miss */
-	.long _ex_trap_c        /* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero */
+	.long _ex_dmiss         /* 0x26 - Data CPLB Miss */
+	.long _ex_dmult         /* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero */
 	.long _ex_trap_c        /* 0x28 - Emulation Watchpoint */
 	.long _ex_trap_c        /* 0x29 - Instruction fetch access error (535 only) */
 	.long _ex_trap_c        /* 0x2A - Instruction fetch misaligned */
-	.long _ex_icplb         /* 0x2B - Instruction CPLB protection Violation */
-	.long _ex_icplb         /* 0x2C - Instruction CPLB miss */
+	.long _ex_trap_c        /* 0x2B - Instruction CPLB protection Violation */
+	.long _ex_icplb_miss    /* 0x2C - Instruction CPLB miss */
 	.long _ex_trap_c        /* 0x2D - Instruction CPLB Multiple Hits */
 	.long _ex_trap_c        /* 0x2E - Illegal use of Supervisor Resource */
 	.long _ex_trap_c        /* 0x2E - Illegal use of Supervisor Resource */
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index c6b32fe..4de3764 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -30,7 +30,6 @@
 
 #include <asm/blackfin.h>
 #include <asm/mach/irq.h>
-#include <linux/autoconf.h>
 #include <linux/linkage.h>
 #include <asm/entry.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index c2f05fa..4882f0e 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -181,7 +181,6 @@ static struct irq_chip bf561_internal_irqchip = {
 	.unmask = bf561_internal_unmask_irq,
 };
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 static unsigned short gpio_enabled[gpio_bank(MAX_BLACKFIN_GPIOS)];
 static unsigned short gpio_edge_triggered[gpio_bank(MAX_BLACKFIN_GPIOS)];
 
@@ -362,8 +361,6 @@ static void bf561_demux_gpio_irq(unsigned int inta_irq,
 
 }
 
-#endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
-
 void __init init_exception_vectors(void)
 {
 	SSYNC();
@@ -413,26 +410,21 @@ int __init init_arch_irq(void)
 			set_irq_chip(irq, &bf561_core_irqchip);
 		else
 			set_irq_chip(irq, &bf561_internal_irqchip);
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
+
 		if ((irq != IRQ_PROG0_INTA) &&
-		    (irq != IRQ_PROG1_INTA) && (irq != IRQ_PROG2_INTA)) {
-#endif
+		    (irq != IRQ_PROG1_INTA) &&
+		    (irq != IRQ_PROG2_INTA))
 			set_irq_handler(irq, handle_simple_irq);
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
-		} else {
+		else
 			set_irq_chained_handler(irq, bf561_demux_gpio_irq);
-		}
-#endif
-
 	}
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 	for (irq = IRQ_PF0; irq <= IRQ_PF47; irq++) {
 		set_irq_chip(irq, &bf561_gpio_irqchip);
 		/* if configured as edge, then will be changed to do_edge_IRQ */
 		set_irq_handler(irq, handle_level_irq);
 	}
-#endif
+
 	bfin_write_IMASK(0);
 	CSYNC();
 	ilat = bfin_read_ILAT();
@@ -457,9 +449,8 @@ int __init init_arch_irq(void)
 }
 
 #ifdef CONFIG_DO_IRQ_L1
-void do_irq(int vec, struct pt_regs *fp)__attribute__((l1_text));
+__attribute__((l1_text))
 #endif
-
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 2d2b635..147f073 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -308,7 +308,7 @@ static void bfin_demux_error_irq(unsigned int int_err_irq,
 }
 #endif				/* BF537_GENERIC_ERROR_INT_DEMUX */
 
-#if defined(CONFIG_IRQCHIP_DEMUX_GPIO) && !defined(CONFIG_BF54x)
+#if !defined(CONFIG_BF54x)
 
 static unsigned short gpio_enabled[gpio_bank(MAX_BLACKFIN_GPIOS)];
 static unsigned short gpio_edge_triggered[gpio_bank(MAX_BLACKFIN_GPIOS)];
@@ -464,7 +464,7 @@ static void bfin_demux_gpio_irq(unsigned int intb_irq,
 	}
 }
 
-#else				/* CONFIG_IRQCHIP_DEMUX_GPIO */
+#else				/* CONFIG_BF54x */
 
 #define NR_PINT_SYS_IRQS	4
 #define NR_PINT_BITS		32
@@ -726,7 +726,7 @@ static void bfin_demux_gpio_irq(unsigned int intb_irq,
 	}
 
 }
-#endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
+#endif
 
 void __init init_exception_vectors(void)
 {
@@ -766,10 +766,10 @@ int __init init_arch_irq(void)
 	bfin_write_SIC_IMASK1(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
 	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
-#ifdef CONFIG_BF54x
+# ifdef CONFIG_BF54x
 	bfin_write_SIC_IMASK2(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
-#endif
+# endif
 #else
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
@@ -778,13 +778,13 @@ int __init init_arch_irq(void)
 
 	local_irq_disable();
 
-#if defined(CONFIG_IRQCHIP_DEMUX_GPIO) && defined(CONFIG_BF54x)
-#ifdef CONFIG_PINTx_REASSIGN
+#ifdef CONFIG_BF54x
+# ifdef CONFIG_PINTx_REASSIGN
 	pint[0]->assign = CONFIG_PINT0_ASSIGN;
 	pint[1]->assign = CONFIG_PINT1_ASSIGN;
 	pint[2]->assign = CONFIG_PINT2_ASSIGN;
 	pint[3]->assign = CONFIG_PINT3_ASSIGN;
-#endif
+# endif
 	/* Whenever PINTx_ASSIGN is altered init_pint_lut() must be executed! */
 	init_pint_lut();
 #endif
@@ -799,18 +799,17 @@ int __init init_arch_irq(void)
 #endif
 
 			switch (irq) {
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #if defined(CONFIG_BF53x)
 			case IRQ_PROG_INTA:
 				set_irq_chained_handler(irq,
 							bfin_demux_gpio_irq);
 				break;
-#if defined(BF537_FAMILY) && !(defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
+# if defined(BF537_FAMILY) && !(defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
 			case IRQ_MAC_RX:
 				set_irq_chained_handler(irq,
 							bfin_demux_gpio_irq);
 				break;
-#endif
+# endif
 #elif defined(CONFIG_BF54x)
 			case IRQ_PINT0:
 				set_irq_chained_handler(irq,
@@ -842,7 +841,6 @@ int __init init_arch_irq(void)
 							bfin_demux_gpio_irq);
 				break;
 #endif
-#endif
 			default:
 				set_irq_handler(irq, handle_simple_irq);
 				break;
@@ -861,7 +859,6 @@ int __init init_arch_irq(void)
 	}
 #endif
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #ifndef CONFIG_BF54x
 	for (irq = IRQ_PF0; irq < NR_IRQS; irq++) {
 #else
@@ -871,7 +868,7 @@ int __init init_arch_irq(void)
 		/* if configured as edge, then will be changed to do_edge_IRQ */
 		set_irq_handler(irq, handle_level_irq);
 	}
-#endif
+
 	bfin_write_IMASK(0);
 	CSYNC();
 	ilat = bfin_read_ILAT();
@@ -896,9 +893,8 @@ int __init init_arch_irq(void)
 }
 
 #ifdef CONFIG_DO_IRQ_L1
-void do_irq(int vec, struct pt_regs *fp) __attribute__((l1_text));
+__attribute__((l1_text))
 #endif
-
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
diff --git a/arch/blackfin/mach-common/irqpanic.c b/arch/blackfin/mach-common/irqpanic.c
index f05e3da..b22959b 100644
--- a/arch/blackfin/mach-common/irqpanic.c
+++ b/arch/blackfin/mach-common/irqpanic.c
@@ -153,27 +153,29 @@ asmlinkage void irq_panic(int reason, struct pt_regs *regs)
 		case (SEQSTAT_HWERRCAUSE_SYSTEM_MMR):	/* System MMR Error */
 			info.si_code = BUS_ADRALN;
 			sig = SIGBUS;
-			printk(KERN_EMERG HWC_x2);
+			printk(KERN_EMERG HWC_x2(KERN_EMERG));
 			break;
 		case (SEQSTAT_HWERRCAUSE_EXTERN_ADDR):	/* External Memory Addressing Error */
 			info.si_code = BUS_ADRERR;
 			sig = SIGBUS;
-			printk(KERN_EMERG HWC_x3);
+			printk(KERN_EMERG HWC_x3(KERN_EMERG));
 			break;
 		case (SEQSTAT_HWERRCAUSE_PERF_FLOW):	/* Performance Monitor Overflow */
-			printk(KERN_EMERG HWC_x12);
+			printk(KERN_EMERG HWC_x12(KERN_EMERG));
 			break;
 		case (SEQSTAT_HWERRCAUSE_RAISE_5):	/* RAISE 5 instruction */
-			printk(KERN_EMERG HWC_x18);
+			printk(KERN_EMERG HWC_x18(KERN_EMERG));
 			break;
 		default:	/* Reserved */
-			printk(KERN_EMERG HWC_default);
+			printk(KERN_EMERG HWC_default(KERN_EMERG));
 			break;
 		}
 	}
 
 	regs->ipend = bfin_read_IPEND();
-	dump_bfin_regs(regs, (void *)regs->pc);
+	dump_bfin_process(regs);
+	dump_bfin_mem((void *)regs->pc);
+	show_regs(regs);
 	if (0 == (info.si_signo = sig) || 0 == user_mode(regs))	/* in kernelspace */
 		panic("Unhandled IRQ or exceptions!\n");
 	else {			/* in userspace */
diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index b99ea88..e41f0e8 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -27,7 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/autoconf.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 5ce632c..b88569e 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -21,7 +21,7 @@ if SERIO
 config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
-	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K && !BFIN
+	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K && !BLACKFIN
 	---help---
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 084acfd..0b99b55 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -924,7 +924,7 @@ static int __init bf537mac_probe(struct net_device *dev)
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		/* Grab the MAC from the board somehow - this is done in the
 		   arch/blackfin/mach-bf537/boards/eth_mac.c */
-		get_bf537_ether_addr(dev->dev_addr);
+		bfin_get_ether_addr(dev->dev_addr);
 	}
 
 	/* If still not valid, get a random one */
diff --git a/drivers/net/bfin_mac.h b/drivers/net/bfin_mac.h
index 3a107ad..5970ea7 100644
--- a/drivers/net/bfin_mac.h
+++ b/drivers/net/bfin_mac.h
@@ -92,4 +92,4 @@ struct bf537mac_local {
 	struct mii_bus mii_bus;
 };
 
-extern void get_bf537_ether_addr(char *addr);
+extern void bfin_get_ether_addr(char *addr);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e5cdc02..1e6715e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -447,7 +447,7 @@ config RTC_DRV_AT91RM9200
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
-	depends on BFIN
+	depends on BLACKFIN
 	help
 	  If you say yes here you will get support for the
 	  Blackfin On-Chip Real Time Clock.
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index ed438bc..d7e1996 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -600,7 +600,7 @@ config SERIAL_SA1100_CONSOLE
 
 config SERIAL_BFIN
 	tristate "Blackfin serial port support"
-	depends on BFIN
+	depends on BLACKFIN
 	select SERIAL_CORE
 	select SERIAL_BFIN_UART0 if (BF531 || BF532 || BF533 || BF561)
 	help
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a77ede5..abf0504 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -61,7 +61,7 @@ config SPI_ATMEL
 
 config SPI_BFIN
 	tristate "SPI controller driver for ADI Blackfin5xx"
-	depends on SPI_MASTER && BFIN
+	depends on SPI_MASTER && BLACKFIN
 	help
 	  This is the SPI controller master driver for Blackfin 5xx processor.
 
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 267422f..b87ed37 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -6,7 +6,7 @@ menu "Console display driver support"
 
 config VGA_CONSOLE
 	bool "VGA text console" if EMBEDDED || !X86
-	depends on !ARCH_ACORN && !ARCH_EBSA110 && !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !ARCH_VERSATILE && !SUPERH && !BFIN
+	depends on !ARCH_ACORN && !ARCH_EBSA110 && !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !ARCH_VERSATILE && !SUPERH && !BLACKFIN
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index 0212e18..39bdd86 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -50,8 +50,8 @@ extern unsigned long get_sclk(void);
 extern unsigned long sclk_to_usecs(unsigned long sclk);
 extern unsigned long usecs_to_sclk(unsigned long usecs);
 
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
-extern void dump_bfin_regs(struct pt_regs *fp, void *retaddr);
+extern void dump_bfin_process(struct pt_regs *regs);
+extern void dump_bfin_mem(void *retaddr);
 extern void dump_bfin_trace_buffer(void);
 
 extern int init_arch_irq(void);
@@ -63,6 +63,7 @@ extern void bfin_dcache_init(void);
 extern int read_iloc(void);
 extern int bfin_console_init(void);
 extern asmlinkage void lower_to_irq14(void);
+extern asmlinkage void bfin_return_from_exception(void);
 extern void init_exception_vectors(void);
 extern void init_dma(void);
 extern void program_IAR(void);
diff --git a/include/asm-blackfin/cplbinit.h b/include/asm-blackfin/cplbinit.h
index bec6ecd..c4d0596 100644
--- a/include/asm-blackfin/cplbinit.h
+++ b/include/asm-blackfin/cplbinit.h
@@ -27,6 +27,9 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#ifndef __ASM_CPLBINIT_H__
+#define __ASM_CPLBINIT_H__
+
 #include <asm/blackfin.h>
 #include <asm/cplb.h>
 
@@ -57,8 +60,8 @@ struct cplb_tab {
 	u16 size;
 };
 
-extern u_long icplb_table[MAX_CPLBS+1];
-extern u_long dcplb_table[MAX_CPLBS+1];
+extern u_long icplb_table[];
+extern u_long dcplb_table[];
 
 /* Till here we are discussing about the static memory management model.
  * However, the operating envoronments commonly define more CPLB
@@ -69,28 +72,16 @@ extern u_long dcplb_table[MAX_CPLBS+1];
  * This is how Page descriptor Table is implemented in uClinux/Blackfin.
  */
 
-#ifdef CONFIG_CPLB_SWITCH_TAB_L1
-extern u_long ipdt_table[MAX_SWITCH_I_CPLBS+1]__attribute__((l1_data));
-extern u_long dpdt_table[MAX_SWITCH_D_CPLBS+1]__attribute__((l1_data));
-
-#ifdef CONFIG_CPLB_INFO
-extern u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS]__attribute__((l1_data));
-extern u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS]__attribute__((l1_data));
-#endif /* CONFIG_CPLB_INFO */
-
-#else
-
-extern u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
-extern u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
-
+extern u_long ipdt_table[];
+extern u_long dpdt_table[];
 #ifdef CONFIG_CPLB_INFO
-extern u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
-extern u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
-#endif /* CONFIG_CPLB_INFO */
-
-#endif /*CONFIG_CPLB_SWITCH_TAB_L1*/
+extern u_long ipdt_swapcount_table[];
+extern u_long dpdt_swapcount_table[];
+#endif
 
 extern unsigned long reserved_mem_dcache_on;
 extern unsigned long reserved_mem_icache_on;
 
 extern void generate_cpl_tables(void);
+
+#endif
diff --git a/include/asm-blackfin/delay.h b/include/asm-blackfin/delay.h
index 52e7a10..473a811 100644
--- a/include/asm-blackfin/delay.h
+++ b/include/asm-blackfin/delay.h
@@ -1,29 +1,47 @@
-#ifndef _BLACKFIN_DELAY_H
-#define _BLACKFIN_DELAY_H
-
-static inline void __delay(unsigned long loops)
-{
-
-/* FIXME: Currently the assembler doesn't recognize Loop Register Clobbers,
-   uncomment this as soon those are implemented */
 /*
-      __asm__ __volatile__ (  "\t LSETUP (1f,1f) LC0= %0\n\t"
-                              "1:\t NOP;\n\t"
-                              : :"a" (loops)
-                              : "LT0","LB0","LC0");
+ * delay.h - delay functions
+ *
+ * Copyright (c) 2004-2007 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __ASM_DELAY_H__
+#define __ASM_DELAY_H__
 
-*/
+#include <asm/mach/anomaly.h>
 
-	__asm__ __volatile__("[--SP] = LC0;\n\t"
-			     "[--SP] = LT0;\n\t"
-			     "[--SP] = LB0;\n\t"
-			     "LSETUP (1f,1f) LC0 = %0;\n\t"
-			     "1:\t NOP;\n\t"
-			     "LB0 = [SP++];\n\t"
-				"LT0 = [SP++];\n\t"
-				"LC0 = [SP++];\n"
-				:
-				:"a" (loops));
+static inline void __delay(unsigned long loops)
+{
+	if (ANOMALY_05000312) {
+		/* Interrupted loads to loop registers -> bad */
+		unsigned long tmp;
+		__asm__ __volatile__(
+			"[--SP] = LC0;"
+			"[--SP] = LT0;"
+			"[--SP] = LB0;"
+			"LSETUP (1f,1f) LC0 = %1;"
+			"1: NOP;"
+			/* We take advantage of the fact that LC0 is 0 at
+			 * the end of the loop.  Otherwise we'd need some
+			 * NOPs after the CLI here.
+			 */
+			"CLI %0;"
+			"LB0 = [SP++];"
+			"LT0 = [SP++];"
+			"LC0 = [SP++];"
+			"STI %0;"
+			: "=d" (tmp)
+			: "a" (loops)
+		);
+	} else
+		__asm__ __volatile__ (
+			"LSETUP(1f, 1f) LC0 = %0;"
+			"1: NOP;"
+			:
+			: "a" (loops)
+			: "LT0", "LB0", "LC0"
+		);
 }
 
 #include <linux/param.h>	/* needed for HZ */
@@ -41,4 +59,4 @@ static inline void udelay(unsigned long usecs)
 	__delay(usecs * loops_per_jiffy / (1000000 / HZ));
 }
 
-#endif				/* defined(_BLACKFIN_DELAY_H) */
+#endif
diff --git a/include/asm-blackfin/io.h b/include/asm-blackfin/io.h
index d1d2e6b..1601d62 100644
--- a/include/asm-blackfin/io.h
+++ b/include/asm-blackfin/io.h
@@ -122,6 +122,7 @@ extern void outsl(unsigned long port, const void *addr, unsigned long count);
 extern void insb(unsigned long port, void *addr, unsigned long count);
 extern void insw(unsigned long port, void *addr, unsigned long count);
 extern void insl(unsigned long port, void *addr, unsigned long count);
+extern void insl_16(unsigned long port, void *addr, unsigned long count);
 
 extern void dma_outsb(unsigned long port, const void *addr, unsigned short count);
 extern void dma_outsw(unsigned long port, const void *addr, unsigned short count);
diff --git a/include/asm-blackfin/mach-bf527/irq.h b/include/asm-blackfin/mach-bf527/irq.h
index 304f5bc..4e2b3f2 100644
--- a/include/asm-blackfin/mach-bf527/irq.h
+++ b/include/asm-blackfin/mach-bf527/irq.h
@@ -176,11 +176,7 @@
 
 #define GPIO_IRQ_BASE	IRQ_PF0
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PH15+1)
-#else
-#define NR_IRQS     (SYS_IRQS+1)
-#endif
 
 #define IVG7            7
 #define IVG8            8
diff --git a/include/asm-blackfin/mach-bf527/mem_map.h b/include/asm-blackfin/mach-bf527/mem_map.h
index c5aa201..193082d 100644
--- a/include/asm-blackfin/mach-bf527/mem_map.h
+++ b/include/asm-blackfin/mach-bf527/mem_map.h
@@ -47,6 +47,7 @@
 /* Boot ROM Memory */
 
 #define BOOT_ROM_START		0xEF000000
+#define BOOT_ROM_LENGTH		0x8000
 
 /* Level 1 Memory */
 
@@ -90,9 +91,7 @@
 
 /* Scratch Pad Memory */
 
-#if defined(CONFIG_BF527) || defined(CONFIG_BF536) || defined(CONFIG_BF534)
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
-#endif
 
 #endif				/* _MEM_MAP_527_H_ */
diff --git a/include/asm-blackfin/mach-bf533/irq.h b/include/asm-blackfin/mach-bf533/irq.h
index 452fb82..832e6f6 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -130,11 +130,7 @@ Core        Emulation               **
 
 #define GPIO_IRQ_BASE		IRQ_PF0
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define	NR_IRQS		(IRQ_PF15+1)
-#else
-#define	NR_IRQS		SYS_IRQS
-#endif
 
 #define IVG7			7
 #define IVG8			8
diff --git a/include/asm-blackfin/mach-bf533/mem_map.h b/include/asm-blackfin/mach-bf533/mem_map.h
index 94d8c40..bd30b6f 100644
--- a/include/asm-blackfin/mach-bf533/mem_map.h
+++ b/include/asm-blackfin/mach-bf533/mem_map.h
@@ -1,4 +1,3 @@
-
 /*
  * File:         include/asm-blackfin/mach-bf533/mem_map.h
  * Based on:
@@ -48,6 +47,7 @@
 /* Boot ROM Memory */
 
 #define BOOT_ROM_START		0xEF000000
+#define BOOT_ROM_LENGTH		0x400
 
 /* Level 1 Memory */
 
@@ -160,9 +160,7 @@
 
 /* Scratch Pad Memory */
 
-#if defined(CONFIG_BF533) || defined(CONFIG_BF532) || defined(CONFIG_BF531)
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
-#endif
 
 #endif				/* _MEM_MAP_533_H_ */
diff --git a/include/asm-blackfin/mach-bf537/irq.h b/include/asm-blackfin/mach-bf537/irq.h
index 36c44bc..be6f2ff 100644
--- a/include/asm-blackfin/mach-bf537/irq.h
+++ b/include/asm-blackfin/mach-bf537/irq.h
@@ -162,11 +162,7 @@ Core        Emulation               **
 
 #define GPIO_IRQ_BASE	IRQ_PF0
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PH15+1)
-#else
-#define NR_IRQS     (IRQ_UART1_ERROR+1)
-#endif
 
 #define IVG7            7
 #define IVG8            8
diff --git a/include/asm-blackfin/mach-bf537/mem_map.h b/include/asm-blackfin/mach-bf537/mem_map.h
index 18759e3..5c6726d 100644
--- a/include/asm-blackfin/mach-bf537/mem_map.h
+++ b/include/asm-blackfin/mach-bf537/mem_map.h
@@ -47,6 +47,7 @@
 /* Boot ROM Memory */
 
 #define BOOT_ROM_START		0xEF000000
+#define BOOT_ROM_LENGTH		0x800
 
 /* Level 1 Memory */
 
@@ -167,9 +168,7 @@
 
 /* Scratch Pad Memory */
 
-#if defined(CONFIG_BF537) || defined(CONFIG_BF536) || defined(CONFIG_BF534)
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
-#endif
 
 #endif				/* _MEM_MAP_537_H_ */
diff --git a/include/asm-blackfin/mach-bf548/bf548.h b/include/asm-blackfin/mach-bf548/bf548.h
index 7e6d349..e748588 100644
--- a/include/asm-blackfin/mach-bf548/bf548.h
+++ b/include/asm-blackfin/mach-bf548/bf548.h
@@ -106,24 +106,22 @@
 
 #define AMGCTLVAL	(V_AMBEN | V_AMCKEN)
 
-#ifdef CONFIG_BF542
-#define CPU "BF542"
-#define CPUID 0x027c8000
-#endif
-#ifdef CONFIG_BF544
-#define CPU "BF544"
-#define CPUID 0x027c8000
-#endif
-#ifdef CONFIG_BF548
-#define CPU "BF548"
-#define CPUID 0x027c6000
-#endif
-#ifdef CONFIG_BF549
-#define CPU "BF549"
-#endif
-#ifndef CPU
-#define	CPU "UNKNOWN"
-#define CPUID 0x0
+#if defined(CONFIG_BF542)
+# define CPU   "BF542"
+# define CPUID 0x027c8000
+#elif defined(CONFIG_BF544)
+# define CPU "BF544"
+# define CPUID 0x027c8000
+#elif defined(CONFIG_BF547)
+# define CPU "BF547"
+#elif defined(CONFIG_BF548)
+# define CPU "BF548"
+# define CPUID 0x027c6000
+#elif defined(CONFIG_BF549)
+# define CPU "BF549"
+#else
+# define CPU "UNKNOWN"
+# define CPUID 0x0
 #endif
 
 #endif	/* __MACH_BF48_H__  */
diff --git a/include/asm-blackfin/mach-bf548/defBF544.h b/include/asm-blackfin/mach-bf548/defBF544.h
index 760307e..b8b9870 100644
--- a/include/asm-blackfin/mach-bf548/defBF544.h
+++ b/include/asm-blackfin/mach-bf548/defBF544.h
@@ -645,7 +645,7 @@
 
 /* Bit masks for HOST_STATUS */
 
-#define                     READY  0x1        /* DMA Ready */
+#define                 DMA_READY  0x1        /* DMA Ready */
 #define                  FIFOFULL  0x2        /* FIFO Full */
 #define                 FIFOEMPTY  0x4        /* FIFO Empty */
 #define                  COMPLETE  0x8        /* DMA Complete */
diff --git a/include/asm-blackfin/mach-bf548/defBF548.h b/include/asm-blackfin/mach-bf548/defBF548.h
index 70af33c..ecbca95 100644
--- a/include/asm-blackfin/mach-bf548/defBF548.h
+++ b/include/asm-blackfin/mach-bf548/defBF548.h
@@ -1007,7 +1007,7 @@
 
 /* Bit masks for HOST_STATUS */
 
-#define                     READY  0x1        /* DMA Ready */
+#define                 DMA_READY  0x1        /* DMA Ready */
 #define                  FIFOFULL  0x2        /* FIFO Full */
 #define                 FIFOEMPTY  0x4        /* FIFO Empty */
 #define                  COMPLETE  0x8        /* DMA Complete */
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
index 3b08cf9..9fb7bc5 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -338,11 +338,7 @@ Events         (highest priority)  EMU         0
 
 #define GPIO_IRQ_BASE	IRQ_PA0
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PJ15+1)
-#else
-#define NR_IRQS     (SYS_IRQS+1)
-#endif
 
 /* For compatibility reasons with existing code */
 
diff --git a/include/asm-blackfin/mach-bf548/mem_map.h b/include/asm-blackfin/mach-bf548/mem_map.h
index ec1597e..f99f47b 100644
--- a/include/asm-blackfin/mach-bf548/mem_map.h
+++ b/include/asm-blackfin/mach-bf548/mem_map.h
@@ -47,6 +47,12 @@
 /* Boot ROM Memory */
 
 #define BOOT_ROM_START		0xEF000000
+#define BOOT_ROM_LENGTH		0x1000
+
+/* L1 Instruction ROM */
+
+#define L1_ROM_START		0xFFA14000
+#define L1_ROM_LENGTH		0x10000
 
 /* Level 1 Memory */
 
@@ -87,11 +93,19 @@
 #define BFIN_DSUPBANKS	0
 #endif /*CONFIG_BFIN_DCACHE*/
 
+/* Level 2 Memory */
+#if !defined(CONFIG_BF542)
+# define L2_START          0xFEB00000
+# if defined(CONFIG_BF544)
+#  define L2_LENGTH        0x10000
+# else
+#  define L2_LENGTH        0x20000
+# endif
+#endif
+
 /* Scratch Pad Memory */
 
-#if defined(CONFIG_BF54x)
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
-#endif
 
 #endif/* _MEM_MAP_548_H_ */
diff --git a/include/asm-blackfin/mach-bf561/bf561.h b/include/asm-blackfin/mach-bf561/bf561.h
index 17e1d5d..3ef9e5f 100644
--- a/include/asm-blackfin/mach-bf561/bf561.h
+++ b/include/asm-blackfin/mach-bf561/bf561.h
@@ -33,25 +33,6 @@
 #define SUPPORTED_REVID		0x3
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
-#define L1_ISRAM		0xFFA00000
-#define L1_ISRAM_END		0xFFA04000
-#define DATA_BANKA_SRAM		0xFF800000
-#define DATA_BANKA_SRAM_END	0xFF804000
-#define DATA_BANKB_SRAM		0xFF900000
-#define DATA_BANKB_SRAM_END	0xFF904000
-#define L1_DSRAMA		0xFF800000
-#define L1_DSRAMA_END		0xFF804000
-#define L1_DSRAMB		0xFF900000
-#define L1_DSRAMB_END		0xFF904000
-#define L2_SRAM			0xFEB00000
-#define L2_SRAM_END		0xFEB20000
-#define AMB_FLASH		0x20000000
-#define AMB_FLASH_END		0x21000000
-#define AMB_FLASH_LENGTH	0x01000000
-#define L1_ISRAM_LENGTH		0x4000
-#define L1_DSRAMA_LENGTH	0x4000
-#define L1_DSRAMB_LENGTH	0x4000
-#define L2_SRAM_LENGTH		0x20000
 
 /*some misc defines*/
 #define IMASK_IVG15		0x8000
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h b/include/asm-blackfin/mach-bf561/defBF561.h
index 7945e8a..c3c0eb1 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -55,6 +55,7 @@
 /* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
 #define SWRST                   SICA_SWRST
 #define SYSCR                   SICA_SYSCR
+#define DOUBLE_FAULT            (DOUBLE_FAULT_B|DOUBLE_FAULT_A)
 #define RESET_DOUBLE            (SWRST_DBL_FAULT_B|SWRST_DBL_FAULT_A)
 #define RESET_WDOG              (SWRST_WDT_B|SWRST_WDT_A)
 #define RESET_SOFTWARE          (SWRST_OCCURRED)
@@ -877,12 +878,14 @@
 #define	PLL_LOCKED			0x0020	/* PLL_LOCKCNT Has Been Reached                                 */
 
 /* SWRST Mask */
-#define SYSTEM_RESET           0x00000007	/* Initiates a system software reset */
-#define SWRST_DBL_FAULT_B      0x00000800	/* SWRST Core B Double Fault */
-#define SWRST_DBL_FAULT_A      0x00001000	/* SWRST Core A Double Fault */
-#define SWRST_WDT_B		       0x00002000	/* SWRST Watchdog B */
-#define SWRST_WDT_A		       0x00004000	/* SWRST Watchdog A */
-#define SWRST_OCCURRED         0x00008000	/* SWRST Status */
+#define SYSTEM_RESET           0x0007	/* Initiates a system software reset */
+#define DOUBLE_FAULT_A         0x0008	/* Core A Double Fault Causes Reset */
+#define DOUBLE_FAULT_B         0x0010	/* Core B Double Fault Causes Reset */
+#define SWRST_DBL_FAULT_A      0x0800	/* SWRST Core A Double Fault */
+#define SWRST_DBL_FAULT_B      0x1000	/* SWRST Core B Double Fault */
+#define SWRST_WDT_B		       0x2000	/* SWRST Watchdog B */
+#define SWRST_WDT_A		       0x4000	/* SWRST Watchdog A */
+#define SWRST_OCCURRED         0x8000	/* SWRST Status */
 
 /* *************  SYSTEM INTERRUPT CONTROLLER MASKS ***************** */
 
diff --git a/include/asm-blackfin/mach-bf561/irq.h b/include/asm-blackfin/mach-bf561/irq.h
index 1278992..83f0383 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -291,11 +291,7 @@
 
 #define GPIO_IRQ_BASE		IRQ_PF0
 
-#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS			(IRQ_PF47 + 1)
-#else
-#define NR_IRQS			SYS_IRQS
-#endif
 
 #define IVG7			7
 #define IVG8			8
diff --git a/include/asm-blackfin/mach-bf561/mem_map.h b/include/asm-blackfin/mach-bf561/mem_map.h
index f7ac09c..c26d848 100644
--- a/include/asm-blackfin/mach-bf561/mem_map.h
+++ b/include/asm-blackfin/mach-bf561/mem_map.h
@@ -19,6 +19,11 @@
 #define ASYNC_BANK0_BASE	0x20000000	 /* Async Bank 0 */
 #define ASYNC_BANK0_SIZE	0x04000000	/* 64M */
 
+/* Boot ROM Memory */
+
+#define BOOT_ROM_START		0xEF000000
+#define BOOT_ROM_LENGTH		0x800
+
 /* Level 1 Memory */
 
 #ifdef CONFIG_BFIN_ICACHE
@@ -67,9 +72,7 @@
 
 /* Scratch Pad Memory */
 
-#if defined(CONFIG_BF561)
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
-#endif
 
 #endif				/* _MEM_MAP_533_H_ */
diff --git a/include/asm-blackfin/mach-common/def_LPBlackfin.h b/include/asm-blackfin/mach-common/def_LPBlackfin.h
index c1d8c4a..e8967f6 100644
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -46,7 +46,7 @@
 #endif
 
 #define bfin_read8(addr) ({ \
-	uint8_t __v; \
+	uint32_t __v; \
 	__asm__ __volatile__( \
 		NOP_PAD_ANOMALY_05000198 \
 		"%0 = b[%1] (z);" \
@@ -56,7 +56,7 @@
 	__v; })
 
 #define bfin_read16(addr) ({ \
-	uint16_t __v; \
+	uint32_t __v; \
 	__asm__ __volatile__( \
 		NOP_PAD_ANOMALY_05000198 \
 		"%0 = w[%1] (z);" \
@@ -80,7 +80,7 @@
 		NOP_PAD_ANOMALY_05000198 \
 		"b[%0] = %1;" \
 		: \
-		: "a" (addr), "d" (val) \
+		: "a" (addr), "d" ((uint8_t)(val)) \
 		: "memory" \
 	)
 
@@ -89,7 +89,7 @@
 		NOP_PAD_ANOMALY_05000198 \
 		"w[%0] = %1;" \
 		: \
-		: "a" (addr), "d" (val) \
+		: "a" (addr), "d" ((uint16_t)(val)) \
 		: "memory" \
 	)
 
diff --git a/include/asm-blackfin/page_offset.h b/include/asm-blackfin/page_offset.h
index 3b671d5..cbaff24 100644
--- a/include/asm-blackfin/page_offset.h
+++ b/include/asm-blackfin/page_offset.h
@@ -1,6 +1,6 @@
 
 /* This handles the memory map.. */
 
-#ifdef CONFIG_BFIN
+#ifdef CONFIG_BLACKFIN
 #define PAGE_OFFSET_RAW		0x00000000
 #endif
diff --git a/include/asm-blackfin/string.h b/include/asm-blackfin/string.h
index e8ada91..321f4d9 100644
--- a/include/asm-blackfin/string.h
+++ b/include/asm-blackfin/string.h
@@ -1,6 +1,8 @@
 #ifndef _BLACKFIN_STRING_H_
 #define _BLACKFIN_STRING_H_
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__		/* only set these up for kernel code */
 
 #define __HAVE_ARCH_STRCPY
diff --git a/include/asm-blackfin/traps.h b/include/asm-blackfin/traps.h
index fe365b1..ee1cbf7 100644
--- a/include/asm-blackfin/traps.h
+++ b/include/asm-blackfin/traps.h
@@ -48,28 +48,80 @@
 
 #ifndef __ASSEMBLY__
 
-#define HWC_x2 "System MMR Error\nAn error occurred due to an invalid access to an System MMR location\nPossible reason: a 32-bit register is accessed with a 16-bit instruction,\nor a 16-bit register is accessed with a 32-bit instruction.\n"
-#define HWC_x3 "External Memory Addressing Error\n"
-#define HWC_x12 "Performance Monitor Overflow\n"
-#define HWC_x18 "RAISE 5 instruction\n Software issued a RAISE 5 instruction to invoke the Hardware\n"
-#define HWC_default "Reserved\n"
-
-#define EXC_0x03 "Application stack overflow\n - Please increase the stack size of the application using elf2flt -s option,\n and/or reduce the stack use of the application.\n"
-#define EXC_0x10 "Single step\n - When the processor is in single step mode, every instruction\n generates an exception. Primarily used for debugging.\n"
-#define EXC_0x11 "Exception caused by a trace buffer full condition\n - The processor takes this exception when the trace\n buffer overflows (only when enabled by the Trace Unit Control register).\n"
-#define EXC_0x21 "Undefined instruction\n - May be used to emulate instructions that are not defined for\n a particular processor implementation.\n"
-#define EXC_0x22 "Illegal instruction combination\n - See section for multi-issue rules in the ADSP-BF53x Blackfin\n Processor Instruction Set Reference.\n"
-#define EXC_0x23 "Data access CPLB protection violation\n - Attempted read or write to Supervisor resource,\n or illegal data memory access. \n"
-#define EXC_0x24 "Data access misaligned address violation\n - Attempted misaligned data memory or data cache access.\n"
-#define EXC_0x25 "Unrecoverable event\n - For example, an exception generated while processing a previous exception.\n"
-#define EXC_0x26 "Data access CPLB miss\n - Used by the MMU to signal a CPLB miss on a data access.\n"
-#define EXC_0x27 "Data access multiple CPLB hits\n - More than one CPLB entry matches data fetch address.\n"
-#define EXC_0x28 "Program Sequencer Exception caused by an emulation watchpoint match\n - There is a watchpoint match, and one of the EMUSW\n bits in the Watchpoint Instruction Address Control register (WPIACTL) is set.\n"
-#define EXC_0x2A "Instruction fetch misaligned address violation\n - Attempted misaligned instruction cache fetch. On a misaligned instruction fetch exception,\n the return address provided in RETX is the destination address which is misaligned, rather than the address of the offending instruction.\n"
-#define EXC_0x2B "CPLB protection violation\n - Illegal instruction fetch access (memory protection violation).\n"
-#define EXC_0x2C "Instruction fetch CPLB miss\n - CPLB miss on an instruction fetch.\n"
-#define EXC_0x2D "Instruction fetch multiple CPLB hits\n - More than one CPLB entry matches instruction fetch address.\n"
-#define EXC_0x2E "Illegal use of supervisor resource\n - Attempted to use a Supervisor register or instruction from User mode.\n Supervisor resources are registers and instructions that are reserved\n for Supervisor use: Supervisor only registers, all MMRs, and Supervisor\n only instructions.\n"
+#define HWC_x2(level) \
+	"System MMR Error\n" \
+	level " - An error occurred due to an invalid access to an System MMR location\n" \
+	level "   Possible reason: a 32-bit register is accessed with a 16-bit instruction\n" \
+	level "   or a 16-bit register is accessed with a 32-bit instruction.\n"
+#define HWC_x3(level) \
+	"External Memory Addressing Error\n"
+#define HWC_x12(level) \
+	"Performance Monitor Overflow\n"
+#define HWC_x18(level) \
+	"RAISE 5 instruction\n" \
+	level "    Software issued a RAISE 5 instruction to invoke the Hardware\n"
+#define HWC_default(level) \
+	 "Reserved\n"
+#define EXC_0x03(level) \
+	"Application stack overflow\n" \
+	level " - Please increase the stack size of the application using elf2flt -s option,\n" \
+	level "   and/or reduce the stack use of the application.\n"
+#define EXC_0x10(level) \
+	"Single step\n" \
+	level " - When the processor is in single step mode, every instruction\n" \
+	level "   generates an exception. Primarily used for debugging.\n"
+#define EXC_0x11(level) \
+	"Exception caused by a trace buffer full condition\n" \
+	level " - The processor takes this exception when the trace\n" \
+	level "   buffer overflows (only when enabled by the Trace Unit Control register).\n"
+#define EXC_0x21(level) \
+	"Undefined instruction\n" \
+	level " - May be used to emulate instructions that are not defined for\n" \
+	level "   a particular processor implementation.\n"
+#define EXC_0x22(level) \
+	"Illegal instruction combination\n" \
+	level " - See section for multi-issue rules in the ADSP-BF53x Blackfin\n" \
+	level "   Processor Instruction Set Reference.\n"
+#define EXC_0x23(level) \
+	"Data access CPLB protection violation\n" \
+	level " - Attempted read or write to Supervisor resource,\n" \
+	level "   or illegal data memory access. \n"
+#define EXC_0x24(level) \
+	"Data access misaligned address violation\n" \
+	level " - Attempted misaligned data memory or data cache access.\n"
+#define EXC_0x25(level) \
+	"Unrecoverable event\n" \
+	level " - For example, an exception generated while processing a previous exception.\n"
+#define EXC_0x26(level) \
+	"Data access CPLB miss\n" \
+	level " - Used by the MMU to signal a CPLB miss on a data access.\n"
+#define EXC_0x27(level) \
+	"Data access multiple CPLB hits\n" \
+	level " - More than one CPLB entry matches data fetch address.\n"
+#define EXC_0x28(level) \
+	"Program Sequencer Exception caused by an emulation watchpoint match\n" \
+	level " - There is a watchpoint match, and one of the EMUSW\n" \
+	level "   bits in the Watchpoint Instruction Address Control register (WPIACTL) is set.\n"
+#define EXC_0x2A(level) \
+	"Instruction fetch misaligned address violation\n" \
+	level " - Attempted misaligned instruction cache fetch. On a misaligned instruction fetch\n" \
+	level "   exception, the return address provided in RETX is the destination address which is\n" \
+	level "   misaligned, rather than the address of the offending instruction.\n"
+#define EXC_0x2B(level) \
+	"CPLB protection violation\n" \
+	level " - Illegal instruction fetch access (memory protection violation).\n"
+#define EXC_0x2C(level) \
+	"Instruction fetch CPLB miss\n" \
+	level " - CPLB miss on an instruction fetch.\n"
+#define EXC_0x2D(level) \
+	"Instruction fetch multiple CPLB hits\n" \
+	level " - More than one CPLB entry matches instruction fetch address.\n"
+#define EXC_0x2E(level) \
+	"Illegal use of supervisor resource\n" \
+	level " - Attempted to use a Supervisor register or instruction from User mode.\n" \
+	level "   Supervisor resources are registers and instructions that are reserved\n" \
+	level "   for Supervisor use: Supervisor only registers, all MMRs, and Supervisor\n" \
+	level "   only instructions.\n"
 
 #endif				/* __ASSEMBLY__ */
 #endif				/* _BFIN_TRAPS_H */
diff --git a/init/Kconfig b/init/Kconfig
index c5b354b..d35e44f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -438,7 +438,7 @@ menuconfig EMBEDDED
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
-	depends on ARM || BFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
+	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1e5f207..a601093 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -359,7 +359,7 @@ config DEBUG_HIGHMEM
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
 	depends on BUG
-	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || FRV || SUPERH || GENERIC_BUG || BFIN
+	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || FRV || SUPERH || GENERIC_BUG || BLACKFIN
 	default !EMBEDDED
 	help
 	  Say Y here to make BUG() panics output the file name and line number
@@ -409,7 +409,7 @@ config DEBUG_SG
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
-	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
+	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BLACKFIN)
 	default y if DEBUG_INFO && UML
 	help
 	  If you say Y here the resulting kernel image will be slightly larger
