Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab0BFWoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 17:44:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab0BFWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 17:44:07 -0500
Date: Sat, 6 Feb 2010 14:44:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc7
Message-ID: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have to admit that I wish we had way fewer regressions listed by this 
time, so I hereby would like to point every developer to 

	http://article.gmane.org/gmane.linux.kernel.wireless.general/46197

to just remind them to look for regressions that look familiar. Taking a 
few minutes to look at that list and go "Hmm, maybe I know about that one" 
is a good idea.

But we've certainly fixed a few things, and it's been a week, so here's 
-rc7. I wish I could say that it's the last -rc, but I strongly doubt 
that, and we'll almost certainly have at least one more.

The bulk of the diffs are some powerpc defconfig additions, but if you 
ignore those, you'll notice i915 and (even more so) radeon KMS updates 
standing out. The rest is mostly random stuff spread all over, much of it 
one- or few-liners. kgdb fixes, fixed percpu vmap gc, futex fixes, btrfs 
and nfs fixes etc.

And various driver fixes and updates, of course. 

			Linus

---
Ajit Khaparde (1):
      be2net: Bug fix to support newer generation of BE ASIC

Alberto Panizzo (1):
      mx3fb: some debug and initialisation fixes

Alexander Clouter (1):
      MIPS: AR7: Fix USB slave mem range typo

Alexander Duyck (1):
      igbvf: fix issue w/ mapped_as_page being left set after unmap

Amerigo Wang (1):
      perf: Ignore perf.data.old

Andi Kleen (1):
      oprofile/x86: add Xeon 7500 series support

Andreas Schwab (1):
      powerpc: TIF_ABI_PENDING bit removal

Andrei Emeltchenko (2):
      Bluetooth: Remove double free of SKB pointer in L2CAP
      Bluetooth: Fix memory leak in L2CAP

Andres Salomon (1):
      CS5536: apply pci quirk for BIOS SMBUS bug

Andrew Morton (1):
      drivers/gpu/drm/radeon/radeon_combios.c: fix warning

Aneesh Kumar K.V (1):
      Btrfs: apply updated fallocate i_size fix

Anton Blanchard (1):
      fault injection: correct function names in documentation

Anuj Aggarwal (2):
      ASoC: AIC23: Fixing writes to non-existing registers in resume function
      ASoC: AM3517: ASoC driver not getting compiled

Austin Yuan (1):
      drm/ttm: remove unnecessary save_flags and ttm_flag_masked in ttm_bo_util.c

Baruch Siach (4):
      mx25: remove unused mx25_clocks_init() argument
      mx25: properly initialize clocks
      mx25: fix time accounting
      mx25: make the FEC AHB clk secondary of the IPG

Bastien Nocera (1):
      Bluetooth: Use the control channel for raw HID reports

Ben Hutchings (2):
      starfire: clean up properly if firmware loading fails
      cdc_ether: Partially revert "usbnet: Set link down initially ..."

Benjamin Herrenschmidt (4):
      powerpc/pci: Add calls to set_pcie_port_type() and set_pcie_hotplug_bridge()
      powerpc/pci: Add missing hookup to pci_slot
      powerpc/pci: Add missing call to header fixup
      powerpc/pseries: Fix xics build without CONFIG_SMP

Benjamin Marzinski (1):
      GFS2: Don't withdraw on partial rindex entries

Catalin Marinas (3):
      ARM: 5904/1: ARM: Always generate the IT instruction when compiling for Thumb-2
      ARM: 5909/1: ARM: Correct the FPSCR bits setting when raising exceptions
      [libata] Call flush_dcache_page after PIO data transfers in libata-sff.c

Choi, David (1):
      drivers/net: ks8851_mll ethernet network driver

Chris Wilson (2):
      drm/i915: Prevent use of uninitialized pointers along error path.
      drm/i915: Fix leak of relocs along do_execbuffer error path

Christoph Hellwig (1):
      libata: fix ata_id_logical_per_physical_sectors

Chuck Ebbert (1):
      block: fix bugs in bio-integrity mempool usage

Colin Tuckley (1):
      ARM: 5907/1: ARM: Fix the reset on the RealView PBX Development board

Dan Carpenter (1):
      drbd: null dereference bug

Dave Airlie (9):
      drm/radeon/kms: fix incorrect logic in DP vs eDP connector checking.
      drm/radeon/kms: use active device to pick connector for encoder
      drm/kms/radeon: pick digitial encoders smarter. (v3)
      drm/radeon/kms: release agp on error.
      drm/radeon/kms: move radeon KMS on/off switch out of staging.
      drm/radeon/kms: disable HDMI audio for now on rv710/rv730
      drm/radeon/kms: make initial state of load detect property correct.
      drm/radeon/kms: rs400/480 MC setup is different than r300.
      drm/radeon/kms: fix r300 vram width calculations

David Howells (1):
      NFS: Avoid warnings when CONFIG_NFS_V4=n

David Härdeman (1):
      x86: Add quirk for Intel DG45FC board to avoid low memory corruption

David John (1):
      drm/i915: Disable SR when more than one pipe is enabled

David S. Miller (1):
      be2net: Fix memset() arg ordering.

Dimitri Sivanich (1):
      x86, UV: Fix RTC latency bug by reading replicated cachelines

Dmitry Monakhov (1):
      block: fix bio_add_page for non trivial merge_bvec_fn case

Douglas Gilbert (1):
      libata-scsi passthru: fix bug which truncated LBA48 return values

Evgeniy Polyakov (1):
      connector: Delete buggy notification code.

FUJITA Tomonori (1):
      x86/agp: Fix agp_amd64_init regression

Felix Fietkau (2):
      ath9k: fix beacon slot/buffer leak
      ath9k: fix eeprom INI values override for 2GHz-only cards

Francisco Jerez (1):
      drm/ttm: Avoid conflicting reserve_memtype during ttm_tt_set_page_caching.

Frans Pop (1):
      sched: Correct printk whitespace in warning from cpu down task check

Frederic Weisbecker (1):
      reiserfs: Fix vmalloc call under reiserfs lock

Grazvydas Ignotas (1):
      ASoC: pandora: Add APLL supply to fix audio output

Guenter Roeck (1):
      MIPS: 64-bit: Detect virtual memory size

Gui Jianfeng (1):
      blk-cgroup: Fix potential deadlock in blk-cgroup

H Hartley Sweeten (1):
      NFS: Make nfs_commitdata_release static

Hans Verkuil (1):
      V4L/DVB: saa7134: remove stray unlock_kernel

Herbert Xu (2):
      crypto: padlock-sha - Add import/export support
      random: Remove unused inode variable

Hui Zhu (1):
      markup_oops.pl: fix $func_offset error with x86_64

Jakob Bornecrantz (2):
      drm/vmwgfx: Correctly detect 3D
      drm/vmwgfx: Don't send bad flags to the host

Jaroslav Kysela (2):
      ALSA: ctxfi - fix PTP address initialization
      ALSA: ice1724 - aureon - fix wm8770 volume offset

Jason Wessel (3):
      x86, hw_breakpoints, kgdb: Fix kgdb to use hw_breakpoint API
      perf, hw_breakpoint, kgdb: Do not take mutex for kernel debugger
      softlockup: Add sched_clock_tick() to avoid kernel warning on kgdb resume

Jean Delvare (2):
      hwmon: (lm78) Request I/O ports individually for probing
      hwmon: (w83781d) Request I/O ports individually for probing

Jeff Mahoney (1):
      hugetlb: fix section mismatches

Jerome Glisse (4):
      drm/radeon/kms: Bailout of blit if error happen & protect with mutex V3
      drm/radeon/kms: move blit initialization after we disabled VGA
      drm/radeon/kms: fix regression rendering issue on R6XX/R7XX
      drm/radeon/kms: don't call suspend path before cleaning up GPU

Jesse Barnes (2):
      drm/i915: handle non-flip pending case when unpinning the scanout buffer
      drm/i915: page flip support for Ironlake

Joerg Roedel (4):
      x86/amd-iommu: Fix possible integer overflow
      x86/amd-iommu: Fix NULL pointer dereference in __detach_device()
      x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
      x86/amd-iommu: Fix deassignment of a device from the pt_domain

Johannes Berg (1):
      iwlwifi: fix pointer signedness warning

John Fastabend (2):
      ixgbe: set the correct DCB bit for pg tx settings
      ixgbe: if ixgbe_copy_dcb_cfg is going to fail learn about it early

John Kacur (2):
      drm/kms/radeon/agp: Fix warning, format ‘%d’ expects type ‘int’, but argument 4 has type ‘size_t’
      drm/kms/radeon/agp: Move the check of the aper_size after drm_acp_acquire and drm_agp_info

Josef Bacik (1):
      Btrfs: do not try and lookup the file extent when finishing ordered io

Josh Boyer (2):
      powerpc/44x: Update PowerPC 44x board defconfigs
      powerpc/40x: Update the PowerPC 40x board defconfigs

Julia Lawall (1):
      kernel/cred.c: use kmem_cache_free

KAMEZAWA Hiroyuki (1):
      devmem: check vmalloc address on kmem read/write

Kevin Hilman (2):
      OMAP2/3: IRQ: ensure valid base address
      OMAP2/3: GPMC: ensure valid clock pointer

Lars Ellenberg (1):
      drbd: fix max_segment_size initialization

Leann Ogasawara (1):
      x86: Add Dell OptiPlex 760 reboot quirk

Li Peng (3):
      drm/i915: enable vblank interrupt on ironlake
      drm/i915: Fix the device info of Pineview
      drm/i915: don't trigger ironlake vblank interrupt at irq install

Li Zefan (1):
      cgroups: fix to return errno in a failure path

Linus Torvalds (3):
      Fix 'flush_old_exec()/setup_new_exec()' split
      Fix potential crash with sys_move_pages
      Linux 2.6.33-rc7

Magnus Damm (1):
      usb: r8a66597-hdc disable interrupts fix

Mahesh Salgaonkar (1):
      hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.

Manuel Lauss (1):
      MIPS: Alchemy: Fix dbdma ring destruction memory debugcheck.

Marcin Kościelnicki (1):
      drm/kms: Remove incorrect comment in struct drm_mode_modeinfo

Marek Skuczynski (3):
      sh: Fix access to released memory in dwarf_unwinder_cleanup()
      sh: Fix access to released memory in clk_debugfs_register_one()
      omap: Fix access to already released memory in clk_debugfs_register_one()

Mark Brown (5):
      mx31ads: Allow enable/disable of switchable supplies
      mx31ads: Provide a name for EXPIO interrupt chip
      mx31ads: Provide an IRQ range to the WM835x on the 1133-EV1 module
      MXC: Add AUDMUXv2 register decode to debugfs
      regulator: Specify REGULATOR_CHANGE_STATUS for WM835x LED constraints

Markus Pietrek (1):
      spi: spi_sh_msiof: Fixed data sampling on the correct edge

Matt Mackall (1):
      random: drop weird m_time/a_time manipulation

Mauro Carvalho Chehab (1):
      saa7146: stop DMA before de-allocating DMA scatter/gather page buffers

Maxim Levitsky (2):
      ALSA: hda - Delay switching to polling mode if an interrupt was missing
      ALSA: cosmetic: make hda intel interrupt name consistent with others

Miao Xie (1):
      Btrfs: remove BUG_ON() due to mounting bad filesystem

Michal Simek (1):
      microblaze: Defconfig update

Michel Dänzer (1):
      drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.

Mikael Pettersson (1):
      futex_lock_pi() key refcnt fix

Mike Frysinger (2):
      tracing/documentation: Cover new frame pointer semantics
      Bluetooth: Redo checks in IRQ handler for shared IRQ support

Nick Piggin (2):
      mm: percpu-vmap fix RCU list walking
      mm: purge fragmented percpu vmap blocks

OGAWA Hirofumi (1):
      GFS2: Fix refcnt leak on gfs2_follow_link() error path

Oleg Nesterov (1):
      lockdep: Fix check_usage_backwards() error message

Patrick McHardy (2):
      netfilter: nf_conntrack_sip: fix off-by-one in compact header parsing
      netfilter: ctnetlink: fix expectation mask dump

Pauli Nieminen (1):
      drm/r100/kms: Emit cache flush to the end of command buffer. (v2)

Peter Hanzel (1):
      drm/vmwgfx: Request SVGA version 2 and bail if not found

Peter Zijlstra (2):
      sched: Fix fork vs hotplug vs cpuset namespaces
      sched: Fix incorrect sanity check

Randy Dunlap (2):
      kfifo: fix kernel-doc notation
      ati_pcigart: fix printk format warning

Ray Copeland (1):
      hwmon: (adt7462) Wrong ADT7462_VOLT_COUNT

Richard Kennedy (2):
      drm/ttm: remove padding from ttm_ref_object on 64bit builds
      get_maintainer.pl: teach git log to use --no-color

Richard Röjfors (1):
      uartlite: fix crash when using as console

Roel Kluin (1):
      Btrfs: make error return negative in btrfs_sync_file()

Russell King (1):
      ARM: Fix wrong register in proc-arm6_7.S data abort handler

Ryusuke Konishi (1):
      nilfs2: fix potential leak of dirty data on umount

Sascha Hauer (2):
      i.MX25: Allow secondary clocks in DEFINE_CLOCK
      i.MX25: implement secondary clocks for uarts and fec

Sathya Perla (1):
      be2net: use eq-id to calculate cev-isr reg offset

Sergey Matyukevich (1):
      rtc-fm3130: add missing braces

Shan Wei (1):
      ipv6: conntrack: Add member of user to nf_ct_frag6_queue structure

Shaohui Zheng (1):
      memory hotplug: fix a bug on /dev/mem for 64-bit kernels

Sriram (1):
      ARCH OMAP : enable ARCH_HAS_HOLES_MEMORYMODEL for OMAP

Stef van Os (1):
      powerpc/4xx: Add pcix type 1 transactions

Stephen Rothwell (1):
      percpu: add __percpu for sparse

Steven J. Magnani (1):
      microblaze: fix interrupt state restore

Steven Rostedt (3):
      tracing: Prevent kernel oops with corrupted buffer
      ring-buffer: Check if ring buffer iterator has stale data
      ring-buffer: Check for end of page in iterator

Steven Whitehouse (4):
      GFS2: Fix previous patch
      GFS2: Use GFP_NOFS for alloc structure
      GFS2: Wait for unlock completion on umount
      GFS2: Extend umount wait coverage to full glock lifetime

Suravee Suthikulpanit (1):
      oprofile/x86: fix crash when profiling more than 28 events

Takashi Iwai (1):
      ALSA: hda - Add an ASUS mobo to MSI blacklist

Tejun Heo (3):
      idr: fix a critical misallocation bug
      ahci: add Acer G725 to broken suspend list
      idr: revert misallocation bug fix

Thadeu Lima de Souza Cascardo (1):
      pktcdvd: removing device does not remove its sysfs dir

Thiago Farina (1):
      lib/dma-debug.c: mark file-local struct symbol static.

Thomas Gleixner (3):
      clocksource: Prevent potential kgdb dead lock
      futex: Handle user space corruption gracefully
      futex: Handle futex value corruption gracefully

Thomas Meyer (1):
      drm/i915: slow acpi_lid_open() causes flickering - V2

Tony Lindgren (4):
      omap: Remove old unused defines for OMAP_32KSYNCT_BASE
      omap: Fix 3630 mux errors
      omap: Fix arch/arm/mach-omap2/mux.c: Off by one error
      omap: Disable serial port autoidle by default

Trond Myklebust (9):
      NFS: Fix a reference leak in nfs_wb_cancel_page()
      NFS: Try to commit unstable writes in nfs_release_page()
      NFSv4: Ensure that the NFSv4 locking can recover from stateid errors
      NFSv4: Don't allow posix locking against servers that don't support it
      NFSv4.1: Don't call nfs4_schedule_state_recovery() unnecessarily
      NFS: Ensure that we handle NFS4ERR_STALE_STATEID correctly
      NFS: Fix an Oops when truncating a file
      NFS: Fix a umount race
      NFS: Don't clobber the attribute type in nfs_update_inode()

Uwe Kleine-König (3):
      mx35: add a missing comma in a pad definition
      omap: define _toggle_gpio_edge_triggering only for OMAP1
      imxfb: correct location of callbacks in suspend and resume

Vikram Kandukuri (1):
      Bluetooth: Add DFU driver for Atheros Bluetooth chipset AR3011

Vivek Goyal (1):
      cfq-iosched: Do not idle on async queues

Vladimir Zapolskiy (1):
      ARM: MX3: Fixed typo in declared enum type name.

Wu Fengguang (1):
      devmem: fix kmem write bug on memory holes

Yan, Zheng (2):
      Btrfs: fix race between allocate and release extent buffer.
      Btrfs: Fix oopsen when dropping empty tree.

Yang Hongyang (1):
      tracing/documentation: Fix a typo in ftrace.txt

Yong Wang (1):
      perf report: Fix segmentation fault when running with '-g none'

Zhao Yakui (2):
      drm/i915: Add support for SDVO composite TV
      drm/i915: Fix the incorrect DMI string for Samsung SX20S laptop

Zhenyu Wang (1):
      drm/i915: disable hotplug detect before Ironlake CRT detect

Zhu Yi (1):
      mac80211: fix NULL pointer dereference when ftrace is enabled

anfei zhou (1):
      mm: flush dcache before writing into page to avoid alias

stephen hemminger (1):
      bonding: bond_open error return value
