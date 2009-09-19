Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZISVeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZISVeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZISVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:34:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZISVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:34:00 -0400
Date: Sat, 19 Sep 2009 14:33:45 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.31-git
Message-ID: <20090919213345.GB7668@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big tty tree merge for your 2.6.31-git tree.

It contains a lot of tty core changes, and a bunch of usb-serial
regression fixes, which depend on some tty changes, which is why they
are all in this tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

All of these patches have been in the -next and -mm trees for quite a
while.

The full patches will be sent to the linux-kernel mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 arch/mn10300/kernel/asm-offsets.c       |    6 +-
 drivers/char/cyclades.c                 | 2311 ++++++++-----------------------
 drivers/char/esp.c                      |    7 +-
 drivers/char/isicom.c                   |   57 +-
 drivers/char/mxser.c                    |   62 +-
 drivers/char/n_tty.c                    |   79 +-
 drivers/char/riscom8.c                  |  164 ++--
 drivers/char/tty_io.c                   |   22 +-
 drivers/char/tty_ioctl.c                |    4 +-
 drivers/char/tty_ldisc.c                |   82 +-
 drivers/char/tty_port.c                 |   31 +-
 drivers/char/vt.c                       |   14 +-
 drivers/char/vt_ioctl.c                 |  482 ++++++-
 drivers/isdn/gigaset/interface.c        |   19 +-
 drivers/net/slip.c                      |   96 +-
 drivers/serial/21285.c                  |    8 +-
 drivers/serial/8250.c                   |   28 +-
 drivers/serial/8250.h                   |    1 +
 drivers/serial/amba-pl010.c             |    6 +-
 drivers/serial/amba-pl011.c             |    6 +-
 drivers/serial/atmel_serial.c           |   14 +-
 drivers/serial/bfin_5xx.c               |   24 +-
 drivers/serial/bfin_sport_uart.c        |    6 +-
 drivers/serial/clps711x.c               |    4 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/serial/dz.c                     |    6 +-
 drivers/serial/icom.c                   |   20 +-
 drivers/serial/imx.c                    |   16 +-
 drivers/serial/ioc3_serial.c            |   54 +-
 drivers/serial/ioc4_serial.c            |   68 +-
 drivers/serial/ip22zilog.c              |   14 +-
 drivers/serial/jsm/jsm_neo.c            |    2 +-
 drivers/serial/jsm/jsm_tty.c            |   20 +-
 drivers/serial/m32r_sio.c               |    6 +-
 drivers/serial/max3100.c                |   16 +-
 drivers/serial/mcf.c                    |    4 +-
 drivers/serial/mpc52xx_uart.c           |    4 +-
 drivers/serial/mpsc.c                   |    4 +-
 drivers/serial/msm_serial.c             |    6 +-
 drivers/serial/mux.c                    |    4 +-
 drivers/serial/netx-serial.c            |    6 +-
 drivers/serial/nwpserial.c              |    4 +-
 drivers/serial/pmac_zilog.c             |   20 +-
 drivers/serial/pnx8xxx_uart.c           |    8 +-
 drivers/serial/pxa.c                    |    6 +-
 drivers/serial/sa1100.c                 |    8 +-
 drivers/serial/samsung.c                |    8 +-
 drivers/serial/sb1250-duart.c           |    6 +-
 drivers/serial/sc26xx.c                 |   10 +-
 drivers/serial/serial_core.c            |  876 ++++++------
 drivers/serial/serial_cs.c              |    1 +
 drivers/serial/serial_ks8695.c          |    6 +-
 drivers/serial/serial_lh7a40x.c         |    6 +-
 drivers/serial/serial_txx9.c            |    4 +-
 drivers/serial/sh-sci.c                 |   10 +-
 drivers/serial/sn_console.c             |   22 +-
 drivers/serial/sunhv.c                  |    8 +-
 drivers/serial/sunsab.c                 |   10 +-
 drivers/serial/sunsu.c                  |    6 +-
 drivers/serial/sunzilog.c               |   14 +-
 drivers/serial/timbuart.c               |   10 +-
 drivers/serial/uartlite.c               |   19 +-
 drivers/serial/ucc_uart.c               |    4 +-
 drivers/serial/vr41xx_siu.c             |    6 +-
 drivers/serial/zs.c                     |    6 +-
 drivers/usb/class/cdc-acm.c             |    5 +-
 drivers/usb/serial/ark3116.c            |   51 +-
 drivers/usb/serial/belkin_sa.c          |    4 +-
 drivers/usb/serial/ch341.c              |    5 +-
 drivers/usb/serial/console.c            |   32 +-
 drivers/usb/serial/cp210x.c             |   12 +-
 drivers/usb/serial/cyberjack.c          |    4 +-
 drivers/usb/serial/cypress_m8.c         |   18 +-
 drivers/usb/serial/digi_acceleport.c    |    6 +-
 drivers/usb/serial/empeg.c              |   18 +-
 drivers/usb/serial/ftdi_sio.c           |    6 +-
 drivers/usb/serial/garmin_gps.c         |    3 +-
 drivers/usb/serial/generic.c            |    3 +-
 drivers/usb/serial/io_edgeport.c        |    6 +-
 drivers/usb/serial/io_ti.c              |    3 +-
 drivers/usb/serial/ipaq.c               |    9 +-
 drivers/usb/serial/ipw.c                |    3 +-
 drivers/usb/serial/ir-usb.c             |    6 +-
 drivers/usb/serial/iuu_phoenix.c        |   34 +-
 drivers/usb/serial/keyspan.c            |    3 +-
 drivers/usb/serial/keyspan.h            |    3 +-
 drivers/usb/serial/keyspan_pda.c        |    2 +-
 drivers/usb/serial/kl5kusb105.c         |   10 +-
 drivers/usb/serial/kobil_sct.c          |   28 +-
 drivers/usb/serial/mct_u232.c           |   15 +-
 drivers/usb/serial/mos7720.c            |  123 ++-
 drivers/usb/serial/mos7840.c            |  118 +--
 drivers/usb/serial/navman.c             |    3 +-
 drivers/usb/serial/omninet.c            |    6 +-
 drivers/usb/serial/opticon.c            |    3 +-
 drivers/usb/serial/option.c             |    6 +-
 drivers/usb/serial/oti6858.c            |   27 +-
 drivers/usb/serial/pl2303.c             |    5 +-
 drivers/usb/serial/sierra.c             |    3 +-
 drivers/usb/serial/spcp8x5.c            |   26 +-
 drivers/usb/serial/symbolserial.c       |    3 +-
 drivers/usb/serial/ti_usb_3410_5052.c   |    6 +-
 drivers/usb/serial/usb-serial.c         |  385 +++---
 drivers/usb/serial/usb_debug.c          |    5 +-
 drivers/usb/serial/visor.c              |    6 +-
 drivers/usb/serial/whiteheat.c          |   11 +-
 include/linux/cyclades.h                |   11 +-
 include/linux/hayesesp.h                |    1 -
 include/linux/kfifo.h                   |    4 +-
 include/linux/serial.h                  |    2 +
 include/linux/serial_8250.h             |    1 +
 include/linux/serial_core.h             |   93 +-
 include/linux/tty.h                     |   19 +-
 include/linux/usb/serial.h              |   10 +-
 include/linux/vt.h                      |   32 +-
 include/linux/vt_kern.h                 |   16 +-
 kernel/kfifo.c                          |    2 +-
 kernel/power/console.c                  |   63 +-
 118 files changed, 2572 insertions(+), 3570 deletions(-)

---------------

Alan Cox (33):
      slip: Clean up create and destroy
      kfifo: Use "const" definitions
      tty: Fix a typo noted in passing
      mos7840: remove old dead modem logic
      tty: Add a full port_close function
      riscom8: split open and close methods up
      mxser: Split close ready for a standard tty_port_close method
      isicom: Split the close hardware bits out
      tty: riscom8 kref and tty_port_close
      cyclades: use the full port_close function
      tty: make the kref destructor occur asynchronously
      cdc_acm: Fix to use modern speed interfaces
      tty: USB hangup is racy
      tty: remove dtr/rts use from the driver open methods
      tty: USB can now use the shutdown method for kref based freeing of ports
      vt: add an event interface
      vt: remove power stuff from kernel/power
      vt: move kernel stuff out of vt.h
      vt: add an activate and lock
      tty: USB does not need the filp argument in the drivers
      isicom: split the open method for the isicom device
      serial: kill off uart_info
      serial: Fold closing_* fields into the tty_port ones
      serial: use tty_port pointers in the core code
      serial: move count into the tty_port version
      serial: move the flags into the tty_port field
      serial: kill off uif_t
      serial: replace the state mutex with the tty port mutex
      serial: move delta_msr_wait into the tty_port
      serial: move port users helper
      serial: kill USF_CLOSING_* definitions
      serial: introduce tty krefs
      tty: USB serial termios bits

Alan Stern (10):
      TTY: fix typos
      usb-serial: change referencing of port and serial structures
      usb-serial: put subroutines in logical order
      usb-serial: change logic of serial lookups
      usb-serial: acquire references when a new tty is installed
      usb-serial: fix termios initialization logic
      usb-serial: rename subroutines
      usb-serial: add missing tests and debug lines
      usb-serial: straighten out serial_open
      USB serial: update the console driver

Anton Vorontsov (1):
      8250: Now honours baud rate lower bounds

Arnd Bergmann (1):
      tty: handle VT specific compat ioctls in vt driver

Deepak Saxena (1):
      Set proper console speed on resume if console suspend is disabled

Jaswinder Singh Rajput (1):
      tty: includecheck fix: drivers/char, vt.c

Jiri Slaby (19):
      cyclades: add tty refcounting
      cyclades: remove block_til_ready
      cyclades: avoid addresses recomputation
      cyclades: switch to tty_port_hangup
      cyclades: close cleanup
      cyclades: overall cleanup
      cyclades: sleep instead busy-wait
      cyclades: use dtr_rts helpers
      cyclades: merge cy_startup tails
      cyclades: ioctls cleanup
      cyclades: tiocm cleanup
      cyclades: introduce cyy_readb/writeb
      cyclades: remove more duplicated code
      tty: Power: fix suspend vt regression
      tty: riscom8, fix shutdown declaration
      tty: riscom8, fix tty refcnt
      tty: USB: serial/mct_u232, fix tty refcnt
      tty: Char: mxser, add support for CP112UL
      tty: Char: mxser, use THRE for ASPP_OQUEUE ioctl

Joe Peterson (2):
      n_tty: honor opost flag for echoes
      n_tty: move echoctl check and clean up logic

Kees Schoenmakers (2):
      MOS7720 has no tiocmget method
      tty: usb_serial_mos7720: Fix get_lsr_info

Linus Torvalds (2):
      tty-ldisc: make /proc/tty/ldiscs use ldisc_ops instead of ldiscs
      tty-ldisc: get rid of tty_ldisc_try_get() helper function

Marcin Slusarz (1):
      tty: vt: use printk_once

Mike Frysinger (1):
      serial: bfin_5xx: fix building as module when early printk is enabled

Peter Korsgaard (1):
      uartlite: support shared interrupt lines

Roel Kluin (1):
      tty: icom: bit and/or confusion?

Tilman Schmidt (1):
      tty: gigaset: really fix chars_in_buffer

Vikram Pandita (1):
      serial: 8250: add IRQ trigger support

Wolfram Sang (1):
      tty: serial/pcmcia: add ID for Advantech card

