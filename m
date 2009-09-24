Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZIXRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZIXRks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZIXRkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:40:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZIXRki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:40:38 -0400
Date: Thu, 24 Sep 2009 10:40:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.1
Message-ID: <20090924174002.GE17077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.1 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31 and 2.6.31.1

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/arm/mm/highmem.c                     |    8 +
 arch/powerpc/include/asm/mmu-hash64.h     |    2 
 arch/powerpc/include/asm/pmc.h            |   16 ++
 arch/powerpc/kernel/lparcfg.c             |    3 
 arch/powerpc/kernel/perf_counter.c        |   68 +++++----
 arch/powerpc/kernel/rtas.c                |    7 -
 arch/powerpc/kernel/sysfs.c               |    3 
 arch/powerpc/mm/slb.c                     |   16 +-
 arch/powerpc/platforms/pseries/reconfig.c |    9 +
 arch/powerpc/platforms/pseries/setup.c    |    4 
 arch/x86/include/asm/kvm_host.h           |    1 
 arch/x86/include/asm/processor.h          |   12 +
 arch/x86/include/asm/stackprotector.h     |    4 
 arch/x86/include/asm/system.h             |    2 
 arch/x86/kernel/amd_iommu.c               |    2 
 arch/x86/kernel/apic/es7000_32.c          |    2 
 arch/x86/kernel/cpu/common.c              |    2 
 arch/x86/kernel/head_32.S                 |    1 
 arch/x86/kernel/kvm.c                     |    7 -
 arch/x86/kernel/kvmclock.c                |    4 
 arch/x86/kvm/lapic.c                      |    9 +
 arch/x86/kvm/mmu.c                        |    3 
 arch/x86/kvm/vmx.c                        |   11 -
 arch/x86/kvm/x86.c                        |   19 ++
 arch/x86/kvm/x86_emulate.c                |   17 ++
 arch/x86/mm/pageattr.c                    |    8 +
 block/blk-sysfs.c                         |    7 -
 drivers/ata/libata-core.c                 |    8 +
 drivers/char/agp/intel-agp.c              |    9 -
 drivers/char/tpm/tpm_tis.c                |   12 -
 drivers/md/dm-log-userspace-base.c        |    2 
 drivers/net/mlx4/eq.c                     |   42 ------
 drivers/net/mlx4/main.c                   |    9 -
 drivers/net/mlx4/mlx4.h                   |    7 -
 drivers/net/wireless/ath/ath5k/base.c     |    2 
 drivers/pci/quirks.c                      |    4 
 drivers/ps3/ps3stor_lib.c                 |   65 ++++++++-
 drivers/scsi/libsrp.c                     |    1 
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   23 +--
 drivers/scsi/mpt2sas/mpt2sas_base.h       |   43 +++++-
 drivers/scsi/mpt2sas/mpt2sas_config.c     |   61 ++++++++
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   16 --
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  207 +++++++++++++-----------------
 drivers/scsi/mpt2sas/mpt2sas_transport.c  |   29 ++--
 drivers/scsi/sd.c                         |    2 
 drivers/scsi/sg.c                         |    2 
 fs/binfmt_elf.c                           |   28 ++--
 include/linux/kvm_para.h                  |    1 
 ipc/shm.c                                 |    2 
 kernel/perf_counter.c                     |   44 ++++--
 net/wireless/scan.c                       |    2 
 sound/pci/cs46xx/cs46xx_lib.h             |    2 
 sound/pci/oxygen/oxygen_io.c              |   11 -
 sound/soc/codecs/wm8350.c                 |    2 
 tools/perf/builtin-stat.c                 |  170 ++++++++++--------------
 virt/kvm/ioapic.c                         |    2 
 57 files changed, 616 insertions(+), 441 deletions(-)


Alexander Duyck (1):
      PCI quirk: update 82576 device ids in SR-IOV quirks list

Avi Kivity (3):
      KVM: VMX: Check cpl before emulating debug register access
      KVM: x86 emulator: Implement zero-extended immediate decoding
      KVM: x86 emulator: fix jmp far decoding (opcode 0xea)

Bart Van Assche (1):
      SCSI: libsrp: fix memory leak in srp_ring_free()

Bob Copeland (2):
      cfg80211: fix looping soft lockup in find_ie()
      ath5k: write PCU registers on initial reset

Brian King (1):
      powerpc/pseries: Fix to handle slb resize across migration

Clemens Ladisch (1):
      sound: oxygen: work around MCE when changing volume

Geert Uytterhoeven (1):
      md: Fix "strchr" [drivers/md/dm-log-userspace.ko] undefined!

Geoff Levand (1):
      powerpc/ps3: Workaround for flash memory I/O error

Glauber Costa (1):
      KVM guest: fix bogus wallclock physical address calculation

Gleb Natapov (2):
      KVM: Fix coalesced interrupt reporting in IOAPIC
      KVM: VMX: Fix cr8 exiting control clobbering by EPT

Greg Kroah-Hartman (1):
      Linux 2.6.31.1

Hugh Dickins (1):
      fix undefined reference to user_shm_unlock

Izik Eidus (1):
      KVM: MMU: make __kvm_mmu_free_some_pages handle empty list

Jack Steiner (1):
      x86, pat: Fix cacheflush address in change_page_attr_set_clr()

James Bottomley (1):
      SCSI: fix oops during scsi scanning

Jan Kiszka (1):
      KVM: x86: Disallow hypercalls for guest callers in rings > 0

Jason Gunthorpe (1):
      TPM: Fixup boot probe timeout for tpm_tis driver

Jean Delvare (1):
      PCI: Unhide the SMBus on the Compaq Evo D510 USDT

Jens Axboe (1):
      block: don't assume device has a request list backing in nr_requests store

Jeremy Fitzhardinge (1):
      x86/i386: Make sure stack-protector segment base is cache aligned

Joerg Roedel (1):
      x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices

Kashyap, Desai (4):
      mpt2sas : Rescan topology from Interrupt context instead of work thread
      mpt2sas: Prevent sending command to FW while Host Reset
      mpt2sas: setting SDEV into RUNNING state from Interrupt context
      mpt2sas: Raid 10 Volume is showing as Raid 1E in dmesg

Marcelo Tosatti (2):
      KVM guest: do not batch pte updates from interrupt context
      KVM: limit lapic periodic timer frequency

Mark Brown (1):
      ASoC: Fix WM835x Out4 capture enumeration

Michal Schmidt (1):
      sg: fix oops in the error path in sg_build_indirect()

Nicolas Pitre (1):
      ARM: 5691/1: fix cache aliasing issues between kmap() and kmap_atomic() with highmem

Paul Mackerras (3):
      perf_counter: Start counting time enabled when group leader gets enabled
      powerpc/perf_counters: Reduce stack usage of power_check_constraints
      powerpc: Fix bug where perf_counters breaks oprofile

Peter Zijlstra (1):
      perf stat: Change noise calculation to use stddev

Roel Kluin (1):
      x86: Fix x86_model test in es7000_apic_is_cluster()

Roland Dreier (1):
      mlx4_core: Allocate and map sufficient ICM memory for EQ context

Roland McGrath (1):
      binfmt_elf: fix PT_INTERP bss handling

Sophie Hamilton (1):
      ALSA: cs46xx - Fix minimum period size

Tejun Heo (2):
      PCI: apply nv_msi_ht_cap_quirk on resume too
      libata: fix off-by-one error in ata_tf_read_block()

Xiao Guangrong (1):
      perf_counter: Fix buffer overflow in perf_copy_attr()

Zhenyu Wang (1):
      agp/intel: remove restore in resume

