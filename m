Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZFPFSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZFPFSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZFPFR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:17:57 -0400
Received: from kroah.org ([198.145.64.141]:34228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZFPFR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:17:56 -0400
Date: Mon, 15 Jun 2009 22:13:51 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.30-git
Message-ID: <20090616051351.GA23627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big patch series for the driver core for your tree.

It's just lots of little things, cleanups of apis, and documentation,
and other minor stuff.  Most of the cleanups are being done for future
changes to the driver core, to prevent us from having to touch code
outside of it.

There are also some debugfs updates as well.

All of the non-driver-core touching patches have been sent to the
various subsystem maintainers and gotten acks for them.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/DocBook/debugobjects.tmpl            |    2 +-
 Documentation/cdrom/packet-writing.txt             |    2 +-
 Documentation/driver-model/device.txt              |   32 +++
 Documentation/fault-injection/fault-injection.txt  |   70 +++---
 Documentation/firmware_class/README                |    3 +-
 Documentation/kprobes.txt                          |    6 +-
 Documentation/trace/ftrace.txt                     |  233 ++++++++++++--------
 Documentation/trace/mmiotrace.txt                  |   26 +-
 arch/mips/sni/eisa.c                               |    2 +-
 arch/um/drivers/net_kern.c                         |    4 +-
 arch/um/drivers/ubd_kern.c                         |    4 +-
 arch/x86/kernel/cpuid.c                            |    6 +
 arch/x86/kernel/microcode_core.c                   |    1 +
 arch/x86/kernel/msr.c                              |    6 +
 block/bsg.c                                        |    6 +
 block/genhd.c                                      |   10 +
 drivers/base/core.c                                |   57 +++++-
 drivers/base/dd.c                                  |    6 +-
 drivers/base/firmware_class.c                      |   27 ++-
 drivers/base/platform.c                            |    7 +-
 drivers/base/sys.c                                 |    8 +-
 drivers/block/aoe/aoechr.c                         |    7 +
 drivers/block/pktcdvd.c                            |    9 +-
 drivers/block/ps3disk.c                            |   18 +-
 drivers/block/ps3vram.c                            |   46 ++--
 drivers/block/xen-blkfront.c                       |   14 +-
 drivers/char/hvcs.c                                |    6 +-
 drivers/char/hw_random/core.c                      |    1 +
 drivers/char/ipmi/ipmi_si_intf.c                   |    4 +-
 drivers/char/misc.c                                |   15 +-
 drivers/char/raw.c                                 |    6 +
 drivers/eisa/pci_eisa.c                            |    2 +-
 drivers/eisa/virtual_root.c                        |    2 +-
 drivers/firewire/fw-sbp2.c                         |    6 +-
 drivers/gpu/drm/drm_debugfs.c                      |   12 +-
 drivers/gpu/drm/drm_drv.c                          |    2 +-
 drivers/gpu/drm/drm_stub.c                         |    2 +-
 drivers/gpu/drm/drm_sysfs.c                        |    7 +
 drivers/hid/usbhid/hiddev.c                        |    7 +-
 drivers/ide/ide-pm.c                               |    6 +-
 drivers/ide/ide-probe.c                            |    4 +-
 drivers/ide/ide_platform.c                         |    2 +-
 drivers/ieee1394/eth1394.c                         |   16 +-
 drivers/ieee1394/sbp2.c                            |    8 +-
 drivers/infiniband/core/sysfs.c                    |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    8 +-
 drivers/input/input.c                              |    6 +
 drivers/input/touchscreen/wm97xx-core.c            |    2 +-
 drivers/input/xen-kbdfront.c                       |    8 +-
 drivers/md/dm-ioctl.c                              |    1 +
 drivers/media/common/tuners/tuner-xc2028.c         |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |   10 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/dvb/firewire/firedtv-1394.c          |    4 +-
 drivers/media/dvb/firewire/firedtv-dvb.c           |    2 +-
 drivers/media/video/dabusb.c                       |    6 +
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   22 +-
 drivers/mfd/htc-pasic3.c                           |    4 +-
 drivers/mfd/pcf50633-core.c                        |    2 +-
 drivers/mfd/wm8400-core.c                          |    2 +-
 drivers/net/Kconfig                                |    4 +-
 drivers/net/tun.c                                  |    1 +
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wireless/ath/ath5k/Kconfig             |    5 +-
 drivers/net/wireless/libertas/README               |   12 +-
 drivers/net/wireless/libertas/if_spi.c             |    8 +-
 drivers/net/wireless/libertas/if_spi.h             |    3 +
 drivers/net/wireless/libertas/if_usb.c             |    8 +-
 drivers/net/xen-netfront.c                         |   10 +-
 drivers/parisc/eisa.c                              |    2 +-
 drivers/parisc/sba_iommu.c                         |    6 +-
 drivers/parport/parport_gsc.c                      |    4 +-
 drivers/pci/pcie/portdrv_core.c                    |    2 +-
 drivers/pcmcia/ds.c                                |   20 +--
 drivers/s390/char/con3215.c                        |   16 +-
 drivers/s390/char/raw3270.c                        |   16 +-
 drivers/s390/char/tape_34xx.c                      |    2 +-
 drivers/s390/char/tape_3590.c                      |    2 +-
 drivers/s390/char/tape_core.c                      |   22 +-
 drivers/s390/char/vmlogrdr.c                       |   12 +-
 drivers/s390/char/vmur.c                           |   16 +-
 drivers/s390/net/claw.c                            |   52 +++---
 drivers/s390/net/lcs.c                             |   20 +-
 drivers/s390/net/lcs.h                             |    4 +-
 drivers/s390/net/netiucv.c                         |   47 ++--
 drivers/scsi/aha1740.c                             |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |    6 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c                   |    2 +-
 drivers/scsi/libsrp.c                              |    2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    3 +-
 drivers/serial/of_serial.c                         |    4 +-
 drivers/thermal/thermal_sys.c                      |    4 +-
 drivers/usb/atm/ueagle-atm.c                       |    9 +-
 drivers/usb/class/usblp.c                          |    6 +
 drivers/usb/core/file.c                            |   13 +-
 drivers/usb/core/usb.c                             |   11 +
 drivers/usb/gadget/at91_udc.c                      |    6 +-
 drivers/usb/misc/iowarrior.c                       |    6 +
 drivers/usb/misc/legousbtower.c                    |    6 +
 drivers/video/xen-fbfront.c                        |    8 +-
 fs/debugfs/file.c                                  |   65 ++++++-
 fs/debugfs/inode.c                                 |   11 +
 fs/sysfs/symlink.c                                 |    5 +-
 include/linux/device.h                             |    5 +
 include/linux/eisa.h                               |    4 +-
 include/linux/firmware.h                           |    1 -
 include/linux/genhd.h                              |    2 +-
 include/linux/kernel.h                             |    2 +-
 include/linux/miscdevice.h                         |    1 +
 include/linux/platform_device.h                    |    4 +-
 include/linux/sched.h                              |    2 +-
 include/linux/tracepoint.h                         |    4 +-
 include/linux/usb.h                                |    3 +
 init/Kconfig                                       |    6 +-
 kernel/trace/Kconfig                               |   10 +-
 kernel/trace/trace.c                               |   23 +-
 kernel/user.c                                      |   67 ++++---
 lib/kobject.c                                      |    7 +-
 samples/Kconfig                                    |    3 +-
 samples/firmware_class/firmware_sample_driver.c    |  121 ----------
 .../firmware_sample_firmware_class.c               |  204 -----------------
 scripts/tracing/draw_functrace.py                  |    7 +-
 sound/sound_core.c                                 |    7 +
 123 files changed, 907 insertions(+), 844 deletions(-)
 delete mode 100644 samples/firmware_class/firmware_sample_driver.c
 delete mode 100644 samples/firmware_class/firmware_sample_firmware_class.c

---------------

Armin Kuster (1):
      Sysfs: fix possible memleak in sysfs_follow_link

Dave Young (2):
      kobject: make kset_create check kobject_set_name return value
      driver-core: make sysdev_class_register check kobject_set_name return value

Dmitry Torokhov (1):
      Driver core: fix comment for device_attach()

GeunSik Lim (1):
      debugfs: Fix terminology inconsistency of dir name to mount debugfs filesystem.

Grant Likely (1):
      Driver Core: Warn driver authors about adding device attributes

Greg Kroah-Hartman (27):
      firmware: remove broken example files
      driver core: fix gcc 4.3.3 warnings about string literals
      eisa: remove driver_data direct access of struct device
      firewire: remove driver_data direct access of struct device
      ide: remove driver_data direct access of struct device
      ieee1394: remove driver_data direct access of struct device
      infiniband: remove driver_data direct access of struct device
      input: remove driver_data direct access of struct device
      media: remove driver_data direct access of struct device
      mfd: remove driver_data direct access of struct device
      PCIE: remove driver_data direct access of struct device
      pcmcia: remove driver_data direct access of struct device
      scsi: remove driver_data direct access of struct device
      thermal: remove driver_data direct access of struct device
      xen block: remove driver_data direct access of struct device
      hvcs: remove driver_data direct access of struct device
      ibmvscsi: gadget: at91_udc: remove driver_data direct access of struct device
      infiniband: ehca: remove driver_data direct access of struct device
      ipmi: remove driver_data direct access of struct device
      mips: remove driver_data direct access of struct device
      of_serial: remove driver_data direct access of struct device
      parisc: remove driver_data direct access of struct device
      parport: remove driver_data direct access of struct device
      s390: remove driver_data direct access of struct device
      uml: remove driver_data direct access of struct device
      usb: gadget: at91_udc: remove driver_data direct access of struct device
      xen: remove driver_data direct access of struct device from more drivers

Joerg Roedel (1):
      driver core: add BUS_NOTIFY_UNBOUND_DRIVER event

John W. Linville (1):
      firmware: wireless/libertas: prepare for FIRMWARE_NAME_MAX removal

Jonathan Corbet (1):
      debugfs: fix docbook error

Kay Sievers (14):
      driver core: set default SYSFS_DEPRECATED=n
      sched: delayed cleanup of user_struct
      Driver Core: add nodename callbacks
      Driver Core: misc: add nodename support for misc devices.
      Driver Core: usb: add nodename support for usb drivers.
      Driver Core: block: add nodename support for block drivers.
      Driver Core: x86: add nodename for cpuid and msr drivers.
      Driver Core: dvb: add nodename for dvb drivers
      Driver Core: input: add nodename for input drivers
      Driver Core: sound: add nodename for sound drivers
      Driver Core: raw: add nodename for raw devices
      Driver Core: drm: add nodename for drm devices
      Driver Core: aoe: add nodename for aoe devices
      Driver Core: bsg: add nodename for bsg driver

Linus Walleij (1):
      driver core: Const-correct platform getbyname functions

Michal Marek (1):
      kobject: samples: make SAMPLE_KOBJECT module-only

Ming Lei (2):
      driver core: firmware_class: replace kfree(dev) with put_device(dev)
      driver core: fix documentation of request_firmware_nowait

Robin Getz (1):
      debugfs: use specified mode to possibly mark files read/write only

Roel Kluin (1):
      block/ps3: remove driver_data direct access of struct device

Samuel Ortiz (6):
      firmware: allocate firmware id dynamically
      firmware: atm/ueagle-atm: prepare for FIRMWARE_NAME_MAX removal
      firmware: tuners/xc2028: prepare for FIRMWARE_NAME_MAX removal
      firmware: dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
      firmware: pcmcia/ds: prepare for FIRMWARE_NAME_MAX removal
      firmware: FIRMWARE_NAME_MAX removal

Shaohua Li (1):
      driver core: synchronize device shutdown

Steven Rostedt (1):
      debugfs: dont stop on first failed recursive delete

