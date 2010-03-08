Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0CHOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:12:47 -0500
Received: from kroah.org ([198.145.64.141]:36240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0CHOMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:12:44 -0500
Date: Mon, 8 Mar 2010 06:12:34 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 2.6.33-git
Message-ID: <20100308141234.GA2911@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100302230933.GA32287@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 03:09:33PM -0800, Greg KH wrote:
> Here is the big driver core patchset for the 2.6.34 merge window.
> 
> The msi-laptop driver also got updates through this patch series, at the
> blessing of the maintainer of that driver.
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/
> 
> All of these patches have been in the linux-next and mm trees for a
> while.
> 
> The patches will be sent as a follow-on to this message to lkml for
> people to see.

I've now updated this series, fixing the 'default y' option for the
DEVTMPFS config options, and respun it on top of your tree as of a few
days ago.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The updated diffstat and shortlog is below.

thanks,

greg k-h

---------

 Documentation/HOWTO                       |  113 +++------
 Documentation/kobject.txt                 |    2 +-
 arch/arm/mach-pxa/corgi_ssp.c             |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c            |    2 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c   |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c     |    2 +-
 arch/ia64/kernel/topology.c               |    2 +-
 arch/mips/txx9/generic/7segled.c          |    5 +-
 arch/powerpc/kernel/cacheinfo.c           |    2 +-
 arch/s390/kernel/smp.c                    |   12 +-
 arch/s390/kernel/time.c                   |   49 +++-
 arch/sh/kernel/cpu/sh4/sq.c               |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |    2 +-
 block/blk-integrity.c                     |    2 +-
 block/blk-sysfs.c                         |    2 +-
 block/elevator.c                          |    2 +-
 drivers/acpi/system.c                     |    2 +
 drivers/auxdisplay/cfag12864bfb.c         |    2 +-
 drivers/base/Kconfig                      |   51 +++--
 drivers/base/bus.c                        |   26 +-
 drivers/base/class.c                      |   16 +-
 drivers/base/core.c                       |   46 ++--
 drivers/base/cpu.c                        |  105 ++++-----
 drivers/base/dd.c                         |   38 ++--
 drivers/base/devtmpfs.c                   |   13 +
 drivers/base/firmware_class.c             |   11 +-
 drivers/base/memory.c                     |   20 +-
 drivers/base/node.c                       |   81 +++----
 drivers/base/platform.c                   |   76 ++++++-
 drivers/base/power/main.c                 |   20 +-
 drivers/base/sys.c                        |   17 +-
 drivers/block/osdblk.c                    |   12 +-
 drivers/block/pktcdvd.c                   |   14 +-
 drivers/cpufreq/cpufreq.c                 |    2 +-
 drivers/cpuidle/sysfs.c                   |    8 +-
 drivers/dma/ioat/dma.c                    |    2 +-
 drivers/dma/ioat/dma.h                    |    2 +-
 drivers/edac/edac_device_sysfs.c          |    6 +-
 drivers/edac/edac_mc_sysfs.c              |    4 +-
 drivers/edac/edac_pci_sysfs.c             |    4 +-
 drivers/firewire/core-device.c            |    5 +-
 drivers/firmware/edd.c                    |    2 +-
 drivers/firmware/efivars.c                |    2 +-
 drivers/firmware/iscsi_ibft.c             |    2 +-
 drivers/firmware/memmap.c                 |    2 +-
 drivers/gpio/gpiolib.c                    |    8 +-
 drivers/gpu/drm/drm_sysfs.c               |   18 +-
 drivers/gpu/drm/ttm/ttm_bo.c              |    2 +-
 drivers/gpu/drm/ttm/ttm_memory.c          |    2 +-
 drivers/i2c/busses/i2c-omap.c             |    2 +-
 drivers/ieee1394/nodemgr.c                |    5 +-
 drivers/infiniband/core/cm.c              |    2 +-
 drivers/infiniband/core/sysfs.c           |    2 +-
 drivers/infiniband/core/ucm.c             |   13 +-
 drivers/infiniband/core/user_mad.c        |    9 +-
 drivers/infiniband/core/uverbs_main.c     |    9 +-
 drivers/macintosh/windfarm_core.c         |    1 +
 drivers/macintosh/windfarm_smu_controls.c |    1 +
 drivers/md/dm-sysfs.c                     |    2 +-
 drivers/md/md.c                           |    4 +-
 drivers/media/video/omap24xxcam.c         |    2 +-
 drivers/misc/phantom.c                    |   13 +-
 drivers/mtd/ubi/build.c                   |    3 +-
 drivers/net/bonding/bond_sysfs.c          |    5 +-
 drivers/net/ibmveth.c                     |    2 +-
 drivers/net/iseries_veth.c                |    4 +-
 drivers/parisc/pdc_stable.c               |    2 +-
 drivers/pci/bus.c                         |    4 +-
 drivers/pci/hotplug/fakephp.c             |    2 +-
 drivers/pci/pci-sysfs.c                   |    5 +
 drivers/pci/pci.c                         |    4 +-
 drivers/pci/slot.c                        |    2 +-
 drivers/pcmcia/ds.c                       |    8 +-
 drivers/platform/x86/Kconfig              |    1 +
 drivers/platform/x86/hp-wmi.c             |    4 +-
 drivers/platform/x86/msi-laptop.c         |  360 ++++++++++++++++++++++++++++-
 drivers/scsi/sgiwd93.c                    |    2 +-
 drivers/scsi/sni_53c710.c                 |    2 +-
 drivers/staging/asus_oled/asus_oled.c     |   13 +-
 drivers/uio/Kconfig                       |   24 +-
 drivers/uio/Makefile                      |    2 +-
 drivers/uio/uio.c                         |    4 +-
 drivers/uio/uio_netx.c                    |  172 ++++++++++++++
 drivers/uio/uio_smx.c                     |  140 -----------
 drivers/usb/core/driver.c                 |    4 +-
 drivers/uwb/driver.c                      |    5 +-
 drivers/uwb/umc-bus.c                     |    4 +-
 drivers/uwb/uwb-internal.h                |    4 +-
 drivers/uwb/wlp/sysfs.c                   |    3 +-
 drivers/video/acornfb.c                   |    2 +-
 drivers/video/arcfb.c                     |    2 +-
 drivers/video/cobalt_lcdfb.c              |    2 +-
 drivers/video/efifb.c                     |    2 +-
 drivers/video/epson1355fb.c               |    2 +-
 drivers/video/gbefb.c                     |    2 +-
 drivers/video/hgafb.c                     |    2 +-
 drivers/video/hitfb.c                     |    2 +-
 drivers/video/omap2/dss/manager.c         |    2 +-
 drivers/video/omap2/dss/overlay.c         |    2 +-
 drivers/video/q40fb.c                     |    2 +-
 drivers/video/s3c2410fb.c                 |    4 +-
 drivers/video/sa1100fb.c                  |    2 +-
 drivers/video/sgivwfb.c                   |    2 +-
 drivers/video/sh_mobile_lcdcfb.c          |    2 +-
 drivers/video/vesafb.c                    |    2 +-
 drivers/video/vfb.c                       |    2 +-
 drivers/video/vga16fb.c                   |    2 +-
 drivers/video/w100fb.c                    |    2 +-
 drivers/w1/masters/omap_hdq.c             |    4 +-
 drivers/xen/sys-hypervisor.c              |    2 +-
 fs/btrfs/sysfs.c                          |    4 +-
 fs/dlm/lockspace.c                        |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/gfs2/sys.c                             |    4 +-
 fs/ocfs2/cluster/masklog.c                |    2 +-
 fs/sysfs/bin.c                            |   50 ++--
 fs/sysfs/dir.c                            |  132 ++++++-----
 fs/sysfs/file.c                           |   47 +++-
 fs/sysfs/inode.c                          |   13 +-
 fs/sysfs/mount.c                          |    4 +-
 fs/sysfs/symlink.c                        |   38 +++
 fs/sysfs/sysfs.h                          |   17 +-
 include/linux/device.h                    |   40 +++-
 include/linux/kobject.h                   |   14 +-
 include/linux/platform_device.h           |    9 +-
 include/linux/sysdev.h                    |   21 ++-
 include/linux/sysfs.h                     |   61 +++++
 include/linux/usb.h                       |    6 +-
 kernel/module.c                           |    3 +
 kernel/params.c                           |    5 +-
 kernel/perf_event.c                       |   13 +-
 kernel/sched.c                            |    4 +
 lib/kobject.c                             |    6 +-
 lib/kobject_uevent.c                      |    2 +-
 mm/slub.c                                 |    4 +-
 net/bluetooth/l2cap.c                     |    4 +-
 net/bluetooth/rfcomm/core.c               |    4 +-
 net/bluetooth/rfcomm/sock.c               |    4 +-
 net/bluetooth/sco.c                       |    4 +-
 net/bridge/br_private.h                   |    2 +-
 net/bridge/br_sysfs_if.c                  |    2 +-
 samples/kobject/kobject-example.c         |    4 +-
 samples/kobject/kset-example.c            |    6 +-
 145 files changed, 1463 insertions(+), 793 deletions(-)
 create mode 100644 drivers/uio/uio_netx.c
 delete mode 100644 drivers/uio/uio_smx.c

---------------

Andi Kleen (12):
      sysdev: Pass attribute in sysdev_class attributes show/store
      sysdev: Convert node driver class attributes to be data driven
      sysdev: Convert cpu driver sysdev class attributes
      sysfs: Add sysfs_add/remove_files utility functions
      sysfs: Add attribute array to sysdev classes
      sysdev: Convert node driver
      sysdev: Use sysdev_class attribute arrays in node driver
      sysdev: Add sysdev_create/remove_files
      sysdev: Fix type of sysdev class attribute in memory driver
      driver-core: Add attribute argument to class_attribute show/store
      driver core: Add class_attr_string for simple read-only string
      driver core: Convert some drivers to CLASS_ATTR_STRING

Ben Hutchings (1):
      Driver core: Fix first line of kernel-doc for a few functions

Dmitry Torokhov (1):
      Driver core: add platform_create_bundle() helper

Emese Revfy (2):
      kobject: Constify struct kset_uevent_ops
      Driver core: Constify struct sysfs_ops in struct kobj_type

Eric Miao (1):
      driver core: make platform_device_id table const

Eric W. Biederman (13):
      sysfs: Cache the last sysfs_dirent to improve readdir scalability v2
      sysfs: Remove sysfs_get/put_active_two
      sysfs: Only take active references on attributes.
      sysfs: Use one lockdep class per sysfs attribute.
      sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on dynamic attributes
      sysfs: Document sysfs_attr_init and sysfs_bin_attr_init
      sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on module dynamic attributes
      sysfs: Serialize updates to the vfs inode
      sysfs: Pack sysfs_dirent more tightly.
      sysfs: Implement sysfs_rename_link
      driver core: Use sysfs_rename_link in device_rename
      sysfs: Pass super_block to sysfs_get_inode
      sysfs: Kill unused sysfs_sb variable.

Greg Kroah-Hartman (2):
      sysdev: fix up the probe/release attributes
      Driver core: create lock/unlock functions for struct device

Hans J. Koch (2):
      UIO: Add a driver for Hilscher netX-based fieldbus cards
      UIO: Remove SMX Cryptengine driver

Heiko Carstens (1):
      sysdev: fix missing s390 conversion

Johannes Berg (1):
      sysfs: windfarm: init sysfs attributes

John Ogness (1):
      UIO: minor Kconfig fixes

Kay Sievers (4):
      Driver-Core: devtmpfs - reset inode permissions before unlinking
      Driver-Core: devtmpfs - remove EXPERIMENTAL and flush out the description
      Driver-Core: disable /sbin/hotplug by default
      Driver-Core: require valid action string in uevent trigger

Lee, Chun-Yi (5):
      msi-laptop: Support standard ec 66/62 command on MSI notebook and nebook
      msi-laptop: Add threeg sysfs file for support query 3G state by standard 66/62 ec command
      msi-laptop: Support some MSI 3G netbook that is need load SCM
      msi-laptop: Add resume method for set the SCM load again
      msi-laptop: Detect 3G device exists by standard ec command

Luis R. Rodriguez (1):
      driver-core: firmware_class: remove base.h header inclusion

Radu Voicilas (2):
      kobject-example: Spelling fixes.
      kset-example: Spelling fixes.

Randy Dunlap (1):
      msi-laptop: depends on RFKILL

Stefan Richter (1):
      HOWTO: Updates on subsystem trees, patchwork, -next (vs. -mm)

Stephen Rothwell (1):
      sysfs: fix for thinko with sysfs_bin_attr_init()

Tejun Heo (1):
      driver-core: fix race condition in get_device_parent()

Uwe Kleine-König (9):
      Driver core: make struct platform_driver.id_table const
      platform-drivers: move probe to .devinit.text in arch/arm
      platform-drivers: move probe to .devinit.text in drivers/scsi
      platform-drivers: move probe to .devinit.text in drivers/video
      x86: move hp-wmi's probe function to .devinit.text
      i2c: move i2c_omap's probe function to .devinit.text
      w1: move omap_hdq's probe function to .devinit.text
      media: move omap24xxcam's probe function to .devinit.text
      auxdisplay: move cfag12864bfb's probe function to .devinit.text

