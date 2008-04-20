Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbYDTBJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbYDTBJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYDTBJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:09:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48763 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYDTBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:09:41 -0400
Date: Sat, 19 Apr 2008 21:09:15 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Stelian Pop <stelian@popies.net>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PULL] AVR32 update
Message-ID: <20080419210915.5decdc86@siona.local>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Apr 2008 01:09:19.0486 (UTC) FILETIME=[292671E0:01C8A283]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates.

This has been tested somewhat less than usual since I've been traveling
for the past three weeks, but linux-next shows all green lights and
it's not going to get any better by me sitting on this stuff forever,
and the juicy stuff has been in our vendor tree for a while, so I feel
pretty confident about it. This merge ended up a bit smaller than I had
hoped for though...I might push power management support later if I
ever get home from Atlanta.

Stelian and Nicolas, once this is merged, everything should be set
for the rest of the AT91 USB stuff.

Adrian Bunk (5):
      add include/asm-avr32/xor.h
      avr32: don't offer CONFIG_RTC
      avr32: don't offer CONFIG_GEN_RTC
      avr32: don't offer PARPORT_PC
      avr32: add include/asm-avr32/serial.h

Ben Nizette (1):
      avr32: pass i2c board info through at32_add_device_twi

Cyrill Gorcunov (1):
      avr32: cleanup - use _AC macro to define PAGE_SIZE

David Brownell (5):
      atmel_tc library
      atmel_tc clocksource/clockevent code
      tclib: Fix compile warnings
      avr32: start clocksource cleanup
      avr32: Generic clockevents support

Haavard Skinnemoen (6):
      atmel_usba: Kill copy_to_fifo() and copy_from_fifo()
      Merge branch 'master' of git://git.kernel.org/.../hskinnemoen/tclib into base
      Merge branch 'master' of git://git.kernel.org/.../hskinnemoen/usba-2.6.26 into base
      avr32: Delete mostly unused header asm/intc.h
      avr32: Use constants from sysreg.h in asm.h
      avr32: Move sleep code into mach-at32ap

Hans-Christian Egtvedt (2):
      Generate raw keyboard codes for AVR32 architecture
      avr32: Implement set_rate(), set_parent() and mode() for pll1

Johannes Weiner (1):
      avr32: Remove two unused #defines from mm/init.c

Peter Ma (1):
      avr32: Add hardware power-down function call

Stelian Pop (5):
      atmel_usba_udc: Fix endpoint names.
      atmel_usba_udc: Kill GPIO_PIN_NONE
      atmel_usba_udc: move endpoint declarations into platform data.
      atmel_usba_udc: Add missing kfree() in usba_udc_remove()
      atmel_usba_udc: Add support for AT91CAP9 UDPHS

 arch/avr32/Kconfig                     |    5 +
 arch/avr32/kernel/entry-avr32b.S       |   20 --
 arch/avr32/kernel/process.c            |    6 +-
 arch/avr32/kernel/time.c               |  248 +++++++++-----------------
 arch/avr32/mach-at32ap/Makefile        |    3 +-
 arch/avr32/mach-at32ap/at32ap700x.c    |  243 +++++++++++++++++++++++--
 arch/avr32/mach-at32ap/intc.c          |    1 -
 arch/avr32/mach-at32ap/pm-at32ap700x.S |   66 +++++++
 arch/avr32/mach-at32ap/time-tc.c       |  218 -----------------------
 arch/avr32/mm/init.c                   |    3 -
 arch/avr32/oprofile/op_model_avr32.c   |    1 -
 drivers/char/Kconfig                   |    4 +-
 drivers/char/keyboard.c                |    3 +-
 drivers/clocksource/Makefile           |    1 +
 drivers/clocksource/tcb_clksrc.c       |  302 ++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig                   |   33 ++++
 drivers/misc/Makefile                  |    1 +
 drivers/misc/atmel_tclib.c             |  161 +++++++++++++++++
 drivers/parport/Kconfig                |    2 +-
 drivers/usb/gadget/Kconfig             |    4 +-
 drivers/usb/gadget/atmel_usba_udc.c    |  156 ++++++++---------
 drivers/usb/gadget/atmel_usba_udc.h    |    9 +
 include/asm-avr32/arch-at32ap/board.h  |    9 +-
 include/asm-avr32/arch-at32ap/pm.h     |   48 +++++
 include/asm-avr32/arch-at32ap/time.h   |  112 ------------
 include/asm-avr32/asm.h                |    8 +-
 include/asm-avr32/intc.h               |  128 --------------
 include/asm-avr32/irq.h                |    5 +
 include/asm-avr32/page.h               |    8 +-
 include/asm-avr32/serial.h             |   13 ++
 include/asm-avr32/xor.h                |    6 +
 include/linux/atmel_tc.h               |  252 ++++++++++++++++++++++++++
 include/linux/usb/atmel_usba_udc.h     |   22 +++
 33 files changed, 1329 insertions(+), 772 deletions(-)
 create mode 100644 arch/avr32/mach-at32ap/pm-at32ap700x.S
 delete mode 100644 arch/avr32/mach-at32ap/time-tc.c
 create mode 100644 drivers/clocksource/tcb_clksrc.c
 create mode 100644 drivers/misc/atmel_tclib.c
 create mode 100644 include/asm-avr32/arch-at32ap/pm.h
 delete mode 100644 include/asm-avr32/arch-at32ap/time.h
 delete mode 100644 include/asm-avr32/intc.h
 create mode 100644 include/asm-avr32/serial.h
 create mode 100644 include/asm-avr32/xor.h
 create mode 100644 include/linux/atmel_tc.h
 create mode 100644 include/linux/usb/atmel_usba_udc.h
