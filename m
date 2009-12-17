Return-Path: <linux-kernel-owner+w=401wt.eu-S936148AbZLQBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936148AbZLQBtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbZLQBtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:49:13 -0500
Received: from kroah.org ([198.145.64.141]:47765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763560AbZLQBTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:50 -0500
Date: Wed, 16 Dec 2009 17:18:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/90] 2.6.31.9-stable review
Message-ID: <20091217011835.GA20434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.9 release.
There are 90 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, December 19, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.9-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

--------------

 Documentation/kernel-parameters.txt         |    2 +
 Documentation/video4linux/gspca.txt         |    1 +
 Makefile                                    |    2 +-
 arch/arm/mach-pxa/em-x270.c                 |   11 +-
 arch/powerpc/kernel/vector.S                |    2 +-
 arch/s390/include/asm/kvm.h                 |    3 +-
 arch/s390/kvm/kvm-s390.c                    |   25 ++-
 arch/sparc/Makefile                         |    2 +
 arch/sparc/kernel/ldc.c                     |    4 +-
 arch/sparc/kernel/of_device_64.c            |   14 +-
 arch/sparc/lib/mcount.S                     |    5 +-
 arch/sparc/mm/init_64.h                     |    2 +-
 arch/x86/include/asm/mce.h                  |    6 +
 arch/x86/kernel/acpi/cstate.c               |    2 +-
 arch/x86/kernel/amd_iommu.c                 |    8 +-
 arch/x86/kernel/amd_iommu_init.c            |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c       |    5 +-
 arch/x86/kernel/cpu/mcheck/mce.c            |    3 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c    |   29 +++-
 arch/x86/kernel/cpu/perfctr-watchdog.c      |    2 +-
 arch/x86/kernel/pci-calgary_64.c            |   12 +-
 arch/x86/kernel/pci-dma.c                   |    2 +-
 arch/x86/kernel/pci-gart_64.c               |    2 +-
 arch/x86/kernel/reboot.c                    |    8 +
 arch/x86/kernel/setup.c                     |    3 +
 drivers/ata/pata_hpt37x.c                   |   32 ++--
 drivers/ata/pata_hpt3x2n.c                  |   17 +-
 drivers/firewire/ohci.c                     |   12 +-
 drivers/gpu/drm/i915/i915_drv.h             |    5 +
 drivers/gpu/drm/i915/i915_reg.h             |    2 +
 drivers/gpu/drm/i915/i915_suspend.c         |    2 +
 drivers/gpu/drm/i915/intel_crt.c            |    4 +-
 drivers/gpu/drm/i915/intel_display.c        |   66 ++++--
 drivers/gpu/drm/i915/intel_tv.c             |   11 +-
 drivers/gpu/drm/radeon/radeon_atombios.c    |    8 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    7 +-
 drivers/ide/cmd64x.c                        |    6 +-
 drivers/ide/ide-ioctls.c                    |    2 +-
 drivers/ide/ide-probe.c                     |    9 -
 drivers/ide/slc90e66.c                      |    3 +-
 drivers/isdn/i4l/isdn_ppp.c                 |  342 ++++++++++++--------------
 drivers/md/bitmap.c                         |   24 ++-
 drivers/md/bitmap.h                         |    2 +-
 drivers/md/md.c                             |    3 +-
 drivers/md/md.h                             |    1 +
 drivers/media/common/tuners/mxl5007t.c      |    2 +-
 drivers/media/video/gspca/ov519.c           |    1 +
 drivers/net/au1000_eth.c                    |   15 +-
 drivers/net/b44.c                           |    6 +-
 drivers/net/e100.c                          |   17 +-
 drivers/net/smc91x.c                        |    2 +-
 drivers/net/smsc9420.c                      |   14 +
 drivers/net/wireless/ath/ath5k/eeprom.c     |    3 +-
 drivers/net/wireless/ath/ath5k/phy.c        |    2 -
 drivers/net/wireless/b43legacy/rfkill.c     |    7 +
 drivers/net/wireless/ipw2x00/ipw2100.c      |   11 +
 drivers/net/wireless/p54/p54usb.c           |   10 +-
 drivers/platform/x86/asus-laptop.c          |    4 +-
 drivers/platform/x86/thinkpad_acpi.c        |   36 +---
 drivers/serial/8250.c                       |    8 +-
 drivers/serial/suncore.c                    |   37 ++--
 drivers/serial/suncore.h                    |    5 +-
 drivers/serial/sunhv.c                      |    2 +-
 drivers/serial/sunsab.c                     |    9 +-
 drivers/serial/sunsu.c                      |   36 +++-
 drivers/serial/sunzilog.c                   |    8 +-
 drivers/ssb/sprom.c                         |   20 ++-
 drivers/usb/class/usbtmc.c                  |   14 +-
 drivers/usb/core/usb.c                      |   31 ++--
 drivers/usb/musb/musb_gadget_ep0.c          |    1 -
 drivers/usb/serial/option.c                 |   37 +++
 drivers/usb/storage/transport.c             |   17 +-
 drivers/usb/storage/unusual_devs.h          |    7 +
 drivers/usb/storage/usb.c                   |   18 +-
 drivers/video/backlight/lcd.c               |    2 +-
 drivers/video/matrox/g450_pll.c             |    3 +-
 fs/debugfs/inode.c                          |   55 +++--
 fs/devpts/inode.c                           |   16 +-
 fs/ext3/inode.c                             |   18 +-
 fs/hfs/catalog.c                            |    4 +
 fs/hfs/dir.c                                |   11 +
 fs/hfs/super.c                              |    7 +-
 fs/jbd2/journal.c                           |    7 +
 fs/jffs2/gc.c                               |    3 +-
 include/linux/hrtimer.h                     |    4 +-
 include/linux/isdn_ppp.h                    |    2 +-
 include/linux/kvm.h                         |    8 +-
 include/linux/usb_usual.h                   |    4 +-
 kernel/acct.c                               |    3 +-
 kernel/futex.c                              |   10 +-
 kernel/sysctl.c                             |    3 +-
 mm/mincore.c                                |   37 +++
 mm/pagewalk.c                               |   16 ++-
 net/8021q/vlan.c                            |    7 +-
 net/core/dev.c                              |   22 ++-
 net/core/rtnetlink.c                        |    4 +-
 net/core/skbuff.c                           |    3 +-
 net/ipv4/ip_output.c                        |    2 +-
 net/mac80211/util.c                         |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |    4 +
 net/sunrpc/auth_gss/auth_gss.c              |    2 +-
 sound/core/hrtimer.c                        |   15 +-
 sound/pci/hda/hda_intel.c                   |    5 +
 103 files changed, 872 insertions(+), 502 deletions(-)
