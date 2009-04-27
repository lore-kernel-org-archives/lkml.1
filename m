Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZD0SlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZD0SlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZD0SlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:41:04 -0400
Received: from sous-sol.org ([216.99.217.87]:45717 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559AbZD0SlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:41:01 -0400
Date: Mon, 27 Apr 2009 11:38:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.2
Message-ID: <20090427183822.GB3036@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.29.2 kernel.

There are a lot of fixes in this release touching all over the tree.
At least a few have possible security impact (e.g. af_rose, agp,
capability fs_mask, splice/ocfs2).  As usual, you're encouraged to
upgrade.  For details see the short changelog and diffstat below or full
changelog on kernel.org.

I'll be replying to this message with a copy of the patch between
2.6.29.1 and 2.6.29.2.

The updated 2.6.26.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,
-chris

---------

 Documentation/networking/bonding.txt       |    2 
 Makefile                                   |    2 
 arch/ia64/kvm/Kconfig                      |    4 
 arch/mips/kernel/linux32.c                 |    6 
 arch/powerpc/include/asm/futex.h           |   12 
 arch/powerpc/kvm/Kconfig                   |    3 
 arch/s390/kvm/Kconfig                      |    3 
 arch/sparc/include/asm/tlb_64.h            |    4 
 arch/x86/Kconfig.cpu                       |    1 
 arch/x86/boot/memory.c                     |    7 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   12 
 arch/x86/kernel/io_apic.c                  |   13 
 arch/x86/kvm/Kconfig                       |    4 
 arch/x86/kvm/i8254.c                       |   15 
 arch/x86/kvm/i8254.h                       |    1 
 arch/x86/kvm/mmu.h                         |    2 
 arch/x86/kvm/paging_tmpl.h                 |    4 
 arch/x86/kvm/vmx.c                         |   54 +--
 arch/x86/mm/pat.c                          |   98 +----
 arch/x86/pci/fixup.c                       |   20 -
 crypto/shash.c                             |    3 
 drivers/acpi/dock.c                        |    3 
 drivers/ata/pata_hpt37x.c                  |   22 -
 drivers/char/agp/generic.c                 |    4 
 drivers/char/vt.c                          |    2 
 drivers/gpu/drm/drm_gem.c                  |    7 
 drivers/gpu/drm/i915/i915_dma.c            |    9 
 drivers/gpu/drm/i915/i915_gem.c            |    1 
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   31 -
 drivers/gpu/drm/i915/i915_reg.h            |   16 
 drivers/gpu/drm/i915/intel_crt.c           |   45 +-
 drivers/gpu/drm/i915/intel_display.c       |   10 
 drivers/gpu/drm/i915/intel_tv.c            |   30 +
 drivers/ide/hpt366.c                       |    4 
 drivers/ide/ide-atapi.c                    |   10 
 drivers/ide/ide-io.c                       |    9 
 drivers/input/gameport/gameport.c          |   14 
 drivers/md/dm-bio-record.h                 |   26 +
 drivers/md/dm-io.c                         |    5 
 drivers/md/dm-kcopyd.c                     |   23 -
 drivers/md/dm-path-selector.c              |   21 -
 drivers/md/dm-raid1.c                      |   25 +
 drivers/md/dm-snap.c                       |  101 +++--
 drivers/md/dm-table.c                      |   26 -
 drivers/md/dm-target.c                     |   20 -
 drivers/md/raid1.c                         |    7 
 drivers/media/video/cx88/cx88-input.c      |   25 -
 drivers/message/fusion/mptbase.c           |    2 
 drivers/net/bonding/bond_main.c            |    5 
 drivers/net/bonding/bond_sysfs.c           |   14 
 drivers/net/ixgbe/ixgbe_ethtool.c          |  101 +++--
 drivers/net/r8169.c                        |    5 
 drivers/net/sfc/efx.c                      |    8 
 drivers/net/skge.c                         |    4 
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   86 ++---
 drivers/pci/probe.c                        |    9 
 drivers/platform/x86/acer-wmi.c            |   25 +
 drivers/scsi/libiscsi.c                    |    9 
 drivers/scsi/sg.c                          |  495 ++++++++++++++---------------
 drivers/spi/spi.c                          |   22 -
 drivers/usb/class/cdc-wdm.c                |    2 
 drivers/usb/gadget/u_ether.c               |    8 
 drivers/usb/serial/ftdi_sio.c              |    1 
 drivers/usb/serial/ftdi_sio.h              |    7 
 drivers/usb/serial/ti_usb_3410_5052.c      |   26 -
 drivers/usb/storage/unusual_devs.h         |    6 
 drivers/video/console/fbcon.c              |   24 -
 drivers/video/fbmem.c                      |   18 -
 drivers/virtio/virtio_balloon.c            |    3 
 fs/dquot.c                                 |    2 
 fs/drop_caches.c                           |    2 
 fs/ext4/mballoc.c                          |    4 
 fs/fs-writeback.c                          |    3 
 fs/hugetlbfs/inode.c                       |    3 
 fs/nfs/nfs3xdr.c                           |    3 
 fs/ocfs2/file.c                            |    8 
 fs/splice.c                                |   25 +
 include/linux/capability.h                 |   23 +
 include/linux/hrtimer.h                    |    5 
 include/linux/interrupt.h                  |    1 
 include/linux/kvm_host.h                   |   17 
 include/linux/pagemap.h                    |   12 
 include/linux/sched.h                      |    3 
 kernel/fork.c                              |   13 
 kernel/hrtimer.c                           |   55 +--
 kernel/kprobes.c                           |    4 
 kernel/posix-cpu-timers.c                  |    9 
 kernel/sched.c                             |   79 +++-
 kernel/softirq.c                           |    2 
 kernel/sysctl.c                            |   15 
 kernel/trace/trace.c                       |    3 
 lib/cpumask.c                              |    4 
 mm/filemap_xip.c                           |    4 
 mm/mmap.c                                  |    2 
 net/core/skbuff.c                          |    2 
 net/ipv4/netfilter/arp_tables.c            |    4 
 net/ipv4/netfilter/ip_tables.c             |    4 
 net/ipv6/netfilter/ip6_tables.c            |    4 
 net/netrom/af_netrom.c                     |    8 
 net/rose/af_rose.c                         |    4 
 net/x25/af_x25.c                           |    6 
 security/commoncap.c                       |    1 
 security/smack/smack_lsm.c                 |    4 
 sound/pci/hda/hda_codec.c                  |    6 
 sound/pci/hda/patch_analog.c               |    2 
 virt/kvm/ioapic.c                          |    6 
 virt/kvm/irq_comm.c                        |   24 +
 virt/kvm/kvm_main.c                        |   11 
 111 files changed, 1179 insertions(+), 869 deletions(-)

Akinobu Mita (2):
      ALSA: hda - add missing comma in ad1884_slave_vols
      hugetlbfs: return negative error code for bad mount option

Alan Cox (2):
      af_rose/x25: Sanity check the maximum user frame size
      tty: Fix leak in ti-usb

Alan Stern (1):
      USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab

Alasdair G Kergon (1):
      dm table: fix upgrade mode race

Amit Shah (2):
      KVM: VMX: Update necessary state when guest enters long mode
      KVM: is_long_mode() should check for EFER.LMA

Ananth N Mavinakayanahalli (1):
      kprobes: Fix locking imbalance in kretprobes

Andrea Arcangeli (1):
      KVM: Fix missing smp tlb flush in invlpg

Andrea Righi (2):
      fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
      fbdev: fix info->lock deadlock in fbcon_event_notify()

Avi Kivity (3):
      KVM: Add CONFIG_HAVE_KVM_IRQCHIP
      KVM: Interrupt mask notifiers for ioapic
      KVM: Reset PIT irq injection logic when the PIT IRQ is unmasked

Ben Hutchings (1):
      sfc: Match calls to netif_napi_add() and netif_napi_del()

Borislav Petkov (1):
      ide-atapi: start DMA after issuing a packet command

Brian Haley (1):
      Bonding: fix zero address hole bug in arp_ip_target list

Carlos Corbacho (1):
      acer-wmi: Blacklist Acer Aspire One

Cheng Renquan (1):
      dm target: use module refcount directly

Chris Wilson (1):
      drm/i915: Check for dev->primary->master before dereference.

Chris Wright (1):
      Linux 2.6.29.2

Dan Carpenter (2):
      ext4: fix typo which causes a memory leak on error path
      dock: fix dereference after kfree()

David Brownell (1):
      spi: spi_write_then_read() bugfixes

David Miller (1):
      sparc64: Fix bug in ("sparc64: Flush TLB before releasing pages.")

Dmitry Torokhov (1):
      Input: gameport - fix attach driver code

Elias Oltmanns (1):
      ide: Fix code dealing with sleeping devices in do_ide_request()

Eric Anholt (1):
      drm/i915: Change DCC tiling detection case to cover only mobile parts.

Eric Paris (1):
      scsi: mpt: suppress debugobjects warning

Etienne Basset (1):
      security/smack: fix oops when setting a size 0 SMACK64 xattr

FUJITA Tomonori (3):
      SCSI: sg: fix iovec bugs introduced by the block layer conversion
      SCSI: sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
      SCSI: sg: fix q->queue_lock on scsi_error_handler path

Francois Romieu (1):
      r8169: Reset IntrStatus after chip reset

Frederic Weisbecker (1):
      tracing/core: fix early free of cpumasks

Geert Uytterhoeven (1):
      ide: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>

Gertjan van Wingerde (1):
      rt2x00: Fix SLAB corruption during rmmod

Herbert Xu (1):
      gso: Fix support for linear packets

Hidetoshi Seto (1):
      posixtimers, sched: Fix posix clock monotonicity

Hugh Dickins (1):
      mm: pass correct mm when growing stack

Ingo Molnar (1):
      x86: disable X86_PTRACE_BTS for now

Jack Steiner (1):
      cpumask: fix slab corruption caused by alloc_cpumask_var_node()

Jean Delvare (4):
      V4L/DVB (10943): cx88: Prevent general protection fault on rmmod
      net/netrom: Fix socket locking
      SCSI: libiscsi: fix iscsi pool error path
      SCSI: libiscsi: fix iscsi pool error path

Jesse Barnes (2):
      drm/i915: check for -EINVAL from vm_insert_pfn
      drm: Use pgprot_writecombine in GEM GTT mapping to get the right bits for !PAT.

Joerg Roedel (1):
      KVM: MMU: handle compound pages in kvm_is_mmio_pfn

Jonathan McDowell (1):
      usb gadget: fix ethernet link reports to ethtool

Jun'ichi Nomura (1):
      dm: path selector use module refcount directly

Kristian Høgsberg (1):
      drm/i915: Read the right SDVO register when detecting SVDO/HDMI.

Lee Schermerhorn (1):
      mm: define a UNIQUE value for AS_UNEVICTABLE flag

Mallikarjuna R Chilakala (1):
      ixgbe: Fix potential memory leak/driver panic issue while setting up Tx & Rx ring parameters

Marcelo Tosatti (1):
      virtio: fix suspend when using virtio_balloon

Martin Schwidefsky (1):
      mm: do_xip_mapping_read: fix length calculation

Matthew Wilcox (1):
      sysctl: fix suid_dumpable and lease-break-time sysctls

Michael K. Johnson (1):
      x86, setup: mark %esi as clobbered in E820 BIOS call

Michal Schmidt (1):
      skge: fix occasional BUG during MTU change

Miklos Szeredi (1):
      splice: fix deadlock in splicing to file

Mikulas Patocka (8):
      dm: preserve bi_io_vec when resubmitting bios
      dm raid1: switch read_record from kmalloc to slab to save memory
      dm io: make sync_io uninterruptible
      dm snapshot: refactor __find_pending_exception
      dm snapshot: avoid dropping lock in __find_pending_exception
      dm snapshot: avoid having two exceptions for the same chunk
      dm kcopyd: prepare for callback race fix
      dm kcopyd: fix callback race

Nathan Lynch (1):
      sched: do not count frozen tasks toward load

NeilBrown (1):
      md/raid1 - don't assume newly allocated bvecs are initialised.

Oleg Nesterov (2):
      posix-timers: fix RLIMIT_CPU && fork()
      posix-timers: fix RLIMIT_CPU && setitimer(CPUCLOCK_PROF)

Oliver Neukum (1):
      USB: fix oops in cdc-wdm in case of malformed descriptors

Pallipadi, Venkatesh (2):
      ACPI: cap off P-state transition latency from buggy BIOSes
      x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

Patrick McHardy (1):
      netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection

Paul Mackerras (1):
      powerpc: Fix data-corrupting bug in __futex_atomic_op

Peter Korsgaard (1):
      USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer

Peter Zijlstra (1):
      hrtimer: fix rq->lock inversion (again)

Ralf Baechle (1):
      MIPS: Compat: Zero upper 32-bit of offset_high and offset_low.

Samuel Thibault (1):
      Revert "console ASCII glyph 1:1 mapping"

Serge E. Hallyn (2):
      cap_prctl: don't set error to 0 at 'no_change'
      add some long-missing capabilities to fs_mask

Sergei Shtylyov (2):
      hpt366: fix HPT370 DMA timeouts
      pata_hpt37x: fix HPT370 DMA timeouts

Shaohua Li (1):
      agp: zero pages before sending to userspace

Suresh Siddha (1):
      x86: fix broken irq migration logic while cleaning up multiple vectors

Takashi Iwai (1):
      ALSA: hda - Fix the cmd cache keys for amp verbs

Theodore Ts'o (1):
      ext4: fix locking typo in mballoc which could cause soft lockup hangs

Tony Battersby (2):
      SCSI: sg: fix races during device removal
      SCSI: sg: fix races with ioctl(SG_IO)

Trond Myklebust (1):
      NFS: Fix the XDR iovec calculation in nfs3_xdr_setaclargs

Weidong Han (1):
      KVM: fix kvm_vm_ioctl_deassign_device

Wu Fengguang (1):
      vfs: skip I_CLEAR state inodes

Yehuda Sadeh (1):
      crypto: shash - Fix unaligned calculation with short length

Yinghai Lu (1):
      PCI/x86: detect host bridge config space size w/o using quirks

Zhao Yakui (1):
      drm/i915: Sync crt hotplug detection with intel video driver

Zhenyu Wang (2):
      drm/i915: only set TV mode when any property changed
      drm/i915: fix TV mode setting in property change

