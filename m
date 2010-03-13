Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab0CMAae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:30:34 -0500
Received: from kroah.org ([198.145.64.141]:46554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935293Ab0CMAaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:03 -0500
Date: Fri, 12 Mar 2010 16:28:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/145] 2.6.32.10-stable review
Message-ID: <20100313002816.GA18903@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.10 release.
There are 145 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Note, I still have a number of outstanding patches that have been
submitted for this release.  But due to the size, I figured it was best
to get this release out as soon as possible and then catch up next week
with the next batch of patches.  So don't worry if you don't see a patch
you have asked to be included that is not in here.

Responses should be made by Monday, March 15, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/kernel-parameters.txt     |    7 +
 Makefile                                |    2 +-
 arch/Kconfig                            |    2 -
 arch/ia64/include/asm/acpi.h            |    1 +
 arch/sparc/include/asm/io_32.h          |    2 +-
 arch/sparc/include/asm/page_32.h        |    2 +-
 arch/sparc/include/asm/stat.h           |    4 +-
 arch/sparc/kernel/central.c             |    4 +-
 arch/sparc/kernel/process_32.c          |    2 +-
 arch/sparc/kernel/process_64.c          |    8 +-
 arch/sparc/kernel/signal32.c            |   10 +-
 arch/sparc/kernel/signal_32.c           |    6 +-
 arch/sparc/kernel/signal_64.c           |    8 +-
 arch/sparc/kernel/tsb.S                 |    6 +-
 arch/x86/ia32/ia32_aout.c               |    1 -
 arch/x86/include/asm/io_apic.h          |    1 +
 arch/x86/include/asm/pgalloc.h          |    5 +
 arch/x86/kernel/acpi/boot.c             |   17 +-
 arch/x86/kernel/apic/io_apic.c          |   68 ++-
 arch/x86/kernel/reboot.c                |    8 +
 arch/x86/kvm/emulate.c                  |   55 ++-
 arch/x86/mm/pgtable.c                   |   31 +-
 arch/x86/oprofile/nmi_int.c             |   17 +-
 arch/x86/oprofile/op_model_amd.c        |   42 +--
 arch/x86/oprofile/op_model_p4.c         |    6 -
 arch/x86/oprofile/op_model_ppro.c       |    6 +-
 arch/x86/xen/enlighten.c                |    7 +
 arch/x86/xen/mmu.c                      |   11 +-
 drivers/acpi/processor_idle.c           |   28 +-
 drivers/acpi/tables.c                   |    4 +-
 drivers/ata/ahci.c                      |   12 +-
 drivers/ata/pata_hpt3x2n.c              |   20 +-
 drivers/base/core.c                     |   13 +-
 drivers/base/devtmpfs.c                 |   13 +
 drivers/char/tpm/tpm_tis.c              |   10 +-
 drivers/char/tty_ldisc.c                |   50 +-
 drivers/clocksource/sh_cmt.c            |   32 +-
 drivers/clocksource/sh_mtu2.c           |    6 +-
 drivers/clocksource/sh_tmu.c            |    6 +-
 drivers/gpio/wm831x-gpio.c              |   22 +-
 drivers/gpu/drm/i915/intel_display.c    |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c       |    7 +
 drivers/gpu/drm/i915/intel_sdvo.c       |   23 +-
 drivers/gpu/drm/i915/intel_tv.c         |    2 -
 drivers/gpu/drm/radeon/r600.c           |   13 +-
 drivers/gpu/drm/radeon/r600_cs.c        |   83 +++
 drivers/gpu/drm/radeon/r600d.h          |   26 +
 drivers/gpu/drm/radeon/radeon.h         |    1 +
 drivers/gpu/drm/radeon/radeon_cs.c      |    1 +
 drivers/gpu/drm/radeon/radeon_display.c |    6 +-
 drivers/gpu/drm/radeon/rv770.c          |   13 +-
 drivers/gpu/drm/ttm/ttm_tt.c            |   18 +-
 drivers/hid/hid-core.c                  |    2 -
 drivers/hid/hid-ids.h                   |    7 +-
 drivers/hid/usbhid/hid-core.c           |   28 +-
 drivers/hid/usbhid/hid-quirks.c         |    1 +
 drivers/hid/usbhid/usbhid.h             |    2 +
 drivers/hwmon/ams/ams-core.c            |   11 +-
 drivers/hwmon/ams/ams-i2c.c             |    2 +
 drivers/hwmon/ams/ams-pmu.c             |    2 +
 drivers/hwmon/ams/ams.h                 |    1 +
 drivers/hwmon/tmp421.c                  |   20 +-
 drivers/macintosh/therm_adt746x.c       |   34 +-
 drivers/md/dm.c                         |    4 +-
 drivers/media/dvb/dvb-core/dvb_net.c    |    1 +
 drivers/media/dvb/dvb-usb/Kconfig       |    4 +-
 drivers/media/dvb/frontends/l64781.c    |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 drivers/media/video/bt8xx/bttv-i2c.c    |    8 +-
 drivers/media/video/bt8xx/bttvp.h       |    1 +
 drivers/media/video/gspca/mr97310a.c    |    6 +
 drivers/media/video/pwc/pwc-ctrl.c      |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c      |    7 +
 drivers/mmc/host/s3cmci.c               |    2 +-
 drivers/net/ks8851_mll.c                |    4 +-
 drivers/net/sky2.c                      |    8 +-
 drivers/net/via-rhine.c                 |   41 +-
 drivers/net/wireless/airo.c             |   34 +-
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
 drivers/net/wireless/ath/ath5k/base.c   |   26 +-
 drivers/net/wireless/ath/ath9k/beacon.c |    9 +-
 drivers/net/wireless/ath/ath9k/hw.c     |   10 +
 drivers/net/wireless/ath/ath9k/phy.h    |    3 +
 drivers/net/wireless/ath/ath9k/rc.c     |   15 +-
 drivers/net/wireless/b43/main.c         |    3 +-
 drivers/net/wireless/b43legacy/main.c   |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   21 +-
 drivers/net/wireless/p54/p54pci.c       |   18 +-
 drivers/net/wireless/p54/p54usb.c       |    1 +
 drivers/net/wireless/rndis_wlan.c       |   13 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |   13 +-
 drivers/platform/x86/thinkpad_acpi.c    |   64 ++-
 drivers/rtc/class.c                     |    1 +
 drivers/rtc/rtc-coh901331.c             |    5 +-
 drivers/scsi/arm/fas216.c               |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c    |   17 +
 drivers/scsi/qla1280.c                  |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h          |    1 -
 drivers/scsi/qla2xxx/qla_isr.c          |   29 +-
 drivers/scsi/qla2xxx/qla_mid.c          |    6 +-
 drivers/serial/imx.c                    |    6 +-
 drivers/staging/Kconfig                 |    2 -
 drivers/staging/Makefile                |    1 -
 drivers/staging/hv/vmbus_drv.c          |   30 +
 drivers/staging/mimio/Kconfig           |   10 -
 drivers/staging/mimio/Makefile          |    1 -
 drivers/staging/mimio/mimio.c           |  914 ---------------------------
 drivers/usb/core/driver.c               |    4 +-
 drivers/usb/core/hcd.c                  |    2 +-
 drivers/usb/core/hcd.h                  |    2 +-
 drivers/usb/core/hub.c                  |   12 +
 drivers/usb/core/usb.c                  |    3 -
 drivers/usb/host/ohci-pnx4008.c         |    6 +-
 drivers/usb/host/uhci-hcd.c             |    1 +
 drivers/usb/host/xhci-ext-caps.h        |    7 +-
 drivers/usb/misc/sisusbvga/sisusb.c     |    1 +
 drivers/usb/serial/cp210x.c             |    3 +-
 drivers/usb/serial/ftdi_sio.c           |   31 +-
 drivers/usb/serial/ftdi_sio.h           |  959 +-----------------------------
 drivers/usb/serial/ftdi_sio_ids.h       | 1019 +++++++++++++++++++++++++++++++
 drivers/usb/serial/sierra.c             |   19 +-
 drivers/usb/storage/unusual_devs.h      |   88 +++-
 drivers/video/offb.c                    |   15 +-
 drivers/video/sunxvr500.c               |    1 +
 drivers/watchdog/bfin_wdt.c             |   13 +-
 fs/exec.c                               |    1 -
 fs/file_table.c                         |    2 +
 fs/namei.c                              |   14 +-
 fs/nfs/dns_resolve.c                    |   18 +-
 fs/nfsd/nfs4state.c                     |    2 +
 fs/ocfs2/aops.c                         |    5 +-
 fs/proc/base.c                          |   24 +-
 include/linux/fs.h                      |    3 +
 include/linux/irq.h                     |    2 +
 include/linux/sched.h                   |    5 +-
 kernel/irq/chip.c                       |   52 ++-
 kernel/power/snapshot.c                 |    2 +-
 kernel/sched.c                          |   21 +-
 lib/idr.c                               |    4 +-
 mm/fadvise.c                            |   10 +-
 mm/oom_kill.c                           |    2 +
 mm/readahead.c                          |    6 +
 mm/slab.c                               |    6 +-
 net/core/dev.c                          |    2 +-
 net/core/net-sysfs.c                    |    3 +-
 net/core/scm.c                          |    2 +
 net/ipv4/devinet.c                      |    7 +-
 net/ipv4/igmp.c                         |    2 +-
 net/ipv6/addrconf.c                     |   16 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |    1 +
 net/mac80211/agg-tx.c                   |    3 +-
 net/netfilter/xt_recent.c               |    4 +-
 net/sunrpc/svc_xprt.c                   |    5 +-
 net/sunrpc/xprtsock.c                   |    5 +
 security/selinux/ss/ebitmap.c           |    2 +-
 sound/core/pcm_native.c                 |    8 +-
 sound/pci/hda/hda_intel.c               |    5 +
 sound/pci/hda/patch_analog.c            |    2 +-
 sound/pci/via82xx.c                     |    6 +
 sound/soc/codecs/ak4104.c               |    6 +-
 sound/usb/usbaudio.c                    |   32 +
 sound/usb/usbmidi.c                     |    6 +
 sound/usb/usbquirks.h                   |   27 +
 167 files changed, 2360 insertions(+), 2378 deletions(-)
