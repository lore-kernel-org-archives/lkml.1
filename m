Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819Ab0A2WVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0A2WVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415Ab0A2WVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:21:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab0A2WVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:21:12 -0500
Date: Fri, 29 Jan 2010 14:20:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc6
Message-ID: <alpine.LFD.2.00.1001291407580.4206@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. About 50% arch updates, and 40% drivers, with the rest being a 
smattering of mainly fs and networking updates.

Most of these things are pretty small. The biggest arch/x86 change, for 
example, is largish just because we removed support for the cpu-debug 
feature that nobody seems to have used, and that caused problems on some 
machines because it read some odd CPU registers. The rest of the x86 
changes are basically one-liners.

On the driver side, about half of the changes are nouveau and radeon 
drm updates, with the rest again being mostly a smattering of random 
fixes, mostly small ones. There's a new "pismo" mtd driver, that's a few 
hundred lines.

In short, nothing earth-shattering here.  The most noticeable thing to 
people who triggered this might be the i915 driver fix to avoid getting 
the OOM killer involved that hit some people (the driver was trying to be 
clever with its memory management, but it backfired and caused the OOM 
killer to trigger when it shouldn't have).

Give it a go. Hopefully we've fixed a number of regressions, we're getting 
to that stage of the release cycle where things mostly should "just work" 
and people who still see regressions should start making loud noises. So 
give it a test,

		Linus
---
Abhijeet Kolekar (1):
      cfg80211: fix channel setting for wext

Al Viro (8):
      Fix a leak in affs_fill_super()
      Fix remount races with symlink handling in affs
      fix affs parse_options()
      Fix failure exits in bfs_fill_super()
      get rid of pointless checks after simple_pin_fs()
      fix leak in romfs_fill_super()
      fix oops in fs/9p late mount failure
      Fix failure exit in ipathfs

Alex Deucher (11):
      drm/radeon/kms/r100: fix bug in CS parser
      drm/radeon/kms: fix hardcoded mmio size in register functions
      drm/radeon/kms/atom: fix some parser bugs
      drm/radeon/kms/atom: upstream parser updates
      drm/radeon/kms: fix atombios_crtc_set_base
      drm/radeon/kms/r4xx: cleanup atom path
      drm/radeon/kms/atom: fix crtc lock ordering
      drm/radeon/kms: clean up pll struct
      drm/radeon/kms: clean up atombios pll code
      drm/radeon/kms/atom: atom parser fixes
      drm/radeon/kms: fix legacy get_engine/memory clock

Alexander Clouter (1):
      MIPS: Fix vmlinuz build for 32bit-only math shells

Alexander Duyck (1):
      igb/igbvf: cleanup exception handling in tx_map_adv

Alexander Graf (1):
      KVM: powerpc: Show timing option only on embedded

Alexey Dobriyan (3):
      ipv4: don't remove /proc/net/rt_acct
      netns xfrm: fix "ip xfrm state|policy count" misreport
      netns xfrm: deal with dst entries in netns

Anatolij Gustschin (1):
      [SCSI] mptsas: Fix issue with chain pools allocation on katmai

Andrea Tacconi (1):
      drm/nouveau: add NV18 device id to call_lvds_manufacturer_script

Andreas Herrmann (1):
      Revert "x86: ucode-amd: Load ucode-patches once ..."

Andrew Patterson (1):
      PCI: fix nested spinlock hang in aer_inject

Andrew Randrianasulu (2):
      drm/radeon/kms/r200: fix bug in CS parser
      drm/radeon/kms/r200: fix bug in CS parser

Andrew Vasquez (2):
      [SCSI] qla2xxx: Correct FCP2 recovery handling.
      [SCSI] qla2xxx: Perform fast mailbox read of flash regardless of size nor address alignment.

Aneesh Kumar K.V (4):
      ext4: Handle -EDQUOT error on write
      ext4: Fix quota accounting error with fallocate
      ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag
      Btrfs: Use correct values when updating inode i_size on fallocate

Anton Blanchard (1):
      sparc: cpumask_of_node() should handle -1 as a node

Anton Vorontsov (1):
      phylib: Move workqueue initialization to a proper place

Artem Bityutskiy (2):
      UBI: add more checks to chdev open
      UBI: fix memory leak in update path

Avi Kivity (1):
      KVM: Fix race between APIC TMR and IRR

Ben Hutchings (1):
      sfc: Use fixed-size buffers for MCDI NVRAM requests

Ben Skeggs (23):
      drm/nv50: ignore vbios table's claim to the contrary if EDID says >8bpc
      drm/nouveau: fix handling of fbcon colours in 8bpp
      drm/nouveau: remove unused nouveau_channel_idle() function
      drm/nv50: restore correct cache1 get/put address on fifoctx load
      drm/nouveau: have ttm's fault handler called directly
      drm/nv50: prevent a possible ctxprog hang
      drm/nv04: differentiate between nv04/nv05
      drm/nouveau: use dma.max rather than pushbuf size for checking GET validity
      drm/nouveau: initialise DMA tracking parameters earlier
      drm/nouveau: trust init table registers are safe
      drm/nouveau: wait on fence after bo move if validating for another channel
      drm/nouveau: remove PRIV0 check in nouveau_mem_close()
      drm/nouveau: assume no nv04 board has a DCB table
      drm/nouveau: less magic DCB 1.5 parsing
      drm/nouveau: reserve VGA area for the moment
      drm/nouveau: fix a race condition in nouveau_dma_wait()
      drm/nouveau: fix thinko in nv04_instmem.c
      drm/nv50: fix alignment of per-channel fifo cache
      drm/nv50: prevent accidently turning off encoders we're actually using
      drm/nouveau: report LVDS as disconnected if lid closed
      drm/nouveau: fix failure path if userspace specifies no valid memtypes
      drm/nv50: fail auxch transaction if reply count not what we expect
      drm/nv50: prevent switching off SOR when in use for DVI-over-DP

Benoit Papillault (1):
      mac80211: check that ieee80211_set_power_mgmt only handles STA interfaces.

Boaz Harrosh (1):
      [SCSI] scsi_lib: Fix bug in completion of bidi commands

Bob Copeland (1):
      mac80211: fix sign error in pid controller

Breno Leitao (1):
      qlge: Only free resources if they were allocated

Chris Mason (1):
      Btrfs: Add mount -o compress-force

Chris Wilson (1):
      drm/i915: Selectively enable self-reclaim

Christian Borntraeger (1):
      KVM: S390: fix potential array overrun in intercept handling

Christian Lamparter (1):
      p54pci: rx frame length check

Christof Schmitt (2):
      [SCSI] zfcp: Issue zfcp_fc_wka_port_put after FC CT BSG request
      [SCSI] zfcp: Fix linebreak in hba trace

Dan Carpenter (1):
      hwmon: (amc6821) Double unlock bug

Dan Williams (1):
      MAINTAINERS: transfer maintainership of I/OAT

Dave Airlie (5):
      drm/kms/fb: check for depth changes from userspace for resizing.
      drm/radeon/kms: fix displayport->dvi connector DDC.
      drm/radeon/kms: make hibernate work on IGPs
      drm/radeon/kms: drop unnecessary printks.
      drm/radeon/kms: preface warning printk with driver name

David Härdeman (1):
      Input: winbond-cir - remove dmesg spam

David John (1):
      drm: Keep disabled outputs disabled after suspend / resume

David Miller (1):
      sparc: TIF_ABI_PENDING bit removal

David Rientjes (1):
      x86: Set hotpluggable nodes in nodes_possible_map

David S. Miller (8):
      sparc32: Update defconfig.
      sparc32: Fix page_to_phys().
      sparc64: Add perf callchain support.
      sparc64: Fully support both performance counters.
      sparc: Add missing SW perf fault events.
      sparc64: Update defconfig.
      sparc64: Fix IRQ ->set_affinity() methods.
      sparc64: Fix UP build.

David VomLehn (2):
      MIPS: PowerTV: Streamline access to platform device registers
      MIPS: PowerTV: Fix support for timer interrupts with > 64 external IRQs

Davide Libenzi (1):
      eventfd - allow atomic read and waitqueue remove

Denis Turischev (1):
      [WATCHDOG] sbc_fitpc2_wdt: fix I/O space access technique.

Dirk Teurlings (1):
      [ARM] Orion5x: add GPIO LED and buttons for wrt350n v2

Dmitry Artamonow (1):
      mfd: Fix asic3 build

Eric Dumazet (1):
      vlan: fix vlan_skb_recv()

Eric Miao (3):
      [ARM] pxa/corgi: fix incorrect default GPIO for UDC Vbus
      [ARM] pxa: fix the incorrect naming of AC97 reset pin config for pxa26x
      [ARM] pxa: fix irq suspend/resume for pxa25x

Erik Benada (1):
      [ARM] orion5x: D-link DNS-323 rev. B1 power-off

Felix Beck (1):
      [S390] zcrypt: Do not remove coprocessor for error 8/72

Francisco Jerez (16):
      drm/nouveau: Add cache_flush/pull fifo engine functions.
      drm/nouveau: Pre-G80 tiling support.
      drm/nouveau: Make the MM aware of pre-G80 tiling.
      drm/i2c/ch7006: Drop build time dependency to nouveau.
      drm/nouveau: Fix "general protection fault" in the flipd/flips eviction path.
      drm/nouveau: No need to force evict=true when swapping evicted BOs back in.
      drm/nouveau: Drop redundant placement initialization.
      drm/nouveau: Clean up the nv17-nv4x load detection code a bit.
      drm/nouveau: Implement nv42-nv43 TV load detection.
      drm/nouveau: Don't skip card take down on nv0x.
      drm/nouveau: Allocate a per-channel instance of NV_SW.
      drm/nouveau: Use the software object for fencing.
      drm/nv04: Context switching fixes.
      drm/nouveau: Break some long lines.
      drm/nouveau: Fallback to analog load detection when the EDID block is invalid.
      drm/nouveau: Unset the EDID connector property when the EDID block goes away.

Giridhar Malavali (1):
      [SCSI] qla2xxx: Update version number to 8.03.01-k10.

Greg Kroah-Hartman (1):
      fnctl: f_modown should call write_lock_irqsave/restore

Guennadi Liakhovetski (1):
      ASoC: fix a memory-leak in wm8903

Guido Barzini (1):
      sfc: Add workspace for GMAC bug workaround to MCDI MAC_STATS buffer

H. Peter Anvin (2):
      x86: Remove "x86 CPU features in debugfs" (CONFIG_X86_CPU_DEBUG)
      x86: get rid of the insane TIF_ABI_PENDING bit

Hannes Reinecke (1):
      [SCSI] aic79xx: check for non-NULL scb in ahd_handle_nonpkt_busfree

Hans de Goede (1):
      hwmon: (fschmd) Fix a memleak on multiple opens of /dev/watchdog

Harish Zunjarrao (1):
      [SCSI] fc-transport: Use packed modifier for fc_bsg_request structure.

Heiko Carstens (3):
      sparc: copy_from_user() should not return -EFAULT
      [SCSI] zfcp: add missing compat ptr conversion
      [S390] irqflags: add missing types.h include

Hendrik Brueckner (1):
      [S390] sclp_vt220: set initial terminal window size

Henrik Rydberg (2):
      Input: add the ABS_MT_PRESSURE event
      Input: update multi-touch protocol documentation

Herbert Xu (1):
      virtio_net: Make delayed refill more reliable

Hin-Tak Leung (1):
      zd1211rw: adding 0409:0248 to supported device list

Hugh Dickins (1):
      mm: fix migratetype bug which slowed swapping

Inaky Perez-Gonzalez (1):
      wimax/i2400m: Add support for more i6x50 SKUs

James Bottomley (1):
      [SCSI] lpfc: fix file permissions

Jarek Poplawski (1):
      ax25: netrom: rose: Fix timer oopses

Jeff Garrett (1):
      x86/PCI: remove IOH range fetching

Jeff Kirsher (1):
      MAINTAINERS: Add Intel igbvf maintainer

Jeff Mahoney (1):
      hwmon: (smsc47m1) Fix section mismatch

Jerome Glisse (11):
      drm/radeon/kms: Do not unpin buffer in fb destruction
      drm/radeon/kms: Fix r600 blit cleanup path
      drm/radeon/kms: Disable AGP is aperture size < 32M
      drm/radeon/kms: Use radeon_agp_disable when disabling AGP
      drm: EDID accept separate sync video mode
      drm/radeon/kms: r600/r700 disable irq at suspend
      drm/radeon/kms: r600/r700 don't process IRQ if not initialized
      drm/radeon/kms: r600 handle irq vector ring overflow
      drm/radeon/kms: Forbid creation of framebuffer with no valid GEM object
      drm/radeon/kms: r600/r700 don't test ib if ib initialization fails
      drm/radeon: r6xx/r7xx possible security issue, system ram access

Jesse Brandeburg (3):
      e1000: enhance frame fragment detection
      e1000e: enhance frame fragment detection
      e1000/e1000e: don't use small hardware rx buffers

Jiajun Wu (1):
      ucc_geth: Fix full TX queue processing

Jiri Slaby (1):
      SPARC: use helpers for rlimits

John Stultz (1):
      sparc: convert to arch_gettimeoffset()

Jon Dodgson (1):
      Input: lifebook - add another Lifebook DMI signature

Josef Bacik (4):
      Btrfs: run orphan cleanup on default fs root
      Btrfs: do not mark the chunk as readonly if in degraded mode
      Btrfs: check return value of open_bdev_exclusive properly
      Btrfs: check total number of devices when removing missing

KOSAKI Motohiro (1):
      kmsg_dump: Dump on crash_kexec as well

Ken Kawasaki (1):
      fmvj18x_cs: add new id (Panasonic lan & modem card)

Kevin Hilman (1):
      OMAP: timekeeping: time should not stop during suspend

Lennert Buytenhek (1):
      [ARM] Orion: fix PCIe inbound window programming when RAM size is not a power of two

Linus Torvalds (3):
      mm: add new 'read_cache_page_gfp()' helper function
      Split 'flush_old_exec' into two functions
      Linux 2.6.33-rc6

Luca Barbieri (5):
      drm/nouveau: Fix null deref in nouveau_fence_emit due to deleted fence
      drm/nouveau: check pushbuffer bounds in ioctl
      drm/nouveau: Acknowledge DMA_VTX_PROTECTION PGRAPH interrupts
      drm/nouveau: Evict buffers in VRAM before freeing sgdma
      drm/ttm: Fix race condition in ttm_bo_delayed_delete (v3, final)

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Do not fail if MBIF is missing

Maarten Maathuis (3):
      drm/nouveau: better alignment of bo sizes and use roundup instead of ALIGN
      drm/nv50: make the blocksize depend on vram size
      drm/nv50: wait for pgraph to idle before unloading the context

Manjunatha GK (1):
      OMAP3: PM debug: fix build error when !CONFIG_DEBUG_FS

Marcelo Tosatti (2):
      KVM: properly check max PIC pin in irq route setup
      KVM: MMU: bail out pagewalk on kvm_read_guest error

Marcin Ko¶cielnicki (2):
      drm/nv04: Fix set_operation software method.
      drm/nv50: Fix typo in PGRAPH initialisation.

Marcin Slusarz (2):
      drm/nv50: fix fillrect color
      drm/nouveau: create function for "dealing" with gpu lockup

Martin Schwidefsky (2):
      [S390] use set_current_state in sigsuspend
      [S390] fix single stepped svcs with TRACE_IRQFLAGS=y

Matthew Slattery (1):
      sfc: QT202x: Remove unreliable MMD check at initialisation

Miao Xie (1):
      Btrfs: remove tree_search() in extent_map.c

Michael Hennerich (1):
      Input: ad7879 - support auxiliary GPIOs via gpiolib

Michael S. Tsirkin (2):
      KVM: only allow one gsi per fd
      KVM: fix spurious interrupt with irqfd

Mika Westerberg (1):
      UBI: fix volume creation input checking

Mike Frysinger (1):
      bfin_mac: use the newer CLKBUFOE bit name via asm/dpmc.h

Mike McCormack (1):
      sky2: Enable/disable WOL per hardware device

Morten Thunberg Svendsen (1):
      mtd: tests: fix read, speed and stress tests on NOR flash

Neil Horman (2):
      dccp_probe: Fix module load dependencies between dccp and dccp_probe
      dccp: fix dccp rmmod when kernel configured to use slub

Olof Johansson (1):
      omap: Enable GPMC clock in gpmc_init

Pallipadi, Venkatesh (1):
      x86: Disable HPET MSI on ATI SB700/SB800

Paul Walmsley (1):
      OMAP1 clock: fix for "BUG: spinlock lockup on CPU#0"

Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
      [SCSI] aacraid: fix File System going into read-only mode

Peter Horton (1):
      UBI: initialise update marker

Peter Huewe (1):
      [WATCHDOG] ixp2000: Fix build failure caused by missing include

Peter Korsgaard (1):
      hmt: adjust for new pwm_backlight->notify prototype

Peter Ujfalusi (1):
      OMAP3: PM: Enable wake-up from McBSP2, 3 and 4 modules

Rajendra Nayak (2):
      OMAP4: PRCM: Fix the base address for CHIRONSS reg defines
      OMAP4: clocks: Fix the clksel_rate struct DPLL divs

Ram Vepa (1):
      S2io: two branches the same in wait_for_cmd_complete()

Reinette Chatre (1):
      iwlwifi: add license to tracing files

Robert P. J. Day (1):
      sparc: Simplify param.h by simply including <asm-generic/param.h>

Roel Kluin (6):
      sparc: leds_resource.end assigned to itself in clock_board_probe()
      appletalk:: da.s_net not copied but assigned to itself in aarp_rcv()
      netlink: With opcode INET_DIAG_BC_S_LE dport was compared in inet_diag_bc_run()
      OMAP: dma_chan[lch_head].flag & OMAP_DMA_ACTIVE tested twice in omap_dma_unlink_lch()
      e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of unsigned in *_tx_map()
      OMAP: omap3_pm_get_suspend_state() error ignored in pwrdm_suspend_get()

Ron Murray (1):
      Please add support for Microsoft MN-120 PCMCIA network card

Russ Anderson (1):
      x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.

Russell King (2):
      OMAP3: clock: Remove unnecessarily .init initializers from OMAP3 clocks
      [ARM] Update mach-types

Russell King - ARM Linux (1):
      mtd: Really add ARM pismo support

Saeed Bishara (1):
      [ARM] Kirkwood: drive USB VBUS pin on rd88f6192-nas high on boot

Samuel Ortiz (1):
      iwmc3200wifi: Add UMAC wifi headers to the pmkid command

Sanjeev Premi (1):
      OMAP3: PM: Remove duplicate code blocks

Sathya Perla (2):
      be2net: fix bug in rx page posting
      be2net: swap only first 2 fields of mcc_wrb

Sergio Aguirre (1):
      PM debug: Fix warning when no CONFIG_DEBUG_FS

Sheng Yang (1):
      KVM: x86: Fix host_mapping_level()

Sridhar Samudrala (1):
      net: Fix IPv6 GSO type checks in Intel ethernet drivers

Sripathy, Vishwanath (1):
      OMAP3: PM: Removing redundant and potentially dangerous PRCM configration

Stefan Haberland (1):
      [S390] dasd: fix possible NULL pointer errors

Stefan Richter (4):
      firewire: core: add_descriptor size check
      firewire: cdev: add_descriptor documentation fix
      firewire: core: fix use-after-free regression in FCP handler
      firewire: ohci: fix crashes with TSB43AB23 on 64bit systems

Stephen Hemminger (1):
      tcp_probe: avoid modulus operation and wrap fix

Subramani Venkatesh (1):
      OMAP3: PM: DSS PM_WKEN to refill DMA

Swen Schillig (3):
      [SCSI] scsi_transport_fc: Allow LLD to reset FC BSG timeout
      [SCSI] zfcp: Introduce bsg_timeout callback.
      [SCSI] zfcp: Set hardware timeout as requested by BSG request.

Takashi Iwai (3):
      ALSA: hda - Fix parsing pin node 0x21 on ALC259
      ALSA: hda - Turn on EAPD only if available for Realtek codecs
      ALSA: hda - Fix HP T5735 automute

Tero Kristo (7):
      OMAP3: PM: Ack pending interrupts before entering suspend
      OMAP3: PM: Enable system control module autoidle
      OMAP3: PM: Disable interrupt controller AUTOIDLE before WFI
      OMAP3: CPUidle: Fixed timer resolution
      OMAP3: Fixed ARM aux ctrl register save/restore
      OMAP3: PM: Force write last pad config register into save area
      OMAP2/3: DMTIMER: Clear pending interrupts when stopping a timer

Thara Gopinath (1):
      OMAP3: hwmod: Adding flag to prevent caching of sysconfig register.

Thomas Hellstrom (11):
      drm/vmwgfx: Don't promote updates from GMR-backed scanouts to fullscreen.
      drm/vmwgfx: Fix an error path causing an oops.
      drm/vmwgfx: Make fence sequences continous across a VT switch.
      drm/vmwgfx: Use bo_driver::move_notify to unbind GMRs.
      drm/ttm: Add a swap_notify callback.
      drm/vmwgfx: Implement a swap_notify callback.
      drm/ttm: Export symbols needed for vmwgfx suspend / resume operations.
      drm/vmwgfx: Implement basic pm operations.
      drm/ttm: Make sure system buffer objects has offset == 0.
      drm/ttm: Allow system memory as a busy placement.
      drm/vmwgfx: Optimize memory footprint for DMA buffers.

Tony Lindgren (3):
      omap: Fix cmdline muxing
      omap: Fix functions for dynamic remuxing of pins
      omap3: Fix cpu detection

Uwe Kleine-König (1):
      i2c: imx: call ioremap only after request_mem_region

Valentin Longchamp (1):
      i2c: mxc: let time to generate stop bit

Wei Yongjun (2):
      KVM: x86: Fix probable memory leak of vcpu->arch.mce_banks
      KVM: x86: Fix leak of free lapic date in kvm_arch_vcpu_init()

Wey-Yi Guy (1):
      iwlwifi: Fix throughput stall issue in HT mode for 5000

Wu Zhangjin (1):
      MIPS: Add support of LZO-compressed kernels

Xavier Chantry (1):
      drm/nouveau: fix edid memleak in nouveau_connector

Xiaotian Feng (1):
      clockevent: Don't remove broadcast device when cpu is dead

Yang Hongyang (1):
      Btrfs: fix a memory leak in btrfs_init_acl

Zhenyu Wang (1):
      drm: fix regression in fb blank handling

stephen hemminger (1):
      sky2: revert config space change

£ukasz Wojni³owicz (1):
      ALSA: hda - add possibility to choose speakers configuration for 4930g
