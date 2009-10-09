Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbZJIVGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbZJIVGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbZJIVGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:06:01 -0400
Received: from kroah.org ([198.145.64.141]:55129 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827AbZJIVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:05:59 -0400
Date: Fri, 9 Oct 2009 14:02:46 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.32-git
Message-ID: <20091009210246.GB4348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging fixes for your 2.6.32-git tree.

The big things here is the removal of two drivers:
	- agnx, this is broken and the wireless developers asked me to
	  remove it.
	- cowloop.  Turns out to not work well with the recent block
	  layer changes, so the author asked me to remove it for now so
	  that people will not have problems.  It will be returning in a
	  later merge.

There's a number of other fixes in here:
	- build fixes
	- comedi logic fixes
	- other minor fixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                          |    4 -
 drivers/staging/Makefile                         |    2 -
 drivers/staging/agnx/Kconfig                     |    5 -
 drivers/staging/agnx/Makefile                    |    8 -
 drivers/staging/agnx/TODO                        |   22 -
 drivers/staging/agnx/agnx.h                      |  156 --
 drivers/staging/agnx/debug.h                     |  416 ----
 drivers/staging/agnx/pci.c                       |  635 -----
 drivers/staging/agnx/phy.c                       |  960 --------
 drivers/staging/agnx/phy.h                       |  409 ----
 drivers/staging/agnx/rf.c                        |  893 -------
 drivers/staging/agnx/sta.c                       |  218 --
 drivers/staging/agnx/sta.h                       |  222 --
 drivers/staging/agnx/table.c                     |  168 --
 drivers/staging/agnx/table.h                     |   10 -
 drivers/staging/agnx/xmit.c                      |  836 -------
 drivers/staging/agnx/xmit.h                      |  250 --
 drivers/staging/comedi/Kconfig                   |    2 +-
 drivers/staging/comedi/comedi_fops.c             |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c     |    2 +-
 drivers/staging/comedi/drivers/cb_pcidio.c       |    8 +-
 drivers/staging/comedi/drivers/jr3_pci.c         |   18 +-
 drivers/staging/comedi/drivers/ni_65xx.c         |   12 +-
 drivers/staging/comedi/drivers/ni_daq_700.c      |    2 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |    2 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c       |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c       |   22 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
 drivers/staging/comedi/drivers/s526.c            |  109 +-
 drivers/staging/comedi/drivers/serial2002.c      |    1 +
 drivers/staging/cowloop/Kconfig                  |   16 -
 drivers/staging/cowloop/Makefile                 |    1 -
 drivers/staging/cowloop/TODO                     |   11 -
 drivers/staging/cowloop/cowloop.c                | 2842 ----------------------
 drivers/staging/cowloop/cowloop.h                |   66 -
 drivers/staging/iio/Kconfig                      |    1 +
 drivers/staging/p9auth/p9auth.c                  |   14 +-
 drivers/staging/rtl8192e/r8192E_core.c           |    1 +
 drivers/staging/winbond/wbusb.c                  |   44 +-
 40 files changed, 148 insertions(+), 8248 deletions(-)
 delete mode 100644 drivers/staging/agnx/Kconfig
 delete mode 100644 drivers/staging/agnx/Makefile
 delete mode 100644 drivers/staging/agnx/TODO
 delete mode 100644 drivers/staging/agnx/agnx.h
 delete mode 100644 drivers/staging/agnx/debug.h
 delete mode 100644 drivers/staging/agnx/pci.c
 delete mode 100644 drivers/staging/agnx/phy.c
 delete mode 100644 drivers/staging/agnx/phy.h
 delete mode 100644 drivers/staging/agnx/rf.c
 delete mode 100644 drivers/staging/agnx/sta.c
 delete mode 100644 drivers/staging/agnx/sta.h
 delete mode 100644 drivers/staging/agnx/table.c
 delete mode 100644 drivers/staging/agnx/table.h
 delete mode 100644 drivers/staging/agnx/xmit.c
 delete mode 100644 drivers/staging/agnx/xmit.h
 delete mode 100644 drivers/staging/cowloop/Kconfig
 delete mode 100644 drivers/staging/cowloop/Makefile
 delete mode 100644 drivers/staging/cowloop/TODO
 delete mode 100644 drivers/staging/cowloop/cowloop.c
 delete mode 100644 drivers/staging/cowloop/cowloop.h

---------------

Frank Mori Hess (2):
      Staging: comedi: ni_pcimio: Added device id for pxi-6225.
      Staging: comedi: pcmcia irq fixes

Greg Kroah-Hartman (4):
      Staging: comedi: serial2002: fix include build issue
      Staging: remove agnx driver
      Staging: remove cowloop driver
      Staging: comedi: fix build on arches that don't want comedi drivers

Ian Abbott (9):
      Staging: comedi: Corrected type of a printk argument in resize_async_buffer().
      Staging: comedi: jr3_pci: Initialize transf variable fully in jr3_pci_poll_subdevice().
      Staging: comedi: cb_pcidio: fix "section mismatch" error
      Staging: comedi: s526: Fix number of channels on DIO subdevice
      Staging: comedi: s526: Get rid of global variable 'cmReg'.
      Staging: comedi: s526: Take account of arch's byte order.
      Staging: comedi: s526: fixes for pulse generator
      Staging: comedi: ni_65xx.c: fix insn_bits shift calculation.
      Staging: comedi: ni_65xx.c: fix output inversion problem.

Jeff Mahoney (3):
      Staging: winbond: implement prepare_multicast and fix API usage
      Staging: iio: Don't build on s390
      Staging: rtl8192e: Add #include <linux/vmalloc.h>

Pekka Enberg (1):
      Staging: w35und: Fix ->beacon_int breakage

Serge E. Hallyn (1):
      Staging: p9auth: a few fixes

