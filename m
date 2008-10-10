Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYJJKhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYJJKhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYJJKgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:36:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42510 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753690AbYJJKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:36:46 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 00/27] First block of the tty backlog
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:36:31 +0100
Message-ID: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches implements the various corrections, removals and fixups
that do not form part of the core tty updates. It also omits some 8250 patches
which have a dependancy on Ingo's upcoming submission to remove NR_IRQ.

These have been sitting in linux-next for quite some time

Alan
---

Adrian Bunk (1):
      coldfire: scheduled SERIAL_COLDFIRE removal

Akinobu Mita (1):
      ip2: avoid add_timer with pending timer

Alan Cox (4):
      serial_8250: pci_enable_device fail is not fully handled
      ftdi: A few errors are err() that should be debug which causes much spewage
      nozomi: Fix close on error
      epca: call tty_port_init

Andrew Morton (1):
      serial-make-uart_ports-ioport-unsigned-long-fix

David Miller (1):
      serial: Make uart_port's ioport "unsigned long".

Graf Yang (1):
      Blackfin Serial Driver: Fix bug - ircp fails on sir over Blackfin UART

Jason Wessel (1):
      usb: fix pl2303 initialization

Jiri Slaby (6):
      ip2, init/deinit cleanup
      ip2, fix sparse warnings
      ip2, cleanup globals
      Char: merge ip2main and ip2base
      Char: sx, fix io unmapping
      Char: cyclades. remove bogus iomap

Julia Lawall (2):
      drivers/char/hvc_console.c: adjust call to put_tty_driver
      drivers/serial/crisv10.c: add missing put_tty_driver

Mike Frysinger (3):
      Blackfin Serial Driver: move common variables out of serial headers and into the serial driver
      Blackfin Serial Driver: trim trailing whitespace -- no functional changes
      Blackfin Serial Driver: use __initdata for data, not __init

Miloslav Trmac (1):
      audit: Handle embedded NUL in TTY input auditing

Scott Ashcroft (1):
      Fix oti6858 debug level

Sonic Zhang (4):
      Blackfin Serial Driver: Fix bug - request UART2/3 peripheral mapped interrupts in PIO mode
      Blackfin Serial Driver: Fix bug - Don't call tx_stop in tx_transfer.
      Blackfin Serial Driver: Remove useless stop
      Blackfin Serial Driver: Fix bug - should suspend/resume/remove all uart ports.


 Documentation/feature-removal-schedule.txt         |    8 
 arch/blackfin/kernel/bfin_dma_5xx.c                |   13 
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    4 
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    4 
 drivers/char/cyclades.c                            |   21 
 drivers/char/epca.c                                |    5 
 drivers/char/hvc_console.c                         |    4 
 drivers/char/ip2/Makefile                          |    2 
 drivers/char/ip2/i2ellis.c                         |   32 
 drivers/char/ip2/i2ellis.h                         |    2 
 drivers/char/ip2/ip2base.c                         |  108 -
 drivers/char/ip2/ip2main.c                         |  544 +++---
 drivers/char/nozomi.c                              |    5 
 drivers/char/sx.c                                  |    4 
 drivers/char/tty_audit.c                           |    2 
 drivers/serial/8250_pci.c                          |    4 
 drivers/serial/Kconfig                             |   16 
 drivers/serial/Makefile                            |    1 
 drivers/serial/bfin_5xx.c                          |  123 +
 drivers/serial/crisv10.c                           |    2 
 drivers/serial/mcfserial.c                         | 1965 --------------------
 drivers/serial/mcfserial.h                         |   74 -
 drivers/serial/serial_core.c                       |    5 
 drivers/usb/serial/ftdi_sio.c                      |    6 
 drivers/usb/serial/oti6858.c                       |    4 
 drivers/usb/serial/pl2303.c                        |   11 
 include/linux/serial_core.h                        |    2 
 30 files changed, 430 insertions(+), 2559 deletions(-)
 delete mode 100644 drivers/char/ip2/ip2base.c
 delete mode 100644 drivers/serial/mcfserial.c
 delete mode 100644 drivers/serial/mcfserial.h

-- 
Signature
