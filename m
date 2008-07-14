Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYGNKSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYGNKSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYGNKSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:18:01 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39832 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbYGNKSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:18:00 -0400
Date: Mon, 14 Jul 2008 12:17:34 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: [GIT PULL] avr32 updates for 2.6.27
Message-ID: <20080714121734.453f5045@siona.local>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2008 10:17:37.0763 (UTC) FILETIME=[D729E330:01C8E59A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'master' branch of

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

Among other things, this includes standby and suspend-to-ram support
for avr32, which I originally aimed at the previous merge window but
found myself way too busy with other stuff to be able to actually
finish it up properly. So at this point, it already has more than three
months of exposure through our vendor tree.

The rtc, net and serial driver changes are related to power management.
Without them, power management acts a bit funny on avr32 (and I would
have thought at91 power management acts a bit strange too without the
macb change). I didn't get any response from the relevant maintainers,
so I took them myself.

There are also a few small changes in here needed for out-of-tree
boards that I'm hoping will find their way into mainline in the near
future.

Alex (1):
      avr32: Allow board to define oscillator rates

David Brownell (3):
      avr32: minor GPIO handling updates
      avr32: improve NGW100 I2C/PMBus setup
      at32ap700x spi: enable pullups on MISO

Haavard Skinnemoen (22):
      avr32: Provide PCI DMA mapping API
      avr32: export empty_zero_page
      avr32: Fix wrong I/O access size in __raw_readsb
      avr32: Clean up time.c #includes
      avr32: Kill unneeded #include <asm/pgalloc.h> from asm/mmu_context.h
      avr32: Kill special exception handler sections
      avr32: Move setup_platform() into chip-specific file
      avr32: Rename at32ap.c -> pdc.c
      avr32: Clean up and optimize the TLB operations
      avr32: Remove useless zeroing of swapper_pg_dir at startup
      avr32: Store virtual addresses in the PGD
      avr32: Cover the kernel page tables in the user PGDs
      avr32: Use a quicklist for PGD allocation
      avr32: Use a quicklist for PTE allocation as well
      atmel_serial: Fix build on avr32 with CONFIG_PM enabled
      atmel_serial: Drain console TX shifter before suspending
      macb: Basic suspend/resume support
      rtc-at32ap700x: Enable wakeup
      avr32: Enable SDRAMC clock at startup
      avr32: Add simple SRAM allocator
      avr32: Add system device for the internal interrupt controller (intc)
      avr32: Power Management support ("standby" and "mem" modes)

Hans-Christian Egtvedt (3):
      avr32: Add pin configuration choice to LCDC peripheral
      avr32: Add PSIF platform devices
      avr32: Fix typo of IFSR in a comment in the PIO header file

Martin Koegler (1):
      avr32: Fix sigaltstack behaviour

Sedji Gaouaou (1):
      atmel_pwm: Rename the "mck" clock to "pwm_clk"

 arch/avr32/Kconfig                         |    9 +
 arch/avr32/boards/atngw100/setup.c         |   29 ++++
 arch/avr32/boards/atstk1000/atstk1002.c    |    8 +-
 arch/avr32/boards/atstk1000/atstk1003.c    |    7 +
 arch/avr32/boards/atstk1000/atstk1004.c    |    9 +-
 arch/avr32/kernel/entry-avr32b.S           |   88 ++++++----
 arch/avr32/kernel/signal.c                 |    3 +
 arch/avr32/kernel/time.c                   |   14 +--
 arch/avr32/kernel/vmlinux.lds.S            |   12 +-
 arch/avr32/lib/io-readsb.S                 |    2 +-
 arch/avr32/mach-at32ap/Makefile            |    7 +-
 arch/avr32/mach-at32ap/at32ap700x.c        |  252 ++++++++++++++++++++++------
 arch/avr32/mach-at32ap/intc.c              |   80 +++++++++-
 arch/avr32/mach-at32ap/{at32ap.c => pdc.c} |    8 -
 arch/avr32/mach-at32ap/pio.c               |    2 +
 arch/avr32/mach-at32ap/pio.h               |    2 +-
 arch/avr32/mach-at32ap/pm-at32ap700x.S     |  108 ++++++++++++
 arch/avr32/mach-at32ap/pm.c                |  245 +++++++++++++++++++++++++++
 arch/avr32/mach-at32ap/sdramc.h            |   76 +++++++++
 arch/avr32/mm/init.c                       |   22 +--
 arch/avr32/mm/tlb.c                        |  175 ++++++++++----------
 drivers/misc/atmel_pwm.c                   |    2 +-
 drivers/net/macb.c                         |   37 ++++
 drivers/rtc/rtc-at32ap700x.c               |    3 +
 drivers/serial/atmel_serial.c              |   17 ++-
 include/asm-avr32/arch-at32ap/board.h      |   10 +-
 include/asm-avr32/arch-at32ap/init.h       |    4 -
 include/asm-avr32/arch-at32ap/pm.h         |    3 +
 include/asm-avr32/arch-at32ap/sram.h       |   30 ++++
 include/asm-avr32/mmu_context.h            |    1 -
 include/asm-avr32/pci.h                    |    2 +
 include/asm-avr32/pgalloc.h                |   68 +++++---
 include/asm-avr32/pgtable.h                |   34 ++---
 include/asm-avr32/thread_info.h            |    1 +
 include/asm-avr32/tlbflush.h               |    1 -
 mm/Kconfig                                 |    2 +-
 36 files changed, 1093 insertions(+), 280 deletions(-)
 rename arch/avr32/mach-at32ap/{at32ap.c => pdc.c} (90%)
 create mode 100644 arch/avr32/mach-at32ap/pm.c
 create mode 100644 arch/avr32/mach-at32ap/sdramc.h
 create mode 100644 include/asm-avr32/arch-at32ap/sram.h
