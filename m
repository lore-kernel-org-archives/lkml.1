Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826Ab0A0AGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0A0AGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984Ab0A0AGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:06:23 -0500
Received: from kroah.org ([198.145.64.141]:35090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab0AZXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:00 -0500
Date: Tue, 26 Jan 2010 15:39:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/98] 2.6.32.7-stable review
Message-ID: <20100126233950.GA5372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.7 release.
There are 98 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, January 28, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.7-rc1.gz
and the diffstat can be found below.

I want to strongly thank Ben Hutchings, of the Debian Kernel team, for
doing a lot of work on this release.  He went through the Debian kernel
and sent me a lot of patches.  Same goes for the openSUSE and Gentoo
kernel teams[1], they also did a great job digging patches out for this
release as well.

thanks,

greg k-h

 Documentation/DocBook/Makefile              |   21 ++-
 Documentation/video4linux/CARDLIST.saa7134  |    1 +
 Makefile                                    |    2 +-
 arch/arm/mach-davinci/dm646x.c              |    9 +-
 arch/powerpc/sysdev/fsl_pci.c               |   14 ++
 arch/s390/kvm/intercept.c                   |    4 +-
 arch/x86/kernel/cpu/intel.c                 |    1 -
 arch/x86/kernel/tsc.c                       |    1 +
 arch/x86/kvm/lapic.c                        |   11 +-
 arch/x86/kvm/mmu.c                          |    6 +-
 arch/x86/kvm/paging_tmpl.h                  |    4 +-
 arch/x86/kvm/x86.c                          |    6 +-
 drivers/acpi/processor_idle.c               |   21 ++-
 drivers/ata/ahci.c                          |   20 ++-
 drivers/ata/ata_piix.c                      |    8 +-
 drivers/base/devtmpfs.c                     |    3 +-
 drivers/firmware/dmi_scan.c                 |   15 ++-
 drivers/hid/usbhid/hid-core.c               |    3 +-
 drivers/hid/usbhid/hid-quirks.c             |    2 +-
 drivers/hwmon/fschmd.c                      |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |    1 +
 drivers/input/mouse/alps.c                  |  252 ++++++++++++++++++++++++---
 drivers/input/mouse/alps.h                  |    1 +
 drivers/input/serio/i8042-x86ia64io.h       |  158 +++++++++--------
 drivers/md/md.c                             |    2 +-
 drivers/media/dvb/siano/smsusb.c            |   10 +
 drivers/media/video/saa7134/saa7134-cards.c |   31 ++++
 drivers/media/video/saa7134/saa7134-dvb.c   |    1 +
 drivers/media/video/saa7134/saa7134.h       |    1 +
 drivers/media/video/uvc/uvc_ctrl.c          |    2 +-
 drivers/mtd/ubi/upd.c                       |    1 +
 drivers/mtd/ubi/vtbl.c                      |    1 +
 drivers/net/atl1c/atl1c.h                   |    6 +-
 drivers/net/atl1c/atl1c_main.c              |   72 ++++----
 drivers/net/atl1e/atl1e_main.c              |   36 ----
 drivers/net/benet/be.h                      |   15 ++-
 drivers/net/benet/be_main.c                 |    2 +
 drivers/net/qlge/qlge_main.c                |   30 +---
 drivers/net/qlge/qlge_mpi.c                 |    3 +
 drivers/net/sfc/tx.c                        |    4 +-
 drivers/net/wireless/ath/ar9170/usb.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +
 drivers/pci/pcie/aer/aer_inject.c           |    8 +-
 drivers/pci/setup-bus.c                     |   11 +-
 drivers/s390/cio/device.c                   |   11 +-
 drivers/s390/cio/device_fsm.c               |   25 +--
 drivers/s390/net/netiucv.c                  |    4 +-
 drivers/scsi/device_handler/scsi_dh.c       |   11 +-
 drivers/scsi/fcoe/fcoe.c                    |   15 +-
 drivers/scsi/libfc/fc_disc.c                |    2 +-
 drivers/scsi/libfc/fc_elsct.c               |    4 +-
 drivers/scsi/libfc/fc_fcp.c                 |   35 ++--
 drivers/scsi/libfc/fc_lport.c               |   33 ++--
 drivers/scsi/libfc/fc_rport.c               |   81 ++++++---
 drivers/scsi/lpfc/lpfc_init.c               |   16 ++-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |    8 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   18 ++
 drivers/scsi/scsi_devinfo.c                 |    9 +-
 drivers/scsi/scsi_transport_fc.c            |   70 +++++---
 drivers/scsi/scsi_transport_iscsi.c         |    9 +-
 drivers/usb/serial/ftdi_sio.c               |   14 ++
 drivers/usb/serial/ftdi_sio.h               |   14 ++
 drivers/usb/serial/mos7840.c                |   24 +++-
 drivers/watchdog/iTCO_wdt.c                 |  115 ++++++++-----
 fs/nfs/super.c                              |    2 -
 fs/nfsd/nfs4acl.c                           |    2 +-
 fs/partitions/efi.c                         |   30 ++--
 fs/partitions/efi.h                         |    8 +-
 include/acpi/platform/aclinux.h             |    2 +-
 include/linux/clocksource.h                 |    2 +
 include/linux/hid.h                         |    1 +
 include/linux/pci_ids.h                     |   14 ++
 include/linux/time.h                        |    1 +
 include/scsi/fc_frame.h                     |    3 +
 include/scsi/libfc.h                        |    1 +
 init/calibrate.c                            |   24 ++-
 ipc/msg.c                                   |    1 +
 ipc/sem.c                                   |    1 +
 ipc/shm.c                                   |    1 +
 kernel/cpu.c                                |    5 +-
 kernel/sched.c                              |   34 ++--
 kernel/sched_fair.c                         |   16 ++
 kernel/time/clockevents.c                   |    5 +-
 kernel/time/clocksource.c                   |   44 +++++
 kernel/time/tick-sched.c                    |   52 ++++--
 kernel/time/timekeeping.c                   |   11 ++
 net/mac80211/cfg.c                          |    3 +
 net/netfilter/xt_conntrack.c                |   61 ++-----
 net/wireless/sme.c                          |    1 +
 sound/pci/hda/hda_intel.c                   |    3 +
 sound/pci/hda/patch_intelhdmi.c             |    2 +-
 sound/pci/hda/patch_realtek.c               |   10 +-
 sound/pci/ice1712/juli.c                    |   32 ++++
 sound/soc/codecs/wm8903.c                   |    3 +-
 virt/kvm/eventfd.c                          |   15 ++-
 virt/kvm/irq_comm.c                         |   12 +-
 96 files changed, 1175 insertions(+), 560 deletions(-)



[1] Ok, that would have been me, but I am on both of those teams, and if
I don't thank myself, who does?
