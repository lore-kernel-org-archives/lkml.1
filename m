Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZLWTu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZLWTu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZLWTu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:50:28 -0500
Received: from kroah.org ([198.145.64.141]:39853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZLWTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:50:27 -0500
Date: Wed, 23 Dec 2009 11:49:51 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.33-rc1
Message-ID: <20091223194951.GA18101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for the 2.6.33-rc1 tree.

They do:
	- documentation updates
	- new device ids
	- bugfixes
	- reorg the device ids in one usb-serial driver.  I took this
	  now as it's a merge pressure point, and this is just a code
	  move now, no functionality changed at all.  It's odd that git
	  didn't show this as a code move in the diffstat, I used:
	  	git diff -m --stat --summary
	  to generate the diffstat.  Should I be doing something else?
	  Or is it because the code is being removed from one file and
	  placed in another one?

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-usb |   18 +-
 Documentation/usb/power-management.txt  |   41 +-
 MAINTAINERS                             |    2 +-
 drivers/usb/Makefile                    |    2 -
 drivers/usb/core/hcd.c                  |    4 +-
 drivers/usb/core/hub.c                  |   58 +-
 drivers/usb/core/sysfs.c                |    6 +-
 drivers/usb/core/usb.c                  |    6 +-
 drivers/usb/early/ehci-dbgp.c           |    2 +-
 drivers/usb/gadget/audio.c              |    1 +
 drivers/usb/gadget/f_audio.c            |   15 +-
 drivers/usb/gadget/u_audio.c            |   12 +-
 drivers/usb/gadget/u_audio.h            |    2 +-
 drivers/usb/misc/appledisplay.c         |    5 +-
 drivers/usb/misc/emi62.c                |    2 +-
 drivers/usb/musb/blackfin.c             |  150 +++--
 drivers/usb/musb/blackfin.h             |    2 -
 drivers/usb/musb/cppi_dma.c             |    6 +
 drivers/usb/musb/davinci.c              |    2 +-
 drivers/usb/musb/musb_core.c            |   14 +-
 drivers/usb/musb/musb_gadget.c          |   13 +-
 drivers/usb/musb/musb_gadget_ep0.c      |   14 +-
 drivers/usb/otg/isp1301_omap.c          |    4 +-
 drivers/usb/serial/ftdi_sio.c           |    1 +
 drivers/usb/serial/ftdi_sio.h           |  959 +------------------------------
 drivers/usb/serial/ftdi_sio_ids.h       |  986 +++++++++++++++++++++++++++++++
 drivers/usb/serial/mos7840.c            |    7 +-
 drivers/usb/serial/option.c             |    5 +
 28 files changed, 1234 insertions(+), 1105 deletions(-)
 create mode 100644 drivers/usb/serial/ftdi_sio_ids.h

---------------

Alan Stern (3):
      USB: power management documentation update
      USB: rename usb_configure_device
      USB: fix bugs in usb_(de)authorize_device

Andreas Mohr (2):
      USB: ftdi_sio: isolate all device IDs to new ftdi_sio_ids.h header
      USB: ftdi_sio: sort PID/VID entries in new ftdi_sio_ids.h header

Arnaud Mandy (1):
      USB: musb: gadget: set otg tranceiver to idle when registering gadget

Bill Gatliff (1):
      USB: Fix double-linking of drivers/usb/otg when ULPI is selected

Blaise Gassend (1):
      USB: serial: Extra device/vendor ID for mos7840 driver

Bryan Wu (1):
      USB: musb: workaround Blackfin FIFO anomalies

Clemens Ladisch (1):
      USB: emi62: fix crash when trying to load EMI 6|2 firmware

Cliff Cai (4):
      USB: musb: fix compiling warning with min() macro
      USB: musb: correct DMA address for tx
      USB: audio gadget: fix wTotalLength calculation
      USB: audio gadget: free alsa devices when unloading

Donny Kurnia (1):
      USB: option: support hi speed for modem Haier CE100

Felipe Balbi (4):
      USB: musb: move musb_remove to __exit
      USB: musb: MAINTAINERS: Fix my tree's address
      USB: musb: do not work if no gadget driver is loaded
      usb: otg: isp1301_omap: fix compile error

Jan Beulich (1):
      USB: fix section mismatch in early ehci dbgp

Julia Lawall (1):
      USB: gadget: Use ERR_PTR/IS_ERR

Maulik Mankad (2):
      USB: musb: Fix null pointer dereference issue
      USB: musb: Fix array index out of bounds issue

Randy Dunlap (1):
      USB core: fix recent kernel-doc warnings

Sergei Shtylyov (2):
      USB: musb_gadget: fix kernel oops in txstate()
      USB: musb: gadget_ep0: avoid SetupEnd interrupt

Swaminathan S (2):
      USB: musb: Populate the VBUS GPIO with the correct GPIO number
      USB: musb: fix for crash in DM646x USB when (CPPI)DMA is enabled

pancho horrillo (2):
      USB: add device ID for Apple Cinema Display 23in 2007
      USB: Fix a bug on appledisplay.c regarding signedness

