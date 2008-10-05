Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYJEQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYJEQEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYJEQEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:04:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54832 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbYJEQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:04:30 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 00/76] Queued TTY Patches
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:04:29 +0100
Message-ID: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch stack waiting for 2.6.28 to open. The patches start with
various queued bug fixes then move on to tackle the first stage of making the
tty layer sane. These patches have been in linux-next.

The main thrust is to begin using krefs and refcounts to kill races and make
the locking saner. At this point we still have BKL users but will hopefully
change bit by bit.

Alan


---

Adrian Bunk (1):
      coldfire: scheduled SERIAL_COLDFIRE removal

Akinobu Mita (1):
      ip2: avoid add_timer with pending timer

Alan Cox (43):
      ftdi: A few errors are err() that should be debug which causes much spewage
      applicom: Fix an unchecked user ioctl range and an error return
      hso: net driver using tty without locking
      tty: Minor tidyups and document fixes for n_tty
      tty: Remove lots of NULL checks
      tty: fix up gigaset a bit
      tty: some ICANON magic is in the wrong places
      tty: simplify ktermios allocation
      pty: simplify unix98 allocation
      pty: Fix allocation failure double free
      pty: Coding style and polish
      tty: extract the pty init time special cases
      tty: Finish fixing up the init_dev interface to use ERR_PTR
      tty: More driver operations
      tty: kref the tty driver object
      tty: Clean up the tty_init_dev changes further
      tty: Remove more special casing and out of place code
      tty: shutdown method
      vt: remove bogus lock dropping
      pty: If the administrator creates a device for a ptmx slave we should not error
      tty: Fix abusers of current->sighand->tty
      tty: Redo current tty locking
      tty: the vhangup syscall is racy
      mxser: Switch to kref tty
      stallion: Use krefs
      tty: kref usage for isicom and moxa
      tty: usb-serial krefs
      tty: Move tty_write_message out of kernel/printk
      tty: Make get_current_tty use a kref
      tty: compare the tty winsize
      tty: Termios locking - sort out real_tty confusions and lock reads
      tty: Add termiox
      tty: ipw need reworking
      tty: Cris has a nice RS485 ioctl so we should steal it
      tty: use krefs to protect driver module counts
      tty: Add a kref count
      pps: Reserve a line discipline number for PPS
      tty: Split tty_port into its own file
      tty: split the buffering from tty_io
      uml: small cleanups and note bugs to be dealt with by uml authors...
      tty: move tioclinux from a special case
      8250: Remove NR_IRQ usage
      epca: call tty_port_init

Andrew Morton (1):
      serial-make-uart_ports-ioport-unsigned-long-fix

David Miller (2):
      serial: allow 8250 to be used on sparc
      serial: Make uart_port's ioport "unsigned long".

David S. Miller (1):
      serial: fix device name reporting when minor space is shared between drivers

Graf Yang (1):
      Blackfin Serial Driver: Fix bug - ircp fails on sir over Blackfin UART

Jason Wessel (2):
      usb: fix pl2303 initialization
      tty: tty_io.c shadows sparse fix

Jiri Slaby (6):
      Char: sx, fix io unmapping
      Char: cyclades. remove bogus iomap
      ip2, init/deinit cleanup
      ip2, fix sparse warnings
      ip2, cleanup globals
      Char: merge ip2main and ip2base

Julia Lawall (2):
      drivers/char/hvc_console.c: adjust call to put_tty_driver
      drivers/serial/crisv10.c: add missing put_tty_driver

Mike Frysinger (3):
      Blackfin Serial Driver: move common variables out of serial headers and into the serial driver
      Blackfin Serial Driver: trim trailing whitespace -- no functional changes
      Blackfin Serial Driver: use __initdata for data, not __init

Miloslav Trmac (1):
      audit: Handle embedded NUL in TTY input auditing

Sonic Zhang (4):
      Blackfin Serial Driver: Fix bug - request UART2/3 peripheral mapped interrupts in PIO mode
      Blackfin Serial Driver: Fix bug - Don't call tx_stop in tx_transfer.
      Blackfin Serial Driver: Remove useless stop
      Blackfin Serial Driver: Fix bug - should suspend/resume/remove all uart ports.

Stephen Rothwell (1):
      tty: Fallout from tty-move-canon-specials

Sukadev Bhattiprolu (6):
      Simplify devpts_pty_kill
      Simplify devpts_pty_new()
      Simplify devpts_get_tty()
      Add an instance parameter devpts interfaces
      Move tty lookup/reopen to caller
      tty: Move parts of tty_init_dev into new functions

\\\"Will Newton\\\ (1):
      8250: remove a few inlines of dubious value


 Documentation/feature-removal-schedule.txt         |    8 
 arch/blackfin/kernel/bfin_dma_5xx.c                |   13 
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    4 
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |    6 
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    4 
 arch/sparc/include/asm/serial.h                    |    6 
 arch/um/drivers/line.c                             |    2 
 drivers/bluetooth/hci_ldisc.c                      |    2 
 drivers/char/Kconfig                               |    4 
 drivers/char/Makefile                              |    2 
 drivers/char/amiserial.c                           |    6 
 drivers/char/applicom.c                            |    6 
 drivers/char/cyclades.c                            |   21 
 drivers/char/epca.c                                |    5 
 drivers/char/generic_serial.c                      |   21 
 drivers/char/hvc_console.c                         |    4 
 drivers/char/ip2/Makefile                          |    2 
 drivers/char/ip2/i2ellis.c                         |   32 
 drivers/char/ip2/i2ellis.h                         |    2 
 drivers/char/ip2/ip2base.c                         |  108 -
 drivers/char/ip2/ip2main.c                         |  550 +++---
 drivers/char/isicom.c                              |   61 -
 drivers/char/istallion.c                           |  113 +
 drivers/char/moxa.c                                |   61 -
 drivers/char/mxser.c                               |  193 +-
 drivers/char/n_hdlc.c                              |    2 
 drivers/char/n_r3964.c                             |    9 
 drivers/char/n_tty.c                               |   99 +
 drivers/char/pcmcia/ipwireless/tty.c               |   19 
 drivers/char/pty.c                                 |  335 +++
 drivers/char/stallion.c                            |  139 +
 drivers/char/sx.c                                  |    4 
 drivers/char/tty_audit.c                           |    2 
 drivers/char/tty_buffer.c                          |  511 +++++
 drivers/char/tty_io.c                              | 1380 ++++----------
 drivers/char/tty_ioctl.c                           |  212 ++
 drivers/char/tty_port.c                            |   96 +
 drivers/char/vt.c                                  |   84 -
 drivers/char/vt_ioctl.c                            |    2 
 drivers/isdn/capi/capi.c                           |    2 
 drivers/isdn/gigaset/ser-gigaset.c                 |   27 
 drivers/net/usb/hso.c                              |   46 
 drivers/net/wan/Kconfig                            |    2 
 drivers/s390/char/fs3270.c                         |    3 
 drivers/serial/68328serial.c                       |   11 
 drivers/serial/8250.c                              |  123 +
 drivers/serial/Kconfig                             |   17 
 drivers/serial/Makefile                            |   16 
 drivers/serial/bfin_5xx.c                          |  123 +
 drivers/serial/crisv10.c                           |    5 
 drivers/serial/mcfserial.c                         | 1965 --------------------
 drivers/serial/mcfserial.h                         |   74 -
 drivers/serial/serial_core.c                       |   12 
 drivers/usb/serial/aircable.c                      |   15 
 drivers/usb/serial/belkin_sa.c                     |    3 
 drivers/usb/serial/console.c                       |    8 
 drivers/usb/serial/cyberjack.c                     |    3 
 drivers/usb/serial/cypress_m8.c                    |    5 
 drivers/usb/serial/digi_acceleport.c               |   19 
 drivers/usb/serial/empeg.c                         |    8 
 drivers/usb/serial/ftdi_sio.c                      |   25 
 drivers/usb/serial/garmin_gps.c                    |    3 
 drivers/usb/serial/generic.c                       |    3 
 drivers/usb/serial/io_edgeport.c                   |   43 
 drivers/usb/serial/io_ti.c                         |   26 
 drivers/usb/serial/ipaq.c                          |    3 
 drivers/usb/serial/ipw.c                           |    3 
 drivers/usb/serial/ir-usb.c                        |    3 
 drivers/usb/serial/iuu_phoenix.c                   |    3 
 drivers/usb/serial/keyspan.c                       |   77 -
 drivers/usb/serial/keyspan_pda.c                   |   16 
 drivers/usb/serial/kl5kusb105.c                    |    3 
 drivers/usb/serial/kobil_sct.c                     |    3 
 drivers/usb/serial/mct_u232.c                      |    6 
 drivers/usb/serial/mos7720.c                       |   36 
 drivers/usb/serial/mos7840.c                       |    7 
 drivers/usb/serial/navman.c                        |    3 
 drivers/usb/serial/omninet.c                       |   10 
 drivers/usb/serial/option.c                        |   18 
 drivers/usb/serial/oti6858.c                       |    3 
 drivers/usb/serial/pl2303.c                        |   15 
 drivers/usb/serial/safe_serial.c                   |   11 
 drivers/usb/serial/sierra.c                        |   16 
 drivers/usb/serial/spcp8x5.c                       |    3 
 drivers/usb/serial/ti_usb_3410_5052.c              |   44 
 drivers/usb/serial/usb-serial.c                    |   24 
 drivers/usb/serial/visor.c                         |   18 
 drivers/usb/serial/whiteheat.c                     |    8 
 fs/devpts/inode.c                                  |   66 -
 fs/dquot.c                                         |    6 
 fs/open.c                                          |    3 
 include/asm-x86/ioctls.h                           |    6 
 include/linux/devpts_fs.h                          |   31 
 include/linux/serial.h                             |   16 
 include/linux/serial_core.h                        |    2 
 include/linux/termios.h                            |   15 
 include/linux/tty.h                                |   45 
 include/linux/tty_driver.h                         |   56 +
 include/linux/vt_kern.h                            |    2 
 kernel/acct.c                                      |    2 
 kernel/auditsc.c                                   |    9 
 kernel/fork.c                                      |    5 
 kernel/printk.c                                    |   16 
 kernel/sys.c                                       |    4 
 security/selinux/hooks.c                           |    3 
 107 files changed, 2948 insertions(+), 4401 deletions(-)
 create mode 100644 arch/sparc/include/asm/serial.h
 delete mode 100644 drivers/char/ip2/ip2base.c
 create mode 100644 drivers/char/tty_buffer.c
 create mode 100644 drivers/char/tty_port.c
 delete mode 100644 drivers/serial/mcfserial.c
 delete mode 100644 drivers/serial/mcfserial.h

-- 
Signature
