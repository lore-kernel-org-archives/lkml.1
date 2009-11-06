Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbZKFWVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbZKFWVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbZKFWVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:21:45 -0500
Received: from kroah.org ([198.145.64.141]:56604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbZKFWVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:21:45 -0500
Date: Fri, 6 Nov 2009 14:18:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/99] 2.6.31.6 stable review
Message-ID: <20091106221850.GA15408@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.6 release.
There are 99 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by November 8, 2009, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.6-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

----------------

 Documentation/dontdiff                       |    1 -
 Makefile                                     |    2 +-
 arch/alpha/kernel/vmlinux.lds.S              |    1 +
 arch/m68k/Kconfig                            |    6 +-
 arch/mips/kernel/Makefile                    |    2 +
 arch/mips/kernel/vmlinux.lds.S               |   12 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c |    8 -
 arch/powerpc/platforms/powermac/low_i2c.c    |    7 +-
 arch/powerpc/platforms/powermac/pci.c        |   61 +++
 arch/powerpc/platforms/powermac/smp.c        |    2 +-
 arch/powerpc/platforms/pseries/msi.c         |    2 -
 arch/powerpc/platforms/pseries/xics.c        |    9 +
 arch/sparc/kernel/ldc.c                      |    4 +-
 arch/sparc/kernel/setup_32.c                 |    2 -
 arch/sparc/kernel/setup_64.c                 |    2 -
 arch/x86/ia32/ia32entry.S                    |    5 +-
 arch/x86/include/asm/amd_iommu.h             |    1 +
 arch/x86/include/asm/uv/uv_hub.h             |    7 +
 arch/x86/kernel/amd_iommu.c                  |    2 +
 arch/x86/kernel/amd_iommu_init.c             |   24 +-
 arch/x86/kernel/apic/x2apic_uv_x.c           |    8 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c     |   67 ++--
 arch/x86/kernel/e820.c                       |    4 +-
 arch/x86/kernel/tlb_uv.c                     |    4 +-
 arch/x86/kvm/i8254.c                         |    2 +-
 arch/x86/kvm/lapic.c                         |    2 +-
 arch/x86/kvm/x86.c                           |    3 +-
 arch/x86/xen/enlighten.c                     |   11 +-
 drivers/acpi/pci_root.c                      |   11 +
 drivers/acpi/scan.c                          |   12 +-
 drivers/ata/ahci.c                           |   52 +---
 drivers/ata/libata-core.c                    |   12 +-
 drivers/ata/libata-eh.c                      |    6 +-
 drivers/ata/pata_sc1200.c                    |    3 +-
 drivers/ata/pata_via.c                       |    2 +-
 drivers/ata/sata_nv.c                        |   18 +-
 drivers/ata/sata_via.c                       |    1 -
 drivers/base/driver.c                        |    2 +-
 drivers/char/Kconfig                         |    6 +-
 drivers/char/agp/intel-agp.c                 |    7 +
 drivers/char/hvc_xen.c                       |   25 +-
 drivers/char/vt.c                            |    3 -
 drivers/cpuidle/cpuidle.c                    |    5 +-
 drivers/gpu/drm/i915/i915_drv.h              |    2 +
 drivers/gpu/drm/i915/i915_reg.h              |   14 +-
 drivers/gpu/drm/i915/intel_display.c         |   73 +++-
 drivers/hwmon/it87.c                         |    5 +-
 drivers/input/mouse/synaptics.c              |   10 +
 drivers/macintosh/via-pmu.c                  |   40 +-
 drivers/md/dm-exception-store.c              |   22 +-
 drivers/md/dm-exception-store.h              |    8 +-
 drivers/md/dm-log-userspace-base.c           |    2 +-
 drivers/md/dm-snap-persistent.c              |   16 +-
 drivers/md/dm-snap.c                         |   25 +-
 drivers/md/dm.c                              |   11 +-
 drivers/misc/sgi-gru/gruprocfs.c             |   13 +-
 drivers/net/bonding/bond_main.c              |    2 +-
 drivers/net/wireless/b43/rfkill.c            |    3 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   34 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   33 +-
 drivers/net/wireless/libertas/if_usb.c       |    2 +-
 drivers/net/wireless/ray_cs.c                |    2 +-
 drivers/scsi/dpt_i2o.c                       |    4 +
 drivers/serial/8250_pci.c                    |   11 +
 drivers/usb/serial/option.c                  |   10 +
 drivers/usb/serial/sierra.c                  |   23 +-
 drivers/video/console/.gitignore             |    2 -
 drivers/video/console/Kconfig                |    9 +-
 drivers/video/console/Makefile               |   12 -
 drivers/video/console/prom.uni               |   11 -
 drivers/video/console/promcon.c              |  598 --------------------------
 drivers/virtio/virtio_ring.c                 |    3 +
 drivers/watchdog/riowd.c                     |    2 +-
 fs/cifs/connect.c                            |    3 +-
 fs/fuse/file.c                               |    5 +-
 fs/hfsplus/wrapper.c                         |    4 +
 fs/nfs/client.c                              |    2 +-
 fs/nfs/dir.c                                 |    2 +
 fs/nfs/direct.c                              |    1 +
 fs/nfs/nfs4proc.c                            |   15 +-
 fs/nfs/nfs4renewd.c                          |    6 -
 fs/nfs/nfs4xdr.c                             |    1 -
 fs/nfs/super.c                               |    2 +-
 fs/nilfs2/btnode.c                           |    3 +-
 fs/notify/inode_mark.c                       |    6 +-
 fs/pipe.c                                    |   41 ++-
 include/drm/drm_pciids.h                     |    1 +
 include/linux/moduleparam.h                  |    1 -
 include/linux/pci_ids.h                      |    4 +
 kernel/futex.c                               |   20 +-
 kernel/params.c                              |   17 +-
 mm/mempolicy.c                               |   13 +-
 mm/nommu.c                                   |    6 +-
 mm/swapfile.c                                |    3 +-
 mm/vmscan.c                                  |    2 +-
 net/mac80211/cfg.c                           |    6 +-
 net/mac80211/tx.c                            |    2 +-
 net/sched/cls_api.c                          |    2 +-
 net/unix/af_unix.c                           |    2 +
 scripts/Makefile                             |    1 -
 security/keys/keyctl.c                       |    2 +-
 sound/pci/ice1712/ice1724.c                  |    2 +-
 virt/kvm/kvm_main.c                          |    7 +-
 103 files changed, 657 insertions(+), 953 deletions(-)
