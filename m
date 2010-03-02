Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0CBXKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:10:21 -0500
Received: from kroah.org ([198.145.64.141]:34476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0CBXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:10:15 -0500
Date: Tue, 2 Mar 2010 15:09:56 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20100302230956.GC32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big tty patchset for the .34 merge window.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next and -mm releases for a number of
weeks now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/cyclades.c          |   16 +-
 drivers/char/hvc_console.c       |    2 +-
 drivers/char/ip2/ip2main.c       |   26 ++-
 drivers/char/isicom.c            |   54 ++--
 drivers/char/moxa.c              |   20 +-
 drivers/char/mxser.c             |    3 +-
 drivers/char/nozomi.c            |  157 +++++----
 drivers/char/serial167.c         |    3 +-
 drivers/char/specialix.c         |    2 -
 drivers/char/synclink.c          |    4 +-
 drivers/char/synclink_gt.c       |  186 ++++++-----
 drivers/char/tty_buffer.c        |    6 +-
 drivers/char/tty_ldisc.c         |   50 ++--
 drivers/char/vt_ioctl.c          |   39 ++-
 drivers/mmc/card/sdio_uart.c     |   93 ++----
 drivers/parport/parport_pc.c     |    6 +
 drivers/serial/68328serial.c     |    8 +-
 drivers/serial/8250.c            |   21 +-
 drivers/serial/8250_pci.c        |   31 ++-
 drivers/serial/Kconfig           |   53 ++--
 drivers/serial/atmel_serial.c    |   22 ++
 drivers/serial/bcm63xx_uart.c    |    7 +-
 drivers/serial/bfin_5xx.c        |   22 +-
 drivers/serial/bfin_sport_uart.c |  701 +++++++++++++++++++++++++-------------
 drivers/serial/bfin_sport_uart.h |   38 +--
 drivers/serial/icom.c            |    5 +-
 drivers/serial/imx.c             |    6 +-
 drivers/serial/ioc3_serial.c     |    3 +-
 drivers/serial/jsm/jsm_driver.c  |    1 +
 drivers/serial/jsm/jsm_tty.c     |    9 +-
 drivers/serial/msm_serial.c      |    6 +-
 drivers/serial/timbuart.c        |    7 +-
 drivers/usb/serial/keyspan_pda.c |    7 +
 include/linux/pci_ids.h          |    3 +
 include/linux/tty.h              |   10 +
 include/linux/vt.h               |    3 +-
 36 files changed, 978 insertions(+), 652 deletions(-)

---------------

Alan Cox (8):
      sdio_uart: Use kfifo instead of the messy circ stuff
      nozomi: Add tty_port usage
      nozomi: Fix mutex handling
      nozomi: Tidy up the PCI table
      serial: timberdale: Remove dependancies
      tty: Fix the ldisc hangup race
      tty: Fix up char drivers request_room usage
      tty: Keep the default buffering to sub-page units

Albin Tonnerre (1):
      serial: atmel_serial: add poll_get_char and poll_put_char uart_ops

Ari Entlich (1):
      tty: Add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call

Bartlomiej Zolnierkiewicz (1):
      serial: cyclades: allow overriding ISA defaults also when the driver is built-in

Baruch Siach (1):
      serial: imx: fix NULL dereference Oops when pdata == NULL

Ben Hutchings (1):
      tty: declare MODULE_FIRMWARE in various drivers

Breno Leitao (2):
      jsm: removing the uart structure and filename on error
      jsm: fixing error if the driver fails to load

Graf Yang (1):
      serial: bfin_5xx: need to disable DMA TX interrupt too

Ira W. Snyder (1):
      serial: 8250_pci: add support for MCS9865 / SYBA 6x Serial Port Card

Jiri Slaby (3):
      serial: Char: cyclades, fix compiler warning
      tty: char: mxser, remove unnecessary tty test
      Char: synclink, remove unnecessary checks

Joe Perches (1):
      serial: isicom.c: use pr_fmt and pr_<level>

Kiros Yeh (1):
      serial: add support for Korenix JetCard

Maxime Bizon (2):
      serial: bcm63xx_uart: don't use kfree() on non kmalloced area.
      serial: bcm63xx_uart: allow more than one uart to be registered.

Mike Frysinger (1):
      serial: bfin_5xx: pull in linux/io.h for ioremap prototypes

Paul Fulghum (1):
      serial: synclink_gt: dropped transmit data bugfix

Rakib Mullick (3):
      tty: moxa: remove #ifdef MODULE completely.
      ip2: remove #ifdef MODULE from ip2main.c
      ip2: Add module parameter.

Roel Kluin (2):
      serial: fix test of unsigned
      hvc_console: fix test on unsigned in hvc_console_print()

Shmulik Ladkani (1):
      serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup

Sonic Zhang (2):
      serial: bfin_5xx: remove useless gpio handling with hard flow control
      serial: bfin_5xx: kgdboc should accept gdb break only when it is active

Thiago Farina (1):
      serial: 68328serial.c: remove BAUD_TABLE_SIZE macro

sonic zhang (1):
      serial: fit blackfin uart over sport driver into common uart infrastructure

