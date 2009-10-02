Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZJBBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZJBBbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJBBbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:31:37 -0400
Received: from kroah.org ([198.145.64.141]:32839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZJBBbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:31:36 -0400
Date: Thu, 1 Oct 2009 18:29:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/136] 2.6.31.2-stable review
Message-ID: <20091002012911.GA18542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note from the -stable maintainer on this release:

  This release is big.  Yeah, really big.  There are a number of
  areas that needed some rework in order to get things back to
  working order.  Like the tty layer.  Hopefully everyone can now
  use their usb to serial devices again without oopsing the
  kernel.  Xen and KVM also have reasonably big fixes, as does
  the ath5k and iwlwifi drivers.  One might say that the patches
  for the iwlwifi drivers are a bit "bigger" than normal -stable
  material, but the wifi maintainer wants them, so he can handle
  the fallout.  XHCI (the USB 3.0 controller) also has a big
  update here, to get it into workable shape to coincide with the
  release of the USB 3.0 developer kit.  Without it, it wouldn't
  be really useful.  And there's a whole raft of other important
  fixes as well, not to make light of them.  A huge system speedup
  for large boxes is also in here, for those who like running
  benchmarks.

  Please test this -rc1 release out.  I've been beating on it
  here a lot, but there are still a lot of bits in .31 that feel
  a bit loose, as backed up by Rafael's bug list.  Hopefully this
  release smooths it out.

  Now back to the regular -stable review announcement:


This is the start of the stable review cycle for the 2.6.31.2 release.
There are 136 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, October 3, 2009 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.2-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

---------------

 MAINTAINERS                                 |    6 +
 Makefile                                    |    2 +-
 arch/alpha/kernel/core_marvel.c             |    2 +-
 arch/alpha/kernel/core_titan.c              |    2 +-
 arch/alpha/kernel/pci_impl.h                |    2 +-
 arch/alpha/kernel/pci_iommu.c               |    4 +-
 arch/arm/mach-pxa/sharpsl_pm.c              |    4 +-
 arch/powerpc/include/asm/pte-common.h       |    2 +-
 arch/powerpc/mm/pgtable.c                   |   19 ++-
 arch/x86/include/asm/elf.h                  |    2 +
 arch/x86/include/asm/uv/uv_hub.h            |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   15 +-
 arch/x86/kvm/mmu.c                          |    6 -
 arch/x86/kvm/x86.c                          |   15 +-
 arch/x86/mm/Makefile                        |    5 +
 arch/x86/mm/mmap.c                          |   17 +-
 arch/x86/mm/pageattr.c                      |    1 +
 arch/x86/xen/Makefile                       |    2 +
 arch/x86/xen/enlighten.c                    |  139 ++++++++--
 arch/x86/xen/smp.c                          |    1 +
 arch/x86/xen/spinlock.c                     |   28 ++-
 drivers/acpi/pci_slot.c                     |    4 +-
 drivers/ata/ahci.c                          |    4 +-
 drivers/ata/pata_amd.c                      |    3 +
 drivers/base/base.h                         |    2 +-
 drivers/base/bus.c                          |   23 +-
 drivers/base/core.c                         |    2 +-
 drivers/char/agp/intel-agp.c                |   30 ++-
 drivers/char/pty.c                          |    6 +-
 drivers/char/tty_io.c                       |    1 +
 drivers/char/tty_port.c                     |   29 ++-
 drivers/gpu/drm/i915/i915_drv.c             |    2 -
 drivers/gpu/drm/i915/i915_gem.c             |   55 ++--
 drivers/gpu/drm/i915/i915_gem_tiling.c      |   15 +-
 drivers/gpu/drm/i915/i915_reg.h             |    6 +
 drivers/gpu/drm/i915/intel_bios.c           |    3 +
 drivers/gpu/drm/i915/intel_crt.c            |    9 +-
 drivers/gpu/drm/i915/intel_display.c        |   35 +++-
 drivers/gpu/drm/i915/intel_lvds.c           |   11 +-
 drivers/gpu/drm/i915/intel_sdvo.c           |   96 +++++--
 drivers/hid/hid-core.c                      |    1 -
 drivers/isdn/gigaset/interface.c            |   19 +-
 drivers/media/video/em28xx/em28xx-cards.c   |   32 +--
 drivers/media/video/em28xx/em28xx.h         |    4 +
 drivers/media/video/saa7134/saa7134-input.c |   56 ++--
 drivers/media/video/saa7134/saa7134.h       |    4 +
 drivers/message/fusion/mptbase.c            |   10 +-
 drivers/mfd/ab3100-core.c                   |    2 +-
 drivers/mmc/core/mmc.c                      |   10 +-
 drivers/mmc/core/sd.c                       |   10 +-
 drivers/mtd/chips/cfi_cmdset_0002.c         |   11 -
 drivers/mtd/chips/cfi_util.c                |    4 +
 drivers/mtd/nand/ndfc.c                     |    4 +-
 drivers/mtd/ofpart.c                        |   21 +-
 drivers/net/can/vcan.c                      |    2 +-
 drivers/net/usb/kaweth.c                    |   18 +-
 drivers/net/wireless/ath/ar9170/usb.c       |    2 +
 drivers/net/wireless/ath/ath5k/ath5k.h      |    1 +
 drivers/net/wireless/ath/ath5k/attach.c     |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |   55 ++---
 drivers/net/wireless/ath/ath5k/reset.c      |  155 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   40 +++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   39 +++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   58 ++++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   25 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   57 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |   16 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   43 +++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |  185 +++++++++++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   45 ++--
 drivers/net/wireless/p54/p54usb.c           |    1 +
 drivers/pcmcia/at91_cf.c                    |    2 +-
 drivers/pcmcia/au1000_generic.c             |    2 +-
 drivers/pcmcia/bfin_cf_pcmcia.c             |    2 +-
 drivers/pcmcia/cs.c                         |    2 +-
 drivers/pcmcia/i82092.c                     |    2 +-
 drivers/pcmcia/i82365.c                     |    2 +-
 drivers/pcmcia/m32r_cfc.c                   |    2 +-
 drivers/pcmcia/m32r_pcc.c                   |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                |    2 +-
 drivers/pcmcia/omap_cf.c                    |    2 +-
 drivers/pcmcia/pd6729.c                     |    2 +-
 drivers/pcmcia/pxa2xx_base.c                |    2 +-
 drivers/pcmcia/sa1100_generic.c             |    2 +-
 drivers/pcmcia/sa1111_generic.c             |    2 +-
 drivers/pcmcia/tcic.c                       |    2 +-
 drivers/pcmcia/vrc4171_card.c               |    2 +-
 drivers/pcmcia/yenta_socket.c               |   88 ++++---
 drivers/platform/x86/sony-laptop.c          |    6 +
 drivers/platform/x86/thinkpad_acpi.c        |    8 +-
 drivers/serial/bfin_5xx.c                   |    4 +
 drivers/serial/serial_cs.c                  |    1 +
 drivers/usb/class/cdc-acm.c                 |    7 +-
 drivers/usb/class/cdc-wdm.c                 |   30 ++-
 drivers/usb/class/usbtmc.c                  |   22 ++-
 drivers/usb/core/config.c                   |    2 +-
 drivers/usb/host/sl811-hcd.c                |    8 +-
 drivers/usb/host/xhci-dbg.c                 |    5 +-
 drivers/usb/host/xhci-hcd.c                 |  370 +++++++++++++++++++++-----
 drivers/usb/host/xhci-mem.c                 |   64 ++++-
 drivers/usb/host/xhci-pci.c                 |   13 +
 drivers/usb/host/xhci-ring.c                |  232 +++++++++++++++--
 drivers/usb/host/xhci.h                     |   41 +++-
 drivers/usb/serial/ark3116.c                |   46 +---
 drivers/usb/serial/console.c                |   28 ++-
 drivers/usb/serial/cp210x.c                 |    6 -
 drivers/usb/serial/cypress_m8.c             |   12 +-
 drivers/usb/serial/empeg.c                  |   12 +-
 drivers/usb/serial/ftdi_sio.c               |    7 +
 drivers/usb/serial/ftdi_sio.h               |   10 +
 drivers/usb/serial/iuu_phoenix.c            |   31 +--
 drivers/usb/serial/kobil_sct.c              |   22 +-
 drivers/usb/serial/option.c                 |    4 +
 drivers/usb/serial/oti6858.c                |   21 +-
 drivers/usb/serial/pl2303.c                 |    1 +
 drivers/usb/serial/pl2303.h                 |    4 +
 drivers/usb/serial/spcp8x5.c                |   21 +-
 drivers/usb/serial/usb-serial.c             |  385 ++++++++++++---------------
 drivers/usb/serial/whiteheat.c              |    6 +-
 drivers/usb/storage/initializers.c          |    2 +-
 drivers/usb/storage/onetouch.c              |    2 +-
 drivers/video/console/fbcon.c               |   10 +
 drivers/video/s3c-fb.c                      |    2 +-
 drivers/video/sis/vstruct.h                 |    2 +-
 drivers/xen/Makefile                        |    3 +
 fs/cifs/cifsglob.h                          |    4 +-
 fs/ecryptfs/crypto.c                        |    5 +-
 fs/ecryptfs/inode.c                         |    2 +
 fs/ecryptfs/keystore.c                      |   28 ++-
 fs/ecryptfs/kthread.c                       |   24 +--
 fs/ecryptfs/main.c                          |    3 +-
 fs/inode.c                                  |   14 +-
 fs/nfsd/nfs4callback.c                      |    4 +-
 fs/nilfs2/btnode.c                          |    1 +
 fs/proc/kcore.c                             |    8 +-
 fs/proc/uptime.c                            |    7 +-
 include/linux/tty.h                         |    8 +-
 include/linux/usb/serial.h                  |    3 +
 include/pcmcia/ss.h                         |    2 +-
 kernel/perf_counter.c                       |   20 +-
 mm/hugetlb.c                                |    2 +-
 mm/memory.c                                 |    3 +-
 mm/mlock.c                                  |   99 +++----
 mm/mmap.c                                   |    4 +-
 mm/nommu.c                                  |   34 +--
 mm/page_alloc.c                             |   12 +-
 net/ax25/af_ax25.c                          |    2 +-
 net/bridge/br_netfilter.c                   |    2 +-
 net/bridge/netfilter/ebt_ulog.c             |    2 +-
 net/can/af_can.c                            |    4 +-
 net/ipv4/netfilter/nf_nat_core.c            |    2 +-
 net/netfilter/nf_conntrack_core.c           |    6 +-
 net/packet/af_packet.c                      |    4 +-
 scripts/Kbuild.include                      |    4 +-
 scripts/kallsyms.c                          |    2 +-
 tools/perf/builtin-annotate.c               |    4 +-
 tools/perf/builtin-report.c                 |    4 +-
 tools/perf/util/module.c                    |    2 +-
 162 files changed, 2336 insertions(+), 1127 deletions(-)

