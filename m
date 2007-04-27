Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbXD0Szo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbXD0Szo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXD0Syl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:54:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52430 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbXD0SyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:54:15 -0400
Date: Fri, 27 Apr 2007 11:51:52 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 2.6.21
Message-ID: <20070427185152.GA17121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core patche for 2.6.21.

They do a wide range of things, see the shortlog below for details.

All of these have been in the -mm tree for quite some time.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/feature-removal-schedule.txt |    9 -
 arch/powerpc/kernel/of_platform.c          |    3 -
 drivers/amba/bus.c                         |   13 +-
 drivers/base/attribute_container.c         |   26 ++--
 drivers/base/base.h                        |    2 +-
 drivers/base/bus.c                         |  112 +++++++++--
 drivers/base/class.c                       |    2 +-
 drivers/base/core.c                        |  293 ++++++++++++++++++++--------
 drivers/base/dd.c                          |   66 ++++---
 drivers/base/dmapool.c                     |   14 +-
 drivers/base/driver.c                      |   20 --
 drivers/base/firmware_class.c              |   10 +-
 drivers/base/power/main.c                  |    3 +
 drivers/base/power/resume.c                |   13 ++-
 drivers/base/power/shutdown.c              |    2 -
 drivers/base/power/suspend.c               |   12 ++
 drivers/ide/ide-proc.c                     |    4 -
 drivers/ieee1394/nodemgr.c                 |   22 +--
 drivers/input/gameport/gameport.c          |   39 ++---
 drivers/input/serio/serio.c                |   41 ++---
 drivers/mmc/mmc_sysfs.c                    |   27 +--
 drivers/net/phy/fixed.c                    |    6 -
 drivers/net/phy/phy_device.c               |    9 +-
 drivers/pci/pci-driver.c                   |    6 +-
 drivers/pci/pci.c                          |   58 ++++--
 drivers/pnp/card.c                         |    6 -
 drivers/s390/cio/device.c                  |    6 +
 drivers/s390/crypto/ap_bus.c               |   28 ++--
 drivers/s390/net/qeth_proc.c               |    2 -
 drivers/scsi/hosts.c                       |    4 +-
 drivers/usb/core/devices.c                 |    2 -
 drivers/usb/core/devio.c                   |   13 --
 drivers/usb/core/driver.c                  |   12 +-
 drivers/usb/core/hub.c                     |    4 +-
 drivers/usb/core/message.c                 |    2 +-
 drivers/usb/host/ohci-hcd.c                |    6 -
 fs/debugfs/file.c                          |   42 ++++
 fs/namei.c                                 |   72 +++++--
 fs/super.c                                 |   12 --
 fs/sysfs/bin.c                             |    2 +-
 fs/sysfs/file.c                            |   14 +-
 fs/sysfs/group.c                           |    6 +-
 include/linux/debugfs.h                    |    9 +
 include/linux/device.h                     |   69 +++++---
 include/linux/kobject.h                    |   12 +-
 include/linux/namei.h                      |    1 +
 include/linux/pci.h                        |    2 -
 include/linux/pm.h                         |   37 ++++
 include/linux/sysfs.h                      |    4 +-
 kernel/module.c                            |    4 +-
 kernel/power/main.c                        |   18 ++-
 lib/kobject.c                              |   62 +++++-
 lib/kobject_uevent.c                       |   26 ++--
 lib/kref.c                                 |    2 +
 net/core/net-sysfs.c                       |   27 ++-
 sound/aoa/soundbus/core.c                  |   80 +++-----
 56 files changed, 854 insertions(+), 544 deletions(-)

---------------

Adrian Bunk (1):
      the overdue removal of the mount/umount uevents

Akinobu Mita (1):
      mod_sysfs_setup() doesn't return errno when kobject_add_dir() failure occurs

Alan Stern (1):
      device_schedule_callback() needs a module reference

Andrew Morton (2):
      powerpc: make it compile for multithread change
      sysfs: bin.c printk fix

Cornelia Huck (7):
      driver core: per-subsystem multithreaded probing
      driver core: don't fail attaching the device if it cannot be bound
      Driver core: suppress uevents via filter
      Driver core: switch firmware_class to uevent_suppress.
      kobject: kobject_add() reference leak
      qeth: Remove usage of subsys.rwsem
      s390: cio: Delay uevents for subchannels

Dan Williams (1):
      dev_dbg: check dev_dbg() arguments

David Brownell (1):
      define platform wakeup hook, use in pci_enable_wake()

Dmitriy Monakhov (2):
      driver core: fix device_add error path
      kobject: kobject_shadow_add cleanup

Dmitry Torokhov (4):
      driver core: Use attribute groups in struct device_type
      Driver core: add suspend() and resume() to struct device_type
      Input: serio - do not touch bus's rwsem
      Input: gameport - do not touch bus's rwsem

Eric Rannaud (1):
      uevent: use add_uevent_var() instead of open coding it

Eric W. Biederman (1):
      kobject: Comment and warning fixes to kobject.c

Greg Kroah-Hartman (10):
      Driver core: remove unneeded completion from driver release path
      Driver core: remove use of rwsem
      SCSI: use the proper semaphore to protect the class lists
      USB: remove use of the bus rwsem, as it doesn't really protect anything.
      PNP: stop using the subsystem rwsem
      IDE: remove rwsem use from ide-proc core
      IEEE1394: remove rwsem use from ieee1394 core
      PHY: remove rwsem use from phy core
      kobject core: remove rwsem from struct subsystem
      driver core: bus_add_driver should return an error if no bus

James Morris (1):
      security: prevent permission checking of file removal via sysfs_remove_group()

Jean Delvare (1):
      dev_printk and new-style class devices

Jean Tourrilhes (1):
      Driver core: notify userspace of network device renames

Johannes Berg (1):
      s2ram: add arch irq disable/enable hooks

John Anthony Kazos Jr (1):
      Kobject: kobject_uevent.c: Collapse unnecessary loop nesting (top_kobj)

Kay Sievers (5):
      driver core: fix namespace issue with devices assigned to classes
      Driver core: udev triggered device-<>driver binding
      Driver core: add name to device_type
      Driver core: make uevent-environment available in uevent-file
      Driver core: warn when userspace writes to the uevent file in a non-supported way

Matthias Kaehlcke (2):
      Driver core: use mutex instead of semaphore in DMA pool handler
      drivers/base/attribute_container.c: use mutex instead of binary semaphore

Michael Ellerman (1):
      debugfs: Add debugfs_create_u64()

Oliver Neukum (1):
      kref: fix CPU ordering with respect to krefs

