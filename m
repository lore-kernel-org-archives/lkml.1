Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290Ab0AEA4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0AEA4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879Ab0AEA4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:56:16 -0500
Received: from kroah.org ([198.145.64.141]:34088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0AEAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:40 -0500
Date: Mon, 4 Jan 2010 16:31:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/97] 2.6.32.3 stable review
Message-ID: <20100105003133.GA7199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.3 release.
There are 97 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, Jan 7, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.3-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/ext4.txt             |    2 +-
 Makefile                                       |    2 +-
 arch/powerpc/kernel/align.c                    |   63 +++++--
 arch/x86/include/asm/msr.h                     |   19 ++-
 arch/x86/include/asm/processor.h               |    2 +-
 arch/x86/include/asm/uv/uv_hub.h               |   86 +++++----
 arch/x86/kernel/amd_iommu_init.c               |   10 +
 arch/x86/kernel/apic/x2apic_uv_x.c             |   12 +-
 arch/x86/kernel/ptrace.c                       |   16 +-
 arch/x86/kvm/lapic.c                           |    1 +
 arch/x86/kvm/paging_tmpl.h                     |   18 --
 arch/x86/lib/Makefile                          |    4 +-
 arch/x86/lib/msr-smp.c                         |  204 +++++++++++++++++++++
 arch/x86/lib/msr.c                             |  227 ++----------------------
 drivers/acpi/button.c                          |    7 +
 drivers/acpi/ec.c                              |   10 +-
 drivers/ata/pata_cmd64x.c                      |    2 +-
 drivers/ata/pata_hpt3x2n.c                     |   64 ++++---
 drivers/bluetooth/btusb.c                      |    1 +
 drivers/dma/at_hdmac.c                         |    4 +-
 drivers/dma/ioat/dma.c                         |    2 +-
 drivers/dma/ioat/dma.h                         |   18 ++
 drivers/dma/ioat/dma_v2.c                      |   69 ++++++--
 drivers/dma/ioat/dma_v2.h                      |    2 +
 drivers/dma/ioat/dma_v3.c                      |   60 +++++--
 drivers/dma/ioat/registers.h                   |    1 +
 drivers/edac/amd64_edac.c                      |  221 +++++++++++++----------
 drivers/edac/amd64_edac.h                      |    9 +-
 drivers/gpu/drm/drm_crtc_helper.c              |    3 +
 drivers/gpu/drm/radeon/atombios_crtc.c         |    6 +-
 drivers/gpu/drm/radeon/radeon_test.c           |    4 +-
 drivers/hwmon/sht15.c                          |    6 +-
 drivers/lguest/segments.c                      |    4 +-
 drivers/md/md.c                                |    8 +-
 drivers/media/video/ov511.c                    |    2 +-
 drivers/net/e100.c                             |    2 +-
 drivers/net/usb/rtl8150.c                      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c          |    7 +-
 drivers/net/wireless/ath/ath9k/hw.h            |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c           |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h           |    3 +
 drivers/net/wireless/ath/ath9k/main.c          |   14 ++
 drivers/net/wireless/ath/ath9k/reg.h           |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c          |    6 +-
 drivers/net/wireless/b43/rfkill.c              |   10 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h     |   14 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   23 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   11 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h        |    2 +-
 drivers/net/wireless/libertas/wext.c           |    2 -
 drivers/net/wireless/orinoco/wext.c            |    6 +-
 drivers/platform/x86/acerhdf.c                 |    7 +-
 drivers/s390/block/dasd_diag.c                 |   19 ++-
 drivers/scsi/ipr.c                             |    1 +
 drivers/scsi/qla2xxx/qla_os.c                  |    6 +-
 drivers/scsi/scsi_transport_fc.c               |   17 ++-
 drivers/scsi/st.c                              |   23 ++--
 drivers/scsi/st.h                              |    1 +
 drivers/usb/core/hub.c                         |   58 ++++---
 drivers/usb/core/sysfs.c                       |    6 +-
 drivers/usb/misc/appledisplay.c                |    4 +-
 drivers/usb/misc/emi62.c                       |    2 +-
 drivers/usb/musb/musb_gadget_ep0.c             |   14 +-
 drivers/usb/serial/option.c                    |    5 +
 drivers/xen/xenbus/xenbus_probe.c              |   42 +++--
 fs/cifs/connect.c                              |   13 +-
 fs/ext4/ext4.h                                 |    6 +-
 fs/ext4/inode.c                                |   36 ++--
 fs/ext4/mballoc.c                              |    6 -
 fs/ext4/super.c                                |    5 +
 fs/quota/dquot.c                               |  213 +++++++++++++----------
 fs/stat.c                                      |   10 +-
 fs/udf/super.c                                 |   32 +++-
 include/linux/cpumask.h                        |    2 +
 include/linux/fs.h                             |    1 +
 include/linux/quota.h                          |    5 +-
 include/linux/security.h                       |    7 +
 include/net/ip.h                               |    1 +
 include/net/ipv6.h                             |    8 +
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 kernel/cpu.c                                   |   18 ++-
 kernel/cpuset.c                                |   16 +-
 kernel/sched.c                                 |   40 +++--
 kernel/sched_fair.c                            |    3 +
 kernel/sysctl.c                                |    5 +-
 kernel/time/clockevents.c                      |   18 ++-
 lib/dma-debug.c                                |    8 +-
 mm/Kconfig                                     |    1 +
 mm/memcontrol.c                                |    8 +-
 mm/oom_kill.c                                  |    2 +-
 mm/vmscan.c                                    |   18 ++-
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   21 ++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   19 ++-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 +-
 net/ipv6/reassembly.c                          |    5 +-
 net/mac80211/ibss.c                            |    4 +
 net/mac80211/mlme.c                            |    8 +
 net/mac80211/tx.c                              |    1 +
 net/mac80211/util.c                            |   12 ++
 net/wireless/mlme.c                            |   13 ++-
 security/Makefile                              |    3 +-
 security/keys/keyctl.c                         |   10 +
 sound/mips/sgio2audio.c                        |    2 +-
 sound/pci/hda/patch_realtek.c                  |    6 +
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c         |    2 +-
 sound/soc/codecs/wm8974.c                      |    2 +-
 sound/soc/codecs/wm9712.c                      |    3 +-
 sound/usb/usbaudio.c                           |    2 +-
 113 files changed, 1303 insertions(+), 802 deletions(-)
