Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab0BDRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:23 -0500
Received: from kroah.org ([198.145.64.141]:34552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab0BDRVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:21 -0500
Date: Thu, 4 Feb 2010 09:18:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/74] 2.6.32.8-stable review
Message-ID: <20100204171850.GA16539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.8 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Due to travelling to FOSDEM, I have not been able to test this release
as well as I would have liked to.  Also, given the complexity of some of
these changes, it would be great if people could really test this
release to verify that it works properly.  All help here is greatly
appreciated.

Responses should be made by Sunday, Feb 7 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/kvm/api.txt                 |   36 ++
 Makefile                                  |    2 +-
 arch/blackfin/include/asm/page.h          |    5 +
 arch/frv/include/asm/page.h               |    2 -
 arch/powerpc/include/asm/elf.h            |    8 +-
 arch/powerpc/include/asm/thread_info.h    |    2 -
 arch/powerpc/kernel/process.c             |   12 -
 arch/s390/kernel/entry.S                  |    1 +
 arch/s390/kernel/entry64.S                |    1 +
 arch/sh/kernel/process_64.c               |    2 +-
 arch/sparc/include/asm/elf_64.h           |   13 +-
 arch/sparc/include/asm/thread_info_64.h   |    4 +-
 arch/sparc/kernel/process_64.c            |    8 -
 arch/x86/Kconfig                          |    6 -
 arch/x86/ia32/ia32_aout.c                 |   11 +-
 arch/x86/include/asm/cpu_debug.h          |  127 ------
 arch/x86/include/asm/elf.h                |   10 +-
 arch/x86/include/asm/hpet.h               |    1 +
 arch/x86/include/asm/kvm_host.h           |    1 +
 arch/x86/include/asm/thread_info.h        |    2 -
 arch/x86/kernel/amd_iommu.c               |    2 +-
 arch/x86/kernel/cpu/Makefile              |    2 -
 arch/x86/kernel/cpu/cpu_debug.c           |  688 -----------------------------
 arch/x86/kernel/hpet.c                    |    8 +
 arch/x86/kernel/process.c                 |   12 -
 arch/x86/kernel/process_64.c              |   11 +
 arch/x86/kernel/quirks.c                  |   13 +
 arch/x86/kernel/reboot.c                  |    9 +
 arch/x86/kernel/setup.c                   |   14 +-
 arch/x86/kvm/x86.c                        |   42 ++-
 arch/x86/mm/srat_64.c                     |    4 +-
 arch/x86/oprofile/nmi_int.c               |    3 +-
 drivers/acpi/bus.c                        |  163 +++++++
 drivers/ata/libata-core.c                 |   38 ++-
 drivers/ata/libata-eh.c                   |    5 +-
 drivers/block/pktcdvd.c                   |    2 +-
 drivers/char/random.c                     |    9 -
 drivers/connector/connector.c             |  175 --------
 drivers/firewire/core-card.c              |   42 ++-
 drivers/firewire/ohci.c                   |    4 +-
 drivers/gpu/drm/drm_gem.c                 |   13 -
 drivers/gpu/drm/i915/i915_debugfs.c       |    2 +-
 drivers/gpu/drm/i915/i915_dma.c           |    4 +-
 drivers/gpu/drm/i915/i915_drv.h           |    2 +-
 drivers/gpu/drm/i915/i915_gem.c           |   54 +--
 drivers/gpu/drm/i915/i915_irq.c           |   32 +-
 drivers/gpu/drm/i915/i915_reg.h           |    8 -
 drivers/gpu/drm/i915/intel_crt.c          |    2 +
 drivers/gpu/drm/i915/intel_display.c      |   26 +-
 drivers/gpu/drm/i915/intel_dp.c           |    6 +
 drivers/gpu/drm/i915/intel_hdmi.c         |    5 +
 drivers/gpu/drm/i915/intel_sdvo.c         |    3 +
 drivers/gpu/drm/i915/intel_tv.c           |    2 +
 drivers/infiniband/hw/ipath/ipath_fs.c    |    4 +-
 drivers/input/misc/winbond-cir.c          |    2 +-
 drivers/message/fusion/mptbase.c          |    2 +
 drivers/mtd/ubi/cdev.c                    |    1 -
 drivers/net/benet/be.h                    |    5 +
 drivers/net/benet/be_cmds.h               |    3 +-
 drivers/net/benet/be_main.c               |   25 +-
 drivers/net/e1000/e1000.h                 |    2 +
 drivers/net/e1000/e1000_main.c            |   33 +-
 drivers/net/e1000e/e1000.h                |    1 +
 drivers/net/e1000e/netdev.c               |   45 +-
 drivers/net/sky2.c                        |    3 +-
 drivers/net/starfire.c                    |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c       |    7 +-
 drivers/net/wireless/ath/ath9k/main.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 drivers/regulator/wm8350-regulator.c      |    4 +-
 drivers/s390/block/dasd.c                 |    8 +-
 drivers/s390/block/dasd_eckd.c            |    2 +-
 drivers/s390/block/dasd_ioctl.c           |    7 +-
 drivers/s390/block/dasd_proc.c            |    7 +-
 drivers/s390/crypto/zcrypt_pcicc.c        |    2 +
 drivers/s390/crypto/zcrypt_pcixcc.c       |    2 +
 drivers/scsi/scsi_lib.c                   |    2 +-
 drivers/serial/uartlite.c                 |    2 +-
 drivers/usb/host/r8a66597-hcd.c           |   17 +-
 drivers/video/imxfb.c                     |    6 +-
 drivers/video/mx3fb.c                     |   12 +-
 fs/9p/vfs_super.c                         |    3 +-
 fs/affs/affs.h                            |    2 +-
 fs/affs/namei.c                           |    7 +-
 fs/affs/super.c                           |   31 +-
 fs/affs/symlink.c                         |    7 +-
 fs/bfs/inode.c                            |   43 +-
 fs/binfmt_aout.c                          |    1 +
 fs/binfmt_elf.c                           |   27 +-
 fs/binfmt_elf_fdpic.c                     |   16 +-
 fs/binfmt_flat.c                          |    1 +
 fs/binfmt_som.c                           |    1 +
 fs/bio-integrity.c                        |    3 +-
 fs/bio.c                                  |    7 +-
 fs/exec.c                                 |   36 +-
 fs/fuse/file.c                            |    3 +
 fs/romfs/super.c                          |    1 +
 include/linux/acpi.h                      |   16 +
 include/linux/binfmts.h                   |    1 +
 include/linux/connector.h                 |   32 --
 include/linux/inetdevice.h                |    1 +
 include/linux/kvm.h                       |    9 +
 include/linux/libata.h                    |    3 +
 include/linux/pagemap.h                   |    2 +
 include/linux/sched.h                     |    2 +-
 include/linux/sysctl.h                    |    1 +
 include/net/netrom.h                      |    2 +
 kernel/cred.c                             |    2 +-
 kernel/time/clocksource.c                 |    4 +-
 mm/filemap.c                              |  103 +++--
 mm/page_alloc.c                           |    5 +-
 mm/vmalloc.c                              |  109 ++++-
 net/ax25/ax25_out.c                       |    6 +
 net/core/sock.c                           |    4 +
 net/ipv4/devinet.c                        |    1 +
 net/ipv4/fib_frontend.c                   |    2 +
 net/mac80211/driver-trace.h               |    2 +-
 net/netrom/nr_route.c                     |   11 +-
 net/packet/af_packet.c                    |   19 +-
 net/rose/rose_link.c                      |    8 +
 net/rose/rose_route.c                     |    5 +
 security/selinux/hooks.c                  |    2 +-
 122 files changed, 952 insertions(+), 1461 deletions(-)
