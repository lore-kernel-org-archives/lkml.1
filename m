Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYESPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYESPCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYESPCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:02:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39685 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750957AbYESPC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:02:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/20] Implment a tty port structure and supporting logic
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:50:07 +0100
Message-ID: <20080519144557.19326.74313.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now each tty has its own port level structure which means we can share
no code between ports. Introduce a structure and some initial minor helper
routines so that we can move towards commonality. In doing this the USB serial
code gets a bit of shake up as it kept using port->tty unsafely. Fixing that
means changing the API of all the USB serial drivers. On the bright side the
API now looks far more like the tty layer API which will become useful later
on.


---

Alan Cox (20):
      whiteheat: fix bugs found in the tidy and audit
      whiteheat: coding style
      tty: add more tty_port fields
      riscom8: remove bogus checks
      usb_serial: API all change
      serial: use tty_port
      gs: use tty_port
      cyclades: use tty_port
      stallion: use tty_port
      istallion: use tty_port
      esp: use tty_port
      synclink: use tty_port
      rocket: use tty_port
      riscom8: use tty_port
      mxser: use tty_port
      moxa: use tty_port
      isicom: use tty_port
      epca: use tty_port
      tty: Clean up tiocmset
      tty: Introduce a tty_port common structure


 MAINTAINERS                           |   72 +
 drivers/char/cyclades.c               |  341 +++---
 drivers/char/epca.c                   |  106 +-
 drivers/char/epca.h                   |    7 
 drivers/char/esp.c                    |  272 ++---
 drivers/char/generic_serial.c         |  158 +--
 drivers/char/isicom.c                 |  207 ++--
 drivers/char/istallion.c              |  116 +-
 drivers/char/moxa.c                   |   93 +-
 drivers/char/mxser.c                  |  284 ++---
 drivers/char/rio/rio_linux.c          |   20 
 drivers/char/rio/riocmd.c             |   10 
 drivers/char/rio/riointr.c            |   10 
 drivers/char/rio/rioparam.c           |    2 
 drivers/char/rio/riotty.c             |   16 
 drivers/char/riscom8.c                |  187 +--
 drivers/char/riscom8.h                |   10 
 drivers/char/rocket.c                 |  139 +-
 drivers/char/rocket.h                 |    4 
 drivers/char/rocket_int.h             |   11 
 drivers/char/specialix.c              |  153 +--
 drivers/char/specialix_io8.h          |    8 
 drivers/char/stallion.c               |  160 +--
 drivers/char/sx.c                     |  115 +-
 drivers/char/synclink.c               |  209 ++--
 drivers/char/synclink_gt.c            |  215 ++--
 drivers/char/synclinkmp.c             |  215 ++--
 drivers/char/tty_io.c                 |   87 +
 drivers/serial/8250.c                 |    2 
 drivers/serial/jsm/jsm_neo.c          |    2 
 drivers/serial/jsm/jsm_tty.c          |    8 
 drivers/serial/serial_core.c          |   80 +
 drivers/usb/serial/Kconfig            |    8 
 drivers/usb/serial/aircable.c         |   19 
 drivers/usb/serial/airprime.c         |   16 
 drivers/usb/serial/ark3116.c          |   32 -
 drivers/usb/serial/belkin_sa.c        |   69 -
 drivers/usb/serial/ch341.c            |   10 
 drivers/usb/serial/console.c          |   34 -
 drivers/usb/serial/cp2101.c           |   73 +
 drivers/usb/serial/cyberjack.c        |   47 -
 drivers/usb/serial/cypress_m8.c       |  117 +-
 drivers/usb/serial/digi_acceleport.c  |  127 +-
 drivers/usb/serial/empeg.c            |   78 +
 drivers/usb/serial/ezusb.c            |   22 
 drivers/usb/serial/ftdi_sio.c         |  213 ++--
 drivers/usb/serial/garmin_gps.c       |   58 -
 drivers/usb/serial/generic.c          |   39 -
 drivers/usb/serial/io_edgeport.c      |  175 +--
 drivers/usb/serial/io_fw_down3.h      |   11 
 drivers/usb/serial/io_ti.c            | 1924 +++++++++++++++------------------
 drivers/usb/serial/ipaq.c             |   48 -
 drivers/usb/serial/ipw.c              |   15 
 drivers/usb/serial/ir-usb.c           |   35 -
 drivers/usb/serial/iuu_phoenix.c      |   43 -
 drivers/usb/serial/keyspan.c          |  138 +-
 drivers/usb/serial/keyspan.h          |   39 -
 drivers/usb/serial/keyspan_pda.c      |   69 -
 drivers/usb/serial/kl5kusb105.c       |   74 +
 drivers/usb/serial/kobil_sct.c        |   80 +
 drivers/usb/serial/mct_u232.c         |  121 +-
 drivers/usb/serial/mos7720.c          |   87 +
 drivers/usb/serial/mos7840.c          |  165 +--
 drivers/usb/serial/navman.c           |   10 
 drivers/usb/serial/omninet.c          |   26 
 drivers/usb/serial/option.c           |  105 +-
 drivers/usb/serial/oti6858.c          |  119 +-
 drivers/usb/serial/pl2303.c           |   76 +
 drivers/usb/serial/safe_serial.c      |   14 
 drivers/usb/serial/sierra.c           |   93 --
 drivers/usb/serial/spcp8x5.c          |   69 +
 drivers/usb/serial/ti_fw_3410.h       |    4 
 drivers/usb/serial/ti_fw_5052.h       |    5 
 drivers/usb/serial/ti_usb_3410_5052.c |  214 ++--
 drivers/usb/serial/usb-serial.c       |   82 +
 drivers/usb/serial/visor.c            |   66 -
 drivers/usb/serial/whiteheat.c        |  446 ++++----
 drivers/usb/serial/whiteheat.h        |   78 +
 include/linux/cyclades.h              |   13 
 include/linux/generic_serial.h        |    8 
 include/linux/hayesesp.h              |    9 
 include/linux/istallion.h             |    6 
 include/linux/serial_core.h           |   26 
 include/linux/stallion.h              |    6 
 include/linux/tty.h                   |   31 +
 include/linux/usb/serial.h            |   56 +
 86 files changed, 4252 insertions(+), 4615 deletions(-)

-- 
/dev/pithy_wit: End of file

