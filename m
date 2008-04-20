Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYDTKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYDTKjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYDTKjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:39:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:44625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYDTKjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:39:08 -0400
Date: Sun, 20 Apr 2008 03:45:16 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core changes against 2.6.25-git
Message-ID: <20080420104516.GA9225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of driver core related changes against your current
2.6.25-git tree.

They touch other subsystems (IB and SCSI specifically) with the
class_device changes, but those are acked by the respective maintainers
to go through my tree to minimize the merge mess.

They contain:
	- class_device removal (I think we are finished, the final patch
	  will come after 2.6.26-rc1 is out to verify that nothing was
	  missed.)
	- firmware documentation moving
	- ibft came in through here as no one else wanted to take it and
	  it was under driver/firmware/
	- UIO changes and a new driver.
	- lots of other things, the shortlog below describes them best.

All of these have been in the -mm and linux-next tree for quite a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-ibft                          |   23 
 Documentation/DocBook/kernel-api.tmpl                         |    5 
 Documentation/filesystems/sysfs.txt                           |    9 
 Documentation/firmware_class/firmware_sample_driver.c         |  115 -
 Documentation/firmware_class/firmware_sample_firmware_class.c |  207 --
 Documentation/power/devices.txt                               |    5 
 MAINTAINERS                                                   |    5 
 arch/arm/Kconfig                                              |    2 
 arch/x86/kernel/cpuid.c                                       |    4 
 arch/x86/kernel/msr.c                                         |    4 
 arch/x86/kernel/setup_32.c                                    |    3 
 arch/x86/kernel/setup_64.c                                    |    4 
 block/bsg.c                                                   |   11 
 drivers/ata/ahci.c                                            |    4 
 drivers/ata/libata-scsi.c                                     |   15 
 drivers/base/attribute_container.c                            |   77 
 drivers/base/bus.c                                            |   17 
 drivers/base/class.c                                          |    8 
 drivers/base/core.c                                           |   58 
 drivers/base/cpu.c                                            |    4 
 drivers/base/dd.c                                             |   14 
 drivers/base/firmware_class.c                                 |   18 
 drivers/base/memory.c                                         |   33 
 drivers/base/power/main.c                                     |  106 -
 drivers/base/power/power.h                                    |   23 
 drivers/base/power/sysfs.c                                    |    2 
 drivers/base/sys.c                                            |   18 
 drivers/base/transport_class.c                                |   14 
 drivers/char/drm/drmP.h                                       |    1 
 drivers/char/hw_random/core.c                                 |   10 
 drivers/char/misc.c                                           |   13 
 drivers/firmware/Kconfig                                      |   20 
 drivers/firmware/Makefile                                     |    2 
 drivers/firmware/iscsi_ibft.c                                 |  982 ++++++++++
 drivers/firmware/iscsi_ibft_find.c                            |   84 
 drivers/infiniband/core/sysfs.c                               |   76 
 drivers/infiniband/core/ucm.c                                 |   62 
 drivers/infiniband/core/user_mad.c                            |  109 -
 drivers/infiniband/core/uverbs.h                              |    4 
 drivers/infiniband/core/uverbs_main.c                         |   51 
 drivers/infiniband/hw/amso1100/c2_provider.c                  |   48 
 drivers/infiniband/hw/cxgb3/iwch_provider.c                   |   75 
 drivers/infiniband/hw/ipath/ipath_diag.c                      |   10 
 drivers/infiniband/hw/ipath/ipath_file_ops.c                  |   44 
 drivers/infiniband/hw/ipath/ipath_kernel.h                    |    8 
 drivers/infiniband/hw/ipath/ipath_verbs.c                     |   37 
 drivers/infiniband/hw/mlx4/main.c                             |   49 
 drivers/infiniband/hw/mthca/mthca_provider.c                  |   48 
 drivers/infiniband/hw/nes/nes_verbs.c                         |   48 
 drivers/infiniband/ulp/srp/ib_srp.c                           |  181 -
 drivers/infiniband/ulp/srp/ib_srp.h                           |    4 
 drivers/leds/led-class.c                                      |   11 
 drivers/memstick/core/memstick.c                              |   33 
 drivers/memstick/core/mspro_block.c                           |    4 
 drivers/memstick/host/jmb38x_ms.c                             |   16 
 drivers/message/fusion/mptscsih.c                             |  122 -
 drivers/message/fusion/mptscsih.h                             |    2 
 drivers/misc/enclosure.c                                      |  118 -
 drivers/net/wireless/b43/leds.c                               |    5 
 drivers/net/wireless/b43/main.c                               |    8 
 drivers/scsi/3w-9xxx.c                                        |    9 
 drivers/scsi/3w-xxxx.c                                        |    9 
 drivers/scsi/aacraid/aachba.c                                 |    2 
 drivers/scsi/aacraid/aacraid.h                                |    4 
 drivers/scsi/aacraid/linit.c                                  |   93 
 drivers/scsi/arcmsr/arcmsr.h                                  |    4 
 drivers/scsi/arcmsr/arcmsr_attr.c                             |  163 -
 drivers/scsi/ch.c                                             |   13 
 drivers/scsi/hosts.c                                          |   34 
 drivers/scsi/hptiop.c                                         |   14 
 drivers/scsi/ibmvscsi/ibmvscsi.c                              |   44 
 drivers/scsi/ibmvscsi/ibmvstgt.c                              |   25 
 drivers/scsi/ipr.c                                            |  140 -
 drivers/scsi/lpfc/lpfc_attr.c                                 |  484 ++--
 drivers/scsi/lpfc/lpfc_crtn.h                                 |    4 
 drivers/scsi/megaraid/megaraid_mbox.c                         |   13 
 drivers/scsi/ncr53c8xx.c                                      |    7 
 drivers/scsi/osst.c                                           |   76 
 drivers/scsi/pcmcia/sym53c500_cs.c                            |   14 
 drivers/scsi/qla2xxx/qla_attr.c                               |  177 -
 drivers/scsi/qla2xxx/qla_gbl.h                                |    4 
 drivers/scsi/raid_class.c                                     |   73 
 drivers/scsi/scsi_sas_internal.h                              |   24 
 drivers/scsi/scsi_sysfs.c                                     |  150 -
 drivers/scsi/scsi_transport_fc.c                              |  385 ++-
 drivers/scsi/scsi_transport_iscsi.c                           |  107 -
 drivers/scsi/scsi_transport_sas.c                             |  157 -
 drivers/scsi/scsi_transport_spi.c                             |  185 -
 drivers/scsi/scsi_transport_srp.c                             |   26 
 drivers/scsi/sd.c                                             |   78 
 drivers/scsi/ses.c                                            |   28 
 drivers/scsi/sg.c                                             |   36 
 drivers/scsi/st.c                                             |   82 
 drivers/serial/serial_core.c                                  |    2 
 drivers/uio/Kconfig                                           |   23 
 drivers/uio/Makefile                                          |    1 
 drivers/uio/uio.c                                             |   36 
 drivers/uio/uio_cif.c                                         |    6 
 drivers/uio/uio_smx.c                                         |  140 +
 fs/partitions/check.c                                         |    4 
 fs/sysfs/dir.c                                                |    1 
 fs/sysfs/file.c                                               |    6 
 include/linux/attribute_container.h                           |   28 
 include/linux/bsg.h                                           |    2 
 include/linux/device.h                                        |   35 
 include/linux/enclosure.h                                     |   11 
 include/linux/hw_random.h                                     |   10 
 include/linux/iscsi_ibft.h                                    |   50 
 include/linux/kernel.h                                        |    6 
 include/linux/leds.h                                          |   10 
 include/linux/libata.h                                        |    2 
 include/linux/memory.h                                        |    5 
 include/linux/memstick.h                                      |    2 
 include/linux/miscdevice.h                                    |   10 
 include/linux/pm.h                                            |   43 
 include/linux/pm_wakeup.h                                     |   90 
 include/linux/raid_class.h                                    |   12 
 include/linux/sysfs.h                                         |    9 
 include/linux/transport_class.h                               |    6 
 include/rdma/ib_verbs.h                                       |    2 
 include/scsi/scsi_device.h                                    |   10 
 include/scsi/scsi_host.h                                      |    7 
 include/scsi/scsi_transport.h                                 |    2 
 include/scsi/scsi_transport_fc.h                              |   14 
 include/scsi/scsi_transport_sas.h                             |   12 
 include/scsi/sd.h                                             |    4 
 lib/kobject.c                                                 |   19 
 mm/memory_hotplug.c                                           |    2 
 samples/firmware_class/firmware_sample_driver.c               |  120 +
 samples/firmware_class/firmware_sample_firmware_class.c       |  204 ++
 scripts/mod/file2alias.c                                      |   57 
 131 files changed, 4158 insertions(+), 2602 deletions(-)

---------------

Alan Stern (3):
      PM: Fix misuse of wakeup flag accessors in serial core
      PM: Make wakeup flags available whenever CONFIG_PM is set
      PM: Convert wakeup flag accessors to inline functions

Badari Pulavarty (1):
      driver core: register_memory/unregister_memory clean ups and bugfix

Ben Dooks (1):
      sysdev: detect multiple driver registrations

Ben Nizette (1):
      UIO: Implement a UIO interface for the SMX Cryptengine

Dan Williams (1):
      sysfs: refill attribute buffer when reading from offset 0

Daniel Walker (1):
      driver core: memory: semaphore to mutex

David Rientjes (1):
      sysfs: small header file cleanup for SYSFS=n

Denis Cheng (2):
      uio: Kconfig improvements
      uio: mark pci_device_id hilscher_pci_ids[] __devinitdata

Greg Kroah-Hartman (6):
      kobject: catch kobjects that are not initialized
      firmware: clean up samples for coding style issues
      Driver core: make device_is_registered() work for class devices
      memstick: convert struct class_device to struct device
      IB: rename "dev" to "srp_dev" in srp_host structure
      DRM: remove unused dev_class

Hans-Jürgen Koch (2):
      UIO: arch/arm/Kconfig: Make UIO available on ARM architecture
      UIO: Remove needless PCI_DEVICE_ID definition from uio_cif.c

Harvey Harrison (1):
      driver core: replace remaining __FUNCTION__ occurrences

Joe Perches (1):
      driver core: Convert debug functions declared inline __attribute__((format (printf,x,y) to statement expression macros

Kay Sievers (2):
      PNP: add all PNP card device id's as individual aliases
      block: send disk "change" event for rescan_partitions()

Konrad Rzeszutek (1):
      Firmware: add iSCSI iBFT Support

Pavel Machek (1):
      power_state: remove it from driver core

Rafael J. Wysocki (3):
      PM: Handle device registrations during suspend/resume
      Driver core: Call device_pm_add() after bus_add_device() in device_add()
      PM: Remove destroy_suspended_device()

Randy Dunlap (2):
      firmware: move firmware_class from Documentation/ to samples/
      PM: Remove legacy PM (fix)

Robert P. J. Day (2):
      SYSFS: Explicitly include required header file slab.h.
      Kobject: Replace list_for_each() with list_for_each_entry().

Sam Ravnborg (1):
      driver core: cpu: fix section mismatch in cpu.c:store_online

Tony Jones (2):
      IB: convert struct class_device to struct device
      SCSI: convert struct class_device to struct device

Uwe Kleine-König (1):
      UIO: hold a reference to the device's owner while the device is open

