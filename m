Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYJLPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYJLPDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 11:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYJLPD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 11:03:27 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:56562 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYJLPD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:03:26 -0400
Date: Sun, 12 Oct 2008 17:02:40 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] avr32 update
Message-ID: <20081012170240.55b3d030@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2008 15:02:29.0344 (UTC) FILETIME=[8BB7AE00:01C92C7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the below updates. Note that I had to pull the mmc changes I
sent to Pierre in order to resolve a few conflicts in the platform code.
They are the same commits that Pierre pulled, so I believe git will
sort it out nicely.

Other than that, this is fairly boring. There is support for a few more
boards cooking, which I may be sending you in a second update if they
get finished within the next week. There are also some tricky power
management patches currently being reviewed.

I also have a large pile of patches for the not-yet-released AT32AP7200
chip, which I intend to start pushing upstream for 2.6.29 after this
merge window closes.

On the bright side, the amount of contributions from people outside
Atmel seems to be increasing steadily. Keep up the good work, everyone!

Haavard

Alex Raimondi (1):
      avr32: Replace static clock list with dynamic linked list

David Brownell (1):
      ngw100: export J15 through sysfs

Haavard Skinnemoen (13):
      avr32: Provide a way to deselect pins in the portmux
      atmel-mci: Initialize BLKR before sending data transfer command
      atmel-mci: Implement tasklet as a state machine
      atmel-mci: Don't stop the clock between transfers
      atmel-mci: Platform code for supporting multiple mmc slots
      atmel-mci: support multiple mmc slots
      atmel-mci: Add experimental DMA support
      atmel-mci: Don't overwrite error bits when NOTBUSY is set
      atmel-mci: Add missing flush_dcache_page() in PIO transfer code
      avr32: Implement {read,write}[bwl]_be
      avr32: Minor pm_power_off cleanup
      Merge branch 'master' of git://git.kernel.org/.../hskinnemoen/atmel-mci-2.6.28
      avr32: Fix build failures in board code

Harvey Harrison (1):
      avr32: use the new byteorder headers

Julien May (2):
      avr32: Allow fine-grained control over LCDC pins
      avr32: Allow selecting multiple pins at once

Marco Stornelli (1):
      avr32: added mem kernel command line option support

Nikolaus Voss (1):
      Add kernel support for oprofile callgraphs on AVR32

Uwe Kleine-König (2):
      avr32: Use platform_driver_probe for pio platform driver
      avr32: Use platform_driver_probe for pdc platform driver

 arch/avr32/boards/atngw100/setup.c               |   19 +-
 arch/avr32/boards/atstk1000/atstk1002.c          |   23 +-
 arch/avr32/boards/atstk1000/atstk1003.c          |   15 +-
 arch/avr32/boards/atstk1000/atstk1004.c          |   18 +-
 arch/avr32/include/asm/atmel-mci.h               |   32 +-
 arch/avr32/include/asm/byteorder.h               |   22 +-
 arch/avr32/include/asm/io.h                      |    8 +
 arch/avr32/kernel/process.c                      |    3 +-
 arch/avr32/kernel/setup.c                        |   19 +
 arch/avr32/mach-at32ap/at32ap700x.c              |  460 +++++----
 arch/avr32/mach-at32ap/clock.c                   |   52 +-
 arch/avr32/mach-at32ap/clock.h                   |    8 +-
 arch/avr32/mach-at32ap/include/mach/at32ap700x.h |  128 ++
 arch/avr32/mach-at32ap/include/mach/board.h      |    2 +-
 arch/avr32/mach-at32ap/include/mach/io.h         |    3 +-
 arch/avr32/mach-at32ap/include/mach/portmux.h    |    5 +-
 arch/avr32/mach-at32ap/pdc.c                     |    3 +-
 arch/avr32/mach-at32ap/pio.c                     |   63 +-
 arch/avr32/oprofile/Makefile                     |    2 +-
 arch/avr32/oprofile/backtrace.c                  |   81 ++
 arch/avr32/oprofile/op_model_avr32.c             |    4 +
 drivers/mmc/host/Kconfig                         |   11 +
 drivers/mmc/host/atmel-mci-regs.h                |    6 +-
 drivers/mmc/host/atmel-mci.c                     | 1358 ++++++++++++++++------
 24 files changed, 1696 insertions(+), 649 deletions(-)
 create mode 100644 arch/avr32/oprofile/backtrace.c
