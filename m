Return-Path: <linux-kernel-owner+w=401wt.eu-S1764137AbXGLPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764137AbXGLPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXGLPdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:33:08 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:42659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXGLPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:33:06 -0400
X-IronPort-AV: i="4.16,533,1175486400"; 
   d="scan'208"; a="34749838:sNHT33312881"
Subject: [GIT PULL] Blackfin updates for 2.6.23
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 12 Jul 2007 23:32:56 +0800
Message-Id: <1184254376.6735.8.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Jul 2007 15:33:02.0721 (UTC) FILETIME=[EF4D4F10:01C7C499]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Blackfin architecture updates for 2.6.23 from:

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/
master

A new Blackfin processor BF54x is initial supported:

The ADSP-BF54x was specifically designed to meet the needs of convergent multimedia
applications where system performance and cost are essential ingredients. The
integration of multimedia, human interface, and connectivity peripherals combined
with increased system bandwidth and on-chip memory provides customers a platform to
design the most demanding applications.

Since now, ADSP-BF54x will be supported in the Linux kernel and bunch of related drivers
such as USB OTG, ATAPI, NAND flash controller, LCD framebuffer, sound, touch screen will
be submitted later.

Bernd updates some critical code related CPBL or nommu

And some bug fixing and coding style cleanup.

Alex Landau (1):
      Blackfin arch: Port the dm9000 driver to Blackfin by using the correct low-level io routines

Bernd Schmidt (2):
      Blackfin arch: defines and provides entry points for certain user space functions at fixed addresses
      Blackfin arch: Start untangling the CPLB handling code.

Bryan Wu (2):
      Blackfin arch: clean up some coding style issues
      Blackfin arch: add missing CONFIG_LARGE_ALLOCS when upstream merging

Michael Hennerich (9):
      Blackfin arch: add missing implementations SIC_IWR crosses several registers
      Blackfin arch: Enable BF54x PIN/GPIO interrupts
      Blackfin arch: Some memory and code optimizations - Fix SYS_IRQS
      Blackfin arch: add BF54x missing GPIO access functions
      Blackfin arch: Fix Warning add some defines in BF54x header file
      Blackfin arch: There is no CDPRIO Bit in the EBIU_AMGCTL Register of BF54x arch
      Blackfin arch: Disable CACHELINE_ALIGNED_L1 for BF54x by default
      Blackfin arch: Add Support for Peripheral PortMux and resouce allocation
      Video Console: Blackfin doesnt support VGA console

Mike Frysinger (8):
      Blackfin arch: new kernel config for BF548-EZKIT
      Blackfin arch: need to rename function after moving to match new internal dma API
      Blackfin arch: cleanup warnings from checkpatch -- no functional changes
      Blackfin arch: scrub dead code
      Blackfin arch: use PAGE_SIZE when doing aligns rather than hardcoded values
      Blackfin arch: combine the common code of free_initrd_mem and free_initmem
      Blackfin arch: extract the entry point from the linked kernel
      Blackfin arch: as pointed out by Robert P. J. Day, update the CPU_FREQ name to match current Kconfig

Robin Getz (1):
      Blackfin arch: Clean up trace buffer handling, No major functional changes.

Roy Huang (3):
      Blackfin arch: Add header files for BF548
      Blackfin arch: initial supporting for BF548-EZKIT
      Blackfin serial driver: supporting BF548-EZKIT serial port

Sonic Zhang (4):
      Blackfin arch: kgdb specific code
      Blackfin arch: fix bug set dma_address properly in dma_map_sg
      Blackfin arch: set up gpio interrupt IRQ_PJ9 for BF54x ATAPI PATA driver
      Blackfin arch: Add peripheral io API to gpio header file

 Documentation/blackfin/kgdb.txt                    |  155 +++
 arch/blackfin/Kconfig                              |   59 +-
 arch/blackfin/Makefile                             |    2 +
 arch/blackfin/boot/Makefile                        |    3 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig        | 1100 ++++++++++++++++
 arch/blackfin/kernel/Makefile                      |    7 +-
 arch/blackfin/kernel/asm-offsets.c                 |    7 +-
 arch/blackfin/kernel/bfin_dma_5xx.c                |  251 +----
 arch/blackfin/kernel/bfin_gpio.c                   |   11 +-
 arch/blackfin/kernel/bfin_ksyms.c                  |    5 +-
 arch/blackfin/kernel/cacheinit.c                   |   66 +
 arch/blackfin/kernel/cplbinit.c                    |  433 +++++++
 arch/blackfin/kernel/dma-mapping.c                 |   13 +-
 arch/blackfin/kernel/dualcore_test.c               |    6 +-
 arch/blackfin/kernel/fixed_code.S                  |  132 ++
 arch/blackfin/kernel/flat.c                        |   55 +-
 arch/blackfin/kernel/irqchip.c                     |    2 +-
 arch/blackfin/kernel/kgdb.c                        |  421 ++++++
 arch/blackfin/kernel/module.c                      |   32 +-
 arch/blackfin/kernel/process.c                     |   75 +-
 arch/blackfin/kernel/ptrace.c                      |    6 +-
 arch/blackfin/kernel/setup.c                       |  368 +-----
 arch/blackfin/kernel/signal.c                      |   10 +-
 arch/blackfin/kernel/sys_bfin.c                    |    8 +-
 arch/blackfin/kernel/time.c                        |    4 +-
 arch/blackfin/kernel/traps.c                       |   62 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |   12 +-
 arch/blackfin/lib/strcmp.c                         |    3 +-
 arch/blackfin/lib/strcpy.c                         |    3 +-
 arch/blackfin/lib/strncmp.c                        |    3 +-
 arch/blackfin/lib/strncpy.c                        |    3 +-
 arch/blackfin/mach-bf533/Makefile                  |    4 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   14 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |    8 +-
 arch/blackfin/mach-bf533/boards/generic_board.c    |    6 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |   30 +-
 arch/blackfin/mach-bf533/cpu.c                     |    3 +-
 arch/blackfin/mach-bf533/dma.c                     |   95 ++
 arch/blackfin/mach-bf533/head.S                    |    5 +
 arch/blackfin/mach-bf533/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf537/Makefile                  |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   16 +-
 arch/blackfin/mach-bf537/boards/eth_mac.c          |    5 +-
 arch/blackfin/mach-bf537/boards/generic_board.c    |   36 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |   54 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   77 +-
 arch/blackfin/mach-bf537/dma.c                     |  115 ++
 arch/blackfin/mach-bf537/head.S                    |    6 +
 arch/blackfin/mach-bf537/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf548/Kconfig                   |  316 +++++
 arch/blackfin/mach-bf548/Makefile                  |    9 +
 arch/blackfin/mach-bf548/boards/Makefile           |    5 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |  114 ++
 arch/blackfin/mach-bf548/boards/led.S              |  172 +++
 arch/blackfin/mach-bf548/cpu.c                     |  159 +++
 arch/blackfin/mach-bf548/dma.c                     |  156 +++
 arch/blackfin/mach-bf548/gpio.c                    |  323 +++++
 arch/blackfin/mach-bf548/head.S                    |  512 ++++++++
 arch/blackfin/mach-bf548/ints-priority.c           |  137 ++
 arch/blackfin/mach-bf561/Makefile                  |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   32 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   33 +-
 arch/blackfin/mach-bf561/boards/generic_board.c    |    6 +-
 arch/blackfin/mach-bf561/boards/tepla.c            |    6 +-
 arch/blackfin/mach-bf561/coreb.c                   |   18 +-
 arch/blackfin/mach-bf561/dma.c                     |  131 ++
 arch/blackfin/mach-bf561/head.S                    |    6 +
 arch/blackfin/mach-bf561/ints-priority.c           |    2 +-
 arch/blackfin/mach-common/Makefile                 |    4 +-
 arch/blackfin/mach-common/cacheinit.S              |   89 +--
 arch/blackfin/mach-common/cplbinfo.c               |   13 +-
 arch/blackfin/mach-common/entry.S                  |   76 +-
 arch/blackfin/mach-common/interrupt.S              |    8 +-
 arch/blackfin/mach-common/ints-priority-dc.c       |   13 +-
 arch/blackfin/mach-common/ints-priority-sc.c       |  405 ++++++-
 arch/blackfin/mach-common/pm.c                     |    4 +-
 arch/blackfin/mm/blackfin_sram.c                   |    4 +-
 arch/blackfin/mm/init.c                            |   47 +-
 arch/blackfin/oprofile/common.c                    |    6 +-
 arch/blackfin/oprofile/op_model_bf533.c            |    6 +-
 arch/blackfin/oprofile/timer_int.c                 |    3 +-
 drivers/net/Kconfig                                |    2 +-
 drivers/net/dm9000.c                               |   17 +-
 drivers/serial/Kconfig                             |   48 +-
 drivers/serial/bfin_5xx.c                          |  182 +++-
 drivers/video/console/Kconfig                      |    2 +-
 include/asm-blackfin/Kbuild                        |    2 +
 include/asm-blackfin/bfin-global.h                 |   12 +
 include/asm-blackfin/cplbinit.h                    |  133 +--
 include/asm-blackfin/fixed_code.h                  |   20 +
 include/asm-blackfin/gpio.h                        |   58 +
 include/asm-blackfin/hardirq.h                     |    4 +
 include/asm-blackfin/kgdb.h                        |  183 +++
 include/asm-blackfin/mach-bf533/dma.h              |    3 +
 include/asm-blackfin/mach-bf533/portmux.h          |   65 +
 include/asm-blackfin/mach-bf537/dma.h              |    3 +
 include/asm-blackfin/mach-bf537/portmux.h          |  109 ++
 include/asm-blackfin/mach-bf548/anomaly.h          |   74 ++
 include/asm-blackfin/mach-bf548/bf548.h            |  271 ++++
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |  193 +++
 include/asm-blackfin/mach-bf548/blackfin.h         |  168 +++
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |   72 +-
 include/asm-blackfin/mach-bf548/defBF542.h         |  281 ----
 include/asm-blackfin/mach-bf548/defBF544.h         |   60 -
 include/asm-blackfin/mach-bf548/defBF548.h         |  341 -----
 include/asm-blackfin/mach-bf548/defBF549.h         |  763 +-----------
 include/asm-blackfin/mach-bf548/defBF54x_base.h    | 1366 +++-----------------
 include/asm-blackfin/mach-bf548/dma.h              |   73 ++
 include/asm-blackfin/mach-bf548/gpio.h             |  216 +++
 include/asm-blackfin/mach-bf548/irq.h              |  467 +++++++
 include/asm-blackfin/mach-bf548/mem_init.h         |  189 +++
 include/asm-blackfin/mach-bf548/mem_map.h          |   97 ++
 include/asm-blackfin/mach-bf548/portmux.h          |  270 ++++
 include/asm-blackfin/mach-bf561/cdefBF561.h        |    9 +-
 include/asm-blackfin/mach-bf561/dma.h              |    3 +
 include/asm-blackfin/mach-bf561/portmux.h          |   87 ++
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |   23 +-
 include/asm-blackfin/mman.h                        |    2 -
 include/asm-blackfin/page.h                        |    4 +
 include/asm-blackfin/portmux.h                     | 1133 ++++++++++++++++
 include/asm-blackfin/trace.h                       |   52 +
 121 files changed, 9767 insertions(+), 3904 deletions(-)
 create mode 100644 Documentation/blackfin/kgdb.txt
 create mode 100644 arch/blackfin/configs/BF548-EZKIT_defconfig
 create mode 100644 arch/blackfin/kernel/cacheinit.c
 create mode 100644 arch/blackfin/kernel/cplbinit.c
 create mode 100644 arch/blackfin/kernel/fixed_code.S
 create mode 100644 arch/blackfin/kernel/kgdb.c
 create mode 100644 arch/blackfin/mach-bf533/dma.c
 create mode 100644 arch/blackfin/mach-bf537/dma.c
 create mode 100644 arch/blackfin/mach-bf548/Kconfig
 create mode 100644 arch/blackfin/mach-bf548/Makefile
 create mode 100644 arch/blackfin/mach-bf548/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf548/boards/ezkit.c
 create mode 100644 arch/blackfin/mach-bf548/boards/led.S
 create mode 100644 arch/blackfin/mach-bf548/cpu.c
 create mode 100644 arch/blackfin/mach-bf548/dma.c
 create mode 100644 arch/blackfin/mach-bf548/gpio.c
 create mode 100644 arch/blackfin/mach-bf548/head.S
 create mode 100644 arch/blackfin/mach-bf548/ints-priority.c
 create mode 100644 arch/blackfin/mach-bf561/dma.c
 create mode 100644 include/asm-blackfin/fixed_code.h
 create mode 100644 include/asm-blackfin/kgdb.h
 create mode 100644 include/asm-blackfin/mach-bf533/portmux.h
 create mode 100644 include/asm-blackfin/mach-bf537/portmux.h
 create mode 100644 include/asm-blackfin/mach-bf548/anomaly.h
 create mode 100644 include/asm-blackfin/mach-bf548/bf548.h
 create mode 100644 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
 create mode 100644 include/asm-blackfin/mach-bf548/blackfin.h
 create mode 100644 include/asm-blackfin/mach-bf548/dma.h
 create mode 100644 include/asm-blackfin/mach-bf548/gpio.h
 create mode 100644 include/asm-blackfin/mach-bf548/irq.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_init.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_map.h
 create mode 100644 include/asm-blackfin/mach-bf548/portmux.h
 create mode 100644 include/asm-blackfin/mach-bf561/portmux.h
 create mode 100644 include/asm-blackfin/portmux.h
 create mode 100644 include/asm-blackfin/trace.h
