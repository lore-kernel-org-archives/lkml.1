Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYCQACR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYCQACR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 20:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCQACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 20:02:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbYCQAB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:01:59 -0400
Date: Sun, 16 Mar 2008 17:01:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc6
Message-ID: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I lost a day-and-a-half this week due to a disk that decided to get 
read errors due to an unfortunate power outage, and had to spend too much 
time regenerating my normal setup, but I don't think I lost any emails, 
and things seemed to have calmed down a bit, so here's to hoping that -rc6 
is starting to look better.

The dirstat shows the usual pattern of most changes being in drivers and 
architecture updates, although this time it's a bit skewed by the parisc 
and powerpc updates (hopefully closing the parisc compile regression among 
other things), which means that arch is about half, and drivers are just 
under a third of the patch (it seems to be usually the other way around). 

Documentation updates bring most of the rest:

	   5.4% Documentation/laptops/
	   2.7% Documentation/power/
	  17.0% Documentation/
	   3.8% arch/arm/
	   9.1% arch/mips/
	   8.1% arch/parisc/configs/
	  16.8% arch/parisc/
	  13.7% arch/powerpc/configs/
	  15.6% arch/powerpc/
	  46.4% arch/
	   2.3% drivers/ata/
	   8.7% drivers/memstick/host/
	   9.5% drivers/memstick/
	   4.2% drivers/video/
	  27.4% drivers/
	   2.2% fs/
	   2.3% include/

but the above is hiding the fact that there's a lot of small updates all 
over that just aren't big enough to show up in the percentage counts, but 
hopefully help drive down the regression list. More still pending, though.

Shortlog appended, patches and git trees in all the usual places once they 
have mirrored out.

		Linus

---
Adam Baker (1):
      rt2x00: never disable multicast because it disables broadcast too

Adam Litke (1):
      hugetlb: correct page count for surplus huge pages

Adrian Bunk (8):
      sony-laptop.c: fix off-by-one
      fix drivers/net/atarilance.c compilation
      FIXED_PHY must depend on PHYLIB=y
      make s2io.c:init_tti() static
      [WATCHDOG] make watchdog/hpwdt.c:asminline_call() static
      i2c-amd756: Fix off-by-one
      [MIPS] Use KBUILD_DEFCONFIG
      [PARISC] move defconfig to arch/parisc/configs/

Ahmed S. Darwish (1):
      smackfs: do not trust `count' in inodes write()s

Alan Cox (1):
      riscom8: Fix hang on load

Alex Dubov (11):
      memstick: introduce correct definitions in the header
      memstick: add memstick_suspend/resume_host methods
      memstick: make sure number of command retries is exactly as specified
      memstick: drop DRIVER_VERSION numbers as meaningless
      tifm: fix the MemoryStick host fifo handling code
      tifm: fix memorystick host initialization code
      tifm: clear interrupt mask bits before setting them on adapter init
      memstick: add support for decoding "specfile" media attributes
      memstick: fix parsing of "assembly_date" attribute field
      memstick: try harder to recover from unsuccessful interface mode switch
      memstick: add support for JMicron jmb38x MemoryStick host controller

Alexey Dobriyan (2):
      [NETFILTER]: nf_conntrack: add \n to "expectation table full" message
      modules: warn about suspicious return values from module's ->init() hook

Alexey Starikovskiy (1):
      ACPI: EC: Handle IRQ storm on Acer laptops

Andrew Morton (5):
      fs/ocfs2/dlm/dlmdomain.c: fix printk warning
      PCI: rename DECLARE_PCI_DEVICE_TABLE to DEFINE_PCI_DEVICE_TABLE
      USB: drivers/usb/storage/sddr55.c: fix uninitialized var warnings
      rename DECLARE_PCI_DEVICE_TABLE to DEFINE_PCI_DEVICE_TABLE
      net: fix build with CONFIG_NET=n

Andrew Paprocki (1):
      [WATCHDOG] it8712f_wdt support for 16-bit timeout values, WDIOC_GETSTATUS

Andrey Borzenkov (1):
      ACPI: button: make real parent for input devices in device tree

Andy Fleming (1):
      [POWERPC] 83xx: Make 83xx perfmon support selectable

Arnaud Patard (1):
      gpio/pca953x bugfix: mark as can_sleep

Arne Redlich (2):
      IB/iser: Fix list iteration bug
      IB/iser: Handle iser_device allocation error gracefully

Arthur Jones (1):
      MAINTAINERS: update ipath owner

Atsushi Nemoto (1):
      [MIPS] Fix plat_ioremap for JMR3927

Auke Kok (2):
      e100: Do suspend/shutdown like e1000
      Intel ethernet adapter: Update MAINTAINERS

Benjamin Herrenschmidt (3):
      [POWERPC] Fix bogus test for unassigned PCI resources
      [POWERPC] Fix sleep on some powerbooks
      [POWERPC] Fix viodasd driver with scatterlist debug

Bjorn Helgaas (3):
      ACPI: add _PRT quirks to work around broken firmware
      PNP: revert Supermicro H8DCE motherboard quirk
      PNP: disable PNP motherboard resources that overlap PCI BARs

Bryan Wu (1):
      BF54x LQ043 Framebuffer driver: fix bug lcd_device_register API breakage

Carlos Corbacho (6):
      acer-wmi: Rename mail LED correctly & remove hardcoded colour
      acer-wmi: Don't warn if mail LED cannot be detected
      ACPI: WMI: Clean up handling of spec violating data blocks
      acer-wmi: Make device detection error messages more descriptive
      acer-wmi: Fix DSDT path in documentation
      acer-wmi: Add DMI quirk for mail LED support on Acer Aspire 3610/ 5610

Chidambar 'ilLogict' Zinnoury (1):
      [SCTP]: Fix local_addr deletions during list traversals.

Chris Dearman (1):
      [MIPS] Added missing cases for rdhwr emulation

Dan Williams (1):
      async_tx: checkpatch says s/__FUNCTION__/__func__/g

Dave Young (1):
      bluetooth: hci_core: defer hci_unregister_sysfs()

David Brownell (10):
      ACPI: acpi_pci_set_power_state() cleanups
      ARM: OMAP: fix false lockdep warnings
      ARM: OMAP: fix omap i2c init (regression)
      ARM: OMAP1: omap h3 regression and build fix
      ARM: OMAP1: omap h2 regression fix
      ARM: OMAP1: omap1/pm.c build fix
      ARM: OMAP: gpio lockdep updates
      net/enc28j60: oops fix
      [ARM] 4848/1: at91: remove false lockdep warnings
      USB: fix ehci unlink regressions

David Howells (1):
      RxRPC: fix rxrpc_recvmsg()'s returning of msg_name

David Woodhouse (1):
      Remove <linux/genhd.h> from user-visible headers.

Dirk DeSchepper (1):
      USB: option: add novatel device ids

Dmitry Shapin (1):
      USB: cypress_m8: add UPS Powercom (0d9f:0002)

Emil Tantilov (1):
      ixgbe: fix typo in speed mesage

Eric Leblond (2):
      [NETFILTER]: nfnetlink_queue: fix computation of allocated size for netlink skb.
      [NETFILTER]: nfnetlink_log: fix computation of netlink skb size

Eugene Teo (1):
      lguest: make sure cpu is initialized before accessing it

FUJITA Tomonori (2):
      alpha: use iommu_is_span_boundary helper function
      [PARISC] make ptr_to_pide() static

Florian Fainelli (2):
      [WATCHDOG] Remove volatiles from watchdog device structures
      [libata] Add support for the RB500 PATA CompactFlash

Frank Seidel (1):
      nozomi: fix initialization and early flow control access

Glauber Costa (1):
      ACPI: use ACPI_DEBUG_PRINT instead of printk in acpi_processor_hotplug_notify()

Grant Likely (1):
      [POWERPC] Fix zImage-dtb.initrd build error

Greg Kroah-Hartman (2):
      sysdev: fix problem with sysdev_class being re-registered
      PCI: fix issue with busses registering multiple times in sysfs

Greg Ungerer (2):
      [ARM] 4849/1: move ATAGS asm definitions
      [ARM] 4850/1: include generic pgtable.h for !CONFIG_MMU case

Gregory Haskins (2):
      Revert "cpu hotplug: adjust root-domain->online span in response to hotplug event"
      keep rd->online and cpu_online_map in sync

Guennadi Liakhovetski (1):
      [ARM] 4845/1: Orion: Ignore memory tags with invalid data

Gui Jianfeng (1):
      SCTP: Fix chunk parameter processing bug

Guido Guenther (1):
      [POWERPC] Fix build of modular drivers/macintosh/apm_emu.c

Hans Verkuil (1):
      i2c: Keep client->driver and client->dev.driver in sync

Harvey Harrison (9):
      net: replace __inline with inline
      irda: replace __inline with inline
      isdn: replace __inline with inline
      atm: replace remaining __FUNCTION__ occurrences
      [WATCHDOG] replace remaining __FUNCTION__ occurrences
      [ARM] replace remaining __FUNCTION__ occurrences
      ata: replace remaining __FUNCTION__ occurrences
      ACPI: replace remaining __FUNCTION__ occurrences
      iop-adma.c: replace remaining __FUNCTION__ occurrences

Helge Deller (2):
      stifb: fix crash A1439A CRX (Rattler) graphics card
      [PARISC] head.S: section mismatch fixes

Hiroshi DOYU (1):
      ARM: OMAP: Fix sleep under spinlock for cpufreq

Hiroshi Shimamoto (1):
      sched: fix race in schedule()

Holger Macht (1):
      ACPI: Do not pass NULL to acpi_get_handle() when looking for _EJD

Ilpo Järvinen (1):
      [TCP]: Prevent sending past receiver window with TSO (at last skb)

Ingo Molnar (6):
      fix BIOS PCI config cycle buglet causing ACPI boot regression
      x86: ioremap, remove WARN_ON()
      sched: fix update_load_add()/sub()
      sched: fix calc_delta_mine()
      sched: fix fair sleepers
      sched: simplify sched_slice()

Ionut Nicu (1):
      [POWERPC] QE: Make qe_get_firmware_info reentrant

Ivo van Doorn (1):
      rt2x00: Add new D-Link USB ID

J. Bruce Fields (1):
      nfsd: fix oops on access from high-numbered ports

James Bottomley (3):
      firmware: provide stubs for the FW_LOADER=n case
      drivers: fix dma_get_required_mask
      [PARISC] add pa8900 CPUs to hardware inventory

James Chapman (2):
      [PPPOL2TP]: Make locking calls softirq-safe
      [PPPOL2TP]: Fix SMP issues in skb reorder queue handling

Jan Beulich (1):
      avoid endless loops in lib/swiotlb.c

Jan Engelhardt (2):
      [OCFS2]: constify function pointer tables
      [NETFILTER]: xt_time: fix failure to match on Sundays

Jan Nikitenko (2):
      au1550_spi: fix prototype of irq handler
      spi_bitbang: short transfer status fix

Jarkko Nikula (1):
      ARM: OMAP: Pass logical DMA channel number always to callback handlers

Jarod Wilson (2):
      firewire: fw-sbp2: set single-phase retry_limit
      firewire: fw-ohci: use dma_alloc_coherent for ar_buffer

Jean Delvare (2):
      ACPI: Fix a duplicate log level
      i2c: chips subdirectory is deprecated

Jeremy Kerr (2):
      [POWERPC] spufs: don't (ab)use SCHED_IDLE
      [POWERPC] spufs: fix rescheduling of non-runnable contexts

Jeremy McNicoll (1):
      [POWERPC] 85xx: sbc8548 - Fix incorrect PCI-X and PCI interrupt map

Jesper Juhl (1):
      PCI Hotplug: Fix small mem leak in IBM Hot Plug Controller Driver

Jim Meyering (1):
      USB: usbaudio: handle kcalloc failure

Jiri Kosina (1):
      acer-wmi: build depends on i8042

Jiri Slaby (2):
      char: riscom, fix rc_board indexing
      block: floppy: fix rmmod lockup

Joe Perches (1):
      [ARM] include/asm-arm - use angle brackets for includes

Joel Becker (1):
      ocfs2: Fix endian bug in o2dlm protocol negotiation.

Joel Soete (1):
      [PARISC] pdc_stable: fix compile errors

Johann Felix Soden (1):
      ACPI: buffer array too short in drivers/acpi/system.c

John W. Linville (1):
      drivers/net/Kconfig: fix whitespace for GELIC_WIRELESS entry

Jon Mason (2):
      RDMA/cxgb3: Return correct max_inline_data when creating a QP
      RDMA/cxgb3: Fix iwch_create_cq() off-by-one error

Jon Schindler (4):
      drivers/net/appletalk/ltpc.c: replace init_module&cleanup_module with module_init&module_exit
      drivers/net/arcnet/capmode.c: replace init_module&cleanup_module with module_init&module_exit
      drivers/net/apne.c: replace init_module&cleanup_module with module_init&module_exit
      drivers/net/ac3200.c: replace init_module&cleanup_module with module_init&module_exit

Josh Boyer (1):
      of_serial: fix section mismatch warnings

Kirill A. Shutemov (1):
      [NET]: include <linux/types.h> into linux/ethtool.h for __u* typedef

Komuro (1):
      axnet_cs: change debugging level for "Too much work at interrupt" message.

Krzysztof Helt (3):
      tridentfb: register should be left in non-locked state
      tridentfb: fix memory size detection
      mbxfb: fix incorrect argument type

Kyle McMartin (11):
      [PARISC] remove old timerfd syscall
      [PARISC] wire up timerfd syscalls
      [PARISC] move VMALLOC_* definitions to fixmap.h
      [PARISC] unbreak pgalloc.h
      [PARISC] bump __NR_syscalls
      [PARISC] remove unused pdc_iodc_printf function
      [PARISC] dump_stack in show_regs
      [PARISC] pdc_console: fix bizarre panic on boot
      [PARISC] clean up show_stack
      [PARISC] futex: special case cmpxchg NULL in kernel space
      [PARISC] add back Crestone Peak cpu

Kyungmin Park (2):
      ARM: OMAP: Remove compiler warning when i2c is not set
      ARM: OMAP2: Register the L4 io bus to boot OMAP2

Lee Schermerhorn (1):
      mempolicy: fix reference counting bugs

Len Brown (6):
      Revert "ACPI: EC: Use proper handle for boot EC"
      Merge branches 'release', 'bugzilla-8570', 'bugzilla-9966', 'bugzilla-9998', 'bugzilla-10100', 'bugzilla-10132', 'bugzilla-10138' and 'bugzilla-10206' into release
      Merge branches 'release' and 'thermal' into release
      Merge branches 'release', 'button-sysfs', 'misc', 'mismatch', 'randconfig' and 'toshiba' into release
      Merge branches 'release', 'ejd', 'sony' and 'wmi' into release
      Merge branches 'release' and 'doc' into release

Lennert Buytenhek (2):
      [ARM] 4855/1: Orion: use correct ethernet unit address range
      [ARM] 4856/1: Orion: initialise the sixth PCIe MBUS mapping window as well

Li Yang (3):
      [POWERPC] 83xx: Fix wrong USB phy type in mpc837xmds dts
      [POWERPC] 83xx: Add local bus device nodes to MPC837xMDS device trees.
      USB: fsl_usb2_udc: fix broken Kconfig

Lin Ming (1):
      ACPI: fix boot oops regression in thermal

Linus Torvalds (24):
      Merge git://git.kernel.org/.../wim/linux-2.6-watchdog
      Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2
      Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus
      Merge git://git.kernel.org/.../gregkh/driver-2.6
      Merge git://git.kernel.org/.../gregkh/pci-2.6
      Merge git://git.kernel.org/.../gregkh/usb-2.6
      Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev
      Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband
      Merge branch 'for-linus' of git://git.kernel.org/.../mingo/linux-2.6-sched-devel
      Merge branch 'for-linus' of git://git.kernel.org/.../x86/linux-2.6-x86
      Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
      Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6
      Merge git://git.kernel.org/.../davem/net-2.6
      Merge branch 'merge' of git://git.kernel.org/.../paulus/powerpc
      Merge master.kernel.org:/home/rmk/linux-2.6-arm
      Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6
      Merge git://git.kernel.org/.../gregkh/pci-2.6
      Merge branch 'fixes' of git://git.kernel.org/.../djbw/async_tx
      Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband
      Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
      Merge git://git.kernel.org/.../davem/net-2.6
      ACPI: Remove ACPI_CUSTOM_DSDT_INITRD option
      Merge branch 'master' of git://git.kernel.org/.../kyle/parisc-2.6
      Linux 2.6.25-rc6

Marc Dionne (1):
      struct export_operations: adjust comments to match current members

Marcelo Tosatti (1):
      pagemap: proper read error handling

Martin Michlmayr (1):
      mv643xx_eth: Define module alias for platform device

Masatake YAMATO (1):
      Typo in Documentation/scheduler/sched-stats.txt

Michael Ellerman (1):
      [POWERPC] Fix large hash table allocation on Cell blades

Michael Hennerich (3):
      BF54x LQ043 Framebuffer driver: fix bug NULL for gpio_request label is not allowed
      BF54x LQ043 Framebuffer driver: Update copyright on previously modified files
      fbdev: add BF52x EZkit Display driver

Mirko Bordignon (1):
      USB: new ftdi_sio device id

Neil Horman (1):
      [SCTP]: Bring MAX_BURST socket option into ietf API extension compliance

NeilBrown (2):
      md: fix formatting error in /proc/mdstat
      md: reduce CPU wastage on idle md array with a write-intent bitmap

Nick Piggin (1):
      iov_iter_advance() fix

Nicolas Ferre (1):
      [ARM] AT91: correct at91sam9263ek LCD power gpio pin

Nicolas Pitre (1):
      [ARM] 4847/1: kprobes: fix compilation with CONFIG_DEBUG_FS=y

Ondrej Zary (1):
      de2104x: remove BUG_ON() when changing media type

Or Gerlitz (1):
      IPoIB: Don't drop multicast sends when they can be queued

Patrick Marchand Latifi (4):
      IB/ipath: Fix potentially wrong RNR retry counter returned in ipath_query_qp()
      IB/ipath: Fix RC QP initialization
      IB/ipath: Fix error completion put on send CQ instead of recv CQ
      IB/ipath: Reset the retry counter for RDMA_READ_RESPONSE_MIDDLE packets

Patrick McHardy (4):
      [NETFILTER]: nfnetlink: fix ifdef in nfnetlink_compat.h
      [NETFILTER]: nfnetlink_log: fix EPERM when binding/unbinding and instance 0 exists
      [NETFILTER]: nfnetlink_queue: fix EPERM when binding/unbinding and instance 0 exists
      [NETFILTER]: nf_queue: don't return error when unregistering a non-existant handler

Paul Bolle (1):
      lguest: Do not append space to guests kernel command line

Paul E. McKenney (1):
      rcu: move PREEMPT_RCU config option back under PREEMPT

Paul Mackerras (2):
      Merge branch 'master' of git://git.kernel.org/.../jk/spufs into merge
      [POWERPC] Add __ucmpdi2 for 64-bit comparisons in 32-bit kernels

Paul Mundt (1):
      nommu: Provide is_vmalloc_addr() stub.

Pavel Emelyanov (1):
      [NET]: Make /proc/net a symlink on /proc/self/net (v3)

Pekka Enberg (1):
      [NETFILTER]: nf_conntrack: replace horrible hack with ksize()

Pete Wyckoff (2):
      Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs"
      IB/fmr_pool: Flush all dirty FMRs from ib_fmr_pool_flush()

Pete Zaitcev (1):
      USB: fix usb-serial generic recursive lock

Peter Zijlstra (2):
      sched: min_vruntime fix
      sched: fix overload performance: buddy wakeups

Rafael J. Wysocki (1):
      Hibernation: Fix mark_nosave_pages()

Ralf Baechle (8):
      [MIPS] Allow 48Hz to be selected if CONFIG_SYS_SUPPORTS_ARBIT_HZ is set.
      [MIPS] Export __ucmpdi2 to modules.
      [MIPS] IP27: Tighten up CPU description to fix warnings.
      [MIPS] Fix loads of section missmatches
      [MIPS] Fix yosemite build error
      [MIPS] Yosemite: Fix a few more section reference bugs.
      [MIPS] Delete leftovers of old pcspeaker support.
      [MIPS] Clocksource: Only install r4k counter as clocksource if present.

Ralph Campbell (1):
      IB/ipath: Fix IB compliance problems with link state vs physical state

Randolph Chung (1):
      [PARISC] clean up include/asm-parisc/elf.h

Randy Dunlap (4):
      ACPI: prevent randconfig build failure on empty ACPI_CUSTOM_DSDT_FILE
      laptops: move laptop-mode.txt to Documentation/laptops/
      documentation:  Move power-related files to Documentation/power/
      kernel-doc: set verbose mode via environment

Robert P. J. Day (3):
      USB: g_printer.h does not need to be "unifdef"ed.
      USB: Remove __KERNEL__ check from non-exported gadget.h.
      USB:Update mailing list information in documentation

Roel Kluin (2):
      ahci: logical-bitwise and confusion in ahci_save_initial_config()
      tifm_sd: DATA_CARRY is not boolean in tifm_sd_transfer_data()

Roland Dreier (5):
      [WATCHDOG] Fix declaration of struct smbios_entry_point in hpwdt
      [WATCHDOG] Fix return value warning in hpwdt
      [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
      IPoIB/cm: Set tx_wr.num_sge in connected mode post_send()
      IPoIB: Allocate priv->tx_ring with vmalloc()

Roland McGrath (2):
      x86: ia32 syscall restart fix
      genhd must_check warning fix

Russell King (1):
      Merge branch 'omap-fixes'

Rusty Russell (4):
      lguest: fix __get_vm_area usage.
      lguest: Sanitize the lguest clock.
      lguest: Revert 1ce70c4fac3c3954bd48c035f448793867592bc0, fix real problem.
      modules: fix module waiting for dependent modules' init

SDiZ (1):
      bluetooth: CONWISE Technology based adapters with buggy SCO support (bugzilla #9027)

Sam Ravnborg (3):
      ACPI: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
      acer-wmi: fix section mismatch warnings
      ACPI: fix section mismatch in acpi_pci_root_add

Scott Wood (1):
      [POWERPC] 8xx: Fix wrapper platform for adder875, and combine defconfigs.

Sean Hefty (1):
      IB/cm: Flush workqueue when removing device

Sebastian Siewior (1):
      libertas: fix the 'compare command with itself' properly

Stefan Richter (9):
      firewire: endianess fix
      firewire: endianess annotations
      firewire: fw-ohci: PPC PMac platform code
      firewire: fw-ohci: Apple UniNorth 1st generation support
      firewire: warn on fatal condition in topology code
      firewire: update Kconfig help text
      firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
      ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
      firewire: fw-ohci: shut up false compiler warning on PPC32

Steve Wise (1):
      RDMA/iwcm: Don't access a cm_id after dropping reference

Sunil Mushran (5):
      ocfs2/dlm: Add missing dlm_lock_put()s
      ocfs2/dlm: Add missing dlm_lockres_put()s in migration path
      ocfs2/dlm: Add missing dlm_lockres_put()s
      ocfs2/dlm: Print message showing the recovery master
      ocfs2/dlm: dlm_thread should not sleep while holding the dlm_spinlock

Tao Ma (3):
      ocfs2: Use dlm_print_one_lock_resource for lock resource print
      ocfs2: Fix an endian bug in online resize.
      ocfs2: Fix NULL pointer dereferences in o2net

Tejun Heo (3):
      libata: allow LLDs w/o any reset method
      libata-sff: handle controllers w/o ctl register
      libata: don't allow sysfs read access to force param

Theodore Ts'o (1):
      [POWERPC] Export empty_zero_page

Thibaut VARENE (1):
      [PARISC] add back AD1889 MAINTAINERS entry

Thiemo Seufer (1):
      [MIPS] Fix typo in comment

Thomas Bogendoerfer (2):
      i8042: use SGI_HAS_I8042 to select SGI i8042 handlinig
      [MIPS] BCM1480: Init pci controller io_map_base

Thomas Gleixner (1):
      x86: remove quicklists

Thomas Klein (1):
      ehea: Fix missing Kconfig dependency

Thomas Renninger (1):
      ACPICA: Warn if packages with invalid references are evaluated

Timur Tabi (1):
      [POWERPC] QE: Fix QE firmware uploading limit

Tobias Klauser (2):
      bluetooth: Make hci_sock_cleanup() return void
      bluetooth: make bnep_sock_cleanup() return void

Tom Tucker (2):
      SVCRDMA: Add xprt refs to fix close/unmount crash
      SVCRDMA: Fix erroneous BUG_ON in send_write

Tony Breeds (3):
      [POWERPC] Fix undefined pmu_sys_suspended compilation error
      [POWERPC] Fix drivers/macintosh/mediabay.c when !CONFIG_ADB_PMU
      [POWERPC] Fix arch/powerpc/platforms/powermac/pic.c when !CONFIG_ADB_PMU

Tony Lindgren (4):
      ARM: OMAP1: Fix compile for boards depending on old gpio expander
      ARM: OMAP1: Refresh OSK defconfig
      ARM: OMAP1: Refresh H2 defconfig
      ARM: OMAP1: Compile in other 16xx boards to OSK defconfig

Uwe Kleine-König (2):
      [ARM] 4851/1: ns9xxx: fix size of gpiores
      [ARM] 4853/1: include uImage target in make help

Vitaly Bordug (1):
      [POWERPC] 8xx: fix swap

Wolfgang Ocker (1):
      [MIPS] Alchemy: Fix ids in Alchemy db dma device table

Yoichi Yuasa (1):
      [MIPS] Lasat: fix LASAT_CASCADE_IRQ

Yoshinori Sato (1):
      h8300: fix recent uaccess breakage

Yuri Tikhonov (1):
      [PPC] 8xx: swap bug-fix

Zhang Rui (1):
      ACPI Exception (): AE_NOT_FOUND, Processor Device is not present (update)

Zhang Wei (4):
      fsldma: Fix fsldma.c warning messages when it's compiled under PPC64.
      dmaengine: Fix a bug about BUG_ON() on DMA engine capability DMA_INTERRUPT.
      fsldma: Add device_prep_dma_interrupt support to fsldma.c
      fsldma: Add a completed cookie updated action in DMA finish interrupt.

Zhang Yanmin (1):
      [NET]: Fix tbench regression in 2.6.25-rc1

Zhang, Rui (2):
      thermal: fix generic thermal I/F for hwmon
      ACPI: thermal: show temperature in millidegree Celsius

Zhao Yakui (1):
      ACPI: Ignore _BQC object when registering backlight device

arvidjaar@mail.ru (1):
      toshiba_acpi: Enable autoloading

frederic Rodo (1):
      dm9161: add configuration for MII/RMII

peerchen (1):
      ahci: add the Device IDs for nvidia MCP7B AHCI

