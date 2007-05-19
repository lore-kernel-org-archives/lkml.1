Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbXESFSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbXESFSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXESFRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:17:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbXESFRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:17:51 -0400
Date: Fri, 18 May 2007 22:17:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22-rc2
Message-ID: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there, both patches/tarballs and git trees are updated (although 
mirroring might still be ongoing)

Various random fixes all over - the shortlog (appended) is fairly 
readable. The most notable ones are probably more SLUB fixes, and the 
epoll optimizations and cleanups.

But there's stuff in architectures (ia64, SH, AVR32, POWER), libata, 
network drivers, sound.. Give it a try.

I've been telling some people off on merging stuff, and I'll get even more 
hard-nosed about it after -rc2, so please don't even try to send anything 
but real fixes.

I think the current situation looks reasonably good for 2.6.22, but I hope 
everybody will take a good look at the regression lists (whether they 
_think_ they are affected or not), and spend some time wondering "was that 
anything I did, or is it something I can look at". Ok?

		Linus

---

Aaron Durbin (1):
      acpi: fix potential call to a freed memory section.

Al Viro (11):
      fix deadlock in loop.c
      missing mm.h in fw-ohci
      missing dependencies for USB drivers in input
      missing includes in mlx4
      em28xx and ivtv should depend on PCI
      rpadlpar breakage - fallout of struct subsystem removal
      m32r: __xchg() should be always_inline
      audit_match_signal() and friends are used only if CONFIG_AUDITSYSCALL is set
      fix uml-x86_64
      arm: walk_stacktrace() needs to be exported
      pata_scc had been missed by ata_std_prereset() switch

Alan Cox (1):
      sl82c105: Switch to ref counting API

Andrew Morton (2):
      parport_pc needs dma-mapping.h
      slub: fix handling of oversized slabs

Arthur Jones (1):
      IB/ipath: Shadow the gpio_mask register

Auke Kok (2):
      ixgb: don't print error if pci_enable_msi() fails, cleanup minor leak
      e1000: Fix msi enable leak on error, don't print error message, cleanup

Bartlomiej Zolnierkiewicz (13):
      pdc202xx_old: rewrite mode programming code (v2)
      serverworks: PIO mode setup fixes
      sis5513: PIO mode setup fixes
      alim15x3: use ide_tune_dma()
      pdc202xx_new: use ide_tune_dma()
      ide: always disable DMA before tuning it
      cs5530/sc1200: add ->udma_filter methods
      ide: use ide_tune_dma() part #2
      cs5530/sc1200: DMA support cleanup
      cs5530/sc1200: add ->speedproc support
      ide: remove ide_dma_enable()
      ide: add missing validity checks for identify words 62 and 63
      ide: remove ide_use_dma()

Becky Bruce (1):
      [POWERPC] Change include protections to ASM_POWERPC

Benjamin Herrenschmidt (4):
      [POWERPC] Add spinlock to request_phb_iospace()
      [POWERPC] Fix IO space on PCI buses created from of_platform
      [POWERPC] Make sure device node type/name is not NULL on hot-added nodes
      Make __vunmap static

Bernhard Walle (1):
      i386/x86-64: fix section mismatch

Christian Krafft (1):
      [POWERPC] cell_defconfig: Disable cpufreq and pmi

Christoph Hellwig (7):
      [AVR32] optimize pagefault path
      SUNRPC: remove dead variable 'rpciod_running'
      [IA64] optimize pagefaults a little
      [POWERPC] viopath: Use completion
      [POWERPC] viopath: Use a completion in some more places
      small netdevices.txt fix
      spidernet: node-aware skbuff allocation

Christoph Lameter (15):
      SLUB: CONFIG_LARGE_ALLOCS must consider MAX_ORDER limit
      SLUB: It is legit to allocate a slab of the maximum permitted size
      Fix: find_or_create_page skips cpuset memory spreading.
      Slab allocators: Drop support for destructors
      SLUB: Remove depends on EXPERIMENTAL and !ARCH_USES_SLAB_PAGE_STRUCT
      SLAB: Move two remaining SLAB specific definitions to slab_def.h
      SLUB: Define functions for cpu slab handling instead of using PageActive
      slab: warn on zero-length allocations
      SLUB: slabinfo fixes
      SLUB: Do our own flags based on PG_active and PG_error
      Remove SLAB_CTOR_CONSTRUCTOR
      SLUB: Simplify debug code
      Slab allocators: define common size limitations
      Fix page allocation flags in grow_dev_page()
      slub: another slabinfo fix

Corey Mutter (1):
      [IPV6]: Reverse sense of promisc tests in ip6_mc_input

Dan Aloni (1):
      make sysctl/kernel/core_pattern and fs/exec.c agree on maximum core filename size

Daniel Drake (2):
      [CPUFREQ] powernow-k7: fix MHz rounding issue with perflib
      [ALSA] usb-audio: another Logitech QuickCam ID

Daniel T Chen (1):
      [ALSA] Include quirks from Ubuntu Dapper/Edgy/Feisty

Dave Jiang (2):
      [POWERPC] Fix comment in booke_wdt
      [POWERPC] 85xx: Add device nodes for error reporting devices used by EDAC

Dave Jones (4):
      [CPUFREQ] Support rev H AMD64s in powernow-k8
      MAINTAINERS update.
      [CPUFREQ] Correct revision mask for powernow-k8
      [IPV4]: Correct rp_filter help text.

David Brownell (3):
      gpio interface loosens call restrictions
      rtc-omap build fix
      rtc kconfig clarification

David Gibson (4):
      [POWERPC] Remove fixup_bigphys_addr() for arch/powerpc to avoid link error
      [POWERPC] Fix bug adding properties with flatdevtree.c's ft_set_prop()
      [POWERPC] Fix make rules for treeImage.initrd
      [POWERPC] Small fixes for the Ebony device tree

David Howells (2):
      AFS: write back dirty data on unmount
      AFS: Fix afs_prepare_write()

David S. Miller (16):
      [SERIAL] SUNHV: Add an ID string.
      [SPARC64]: Be more resiliant with PCI I/O space regs.
      [SPARC] SBUS: bbc_i2c.c needs asm/io.h
      [SPARC] SBUS: display7seg.c needs asm/io.h
      [SCSI]: Add help text for SCSI_ESP_CORE.
      [SPARC64]: Add missing cpus_empty() check in hypervisor xcall handling.
      [SPARC64]: Accept ebus_bus_type for generic DMA ops.
      [SPARC32]: Update defconfig.
      [SPARC32]: asm/system.h needs asm/smp.h
      [VIDEO]: XVR-500 and XVR-2500 need FB=y.
      [SPARC64]: Update defconfig.
      [SPARC64]: Add hypervisor API negotiation and fix console bugs.
      [NET]: Fix BMSR_100{HALF,FULL}2 defines in linux/mii.h
      [TCP]: TCP_CONG_YEAH requires TCP_CONG_VEGAS
      [SPARC64]: Fix sched_clock() et al.
      [IPV4]: Remove IPVS icmp hack from route.c for now.

David Woodhouse (2):
      NS16550A: Restore HS settings in EXCR2 on resume
      Fix incorrect prototype for ipxrtr_route_packet()

Davide Libenzi (6):
      fix epoll single pass code and add wait-exclusive flag
      epoll locks changes and cleanups
      epoll: fix some comments
      epoll: move kfree inside ep_free
      eventfd use waitqueue lock ...
      timerfd use waitqueue lock ...

Domen Puncer (1):
      spi: fix spidev for >sizeof(long)/32 devices

Eugene Surovegin (3):
      ibm_emac: fix section mismatch warnings
      ibm_emac: improved PHY support
      ibm_emac: fix link speed detection change

Gabriel Mansi (1):
      [AGPGART] Fix wrong ID in via-agp.c

Geert Uytterhoeven (1):
      m68k: implement __clear_user()

Gerald Britton (1):
      cciss: Fix pci_driver.shutdown while device is still active

Gerd Hoffmann (1):
      Refine SCREEN_INFO sanity check for vgacon initialization

H. Peter Anvin (1):
      Further update of the i386 boot documentation

Haavard Skinnemoen (3):
      [AVR32] Remove bogus comment in arch/avr32/kernel/irq.c
      [AVR32] Wire up signalfd, timerfd and eventfd
      [AVR32] Implement platform hooks for atmel_lcdfb driver

Heiko Carstens (2):
      simplify compat_sys_timerfd
      Let smp_call_function_single return -EBUSY on UP

Herbert Xu (4):
      [IPSEC]: Check validity of direction in xfrm_policy_byid
      [IPSEC]: Don't warn if high-order hash resize fails
      [CRYPTO] padlock: Make CRYPTO_DEV_PADLOCK a tristate again
      [CRYPTO] tcrypt: Add missing error check

Hoang-Nam Nguyen (1):
      IB/ehca: Fix AQP0/1 QP number

Hugh Dickins (2):
      slub: don't confuse ctor and dtor
      i386: don't check_pgt_cache in flush_tlb_mm

Jack Morgenstein (1):
      IB/mlx4: Fix uninitialized spinlock for 32-bit archs

Jamal Hadi Salim (1):
      [NET_SCHED]: prio qdisc boundary condition

James.Yang (1):
      [POWERPC] Remove CPU_FTR_NEED_COHERENT for 7448.

Jan Engelhardt (1):
      Use menuconfig objects: IDE

Jan Kara (1):
      circular locking dependency found in QUOTA OFF

Jarek Poplawski (1):
      [NET]: lockdep classes in register_netdevice

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc4

Jay Lan (1):
      [IA64] kdump on INIT needs multi-nodes sync-up (v.2)

Jens Axboe (1):
      ll_rw_blk: fix gcc 4.2 warning on current_io_context()

Jeremy Fitzhardinge (2):
      i386: move common parts of smp into their own file
      i386: fix voyager build

Joachim Fenkes (4):
      IB/ehca: Correctly set GRH mask bit in ehca_modify_qp()
      IB/ehca: Remove _irqsave, move #ifdef
      IB/ehca: Beautify sysfs attribute code and fix compiler warnings
      IB/ehca: Disable scaling code by default, bump version number

Jon Tollefson (1):
      [POWERPC] Correct #endif comment

Josh Boyer (1):
      [POWERPC] Pass per-file CFLAGs for platform specific op codes

Kailang Yang (1):
      [ALSA] hda-codec - Fix ALC882/861VD codec support on some laptops

Kim Phillips (1):
      ucc_geth: eliminate max-speed, change interface-type to phy-connection-type

Kumar Gala (3):
      [POWERPC] Fix COMMON symbol warnings
      [POWERPC] 85xx: Add device nodes for error reporting devices used by EDAC
      [POWERPC] Removed hardcoded phandles from dts

Liam Girdwood (2):
      [ALSA] ASoC AC97 static GPL symbol fix
      [ALSA] ASoC AC97 device reg bugfix

Linus Torvalds (5):
      Revert "ipmi: add new IPMI nmi watchdog handling"
      x86: Fix discontigmem + non-HIGHMEM compile
      Fix ACPI suspend / device suspend ordering problem
      Revert "[PATCH] x86: Drop cc-options call for all options supported in gcc 3.2+"
      Linux v2.6.22-rc2

Martin Michlmayr (1):
      [IA64] Fix section conflict of ia64_mlogbuf_finish

Michael S. Tsirkin (3):
      IB/mthca: Fix posting >255 recv WRs for Tavor
      IB/mthca: Set cleaned CQEs back to HW ownership when cleaning CQ
      IPoIB/cm: Optimize stale connection detection

Milind Arun Choudhary (1):
      sh64: ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c

Mithlesh Thukral (1):
      NetXen: Fix NetXen driver ping on system-p

Mitsuru Chinen (1):
      [IPV4] SNMP: Display new statistics at /proc/net/netstat

Morten Banzon (1):
      [PPC] MCC2 missing in MPC826x device_list

Nate Diller (2):
      NFS: use zero_user_page
      ecryptfs: use zero_user_page

Nick Piggin (2):
      slob: implement RCU freeing
      mm: more rmap checking

Nicolas Pitre (1):
      pxamci: fix PXA27x MMC workaround for bad CRC with 136 bit response

Oleg Nesterov (3):
      NLM: don't use CLONE_SIGHAND in nlmclnt_recovery
      make freezeable workqueues singlethread
      revert "cancel_delayed_work: use del_timer() instead of del_timer_sync()"

Olof Johansson (4):
      pasemi_mac: Interrupt ack fixes
      [POWERPC] pasemi: CONFIG_GENERIC_TBSYNC no longer needed
      [POWERPC] Update pasemi_defconfig
      [POWERPC] Remove warning in mpic.c

Paul Mundt (10):
      net: Trivial MLX4_DEBUG dependency fix.
      sh64: Wire up many new syscalls.
      sh64: Fixups for the irq_regs changes.
      sh64: dma-mapping updates.
      sh64: ppoll/pselect6() and restartable syscalls.
      sh64: Fixup sh-sci build.
      sh64: Update cayman defconfig.
      sh64: generic quicklist support.
      sh64: Add .gitignore entry for syscalltab.
      nommu: add ioremap_page_range()

Peer Chen (1):
      drivers/ata: remove the wildcard from sata_nv driver

Pierre Ossman (2):
      sdhci: handle dma boundary interrupts
      mmc: use assigned major for block device

Prarit Bhargava (1):
      Remove cpu hotplug defines for __INIT & __INITDATA

Rafael J. Wysocki (1):
      swsusp: fix sysfs interface

Randy Dunlap (2):
      parport: mailing list is subscribers-only
      docbook: make kernel-locking table readable

Rene Herman (1):
      [ALSA] Fix probe of non-PnP ISA devices

Robert Reif (1):
      [SPARC32]: Fix sparc32 kdebug changes.

Roland Dreier (1):
      mlx4_core: Remove unused doorbell_lock

Rolf Eike Beer (1):
      Fix roundup_pow_of_two(1)

Satyam Sharma (1):
      [BLUETOOTH]: Fix locking in hci_sock_dev_event().

Scott Wood (1):
      gianfar: Add I/O barriers when touching buffer descriptor ownership.

Sean Hefty (3):
      RDMA/cma: Simplify device removal handling code
      RDMA/cma: Fix synchronization with device removal in cma_iw_handler
      RDMA/cma: Add check to validate that cm_id is bound to a device

Segher Boessenkool (3):
      [POWERPC] Specify GNUTARGET on $(AR) invocations
      [POWERPC] Fix sed command lines for zlib source construction
      [POWERPC] Fix ppc_rtas_progress_show()

Sergei Shtylyov (1):
      sl82c105: add speedproc() method and MWDMA0/1 support

Simon Arlott (2):
      [IA64] spelling fixes: arch/ia64/
      spelling fixes: arch/sh64/

Simon Horman (1):
      alpha: fix hard_smp_processor_id compile error

Stefan Roscher (1):
      IB/ehca: Serialize hypervisor calls in ehca_register_mr()

Stephen Hemminger (7):
      [TCP] slow start: Make comments and code logic clearer.
      sky2: remove Gigabyte 88e8056 restriction
      sky2: PHY register settings
      sky2: keep track of receive alloc failures
      sky2: MIB counter overflow handling
      sky2: remove dual port workaround
      sky2: memory barriers change

Stephen Rothwell (6):
      Declare another couple of compat syscalls.
      Revert "MAINTAINERS: remove invalid list address for TPM"
      [POWERPC] Wire up some more syscalls
      [POWERPC] Update iseries_defconfig
      [POWERPC] Fix warning on UP
      [POWERPC] Remove build warnings in windfarm_core

Takashi Iwai (1):
      [ALSA] hda-codec - Make the mixer capability check more robust

Tejun Heo (8):
      libata: separate out ata_dev_reread_id()
      libata: during revalidation, check n_sectors after device is configured
      libata-acpi: add ATA_FLAG_ACPI_SATA port flag
      libata: fix shutdown warning message printing
      libata: track spindown status and skip spindown_compat if possible
      sata_nv: fix fallout of devres conversion
      libata: remove libata.spindown_compat
      sata_via: pcim_iomap_regions() conversion missed BAR5

Thomas Gleixner (2):
      timekeeping fix patch got mis-applied
      clocksource: fix lock order in the resume path

Thomas Reitmayr (1):
      [ALSA] usbaudio - Coping with short replies in usbmixer

Timur Tabi (1):
      [POWERPC] Fix alignment problem in rh_alloc_align() with exact-sized blocks

Tony Breeds (1):
      [POWERPC] Fix Kconfig undefined symbol 'IBM_NEW_EMAC_ZMII'

Tony Luck (2):
      [IA64] wire up {signal,timer,event}fd syscalls
      [IA64] s/scalibility/scalability/

Trond Myklebust (6):
      NLM: Fix locking client timeouts...
      NFS4: Fix incorrect use of sizeof() in fs/nfs/nfs4xdr.c
      NFS: Fix some 'sparse' warnings...
      NFS: Fix more sparse warnings
      NLM: Fix sparse warnings
      SUNRPC: Fix sparse warnings

Vitaly Wool (1):
      smc911x: fix compilation breakage

Yoichi Yuasa (1):
      mmc: au1xmmc command types check from data flags

Yoshinori Sato (1):
      h8300 atomic.h update

olof@lixom.net (3):
      pasemi_mac: Fix register defines
      pasemi_mac: Terminate PCI ID list
      pasemi_mac: Fix local-mac-address parsing

wendy xiong (1):
      icom: add new sub-device-id to support new adapter

