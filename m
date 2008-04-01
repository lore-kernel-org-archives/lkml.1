Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYDAUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYDAUJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYDAUJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:09:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099AbYDAUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:09:00 -0400
Date: Tue, 1 Apr 2008 13:08:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc8
Message-ID: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No cute April 1st shenanigans, just a regular -rc release that happened to 
come up today because I was waiting for the input layer oops-fixes to be 
ready and tested.

I think the dirstat continues to be fairly informative, with arch/ and 
drivers dominating as usual. And within arch, a fair amount of the line 
noise are all those defconfigs. I wish we had some saner way of handling 
that, but apart from causing noise in the statistics there aren't any real 
downsides. Anyway, here is:

	  15.2% arch/mips/configs/
	  17.5% arch/mips/
	   2.3% arch/powerpc/configs/
	   3.1% arch/powerpc/
	   7.8% arch/sparc64/kernel/
	   8.1% arch/sparc64/
	   4.3% arch/x86/kernel/
	   2.0% arch/x86/lguest/
	   3.2% arch/x86/mach-rdc321x/
	  11.0% arch/x86/
	  40.6% arch/
	   2.2% drivers/char/
	   2.6% drivers/lguest/
	   2.3% drivers/net/igb/
	   8.7% drivers/net/netxen/
	   2.1% drivers/net/phy/
	  15.8% drivers/net/
	  30.6% drivers/
	   4.7% fs/
	   5.0% include/asm-sh/
	   8.6% include/
	   3.9% net/
	   7.5% scripts/

but the bulk of the fixes are the usual random one-liners. Some of the 
"bulk" above (like the arch/x86/kernel changes) are actually just moving 
some functions around in a file, so they look like larger diffs than they 
actually are.

A lot of the one-liners are some sparse cleanups, which is probably 
unnecessary noise at this point, but when Al sends me a series I just tend 
to apply it because his patches tend to be rather careful and basically 
always correct.

The big thing that is actually *noticeable* to most people is that this 
should fix the two top regressions: we've had some suspend-resume 
regressions due to the stupid ACPI _PTS orderign issues, and while the 
cleanups were left, the ordering changes were reverted. So that should fix 
issues for some people (of course, the people who had it fixed are 
unhappy, but regressions are worse).

The other thing that bit a number of people and is now fixed (and that 
also probably often showed up as a suspend/resume regression) was some 
"struct device" lifetime changes that broke the input layer. Thanks to 
people who debugged that one.

So give it a test. And update your regression entries..

		Linus

---
Adrian Bunk (2):
      sound/oss/ac97_codec.c: restore MODULE_LICENSE
      remove include/asm-sh/floppy.h

Al Viro (33):
      wavelan_cs arm fix
      igb: endianness fix
      igb trivial annotations
      e100: endianness annotations
      reduce stack footprint in namespace.c
      count ghost references to vfsmounts
      sanitize locking in mark_mounts_for_expiry() and shrink_submounts()
      do shrink_submounts() for all fs types
      mnt_expire is protected by namespace_sem, no need for vfsmount_lock
      jbd/jbd2 NULL noise
      NULL noise: fs/*, mm/*, kernel/*
      futex_compat __user annotation
      NULL noise: drivers/media
      NULL noise: drivers/misc
      ioat_dca __iomem annotations
      misc __user misannotations (pointless casts to long)
      net/rxrpc trivial annotations
      NULL noise: frv cmpxchg()
      drivers/char/n_tty.c misannotated prototype
      vma_map: use proper pointer types
      fix iomem misannotations in nozomi
      compat_sys_wait4() prototype misannotation
      cifs: fix misannotations
      dma_page_list ->base_address is a userland pointer
      virtio_pci iomem annotations
      drivers/crypto/hifn_795x.c trivial endianness annotations
      8250_pci: duplicate initializer in array ([pbn_b0_8_115200])
      fix the broken annotations in fsldma
      trivial endianness annotations: infiniband core
      powerpc/pseries/xcis: ansify
      zr364xx __user annotations
      mfd/asic3: ioread/iowrite take pointer, not unsigned long
      dm9000 trivial annotation

Alasdair G Kergon (1):
      dm io: write error bits form long not int

Alessandro Zummo (1):
      ixp4xx-beeper: add MODULE_ALIAS

Alexandr Smirnov (1):
      Marvell PHY m88e1111 driver fix

Alexey Starikovskiy (1):
      ACPI: SBS: remove typo from sbchc.c

Ananth N Mavinakayanahalli (1):
      kprobes: another MAINTAINERS update

Andres Salomon (1):
      x86: GEODE: add missing module.h include

Andrew Morton (5):
      x86: ptrace.c: fix defined-but-unused warnings
      Avoid false positive warnings in kmap_atomic_prot() with DEBUG_HIGHMEM
      drivers/char/drm/ati_pcigart.c: fix printk warning
      net/9p/trans_fd.c:p9_trans_fd_init(): module_init functions should return 0 on success
      memstick: suppress uninitialized-var warning

Andy Whitcroft (1):
      update checkpatch.pl to version 0.16

Anthony Liguori (1):
      virtio_pci: unregister virtio device at device remove

Anton Vorontsov (1):
      mtd: maps/physmap: fix oops in suspend/resume/shutdown ops

Bartlomiej Zolnierkiewicz (2):
      Revert "ide: change master/slave IDENTIFY order"
      ide: fix defining SUPPORT_VLB_SYNC

Benjamin Herrenschmidt (3):
      Give futex init a proper name
      pata_sil680: only enable MMIO on Cell blades
      drm: fix for non-coherent DMA PowerPC

Björn Steinbrink (1):
      evdev: Release eventual input device grabs when getting disconnected

Bryan Wu (2):
      smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade
      blackfin video driver: update the BF52x EZKIT video framebuffer driver according to LKML review

Christoph Hellwig (1):
      ext3: don't export ext3_fs.h and jbd.h

Christoph Lameter (3):
      count_partial() is not used if !SLUB_DEBUG and !CONFIG_SLABINFO
      x86: stricter check in follow_huge_addr()
      Fix undefined count_partial if !CONFIG_SLABINFO

Daniel Yeisley (1):
      slab: fix cache_cache bootstrap in kmem_cache_init()

Dave Airlie (2):
      drm/r300: fix bug in r300 userspace hardware wait emission
      drm/i915: fix oops on agp=off

Dave Jones (1):
      audit: silence two kerneldoc warnings in kernel/audit.c

David Brownell (1):
      leds: Remove incorrect use of preempt_count() from leds-gpio

David Howells (1):
      afs: add a MAINTAINERS record for AFS

David S. Miller (16):
      [SPARC64]: Make save_stack_trace() more efficient.
      [SPARC64]: Adjust {TLBTEMP,TSBMAP}_BASE.
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/{cpu,setup}.c
      [SPARC64]: Fix sparse errors in arch/sparc64/kernel/traps.c
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/iommu.c
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/irq.c
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/ptrace.c
      [IRDA]: Store irnet_socket termios properly.
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/time.c
      [SPARC64]: Fix most sparse warnings in arch/sparc64/kernel/sys_sparc.c
      [SPARC64]: Fix sparse warnings in arch/sparc64/kernel/signal.c
      [SPARC64]: Fix __get_cpu_var in preemption-enabled area.
      [SPARC64]: Fix allnoconfig build, ptrace.c missing CONFIG_COMPAT checks.
      [SPARC64]: Update defconfig.
      [SPARC64]: flush_ptrace_access() needs preemption disable.
      [SPARC64]: Define TASK_SIZE_OF()

Dhananjay Phadke (4):
      netxen: improve msi support
      netxen: napi and irq cleanup
      netxen: remove low level tx lock
      netxen: fix rx dropped stats

Dmitri Monakhov (1):
      vfs: fix data leak in nobh_write_end()

Dmitry Torokhov (1):
      Input: make sure input interfaces pin parent input devices

Florian Fainelli (2):
      rdc321x: GPIO routines bugfixes
      [MIPS] XSS1500: Fix compilation

Gordon Farquharson (1):
      [ARM] 4875/1: Add MODULE_ALIAS to ixp4xx-beeper module

Haavard Skinnemoen (3):
      avr32: Work around byteswap bug in gcc < 4.2
      avr32: Build fix for CONFIG_BUG=n
      avr32: Fix bug in early resource allocation code

Harvey Harrison (2):
      kernel: add bit rotation helpers for 16 and 8 bit
      drm: radeon: fix sparse integer as NULL pointer warnings in radeon_mem.c

Helge Deller (1):
      Input: apm-power - fix crash when unloading modules

Herbert Xu (1):
      [IPSEC]: Fix BEET output

Ingo Molnar (4):
      x86: add dmi quirk for io_delay
      x86: fix prefetch workaround
      x86: prefetch fix #2
      revert "ACPI: drivers/acpi: elide a non-zero test on a result that is never 0"

Jarod Wilson (1):
      firewire: fw-ohci: plug dma memory leak in AR handler

Jay Schulist (1):
      smctr.c: fix logical-bitwise-or confusion

Jay Vosburgh (3):
      bonding: Fix locking in 802.3ad mode
      bonding: fix two compiler warnings
      bonding: update version

Jean Delvare (2):
      hwmon: (w83781d) Fix I/O resource conflict with PNP
      pci: revert SMBus unhide on HP Compaq nx6110

Jeff Garzik (1):
      netxen, phy/marvell, skge: minor checkpatch fixes

Jens Axboe (1):
      relay: set an spd_release() hook for splice

Jeremy Fitzhardinge (2):
      xen: fix RMW when unmasking events
      xen: fix UP setup of shared_info

Jesper Juhl (1):
      driver core: fix small mem leak in driver_add_kobj()

John W. Linville (1):
      arlan: fix warning when PROC_FS=n

Jonathan Corbet (1):
      in_atomic(): document why it is unsuitable for general use

Julia Lawall (2):
      ixgb: remove unused variable
      ACPI: drivers/acpi: elide a non-zero test on a result that is never 0

Jussi Kivilinna (1):
      rndis_host: fix oops when query for OID_GEN_PHYSICAL_MEDIUM fails

Kazunori MIYAZAWA (1):
      [IPSEC]: Fix inter address family IPsec tunnel handling.

Lai Jiangshan (1):
      set relay file can not be read by pread(2)

Len Brown (1):
      pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."

Libor Pechacek (1):
      bonding: Fix sysfs attribute handling

Linus Torvalds (3):
      Revert "PCI: remove transparent bridge sizing"
      Revert "SLUB: remove useless masking of GFP_ZERO"
      Linux 2.6.25-rc8

Marcin Slusarz (1):
      x86, documentation: nmi_watchdog=2 works on x86_64

Marin Mitov (1):
      skge napi->poll() locking bug

Mark Lord (1):
      fix uevent action-string regression

Masakazu Mokuno (1):
      rt2x00: Add id for Corega CG-WLUSB2GPX

Masami Hiramatsu (1):
      kprobes: MAINTAINERS update

Michael Buesch (3):
      b43: Fix DMA mapping leakage
      b43: Remove irqs_disabled() sanity checks
      b44: Truncate PHY address

Michael Ellerman (1):
      [POWERPC] Fix missed hardware breakpoints across multiple threads

Michael Hennerich (1):
      blackfin video driver: fix bug when opening/reading/mmaping BF54x and BF52x framebuffer simultaneously

Mike Rapoport (1):
      [ARM] 4873/1: Fix ITE 8152 interrupt demux

Mikulas Patocka (1):
      plip: replace spin_lock_irq with spin_lock_irqsave in irq context

Milan Broz (1):
      dm crypt: fix ctx pending

Nick Andrew (1):
      x86: Documentation/i386/IO-APIC.txt: fix description

Nishanth Aravamudan (2):
      hugetlb: indicate surplus huge page counts in per-node meminfo
      hugetlb: fix potential livelock in return_unused_surplus_hugepages()

Oliver Schuster (1):
      [WATCHDOG] Fix it8712f_wdt.c wrong byte order accessing WDT_TIMEOUT

Olof Johansson (1):
      [POWERPC] update pasemi_defconfig

Pascal Terjan (1):
      iwlwifi: fix a typo in Kconfig message

Patrick McHardy (3):
      [VLAN]: Don't copy ALLMULTI/PROMISC flags from underlying device
      [UML]: uml-net: don't set IFF_ALLMULTI in set_multicast_list
      [NET]: Fix multicast device ioctl checks

Paul Bolle (1):
      lguest: lguest.txt documentation fix

Paul Mundt (2):
      sh: Fix occasional FPU register corruption under preempt.
      sh: Fix TIF_USEDFPU clearing under FPU emulation.

Pavel Emelyanov (2):
      [NEIGH]: Fix race between pneigh deletion and ipv6's ndisc_recv_ns (v3).
      [ICMP]: Dst entry leak in icmp_send host re-lookup code (v2).

Peter Korsgaard (3):
      dm9601: add Hirose USB-100 device ID
      dm9601: configure MAC to drop invalid (crc/length) packets
      dm9000: Support promisc and all-multi modes

Rafael J. Wysocki (1):
      ACPI PM: Restore the 2.6.24 suspend ordering

Ralf Baechle (3):
      [MIPS] VPE loader: Check result of memory allocation.
      [MIPS] I8253: Export i2853_lock to modules.
      [MIPS] Bigsur: make defconfig more useful.

Randy Dunlap (1):
      x86: convert mtrr/generic.c to kernel-doc

Reinette Chatre (2):
      MAINTAINERS: update iwlwifi git url
      iwlwifi: fix __devexit_p points to __devexit functions

Rick Farrington (1):
      iwlwifi: mac start synchronization issue

Riku Voipio (1):
      [ARM] 4878/1: Add oabi shim for fstatat64

Robert P. J. Day (1):
      [AX25]: Remove obsolete references to BKL from TODO file.

Roland Dreier (2):
      cxgb3: Fix lockdep problems with sge.reg_lock
      RDMA/cxgb3: Program hardware IRD with correct value

Rusty Russell (2):
      lguest: Don't need comment terminator before disk section.
      lguest: comment documentation update.

Samuel Ortiz (1):
      Input: pxa27x - fix keypad KPC macros

Sebastian Siewior (1):
      mtd: nand: add out label in rfc_from4

Sergei Shtylyov (1):
      [MIPS] Alchemy: work around clock misdetection on early Au1000

Sreenivasa Honnur (1):
      S2io: Handle TX completions on the same CPU as the sender for MIS-X interrupts

Stephan Diestelhorst (1):
      x86, cpufreq: fix Speedfreq-SMI call that clobbers ECX

Suresh Siddha (1):
      x86: fix performance drop for glx

Sven Schnelle (1):
      afs: prevent double cell registration

Tejun Heo (1):
      libata: ATA_EHI_LPM should be ATA_EH_LPM

Thomas Bogendoerfer (3):
      [MIPS] Check for GCC r10k-cache-barrier support
      [MIPS] BCM1480: Fix PCI/HT IO access
      [MIPS] Add missing 4KEC TLB refill handler

Thomas Gleixner (2):
      clocksource: revert: use init_timer_deferrable for clocksource_watchdog
      NOHZ: reevaluate idle sleep length after add_timer_on()

Thomas Klein (1):
      ehea: Fix IPv6 support

Tim Ansell (1):
      lguest: Add puppies which where previously missing.

Tom Tucker (1):
      SVCRDMA: Check num_sge when setting LAST_CTXT bit

Uwe Kleine-König (1):
      leds: Fix potential leds-gpio oops

Venki Pallipadi (2):
      ACPI: fix mis-merge -- invoke acpi_unlazy_tlb() only on C3 entry
      cpuidle: fix 100% C0 statistics regression

YAMAMOTO Takashi (1):
      memcgroup: fix spurious EBUSY on memory cgroup removal

Yi Yang (1):
      cpuidle: fix cpuidle time and usage overflow

Yinghai Lu (2):
      x86: fix memoryless node oops during boot
      x86: fix trim mtrr not to setup_memory two times

Yoichi Yuasa (1):
      [MIPS] Fix the installation condition of MIPS clocksource

Yoshihiro Shimoda (1):
      sh: Fix up uImage compression type

Zhang Rui (1):
      ACPI: fix a regression of ACPI device driver autoloading

