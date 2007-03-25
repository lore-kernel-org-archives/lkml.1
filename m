Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXCYXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXCYXIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXCYXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:08:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXCYXIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:08:39 -0400
Date: Sun, 25 Mar 2007 16:08:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc5
Message-ID: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-984627110-1174864114=:6730"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-984627110-1174864114=:6730
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


There's various fixes here, ranging from some architecture updates (ia64, 
ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.

And random one-liners.

But probably more important, and likely much more visible to most people 
is the fixes for the fallout from the hrtimers and no-HZ changes, and some 
of the ACPI regressions.

Those timer changes ended up much more painful than anybody wished for, 
but big thanks to Thomas Gleixner for being on it like a weasel on a dead 
rat, and the regression list has kept shrinking.

So if you have reported a regression in the 2.6.21-rc series, please check 
2.6.21-rc5, and update your report as appropriate (whether fixed or "still 
problems with xyzzy").

		Linus

---
Adrian Bunk (3):
      X86_P4_CLOCKMOD must select CPU_FREQ_TABLE
      [X25] x25_forward_call(): fix NULL dereferences
      drivers/video/s3fb.c: fix a use-before-check

Akira Iguchi (1):
      drivers/ata/Kconfig: PATA_SCC depends on wrong platform

Alan Stern (1):
      usblp: quirk flag and device entry for Seiko Epson M129C printer

Alan Tyson (1):
      [CIFS] reset mode when client notices that ATTR_READONLY is no longer set

Alessandro Zummo (1):
      pata_ixp4xx_cf: fix interrupt

Alexandr Andreev (1):
      x86-64: wire up compat sched_rr_get_interval(2)

Alexey Dobriyan (1):
      [NET]: Copy mac_len in skb_clone() as well

Alexey Starikovskiy (1):
      ACPI: resolve HP nx6125 S3 immediate wakeup regression

Andi Kleen (4):
      x86-64: Update defconfig
      i386: Update defconfig
      i386: Enforce GPLness of VMI ROM
      x86: Export _proxy_pda for gcc 4.2

Andrew Johnson (1):
      swsusp: fix suspend when console is in VT_AUTO+KD_GRAPHICS mode

Andrew Morton (2):
      machzwd warning fix
      "ext[34]: EA block reference count racing fix" performance fix

Andy Isaacson (1):
      fix read past end of array in md/linear.c

Ankita Garg (1):
      oom fix: prevent oom from killing a process with children/sibling unkillable

Anton Blanchard (2):
      [POWERPC] Bypass hcall stats until cpu features have run
      Fix return code in pci-skeleton.c

Antonino A. Daplas (2):
      savagefb: Fix black screen on load in Savage IX
      savagefb: Fix compile error if debugging is enabled

Arnaud Patard (1):
      spi_s3c24xx.c: warning fix

Atsushi Nemoto (5):
      [MIPS] Check FCSR for pending interrupts, alternative version
      [MIPS] FPU ownership management & preemption fixes
      SPI: at25: do not use pointer before assignment
      [MIPS] Qemu: Fix Symmetric Uniprocessor support.
      [MIPS] SPARSEMEM: The first pfn of zone should be min_low_pfn, not 0.

Avi Kivity (4):
      KVM: Unset kvm_arch_ops if arch module loading failed
      KVM: Fix guest sysenter on vmx
      KVM: MMU: Fix guest writes to nonpae pde
      KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram

Bartlomiej Zolnierkiewicz (2):
      ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n
      ide: remove CONFIG_IDEDMA_{ICS,PCI}_AUTO config options

Bernhard Walle (3):
      Initialise SAK member for each virtual console to prevent oops
      Fix wrong /proc/iomem on SGI Altix
      [IA64] Fix wrong /proc/iomem on SGI Altix

Brice Goglin (4):
      myri10ge: Serverworks HT2100 provides aligned PCIe completion
      myri10ge: update wcfifo and intr_coal_delay default values
      myri10ge: fix management of >4kB allocated pages
      myri10ge: update driver version to 1.3.0-1.226

Bryan O'Sullivan (1):
      IB/ipath: Check return value of lookup_one_len

Chris Lesiak (1):
      spi: destroy workqueue after spi_unregister_master

Cyrill V. Gorcunov (1):
      i2c/ds1374: Check workqueue creation status

Dale Farnsworth (1):
      mv643xx_eth: add mv643xx_eth_shutdown function

Dan Williams (1):
      [ARM] 4271/1: iop32x: fix ep80219 detection (support iq80219 platforms)

Daniel Mack (1):
      ide: remove static prototypes from include/asm-mips/mach-au1x00/au1xxx_ide.h

Danny Kukawka (1):
      add Fujitsu Siemens Tablet PC devices to 8250_pnp.c

Dave Jones (1):
      [NET]: fix up misplaced inlines.

David Brownell (4):
      reduce pnp syslog spam
      rm pointless dmaengine exports
      gpio_direction_output() needs an initial value
      gpio_direction_output-needs-an-initial-value fix

David Howells (4):
      FRV: fix unannotated variable declarations
      NOMMU: supply get_unmapped_area() to fix NOMMU SYSV SHM
      NOMMU: make SYSV SHM nattch work correctly
      FDPIC: fix the /proc/pid/stat representation of executable boundaries

David S. Miller (3):
      [SPARC64]: Get DEBUG_PAGEALLOC working again.
      [SPARC64]: Use Kconfig.preempt
      [SPARC64]: store-init needs trailing membar.

Deepak Saxena (1):
      [MIPS] Make MIPS udelay() preempt safe under DEBUG_PREEMPT

Divy Le Ray (5):
      cxgb3 - fix ethtool cmd on multiple queues port
      cxgb3 - Auto-load FW if mismatch detected
      cxgb3 - Fix potential MAC hang
      cxgb3 - T3B2 pcie config space
      cxgb3 - fix white spaces in drivers/net/Kconfig

Eric W. Biederman (1):
      tty: Fix two reported pid leaks

Evgeniy Dushistov (4):
      ufs2: more correct work with time
      ufs: prepare write + change blocks on the fly
      ufs: zeroize the rest of block in truncate
      ufs2: tindirect truncate fix

Franck Bui-Huu (1):
      [MIPS] Always use virt_to_phys() when translating kernel addresses

G. Liakhovetski (1):
      [IrDA]: irttp_dup spin_lock initialisation

Geert Uytterhoeven (1):
      bool fbdevs must depend on FB = y

Graeme Gregory (1):
      [ARM] 4270/2: mach-s3c2443/irq.c off by one error in dma irqs

Greg Kroah-Hartman (1):
      USB: new Novatel device ids for option driver

Guennadi Liakhovetski (1):
      [ARM] 4278/1: configure pxa27x I2C SCL as "input"

Guido Guenther (1):
      rivafb: fix initial brightness

Guillaume Chazarain (1):
      i386: Don't use the TSC in sched_clock if unstable

Heiko Carstens (3):
      [S390] memory detection: fix off by one bug.
      [S390] Wire up compat_sys_epoll_pwait.
      [S390] Wire up sys_utimes.

Henrique de Moraes Holschuh (1):
      ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set (v2)

Hideo Saito (1):
      sh: Fix PCI BAR address-space wraparound.

Ingo Molnar (2):
      futex: PI state locking fix
      setup_boot_APIC_clock() irq-enable fix

J. Bruce Fields (1):
      [CRYPTO] api: scatterwalk_copychunks() fails to advance through scatterlist

Jack Steiner (1):
      [IA64] Fix get_model_name() for mixed cpu type systems

James Bottomley (1):
      fix process crash caused by randomisation and 64k pages

James Morris (1):
      time: fix formatting in /proc/timer_list

Jamie Clark (1):
      sata_sil24: Add Adaptec 1220SA PCI ID

Jarek Poplawski (2):
      lockdep: lockdep_depth vs. debug_locks
      lockdep: debug_show_all_locks & debug_show_held_locks vs. debug_locks

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc3

Jay Lan (1):
      [IA64] Fix typo/thinko in crash.c

Jean Delvare (3):
      [S390] strlcpy is smart enough
      i2c-amd8111: Missed cleanup
      i2c-i801: Restore the device state before leaving

Jeff Garzik (1):
      [netdrvr] ewrk3: correct card detection bug

Jeremy Fitzhardinge (1):
      i386: fix typo in sync_constant_test_bit()'s name

Jim Radford (1):
      USB: fix usb-serial regression

Joachim Deguara (1):
      [ALSA] hda-intel - Fix HDA buffer alignment

Joachim Fenkes (1):
      IB/ehca: Make scaling code work without CPU hotplug

Johannes Berg (1):
      change misleading EFI partition support description

Johannes Schlumberger (1):
      [CRYPTO] doc: Fix typo in hash example

Johannes Weiner (1):
      Documentation/sysrq.txt: added short description for 'Q' (timerlist)

John Heffner (1):
      [TCP]: Fix tcp_mem[] initialization.

John Keller (2):
      ia64: platform_kernel_launch_event is noop on generic kernel
      [IA64] Altix: ioremap vga_console_iobase

Jon Dowland (1):
      USB: two more device ids for dm9601 usbnet driver

Joy Latten (1):
      [XFRM]: ipsecv6 needs a space when printing audit record.

Ken L Johnson (1):
      USB: berry_charge: correct dbg string for second magic command

Kou Ishizaki (1):
      scc_pata: dependency fix

Krzysztof Helt (1):
      [ARM] 4272/1: Missing symbol h1940_pm_return fix

Larry Finger (1):
      bcm43xx: MANUALWLAN fixes

Len Brown (5):
      ACPI: Add support to parse 2nd MADT
      ACPICA: revert "acpi_serialize" changes
      ACPI: parse 2nd MADT by default
      ACPI: IA64: fix allnoconfig build
      ACPI: IA64: fix %ll build warnings

Li Yang (1):
      Revert "ucc_geth: returns NETDEV_TX_BUSY when BD ring is full"

Linus Torvalds (3):
      Revert "ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)"
      x86-64: add "local_apic_timer_c2_ok" here too
      Linux 2.6.21-rc5

Marcel Selhorst (1):
      tpm_infineon: maintainer

Mark Glines (1):
      airprime: USB ID for Novatel EV620 mini PCI-E card

Masayuki Nakagawa (1):
      [IPV6]: ipv6_fl_socklist is inadvertently shared.

Mathieu Desnoyers (2):
      [POWERPC] Fix atomicity of TIF update in flush_thread()
      Fix atomicity of TIF update in flush_thread() for x86_64

Mattia Dongili (1):
      sony-laptop: MAINTAINERS fix entry, add L: and W:

Michael Halcrow (1):
      eCryptfs: fix possible NULL ptr deref in ecryptfs_d_release()

Michael Holzheu (1):
      [S390] reboot from and dump to SCSI under z/VM fails.

Michael Krufky (1):
      cx88-dvb: fix nxt200x rf input switching

Michael S. Tsirkin (3):
      IPoIB/cm: Fix reaping of stale connections
      IPoIB: Fix use-after-free in path_rec_completion()
      IB/ipoib: Fix thinko in packet length checks

Michal Schmidt (1):
      airo: Fix an error path memory leak

Mike Frysinger (1):
      sh: Convert struct ioctls to static defines.

Mohan Kumar M (1):
      [POWERPC] Avoid hypervisor statistics calculation in real mode

Nick Piggin (1):
      mm: fix madvise infinine loop

Nicolas Boichat (1):
      [ALSA] hda-codec - Add support for MacBook Pro 1st generation

Nigel Williams (1):
      [IrDA]: Delay needed when uploading firmware chunks

Oliver Neukum (1):
      USB: necessary update for mos7720 driver

Ondrej Zajicek (1):
      sstfb: fix pixclock setting on Voodoo 1/2 cards

Patrick McHardy (4):
      [NET]: Fix fib_rules dump race
      [BRIDGE]: Fix fdb RCU race
      [NETFILTER]: nf_conntrack_netlink: add missing dependency on NF_NAT
      [NETFILTER]: nat: avoid rerouting packets if only XFRM policy key changed

Patrick Ringl (1):
      fix typos in net/ieee80211/Kconfig

Paul Mundt (4):
      sh: Define missing __NR_readahead.
      sh: Fix SH-3 cache entry_mask and way_size calculation.
      sh: Fix bogus regs pointer in do_IRQ().
      serial: Fix sh-sci break interrupt/sysrq handling.

Pavel Machek (1):
      fix extra BIOS invocation during resume

Pete Zaitcev (1):
      USB: RAZR v3i unusual_devs

Peter Zijlstra (1):
      nfs: fix congestion control

Rafael J. Wysocki (4):
      swsusp: Fix resume error path in platform mode
      swsusp: disable nonboot CPUs before entering platform suspend
      swsusp: Fix SNAPSHOT_S2RAM ioctl
      Make XFS workqueues nonfreezable

Ralf Baechle (22):
      [MIPS] IP27, IP35: Fix warnings.
      [CHAR] lcd: Fix two warnings.
      [MIPS] Compat: Fix build if CONFIG_SYSVIPC is disabled.
      [MIPS] Lasat: Downgrade 64-bit kernel from experimental to broken.
      [MIPS] RTLX: Don't use volatile; it's fragile.
      [MIPS] RTLX: Harden against compiler reordering and optimization.
      [MIPS] RTLX: Protect rtlx_{read,write} with mutex.
      [MIPS] RTLX: Handle copy_*_user return values.
      [MIPS] Lockdep: Fix recursion bug.
      [MIPS] Kconfig: Move missplaced NR_CPUS default from SMTC to VSMP.
      ide: au1xxx: fix use of mixed declarations and code
      Fix build error due to not including <linux/errno.h>
      [MIPS] VI: TRACE_IRQS_OFF clobbers $v0, so save & restore around call.
      [MIPS] Export except_vec_vi_{mori,lui,ori} as text symbols.
      SAA9730: Fix large pile of warnings
      [MIPS] Fix pipeline hazard.
      [MIPS] Implement flush_anon_page().
      [MIPS] ARC: Fix warning.
      [MIPS] R3000: local_flush_data_cache_page take a pointer argument.
      [MIPS] Jazz: Fix warning.
      [MIPS] SB1: Fix pile of gcc's bogus format string warnings.
      [MIPS] SB1250: Fix bugs/warnings by creative use of volatile.

Ralph Wuerthner (2):
      [S390] zcrypt: fix possible dead lock in AP bus module
      [S390] zcrypt: fix possible race when unloading zcrypt driver modules

Randy Cushman (1):
      [ALSA] ac97 - fix AD shared shared jack control logic

Randy Dunlap (1):
      libata: kernel-doc fix

Robert Olsson (1):
      [IPV4]: Do not disable preemption in trie_leaf_remove().

Roland McGrath (1):
      i386: clear segment register padding in core dumps

Russell King (1):
      [ARM] Fix breakage caused by 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc

Sam Ravnborg (1):
      x86-64: fix section mismatch warnings

Samuel Ortiz (1):
      [IrDA]: Calling ppp_unregister_channel() from process context

Sean Hefty (1):
      IPoIB: Fix race in detaching from mcast group before attaching

Sebastian Siewior (1):
      [CRYPTO] tcrypt: Fix error checking for comp allocation

Sergei Shtylyov (1):
      cmd64x: fix recovery time calculation (take 3)

Stefan Richter (1):
      ieee1394: fix oops on "modprobe -r ohci1394" after network class_device conversion

Stefano Brivio (1):
      hwmon: Build fix for SENSORS_W83793

Stelian Pop (1):
      [ARM] 4264/1: ldrex/strex syntax errors with recent compilers

Stephen Hemminger (3):
      skge: deadlock on tx timeout
      skge: mask irqs when device down
      skge: use per-port phy locking

Steve French (2):
      [CIFS] Do not negotiate new POSIX_PATH_OPERATIONS_CAP yet
      [CIFS] Allow reset of file to ATTR_NORMAL when archive bit not set

Steve Wise (1):
      RDMA/cxgb3: Handle build_phys_page_list() failure in iwch_reregister_phys_mem()

Takashi Iwai (6):
      [ALSA] soc - Fix dependencies in Kconfig files
      [ALSA] hda-intel - Fix codec probe with ATI contorllers
      [ALSA] hda-codec - Fix speaker output on MacPro
      [ALSA] intel8x0 - Fix Oops at kdump crash kernel
      [ALSA] hda-codec - Add model for HP Compaq d5700
      [ALSA] hda-codec - Add model for HP Compaq d5750

Tejun Heo (4):
      jmicron: make ide jmicron driver play nice with libata ones
      libata: don't whine if ->prereset() returns -ENOENT
      sata_inic162x: kill double region requests
      pata_ixp4xx_cf: fix oops on detach

Thiemo Seufer (2):
      [MIPS] Misc fixes for plat_irq_dispatch functions
      [MIPS] mips-boards: More liberal check for mips-board console

Thomas Gleixner (12):
      hrtimer: prevent overrun DoS in hrtimer_forward()
      hrtimer: fix up unlocked access to wall_to_monotonic
      fix MTIME_SEC_MAX on 32-bit
      clockevents: Fix suspend/resume to disk hangs
      i386: trust the PM-Timer calibration of the local APIC timer
      i386: clockevents fix breakage on Geode/Cyrix PIT implementations
      i386: disable local apic timer via command line or dmi quirk
      i386: add command line option "local_apic_timer_c2_ok"
      x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to itself
      i386: Prevent early access to TSC to avoid crash on TSCless systems
      dynticks: fix hrtimer rounding error in next_timer_interrupt
      clocksource: Fix thinko in watchdog selection

Thomas Renninger (1):
      ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)

Tobin Davis (2):
      [ALSA] hda-codec - Add suppoprt for Asus M2N-SLI motherboard
      [ALSA] hda-codec - more systems for Analog Devices

Tommi Kyntola (1):
      [ALSA] intel8x0 - Fix speaker output after S2RAM

Trond Myklebust (1):
      nfs: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files

Ursula Braun (1):
      [S390] cio: qdio slsb setup

Uwe Kleine-König (1):
      [ARM] 4235/1: ns9xxx: declare the clock functions as "const"

Vasily Averin (1):
      smbfs: double free memory corruption

Vlad Yasevich (4):
      [SCTP]: Clean up stale data during association restart
      [SCTP]: Increment error counters on user requested HBs.
      [SCTP]: Reset some transport and association variables on restart
      [SCTP]: Correctly reset ssthresh when restarting association

Zach Brown (1):
      dio: invalidate clean pages before dio write

Zilvinas Valinskas (1):
      initialise pi_lock if CONFIG_RT_MUTEXES=N

Zou Nan hai (1):
      [IA64] min_low_pfn and max_low_pfn calculation fix

suzuki (1):
      fix rescan_partitions to return errors properly
---1463790079-984627110-1174864114=:6730--
