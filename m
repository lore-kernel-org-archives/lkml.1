Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYAYNHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYAYNHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYAYNHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:07:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63732 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbYAYNHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:07:37 -0500
Date: Fri, 25 Jan 2008 14:07:14 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [GIT PULL] AVR32 update
Message-ID: <20080125140714.161cedb6@dhcp-252-066.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the for-linus branch of

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following changes.

Mathieu, this includes the patch that adds the instrumentation menu to
avr32, bringing it in line with most other architectures at the moment.
Please update your patch so that it also updates the avr32 Kconfig when
removing it.

David Brownell (1):
      [AVR32] extint: change set_irq_type() handling

Haavard Skinnemoen (16):
      [AVR32] Drop GFP_COMP for DMA memory allocations
      [AVR32] Remove redundant try_to_freeze() call from do_signal()
      ptrace: Call arch_ptrace_attach() when request=PTRACE_TRACEME
      [AVR32] Enable debugging only when needed
      [AVR32] Include instrumentation menu
      [AVR32] Oprofile support
      [AVR32] Provide more CPU information in /proc/cpuinfo and dmesg
      [AVR32] Add support for AT32AP7001 and AT32AP7002
      [AVR32] ATSTK1000: Move gpio-leds setup to setup.c
      [AVR32] Clean up external DAC setup code
      [AVR32] Add support for ATSTK1003 and ATSTK1004
      [AVR32] Kconfig: Choose daughterboard instead of CPU
      [AVR32] ATSTK1002: Update defconfig
      [AVR32] ATNGW100: Update defconfig
      [AVR32] NMI debugging
      [AVR32] extint: Set initial irq type to low level

Hans-Christian Egtvedt (1):
      Disable VGA text console for AVR32 architecture

Jan Engelhardt (1):
      [AVR32] constify function pointer tables

 Documentation/kernel-parameters.txt                |    5 +
 arch/avr32/Kconfig                                 |   47 +-
 arch/avr32/Kconfig.debug                           |   10 -
 arch/avr32/Makefile                                |    3 +-
 arch/avr32/boards/atngw100/setup.c                 |    2 +-
 arch/avr32/boards/atstk1000/Kconfig                |   58 +-
 arch/avr32/boards/atstk1000/Makefile               |    2 +
 arch/avr32/boards/atstk1000/atstk1000.h            |    2 +
 arch/avr32/boards/atstk1000/atstk1002.c            |  106 +--
 arch/avr32/boards/atstk1000/atstk1003.c            |  162 ++++
 arch/avr32/boards/atstk1000/atstk1004.c            |  147 +++
 arch/avr32/boards/atstk1000/setup.c                |   64 ++
 arch/avr32/configs/atngw100_defconfig              |  418 +++++---
 arch/avr32/configs/atstk1002_defconfig             |  637 ++++++++++---
 arch/avr32/configs/atstk1003_defconfig             | 1015 ++++++++++++++++++++
 arch/avr32/configs/atstk1004_defconfig             |  621 ++++++++++++
 arch/avr32/kernel/Makefile                         |    3 +-
 arch/avr32/kernel/cpu.c                            |   96 ++-
 arch/avr32/kernel/irq.c                            |   11 +
 arch/avr32/kernel/kprobes.c                        |    5 +-
 arch/avr32/kernel/nmi_debug.c                      |   82 ++
 arch/avr32/kernel/ocd.c                            |  163 ++++
 arch/avr32/kernel/process.c                        |    5 +-
 arch/avr32/kernel/ptrace.c                         |    5 +-
 arch/avr32/kernel/signal.c                         |    7 -
 arch/avr32/kernel/traps.c                          |   21 +-
 arch/avr32/mach-at32ap/Kconfig                     |   12 +-
 arch/avr32/mach-at32ap/Makefile                    |    4 +-
 .../mach-at32ap/{at32ap7000.c => at32ap700x.c}     |   15 +-
 arch/avr32/mach-at32ap/extint.c                    |   59 +-
 arch/avr32/mm/dma-coherent.c                       |    7 +
 arch/avr32/mm/tlb.c                                |    2 +-
 arch/avr32/oprofile/Makefile                       |    8 +
 arch/avr32/oprofile/op_model_avr32.c               |  235 +++++
 drivers/video/console/Kconfig                      |    2 +-
 drivers/watchdog/Kconfig                           |    2 +-
 .../arch-at32ap/{at32ap7000.h => at32ap700x.h}     |    6 +-
 include/asm-avr32/arch-at32ap/cpu.h                |    2 +-
 include/asm-avr32/arch-at32ap/io.h                 |    4 +-
 include/asm-avr32/irq.h                            |    5 +
 include/asm-avr32/kdebug.h                         |    1 +
 include/asm-avr32/ocd.h                            |    5 +
 include/asm-avr32/processor.h                      |   14 +
 include/asm-avr32/ptrace.h                         |   13 +-
 include/asm-avr32/thread_info.h                    |    1 +
 kernel/ptrace.c                                    |    2 +
 46 files changed, 3579 insertions(+), 517 deletions(-)
 create mode 100644 arch/avr32/boards/atstk1000/atstk1003.c
 create mode 100644 arch/avr32/boards/atstk1000/atstk1004.c
 create mode 100644 arch/avr32/configs/atstk1003_defconfig
 create mode 100644 arch/avr32/configs/atstk1004_defconfig
 create mode 100644 arch/avr32/kernel/nmi_debug.c
 create mode 100644 arch/avr32/kernel/ocd.c
 rename arch/avr32/mach-at32ap/{at32ap7000.c => at32ap700x.c} (98%)
 create mode 100644 arch/avr32/oprofile/Makefile
 create mode 100644 arch/avr32/oprofile/op_model_avr32.c
 rename include/asm-avr32/arch-at32ap/{at32ap7000.h => at32ap700x.h} (89%)
