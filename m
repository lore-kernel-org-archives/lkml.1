Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbXJLWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbXJLWe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXJLWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbXJLWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:52 -0400
Date: Fri, 12 Oct 2007 15:12:51 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.23
Message-ID: <20071012221251.GB4559@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are lot of driver core patches, tweaks, fixes and documentation updates
against your 2.6.23 git tree.

They do loads of different things, see my summary last week for details,
and the shortlog below for a short summary.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

All of these patches have been in the past few -mm releases with no
problems.

Patches will be sent as a follow-on to this message to lkml for people
to see.

As a bonus, we removed more code than we added overall :)

thanks,

greg k-h


 Documentation/ja_JP/HOWTO                   |   84 ++--
 Documentation/kernel-parameters.txt         |    4 +
 Documentation/kobject.txt                   |   22 +-
 arch/ia64/sn/kernel/tiocx.c                 |    3 +-
 arch/powerpc/kernel/of_device.c             |   37 +-
 arch/powerpc/kernel/vio.c                   |   16 +-
 arch/powerpc/platforms/ps3/system-bus.c     |    9 +-
 block/bsg.c                                 |    5 +-
 block/elevator.c                            |    2 +-
 block/genhd.c                               |   35 +-
 block/ll_rw_blk.c                           |    2 +-
 drivers/acpi/bus.c                          |    2 +-
 drivers/acpi/scan.c                         |   16 +-
 drivers/acpi/video.c                        |    4 +-
 drivers/amba/bus.c                          |    9 +-
 drivers/base/Kconfig                        |    8 +
 drivers/base/base.h                         |    2 -
 drivers/base/bus.c                          |  116 +++--
 drivers/base/class.c                        |   60 +--
 drivers/base/core.c                         |  108 ++---
 drivers/base/firmware_class.c               |   14 +-
 drivers/base/memory.c                       |    3 +-
 drivers/base/platform.c                     |   26 +-
 drivers/base/power/Makefile                 |    2 +-
 drivers/base/power/main.c                   |  344 ++++++++++++-
 drivers/base/power/power.h                  |   38 +--
 drivers/base/power/resume.c                 |  149 ------
 drivers/base/power/suspend.c                |  210 --------
 drivers/base/sys.c                          |   73 +--
 drivers/char/dsp56k.c                       |    4 +-
 drivers/char/ip2/ip2main.c                  |   12 +-
 drivers/char/ipmi/ipmi_devintf.c            |    6 +-
 drivers/char/istallion.c                    |    8 +-
 drivers/char/lp.c                           |    5 +-
 drivers/char/pcmcia/cm4000_cs.c             |    5 +-
 drivers/char/pcmcia/cm4040_cs.c             |    5 +-
 drivers/char/pty.c                          |    9 +-
 drivers/char/raw.c                          |    5 +-
 drivers/char/snsc.c                         |    3 +-
 drivers/char/stallion.c                     |    7 +-
 drivers/char/tipar.c                        |    6 +-
 drivers/char/viotape.c                      |   10 +-
 drivers/cpufreq/cpufreq.c                   |    2 +-
 drivers/edac/edac_mc_sysfs.c                |    3 +-
 drivers/eisa/eisa-bus.c                     |    9 +-
 drivers/firewire/fw-device.c                |   11 +-
 drivers/firmware/dmi-id.c                   |   62 ++-
 drivers/firmware/edd.c                      |    4 +-
 drivers/firmware/efivars.c                  |    4 +-
 drivers/i2c/i2c-core.c                      |    8 +-
 drivers/ide/ide.c                           |   17 +-
 drivers/ieee1394/nodemgr.c                  |   17 +-
 drivers/infiniband/core/sysfs.c             |    9 +-
 drivers/input/input.c                       |   62 +--
 drivers/input/misc/pcspkr.c                 |    1 +
 drivers/input/serio/serio.c                 |   11 +-
 drivers/md/md.c                             |    3 +-
 drivers/media/dvb/dvb-core/dvbdev.c         |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    4 +-
 drivers/misc/tifm_core.c                    |    9 +-
 drivers/mmc/core/bus.c                      |   21 +-
 drivers/net/ibmveth.c                       |    2 +-
 drivers/pci/hotplug.c                       |   28 +-
 drivers/pci/hotplug/pci_hotplug_core.c      |   60 ---
 drivers/pci/hotplug/rpadlpar_sysfs.c        |    6 +-
 drivers/pci/pci-driver.c                    |    3 +-
 drivers/pci/pci.h                           |    3 +-
 drivers/pci/setup-irq.c                     |    2 +-
 drivers/pcmcia/cs.c                         |   10 +-
 drivers/pcmcia/ds.c                         |   26 +-
 drivers/pcmcia/pxa2xx_mainstone.c           |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c             |    2 +-
 drivers/power/power_supply.h                |    3 +-
 drivers/power/power_supply_sysfs.c          |   17 +-
 drivers/s390/cio/ccwgroup.c                 |    3 +-
 drivers/s390/cio/device.c                   |   25 +-
 drivers/s390/crypto/ap_bus.c                |   14 +-
 drivers/scsi/scsi_sysfs.c                   |    9 +-
 drivers/spi/spi.c                           |    7 +-
 drivers/usb/core/devio.c                    |    6 +-
 drivers/usb/core/driver.c                   |   29 +-
 drivers/usb/core/message.c                  |   28 +-
 drivers/video/output.c                      |   29 +-
 drivers/w1/w1.c                             |   19 +-
 fs/debugfs/file.c                           |   36 ++
 fs/dlm/lockspace.c                          |    2 +-
 fs/gfs2/locking/dlm/sysfs.c                 |    2 +-
 fs/gfs2/sys.c                               |    2 +-
 fs/ocfs2/cluster/masklog.c                  |    3 +-
 fs/partitions/check.c                       |   12 +-
 fs/sysfs/bin.c                              |   36 +-
 fs/sysfs/dir.c                              |  754 +++++++--------------------
 fs/sysfs/file.c                             |  248 ++++++---
 fs/sysfs/group.c                            |    2 -
 fs/sysfs/inode.c                            |  103 ++--
 fs/sysfs/mount.c                            |   26 +-
 fs/sysfs/symlink.c                          |   34 +-
 fs/sysfs/sysfs.h                            |  184 ++++---
 include/asm-powerpc/of_device.h             |    2 +-
 include/linux/debugfs.h                     |   27 +
 include/linux/device.h                      |   17 +-
 include/linux/kobject.h                     |  125 ++---
 include/linux/platform_device.h             |    7 +-
 include/linux/sysfs.h                       |  147 ++----
 include/linux/tty.h                         |    1 -
 include/linux/video_output.h                |    4 +-
 lib/Makefile                                |    3 +-
 lib/kobject.c                               |  135 ++---
 lib/kobject_uevent.c                        |  216 ++++----
 net/atm/atm_sysfs.c                         |    7 +-
 net/bridge/br_sysfs_br.c                    |    2 +-
 net/core/net-sysfs.c                        |   14 +-
 net/wireless/sysfs.c                        |    3 +-
 sound/aoa/soundbus/core.c                   |   33 +-
 114 files changed, 1777 insertions(+), 2493 deletions(-)
 delete mode 100644 drivers/base/power/resume.c
 delete mode 100644 drivers/base/power/suspend.c

---------------

Adrian Bunk (1):
      drivers/base/power/: make 2 functions static

Akinobu Mita (1):
      sysdev: remove global sysdev drivers list

Alan Stern (1):
      PM: merge device power-management source files

Cornelia Huck (1):
      Driver core: clean up removed functions from the documentation

Dave Young (2):
      sysfs/file.c - use mutex instead of semaphore
      sysfs: cleanup semaphore.h

Eric W. Biederman (12):
      sysfs: Remove first pass at shadow directory support
      sysfs: Move all of inode initialization into sysfs_init_inode
      sysfs: Remove sysfs_instantiate
      sysfs: Use kill_anon_super
      sysfs: Make sysfs_mount static
      sysfs: In sysfs_lookup don't open code sysfs_find_dirent
      sysfs: Simplify readdir.
      sysfs: Rewrite sysfs_drop_dentry.
      sysfs: Introduce sysfs_rename_mutex
      sysfs: Remove s_dentry
      sysfs: Rewrite rename in terms of sysfs dirents
      sysfs: Rewrite sysfs_move_dir in terms of sysfs dirents

Greg Kroah-Hartman (18):
      Driver core: remove subsys_set_kset
      Driver core: remove kset_set_kset_s
      Driver core: remove subsys_put()
      Driver core: remove subsys_get()
      Driver core: remove put_bus()
      Driver core: remove get_bus()
      kobjects: fix up improper use of the kobject name field
      cdev: remove unneeded setting of cdev names
      Drivers: clean up direct setting of the name of a kset
      kobject: remove the static array for the name
      sysfs: spit a warning to users when they try to create a duplicate sysfs file
      driver core: remove subsystem_init()
      Driver core: rename ktype_class
      Driver core: rename ktype_device
      Driver core: rename ktype_driver
      Driver core: rename ktype_edd and ktype_efivar
      kset: add some kerneldoc to help describe what these strange things are
      kobject: update the copyrights

Jean Delvare (3):
      dmi-id: Use dynamic sysfs attributes
      dmi-id: Possible cleanup
      Driver core: Make platform_device.id an int

Kay Sievers (8):
      platform: prefix MODALIAS with "platform:"
      Driver core: make sysfs uevent-attributes static
      Driver core: change add_uevent_var to use a struct
      Driver core: add CONFIG_UEVENT_HELPER_PATH
      Driver core: exclude kobject_uevent.c for !CONFIG_HOTPLUG
      Driver core: add uevent file for bus and driver
      Driver core: kerneldoc - kobject_uevent_env is not "usually KOBJ_MOVE"
      PTY: add kernel parameter to overwrite legacy pty count

Markus Rechberger (1):
      Fix Firmware class name collision

Robin Getz (1):
      debugfs: helper for decimal challenged

Rolf Eike Beer (1):
      sysfs: Fix typos in fs/sysfs/file.c

Tejun Heo (22):
      sysfs: cosmetic changes in sysfs_lookup()
      sysfs: simplify sysfs_rename_dir()
      sysfs: make sysfs_add/remove_one() call link/unlink_sibling() implictly
      sysfs: make sysfs_add_one() automatically check for duplicate entry
      sysfs: make sysfs_addrm_finish() return void
      sysfs: fix i_mutex locking in sysfs_get_dentry()
      sysfs: simply sysfs_get_dentry
      sysfs: fix comments of sysfs_add/remove_one()
      sysfs: fix sysfs_chmod_file() such that it updates sd->s_mode too
      sysfs: clean up header files
      sysfs: kill sysfs_update_file()
      sysfs: reposition sysfs_dirent->s_mode.
      sysfs: kill unnecessary sysfs_get() in open paths
      sysfs: kill unnecessary NULL pointer check in sysfs_release()
      sysfs: make bin attr open get active reference of parent too
      sysfs: make s_elem an anonymous union
      sysfs: open code sysfs_attach_dentry()
      sysfs: make sysfs_root a regular directory dirent
      sysfs: move sysfs_dirent->s_children into sysfs_dirent->s_dir
      sysfs: implement sysfs_open_dirent
      sysfs: move sysfs file poll implementation to sysfs_open_dirent
      sysfs: add copyrights

Tsugikazu Shibata (1):
      HOWTO: update ja_JP/HOWTO with latest changes

tonyj@suse.de (2):
      Convert from class_device to device for drivers/video
      Convert from class_device to device in drivers/char

