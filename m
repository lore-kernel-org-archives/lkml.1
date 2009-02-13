Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbZBMWVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbZBMWVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZBMWVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:21:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbZBMWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:21:23 -0500
Date: Fri, 13 Feb 2009 14:20:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.29-rc5
Message-ID: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's a (faked) magical moment to release a kernel, so there it is. 

The dirstat shows it all:

  88.6% drivers/net/
   4.9% drivers/staging/at76_usb/

ie practically all of the changes come from some driver updates, the bnx2 
firmware update, and one of the staging drivers. And even there, the bulk 
of the changes to the at76_usb driver was actually a revert.

All the rest is pretty much a collection of trivial small fixes. Yes, 
there's a Intel SVDO update that shows up in diffstat, but the rest 
really is pretty tiny.

Which is just how I like it.

So go out and test the heck out of it, because I'm going to spend the 
three-day weekend drunk at the beach. Because somebody has to do it.

		Linus

---
Adrian-Ken Rueegsegger (1):
      crypto: shash - Fix module refcount

Alan Stern (2):
      USB: usb-storage: remove WARN from last-sector hacks
      USB: usb-storage: add Pentax to the bad-vendor list

Alex Chiang (1):
      x86: fix grammar in user-visible BIOS warning

Alex Williamson (1):
      tun: Fix unicast filter overflow

Alok Kataria (1):
      x86, vmi: put a missing paravirt_release_pmd in pgd_dtor

Ananth N Mavinakayanahalli (1):
      powerpc: Don't emulate mr. instructions

Andres Salomon (2):
      gxfb: properly alloc cmap and plug cmap leak
      gx1fb: properly alloc cmap and plug cmap leak

Andrew Morton (2):
      net: don't use in_atomic() in gfp_any()
      Documentation/connector/cn_test.c: don't use gfp_any()

Anton Vorontsov (8):
      powerpc/83xx: Fix missing #{address,size}-cells in mpc8313erdb.dts
      powerpc/83xx: Fix TSEC0 workability on MPC8313E-RDB boards
      USB: fsl_qe_udc: Fix oops on QE UDC probe failure
      USB: fsl_qe_udc: Fix recursive locking bug in ch9getstatus()
      USB: fsl_qe_udc: Fix QE USB controller initialization
      USB: fsl_qe_udc: Fix disconnects reporting during bus reset
      USB: fsl_qe_udc: Fix muram corruption by disabled endpoints
      USB: fsl_qe_udc: Fix stalled TX requests bug

Arnd Bergmann (1):
      sound: Remove OSSlib stuff from linux/soundcard.h

Arve Hjønnevåg (1):
      Staging: android: ram_console: Disable ECC when early init is enabled and validate buffer size

Balaji Rao (1):
      pcf50633_charger: Fix typo

Benjamin Herrenschmidt (1):
      powerpc/pci: mmap anonymous memory when legacy_mem doesn't exist

Bob Copeland (1):
      ath5k: fix bf->skb==NULL panic in ath5k_tasklet_rx

Borislav Petkov (1):
      x86/Kconfig.cpu: make Kconfig help readable in the console

Carsten Otte (1):
      ext2/xip: refuse to change xip flag during remount with busy inodes

Chris Mason (1):
      Btrfs: don't use spin_is_contended

Chris Wilson (2):
      drm/i915: Unref the object after failing to set tiling mode.
      drm/i915: Unlock mutex on i915_gem_fault() error path

Chuck Ebbert (1):
      pkt_sched: type should be __u32 in header

Clemens Ladisch (1):
      i8327: fix outb() parameter order

Clément Lecigne (1):
      net: 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt try #2

Cornelia Huck (1):
      [S390] dasd: bus_id -> dev_name() conversion.

Daisuke Nishimura (1):
      migration: migrate_vmas should check "vma"

Dan Carpenter (1):
      USB: ftdi_sio: unlock_kernel() on error in set_serial_info()

Dave Airlie (2):
      i915: fix unneeded locking in i915 LVDS get modes code.
      drm/radeon: fix ioremap conflict with AGP mappings

Dave Young (1):
      USB: usb-serial: fix the aircable_init failure path

David Howells (2):
      RxRPC: Fix a potential NULL dereference
      FRV: in_interrupt() requires #inclusion of linux/hardirq.h not asm/hardirq.h now

David S. Miller (7):
      sparc64: Call dump_stack() in die_nmi().
      sparc64: Don't hook up pcr_ops on spitfire chips.
      ipv6: Disallow rediculious flowlabel option sizes.
      net_dma: call dmaengine_get only if NET_DMA enabled
      sunhme: Don't match PCI devices in SBUS probe.
      sparc64: Kill .fixup section bloat.
      sparc64: Fix probe_kernel_{read,write}().

Dhananjay Phadke (2):
      netxen: fix msi-x interrupt handling
      netxen: remove pcie workaround

Dirk De Schepper (1):
      USB: option: New mobile broadband modems to be supported

Eero Nurkkala (1):
      ASoC: TLV320AIC3X: Fix kcontrol's private value use in put callback

Eric Anholt (5):
      drm/i915: Suppress GEM teardown on X Server exit in KMS mode.
      drm/i915: Skip SDVO/HDMI init when the chipset tells us it's not present.
      drm/i915: Set up an MTRR covering the GTT at driver load.
      drm/i915: Return error from i915_gem_object_get_fence_reg() when failing.
      drm/i915: Quiet the message on get/setparam ioctl with an unknown value.

Eric Leblond (2):
      netfilter: fix tuple inversion for Node information request
      netfilter: nf_conntrack_ipv6: don't track ICMPv6 negotiation message

Eric Miao (3):
      [ARM] pxa: fix missing of __REG() definition for ac97 registers access
      [ARM] pxa: make more SSCR0 bit definitions visible on multiple processors
      [ARM] pxa: stop and disable IRQ for each DMA channels at startup

Eric Van Hensbergen (1):
      9p: fix endian issues [attempt 3]

Federico Cuello (1):
      writeback: fix break condition

Gautam Kachroo (1):
      neigh: some entries can be skipped during dumping

Greg Kroah-Hartman (3):
      Revert USB: option: add Pantech cards
      Revert Staging: at76_usb: update drivers/staging/at76_usb w/ mac80211 port
      Staging: android: fix up units in timed_gpio

Heiko Carstens (1):
      syscall define: fix uml compile bug

Herbert Xu (5):
      crypto: api - Fix algorithm test race that broke aead initialisation
      crypto: api - Fix zeroing on free
      crypto: shash - Fix tfm destruction
      crypto: scatterwalk - Avoid flush_dcache_page on slab pages
      bridge: Fix LRO crash with tun

Herton Ronaldo Krzesinski (1):
      ALSA: hda - Change HP dv7 (103c:30f4) quirk from hp-m4 to hp-dv5 model

Hin-Tak Leung (2):
      zd1211rw: adding 0ace:0xa211 as a ZD1211 device
      zd1211rw: treat MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for TP-Link WN322/422G

Hugh Dickins (2):
      mm: fix error case in mlock downgrade reversion
      profiling: fix broken profiling regression

Ian Dall (1):
      w1: w1 temp calculation overflow fix

Ilkka Virta (1):
      sungem: Soft lockup in sungem on Netra AC200 when switching interface up

Inaky Perez-Gonzalez (1):
      wimax: fix oops in wimax_dev_get_by_genl_info() when looking up non-wimax iface

Ingo Molnar (2):
      timers: split process wide cpu clocks/timers, remove spurious warning
      drm/i915: select framebuffer support automatically

Ivan Kuten (1):
      USB: Correct Makefile to make isp1760 buildable

Ivan Vecera (1):
      r8169: Don't update statistics counters when interface is down

J. Bruce Fields (1):
      lockd: fix regression in lockd's handling of blocked locks

James Treacy (1):
      USB: cdc-acm.c: remove duplicate lines for MTK gps support

Jamie Lentin (1):
      Staging: at76_usb: Add support for OQO Model 01+

Jan Kara (2):
      jbd: fix return value of journal_start_commit()
      ext3: revert "ext3: wait on all pending commits in ext3_sync_fs"

Jarek Poplawski (1):
      gianfar: Fix boot hangs while bringing up gianfar ethernet

Jarkko Nikula (1):
      ASoC: WM8990: Fix kcontrol's private value use in put callback

Jason Andryuk (1):
      Staging: at76_usb: fix bugs introduced by "Staging: at76_usb: cleanup dma on stack issues"

Jeremy Fitzhardinge (2):
      x86: don't apply __supported_pte_mask to non-present ptes
      mm: rearrange exit_mmap() to unlock before arch_exit_mmap

Jesper Dangaard Brouer (1):
      udp: Fix potential wrong ip_hdr(skb) pointers

Jesse Barnes (4):
      drm/i915: add fence register management to execbuf
      drm/i915: sync SDVO code with stable userland modesetting driver
      drm/i915: capture last_vblank count at IRQ uninstall time too
      drm/i915: add get_vblank_counter function for GM45

Jiri Slaby (1):
      parport: parport_serial, don't bind netmos ibm 0299

Johannes Berg (1):
      mac80211: restrict to AP in outgoing interface heuristic

Julia Lawall (3):
      arch/powerpc: Eliminate double sizeof
      drivers/atm: introduce missing kfree
      drivers/isdn: introduce missing kfree

KAMEZAWA Hiroyuki (1):
      memcg: use __GFP_NOWARN in page cgroup allocation

KOSAKI Motohiro (1):
      cgroups: add Li Zefan as a maintainer

Kirill A. Shutemov (1):
      mm: Export symbol ksize()

Kumar Gala (2):
      powerpc/fsl-booke: Fix mapping functions to use phys_addr_t
      powerpc/mm: Fix _PAGE_COHERENT support on classic ppc32 HW

Kyle McMartin (3):
      x86, 64-bit: print DMI info in the oops trace
      x86: disable intel_iommu support by default
      x86: spinlocks: define dummy __raw_spin_is_contended

Li Zefan (1):
      cgroups: fix lockdep subclasses overflow

Linus Torvalds (2):
      i915: Fix more size_t format string warnings
      Linux 2.6.29-rc5

Lopez Cruz, Misael (1):
      ASoC: Update SDP3430 machine driver for snd_soc_card

Mackenzie Morgan (1):
      ALSA: hda - Add quirk for Asus z37e (1043:8284)

Marcel Selhorst (1):
      tpm: correct email address for tpm_infineon-driver

Marco La Porta (1):
      lxfb: properly alloc cmap in all cases and don't leak the memory

Mark Brown (1):
      ASoC: Only register AC97 bus if it's not done already

Mark Langsdorf (1):
      [CPUFREQ] powernow-k8: Get transition latency from ACPI _PSS table

Martin Schwidefsky (2):
      [S390] vdso: fix per cpu vdso pointer in lowcore
      [S390] Update default configuration.

Meelis Roos (2):
      fore200: fix oops on failed firmware load
      sunhme: Fix Quattro HME irq registration on proble failures

Mel Gorman (2):
      Do not account for the address space used by hugetlbfs using VM_ACCOUNT
      Do not account for hugetlbfs quota at mmap() time if mapping [SHM|MAP]_NORESERVE

Michael Chan (4):
      bnx2: Update 5706/5708 firmware.
      bnx2: Update 5709 firmware.
      bnx2: Fix jumbo frames error handling.
      bnx2: Update version to 1.9.2 and copyright.

Michael Neuling (3):
      powerpc/83xx: Build breakage for CONFIG_PM but no CONFIG_SUSPEND
      powerpc/cell: Add missing #include for oprofile
      powerpc: Add missing sparsemem.h include

Mike Rapoport (1):
      [ARM] pxa: fix NAND and MMC clock initialization for pxa3xx

MinChan Kim (1):
      mm: fix mlocked page counter mismatch

Nick Holloway (1):
      USB: Storage: Update unusual_devs entry for Datafab KECF-USB

Nick Piggin (1):
      Fix page writeback thinko, causing Berkeley DB slowdown

Noriaki TAKAMIYA (1):
      IPv6: fix to set device name when new IPv6 over IPv6 tunnel device is created.

Oleg Nesterov (1):
      ptrace, x86: fix the usage of ptrace_fork()

Oliver Neukum (1):
      USB: two more usb ids for ti_usb_3410_5052

Ondrej Zary (1):
      3c509: Fix resume from hibernation for PnP mode.

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: allow changing NAT sequence adjustment in creation
      netfilter: ctnetlink: fix echo if not subscribed to any multicast group

Pallipadi, Venkatesh (1):
      x86: add clflush before monitor for Intel 7400 series

Paul Clements (1):
      nbd: fix I/O hang on disconnected nbds

Paul Collins (1):
      drm/i915: skip LVDS initialization on Apple Mac Mini

Paulius Zaleckas (1):
      mdio-gpio: Add mdc pin direction initialization

Pavel Emelyanov (2):
      x86: fix hpet timer reinit for x86_64
      x86: clean up hpet timer reinit

Peter Zijlstra (5):
      signal: re-add dead task accumulation stats.
      timers: split process wide cpu clocks/timers
      timers: split process wide cpu clocks/timers, fix
      timers: fix TIMER_ABSTIME for process wide cpu timers
      sched: revert recent sync wakeup changes

Qu Haoran (1):
      netfilter: xt_sctp: sctp chunk mapping doesn't work

Randy Dunlap (2):
      kernel-doc: preferred ending marker and examples
      kernel-doc: fix syscall wrapper processing

Reinette Chatre (1):
      iwlwifi: fix suspend/resume and its usage of pci saved state

Risto Suominen (1):
      de2104x: force correct order when writing to rx ring

Robert Jarzmik (1):
      rtc: update maintainership of pxa rtc driver

Roel Kluin (6):
      [ARM] AACI: timeout will reach -1
      rtc: t reaches -1, tested 0
      TG3: limit reaches -1
      sun3: print when lance_open() fails
      IRDA: cnt is off by 1
      3c505: do not set pcb->data.raw beyond its size

Ron Mercer (7):
      qlge: bugfix: Use netif_receive_skb() and vlan_hwaccel_receive_skb().
      qlge: bugfix: Fix fatal error recovery hang.
      qlge: bugfix: Add missing put_page() call.
      qlge: bugfix: Add missing dev_kfree_skb_any() call.
      qlge: bugfix: Fix TSO breakage.
      qlge: bugfix: Fix RX scaling values.
      qlge: bugfix: Add missing rx buf clean index on early exit.

Rémi Denis-Courmont (2):
      Phonet: fix double free in GPRS outbound packet error path
      Phonet: do not compute unused value

Sachin P. Sant (1):
      Staging: panel: fix lcd panel driver build failure

Sachin Sant (1):
      [S390] Fix init irq proc build break.

Serge E. Hallyn (1):
      User namespaces: Only put the userns when we unhash the uid

Stefan Richter (1):
      hugetlbfs: fix build failure with !CONFIG_HUGETLBFS

Stefan Weinhuber (1):
      [S390] dasd: fix race in dasd timer handling

Stephane Clerambault (1):
      USB: ftdi_sio: add support for the NDI Polaris system

Steven Rostedt (3):
      powerpc/ftrace: Fix math to calculate offset in TOC
      tracing, x86: fix fixup section to return to original code
      tracing, x86: fix constraint for parent variable

Suresh Siddha (1):
      sched: fix nohz load balancer on cpu offline

Sven Wegener (1):
      mm: fix dirty_bytes/dirty_background_bytes sysctls on 64bit arches

Takashi Iwai (4):
      ALSA: mtpav - Fix initial value for input hwport
      ALSA: hda - Register (new) devices at reconfig
      ALSA: hda - Add missing terminator in slave dig-out array
      ALSA: hda - Add snd_hda_multi_out_dig_cleanup()

Tejun Heo (3):
      x86: include correct %gs in a.out core dump
      x86: math_emu info cleanup
      x86: fix math_emu register frame access

Tobias Klauser (1):
      [ARM] Storage class should be before const qualifier

Uwe Kleine-Koenig (1):
      video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver

Venkatesh Pallipadi (1):
      [CPUFREQ] Make ignore_nice_load setting of ondemand work as expected.

Wu Fengguang (4):
      ALSA: hda - allow multi-channel HDMI audio playback when ELD is not present
      ALSA: hda - enable HDMI audio pin out at module loading time
      ALSA: hda - compute checksum in HDMI audio infoframe
      ALSA: hda - add id for Intel IbexPeak integrated HDMI codec

Yang Hongyang (1):
      netxen: fix compile waring "label ‘set_32_bit_mask’ defined but not used" on IA64 platform

Yinghai Lu (1):
      x86: find nr_irqs_gsi with mp_ioapic_routing

paulfax (1):
      powerpc/cpm2: Fix set interrupt type
