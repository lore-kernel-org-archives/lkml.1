Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYFTUPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYFTUPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYFTUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:15:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51945 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222AbYFTUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:15:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/70] tty updates proposed for 2.6.27
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 20:57:55 +0100
Message-ID: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces the idea of a tty_port - a common structure
that eventually all ports will have. Some drivers are migrated to make partial
use of the tty port commonality and helpers but only a little.

On the USB side the USB tty API is changed to fix a whole pile of races where
tty->port->tty cannot be assumed to be tty (because of hangup/reopen). The
USB drivers all get a spring clean and the entire pile have been dragged into
CodingStyle near compliance (some cases where the checkpatch whines that
make no sense have been ignored).

Greg: At the end of this series there shouldn't be any white space issues
although some earlier patches introduce them and later ones take them away

Aim... load... fire...
---

Alan Cox (70):
      tty-usb-mos7720: Coding style
      whiteheat: remove unused variable
      mos7840: remove loads of bogus assignments to status
      omninet: Use string flip functions
      tty-usb-omninet: Coding style
      tty-usb-option: Coding style
      tty-usb-oti6858: Coding style
      tty-usb-safe-serial: Coding style
      tty-usb-ti-usb: Coding style
      tty-usb-spcp8x5: Minor coding style
      tty-usb-sierra: Coding style - minor
      tty-usb-pl2303: Coding style
      mct_u232: Use flip buffer functions
      tty-usb-mct-u232: Coding style
      kobil_sct: Fix ioctls
      tty-usb-kobil-sct: Coding style
      keyspan_pda: Use string flip functions
      tty-usb-kl5kusb105: Coding style
      tty-usb-keyspan-pda: Coding style
      keyspan: Use string flip functions when possible
      tty-usb-keyspan: Coding style
      tty-usb-iuu-phoenix: Clean up to coding style
      tty-usb-ir-usb: Clean up to coding style
      tty-usb-ipw: Coding style
      ipaq: Coding style
      io_ti: Minor coding style
      usb-serial: Coding style
      io_edgeport: Fix various bogus returns to the tty layer
      tty-usb-io_edgeport: Coding style
      tty-usb-visor: Coding style
      tty-usb-hp4x: Fix overlong line
      tty-usb-generic: Code cleanup
      garmin_gps: Coding style
      funsoft: Switch to linux/uaccess
      ftdi_sio: Coding style
      empeg: Coding style
      digi_acceleport: coding style
      usb-cypress: There is no 0 case to go with CS5/6/7/8 so remove the test
      cypress_m8: coding style
      cyberjack: Coding style
      cp2101: coding style
      tty-usb-console: Fix termios
      tty-usb-console: tidy the USB console code
      usb-serial-bus: tidy coding style
      belkin_sa: clean up code
      whiteheat: fix bugs found in the tidy and audit
      whiteheat: coding style
      usb_serial: API all change
      tty: add more tty_port fields
      termios: Termios defines for other platforms
      cyclades: use tty_port
      tty: Clean up tiocmset
      synclink: use tty_port
      stallion: use tty_port
      serial: use tty_port
      rocket: use tty_port
      mxser: use tty_port
      moxa: use tty_port
      istallion: use tty_port
      isicom: use tty_port
      riscom8: remove bogus checks
      riscom8: use tty_port
      gs: use tty_port
      esp: use tty_port
      epca: use tty_port
      tty.h: clean up
      tty: Introduce a tty_port common structure
      drivers/serial/: remove CVS keywords
      drivers/char/rio/: remove VCS tags
      tty: Ldisc revamp


 drivers/bluetooth/hci_ldisc.c           |    6 
 drivers/char/cyclades.c                 |  342 +++--
 drivers/char/epca.c                     |  110 +-
 drivers/char/epca.h                     |    7 
 drivers/char/esp.c                      |  272 ++--
 drivers/char/generic_serial.c           |  158 +-
 drivers/char/ip2/i2lib.c                |    4 
 drivers/char/ip2/ip2main.c              |    7 
 drivers/char/isicom.c                   |  207 +--
 drivers/char/istallion.c                |  116 +-
 drivers/char/moxa.c                     |   93 +
 drivers/char/mxser.c                    |  284 ++--
 drivers/char/n_hdlc.c                   |    6 
 drivers/char/n_r3964.c                  |    2 
 drivers/char/n_tty.c                    |    2 
 drivers/char/pcmcia/synclink_cs.c       |    4 
 drivers/char/pty.c                      |   10 
 drivers/char/rio/cirrus.h               |    3 
 drivers/char/rio/cmdblk.h               |    6 
 drivers/char/rio/cmdpkt.h               |    6 
 drivers/char/rio/daemon.h               |    6 
 drivers/char/rio/errors.h               |    6 
 drivers/char/rio/func.h                 |    6 
 drivers/char/rio/map.h                  |    4 
 drivers/char/rio/param.h                |    5 
 drivers/char/rio/parmmap.h              |    7 
 drivers/char/rio/pci.h                  |    4 
 drivers/char/rio/protsts.h              |    7 
 drivers/char/rio/rio_linux.c            |   25 
 drivers/char/rio/rioboard.h             |    6 
 drivers/char/rio/riocmd.c               |   13 
 drivers/char/rio/rioctrl.c              |    4 
 drivers/char/rio/riodrvr.h              |    4 
 drivers/char/rio/rioinfo.h              |    4 
 drivers/char/rio/rioinit.c              |    3 
 drivers/char/rio/riointr.c              |   14 
 drivers/char/rio/rioparam.c             |    6 
 drivers/char/rio/rioroute.c             |    3 
 drivers/char/rio/riospace.h             |    4 
 drivers/char/rio/riotable.c             |    3 
 drivers/char/rio/riotty.c               |   20 
 drivers/char/rio/route.h                |    6 
 drivers/char/rio/unixrup.h              |    4 
 drivers/char/riscom8.c                  |  187 +--
 drivers/char/riscom8.h                  |   10 
 drivers/char/rocket.c                   |  139 +-
 drivers/char/rocket.h                   |    4 
 drivers/char/rocket_int.h               |   11 
 drivers/char/selection.c                |    3 
 drivers/char/specialix.c                |  153 +-
 drivers/char/specialix_io8.h            |    8 
 drivers/char/stallion.c                 |  160 +-
 drivers/char/sx.c                       |  115 +-
 drivers/char/synclink.c                 |  213 ++-
 drivers/char/synclink_gt.c              |  219 ++-
 drivers/char/synclinkmp.c               |  219 ++-
 drivers/char/tty_io.c                   |  420 ++++--
 drivers/char/tty_ioctl.c                |   16 
 drivers/input/serio/serport.c           |    2 
 drivers/isdn/capi/capi.c                |    4 
 drivers/isdn/gigaset/ser-gigaset.c      |    2 
 drivers/net/hamradio/6pack.c            |    2 
 drivers/net/hamradio/mkiss.c            |    2 
 drivers/net/irda/irtty-sir.c            |    2 
 drivers/net/ppp_async.c                 |    2 
 drivers/net/ppp_synctty.c               |    2 
 drivers/net/slip.c                      |    2 
 drivers/net/wan/pc300_tty.c             |    4 
 drivers/net/wan/x25_asy.c               |    2 
 drivers/net/wireless/strip.c            |    2 
 drivers/serial/21285.c                  |    6 
 drivers/serial/8250.c                   |    8 
 drivers/serial/8250.h                   |    2 
 drivers/serial/8250_pci.c               |    2 
 drivers/serial/8250_pnp.c               |    2 
 drivers/serial/Kconfig                  |    2 
 drivers/serial/Makefile                 |    2 
 drivers/serial/amba-pl010.c             |    6 
 drivers/serial/amba-pl011.c             |    2 
 drivers/serial/clps711x.c               |    7 
 drivers/serial/cpm_uart/cpm_uart_core.c |    4 
 drivers/serial/jsm/jsm_neo.c            |    2 
 drivers/serial/jsm/jsm_tty.c            |    8 
 drivers/serial/m32r_sio.c               |    4 
 drivers/serial/mpsc.c                   |    4 
 drivers/serial/pnx8xxx_uart.c           |    2 
 drivers/serial/sa1100.c                 |    7 
 drivers/serial/serial_core.c            |   80 +
 drivers/serial/sunsu.c                  |    2 
 drivers/usb/serial/Kconfig              |    8 
 drivers/usb/serial/aircable.c           |   19 
 drivers/usb/serial/airprime.c           |   16 
 drivers/usb/serial/ark3116.c            |   32 
 drivers/usb/serial/belkin_sa.c          |  201 ++-
 drivers/usb/serial/belkin_sa.h          |   15 
 drivers/usb/serial/bus.c                |   20 
 drivers/usb/serial/ch341.c              |   10 
 drivers/usb/serial/console.c            |  136 +-
 drivers/usb/serial/cp2101.c             |  381 +++---
 drivers/usb/serial/cyberjack.c          |  176 +--
 drivers/usb/serial/cypress_m8.c         |  703 +++++-----
 drivers/usb/serial/cypress_m8.h         |    2 
 drivers/usb/serial/digi_acceleport.c    |  804 ++++++------
 drivers/usb/serial/empeg.c              |  257 ++--
 drivers/usb/serial/ezusb.c              |   22 
 drivers/usb/serial/ftdi_sio.c           | 1249 ++++++++++--------
 drivers/usb/serial/ftdi_sio.h           |  126 +-
 drivers/usb/serial/funsoft.c            |    2 
 drivers/usb/serial/garmin_gps.c         |  400 +++---
 drivers/usb/serial/generic.c            |  122 +-
 drivers/usb/serial/hp4x.c               |    3 
 drivers/usb/serial/io_edgeport.c        | 2106 +++++++++++++++++--------------
 drivers/usb/serial/io_fw_down3.h        |   11 
 drivers/usb/serial/io_tables.h          |    6 
 drivers/usb/serial/io_ti.c              | 1924 +++++++++++++---------------
 drivers/usb/serial/ipaq.c               |  143 +-
 drivers/usb/serial/ipw.c                |  294 ++--
 drivers/usb/serial/ir-usb.c             |  398 +++---
 drivers/usb/serial/iuu_phoenix.c        |   58 -
 drivers/usb/serial/keyspan.c            |  969 +++++++-------
 drivers/usb/serial/keyspan.h            |   39 -
 drivers/usb/serial/keyspan_pda.c        |  238 ++--
 drivers/usb/serial/kl5kusb105.c         |  415 +++---
 drivers/usb/serial/kobil_sct.c          |  617 +++++----
 drivers/usb/serial/mct_u232.c           |  364 +++--
 drivers/usb/serial/mos7720.c            |  308 ++---
 drivers/usb/serial/mos7840.c            |  557 +++-----
 drivers/usb/serial/navman.c             |   10 
 drivers/usb/serial/omninet.c            |  171 +--
 drivers/usb/serial/option.c             |  166 +-
 drivers/usb/serial/oti6858.c            |  255 ++--
 drivers/usb/serial/pl2303.c             |  140 +-
 drivers/usb/serial/safe_serial.c        |  298 ++--
 drivers/usb/serial/sierra.c             |   95 -
 drivers/usb/serial/spcp8x5.c            |   73 +
 drivers/usb/serial/ti_fw_3410.h         |    4 
 drivers/usb/serial/ti_fw_5052.h         |    5 
 drivers/usb/serial/ti_usb_3410_5052.c   |  460 ++++---
 drivers/usb/serial/usb-serial.c         |  393 +++---
 drivers/usb/serial/visor.c              |  384 +++---
 drivers/usb/serial/whiteheat.c          |  484 ++++---
 drivers/usb/serial/whiteheat.h          |   78 +
 fs/proc/proc_tty.c                      |   48 -
 include/asm-avr32/ioctls.h              |    4 
 include/asm-frv/ioctls.h                |    4 
 include/asm-frv/termbits.h              |    5 
 include/linux/cyclades.h                |   13 
 include/linux/generic_serial.h          |    8 
 include/linux/hayesesp.h                |    9 
 include/linux/istallion.h               |    6 
 include/linux/serial_core.h             |   26 
 include/linux/stallion.h                |    6 
 include/linux/tty.h                     |  204 ++-
 include/linux/tty_ldisc.h               |    7 
 include/linux/usb/serial.h              |   56 -
 net/bluetooth/rfcomm/tty.c              |   13 
 net/irda/ircomm/ircomm_tty.c            |   14 
 157 files changed, 10296 insertions(+), 10160 deletions(-)

-- 
   "When you turn it on, listen and smell for anything odd and if it smells
    or crackles, shut it off and let me know - that's the one I had to 
    realign  with a hammer because it was slighly damaged in shipping"
                        -- Michael K Johnson

