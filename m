Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0BSQ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:57:29 -0500
Received: from kroah.org ([198.145.64.141]:57958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BSQ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:57:27 -0500
Date: Fri, 19 Feb 2010 08:57:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/93] 2.6.32.9-stable review
Message-ID: <20100219165717.GA15002@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.9 release.
There are 93 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

There are still a number of patches that I have had submitted for
inclusion in the .32 kernel series that I have not gotten to yet.  This
release has taken longer than I wanted (again), and the size of it, and
the importance of it, justifies pushing it out now.  If you have sent
patches for inclusion that you do not see here, please wait for the
2.6.32.10 release before worrying.

Responses should be made by Sunday, February 21, 2010, 17:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.9-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                                           |    2 +-
 arch/sh/include/asm/pgtable_32.h                   |    5 +-
 arch/x86/include/asm/amd_iommu.h                   |    1 +
 arch/x86/kernel/amd_iommu.c                        |   12 ++-
 arch/x86/kernel/amd_iommu_init.c                   |    3 +
 arch/x86/kernel/apic/io_apic.c                     |    1 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c          |    3 +-
 arch/x86/kvm/i8254.c                               |    3 +
 arch/x86/kvm/x86.c                                 |    7 +-
 drivers/acpi/processor_idle.c                      |    8 ++
 drivers/acpi/scan.c                                |    3 +
 drivers/ata/ahci.c                                 |   15 +++
 drivers/ata/libata-sff.c                           |    3 +
 drivers/base/class.c                               |    2 +
 drivers/block/cciss.c                              |    3 +
 drivers/char/mem.c                                 |   70 ++++++------
 drivers/char/tpm/tpm_infineon.c                    |   79 +++++++++----
 drivers/char/tty_io.c                              |    4 +-
 drivers/crypto/padlock-sha.c                       |   23 ++++
 drivers/dma/ioat/dma_v2.c                          |    2 +-
 drivers/edac/amd64_edac.c                          |   15 ++-
 drivers/gpu/drm/i915/i915_debugfs.c                |   30 -----
 drivers/gpu/drm/i915/i915_drv.h                    |   13 ++
 drivers/gpu/drm/i915/i915_gem.c                    |  123 +++++++++++++++++---
 drivers/gpu/drm/i915/i915_reg.h                    |   15 +++
 drivers/gpu/drm/i915/i915_suspend.c                |    5 +-
 drivers/gpu/drm/i915/intel_crt.c                   |    3 +
 drivers/gpu/drm/i915/intel_display.c               |   48 +++++++-
 drivers/gpu/drm/i915/intel_drv.h                   |    2 +
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   19 +++
 drivers/gpu/drm/i915/intel_lvds.c                  |   21 ++++
 drivers/gpu/drm/radeon/atom.c                      |    2 +-
 drivers/hwmon/adt7462.c                            |    2 +-
 drivers/hwmon/lm78.c                               |   25 ++--
 drivers/hwmon/w83781d.c                            |   26 ++--
 drivers/i2c/busses/i2c-tiny-usb.c                  |   12 +-
 drivers/md/dm-log-userspace-transfer.c             |   10 +-
 drivers/md/dm-stripe.c                             |    2 +-
 drivers/md/dm.c                                    |   21 +++-
 drivers/md/raid5.c                                 |   11 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    2 +-
 drivers/message/fusion/mptscsih.c                  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    4 +-
 drivers/net/wireless/b43/b43.h                     |    1 +
 drivers/net/wireless/b43/main.c                    |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c            |    1 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |    1 +
 drivers/platform/x86/dell-wmi.c                    |    8 +-
 drivers/platform/x86/hp-wmi.c                      |    9 ++-
 drivers/platform/x86/wmi.c                         |    4 +-
 drivers/regulator/core.c                           |    2 +-
 drivers/rtc/rtc-fm3130.c                           |    6 +-
 drivers/s390/block/dasd.c                          |   22 ++--
 drivers/s390/block/dasd_eckd.c                     |   44 +++----
 drivers/s390/block/dasd_fba.c                      |   10 +-
 drivers/s390/block/dasd_int.h                      |   10 ++
 drivers/serial/8250.c                              |    7 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   10 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   14 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   10 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/usb/core/devio.c                           |   48 +++++---
 drivers/usb/host/r8a66597-hcd.c                    |   37 ++++--
 fs/befs/linuxvfs.c                                 |    1 +
 fs/block_dev.c                                     |    7 +-
 fs/cifs/readdir.c                                  |    1 +
 fs/ecryptfs/inode.c                                |   16 +++
 fs/exec.c                                          |   21 +++-
 fs/fcntl.c                                         |    6 +-
 fs/nfs/direct.c                                    |    3 +
 fs/nfs/file.c                                      |    2 +
 fs/nfs/fscache.c                                   |    9 +-
 fs/nfs/mount_clnt.c                                |    2 +-
 fs/nfs/nfs2xdr.c                                   |    2 +-
 fs/nfs/nfs4_fs.h                                   |    1 +
 fs/nfs/nfs4proc.c                                  |   26 ++++-
 fs/nfs/nfs4xdr.c                                   |    6 +-
 fs/nfs/pagelist.c                                  |   17 ++--
 fs/nfs/super.c                                     |   15 +++-
 fs/nfs/write.c                                     |    1 +
 fs/sysfs/inode.c                                   |   47 ++++----
 include/drm/drm_os_linux.h                         |    2 +-
 include/linux/sched.h                              |   22 ++++
 include/net/netns/conntrack.h                      |    3 +
 include/net/netns/ipv4.h                           |    1 +
 kernel/futex.c                                     |   30 +++++-
 kernel/time/timekeeping.c                          |    2 +
 mm/migrate.c                                       |    3 +
 net/core/dst.c                                     |    2 +
 net/core/pktgen.c                                  |    1 +
 net/ipv4/netfilter/arp_tables.c                    |    4 +-
 net/ipv4/netfilter/ip_tables.c                     |    4 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    4 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   22 ++--
 net/ipv6/netfilter/ip6_tables.c                    |    4 +-
 net/mac80211/ibss.c                                |    2 +-
 net/netfilter/nf_conntrack_core.c                  |  117 ++++++++++---------
 net/netfilter/nf_conntrack_expect.c                |    4 +-
 net/netfilter/nf_conntrack_helper.c                |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    2 +-
 net/netfilter/nf_conntrack_standalone.c            |    7 +-
 sound/pci/ctxfi/ctatc.c                            |   15 +--
 sound/pci/ctxfi/ctvmem.c                           |   38 +++---
 sound/pci/ctxfi/ctvmem.h                           |    8 +-
 sound/pci/hda/hda_intel.c                          |    3 +
 sound/pci/hda/patch_realtek.c                      |   28 ++++-
 sound/usb/usbaudio.c                               |    2 +-
 111 files changed, 981 insertions(+), 463 deletions(-)
