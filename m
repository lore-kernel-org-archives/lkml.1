Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbZLQECd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbZLQECd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZLQECb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:02:31 -0500
Received: from kroah.org ([198.145.64.141]:55152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbZLQECb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:02:31 -0500
Date: Wed, 16 Dec 2009 20:02:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/151] 2.6.32.2-stable review
Message-ID: <20091217040208.GA26571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.2 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, December 19, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

------------

 Documentation/Changes                         |    2 +
 Documentation/kernel-parameters.txt           |    2 +
 Documentation/video4linux/gspca.txt           |    1 +
 MAINTAINERS                                   |    4 +-
 Makefile                                      |    2 +-
 arch/arm/mach-pxa/em-x270.c                   |   11 +-
 arch/ia64/include/asm/io.h                    |    2 +
 arch/ia64/mm/ioremap.c                        |   11 ++
 arch/powerpc/kernel/vector.S                  |    2 +-
 arch/s390/include/asm/kvm.h                   |    3 +-
 arch/s390/kernel/head64.S                     |    3 +
 arch/s390/kvm/kvm-s390.c                      |   25 ++-
 arch/s390/kvm/sigp.c                          |    6 +-
 arch/sparc/Makefile                           |    2 +
 arch/sparc/kernel/ldc.c                       |    4 +-
 arch/sparc/kernel/of_device_64.c              |   14 ++-
 arch/sparc/lib/mcount.S                       |    5 +-
 arch/x86/Makefile_32.cpu                      |    7 +
 arch/x86/include/asm/irq_vectors.h            |    2 +-
 arch/x86/include/asm/kvm_emulate.h            |    2 +-
 arch/x86/include/asm/mce.h                    |    6 +
 arch/x86/kernel/acpi/cstate.c                 |    2 +-
 arch/x86/kernel/amd_iommu.c                   |    8 +-
 arch/x86/kernel/amd_iommu_init.c              |    2 +-
 arch/x86/kernel/apic/apic.c                   |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c         |    5 +-
 arch/x86/kernel/cpu/mcheck/mce.c              |    9 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |   29 +++-
 arch/x86/kernel/cpu/perfctr-watchdog.c        |    2 +-
 arch/x86/kernel/pci-calgary_64.c              |   12 +-
 arch/x86/kernel/pci-dma.c                     |    2 +-
 arch/x86/kernel/pci-gart_64.c                 |    2 +-
 arch/x86/kernel/reboot.c                      |    8 +
 arch/x86/kernel/setup.c                       |    3 +
 arch/x86/kernel/tlb_uv.c                      |    4 +-
 arch/x86/kvm/emulate.c                        |    5 +-
 arch/x86/kvm/x86.c                            |   12 +-
 arch/x86/xen/enlighten.c                      |   27 ++--
 arch/x86/xen/mmu.c                            |    2 +-
 arch/x86/xen/smp.c                            |    1 +
 arch/x86/xen/suspend.c                        |   17 ++-
 arch/x86/xen/time.c                           |    7 +-
 arch/x86/xen/xen-asm_64.S                     |    4 +-
 arch/x86/xen/xen-ops.h                        |    2 +
 drivers/ata/pata_hpt37x.c                     |   32 ++--
 drivers/ata/pata_hpt3x2n.c                    |   17 +-
 drivers/base/core.c                           |    9 +-
 drivers/base/power/runtime.c                  |    2 +-
 drivers/firewire/ohci.c                       |   12 +-
 drivers/gpu/drm/drm_irq.c                     |   34 +++-
 drivers/gpu/drm/i915/i915_drv.h               |    4 +
 drivers/gpu/drm/i915/i915_gem.c               |    1 +
 drivers/gpu/drm/i915/intel_display.c          |   67 +++++---
 drivers/gpu/drm/i915/intel_dp.c               |    6 +-
 drivers/gpu/drm/i915/intel_tv.c               |   11 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |    8 +-
 drivers/gpu/drm/radeon/radeon_atombios.c      |    8 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |    7 +-
 drivers/gpu/drm/radeon/rs600.c                |   15 ++-
 drivers/gpu/drm/radeon/rs690.c                |   19 +-
 drivers/ide/slc90e66.c                        |    3 +-
 drivers/macintosh/therm_adt746x.c             |   13 ++-
 drivers/macintosh/windfarm_smu_controls.c     |    2 +
 drivers/md/bitmap.c                           |   24 ++-
 drivers/md/bitmap.h                           |    2 +-
 drivers/md/dm-crypt.c                         |  170 +++++++++++++------
 drivers/md/dm-exception-store.c               |    3 +-
 drivers/md/dm-ioctl.c                         |   17 ++-
 drivers/md/dm-snap.c                          |   12 +-
 drivers/md/dm-uevent.c                        |    9 +-
 drivers/md/md.c                               |    3 +-
 drivers/md/md.h                               |    1 +
 drivers/media/common/tuners/mxl5007t.c        |    2 +-
 drivers/media/video/gspca/ov519.c             |    1 +
 drivers/mtd/ubi/upd.c                         |   20 ++-
 drivers/net/b44.c                             |    3 +-
 drivers/net/bcm63xx_enet.c                    |   12 +-
 drivers/net/wireless/ath/ath5k/eeprom.c       |    3 +-
 drivers/net/wireless/ath/ath5k/phy.c          |    2 -
 drivers/net/wireless/ath/ath9k/ath9k.h        |    3 +
 drivers/net/wireless/ath/ath9k/hw.c           |   11 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/mac.c          |    6 +-
 drivers/net/wireless/ath/ath9k/mac.h          |    1 +
 drivers/net/wireless/ath/ath9k/main.c         |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |   20 ++-
 drivers/net/wireless/b43legacy/rfkill.c       |    7 +
 drivers/net/wireless/ipw2x00/ipw2100.c        |   11 ++
 drivers/net/wireless/rtl818x/rtl8187.h        |    5 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c    |   12 +-
 drivers/net/wireless/rtl818x/rtl8187_rfkill.c |    4 +-
 drivers/pci/dmar.c                            |   67 ++++++--
 drivers/pci/intel-iommu.c                     |   26 +++-
 drivers/platform/x86/acerhdf.c                |   63 ++++---
 drivers/platform/x86/asus-laptop.c            |    4 +-
 drivers/platform/x86/thinkpad_acpi.c          |   36 +---
 drivers/serial/8250.c                         |    8 +-
 drivers/ssb/sprom.c                           |   20 ++-
 drivers/usb/class/usbtmc.c                    |   14 +-
 drivers/usb/core/usb.c                        |   31 ++--
 drivers/usb/musb/musb_gadget_ep0.c            |    1 -
 drivers/usb/serial/option.c                   |   37 ++++
 drivers/usb/storage/transport.c               |   17 ++-
 drivers/usb/storage/unusual_devs.h            |    7 +
 drivers/usb/storage/usb.c                     |   18 ++-
 drivers/video/matrox/g450_pll.c               |    3 +-
 drivers/xen/balloon.c                         |   38 +---
 drivers/xen/events.c                          |    3 +
 drivers/xen/manage.c                          |   37 +++--
 drivers/xen/xenbus/xenbus_probe.c             |    6 +-
 fs/debugfs/inode.c                            |   55 ++++---
 fs/devpts/inode.c                             |   16 ++-
 fs/ext3/inode.c                               |   18 ++-
 fs/hfs/catalog.c                              |    4 +
 fs/hfs/dir.c                                  |   11 ++
 fs/hfs/super.c                                |    7 +-
 fs/jbd2/journal.c                             |    7 +
 fs/jffs2/gc.c                                 |    3 +-
 fs/nfs/write.c                                |    5 +-
 include/drm/drmP.h                            |    1 +
 include/drm/ttm/ttm_memory.h                  |    1 +
 include/linux/hrtimer.h                       |    4 +-
 include/linux/kvm.h                           |    8 +-
 include/linux/perf_event.h                    |    2 +-
 include/linux/usb_usual.h                     |    4 +-
 include/linux/vmalloc.h                       |    2 +
 include/net/tcp.h                             |   10 +-
 include/trace/ftrace.h                        |    2 +-
 kernel/acct.c                                 |    3 +-
 kernel/futex.c                                |   10 +-
 kernel/perf_event.c                           |    6 +-
 kernel/rcutree.c                              |  227 +++++++++++++++----------
 kernel/rcutree.h                              |   13 +-
 kernel/rcutree_plugin.h                       |    4 +-
 kernel/sched.c                                |   28 +++-
 kernel/sched_debug.c                          |    4 +
 kernel/sched_fair.c                           |   35 ++++-
 kernel/sysctl.c                               |    3 +-
 mm/memcontrol.c                               |    1 +
 mm/memory.c                                   |    4 +-
 mm/mincore.c                                  |   37 ++++
 mm/pagewalk.c                                 |   16 ++-
 mm/vmalloc.c                                  |    2 +
 net/core/dev.c                                |   11 ++
 net/core/rtnetlink.c                          |    4 +-
 net/ipv4/ip_output.c                          |    2 +-
 net/mac80211/cfg.c                            |    3 +-
 net/mac80211/ieee80211_i.h                    |    1 +
 net/mac80211/mesh.h                           |    5 +-
 net/mac80211/mesh_hwmp.c                      |    2 +-
 net/mac80211/rx.c                             |    1 -
 net/mac80211/scan.c                           |   32 +++-
 net/mac80211/util.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                |    4 +
 net/sunrpc/auth_gss/auth_gss.c                |    2 +-
 sound/core/hrtimer.c                          |   15 ++-
 sound/pci/hda/hda_intel.c                     |    5 +
 virt/kvm/irq_comm.c                           |    7 +-
 158 files changed, 1395 insertions(+), 617 deletions(-)
