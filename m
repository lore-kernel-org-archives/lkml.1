Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYKBWqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYKBWqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYKBWqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:46:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYKBWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:46:33 -0500
Date: Sun, 2 Nov 2008 14:46:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc3
Message-ID: <alpine.LFD.2.00.0811021430240.3459@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc.

Unlike -rc2, this one isn't just "critical brown-paper-bag fixes", and is 
more in line with a normal -rc. Yeah, I was hoping for a nice calm week, 
and it really wasn't that bad, but it's also certainly not the small 
minimal kind of -rc that -rc2 was.

>From a diffstat standpoint, about 2/3rds are architectyre updates: mainly 
mips, SH and CRIS. Some of it is defconfig files, some of it is header 
file removal (cris header file movement included removing a number of 
stale headers), some of it is just updates.

Another 1/4 of the changes are drivers (input, hid, edac and pcmcia 
updates), and the rest is a smattering of fixes all over (with perhaps 
ftrace standing out a bit).

The one change I'm personally most interested in is the impact of the 
resource handling changes: since 2.6.27 we've changed the order in which 
we scan resources on x86, so that PCI scanning now sets up its resources 
before we do the e820 resouce entries. That, in turn, can cause changes in 
where we allocate PCI devices.

We already found and fixed one regression that caused, but I really am 
very interested in getting wide testing of the new order across as wide a 
range of machines as possible. It would be especially interesting to hear 
from people who have older machines, which are often under-represented in 
the early -rc testing.

I'm including the shortlog - it's big enough that perhaps it's a bit 
ovwewhelming and people don't end up finding it all that useful, but it 
does get a flavor of the changes. 

		Linus

---
Adrian Bunk (1):
      MIPS: RB532: Fix build error

Al Viro (8):
      saner FASYNC handling on file close
      oss: fix O_NONBLOCK in dmasound_core
      PM_TEST_SUSPEND should depend on RTC_CLASS, not RTC_LIB
      section fixes for cirrusfb
      missing dependencies on HAVE_CLK in drivers/mfd
      el3_common_init() should be __devinit, not __init
      sparc32: kernel/trace/trace.c wants DIE_OOPS
      sparc32: kernel/trace/trace.c wants DIE_OOPS

Alan Cox (13):
      pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
      pcmcia: Whine harder about use of EXCLUSIVE
      fdomain_cs: Sort out modules with duplicate description
      sound: use a common working email address
      Tidy up addresses in random drivers
      Switch to a valid email address...
      ata: Switch all my stuff to a common address
      pata_ninja32: suspend/resume support
      Switch all my contributions stuff to a single common address
      Rationalise Randy's address a bit
      nfsd: fix vm overcommit crash
      tty: Fix USB kref leak
      ide: Switch to a common address

Alan Jenkins (2):
      tracing/fastboot: fix bootgraph.pl to run with "use strict"
      tracing/fastboot: fix row order in bootgraph.pl

Alan Stern (3):
      USB: fix crash when URBs are unlinked after the device is gone
      USB: prevent autosuspend during hub initialization
      HID: add quirk entry for no-name keyboard (0x13ba/0x0017)

Alexander Beregalov (1):
      IRDA: remove double inclusion of module.h

Alexey Dobriyan (5):
      .gitignore updates
      init/do_mounts_md.c: msleep compile fix
      netns: add register_pernet_gen_subsys/unregister_pernet_gen_subsys
      netfilter: nf_conntrack_proto_gre: switch to register_pernet_gen_subsys()
      key: fix setkey(8) policy set breakage

Andi Kleen (2):
      HID: Remove "default m" for Thrustmaster and Zeroplus
      sysfs: Fix return values for sysdev_store_{ulong,int}

Andreas Schwab (1):
      HID: fix hid_device_id for cross compiling

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Arjan Opmeer (1):
      Input: psmouse - add support for Elantech touchpads

Arjan van de Ven (2):
      pci: use pci_ioremap_bar() in sound/
      [WATCHDOG] pci: use pci_ioremap_bar() in drivers/watchdog

Ashutosh Naik (1):
      kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module

Atsushi Nemoto (9):
      MIPS: Set positive error number to errno on illegal_syscall
      MIPS: Set ENOSYS to errno on illegal system call number for syscall(2)
      MIPS: TXx9: 7 segment LED support
      MIPS: RBTX4939: Add smc91x support
      MIPS: TXx9: Fix RBTX4939 ethernet address initialization
      MIPS: RBTX4927: Add GPIO-LED support
      tx4938ide: Check minimum cycle time and SHWT range (v2)
      tx4938ide: Do not call devm_ioremap for whole 128KB
      tx4938ide: Avoid underflow on calculation of a wait cycle

Avi Kivity (1):
      KVM: Future-proof device assignment ABI

Bastien Nocera (1):
      ALSA: intel8x0 - add Dell Optiplex GX620 (AD1981B) to AC97 clock whitelist

Benjamin Herrenschmidt (2):
      edac: fix enabling of polling cell module
      powerpc/pci: Fix unmapping of IO space on 64-bit

Bob Copeland (3):
      ath5k: correct misspelling in debug help
      ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode
      ath5k: add self to MAINTAINERS

Borislav Petkov (2):
      ide-cd: fix DMA alignment regression
      ide-gd: re-get capacity on revalidate

Brice Goglin (1):
      myri10ge: fix stop/go mmio ordering

Carl Love (1):
      powerpc/cell/OProfile: Fix on-stack array size in activate spu profiling function

Chris Friesen (1):
      amd8111e: Fix rx return code

Chris Lalancette (1):
      xen: fix Xen domU boot with batched mprotect

Chris Malley (1):
      USB: usbtmc: Use explicit unsigned type for input buffer instead of char*

Christian Borntraeger (2):
      [S390] pgtables: Fix race in enable_sie vs. page table ops
      [S390] s390: Fix build for !CONFIG_S390_GUEST + CONFIG_VIRTIO_CONSOLE

Christian Lamparter (2):
      p54: fix misbehavings when firmware can't be found
      p54: fix build warnings

Chuck Lever (1):
      NLM: Set address family before calling nlm_host_rebooted()

Chunbo Luo (1):
      amd8111e: fix dma_free_coherent context

Cliff Cai (1):
      ALSA: ASoC: Blackfin: update SPORT0 port selector (v2)

Cliff Wickman (1):
      x86/uv: memory allocation at initialization

Dan Nicholson (1):
      Revert "HID: Invert HWHEEL mappings for some Logitech mice"

Dan Williams (1):
      [ARM] xsc3: revert writethrough memory-type encoding change

Daniel Laird (1):
      MIPS: Add support for NXP PNX833x (STB222/5) into linux kernel

Darius Augulis (1):
      [ARM] MXC: Fix mxc_gpio_get(), which must read PSR register instead DR.

David Brownell (1):
      at91_ether: request/free GPIO for PHY interrupt

David Daney (3):
      MIPS: Don't unmap the memory for dma_sync*.
      MIPS: Fix KGDB build error
      MIPS: Consider value of c0_ebase when computing value of exception base.

David Gibson (1):
      powerpc: Fix bug in kernel copy of libfdt's fdt_subnode_offset_namelen()

David Milburn (2):
      libata: ahci enclosure management led sync
      libata: ahci enclosure management bit mask

David S. Miller (4):
      sparc64: Add missing null terminating entry to bq4802_match[].
      pppoe: Fix socket leak.
      net: Really remove all of LOOPBACK_TSO code.
      sparc64: Kill annoying warning when building compat_binfmt_elf.o

David Vrabel (1):
      uwb: build UWB before USB/WUSB

Dean Nelson (1):
      sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified

Dmitri Vorobiev (2):
      MIPS: IP22: Small cleanups
      INPUT: sgi_btns: Add license specification

Dmitry Baryshkov (4):
      RFKILL: fix input layer initialisation
      [ARM] pxa/spitz: fix spi cs on spitz
      [ARM] corgi_lcd: fix simultaneous compilation with corgi_bl
      [ARM] sharpsl_pm: fix compilation w/o CONFIG_PM

Elias Oltmanns (2):
      ath5k: Reset key cache on interface up, thus fixing resume
      ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Eric Dumazet (1):
      udp: multicast packets need to check namespace

Eric Miao (1):
      leds: da903x: fix the building failure of incomplete type of 'work'

Eric Paris (1):
      SELinux: properly handle empty tty_files list

Eric Sandeen (3):
      merge ext4_claim_free_blocks & ext4_has_free_blocks
      delay capable() check in ext4_has_free_blocks()
      ecryptfs: fix memory corruption when storing crypto info in xattrs

Evgeniy Manachkin (1):
      kbuild: mkspec - fix build rpm

FUJITA Tomonori (5):
      swiotlb: remove panic for alloc_coherent failure
      x86: use GFP_DMA for 24bit coherent_dma_mask
      x86: restore the old swiotlb alloc_coherent behavior
      dmfe: check pci_alloc_consistent errors
      dbri: check dma_alloc_coherent errors

Fenghua Yu (1):
      x86/PCI: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI

Fernando Luis Vazquez Cao (1):
      spi: fix compile error

Florian Fainelli (1):
      MIPS: RB532: Set gpio interrupt status and level for CompactFlash

Florian Westphal (1):
      syncookies: fix inclusion of tcp options in syn-ack

Frank Blaschka (2):
      qeth: fix offset error in non prealloc header path
      qeth: remove unnecessary support ckeck in sysfs route6

Frank Munzert (2):
      [S390] tape block: complete request with correct locking
      [S390] tape: disable interrupts in tape_open and tape_release

Frederic Weisbecker (4):
      tracepoint: check if the probe has been registered
      tracing/ftrace: make boot tracer select the sched_switch tracer
      tracing: fix a build error on alpha
      ftrace: perform an initialization for ftrace to enable it

Gary Hade (1):
      x86: remove debug code from arch_add_memory()

Geert Uytterhoeven (3):
      MIPS: TXx9: CONFIG_TOSHIBA_RBTX4939 spelling
      MIPS: TXx9: Make firmware parameter passing more robust
      rtc: ds3234 doesn't link when built-in

Greg Kroah-Hartman (1):
      Document kernel taint flags properly

Guennadi Liakhovetski (1):
      powerpc: fix i2c on PPC linkstation / kurobox machines

Guillem Jover (1):
      ACPI: Always report a sync event after a lid state change

Hans Ulrich Niedermann (1):
      docbook: fix command spacing

Harvey Harrison (6):
      x86: two trivial sparse annotations
      x86: start annotating early ioremap pointers with __iomem
      sparc64: remove byteshifting from out* helpers
      sparc: use the new byteorder headers
      MIPS: Use the new byteorder headers
      sh: use the new byteorder headers.

Heiko Carstens (4):
      [S390] Fix sysdev class file creation.
      [S390] Change default IPL method to IPL_VM.
      [S390] No more 4kb stacks.
      lockdep: fix irqs on/off ip tracing

Hidehiro Kawai (2):
      ext3: fix a bug accessing freed memory in ext3_abort
      ext4: fix a bug accessing freed memory in ext4_abort

Hitoshi Mitake (1):
      edac x38: new MC driver module

Holger Schurig (1):
      libertas: remove two libertas sparse warning

Huang Weiyi (4):
      mlx4_en: remove duplicated #include
      viafb: removed duplicated #include's
      remove unused #include <version.h>'s
      init/do_mounts_md.c: remove duplicated #include

Hugh Dickins (1):
      sparc64: Fix __copy_{to,from}_user_inatomic defines.

Ian Campbell (1):
      kbuild: do not include arch/<ARCH>/include/asm in find-sources twice.

Ilpo Jarvinen (1):
      dm raid1: fix do_failures

Ilpo Järvinen (2):
      ALSA: sound/ice1712: indentation & braces disagree - add braces
      bpa10x: free sk_buff with kfree_skb

Ingo Molnar (4):
      ftrace: fix build failure
      ftrace: warning in kernel/trace/ftrace.c
      x86: cpu_index build fix
      x86: build fix

Isaku Yamahata (2):
      xen: portability clean up and some minor clean up for xencomm.c
      xen: compilation fix of drivers/xen/events.c on IA64

Ivo van Doorn (1):
      rt2x00: Fix build error when mac80211=M rt2x00=Y

J. Bruce Fields (1):
      nfsd: fix failure to set eof in readdir in some situations

James Bottomley (5):
      x86/voyager: fix boot breakage caused by x86: boot secondary cpus through initial_code
      x86: use CONFIG_X86_SMP instead of CONFIG_SMP
      x86/voyager: fix compile breakage casued by x86: move prefill_possible_map calling early
      x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d3510438b63c600fee1e2
      x86/voyager: fix missing cpu_index initialisation

Jan Beulich (2):
      adjust init section definitions
      i386/PAE: fix pud_page()

Jan Glauber (2):
      [S390] qdio: prevent double qdio shutdown in case of I/O errors
      [S390] qdio: remove incorrect memset

Jason Baron (1):
      Driver core: fix 'dynamic_debug' cmd line parameter

Jay Cliburn (1):
      atl1: fix vlan tag regression

Jay Fenlason (4):
      firewire: Survive more than 256 bus resets
      firewire: fix struct fw_node memory leak
      firewire: fw-ohci: don't leak dma memory on module removal
      firewire: fw-sbp2: fix races

Jay Vosburgh (2):
      bonding: fix miimon failure counter
      bonding: Clean up resource leaks

Jean Delvare (1):
      i2c: The i2c mailing list is moving

Jeff Garzik (2):
      drivers/net/wan/syncppp: Fix unused-var warnings
      linux/string.h: fix comment typo

Jens Axboe (3):
      scsi: make sure that scsi_init_shared_tag_map() doesn't overwrite existing map
      libata: fix NCQ devices behind port multipliers
      libata: add whitelist for devices with known good pata-sata bridges

Jens Taprogge (1):
      USB: Unusual dev for the "Kyocera / Contax SL300R T*" digital camera.

Jeremy Fitzhardinge (1):
      xen: don't reload cr3 on suspend

Jeremy Huntwork (1):
      Fix incompatibility with versions of Perl less than 5.6.0

Jeremy Kerr (2):
      scripts/package: don't break if %{_smp_mflags} isn't set
      OF-device: Don't overwrite numa_node in device registration

Jesper Nilsson (4):
      [CRISv32] Remove warning in io.h
      [CRIS] Move header files from include to arch/cris/include.
      [CRIS] Merge asm-offsets.c for both arches into one file.
      [CRIS] Remove links from CRIS build

Jesse Brandeburg (1):
      pktgen: fix multiple queue warning

Jianjun Kong (1):
      af_unix: netns: fix problem of return value

Jiri Kosina (4):
      HID: add support for another Gyration remote control
      HID: quirk for OLED devices present in ASUS G50/G70/G71
      HID: Add support for Sony Vaio VGX-TP1E
      sched: fix documentation reference for sched_min_granularity_ns

Jiri Pirko (1):
      docs: fix ManagementStyle book name

Jiri Slaby (7):
      HID: fix hidraw_exit section mismatch
      HID: add hid_type to general hid struct
      HID: fix hidbus/appletouch device binding regression
      HID: fix lock imbalance in hidraw
      HID: fix lock imbalance in hiddev
      HID: fix oops during suspend of unbound HID devices
      HID: sync on deleted io_retry timer in usbhid driver

Joerg Roedel (1):
      x86, gart: fix gart detection for Fam11h CPUs

Johannes Berg (1):
      libertas: fix buffer overrun

John W. Linville (1):
      mac80211: correct warnings in minstrel rate control algorithm

Jon Smirl (2):
      ALSA: ASoC: Fix some minor errors in mpc5200 psc i2s driver
      powerpc: Fix format string warning in arch/powerpc/boot/main.c

Jonas Bonn (1):
      asm-generic: define DIE_OOPS in asm-generic

Jonathan Cameron (2):
      leds: da903x: (da9030 only) led brightness reversed.
      regulator: da903x regulator bug fix

Josh Boyer (5):
      ibm_newemac: Fix typo in flow control config option
      powerpc/40x: Don't enable HCU4 board by default
      Update stable tree documentation
      powerpc/40x: Update 40x defconfigs
      powerpc/44x: Update 44x defconfigs

Julia Lawall (1):
      i2c-s3c2410: Correct use of ! and &

KAMEZAWA Hiroyuki (1):
      memcg: update menuconfig help text

Kay Sievers (1):
      sound: struct device - replace bus_id with dev_name(), dev_set_name()

Ken'ichi Ohmichi (1):
      x86, kdump: fix invalid access on i386 sparsemem

Kristoffer Ericson (1):
      [ARM] 5299/1: Add maintainer for Mobilepro 900/c

Krzysztof Helt (1):
      rtc-m48t59: shift zero year to 1968 on sparc (rev 2)

Kumar Gala (1):
      powerpc/mpic: Fix regression caused by change of default IRQ affinity

Kuninori Morimoto (4):
      sh: Provide a sample defconfig for the UL2 (SH7366) board.
      SH 7366 needs SCIF_ONLY
      Add support usb setting on sh 7366
      sh: Enable NFS root in Migo-R defconfig.

Kurt Garloff (1):
      mm: increase the default mlock limit from 32k to 64k

Len Brown (2):
      toshiba_acpi: always call input_sync() after input_report_switch()
      leds-hp-disk: fix build warning

Lennart Sorensen (1):
      scx200_i2c: Add missing class parameter

Li Zefan (8):
      sched: add CONFIG_SMP consistency
      sched: change sched_debug's mode to 0444
      sched: remove sched-design.txt from 00-INDEX
      freezer_cg: fix improper BUG_ON() causing oops
      freezer_cg: remove redundant check in freezer_can_attach()
      freezer_cg: use thaw_process() in unfreeze_cgroup()
      freezer_cg: simplify freezer_change_state()
      cgroups: tiny cleanups

Linus Torvalds (3):
      reserve_region_with_split: Fix GFP_KERNEL usage under spinlock
      x86: Clean up late e820 resource allocation
      Linux v2.6.28-rc3

Linus Walleij (1):
      [ARM] 5322/1: Fix fastpath issue in mmci.c

Manish Katiyar (1):
      netlabel: Fix compilation warnings in net/netlabel/netlabel_addrlist.c

Manuel Lauss (1):
      MIPS: Alchemy: Wire up SD controller on DB/PB1200 boards.

Marcelo Tosatti (1):
      KVM: MMU: sync root on paravirt TLB flush

Marcin Slusarz (1):
      fbcon: don't inline updatescrollmode

Mariusz Kozlowski (1):
      hdpuftrs: fix build

Mark Brown (6):
      mfd: Make WM8400 depend on I2C until SPI is submitted
      ALSA: hda: Add HDA vendor ID for Wolfson Microelectronics
      regulator: Build on non-ARM platforms
      ALSA: Warn when control names are truncated
      ALSA: ASoC: Fix mono controls after conversion to support full int masks
      ALSA: ASoC: Fix WM9713 ALC Decay Time name

Mark Nelson (2):
      ahci: Add support for Promise PDC42819
      powerpc: Update remaining dma_mapping_ops to use map/unmap_page

Markus Metzger (1):
      x86, bts: improve help text for BTS config

Matt Fleming (1):
      Define SCSPTR1 for SH 7751R

Matthew Garrett (1):
      sony-laptop: ignore missing _DIS method on pic device

Matthias Kaehlcke (1):
      [ARM] ep93xx: fix OHCI DMA mask

Max Dmitrichenko (1):
      sparc64: Fix PCI resource mapping on sparc64

Miao Xie (1):
      ACPI: cpufreq, processor: fix compile error in drivers/acpi/processor_perflib.c

Michael Neuling (2):
      powerpc: Fix compiler warning for the relocatable kernel
      powerpc: Fix swapcontext system for VSX + old ucontext size

Michael Trimarchi (1):
      sh: Fix up the shared IRQ demuxer's control bit testing logic.

Mike Crowe (1):
      [ARM] 5323/1: Remove outdated empeg documentation.

Mike Dyer (1):
      powerpc: Remove duplicate DMA entry from mpc8313erdb device tree

Mike Frysinger (3):
      kbuild: setlocalversion: dont include svn change count
      MAINTAINERS: add LTP info to the list
      SMC91x: delete unused local variable "lp"

Mike Galbraith (1):
      sched: weaken sync hint

Mike Travis (1):
      x86, uv: fix compile error in uv_hub.h

Mikulas Patocka (3):
      dm snapshot: fix register_snapshot deadlock
      dm snapshot: wait for chunks in destructor
      framebuffer compat_ioctl deadlock

Milton Miller (3):
      powerpc: Kexec exit should not use magic numbers
      powerpc: Use is_kdump_kernel()
      powerpc/ppc64/kdump: Better flag for running relocatable

Nathan Fontenot (1):
      powerpc/pci: Properly allocate bus resources for hotplug PHBs

NeilBrown (4):
      md: use sysfs_notify_dirent to notify changes to md/array_state
      md: use sysfs_notify_dirent to notify changes to md/dev-xxx/state
      md: allow extended partitions on md devices.
      md: destroy partitions and notify udev when md array is stopped.

Nick Piggin (1):
      fs: remove prepare_write/commit_write

Nobuhiro Iwamatsu (3):
      gdrom: Fix compile error
      sh: Change register name SCSPTR to SCSPTR2
      sh: Add sci_rxd_in of SH4-202

Ondrej Zary (1):
      libata: Fix LBA48 on pata_it821x RAID volumes.

Paul Bolle (1):
      [ARM] build fixes for netX serial driver

Paul Mackerras (3):
      powerpc: Work around ld bug in older binutils
      powerpc: Fix compile errors with CONFIG_BUG=n
      Revert "powerpc: Sync RPA note in zImage with kernel's RPA note"

Paul Moore (1):
      netlabel: Fix compiler warnings in netlabel_mgmt.c

Paul Mundt (12):
      serial: sh-sci: Kill off all of the SCI/SCIF special casing.
      kernel/resource: fix reserve_region_with_split() section mismatch
      sh: oprofile: Fix up the SH7750 performance counter name.
      sh: Fix FPU tuning on toolchains with mismatched multilib targets.
      sh: Add on-chip RTC support for SH7722.
      sh: sh7785lcr: Select uImage as default image target.
      sh: Simplify and lock down the ISA tuning.
      sh: Revert "SH 7366 needs SCIF_ONLY"
      sh: Kill off long-dead HD64465 cchip support.
      kernel/profile: fix profile_init() section mismatch
      sh: SHmedia ISA tuning fixups.
      sh: FTRACE renamed to FUNCTION_TRACER.

Peter Korsgaard (1):
      dm9601: runtime mac address change support

Peter Oruba (3):
      mailmap: add Peter Oruba
      x86: microcode patch loader author update
      x86: AMD microcode patch loader author update

Peter Volkov (1):
      kbuild: fix KBUILD_EXTRA_SYMBOLS

Peter Zijlstra (5):
      tracing: create tracers menu
      sched: fix a find_busiest_group buglet
      sched: more accurate min_vruntime accounting
      sched: re-instate vruntime based wakeup preemption
      sched: virtual time buddy preemption

Phil Sutter (1):
      MIPS: RB532: Disable the right device

Qinghuang Feng (1):
      driver core: drivers/base/sys.c: update comments

Rafael J. Wysocki (2):
      ACPI suspend: build fix for ACPI_SLEEP=n && XEN_SAVE_RESTORE=y.
      ACPI: Oops in ACPI with git latest

Ralf Baechle (10):
      MIPS: SMP: Don't reenable interrupts in stop_this_cpu; use WAIT instruction.
      MIPS: IP22: ip22-int.c header file weeding.
      MIPS: New feature test macro cpu_has_mips_r
      MIPS: Clean up MIPSxx-optimized bitop functions
      MIPS: SMP: Do not initialize __cpu_number_map/__cpu_logical_map for CPU 0.
      MIPS: Switch FPU emulator trap to BREAK instruction.
      MIPS: Probe for watch registers on cores of all vendors, not just MTI.
      MIPS: Sort out CPU type to name translation.
      CHAR: Delete old and now unused DS1286 driver.
      CHAR: Delete old and now unused M48T35 RTC driver for SGI IP27.

Randy Dunlap (10):
      kernel-doc: allow more whitespace in macros
      docbooks: fix fatal filename errors
      mac80211.h: fix kernel-doc excesses
      libata: add missing kernel-doc
      i2o: fix kernel-doc warnings
      mm: fix kernel-doc function notation
      fs: remove excess kernel-doc
      kernel.h: fix might_sleep kernel-doc
      ATA: remove excess kernel-doc notation
      net: delete excess kernel-doc notation

Ravikiran G Thirumalai (1):
      x86: fix /dev/mem mmap breakage when PAT is disabled

Remi Denis-Courmont (2):
      Phonet: include generic link-layer header size in MAX_PHONET_HEADER
      Phonet: do not reply to indication reset packets

Roel Kluin (1):
      [S390] appldata: unsigned ops->size cannot be negative

Rogério Brito (2):
      powerpc: compile kernel for linkstations optimized for size
      powerpc: enable heap randomization for linkstations

Roland Dreier (1):
      libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127

Rusty Russell (3):
      lguest: fix example launcher compile after moved asm-x86 dir.
      lguest: fix early_ioremap.
      lguest: fix irq vectors.

Sam Ravnborg (1):
      kbuild: improve check-symlink

Samuel Ortiz (1):
      mfd: add missing Kconfig entry for da903x

Sascha Hauer (3):
      [ARM] pcm037: map AIPS1 and AIPS2 as nonshared area
      [ARM] MX3: Use ioremap wrapper to map SoC devices nonshared
      [ARM] mx31ads: Add missing include

Scott James Remnant (1):
      ipmi: add MODULE_ALIAS to load ipmi_devintf with ipmi_si

Serge Hallyn (1):
      file caps: always start with clear bprm->caps_*

Sergey Lapin (1):
      [ARM] 5326/1: AFEB9260: Fix for i2c_board_info structure

Sergio Luis (2):
      btsdio: free sk_buff with kfree_skb
      libertas: free sk_buff with kfree_skb

Shaohua Li (1):
      x86, memory hotplug: remove wrong -1 in calling init_memory_mapping()

Sheng Yang (1):
      KVM: Fix guest shared interrupt with in-kernel irqchip

Shinya Kuribayashi (12):
      MIPS: Add CONFIG_CPU_R5500 for NEC VR5500 series processors
      MIPS: EMMA: Kconfig reorganization
      MIPS: EMMA: Move arch/mips/emma2rh/ into arch/mips/emma/
      MIPS: EMMA: Move <asm/emma2rh> to <asm/emma> dir
      MIPS: EMMA2RH: Remove emma2rh_sync on read operation
      MIPS: EMMA2RH: Remove emma2rh_irq_base global variable
      MIPS: EMMA2RH: Remove emma2rh_sw_irq_base
      MIPS: EMMA2RH: Remove emma2rh_gpio_irq_base
      MIPS: EMMA: Fold arch/mips/emma/{common,markeins}/irq*.c into markeins/irq.c
      MIPS: Markeins: Remove runtime debug prints
      MIPS: Markeins: Extract ll_emma2rh_* functions
      MIPS: Markeins: Remove unnecessary define and cleanup comments, etc.

Stefan Bader (1):
      Input: i8042 - add Blue FB5601 to noloop exception table

Stefan Richter (2):
      firewire: fw-ohci: initialization failure path fixes
      firewire: fw-sbp2: delay first login to avoid retries

Stephen Hemminger (1):
      net: add documentation for skb recycling

Stephen Rothwell (1):
      trace: fix printk warning for u64

Steven Rostedt (23):
      ftrace: do not enclose logic in WARN_ON
      ftrace: release functions from hash
      ftrace: fix depends
      ftrace: rename FTRACE to FUNCTION_TRACER
      ftrace: rename the ftrace tracer to function
      ftrace: stack tracer only record when on stack
      ring-buffer: fix free page
      ftrace: handle generic arch calls
      ftrace: dynamic ftrace process only text section
      ftrace: return error on failed modified text.
      ftrace: comment arch ftrace code
      ftrace: use probe_kernel
      ftrace: only have ftrace_kill atomic
      ftrace: add ftrace warn on to disable ftrace
      ftrace: disable dynamic ftrace for all archs that use daemon
      ftrace: remove daemon
      ftrace: remove mcount set
      ftrace: remove ftrace hash
      ftrace, powerpc, sparc64, x86: remove notrace from arch ftrace file
      ftrace: use a real variable for ftrace_nop in x86
      ftrace: fix current_tracer error return
      ftrace: fix trace_nop config select
      ftrace: handle archs that do not support irqs_disabled_flags

Sukadev Bhattiprolu (1):
      'kill sig -1' must only apply to caller's namespace

Suresh Siddha (1):
      resources: fix x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6() WARNINGs

Sven Hartge (1):
      via-velocity: use driver string instead of dev->name before register_netdev()

Takashi Iwai (5):
      ALSA: hda - Restore default pin configs for realtek codecs
      ALSA: hda - Add another HP model for AD1884A
      ALSA: hda - Fix SPDIF mute on IDT/STAC codecs
      ALSA: hda - Add reboot notifier
      ALSA: usb - Add quirk for Edirol UA-25EX advanced modes

Tejun Heo (4):
      libata: fix device iteration bugs
      sata_sil24: configure max read request size to 4k
      libata: clear saved xfer_mode and ncq_enabled on device detach
      sata_via: fix support for 5287

Theodore Ts'o (1):
      jbd2: Call the commit callback before the transaction could get dropped

Thomas Klein (1):
      ehea: Detect 16GB hugepages for firmware restriction

Thomas Volpini (1):
      scripts/checksyscalls.sh: fix for non-gnu sed

Tomas Winkler (1):
      iwlwifi: fix suspend to RAM in iwlwifi

Trent Piepho (3):
      kbuild: tag with git revision when git describe is missing
      gianfar: Fix race in TBI/SerDes configuration
      gianfar: Don't reset TBI<->SerDes link if it's already up

Trond Myklebust (4):
      SUNRPC: Respond promptly to server TCP resets
      NFS: Convert nfs_attr_generation_counter into an atomic_long
      SUNRPC: Fix rpcauth_prune_expired
      SUNRPC: Fix potential race in put_rpccred()

Tsugikazu Shibata (1):
      HOWTO: Sync patch for jp_JP/HOWTO

Ursula Braun (2):
      qeth: remove non-recover-thread checkings
      qeth: avoid skb_under_panic for malformatted inbound data

Uwe Hermann (1):
      doc/x86: fix doc subdirs

Uwe Kleine-König (1):
      [ARM] gpio_free might sleep, arm architecture

Venki Pallipadi (4):
      i7300_idle: Disable ioat channel only on platforms where ile driver can load
      i7300_idle: Cleanup based review comments
      i7300_idle: Fix compile warning CONFIG_I7300_IDLE_IOAT_CHANNEL not defined
      x86: fix AMDC1E and XTOPOLOGY conflict in cpufeature

Xiantao Zhang (2):
      KVM: ia64: Fix halt emulation logic
      KVM: ia64: Makefile fix for forcing to re-generate asm-offsets.h

Yauhen Kharuzhy (2):
      rtc-s3c: fix section mismatch warnings
      rtc S3C: add device_init_wakeup() invokation

Yevgeny Petrilin (1):
      mlx4: Setting the correct offset for default mac address

Yinghai Lu (4):
      x86: keep the /proc/meminfo page count correct
      x86: fix APIC_DEBUG with inquire_remote_apic
      x86: 64 bit print out absent pages num too
      x86: fix init_memory_mapping for [dc000000 - e0000000) - v2

Yoichi Yuasa (1):
      MIPS: Fix KGDB build error

Yoshihiro Shimoda (1):
      sh: fix sh2a cache entry_mask

Zhang Le (1):
      MIPS: lemote/lm2e: Added io_map_base to pci controller

Zhaolei (2):
      MIPS: Fix debugfs_create_*'s error checking method for arch/mips/math-emu/
      MIPS: Fix debugfs_create_*'s error checking method for mips/kernel/

fernando@oss.ntt.co (1):
      xfrm: do not leak ESRCH to user space

qinghuang feng (1):
      lockdep: minor fix for debug_show_all_locks()

roel kluin (3):
      irq: make variable static
      printk: remove unused code from kernel/printk.c
      cipso: unsigned buf_len cannot be negative
