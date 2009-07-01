Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZGAA3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZGAA3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZGAA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:28:48 -0400
Received: from kroah.org ([198.145.64.141]:34278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858AbZGAA2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:28:46 -0400
Date: Tue, 30 Jun 2009 17:28:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 000/108] 2.6.30-stable review
Message-ID: <20090701002838.GA7100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.30.1 release.

Sorry for the delay in getting this out, it's a big one.

There are 108 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, Jul 3, 00:00:00 2009 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.1-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/sysctl/vm.txt               |   12 ++-
 Makefile                                  |    2 +-
 arch/arm/include/asm/cacheflush.h         |    8 ++
 arch/x86/crypto/aesni-intel_asm.S         |    5 +-
 arch/x86/include/asm/apic.h               |    2 +-
 arch/x86/include/asm/cpufeature.h         |    1 +
 arch/x86/include/asm/uv/uv_bau.h          |    2 +-
 arch/x86/include/asm/uv/uv_hub.h          |    6 +-
 arch/x86/include/asm/vmx.h                |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c        |   15 ++--
 arch/x86/kernel/cpu/amd.c                 |   14 +++-
 arch/x86/kernel/cpu/mcheck/mce_64.c       |    1 +
 arch/x86/kernel/hpet.c                    |    3 +-
 arch/x86/kernel/pci-gart_64.c             |   10 ++-
 arch/x86/kernel/reboot.c                  |    9 ++
 arch/x86/kernel/setup.c                   |   15 +---
 arch/x86/kernel/tlb_uv.c                  |   24 ++++--
 arch/x86/kernel/tsc.c                     |   11 +++-
 arch/x86/kernel/vm86_32.c                 |    9 +-
 arch/x86/kernel/vsyscall_64.c             |    8 --
 arch/x86/kvm/vmx.c                        |  101 ++++++++++++++++++++-----
 arch/x86/kvm/x86.c                        |   10 ++-
 arch/x86/mm/memtest.c                     |   14 ++--
 drivers/char/epca.c                       |    9 +-
 drivers/char/moxa.c                       |    7 ++-
 drivers/char/n_r3964.c                    |   26 ++++---
 drivers/char/pcmcia/cm4000_cs.c           |    3 +-
 drivers/char/rocket.c                     |    6 +-
 drivers/char/vt_ioctl.c                   |    3 +-
 drivers/firmware/memmap.c                 |   16 ++--
 drivers/gpu/drm/i915/i915_drv.c           |    4 +-
 drivers/ide/ide-cd.c                      |    2 +-
 drivers/infiniband/hw/mlx4/qp.c           |    4 +
 drivers/isdn/hisax/hfc_pci.c              |   41 ++++++++---
 drivers/isdn/hisax/hisax.h                |    2 +-
 drivers/md/dm-exception-store.c           |    2 +-
 drivers/md/dm-exception-store.h           |    2 +-
 drivers/md/dm-log.c                       |    2 +-
 drivers/md/dm-mpath.c                     |   12 +++
 drivers/md/dm-table.c                     |    3 +-
 drivers/md/dm.c                           |    4 +
 drivers/md/raid5.c                        |    1 +
 drivers/media/dvb/frontends/lgdt3305.c    |   17 +----
 drivers/media/video/Makefile              |   77 ++++++++++---------
 drivers/media/video/cx18/cx18-controls.c  |    2 +
 drivers/media/video/cx2341x.c             |    2 +
 drivers/media/video/ivtv/ivtv-controls.c  |    2 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   56 ++++++++------
 drivers/media/video/saa7134/Makefile      |    3 +-
 drivers/net/bonding/bond_sysfs.c          |    1 +
 drivers/net/e1000e/netdev.c               |    2 +-
 drivers/net/mv643xx_eth.c                 |    7 +-
 drivers/net/sky2.c                        |   31 ++++----
 drivers/net/tun.c                         |    7 +-
 drivers/net/usb/pegasus.c                 |   29 ++++---
 drivers/net/via-velocity.c                |    2 +-
 drivers/net/wireless/ath5k/base.c         |    7 ++
 drivers/net/wireless/ath9k/calib.c        |   67 ++++++----------
 drivers/net/wireless/ath9k/main.c         |   28 +++++---
 drivers/net/wireless/ath9k/pci.c          |   18 +++++
 drivers/net/wireless/ath9k/regd.c         |    2 +-
 drivers/net/wireless/ath9k/xmit.c         |    5 +-
 drivers/parport/parport_pc.c              |   34 +++++++--
 drivers/pci/pci.c                         |    7 +-
 drivers/pci/pcie/aspm.c                   |    4 +
 drivers/scsi/qla2xxx/qla_dbg.c            |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c       |    5 +-
 drivers/serial/bfin_5xx.c                 |    5 +
 drivers/spi/spi_mpc83xx.c                 |    6 +-
 drivers/staging/uc2322/aten2011.c         |    4 +-
 drivers/usb/class/usbtmc.c                |    6 ++
 drivers/usb/serial/aircable.c             |    5 +-
 drivers/usb/serial/belkin_sa.c            |    7 +-
 drivers/usb/serial/cp210x.c               |    6 +-
 drivers/usb/serial/cyberjack.c            |   20 ++++-
 drivers/usb/serial/cypress_m8.c           |   11 +--
 drivers/usb/serial/digi_acceleport.c      |   20 ++++-
 drivers/usb/serial/empeg.c                |    8 --
 drivers/usb/serial/ftdi_sio.c             |   14 ----
 drivers/usb/serial/garmin_gps.c           |   16 +++-
 drivers/usb/serial/generic.c              |    9 ++-
 drivers/usb/serial/io_edgeport.c          |   29 +++++--
 drivers/usb/serial/io_tables.h            |   12 ++-
 drivers/usb/serial/io_ti.c                |   22 ++++-
 drivers/usb/serial/ipaq.c                 |    7 --
 drivers/usb/serial/iuu_phoenix.c          |    6 +-
 drivers/usb/serial/keyspan.c              |   13 +++-
 drivers/usb/serial/keyspan.h              |   12 ++-
 drivers/usb/serial/keyspan_pda.c          |    4 +-
 drivers/usb/serial/kl5kusb105.c           |   39 ++++++----
 drivers/usb/serial/kobil_sct.c            |   12 +--
 drivers/usb/serial/mct_u232.c             |   13 +--
 drivers/usb/serial/mos7720.c              |    9 +--
 drivers/usb/serial/mos7840.c              |   42 +++++++++-
 drivers/usb/serial/omninet.c              |   19 ++++-
 drivers/usb/serial/opticon.c              |   14 +++-
 drivers/usb/serial/option.c               |   17 +++-
 drivers/usb/serial/oti6858.c              |    7 +-
 drivers/usb/serial/pl2303.c               |    5 +-
 drivers/usb/serial/sierra.c               |   28 ++++++-
 drivers/usb/serial/spcp8x5.c              |    5 +-
 drivers/usb/serial/symbolserial.c         |   14 +++-
 drivers/usb/serial/ti_usb_3410_5052.c     |   10 +--
 drivers/usb/serial/usb-serial.c           |   29 +++----
 drivers/usb/serial/visor.c                |   13 +--
 drivers/usb/serial/whiteheat.c            |    6 +-
 fs/Kconfig                                |   14 ++--
 fs/cifs/file.c                            |   10 +-
 fs/eventpoll.c                            |   21 +++--
 fs/fs-writeback.c                         |    2 -
 fs/jfs/jfs_extent.c                       |    1 +
 fs/ocfs2/super.c                          |   32 +++++----
 fs/ramfs/inode.c                          |    9 ++-
 include/linux/firmware-map.h              |   12 +--
 include/linux/kvm_host.h                  |    1 +
 include/linux/mlx4/qp.h                   |    1 +
 include/linux/serial.h                    |  116 +++++++++++++++++------------
 include/linux/usb/serial.h                |   12 ++-
 include/linux/vmstat.h                    |    3 +
 include/net/x25.h                         |    2 +-
 kernel/trace/trace_functions.c            |    8 +-
 lib/Kconfig.debug                         |    2 +-
 lib/dma-debug.c                           |   43 ++++++++++-
 lib/genalloc.c                            |    1 -
 mm/page_alloc.c                           |    6 +-
 mm/vmscan.c                               |   55 ++++++++++++--
 mm/vmstat.c                               |    3 +
 net/ipv4/route.c                          |   36 ++++++++-
 net/mac80211/rc80211_minstrel.c           |    2 +-
 net/wireless/nl80211.c                    |   26 +++++--
 net/wireless/reg.c                        |   10 ++-
 net/x25/af_x25.c                          |   23 +++++-
 net/x25/x25_timer.c                       |    2 +-
 security/integrity/ima/ima_audit.c        |    2 +-
 security/integrity/ima/ima_main.c         |   13 ++-
 sound/core/seq/seq_midi_event.c           |    8 +-
 sound/isa/cmi8330.c                       |    2 +-
 sound/pci/ca0106/ca0106_mixer.c           |    6 ++
 sound/pci/hda/patch_realtek.c             |    2 +
 sound/pci/intel8x0.c                      |   24 +++---
 sound/soc/codecs/wm8903.c                 |    4 -
 virt/kvm/kvm_main.c                       |   18 ++++-
 142 files changed, 1230 insertions(+), 675 deletions(-)
