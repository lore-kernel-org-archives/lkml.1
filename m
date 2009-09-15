Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbZIOTHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbZIOTHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZIOTHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:07:48 -0400
Received: from kroah.org ([198.145.64.141]:35820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbZIOTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:24 -0400
Date: Tue, 15 Sep 2009 11:12:47 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.31-git
Message-ID: <20090915181247.GA32167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the driver core patchset for the 2.6.31 merge window

It consists of a variety of different things:
	- devtmpfs.  This has been discussed a lot, is tiny,
	  self-contained, and has been acked by all of the major distros
	  as something they will use, and it has been used in the SuSE
	  kernels for quite some time now.
	- driver core cleanups
	- debugfs documentation updates
	- uio drivers
	- hplio driver updates (for some reason they came in through
	  this tree due to procedural issues, they are self-contained).
	- other minor stuff.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
long time.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/DocBook/uio-howto.tmpl       |  163 ++++++++++++
 Documentation/trace/events.txt             |   24 +-
 MAINTAINERS                                |    7 +
 block/genhd.c                              |    2 +-
 drivers/base/Kconfig                       |   25 ++
 drivers/base/Makefile                      |    2 +
 drivers/base/base.h                        |   13 +-
 drivers/base/bus.c                         |   23 +-
 drivers/base/class.c                       |   87 +++++++
 drivers/base/core.c                        |   29 ++-
 drivers/base/dd.c                          |   31 +++-
 drivers/base/devtmpfs.c                    |  367 ++++++++++++++++++++++++++++
 {kernel => drivers/base}/dma-coherent.c    |    0
 drivers/base/driver.c                      |    4 +-
 drivers/base/init.c                        |    1 +
 drivers/base/platform.c                    |    8 +-
 drivers/block/cciss.c                      |    2 +-
 drivers/block/pktcdvd.c                    |    2 +-
 drivers/char/mem.c                         |   82 +++----
 drivers/firewire/core-device.c             |    2 +-
 drivers/firmware/dmi-id.c                  |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c     |    2 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h |    2 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c  |    2 +-
 drivers/input/input.c                      |    2 +-
 drivers/misc/enclosure.c                   |    4 +-
 drivers/misc/hpilo.c                       |  290 +++++++++++++++-------
 drivers/misc/hpilo.h                       |    8 +-
 drivers/mmc/core/mmc.c                     |    2 +-
 drivers/mmc/core/sd.c                      |    2 +-
 drivers/mtd/mtdcore.c                      |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    6 +-
 drivers/s390/cio/css.c                     |    2 +-
 drivers/s390/cio/device.c                  |    2 +-
 drivers/s390/net/netiucv.c                 |    2 +-
 drivers/scsi/scsi_priv.h                   |    2 +-
 drivers/scsi/scsi_sysfs.c                  |    4 +-
 drivers/uio/Kconfig                        |   15 +-
 drivers/uio/Makefile                       |    1 +
 drivers/uio/uio_pci_generic.c              |  207 ++++++++++++++++
 drivers/usb/core/endpoint.c                |    2 +-
 drivers/usb/core/sysfs.c                   |    4 +-
 drivers/usb/core/usb.h                     |    4 +-
 drivers/usb/host/uhci-hcd.c                |    2 +-
 drivers/uwb/lc-dev.c                       |    2 +-
 fs/partitions/check.c                      |    2 +-
 include/linux/attribute_container.h        |    2 +-
 include/linux/device.h                     |   45 +++--
 include/linux/netdevice.h                  |    2 +-
 include/linux/pci_regs.h                   |    1 +
 include/linux/shmem_fs.h                   |    3 +
 include/linux/transport_class.h            |    2 +-
 init/do_mounts.c                           |    2 +-
 init/main.c                                |    2 +
 kernel/Makefile                            |    1 -
 mm/shmem.c                                 |    9 +-
 net/bluetooth/hci_sysfs.c                  |    4 +-
 net/core/net-sysfs.c                       |    2 +-
 samples/trace_events/trace-events-sample.h |    2 +-
 59 files changed, 1287 insertions(+), 239 deletions(-)
 create mode 100644 drivers/base/devtmpfs.c
 rename {kernel => drivers/base}/dma-coherent.c (100%)
 create mode 100644 drivers/uio/uio_pci_generic.c

---------------

Alan Stern (1):
      Driver core: add new device to bus's list before probing

Andrew Morton (1):
      driver core: platform_device_add_data(): use kmemdup()

Daniel Mack (1):
      UIO: remove 'default n' from Kconfig

David Altobelli (3):
      hpilo: staging for interrupt handling
      hpilo: add interrupt handler
      hpilo: add poll f_op

David Brownell (1):
      driver model: constify attribute groups

GeunSik Lim (5):
      debugfs: Fix mount directory of debugfs by default in events.txt
      debugfs: Change debuhgfs directory of trace-events-sample.h
      debugfs: Change debugfs directory of IWMC3200
      debugfs: Modified default dir of debugfs for debugging UHCI.
      debugfs: Modify default debugfs directory for debugging pktcdvd.

Greg Kroah-Hartman (1):
      Driver core: move dev_get/set_drvdata to drivers/base/dd.c

Jean Delvare (1):
      Driver core: Add support for compatibility classes

Jin Dongming (1):
      mem_class: fix bug

Kay Sievers (2):
      mem_class: use minor as index instead of searching the array
      Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev

Mark Brown (1):
      Driver core: Add accessor for device platform data

Michael S. Tsirkin (1):
      uio: add generic driver for PCI 2.3 devices

Ming Lei (1):
      driver-core: move dma-coherent.c from kernel to driver/base

