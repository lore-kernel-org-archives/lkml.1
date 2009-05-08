Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbZEHXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbZEHXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763482AbZEHXRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:17:40 -0400
Received: from kroah.org ([198.145.64.141]:60665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763219AbZEHXRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:17:36 -0400
Date: Fri, 8 May 2009 16:14:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.3
Message-ID: <20090508231412.GC6598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.29.3 kernel.  All users of the
2.6.29 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.29.2 and 2.6.29.3

The updated 2.6.29.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 
 arch/powerpc/include/asm/processor.h |   19 +++
 arch/powerpc/kernel/signal.c         |    4 
 arch/powerpc/kernel/signal.h         |    2 
 arch/powerpc/kernel/signal_32.c      |    4 
 arch/powerpc/kernel/signal_64.c      |    2 
 arch/x86/kernel/xsave.c              |    4 
 arch/x86/kvm/mmu.c                   |    2 
 arch/x86/kvm/x86.c                   |    5 
 arch/x86/mm/kmmio.c                  |    2 
 arch/x86/pci/mmconfig-shared.c       |    6 -
 block/genhd.c                        |   12 +-
 drivers/acpi/acpica/rscreate.c       |   27 -----
 drivers/char/hw_random/virtio-rng.c  |    4 
 drivers/crypto/ixp4xx_crypto.c       |  182 ++++++++++++-----------------------
 drivers/gpu/drm/i915/i915_drv.h      |    4 
 drivers/gpu/drm/i915/i915_reg.h      |    1 
 drivers/gpu/drm/i915/intel_display.c |    9 +
 drivers/ide/cs5536.c                 |    1 
 drivers/net/b44.c                    |    2 
 drivers/net/forcedeth.c              |    3 
 drivers/net/mv643xx_eth.c            |   24 ++--
 drivers/net/wireless/ath5k/debug.c   |    2 
 drivers/net/wireless/ath9k/main.c    |    5 
 drivers/net/wireless/b43/dma.c       |   50 +++++++--
 drivers/net/wireless/rndis_wlan.c    |   14 +-
 drivers/pci/dmar.c                   |   11 +-
 drivers/pci/intel-iommu.c            |    8 +
 drivers/pci/quirks.c                 |    1 
 drivers/platform/x86/thinkpad_acpi.c |   41 +++----
 drivers/usb/serial/usb-serial.c      |   99 +++++++++++++------
 drivers/usb/storage/unusual_devs.h   |    6 +
 fs/Makefile                          |    2 
 fs/bio.c                             |    3 
 fs/compat.c                          |   27 ++++-
 fs/exec.c                            |   43 +++++---
 fs/fs_struct.c                       |  170 ++++++++++++++++++++++++++++++++
 fs/internal.h                        |    8 +
 fs/namei.c                           |    7 -
 fs/namespace.c                       |   60 -----------
 fs/nfsd/nfssvc.c                     |    7 -
 fs/proc/array.c                      |   13 +-
 fs/proc/base.c                       |   55 +++-------
 fs/proc/meminfo.c                    |    2 
 fs/proc/task_mmu.c                   |    4 
 fs/proc/task_nommu.c                 |    2 
 include/drm/drm_pciids.h             |    1 
 include/linux/fs_struct.h            |    7 -
 include/linux/genhd.h                |    1 
 include/linux/kvm.h                  |    2 
 include/linux/mman.h                 |    9 -
 include/linux/pci_regs.h             |    2 
 kernel/exec_domain.c                 |   22 ----
 kernel/exit.c                        |   34 ------
 kernel/fork.c                        |   62 +++++------
 kernel/ptrace.c                      |    4 
 kernel/sched.c                       |    2 
 kernel/time/tick-common.c            |   12 ++
 mm/madvise.c                         |    8 +
 mm/mmap.c                            |   12 +-
 mm/nommu.c                           |   13 +-
 mm/swap.c                            |   46 --------
 net/mac80211/mlme.c                  |    2 
 net/mac80211/rx.c                    |   13 +-
 scripts/mod/modpost.c                |    1 
 security/selinux/hooks.c             |    1 
 sound/soc/codecs/wm8580.c            |    2 
 sound/usb/usx2y/us122l.c             |   12 +-
 virt/kvm/kvm_main.c                  |   11 --
 69 files changed, 682 insertions(+), 558 deletions(-)

Al Viro (5):
      Kill unsharing fs_struct in __set_personality()
      Get rid of bumping fs_struct refcount in pivot_root(2)
      Take fs_struct handling to new file (fs/fs_struct.c)
      New locking/refcounting for fs_struct
      check_unsafe_exec() doesn't care about signal handlers sharing

Alan Stern (1):
      USB: serial: fix lifetime and locking problems

Avi Kivity (1):
      KVM: MMU: Fix off-by-one calculating large page count

Bob Copeland (1):
      ath5k: fix buffer overrun in rate debug code

Cedric Hombourger (1):
      kbuild: fix Module.markers permission error under cygwin

Christian Borntraeger (1):
      virtio-rng: Remove false BUG for spurious callbacks

Christian Hohnstaedt (1):
      crypto: ixp4xx - Fix handling of chained sg buffers

Chuck Short (1):
      USB: Unusual Device support for Gold MP3 Player Energy

David Howells (1):
      Annotate struct fs_struct's usage count restriction

David Woodhouse (3):
      intel-iommu: Fix device-to-iommu mapping for PCI-PCI bridges.
      intel-iommu: Fix oops in device_to_iommu() when devices not found.
      intel-iommu: Avoid panic() for DRHD at address zero.

Ed Swierk (1):
      forcedeth: Fix resume from hibernation regression.

Eric Dumazet (1):
      sched: account system time properly

Eugene Teo (1):
      unreached code in selinux_ip_postroute_iptables_compat() (CVE-2009-1184)

FUJITA Tomonori (1):
      bio: fix memcpy corruption in bio_copy_user_iov()

Greg Kroah-Hartman (1):
      Linux 2.6.29.3

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix LED blinking through timer trigger

Hugh Dickins (3):
      compat_do_execve should unshare_files
      fix setuid sometimes doesn't
      fix setuid sometimes wouldn't

Jake Edge (1):
      proc: avoid information leaks to non-privileged processes

Jan Kiszka (1):
      KVM: Fix overlapping check for memory slots

Jesse Barnes (1):
      drm/i915: allow tiled front buffers on 965+

Joerg Roedel (1):
      KVM: x86: release time_page on vcpu destruction

Johannes Berg (1):
      mac80211: fix basic rate bitmap calculation

John Stultz (1):
      clockevents: prevent endless loop in tick_handle_periodic()

Josh Boyer (1):
      powerpc: Sanitize stack pointer in signal handling code

Jussi Kivilinna (1):
      rndis_wlan: fix initialization order for workqueue&workers

KOSAKI Motohiro (1):
      mm: fix Committed_AS underflow on large NR_CPUS environment

Karsten Wiese (1):
      ALSA: us122l: add snd_us122l_free()

Lennert Buytenhek (2):
      mv643xx_eth: 64bit mib counter read fix
      mv643xx_eth: OOM handling fixes

Luis R. Rodriguez (1):
      ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling

Marcelo Tosatti (1):
      KVM: MMU: disable global page optimization

Mark Brown (1):
      ASoC: Fix offset of freqmode in WM8580 PLL configuration

Mel Gorman (1):
      Ignore madvise(MADV_WILLNEED) for hugetlbfs-backed regions

Michael Buesch (3):
      b43: Poison RX buffers
      b43: Refresh RX poison on buffer recycling
      b44: Use kernel DMA addresses for the kernel DMA API

Oleg Nesterov (4):
      exit_notify: kill the wrong capable(CAP_KILL) check (CVE-2009-1337)
      ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
      do_execve() must not clear fs->in_exec if it was set by another thread
      check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/

Sergei Shtylyov (1):
      cs5536: define dma_sff_read_status() method

Stuart Bennett (1):
      tracing: x86, mmiotrace: fix range test

Suresh Siddha (1):
      x86-64: fix FPU corruption with signals and preemption

Tejun Heo (1):
      block: include empty disks in /proc/diskstats

Thomas Renninger (1):
      PCI quirk: disable MSI on VIA VT3364 chipsets

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in getting rx status for frames pending in reorder buffer

Vitaly Mayatskikh (1):
      pagemap: require aligned-length, non-null reads of /proc/pid/pagemap

Yinghai Lu (1):
      x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case

Yu Zhao (1):
      PCI: fix incorrect mask of PM No_Soft_Reset bit

Zhang Rui (1):
      ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries

Zhenyu Wang (1):
      drm/i915: add support for G41 chipset

