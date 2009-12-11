Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbZLKX2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbZLKX2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbZLKX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:12 -0500
Received: from kroah.org ([198.145.64.141]:50400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761638AbZLKX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:12 -0500
Date: Fri, 11 Dec 2009 15:28:05 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big TTY patchset for your .33-git tree.

Lots of tiny things, and one driver that had been broken for a long time
is removed.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 Documentation/serial/hayes-esp.txt   |  154 --
 Documentation/serial/tty.txt         |    9 +-
 arch/xtensa/platforms/iss/console.c  |    2 +-
 drivers/char/Kconfig                 |   13 -
 drivers/char/Makefile                |    1 -
 drivers/char/bfin_jtag_comm.c        |    2 +-
 drivers/char/epca.c                  |    2 +-
 drivers/char/esp.c                   | 2533 ----------------------------------
 drivers/char/isicom.c                |  115 +--
 drivers/char/istallion.c             |  185 +--
 drivers/char/moxa.c                  |  289 ++---
 drivers/char/mxser.c                 |  248 ++--
 drivers/char/pcmcia/ipwireless/tty.c |    2 +-
 drivers/char/pty.c                   |    2 +-
 drivers/char/riscom8.c               |   89 +-
 drivers/char/stallion.c              |  129 +--
 drivers/char/tty_io.c                |  151 ++-
 drivers/char/tty_ldisc.c             |   23 +-
 drivers/char/tty_port.c              |   97 ++-
 drivers/mmc/card/sdio_uart.c         |  303 +++--
 drivers/serial/8250.c                |   24 +-
 drivers/serial/jsm/jsm.h             |    8 -
 drivers/serial/jsm/jsm_driver.c      |   48 +-
 drivers/serial/jsm/jsm_neo.c         |    8 -
 drivers/serial/jsm/jsm_tty.c         |    6 +-
 drivers/serial/pxa.c                 |   13 +-
 drivers/serial/serial_core.c         |   33 +-
 drivers/usb/serial/opticon.c         |    7 +-
 drivers/usb/serial/usb-serial.c      |   83 +-
 fs/devpts/inode.c                    |   16 +-
 include/linux/Kbuild                 |    1 -
 include/linux/hayesesp.h             |  114 --
 include/linux/isicom.h               |    1 +
 include/linux/tty.h                  |   25 +-
 include/linux/usb/serial.h           |    3 -
 kernel/exit.c                        |    2 +-
 36 files changed, 921 insertions(+), 3820 deletions(-)
 delete mode 100644 Documentation/serial/hayes-esp.txt
 delete mode 100644 drivers/char/esp.c
 delete mode 100644 include/linux/hayesesp.h

---------------

Alan Cox (41):
      tty: esp: remove broken driver
      tty: istallion: Kill off the BKL ioctl
      tty: stallion: kill BKL ioctl
      tty_port: add "tty_port_open" helper
      tty_port: coding style cleaning pass
      usb_serial: Use the shutdown() operation
      usb_serial: Kill port mutex
      opticon: Fix resume logic
      tty_port: Move hupcl handling
      sdio_uart: use tty_port
      sdio_uart: refcount the tty objects
      sdio_uart: Move the open lock
      tty: sdio_uart: Switch to the open/close helpers
      tty: sdio_uart: Fix termios handling
      tty: sdio_uart: Style fixes
      tty: sdio_uart: add modem functionality
      tty: sdio_uart: Fix the locking on "func" for new code
      tty: tty_port: Change the buffer allocator locking
      tty: riscom8: switch to the tty_port_open API
      tty: tty_port: Add IO_ERROR bit handling
      tty: tty_port: Move the IO_ERROR clear
      tty: stallion: Convert to the tty_port_open/close methods
      tty: istallion: tty port open/close methods
      tty: tty_port: Add a kref object to the tty port
      tty: isicom: switch to the new tty_port_open helper
      tty: isicom: sort out the board init logic
      tty: mxser: use the tty_port_open method
      tty: mxser: Use the new locking rules to fix setserial properly
      tty: isicom: fix deadlock on shutdown
      tty: moxa: Use more tty_port ops
      tty: moxa: rework the locking a bit
      tty: moxa: Locking clean up
      tty: moxa: Kill off the throttle method
      tty: moxa: Fix modem op locking
      tty: moxa: Kill the use of lock_kernel
      tty: moxa: split open lock
      tty: push the BKL down into the handlers a bit
      tty: Push the lock down further into the ldisc code
      tty: Push the bkl down a bit in the hangup code
      tty: Move the leader test in disassociate
      tty: split the lock up a bit further

Alexey Dobriyan (1):
      tty: const: constify remaining tty_operations

André Goddard Rosa (3):
      serial: fix NULL pointer dereference
      serial: cascade needless conditionals
      serial, 8250: calculate irqflags bitmask before loop

Breno Leitao (1):
      jsm: adding EEH handlers

Breno Leitão (7):
      jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
      jsm: Rewriting a bad log message
      jsm: remove the ch_custom_speed field
      jsm: removing ch_old_baud field
      jsm: Remove ch_cpstime field
      jsm: Removing unused jsm_channel->ch_wopen field
      jsm: removing the field jsm_board->intr_count

Ian Jackson (1):
      Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Nicolas Pitre (1):
      sdio_uart: Fix oops caused by the previous changeset

Sukadev Bhattiprolu (1):
      devpts_get_tty() should validate inode

Tilman Schmidt (1):
      tty: docs: serial/tty, add to ldisc methods

Uwe Kleine-König (1):
      Serial: pxa: work around Errata #75

