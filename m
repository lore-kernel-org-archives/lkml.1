Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbYJPRPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbYJPRPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYJPRN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:13:27 -0400
Received: from kroah.org ([198.145.64.141]:46910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755403AbYJPRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:13:25 -0400
Date: Thu, 16 Oct 2008 10:09:55 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for your 2.6-git tree
Message-ID: <20081016170954.GA11824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the driver core patchset for your 2.6-git tree.

Highlights include:
	- device_create_drvdata is finally removed as it's no longer
	  used, device_create is all that is needed.  This went through
	  a 2 kernel release cycle to flush everything out properly.
	- dynamic dev_printk() patch, allows debugging to be turned on
	  the fly, instead of at build time.  This is very good and has
	  been in the opensuse beta releases already with much success.
	- the usb gadget drivers had to be reworked to fix linker errors
	  that the dynamic dev_printk() patches exposed.  They are in
	  this tree as the dev_printk() patches require them in order to
	  not break the build.
	- uio cleanups and a new uio driver
	- sysfs field added to oops messages from Andrew.  This has been
	  in the -mm tree for years and in the SuSE kernel releases for
	  almost the same ammount of time and has been very helpful.
	- minor bugfixes all over the place

All of these have been in the -next trees and the -mm releases for a
while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt          |    5 +
 Documentation/kobject.txt                    |    4 +
 arch/mips/kernel/rtlx.c                      |    4 +-
 arch/mips/sibyte/common/sb_tbprof.c          |    3 +-
 arch/x86/kernel/cpuid.c                      |    4 +-
 arch/x86/kernel/dumpstack_32.c               |    2 +
 arch/x86/kernel/dumpstack_64.c               |    2 +
 arch/x86/kernel/msr.c                        |    4 +-
 block/bsg.c                                  |    3 +-
 drivers/base/bus.c                           |   54 +++-
 drivers/base/core.c                          |   30 ++-
 drivers/base/dd.c                            |    3 +
 drivers/base/platform.c                      |   49 +++-
 drivers/base/power/main.c                    |    2 +-
 drivers/block/aoe/aoechr.c                   |    6 +-
 drivers/block/paride/pg.c                    |    5 +-
 drivers/block/paride/pt.c                    |   10 +-
 drivers/block/pktcdvd.c                      |    5 +-
 drivers/char/bsr.c                           |    5 +-
 drivers/char/dsp56k.c                        |    4 +-
 drivers/char/ip2/ip2main.c                   |   12 +-
 drivers/char/ipmi/ipmi_devintf.c             |    2 +-
 drivers/char/istallion.c                     |    5 +-
 drivers/char/lp.c                            |    4 +-
 drivers/char/mem.c                           |    6 +-
 drivers/char/misc.c                          |    4 +-
 drivers/char/pcmcia/cm4000_cs.c              |    2 +-
 drivers/char/pcmcia/cm4040_cs.c              |    3 +-
 drivers/char/ppdev.c                         |    5 +-
 drivers/char/raw.c                           |    7 +-
 drivers/char/snsc.c                          |    4 +-
 drivers/char/stallion.c                      |    4 +-
 drivers/char/tty_io.c                        |    2 +-
 drivers/char/vc_screen.c                     |   12 +-
 drivers/char/viotape.c                       |    8 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c   |    3 +-
 drivers/dca/dca-sysfs.c                      |    8 +-
 drivers/firmware/iscsi_ibft.c                |   18 +-
 drivers/hid/hidraw.c                         |    5 +-
 drivers/hwmon/hwmon.c                        |    4 +-
 drivers/i2c/i2c-dev.c                        |    6 +-
 drivers/ide/ide-probe.c                      |    4 +-
 drivers/ide/ide-tape.c                       |   11 +-
 drivers/ieee1394/dv1394.c                    |    8 +-
 drivers/ieee1394/raw1394.c                   |    8 +-
 drivers/ieee1394/video1394.c                 |    5 +-
 drivers/infiniband/core/cm.c                 |    6 +-
 drivers/infiniband/core/user_mad.c           |   12 +-
 drivers/infiniband/core/uverbs_main.c        |    9 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 drivers/isdn/capi/capi.c                     |    3 +-
 drivers/leds/led-class.c                     |    4 +-
 drivers/macintosh/adb.c                      |    3 +-
 drivers/media/dvb/dvb-core/dvbdev.c          |    2 +-
 drivers/misc/phantom.c                       |    6 +-
 drivers/mtd/mtdchar.c                        |   10 +-
 drivers/net/phy/phy_device.c                 |    8 +-
 drivers/net/ppp_generic.c                    |    4 +-
 drivers/net/wan/cosa.c                       |    4 +-
 drivers/net/wireless/mac80211_hwsim.c        |    6 +-
 drivers/pci/probe.c                          |   50 +---
 drivers/pnp/base.h                           |    2 +-
 drivers/pnp/core.c                           |   10 +-
 drivers/pnp/driver.c                         |    1 +
 drivers/pnp/interface.c                      |   37 +--
 drivers/power/power_supply_core.c            |    4 +-
 drivers/s390/char/raw3270.c                  |   14 +-
 drivers/s390/char/tape_class.c               |    6 +-
 drivers/s390/char/vmlogrdr.c                 |    8 +-
 drivers/s390/char/vmur.c                     |    5 +-
 drivers/scsi/ch.c                            |    6 +-
 drivers/scsi/dpt_i2o.c                       |    2 +-
 drivers/scsi/osst.c                          |    3 +-
 drivers/scsi/sg.c                            |   10 +-
 drivers/scsi/st.c                            |   11 +-
 drivers/spi/spidev.c                         |    7 +-
 drivers/uio/Kconfig                          |   13 +
 drivers/uio/Makefile                         |    1 +
 drivers/uio/uio.c                            |   26 ++-
 drivers/uio/uio_pdrv.c                       |    2 +-
 drivers/uio/uio_sercos3.c                    |  243 +++++++++++++++
 drivers/usb/core/devio.c                     |    6 +-
 drivers/usb/core/file.c                      |    6 +-
 drivers/usb/core/hcd.c                       |    5 +-
 drivers/usb/gadget/Makefile                  |   23 +-
 drivers/usb/gadget/cdc2.c                    |   25 ++-
 drivers/usb/gadget/ether.c                   |   28 ++-
 drivers/usb/gadget/f_ecm.c                   |  108 ++++----
 drivers/usb/gadget/f_loopback.c              |   34 ++-
 drivers/usb/gadget/f_subset.c                |   44 ++--
 drivers/usb/gadget/file_storage.c            |   12 +
 drivers/usb/gadget/gmidi.c                   |   15 +
 drivers/usb/gadget/printer.c                 |   18 +-
 drivers/usb/gadget/rndis.c                   |  115 ++++----
 drivers/usb/gadget/serial.c                  |   18 ++
 drivers/usb/gadget/u_ether.c                 |    4 +-
 drivers/usb/gadget/zero.c                    |   17 +
 drivers/usb/host/uhci-q.c                    |   24 +-
 drivers/usb/misc/phidgetkit.c                |    5 +-
 drivers/usb/misc/phidgetmotorcontrol.c       |    5 +-
 drivers/usb/misc/phidgetservo.c              |    5 +-
 drivers/usb/mon/mon_bin.c                    |    6 +-
 drivers/video/console/fbcon.c                |    4 +-
 drivers/video/display/display-sysfs.c        |    9 +-
 drivers/video/fbmem.c                        |    5 +-
 fs/coda/psdev.c                              |    5 +-
 fs/sysfs/bin.c                               |   42 ++-
 fs/sysfs/dir.c                               |   24 +-
 fs/sysfs/file.c                              |   46 ++-
 fs/sysfs/mount.c                             |   15 +
 fs/sysfs/sysfs.h                             |    6 +-
 include/asm-generic/vmlinux.lds.h            |   10 +-
 include/linux/device.h                       |   18 +-
 include/linux/dynamic_printk.h               |   93 ++++++
 include/linux/kernel.h                       |    7 +-
 include/linux/module.h                       |    1 -
 include/linux/platform_device.h              |    2 +
 include/linux/sysfs.h                        |   36 ++-
 kernel/module.c                              |   33 ++-
 lib/Kconfig.debug                            |   55 ++++
 lib/Makefile                                 |    2 +
 lib/dynamic_printk.c                         |  418 ++++++++++++++++++++++++++
 lib/kobject.c                                |   35 ++-
 net/netfilter/nf_conntrack_pptp.c            |    2 +-
 scripts/Makefile.lib                         |   11 +-
 scripts/basic/Makefile                       |    2 +-
 scripts/basic/hash.c                         |   64 ++++
 sound/core/init.c                            |    6 +-
 sound/core/sound.c                           |    5 +-
 sound/oss/soundcard.c                        |   15 +-
 sound/sound_core.c                           |    5 +-
 131 files changed, 1786 insertions(+), 617 deletions(-)
 create mode 100644 drivers/uio/uio_sercos3.c
 create mode 100644 include/linux/dynamic_printk.h
 create mode 100644 lib/dynamic_printk.c
 create mode 100644 scripts/basic/hash.c

---------------

Adrian Bunk (2):
      driver core: make struct platform_pm_ops static
      drivers/firmware/iscsi_ibft.c: make 3 functions static

Alexey Dobriyan (1):
      modules: fix module "notes" kobject leak

Andrew G. Harvey (1):
      UIO: Fix mapping of logical and virtual memory

Andrew Morton (1):
      sysfs: crash debugging

Arjan van de Ven (4):
      device model: Do a quickcheck for driver binding before doing an expensive check
      debug: Introduce a dev_WARN() function
      debug: use dev_WARN() rather than WARN_ON() in device_pm_add()
      usb: turn dev_warn+WARN_ON combos into dev_WARN

Cornelia Huck (2):
      Driver core: Clarify device cleanup.
      Driver core: Fix cleanup in device_create_vargs().

David Brownell (7):
      usb gadget: link fixes for serial gadget
      usb gadget: link fixes for gadget zero
      usb gadget: link fixes for MIDI gadget
      usb gadget: link fixes for printer gadget
      usb gadget: link fixes for storage gadget
      usb gadget: link fixes for cdc composite gadget
      usb gadget: link fixes for network gadget

Dmitry Baryshkov (1):
      platform: add new device registration helper

Drew Moseley (1):
      PNP: create device attributes via default device attributes

Eric W. Biederman (2):
      kobject: Fix kobject_rename and !CONFIG_SYSFS
      kobject: Cleanup kobject_rename and !CONFIG_SYSFS

Greg Kroah-Hartman (15):
      device create: block: convert device_create_drvdata to device_create
      device create: char: convert device_create_drvdata to device_create
      device create: ieee1394: convert device_create_drvdata to device_create
      device create: infiniband: convert device_create_drvdata to device_create
      device create: misc: convert device_create_drvdata to device_create
      device create: net: convert device_create_drvdata to device_create
      device create: s390: convert device_create_drvdata to device_create
      device create: scsi: convert device_create_drvdata to device_create
      device create: sound: convert device_create_drvdata to device_create
      device create: usb: convert device_create_drvdata to device_create
      device create: video: convert device_create_drvdata to device_create
      device create: ide: convert device_create_drvdata to device_create
      device create: remove device_create_drvdata
      NET: convert the phy_device file to use bus_find_device_by_name
      Driver core: add bus_sort_breadthfirst() function

Hans J. Koch (2):
      UIO: Add alignment warnings for uio-mem
      UIO: Change driver name of uio_pdrv

Jason Baron (1):
      driver core: basic infrastructure for per-module dynamic debug messages

John Ogness (1):
      UIO: add automata sercos3 pci card support

Neil Brown (1):
      sysfs: Support sysfs_notify from atomic context with new sysfs_notify_dirent

Nick Piggin (1):
      sysfs: fix deadlock

Peter Korsgaard (1):
      Driver core: make bus_find_device_by_name() more robust

Tejun Heo (1):
      sysfs: use ilookup5() instead of ilookup5_nowait()

Trent Piepho (1):
      sysfs: Make dir and name args to sysfs_notify() const

