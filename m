Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYGVFW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYGVFW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYGVFVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:21:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:43027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbYGVFVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:21:49 -0400
Date: Mon, 21 Jul 2008 22:18:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches against 2.6.26
Message-ID: <20080722051805.GA17373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of driver core patches against your 2.6.26-git tree.

They do a variety of things:
	- class core cleanups
	- fixup for device_create() api
	- KOBJ_NAME_LEN fixes
	- bus_id removals
	- UIO driver updates
	- HP driver for service processors

All of these have been in the -mm and -next trees for quite a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-dev                |   20 +
 Documentation/DocBook/uio-howto.tmpl               |   63 ++-
 Documentation/HOWTO                                |    2 +-
 Documentation/filesystems/sysfs.txt                |    6 +
 Documentation/sysfs-rules.txt                      |    5 +-
 arch/arm/common/dmabounce.c                        |   22 +-
 arch/arm/common/locomo.c                           |    2 +-
 arch/arm/common/sa1111.c                           |   10 +-
 arch/arm/common/scoop.c                            |    2 +-
 arch/arm/kernel/ecard.c                            |    5 +-
 arch/arm/kernel/time.c                             |    4 +-
 arch/arm/mach-integrator/impd1.c                   |    7 +-
 arch/arm/mach-integrator/lm.c                      |    6 +-
 arch/arm/plat-omap/mailbox.c                       |    2 +-
 arch/avr32/kernel/cpu.c                            |   38 +-
 arch/ia64/kernel/err_inject.c                      |   22 +-
 arch/mips/kernel/rtlx.c                            |    4 +-
 arch/mips/sibyte/common/sb_tbprof.c                |    3 +-
 arch/powerpc/kernel/sysfs.c                        |   15 +-
 arch/powerpc/platforms/cell/cbe_thermal.c          |   45 +-
 arch/powerpc/platforms/cell/spu_base.c             |    3 +-
 arch/powerpc/platforms/chrp/pci.c                  |    2 +-
 arch/s390/kernel/smp.c                             |   36 +-
 arch/s390/kernel/time.c                            |   35 +-
 arch/sh/drivers/dma/dma-sysfs.c                    |   15 +-
 arch/sparc64/kernel/ebus.c                         |    4 +-
 arch/sparc64/kernel/of_device.c                    |    4 +-
 arch/sparc64/kernel/pci.c                          |    2 +-
 arch/sparc64/kernel/sysfs.c                        |   16 +-
 arch/sparc64/kernel/vio.c                          |   18 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c                |   18 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    1 +
 arch/x86/kernel/cpuid.c                            |    4 +-
 arch/x86/kernel/microcode.c                        |   10 +-
 arch/x86/kernel/msr.c                              |    4 +-
 arch/x86/kernel/pci-dma.c                          |    6 +-
 arch/x86/kernel/pci-gart_64.c                      |    4 +-
 block/bsg.c                                        |    3 +-
 block/genhd.c                                      |  205 +++---
 drivers/acpi/fan.c                                 |   10 +-
 drivers/acpi/glue.c                                |    6 +-
 drivers/acpi/processor_core.c                      |    5 +-
 drivers/acpi/scan.c                                |    2 +-
 drivers/acpi/thermal.c                             |    4 +-
 drivers/acpi/video.c                               |    5 +-
 drivers/base/Kconfig                               |    3 +-
 drivers/base/base.h                                |   27 +
 drivers/base/class.c                               |  153 +++--
 drivers/base/core.c                                |  196 ++++--
 drivers/base/cpu.c                                 |   10 +-
 drivers/base/memory.c                              |   12 +-
 drivers/base/node.c                                |   15 +-
 drivers/base/power/trace.c                         |    2 +-
 drivers/base/sys.c                                 |   64 ++-
 drivers/base/topology.c                            |   17 +-
 drivers/block/aoe/aoechr.c                         |    5 +-
 drivers/block/paride/pg.c                          |    5 +-
 drivers/block/paride/pt.c                          |   10 +-
 drivers/block/pktcdvd.c                            |    4 +-
 drivers/char/dsp56k.c                              |    3 +-
 drivers/char/ip2/ip2main.c                         |   12 +-
 drivers/char/ipmi/ipmi_devintf.c                   |    2 +-
 drivers/char/istallion.c                           |    5 +-
 drivers/char/lp.c                                  |    3 +-
 drivers/char/mem.c                                 |    6 +-
 drivers/char/misc.c                                |    4 +-
 drivers/char/pcmcia/cm4000_cs.c                    |    2 +-
 drivers/char/pcmcia/cm4040_cs.c                    |    3 +-
 drivers/char/ppdev.c                               |    5 +-
 drivers/char/raw.c                                 |    7 +-
 drivers/char/snsc.c                                |    3 +-
 drivers/char/stallion.c                            |    4 +-
 drivers/char/tty_io.c                              |   12 +-
 drivers/char/vc_screen.c                           |   12 +-
 drivers/char/viotape.c                             |    8 +-
 drivers/char/vt.c                                  |   14 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    5 +-
 drivers/cpuidle/sysfs.c                            |   10 +-
 drivers/dca/dca-sysfs.c                            |    8 +-
 drivers/eisa/Makefile                              |    2 +-
 drivers/eisa/eisa-bus.c                            |    4 +-
 drivers/hid/hidraw.c                               |    5 +-
 drivers/hwmon/hwmon.c                              |    3 +-
 drivers/i2c/i2c-core.c                             |    6 +-
 drivers/i2c/i2c-dev.c                              |    6 +-
 drivers/ide/ide-tape.c                             |   10 +-
 drivers/ieee1394/dv1394.c                          |    7 +-
 drivers/ieee1394/nodemgr.c                         |   23 +-
 drivers/ieee1394/raw1394.c                         |    4 +-
 drivers/ieee1394/video1394.c                       |    6 +-
 drivers/infiniband/core/cm.c                       |   72 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |    2 +-
 drivers/isdn/capi/capi.c                           |    3 +-
 drivers/macintosh/adb.c                            |    3 +-
 drivers/mca/mca-bus.c                              |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |    4 +-
 drivers/memstick/host/jmb38x_ms.c                  |    4 +-
 drivers/message/fusion/mptbase.c                   |    3 +-
 drivers/message/fusion/mptbase.h                   |    4 +-
 drivers/message/fusion/mptfc.c                     |    4 +-
 drivers/misc/Kconfig                               |   13 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/hpilo.c                               |  768 ++++++++++++++++++++
 drivers/misc/hpilo.h                               |  189 +++++
 drivers/misc/phantom.c                             |    5 +-
 drivers/mtd/devices/block2mtd.c                    |    8 +-
 drivers/mtd/mtdchar.c                              |    9 +-
 drivers/net/3c59x.c                                |    2 +-
 drivers/net/arm/at91_ether.c                       |    2 +-
 drivers/net/arm/ep93xx_eth.c                       |    2 +-
 drivers/net/arm/etherh.c                           |    6 +-
 drivers/net/ppp_generic.c                          |    3 +-
 drivers/net/wan/cosa.c                             |    6 +-
 drivers/pci/hotplug/acpiphp.h                      |    4 +-
 drivers/power/apm_power.c                          |    2 +-
 drivers/power/power_supply_core.c                  |    4 +-
 drivers/rtc/interface.c                            |    2 +-
 drivers/s390/char/raw3270.c                        |   14 +-
 drivers/s390/char/tape_class.c                     |    7 +-
 drivers/s390/char/vmur.c                           |    5 +-
 drivers/sbus/sbus.c                                |    6 +-
 drivers/scsi/dpt_i2o.c                             |    4 +-
 drivers/scsi/hosts.c                               |    7 +-
 drivers/scsi/scsi_transport_fc.c                   |    9 +-
 drivers/scsi/scsi_transport_iscsi.c                |    8 +-
 drivers/spi/spi.c                                  |    2 +-
 drivers/spi/spidev.c                               |    4 +-
 drivers/uio/Kconfig                                |   10 +-
 drivers/uio/Makefile                               |    1 +
 drivers/uio/uio.c                                  |   26 +
 drivers/uio/uio_pdrv.c                             |  118 +++
 drivers/usb/core/devio.c                           |   11 +-
 drivers/usb/core/file.c                            |    5 +-
 drivers/usb/gadget/printer.c                       |    4 +-
 drivers/usb/mon/mon_bin.c                          |    5 +-
 drivers/video/aty/aty128fb.c                       |    2 +-
 drivers/video/aty/radeonfb.h                       |    2 +-
 drivers/video/console/fbcon.c                      |    3 +-
 drivers/video/fbmem.c                              |    5 +-
 drivers/xen/balloon.c                              |    1 +
 fs/coda/psdev.c                                    |    5 +-
 fs/debugfs/inode.c                                 |  114 +++-
 fs/partitions/check.c                              |    2 +-
 fs/sysfs/dir.c                                     |   37 +-
 fs/sysfs/file.c                                    |    5 +-
 fs/sysfs/symlink.c                                 |   41 +-
 fs/sysfs/sysfs.h                                   |    1 +
 include/linux/debugfs.h                            |    4 +
 include/linux/device.h                             |   58 +-
 include/linux/eisa.h                               |    2 +-
 include/linux/kobject.h                            |    3 +-
 include/linux/mtd/map.h                            |    2 +-
 include/linux/mtd/mtd.h                            |    2 +-
 include/linux/spi/spi.h                            |    2 +-
 include/linux/sysdev.h                             |   39 +-
 include/linux/sysfs.h                              |   10 +
 include/linux/uio_driver.h                         |    8 +-
 include/scsi/scsi_host.h                           |    2 +-
 include/scsi/scsi_transport_fc.h                   |    4 +-
 include/scsi/scsi_transport_iscsi.h                |    2 +-
 kernel/rtmutex-tester.c                            |    7 +-
 kernel/sched.c                                     |    8 +-
 kernel/time/clocksource.c                          |    8 +-
 lib/Kconfig.debug                                  |    3 +
 lib/kobject.c                                      |   10 +-
 lib/kobject_uevent.c                               |    3 +-
 net/bluetooth/hci_sysfs.c                          |    7 -
 .../firmware_sample_firmware_class.c               |    2 +-
 samples/kobject/kset-example.c                     |    2 +-
 scripts/mod/file2alias.c                           |   24 +-
 sound/core/init.c                                  |    5 +-
 sound/oss/soundcard.c                              |   14 +-
 sound/sound_core.c                                 |    5 +-
 173 files changed, 2508 insertions(+), 751 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-dev
 create mode 100644 drivers/misc/hpilo.c
 create mode 100644 drivers/misc/hpilo.h
 create mode 100644 drivers/uio/uio_pdrv.c

---------------

Adrian Bunk (1):
      always enable FW_LOADER unless EMBEDDED=y

Andi Kleen (3):
      sysdev: Pass the attribute to the low level sysdev show/store function
      sysdev: Add utility functions for simple int/ulong variable sysdev attributes
      sysdev: Convert the x86 mce tolerant sysdev attribute to generic attribute

Ben Dooks (1):
      sysdev: fix debugging statements in registration code.

Cornelia Huck (1):
      driver core: Suppress sysfs warnings for device_rename().

Dan Williams (1):
      sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor

Dave Young (1):
      class: change internal semaphore to a mutex

David Altobelli (1):
      HP iLO driver

David Brownell (1):
      device create: spi: convert device_create to device_create_drvdata

Greg Kroah-Hartman (48):
      Firmware: fix typo in example code
      device create: block: convert device_create to device_create_drvdata
      device create: char: convert device_create to device_create_drvdata
      device create: coda: convert device_create to device_create_drvdata
      device create: dca: convert device_create to device_create_drvdata
      device create: dvb: convert device_create to device_create_drvdata
      device create: framebuffer: convert device_create to device_create_drvdata
      device create: hid: convert device_create to device_create_drvdata
      device create: hwmon: convert device_create to device_create_drvdata
      device create: i2c: convert device_create to device_create_drvdata
      device create: ide: convert device_create to device_create_drvdata
      device create: ieee1394: convert device_create to device_create_drvdata
      device create: infiniband: convert device_create to device_create_drvdata
      device create: isdn: convert device_create to device_create_drvdata
      device create: macintosh: convert device_create to device_create_drvdata
      device create: mips: convert device_create to device_create_drvdata
      device create: misc: convert device_create to device_create_drvdata
      device create: mtd: convert device_create to device_create_drvdata
      device create: net: convert device_create to device_create_drvdata
      device create: s390: convert device_create to device_create_drvdata
      device create: scsi: convert device_create to device_create_drvdata
      device create: sound: convert device_create to device_create_drvdata
      device create: usb: convert device_create to device_create_drvdata
      device create: x86: convert device_create to device_create_drvdata
      driver core: remove device_create()
      device create: convert device_create_drvdata to device_create
      Driver Core: add ability for class_for_each_device to start in middle of list
      Driver Core: add ability for class_find_device to start in middle of list
      block: fix compiler warning in genhd.c
      block: make printk_partition use the class iterator function
      block: make blk_lookup_devt use the class iterator function
      block: make proc files seq_start use the class_find_device()
      block: move header for /proc/partitions to seq_start
      block: make /proc/partitions and /proc/diskstats use class_find_device()
      infiniband: rename "device" to "ib_device" in cm_device
      infiniband: make cm_device use a struct device and not a kobject.
      bluetooth: remove improper bluetooth class symlinks.
      class: move driver core specific parts to a private structure
      class: rename "devices" to "class_devices" in internal class structure
      class: rename "interfaces" to "class_interfaces" in internal class structure
      class: rename "subsys" to "class_subsys" in internal class structure
      class: rename "sem" to "class_sem" in internal class structure
      class: fix docbook comments for class_private structure
      driver core: remove DEVICE_ID_SIZE define
      driver core: fix a lot of printk usages of bus_id
      MTD: handle pci_name() being const
      3c59x: handle pci_name() being const
      sparc64: fix up bus_id changes in sparc core code

Haavard Skinnemoen (1):
      debugfs: Implement debugfs_remove_recursive()

Hans J. Koch (1):
      UIO: Add write function to allow irq masking

Kay Sievers (5):
      kobject: replace '/' with '!' in name
      driver core: remove KOBJ_NAME_LEN define
      driver core: remove DEVICE_NAME_SIZE define
      pnp: add acpi:* modalias entries
      arm: bus_id -> dev_name() and dev_set_name() conversions

Li Zefan (1):
      kobject: should use kobject_put() in kset-example

Matthew Wilcox (1):
      class: add lockdep infrastructure

Mike Frysinger (2):
      uio-howto.tmpl: use standard copyright/legal markings
      uio-howto.tmpl: use unique output names

Miklos Szeredi (1):
      sysfs: don't call notify_change

Nathan Lynch (1):
      sysfs-rules.txt: reword API stability statement

Randy Dunlap (1):
      block: make /proc/diskstats only build if CONFIG_PROC_FS is enabled

Richard Kennedy (1):
      kobject: reorder kobject to save space on 64 bit builds

Robert P. J. Day (1):
      debugfs: Add a reference to the debugfs API documentation.

Tsugikazu Shibata (1):
      HOWTO: change email addresses of James in HOWTO

Uwe Kleine-König (3):
      UIO: fix UIO Kconfig dependencies
      UIO: add generic UIO platform driver
      UIO: minor style and comment fixes

Wang Chen (1):
      kobject: Transmit return value of call_usermodehelper() to caller

