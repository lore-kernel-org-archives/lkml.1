Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZAFWMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZAFWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZAFWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:12:31 -0500
Received: from kroah.org ([198.145.64.141]:51156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750917AbZAFWM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:12:29 -0500
Date: Tue, 6 Jan 2009 14:11:23 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for your 2.6-git tree
Message-ID: <20090106221123.GA32689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the main driver-core pull request for the 2.6.29-rc1 merge window.

There are lots of things in here, all of which have been in the
linux-next releases for quite some time.  A large majority of these are
the bus_id cleanups, that touch lots of other subsystems.  These patches
have all been sent to the different subsystem maintainers, and have been
acked by them to be included here.

Other than that the patches are:
	- uio updates
	- driver core minor cleanups
	- PM core and PCI suspend changes

All of these have been in the -next trees and the -mm releases for a
while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/DocBook/uio-howto.tmpl     |  101 +++++++++++++++-
 Documentation/kobject.txt                |    4 +-
 arch/arm/kernel/ecard.c                  |    2 +-
 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-ep93xx/core.c              |    6 +-
 arch/arm/mach-integrator/core.c          |   10 +-
 arch/arm/mach-integrator/integrator_cp.c |    6 +-
 arch/arm/mach-lh7a40x/clcd.c             |    2 +-
 arch/arm/mach-netx/fb.c                  |    2 +-
 arch/arm/mach-realview/core.h            |    2 +-
 arch/arm/mach-versatile/core.h           |    2 +-
 arch/arm/plat-omap/include/mach/memory.h |    2 +-
 arch/avr32/mach-at32ap/clock.c           |    4 +-
 arch/cris/arch-v32/drivers/iop_fw_load.c |    6 +-
 arch/ia64/kernel/pci-dma.c               |    2 +-
 arch/ia64/sn/kernel/tiocx.c              |    3 +-
 arch/mips/kernel/vpe.c                   |    2 +-
 arch/s390/include/asm/s390_rdev.h        |   15 ---
 block/bsg.c                              |    6 +-
 block/genhd.c                            |    2 +-
 drivers/ata/libata-scsi.c                |    2 +-
 drivers/base/attribute_container.c       |    2 +-
 drivers/base/base.h                      |   26 ++++
 drivers/base/bus.c                       |   52 +++++---
 drivers/base/core.c                      |  197 +++++++++++++++++++++++-------
 drivers/base/dd.c                        |   26 ++--
 drivers/base/driver.c                    |   13 ++-
 drivers/base/firmware_class.c            |    8 +-
 drivers/base/isa.c                       |    7 +-
 drivers/base/platform.c                  |  130 ++++++++++----------
 drivers/base/power/main.c                |   21 ++--
 drivers/base/power/trace.c               |    4 +-
 drivers/char/mwave/mwavedd.c             |    2 +-
 drivers/firmware/dmi-id.c                |    2 +-
 drivers/gpio/gpiolib.c                   |    2 +-
 drivers/gpu/drm/drm_sysfs.c              |    2 +-
 drivers/hwmon/hwmon.c                    |    2 +-
 drivers/hwmon/lm75.c                     |    2 +-
 drivers/idle/i7300_idle.c                |    2 +-
 drivers/infiniband/core/sysfs.c          |    2 +-
 drivers/infiniband/core/ucm.c            |    3 +-
 drivers/infiniband/ulp/srp/ib_srp.c      |    3 +-
 drivers/isdn/mISDN/dsp_pipeline.c        |    2 +-
 drivers/lguest/lguest_device.c           |   10 +-
 drivers/macintosh/macio_asic.c           |   24 ++--
 drivers/memstick/core/memstick.c         |    5 +-
 drivers/memstick/core/mspro_block.c      |   14 +-
 drivers/memstick/host/tifm_ms.c          |    4 +-
 drivers/message/i2o/device.c             |    8 +-
 drivers/message/i2o/i2o_proc.c           |    2 +-
 drivers/message/i2o/iop.c                |    2 +-
 drivers/misc/sgi-gru/grumain.c           |    2 +-
 drivers/misc/sgi-xp/xp_main.c            |    2 +-
 drivers/misc/sgi-xp/xpc_main.c           |    8 +-
 drivers/misc/sgi-xp/xpnet.c              |    2 +-
 drivers/misc/tifm_7xx1.c                 |    2 +-
 drivers/misc/tifm_core.c                 |    7 +-
 drivers/mtd/devices/m25p80.c             |   16 ++--
 drivers/mtd/devices/mtd_dataflash.c      |   30 +++---
 drivers/mtd/maps/integrator-flash.c      |    2 +-
 drivers/mtd/maps/ixp2000.c               |    4 +-
 drivers/mtd/maps/ixp4xx.c                |    2 +-
 drivers/mtd/maps/omap_nor.c              |    2 +-
 drivers/mtd/maps/physmap.c               |    6 +-
 drivers/mtd/maps/physmap_of.c            |    4 +-
 drivers/mtd/mtdconcat.c                  |    2 +-
 drivers/mtd/nand/fsl_upm.c               |    2 +-
 drivers/mtd/nand/plat_nand.c             |    2 +-
 drivers/mtd/nand/tmio_nand.c             |    2 +-
 drivers/mtd/onenand/generic.c            |    2 +-
 drivers/mtd/onenand/omap2.c              |    2 +-
 drivers/mtd/ubi/build.c                  |    2 +-
 drivers/mtd/ubi/vmt.c                    |    4 +-
 drivers/pci/pci-driver.c                 |  132 ++++++++++++--------
 drivers/pnp/card.c                       |    7 +-
 drivers/pnp/core.c                       |    5 +-
 drivers/pnp/system.c                     |    2 +-
 drivers/power/ds2760_battery.c           |    4 +-
 drivers/s390/Makefile                    |    2 +-
 drivers/s390/block/dcssblk.c             |   11 +-
 drivers/s390/crypto/ap_bus.c             |    7 +-
 drivers/s390/kvm/kvm_virtio.c            |    5 +-
 drivers/s390/net/cu3088.c                |    7 +-
 drivers/s390/net/qeth_core_main.c        |    7 +-
 drivers/s390/net/qeth_l2_main.c          |    2 -
 drivers/s390/net/qeth_l3_main.c          |    2 -
 drivers/s390/s390_rdev.c                 |   51 --------
 drivers/serial/serial_core.c             |    4 +-
 drivers/spi/spi.c                        |   20 ++--
 drivers/spi/spi_bitbang.c                |    2 +-
 drivers/spi/spi_butterfly.c              |    2 +-
 drivers/spi/spi_lm70llp.c                |    2 +-
 drivers/thermal/thermal_sys.c            |    6 +-
 drivers/uio/uio.c                        |  159 +++++++++++++++++++++---
 drivers/uio/uio_cif.c                    |    3 +-
 drivers/uio/uio_pdrv_genirq.c            |    5 +-
 drivers/usb/core/usb.c                   |    4 +-
 drivers/usb/gadget/at91_udc.c            |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c      |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c          |    2 +-
 drivers/usb/gadget/lh7a40x_udc.c         |    2 +-
 drivers/usb/gadget/pxa25x_udc.c          |    2 +-
 drivers/usb/gadget/pxa27x_udc.c          |    2 +-
 drivers/usb/gadget/s3c2410_udc.c         |    2 +-
 drivers/video/backlight/backlight.c      |    2 +-
 drivers/video/backlight/lcd.c            |    2 +-
 drivers/video/output.c                   |    2 +-
 drivers/virtio/virtio_pci.c              |   17 +--
 drivers/w1/w1.c                          |   19 ++--
 drivers/w1/w1_int.c                      |    3 +-
 drivers/xen/xenbus/xenbus_probe.c        |   27 +++--
 drivers/xen/xenbus/xenbus_probe.h        |    4 +-
 fs/partitions/check.c                    |   11 +--
 include/linux/device.h                   |   39 ++++--
 include/linux/kernel.h                   |    8 +-
 include/linux/klist.h                    |    2 -
 include/linux/mtd/concat.h               |    2 +-
 include/linux/pci.h                      |    1 -
 include/linux/platform_device.h          |    1 -
 include/linux/pm.h                       |   88 +++++---------
 include/linux/uio_driver.h               |   30 ++++-
 init/Kconfig                             |   44 ++++---
 kernel/ksysfs.c                          |    4 +-
 kernel/power/main.c                      |    6 +-
 lib/dynamic_printk.c                     |   58 ++++-----
 lib/klist.c                              |   43 ++++++-
 lib/kobject_uevent.c                     |    8 +-
 lib/swiotlb.c                            |    2 +-
 net/iucv/iucv.c                          |    7 +-
 129 files changed, 1063 insertions(+), 701 deletions(-)
 delete mode 100644 arch/s390/include/asm/s390_rdev.h
 delete mode 100644 drivers/s390/s390_rdev.c

---------------

Alan Stern (2):
      Fix misspellings in pm.h macros
      Driver core: move the bus notifier call points

Arjan van de Ven (1):
      UIO: use pci_ioremap_bar() in drivers/uio

Cornelia Huck (1):
      Make DEBUG take precedence over DYNAMIC_PRINTK_DEBUG

Greg Kroah-Hartman (4):
      driver core: create a private portion of struct device
      driver core: move klist_children into private structure
      driver core: move knode_driver into private structure
      driver core: move knode_bus into private structure

Hans J. Koch (2):
      UIO: Pass information about ioports to userspace (V2)
      UIO: Documentation for UIO ioport info handling

Kay Sievers (34):
      driver core: struct device - replace bus_id with dev_name(), dev_set_name()
      sysfs: clarify SYSFS_DEPRECATED help text
      xen: struct device - replace bus_id with dev_name(), dev_set_name()
      w1: struct device - replace bus_id with dev_name(), dev_set_name()
      video: struct device - replace bus_id with dev_name(), dev_set_name()
      tifm: struct device - replace bus_id with dev_name(), dev_set_name()
      thermal: struct device - replace bus_id with dev_name(), dev_set_name()
      swiotlb: struct device - replace bus_id with dev_name(), dev_set_name()
      spi: struct device - replace bus_id with dev_name(), dev_set_name()
      SGI: struct device - replace bus_id with dev_name(), dev_set_name()
      serial: struct device - replace bus_id with dev_name(), dev_set_name()
      power-supply: struct device - replace bus_id with dev_name(), dev_set_name()
      pnp: struct device - replace bus_id with dev_name(), dev_set_name()
      mwave: struct device - replace bus_id with dev_name(), dev_set_name()
      mtd: struct device - replace bus_id with dev_name(), dev_set_name()
      mips: struct device - replace bus_id with dev_name(), dev_set_name()
      memstick: struct device - replace bus_id with dev_name(), dev_set_name()
      macintosh: struct device - replace bus_id with dev_name(), dev_set_name()
      pm: struct device - replace bus_id with dev_name(), dev_set_name()
      ISDN: struct device - replace bus_id with dev_name(), dev_set_name()
      infiniband: struct device - replace bus_id with dev_name(), dev_set_name()
      i7300_idle: struct device - replace bus_id with dev_name(), dev_set_name()
      IA64: struct device - replace bus_id with dev_name(), dev_set_name()
      i2o: struct device - replace bus_id with dev_name(), dev_set_name()
      hwmon: struct device - replace bus_id with dev_name(), dev_set_name()
      gpu: struct device - replace bus_id with dev_name(), dev_set_name()
      gpio: struct device - replace bus_id with dev_name(), dev_set_name()
      gadget: struct device - replace bus_id with dev_name(), dev_set_name()
      dmi: struct device - replace bus_id with dev_name(), dev_set_name()
      chris: struct device - replace bus_id with dev_name(), dev_set_name()
      block: struct device - replace bus_id with dev_name(), dev_set_name()
      avr: struct device - replace bus_id with dev_name(), dev_set_name()
      libata: struct device - replace bus_id with dev_name(), dev_set_name()
      arm: struct device - replace bus_id with dev_name(), dev_set_name()

Mark McLoughlin (4):
      driver core: add root_device_register()
      virtio: do not statically allocate root device
      lguest: do not statically allocate root device
      s390: remove s390_root_dev_*()

Matthew Wilcox (2):
      driver core: Rearrange struct device for better packing
      driver core: Remove completion from struct klist_node

Mike Frysinger (1):
      UIO: uio_pdrv_genirq: allow custom irq_flags

Ming Lei (3):
      kobject: return the result of uevent sending by netlink
      kernel/ksysfs.c:fix dependence on CONFIG_NET
      driver core:fix duplicate removing driver link in __device_release_driver

Rafael J. Wysocki (2):
      PM: Simplify the new suspend/hibernation framework for devices
      PCI: Rework default handling of suspend and resume

Rusty Russell (1):
      kobject: Make Documentation/kobject.txt a little more coherent.

Stephen Rothwell (1):
      uio: make uio_info's name and version const

Tejun Heo (1):
      uevent: don't pass envp_ext[] as format string in kobject_uevent_env()

Wu Fengguang (1):
      dynamic_printk: reduce one level of indentation

