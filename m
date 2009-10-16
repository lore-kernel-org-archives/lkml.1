Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbZJPBMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbZJPBMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 21:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbZJPBMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 21:12:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZJPBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 21:12:44 -0400
Date: Thu, 15 Oct 2009 18:11:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc5
Message-ID: <alpine.LFD.2.01.0910151756550.4017@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As mentioned in the -rc4 notes, this was a short week for the -rc series, 
since I'm leaving for the yearly kernel summit tomorrow morning. And 
obviously a lot of other kernel maintainers have left or will be leaving 
shortly, so I'd expect/hope that next week will be quiet too.

90% of the bulk of the changes since -rc4 are in drivers, with most of 
it coming from two new network drivers (stmmac and vmxnet3). But apart 
from the new drivers, there's almost 300 commits in there, and most of 
them are pretty spread our random one- (or few-) liners: arch updates 
(arm, powerpc, x86), some filesystem updates (mainly btrfs), and some 
documentation, networking etc.

[ Git tip of the day: if somebody wants to really see the size of patches, 
  do something like

	git log --no-merges --oneline --numstat -M v2.6.32-rc4..v2.6.32-rc5

  and you'll get a reasonable view of the patches with number of lines 
  added and removed. You'll see how the commits that add the new drivers 
  really stand out, while the other commits really are largely "just a few 
  lines" each. ]

A few regressions fixed, and hopefully no new ones added ("Oh, yeah, like 
that ever happens").

Go wild,

			Linus

---
Aaro Koskinen (1):
      omap: RX-51: Drop I2C-1 speed to 2200

Alan Cox (5):
      libertas: fix build
      libertas: fix build
      ethoc: fix warning from 32bit build
      Staging: et131x: Correct WRAP bit handling
      Staging: et131x: Fix the add_10bit macro

Albert Herranz (1):
      b43: do not stack-allocate pio rx/tx header and tail buffers

Alek Du (1):
      kbuild: Fix size_append issue for bzip2/lzma kernel

Alok Kataria (1):
      x86, vmi: Mark VMI deprecated and schedule it for removal

Amerigo Wang (1):
      kbuild,scripts: use non-builtin echo for '-e'

Andreas Krebbel (1):
      [S390] Add highgprs facility to /proc/cpuinfo

Andreas Schwab (1):
      tty: fix vt_compat_ioctl

Anton Blanchard (1):
      powerpc: Fix hypervisor TLB batching

Anton Vorontsov (2):
      powerpc/kgdb: Fix build failure caused by "kgdb.c: unused variable 'acc'"
      net: Fix OF platform drivers coldplug/hotplug when compiled as modules

Antonio Ospite (1):
      [ARM] pxamci: fix printing gpio numbers in pxamci_probe

Anuj Aggarwal (1):
      omap: SDMA: Fixing bug in omap_dma_set_global_params()

Arnd Bergmann (1):
      warn about use of uninstalled kernel headers

Ashwin Chaugule (1):
      perf tools: Remove static debugfs path from parse-events

Ben Hutchings (1):
      acenic: Pass up error code from ace_load_firmware()

Benjamin Herrenschmidt (3):
      powerpc/pmac: Fix issues with sleep on some powerbooks
      powerpc/mm: Fix hang accessing top of vmalloc space
      usb-storage: Workaround devices with bogus sense size

Bjorn Helgaas (3):
      PCI: PCIe portdrv: remove "-driver" from driver name
      PCI: remove pci_assign_resource_fixed()
      iwlwifi: use %pM for formatted MAC addresses

Brian Niebuhr (1):
      USB: gadget: Fix EEM driver comments and VID/PID

Catalin Marinas (2):
      ARM: 5746/1: Handle possible translation errors in ARMv6/v7 coherent_user_range
      ARM: 5747/1: Fix the start_pg value in free_memmap()

Chris Mason (5):
      Btrfs: only write one super copy during fsync
      Btrfs: avoid tree log commit when there are no changes
      Btrfs: streamline tree-log btree block writeout
      Btrfs: fix btrfs acl #ifdef checks
      Btrfs: always pin metadata in discard mode

Chris Rankin (1):
      net: Teach pegasus driver to ignore bluetoother adapters with clashing Vendor:Product IDs

Christoph Hellwig (2):
      Btrfs: add -o discard option
      Btrfs: enable discard support

Cornelia Huck (1):
      sysfs: Allow sysfs_move_dir(..., NULL) again.

Corrado Zoccolo (3):
      cfq-iosched: fix possible problem with jiffies wraparound
      cfq-iosched: fix think time allowed for seekers
      cfq-iosched: avoid probable slice overrun when idling

Darren Salt (2):
      eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated
      Staging: rt2860sta: prevent a panic when disabling when associated

Dave Mitchell (1):
      ibm_newemac: Added 16K Tx FIFO size support for EMAC4

David Henningsson (1):
      ALSA: ice1724 - Make call to set hw params succeed on ESI Juli@

David Howells (1):
      KEYS: get_instantiation_keyring() should inc the keyring refcount in all cases

David Rientjes (1):
      oprofile: fix race condition in event_buffer free

David S. Miller (5):
      znet: Don't claim DMA lock around free_dma() calls.
      sparc64: Fix niagara2 perf IRQ bits.
      net: Link in PHY drivers before others.
      sparc64: Fix D-cache flushing on swapin from SW devices.
      sparc64: Set IRQF_DISABLED on LDC channel IRQs.

David Teigland (2):
      dlm: fix lowcomms_connect_node for sctp
      dlm: fix socket fd translation

David Vrabel (3):
      USB: rename Documentation/ABI/.../sysfs-class-usb_host
      USB: whci-hcd: handle early deletion of endpoints
      USB: whci-hcd: always do an update after processing a halted qTD

David Woodhouse (5):
      intel-iommu: Yet another BIOS workaround: Isoch DMAR unit with no TLB space
      Rename pci_init() to pci_apply_final_quirks(), move it to quirks.c
      Mark pci_apply_final_quirks() __init rather than __devinit
      Run pci_apply_final_quirks() sooner.
      x86: Move pci_iommu_init to rootfs_initcall()

Dennis O'Brien (1):
      [ARM] pxa: workaround errata #37 by not using half turbo switching

Dhananjay Phadke (1):
      netxen: fix pci bar mapping

Dmitry Artamonow (2):
      ARM: 5752/1: SA1100: fix building of h3100
      irda/sa1100_ir: check return value of startup hook

Dragos Tatulea (1):
      powerpc/oprofile: Add ppc750 CL as supported by oprofile

Eric Dumazet (3):
      net: Add patchwork URL to MAINTAINERS
      net: Fix struct sock bitfield annotation
      udp: Fix udp_poll() and ioctl()

Felipe Contreras (2):
      kbuild: fix warning when domainname is not available
      kbuild: mkcompile_h: trivial cleanups

Felix Fietkau (1):
      mac80211: fix logic error ibss merge bssid check

Frans Pop (1):
      kbuild: fix the binrpm-pkg target to work with KBUILD_OUTPUT set

Gabe Black (1):
      PCI quirk: TI XIO200a erroneously reports support for fast b2b transfers

Giuseppe Cavallaro (1):
      net: add support for STMicroelectronics Ethernet controllers.

Greg Kroah-Hartman (4):
      Staging: comedi: fix sched.h build breakage
      Staging: b3dfg: fix sched.h build breakage
      Staging: poch: fix sched.h build breakage
      Staging: vme: fix sched.h build breakage

H. Peter Anvin (1):
      x86: fix kernel panic on 32 bits when profiling

Hartley Sweeten (6):
      ARM: 5744/1: ep93xx: add remaining phys offset selections
      ARM: 5745/1: Change ep93xx gpio_irq static inlines to macros
      ARM: 5729/1: ep93xx: define EP93XX_*_PHYS_BASE with macros
      ARM: 5753/1: ep93xx: remove old EP93XX_GPIO_* defines
      ARM: 5754/1: ep93xx: update i2c support
      ARM: 5756/1: ep93xx: introduce clk parent

Heiko Carstens (1):
      [S390] call home support: fix proc handler

Heiko Schocher (1):
      powerpc/pci: Fix MODPOST warning

Hubert Feurstein (3):
      ARM: 5749/1: ep93xx/micro9: Update maintainer
      ARM: 5750/1: ep93xx/micro9: Update platform code
      ARM: 5751/1: ep93xx/micro9: Add Micro9-Slim

Huzaifa Sidhpurwala (1):
      USB: option: Support for AIRPLUS MCD650 Datacard

Imre Deak (1):
      ARM: 5742/1: ARM: add debug check for invalid kernel page faults

Ingo Molnar (4):
      Revert "x86, timers: Check for pending timers after (device) interrupts"
      perf tools: Fix the NO_64BIT build on pure 64-bit systems
      headers: Fix build after <linux/sched.h> removal
      Revert "x86: linker script syntax nits"

Jan Beulich (1):
      x86: Fix Suspend to RAM freeze on Acer Aspire 1511Lmi laptop

Jan Kara (1):
      ext3: Update documentation about ext3 quota mount options

Jarkko Nikula (1):
      omap: McBSP: Fix incorrect receiver stop in omap_mcbsp_stop

Jay Sternberg (1):
      iwlwifi: incorrect method used for finding valid OTP blocks

Jeff Mahoney (2):
      staging: Complete sched.h removal from interrupt.h
      staging: more sched.h fixes

Jens Axboe (6):
      cfq-iosched: fix issue with rq-rq merging and fifo list ordering
      block: get rid of kblock_schedule_delayed_work()
      block: use proper BLK_RW_ASYNC in blk_queue_start_tag()
      cfq-iosched: abstract out the 'may this cfqq dispatch' logic
      cfq-iosched: fix the slice residual sign
      cfq-iosched: apply bool value where we return 0/1

Jeremy Fitzhardinge (1):
      x86/paravirt: Use normal calling sequences for irq enable/disable

Jesse Barnes (1):
      ACPI button: don't try to use a non-existent lid device

Jiri Kosina (2):
      HID: fix kerneldoc comment for hid_input_report()
      HID: fix possible deadlock in hidraw_read

Jiri Pirko (1):
      netlink: fix typo in initialization

Jiri Slaby (1):
      ACPI: Kconfig, fix proc aggregator text

Johannes Berg (5):
      mac80211: fix vlan and optimise RX
      cfg80211: fix netns error unwinding bug
      mac80211: fix ibss race
      b43: fix ieee80211_rx() context
      mac80211: document ieee80211_rx() context requirement

Johannes Weiner (1):
      ARM: boolean bit testing

John Bonesio (1):
      net/fec_mpc52xx: Fix kernel panic on FEC error

Jonathan Cameron (1):
      Staging: iio: Fix missing include <linux/sched.h>

Jonathan Corbet (1):
      Update flex_arrays.txt

Jonathan Woithe (1):
      fujitsu-laptop: address missed led-class ifdef fixup

Josef Bacik (1):
      Btrfs: fix possible ENOSPC problems with truncate

Julia Lawall (1):
      [ARM] pxa/csb726: adjust duplicate structure field initialization

Justin P. Mattock (1):
      ieee1394: update URLs in debugging-via-ohci1394.txt

KOSAKI Motohiro (1):
      elv_iosched_store(): fix strstrip() misuse

Kalle Jokiniemi (1):
      OMAP: Fix race condition with autodeps

Ken Kawasaki (1):
      3c574_cs: spin_lock the set_multicast_list function

Kenji Kaneshige (1):
      PCI: Prevent AER driver from being loaded on non-root port PCIE devices

Krzysztof Halasa (1):
      WAN: fix Cisco HDLC handshaking.

Larry Finger (1):
      b43: Fix PPC crash in rfkill polling on unload

Leo Chen (1):
      ARM: 5748/1: bcmring: fix build warning messages

Li Hong (1):
      x86, perf_event: Rename 'performance counter interrupt'

Li Zefan (1):
      tracing/filters: Fix memory leak when setting a filter

Linus Torvalds (6):
      Revert "USB: Work around BIOS bugs by quiescing USB controllers earlier"
      tty, serial: Fix race and NULL check in uart_close()
      workqueue: add 'flush_delayed_work()' to run and wait for delayed work
      tty: use the new 'flush_delayed_work()' helper to do ldisc flush
      tty: Make flush_to_ldisc() locking more robust
      Linux 2.6.32-rc5

Mark Langsdorf (1):
      ACPI: add AC/DC notifier

Michael Buesch (2):
      b43: Don't use struct wldev after detach.
      b43: Protect sanity check against physical device removal

Michael Ellerman (1):
      powerpc: Fix memory leak in axon_msi.c

Michael Holzheu (3):
      [S390] hypfs: Use subcode 6 if subcode 7 is not available
      [S390] tape390: Fix request queue handling in block driver
      [S390] sclp_vt220 build fix

Mike Frysinger (1):
      USB: musb: invert arch depend string

Mike Galbraith (1):
      sched: Update the clock of runqueue select_task_rq() selected

Neil Brown (1):
      sysfs: Allow sysfs_notify_dirent to be called from interrupt context.

Nikanth Karthikesan (1):
      block: Seperate read and write statistics of in_flight requests v2

Nitin Gupta (1):
      ARM: force dcache flush if dcache_dirty bit set

Paul Mundt (8):
      sh: update die() output.
      sh: force dcache flush if dcache_dirty bit set.
      sh: ftrace: Fix up syscall tracepoint support.
      sh: Use boot_cpu_data for FPU tests in sigcontext paths.
      sh: Tidy up SMP cpuinfo.
      sh: Populate initial secondary CPU info from boot_cpu_data.
      sh: Optimize the setup_rt_frame() I-cache flush.
      sh: Fix a TRACE_IRQS_OFF typo.

Paul Walmsley (1):
      OMAP2xxx clock: set up clockdomain pointer in struct clk

Peter Huewe (1):
      HID: add __init/__exit macros to twinhan.c

Peter Oberparleiter (1):
      [S390] cio: change misleading console logic

Peter Zijlstra (1):
      lockdep: Use cpu_clock() for lockstat

Philby John (1):
      ALSA: aaci: ARM1176 aaci-pl041 AC97 register read timeout

Rafael J. Wysocki (2):
      PCI PM: Read device power state from register after updating it
      ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev() (rev. 2)

Rakib Mullick (1):
      eeepc-laptop: Properly annote eeepc_enable_camera().

Randy Dunlap (6):
      PCI: pci.c: fix kernel-doc notation
      blk-settings: fix function parameter kernel-doc notation
      perf tools: Fix const char type propagation
      sched: Fix missing kernel-doc notation
      net: ks8851_mll uses mii interfaces
      vmxnet: fix 2 build problems

Reinette Chatre (2):
      iwlwifi: fix compile warning
      iwlagn: fix compile warning in iwl5000_gain_computation

Robert Hancock (1):
      ALSA: ice1724: Fix surround on Chaintech AV-710

Robert Richter (1):
      oprofile: warn on freeing event buffer too early

Roel Kluin (2):
      mac80211: fix ADM8211_SYNCTL_RFtype define
      mac80211: use kfree_skb() to free struct sk_buff pointers

Roger Quadros (1):
      mfd: Fix twl4030 boot with twl4030 usb transceiver enabled

Roland Dreier (2):
      intel-iommu: Make "Unknown DMAR structure" message more informative
      intel-iommu: Decode (and ignore) RHSA entries

Roland McGrath (1):
      x86: linker script syntax nits

Ron Mercer (7):
      qlge: Fix RSS hashing values.
      qlge: Fix frame routing issue related to bonding.
      qlge: Fix frame routing for multicast frames.
      qlge: Fix RX multicast filter settings.
      qlge: Fix chip reset process.
      qlge: Restore rx mode after internal reset.
      qlge: Add disable/enable firmare irqs to handler.

Russell King (4):
      ARM: Dump memory and backtrace as one printk per line
      ARM: Dump code/mem oops lines with the appropriate log level
      ARM: update die() output
      ARM: Add kmap_atomic type debugging

Sam Ravnborg (1):
      kbuild: revert "save ARCH & CROSS_COMPILE ..."

Sanjeev Premi (1):
      omap: CONFIG_ISP1301_OMAP redefined in Beagle defconfig

Sarah Sharp (1):
      USB: ehci: Fix IST boundary checking interval math.

Sean MacLennan (1):
      powerpc: warning: allocated section `.data_nosave' not in segment

Shreyas Bhatewara (1):
      net: VMware virtual Ethernet NIC driver: vmxnet3

Srinidhi Kasagar (1):
      ARM: 5741/1: pl022: fix peripheral id for ST vendor

Sriram (1):
      TI DaVinci EMAC: Clear statistics register properly.

Stefan Bader (1):
      ACPI: video: Loosen strictness of video bus detection code

Stefan Haberland (2):
      [S390] dasd: fix locking bug
      [S390] dasd: use idal for device characteristics

Stefan Richter (3):
      ieee1394: add documentation entry to MAINTAINERS
      NFS: suppress a build warning
      firewire: sbp2: provide fallback if mgt_ORB_timeout is missing

Stefano Panella (1):
      USB: wusb: don't use the stack to read security descriptor

Stephen M. Cameron (2):
      cciss: Fix multiple calls to pci_release_regions
      cciss: Add cciss_allow_hpsa module parameter

Steven Rostedt (3):
      tracing: fix trace_vprintk call
      powerpc/ftrace: show real return addresses in modules
      powerpc64/ftrace: use PACA to retrieve TOC in mod_return_to_handler

Takashi Iwai (6):
      ALSA: hda - Add full rates/formats support for Nvidia HDMI
      ALSA: hda - Fix overflow of spec->init_verbs in patch_realtek.c
      ALSA: bt87x - Add a whitelist for Pinnacle PCTV (11bd:0012)
      ALSA: hda - Fix mute sound with STAC9227/9228 codecs
      ALSA: hda - Fix volume-knob setup for Dell laptops with STAC9228
      ALSA: hda - Allow all formats as default for Nvidia HDMI

Teerth Reddy (1):
      omap: Initialization of SDRC params on Zoom2

Tejun Heo (1):
      percpu: fix compile warnings

Theodore Ts'o (1):
      ext3: Don't update superblock write time when filesystem is read-only

Thomas Gleixner (1):
      watchdog: Fix rio watchdog probe function

Vincent Legoll (1):
      perf events: Update MAINTAINERS entry file patterns

Vincent Sanders (1):
      net: Fix IXP 2000 network driver building.

Wey-Yi Guy (2):
      iwlwifi: fix EEPROM enhance tx power offset
      iwlwifi: change the order of freeing memory

Willy Tarreau (1):
      tcp: fix tcp_defer_accept to consider the timeout

Wolfram Sang (1):
      include/linux/netdevice.h: fix nanodoc mismatch

Wu Fengguang (2):
      writeback: account IO throttling wait as iowait
      writeback: kill space in debugfs item name

Yan, Zheng (1):
      Btrfs: properly wait log writers during log sync

Yinghai Lu (1):
      PCI: get larger bridge ranges when space is available

françois romieu (1):
      r8169: partial support and phy init for the 8168d

jamal (1):
      pkt_sched: pedit use proper struct

