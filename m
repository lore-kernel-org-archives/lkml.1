Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXLUBl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXLUBl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXLUBlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:41:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbXLUBlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:41:15 -0500
Date: Thu, 20 Dec 2007 17:41:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc6
Message-ID: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The most noticeable part here (both to users and in the diffstat) should 
be the libata-acpi fixes by Tejun Heo, which should hopefully take care of 
all of the regressions that were caused by teaching SATA about doing the 
proper ACPI stuff at bootup/suspend/resume/shutdown.

Other changes visible in the diffstat are a couple of new watchdog drivers 
and the removal of the old tipar driver, and some Korean translations of 
the kernel docs. And some V4L videobuf changes.

Other than that, it's pretty much a lot of small fixes (maybe not 
one-liners, but we're talking "a few lines"). Networking, USB, scsi, 
wireless, infiniband, IDE... With some alpha, ia64 and x86 arch updates.

The regression list keeps shrinking, so we're still on track for a full 
2.6.24 release in early January. Assuming we don't all overeat during the 
holidays and nobody gets any work done. But we all know that the holidays 
are really the time when we get away from the boring "real work", and can 
spend 24/7 on kernel hacking instead, right?

Here's to a merry christmas, doing the whole druidic festival around the 
tree thing,

			Linus

---
Aaron Carroll (2):
      as-iosched: fix incorrect comments
      as-iosched: fix write batch start point

Adam Jackson (1):
      apm_event{,info}_t are userspace types

Adrian Bunk (14):
      V4L/DVB (6796): ivtv/ section fix
      V4L/DVB (6797): bt8xx/ section fixes
      V4L/DVB (6803): buf-core.c locking fixes
      V4L/DVB (6814): Makefile: always enter video/
      drivers/net/sis190.c section fix
      drivers/net/s2io.c section fixes
      wireless/ipw2200.c: add __dev{init,exit} annotations
      drivers/cpufreq/cpufreq_stats.c section fix
      block: let elv_register() return void
      timer: kernel/timer.c section fixes
      x86 apic_32.c section fix
      x86 smpboot_32.c section fixes
      x86_32: select_idle_routine() must be __cpuinit
      x86_32: disable_pse must be __cpuinitdata

Al Viro (5):
      sundance fixes
      starfire VLAN fix
      hamachi endianness fixes
      [SYNCPPP]: Endianness and 64bit fixes.
      sis190 endianness

Alan Cox (2):
      [SCSI] initio: fix conflict when loading driver
      pata_hpt37x: Fix HPT374 detection

Alan Stern (2):
      USB: fix locking loop by avoiding flush_scheduled_work
      USB: use IRQF_DISABLED for HCD interrupt handlers

Alasdair G Kergon (1):
      dm: trigger change uevent on rename

Alexey Starikovskiy (3):
      ACPI: SBS: Reset alarm bit
      ACPI: SBS: Ignore alarms coming from unknown devices
      ACPI: SBS: Return rate in mW if capacity in mWh

Amos Waterland (1):
      [IPV4]: Updates to nfsroot documentation

Andrew Morton (6):
      V4L/DVB (6819): i2c: fix drivers/media/video/bt866.c
      ucc_geth: minor whitespace fix
      [TIPC]: Fix semaphore handling.
      bcm43xx_debugfs sscanf fix
      fix headers_install
      revert "Hibernation: Use temporary page tables for kernel text mapping on x86_64"

Andrey Borzenkov (1):
      ACPI: battery: fix ACPI battery technology reporting

Andries E. Brouwer (1):
      ext3, ext4: avoid divide by zero

Anton Vorontsov (1):
      ucc_geth: really fix section mismatch

Arjan van de Ven (1):
      debug: add end-of-oops marker

Atsushi Nemoto (1):
      i2c-gpio: Initialize adapter class

Auke Kok (1):
      e100: free IRQ to remove warningwhenrebooting

Barry Kasindorf (1):
      oprofile: op_model_athlon.c support for AMD family 10h barcelona performance counters

Bartlomiej Zolnierkiewicz (13):
      ide-scsi: add ide_scsi_hex_dump() helper
      ide: add missing checks for control register existence
      ide: deprecate CONFIG_BLK_DEV_OFFBOARD
      ide: fix ide_scan_pcibus() error message
      ide: coding style fixes for drivers/ide/setup-pci.c
      ide: add /sys/bus/ide/devices/*/{model,firmware,serial} sysfs entries
      ide: DMA reporting and validity checking fixes (take 3)
      ide-cd: remove dead post_transform_command()
      pdc202xx_new: fix Promise TX4 support
      ide: remove dead code from __ide_dma_test_irq()
      ide: remove stale changelog from ide-disk.c
      ide: remove stale changelog from ide-probe.c
      ide: fix ->io_32bit race in set_io_32bit()

Benjamin Herrenschmidt (1):
      usb: Remove broken optimisation in OHCI IRQ handler

Benoit Istin (1):
      V4L/DVB (6746): saa7134-dvb: fix tuning for WinTV HVR-1110

Boaz Harrosh (1):
      [SCSI] initio: bugfix for accessors patch

Brandon Philips (4):
      V4L/DVB (6601): V4L: videobuf-core locking fixes and comments
      V4L/DVB (6602): V4L: Convert videobuf drivers to videobuf_stop
      V4L/DVB (6615): V4L: Fix  VIDIOCGMBUF locking in saa7146
      V4L/DVB (6751): V4L: Memory leak!  Fix count in videobuf-vmalloc mmap

Chris Dearman (1):
      [MIPS] Ensure that ST0_FR is never set on a 32 bit kernel

Chris Pascoe (1):
      V4L/DVB (6629): zl10353: fix default adc_clock and TRL nominal rate calculation

Christoph Hellwig (1):
      [XFS] Fix mknod regression

Christoph Lameter (3):
      SLUB: remove useless masking of GFP_ZERO
      quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
      IA64: Slim down __clear_bit_unlock

Corey Minyard (1):
      [WATCHDOG] ipmi: add the standard watchdog timeout ioctls

Cyrill Gorcunov (2):
      ieee80211_rate: missed unlock
      iwlwifi3945/4965: fix rate control algo reference leak

Dan Williams (1):
      libertas: select WIRELESS_EXT

Dave Jones (1):
      cpufreq: fix missing unlocks in cpufreq_add_dev error paths.

Dave Young (1):
      pktcdvd: add kobject_put when kobject register fails

David Brownell (2):
      i2c/isp1301_omap: Build fix
      rtc-at32ap700x: fix irq init oops

David S. Miller (2):
      [SPARC64]: Fix endless loop in cheetah_xcall_deliver().
      [SPARC64]: Fix two kernel linear mapping setup bugs.

Dhaval Giani (1):
      Add Documentation for FAIR_USER_SCHED sysfs files

Dmitry Adamushko (1):
      sched: fix crash on ia64, introduce task_current()

Doug Maxey (1):
      usb-storage: Fix devices that cannot handle 32k transfers

Eric Dumazet (3):
      [NETFILTER]: xt_hashlimit should use time_after_eq()
      parport: "dev->timeslice" is an unsigned long, not an int
      sched: sysctl, proc_dointvec_minmax() expects int values for

Eric Sandeen (3):
      ecryptfs: initialize new auth_tokens before teardown
      ecryptfs: set s_blocksize from lower fs in sb
      ecryptfs: fix fsx data corruption problems

Eric W. Biederman (1):
      sysctl: fix ax25 checks

FUJITA Tomonori (1):
      [SCSI] st: fix kernel BUG at include/linux/scatterlist.h:59!

Gary Hade (2):
      ACPI: acpiphp: Remove dmesg spam on device remove
      PCI: Restore PCI expansion ROM P2P prefetch window creation

Geert Uytterhoeven (1):
      ps3fb: Update for firmware 2.10

Geoff Levand (2):
      sparsemem: make SPARSEMEM_VMEMMAP selectable
      ps3fb: Fix ps3fb free_irq() dev_id

Gilles Gigan (1):
      [WATCHDOG] add Nano 7240 driver

Greg Kroah-Hartman (2):
      kobject: fix the documentation of how kobject_set_name works
      USB: revert portions of "UNUSUAL_DEV: Sync up some reported devices from Ubuntu"

Guillaume Chazarain (1):
      kbuild: re-enable Makefile generation in a new O=... directory

Hans Verkuil (1):
      V4L/DVB (6485): ivtv: fix compile warning

Hans-Christian Egtvedt (1):
      [WATCHDOG] at32ap700x_wdt: add support for boot status and add fix for silicon errata

Hartmut Hackmann (1):
      V4L/DVB (6579): Fix bug #8824: Correct support for Diseqc on tda10086

Heikki Lindholm (2):
      V4L/DVB (6666): saa7134-alsa: fix period handling
      V4L/DVB (6690): saa7134: fix ignored interrupts

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: fix lenovo keymap for brightness

Herbert Xu (1):
      [IPSEC]: Fix potential dst leak in xfrm_lookup

Hermann Pitton (1):
      V4L/DVB (6686): saa7134: fix composite over s-video input on the Tevion MD 9717

Hidetoshi Seto (2):
      [IA64] Remove assembler warnings on head.S
      [IA64] Adjust CMCI mask on CPU hotplug

Hinko Kocevar (2):
      [IRDA]: mcs7780 needs to free allocated rx buffer.
      [IRDA]: irlmp_unregister_link() needs to free lsaps.

Ian Wienand (1):
      [IA64] set_thread_area fails in IA32 chroot

Ingo Molnar (4):
      sched: touch softlockup watchdog after idling
      sched: do not hurt SCHED_BATCH on wakeup
      x86: fix "Kernel panic - not syncing: IO-APIC + timer doesn't work!"
      x86: fix die() to not be preemptible

Ivan Kokshaysky (3):
      alpha: strncpy/strncat fixes
      alpha: build fixes
      mm: fix exit_mmap BUG() on a.out binary exit

Jaime Velasco Juan (1):
      USB: option: Bind to the correct interface of the Huawei E220

James Bottomley (1):
      [SCSI] dpt_i2o: driver is only 32 bit so don't set 64 bit DMA mask

James Lentini (1):
      SUNRPC xprtrdma: fix XDR tail buf marshalling for all ops

Jan Beulich (3):
      ACPI: fix modpost warnings
      x86: also define AT_VECTOR_SIZE_ARCH
      [IA64] make flush_tlb_kernel_range() an inline function

Jan Kara (1):
      Fix compilation warning in dquot.c

Jarek Poplawski (1):
      [AX25]: Locking dependencies fix in ax25_disconnect().

Jason Gaston (1):
      x86: intel_cacheinfo.c: cpu cache info entry for Intel Tolapai

Jean Delvare (1):
      i2c: Delete an outdated piece of documentation

Jeff Long (1):
      USB: cp2101: new device id

Jiri Kosina (1):
      V4L/DVB (6733): DVB: Compile 3000MC-specific DIB code only for CONFIG_DVB_DIB3000MC

Jiri Slaby (3):
      [WATCHDOG] bfin_wdt, remove SPIN_LOCK_UNLOCKED
      [WATCHDOG] Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
      Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED

Joachim Fenkes (3):
      IB/ehca: Return correct number of SGEs for SRQ
      IB/ehca: Serialize HCA-related hCalls if necessary
      IB/ehca: Fix lock flag variable location, bump version number

Jochen Friedrich (2):
      [POWERPC] Fix typo #ifdef -> #ifndef
      [POWERPC] Kill non-existent symbols from ksyms and commproc.h

Joe Perches (2):
      i2c: Add missing spaces in split log messages
      [IA64] Two trivial spelling fixes

Jorge Boncompte [DTI2] (1):
      [WATCHDOG] IT8212F watchdog driver

Julia Lawall (4):
      [UM]: Fix use of skb after netif_rx
      [XTENSA]: Fix use of skb after netif_rx
      [S390]: Fix use of skb after netif_rx
      drivers/macintosh/via-pmu.c: Added a missing iounmap

Jun'ichi Nomura (1):
      dm: table detect io beyond device

Kenji Kaneshige (1):
      [IA64] Remove compiler warinings about uninitialized variable in irq_ia64.c

Kevin Hilman (2):
      [ARM] 4694/1: IXP4xx: Update clockevent support for shutdown and resume
      genirq: add unlocked version of set_irq_handler()

Komuro (1):
      pcnet_cs: add new id

Lachlan McIlroy (3):
      [XFS] Don't wait for pending I/Os when purging blocks beyond eof.
      [XFS] Put the correct offset in dirent d_off
      [XFS] Initialise current offset in xfs_file_readdir correctly

Larry Finger (1):
      b43: Fix rfkill radio LED

Linus Torvalds (3):
      Revert "make bnx2x select ZLIB_INFLATE"
      Do dirty page accounting when removing a page from the page cache
      Linux 2.6.24-rc6

Liu Yu (1):
      [POWERPC] Fix rounding bug in emulation for double float operating

Livio Soares (1):
      sched: mark rwsem functions as __sched for wchan/profiling

Mark Fasheh (4):
      ocfs2: fix exit-while-locked bug in ocfs2_queue_orphans()
      ocfs2: Don't panic when truncating an empty extent
      ocfs2: Allow for debugging of transaction extends
      ocfs2: Re-journal buffers after transaction extend

Mark Lord (1):
      sata_mv: improve warnings about Highpoint RocketRAID 23xx cards

Martin Habets (2):
      [SERIAL] sparc: Infrastructure to fix section mismatch bugs.
      [SPARC32]: Silence sparc32 warnings on missing syscalls.

Martin Schwidefsky (1):
      [S390] pud_present/pmd_present bug.

Masami Hiramatsu (2):
      x86: jprobe bugfix
      x86: kprobes bugfix

Matheos Worku (1):
      ixgb: make sure jumbos stay enabled after reset

Mauro Carvalho Chehab (5):
      V4L/DVB (6542): Fix S-video mode on tvp5150
      V4L/DVB (6581): Fix: avoids negative vma usage count
      V4L/DVB (6750): Fix in-kernel compilation for cxusb
      V4L/DVB (6794): Fix compilation when dib3000mc is compiled as a module
      V4L/DVB (6609): Re-adds lock safe videobuf_read_start

Mel Gorman (1):
      mm: fix page allocation for larger I/O segments

Michael Brunner (1):
      [ARM] 4690/1: PXA: fix CKEN corruption in PXA27x AC97 cold reset code

Michael Chan (3):
      [BNX2]: Add PHY_DIS_EARLY_DAC workaround.
      [BNX2]: Fix RX packet rot.
      [BNX2]: Update version to 1.6.9.

Michael Ellerman (1):
      [POWERPC] Make PS3_SYS_MANAGER default y, not m

Michael Krufky (1):
      V4L/DVB (6798): saa7134: enable LNA in analog mode for Hauppauge WinTV HVR-1110

Mike Rapoport (1):
      [ARM] 4667/1: CM-X270 fixes

Mike Travis (1):
      x86: fix show cpuinfo cpu number always zero

Milan Broz (2):
      dm crypt: fix write endio
      dm crypt: use bio_add_page

Nathan Lynch (1):
      fix bloat-o-meter for ppc64

Neil Brown (1):
      dm: merge max_hw_sector

Nick Piggin (1):
      [IA64] ia32 nopage

Nicolas Ferre (1):
      USB: at91_udc: correct hanging while disconnecting usb cable

Nicolas Pitre (1):
      mmc: remove unused 'mode' from the mmc_host structure

Nishanth Aravamudan (3):
      hugetlb: introduce nr_overcommit_hugepages sysctl
      Revert "hugetlb: Add hugetlb_dynamic_pool sysctl"
      Documentation: update hugetlb information

Olaf Hartmann (1):
      [IRDA]: stir4200 fixes.

Oliver Neukum (1):
      [IRDA]: Race between open and disconnect in irda-usb.

Pablo Neira Ayuso (1):
      [NETFILTER]: ctnetlink: set expected bit for related conntracks

Patrick McHardy (2):
      [NETFILTER]: ip_tables: fix compat copy race
      [NETFILTER]: bridge: fix missing link layer headers on outgoing routed packets

Paul Moore (1):
      [XFRM]: Display the audited SPI value in host byte order.

Paul Mundt (2):
      net: smc911x: shut up compiler warnings
      dm mpath: hp requires scsi

Pavel Emelyanov (2):
      [IPV4]: Swap the ifa allocation with the"ipv4_devconf_setall" call
      [VLAN]: Fix potential race in vlan_cleanup_module vs vlan_ioctl_handler.

Peter Zijlstra (1):
      sched: rt: account the cpu time during the tick

Pierre Ossman (4):
      sdhci: describe quirks
      sdhci: don't warn about sdhci 2.0 controllers
      sdhci: use PIO when DMA can't satisfy the request
      sdhci: support JMicron JMB38x chips

Ralf Baechle (3):
      [MIPS] Atlas, Malta: Don't free firmware memory on free_initmem.
      [MIPS] PCI: Make pcibios_fixup_device_resources ignore legacy resources.
      [MIPS] time: Delete weak definition of plat_time_init() due to gcc bug.

Randy Dunlap (2):
      usb.h: fix kernel-doc warning
      Cleanup umem driver: fix most checkpatch warnings, conform to kernel

Richard Knutsson (2):
      V4L/DVB (6684): Complement va_start() with va_end() + style fixes
      [IRDA]: irda parameters warning fixes.

Romain Liévin (1):
      tipar: remove obsolete module

Russ Anderson (1):
      [IA64] Fix Altix BTE error return status

Samuel Tardieu (1):
      [WATCHDOG] Stop looking for device as soon as one is found

Sascha Sommer (1):
      V4L/DVB (6540): em28xx: fix failing autodetection after the reboot

Satoru SATOH (1):
      [IPV4]: Make tcp_input_metrics() get minimum RTO via tcp_rto_min()

Scott Wood (2):
      [POWRPC] CPM2: Eliminate section mismatch warning in cpm2_reset().
      [POWERPC] 82xx: mpc8272ads, pq2fads: Update defconfig with CONFIG_FS_ENET_MDIO_FCC

Sergei Shtylyov (3):
      hpt366: fix HPT37x PIO mode timings (take 2)
      [MIPS] Alchemy: fix PCI resource conflict
      [MIPS] Alchemy: fix off by two error in __fixup_bigphys_addr()

Shannon Nelson (2):
      I/OAT: fixups from code comments
      I/OAT: fix null device in call to dev_err()

Sheela (1):
      Fix lguest documentation

Shi Weihua (1):
      [IA64] signal: remove redundant code in setup_sigcontext()

Simon Horman (1):
      [IA64] Guard elfcorehdr_addr with #if CONFIG_PROC_FS

Stanislaw Gruszka (1):
      uml: stop gdb from deleting breakpoints when running UML

Stefano Brivio (1):
      libertas: add Dan Williams as maintainer

Stephen Hemminger (2):
      sky2: RX lockup fix
      [BRIDGE]: Assign random address.

Stephen Rothwell (1):
      [POWERPC] iSeries: don't printk with HV spinlock held

Steven Rostedt (1):
      genirq: revert lazy irq disable for simple irqs

Steven Toth (1):
      V4L/DVB (6820): s5h1409: QAM SNR related fixes

Tejun Heo (16):
      sata_sil: fix spurious IRQ handling
      libata: clear link->eh_info.serror from ata_std_postreset()
      libata: add ST3160023AS / 3.42 to NCQ blacklist
      libata-acpi: adjust constness in ata_acpi_gtm/stm() parameters
      libata: update ata_*_printk() macros such that level can be a variable
      libata: add more opcodes to ata.h
      libata: ata_dev_disable() should be called from EH context
      libata-acpi: add new hooks ata_acpi_dissociate() and ata_acpi_on_disable()
      libata-acpi: implement and use ata_acpi_init_gtm()
      libata-acpi: implement dev->gtf_cache and evaluate _GTF right after _STM during resume
      libata-acpi: improve ACPI disabling
      libata-acpi: improve _GTF execution error handling and reporting
      libata-acpi: implement _GTF command filtering
      libata: update atapi_eh_request_sense() such that lbam/lbah contains buffer size
      libata: fix ATAPI draining
      block: use jiffies conversion functions in scsi_ioctl.c

Thomas Gleixner (1):
      clockevents: fix reprogramming decision in oneshot broadcast

Thomas Graf (2):
      [IPv4] ESP: Discard dummy packets introduced in rfc4303
      [IPv6] ESP: Discard dummy packets introduced in rfc4303

Tom "spot" Callaway (1):
      [ATM]: Fix compiler warning noise with FORE200E driver

Tony Battersby (2):
      [SCSI] sym53c8xx: fix free_irq() regression
      [SCSI] sym53c8xx: fix "irq X: nobody cared" regression

Tony Luck (1):
      [IA64] print kernel release in OOPS to make kerneloops.org happy

Trond Myklebust (5):
      NFS: Fix NFS mountpoint crossing...
      NFSv2/v3: Fix a memory leak when using -onolock
      Revert "NFS: Ensure we return zero if applications attempt to write zero bytes"
      NFS: Fix an Oops in NFS unmount
      MAINTAINERS: update the NFS CLIENT entry

Tsugikazu Shibata (1):
      HOWTO: Change man-page maintainer address for Japanese HOWTO

Ulrich Kunitz (1):
      zd1211rw: Fix alignment problems

Uwe Kleine-König (2):
      [ARM] 4710/1: Fix coprocessor 14 usage for debug messages via ICEDCC
      fs/Kconfig: grammar fix

Vlad Yasevich (1):
      [SCTP]: Flush fragment queue when exiting partial delivery.

WANG Cong (2):
      mm/sparse.c: check the return value of sparse_index_alloc()
      mm/sparse.c: improve the error handling for sparse_add_one_section()

Wang Chen (1):
      [NET]: Fix wrong comments for unregister_net*

Wei Yongjun (1):
      [IPV6]: Fix the return value of ipv6_getsockopt

William Lee Irwin III (1):
      ACPI: video_device_list corruption

YOSHIFUJI Hideaki (1):
      [IPV6] XFRM: Fix auditing rt6i_flags; use RTF_xxx flags instead of RTCF_xxx.

Yoichi Yuasa (1):
      [MIPS] time: Set up Cobalt's mips_hpt_frequency

Zhu Yi (1):
      iwlwifi: fix rf_kill state inconsistent during suspend and resume

agilmore@wirelessbeehive.com (1):
      USB: sierra: fix product id

barrios (2):
      add stable_api_nonsense.txt in korean
      HOWTO: update misspelling and word incorrected

de Dinechin, Christophe (Integrity VM) (1):
      [IA64] Avoid unnecessary TLB flushes when allocating memory

minchan kim (1):
      HOWTO: change addresses of maintainer and lxr url for Korean HOWTO
