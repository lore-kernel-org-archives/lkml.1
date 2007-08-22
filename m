Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbXHVWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbXHVWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbXHVWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:19:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37071 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967AbXHVWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:19:46 -0400
Date: Wed, 22 Aug 2007 15:08:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.23-rc3
Message-ID: <20070822220805.GB30603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.23-rc3 git tree.

They do the following:
	- more quirk updates for broken devices.
	- device id updates
	- lots of little bugfixes
	- compiler warning fixes

Most of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/media/video/em28xx/em28xx-video.c |    1 +
 drivers/media/video/pwc/pwc-if.c          |   52 +++++++++++-----
 drivers/media/video/pwc/pwc.h             |    1 +
 drivers/usb/Kconfig                       |    1 +
 drivers/usb/atm/cxacru.c                  |    3 +-
 drivers/usb/atm/ueagle-atm.c              |    5 +-
 drivers/usb/class/cdc-acm.c               |   12 +++-
 drivers/usb/core/driver.c                 |    9 +--
 drivers/usb/core/hub.c                    |    3 +-
 drivers/usb/core/message.c                |   28 ++++++++-
 drivers/usb/core/quirks.c                 |   12 ++++
 drivers/usb/gadget/dummy_hcd.c            |    2 -
 drivers/usb/gadget/file_storage.c         |   10 +--
 drivers/usb/gadget/fsl_usb2_udc.c         |   77 +++++++++++++-----------
 drivers/usb/gadget/pxa2xx_udc.c           |    4 +-
 drivers/usb/host/Kconfig                  |    2 +-
 drivers/usb/host/ehci-au1xxx.c            |    5 +-
 drivers/usb/host/ehci-ppc-soc.c           |   22 ++++++-
 drivers/usb/host/ohci-dbg.c               |    2 +-
 drivers/usb/host/r8a66597-hcd.c           |    2 -
 drivers/usb/host/u132-hcd.c               |    3 +
 drivers/usb/serial/airprime.c             |    1 -
 drivers/usb/serial/belkin_sa.c            |    4 +
 drivers/usb/serial/ftdi_sio.c             |    2 +
 drivers/usb/serial/ftdi_sio.h             |    3 +
 drivers/usb/serial/garmin_gps.c           |   93 +++++++++++++++--------------
 drivers/usb/serial/ipaq.c                 |    1 +
 drivers/usb/serial/option.c               |   10 ++-
 drivers/usb/serial/oti6858.c              |   10 +--
 drivers/usb/serial/safe_serial.c          |    6 +-
 drivers/usb/serial/visor.c                |    2 +
 drivers/usb/serial/visor.h                |    3 +
 drivers/usb/storage/unusual_devs.h        |    2 +-
 drivers/usb/storage/usb.c                 |   33 ++--------
 drivers/usb/storage/usb.h                 |    1 +
 35 files changed, 255 insertions(+), 172 deletions(-)

---------------

Alan Stern (7):
      USB: cdc-acm: fix sysfs attribute registration bug
      USB: remove DEBUG definition from dummy_hcd
      USB: accept 1-byte Device Status replies, fixing some b0rken devices
      usb-storage: fix bugs in the disconnect pathway
      USB: allow retry on descriptor fetch errors
      USB: update last_busy field correctly
      USB: g_file_storage: fix bug in DMA buffer handling

Andy Green (1):
      USB: belkin_sa: avoid divide by zero error

Christian Heim (1):
      USB: Adding support for HTC Smartphones to ipaq

David Brownell (3):
      USB: px2xx_udc bugfix, missing check for gpio_pullup
      USB: quirks: multicard reader doesn't like autosuspend
      USB: ohci, fix oddball gcc warning

Faidon Liambotis (1):
      USB: fix support for Dell Wireless Broadband (aka WWAN)

Gabriel C (1):
      USB: u132-hcd.c - Fix a warning when CONFIG_PM=n

Hermann Kneissel (1):
      USB: serial: garmin_gps: fixes package loss if used from gpsbabel

Jesper Juhl (1):
      USB: Fix a memory leak in em28xx_usb_probe()

Kay Sievers (1):
      usb: add PRODUCT, TYPE to usb-interface events

Li Yang (1):
      USB: fsl_usb2_udc: fix bug in processing setup requests

Luis Lloret (1):
      USB: Stall control endpoint when file storage class request wValue != 0

M4rkusXXL (1):
      usb: typo in usb R8A66597 HCD config

Maximilian Attems (1):
      USB: visor add ACER S10 palm device id

Mike Nuss (1):
      USB: make EHCI initialize properly on PPC SOCs

Mike Pagano (1):
      USB: resubmission unusual_devs modification for Nikon D80

Oliver Neukum (5):
      USB: blacklist Samsung ML-2010 printer
      USB: quirky mass storage device
      USB: another quirky device
      USB: unkill cxacru atm driver
      USB: fix DoS in pwc USB video driver

Paul Mundt (2):
      usb: Enable hcd support on SH unconditionally.
      usb: r8a66597-hcd: fix up error path.

Paul Walmsley (1):
      usb quirks: Add Canon EOS 5D (PC Connection mode) to the autosuspend blacklist

Robert P. J. Day (1):
      USB: Typo: "USB_SAFE_PADDED" -> "USB_SERIAL_SAFE_PADDED".

Stanislaw Gruszka (1):
      UEAGLE: Remove sysfs files on error case

Søren Hauberg (1):
      USB: Support for the Evolution Scorpion robots

Thomas Viehmann (1):
      usb-serial: fix oti6858.c segfault in termios handling

