Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbXD0OJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbXD0OJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXD0OJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:09:41 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59710 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755934AbXD0OJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:09:23 -0400
Date: Fri, 27 Apr 2007 16:09:15 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] AVR32 update
Message-ID: <20070427160915.1ad41159@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch of

  git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates. This includes support for the
ATNGW100 Network Gateway reference design and a nice assortment of
cleanups, fixes and optimizations.

Haavard Skinnemoen (16):
      [AVR32] Add basic HMATRIX support
      [AVR32] Add mach-specific Kconfig
      [AVR32] Don't enable clocks with no users
      [AVR32] Clean up asm/sysreg.h
      [AVR32] Clean up cpu identification and add features bitmap
      [AVR32] Clean up exception handling code
      [AVR32] Fix NMI handler
      [AVR32] Make I/O access macros work with external devices
      [AVR32] Move setup_bootmem() from mm/init.c to kernel/setup.c
      [AVR32] Simplify early handling of memory regions
      [AVR32] Reserve framebuffer memory in early_parse_fbmem()
      [AVR32] Get rid of board_setup_fbmem()
      [AVR32] Use memcpy/memset in memcpy_{from,to}_io and memset_io
      [AVR32] Board code for ATNGW100
      [AVR32] Optimize the TLB miss handler
      [AVR32] Fix compile error with gcc 4.1

Hans-Christian Egtvedt (3):
      [AVR32] Add nwait and tdf parameters to SMC configuration
      [AVR32] Change system timer from count-compare to Timer/Counter 0
      [AVR32] Put cpu in sleep 0 when idle.

Mathieu Desnoyers (1):
      avr32: remove unneeded cast in atomic.h

Robert P. J. Day (1):
      AVR32: Remove useless config option "GENERIC_BUST_SPINLOCK".

 arch/avr32/Kconfig                      |   13 +-
 arch/avr32/Makefile                     |    1 +
 arch/avr32/boards/atngw100/Makefile     |    1 +
 arch/avr32/boards/atngw100/flash.c      |   95 +++
 arch/avr32/boards/atngw100/setup.c      |  124 ++++
 arch/avr32/boards/atstk1000/atstk1002.c |    4 +-
 arch/avr32/boards/atstk1000/setup.c     |   30 -
 arch/avr32/configs/atngw100_defconfig   | 1085 +++++++++++++++++++++++++++++++
 arch/avr32/kernel/cpu.c                 |   64 ++-
 arch/avr32/kernel/entry-avr32b.S        |  124 +++--
 arch/avr32/kernel/module.c              |   11 +-
 arch/avr32/kernel/process.c             |  193 +++++-
 arch/avr32/kernel/setup.c               |  484 +++++++++++----
 arch/avr32/kernel/time.c                |  150 +++--
 arch/avr32/kernel/traps.c               |  421 ++++---------
 arch/avr32/kernel/vmlinux.lds.c         |    9 +-
 arch/avr32/mach-at32ap/Kconfig          |   31 +
 arch/avr32/mach-at32ap/Makefile         |    1 +
 arch/avr32/mach-at32ap/at32ap7000.c     |   70 ++-
 arch/avr32/mach-at32ap/hmatrix.h        |  182 ++++++
 arch/avr32/mach-at32ap/hsmc.c           |   23 +
 arch/avr32/mach-at32ap/time-tc.c        |  218 +++++++
 arch/avr32/mm/fault.c                   |  116 ++---
 arch/avr32/mm/init.c                    |  238 -------
 include/asm-avr32/arch-at32ap/io.h      |   39 ++
 include/asm-avr32/arch-at32ap/smc.h     |   22 +
 include/asm-avr32/arch-at32ap/time.h    |  112 ++++
 include/asm-avr32/atomic.h              |    2 +-
 include/asm-avr32/bug.h                 |   50 ++-
 include/asm-avr32/io.h                  |  326 +++++-----
 include/asm-avr32/processor.h           |   15 +-
 include/asm-avr32/setup.h               |   13 +-
 include/asm-avr32/sysreg.h              |  543 +++++++---------
 include/asm-avr32/system.h              |   13 +-
 include/asm-avr32/thread_info.h         |    2 +
 include/asm-avr32/uaccess.h             |   13 +-
 36 files changed, 3435 insertions(+), 1403 deletions(-)
 create mode 100644 arch/avr32/boards/atngw100/Makefile
 create mode 100644 arch/avr32/boards/atngw100/flash.c
 create mode 100644 arch/avr32/boards/atngw100/setup.c
 create mode 100644 arch/avr32/configs/atngw100_defconfig
 create mode 100644 arch/avr32/mach-at32ap/Kconfig
 create mode 100644 arch/avr32/mach-at32ap/hmatrix.h
 create mode 100644 arch/avr32/mach-at32ap/time-tc.c
 create mode 100644 include/asm-avr32/arch-at32ap/io.h
 create mode 100644 include/asm-avr32/arch-at32ap/time.h
