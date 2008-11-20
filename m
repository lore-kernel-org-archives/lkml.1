Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYKTXjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYKTXjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYKTXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:39:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYKTXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:39:35 -0500
Date: Thu, 20 Nov 2008 15:39:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc6
Message-ID: <alpine.LFD.2.00.0811201526480.3427@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been pretty quiet, and I'm hoping it will continue to be so, because 
I'm off for my yearly scuba-diving trip. And so, before I go away (no 
under-water email), here's a new -rc.

It's really CIFS and mips updates, with some updates and code movement in 
drivers/net, and simply a fair number of small fixes here and there. The 
dirstat says:

   4.8% arch/mips/rb532/
   5.3% arch/mips/
  10.9% arch/
  16.2% drivers/net/
  26.6% drivers/
  40.1% fs/cifs/
  41.8% fs/
   4.1% kernel/trace/
   6.7% kernel/
   8.0% net/

and the full diffstat has a lot of one- and two-liners spread out 
everywhere, but an excerpt from the shortlog is probably even more 
indicative of the level of exciting fixing going on:

      fbdev: clean the penguin's dirty feet

and you guys can figure out what it's all about on your own.

We have regressions fixed (the "vmalloc fails easily" is probably the one 
that more people may actually be hitting in practice), and we have a few 
more to go, but I really hope that we'll have a quiet week, and by the 
time I come back you will all have tested it extensively and sent me fixes 
for any regressions found.

Please don't disappoint me.

			Linus

---
Adrian Knoth (1):
      sched: correct sched-rt-group.txt pathname in init/Kconfig

Al Viro (1):
      Fix broken ownership of /proc/sys/ files

Alan Jenkins (1):
      atl2: don't request irq on resume if netif running

Alan Stern (2):
      USB: storage: updates unusual_devs entry for the Nokia 6300
      USB: storage: update unusual_devs entries for Nokia 5300 and 5310

Alessandro Zummo (1):
      rtc: rtc-sun4v fixes, revised

Alexey Dobriyan (4):
      net: shy netns_ok check
      ixgbe: fix compilation with gcc-3.4
      phonet: fix compilation with gcc-3.4
      net: fix tiny output corruption of /proc/net/snmp6

Alexey Klimov (2):
      HID: fix kworld fm700 radio hidquirks
      HID: fix radio-mr800 hidquirks

Andi Kleen (1):
      HID: use single threaded work queue for hid_compat

Andiry Xu (1):
      USB: fix SB700 usb subsystem hang bug

Andrea Paterniani (1):
      spi_imx: full duplex dma corruption bugfix

Andy Fleming (1):
      gianfar: Fix DMA unmap invocations

Anton Vorontsov (1):
      net/ucc_geth: Fix oops in uec_get_ethtool_stats()

Arjan van de Ven (3):
      x86: move iomap.h to the new include location
      suspend: use WARN not WARN_ON to print the message
      lib/scatterlist.c: fix kunmap() argument in sg_miter_stop()

Balazs Scheidler (2):
      TPROXY: fill struct flowi->flags in udp_sendmsg()
      TPROXY: supply a struct flowi->flags argument in inet_sk_rebuild_header()

Ben Dooks (1):
      lcd: fix oops if driver only interested in .set_power

Benjamin Thery (2):
      net: fix ip_mr_init() error path
      ipv6: use seq_release_private for ip6mr.c /proc entries

Bjorn Helgaas (1):
      igb: use dev_printk instead of printk

Brian Haley (1):
      ipv6: routing header fixes

Bruno Prémont (1):
      viafb: fix releasing of /proc/viafb/ subtree

Clemens Ladisch (1):
      fbdev: clean the penguin's dirty feet

Dave Kleikamp (1):
      prevent cifs_writepages() from skipping unwritten pages

David Brownell (1):
      USB: gadget rndis: stop windows self-immolation

David Daney (1):
      MIPS: Malta: Fix include paths in malta-amon.c

David Miller (1):
      sparc64: wire up accept4()

David S. Miller (2):
      niu: Bump driver version and release date.
      net: Do not fire linkwatch events until the device is registered.

Dmitri Vorobiev (1):
      MIPS: IP22: Make indy_sc_ops variable static

Dmitry Baryshkov (1):
      tmiofb: fix compilation with ACCEL disabled

Dominik Brodowski (2):
      pcmcia: add braces in error path
      pcmcia: ensure correct logging in do_io_probe

FUJITA Tomonori (2):
      swiotlb: use coherent_dma_mask in alloc_coherent
      intel-iommu: fix compile warnings

Felipe Balbi (1):
      usb: musb: fix bug in musb_schedule

Florian Fainelli (1):
      MIPS: RB532: GPIO register offsets are relative to GPIOBASE

Giulio Benetti (1):
      phy: fix phy address bug

Glauber Costa (1):
      mm: vmalloc search restart fix

Graf Yang (2):
      Blackfin arch: fix bug - Fail to boot jffs2 kernel for BF561 with SMP patch
      Blackfin arch: fix bug - Turn on DEBUG_DOUBLEFAULT, booting SMP kernel crash

Harvey Harrison (3):
      isdn: remove extra byteswap in isdn_net_ciscohdlck_slarp_send_reply
      net: jme.c rxdesc.flags is __le16, other missing endian swaps
      net: ipg.c fix bracing on endian swapping

Helge Deller (2):
      unitialized return value in mm/mlock.c: __mlock_vma_pages_range()
      parisc: fix bug in compat_arch_ptrace

Henrik Rydberg (4):
      HID: support for new unibody macbooks
      HID: map macbook keys for "Expose" and "Dashboard"
      hwmon: applesmc: Add support for iMac 6
      drivers/hwmon/applesmc.c: add generic MacPro support

Hidetoshi Seto (1):
      [IA64] use mprintk instead of printk, in ia64_mca_modify_original_stack

Hiroshi Shimamoto (1):
      x86: uaccess_64: fix return value in __copy_from_user()

Huang Weiyi (1):
      [IA64] remove duplicate include iommu.h

Hugh Dickins (4):
      sprint_symbol(): use less stack
      migration: fix writepage error
      vmscan: let GFP_NOFS go to swap again
      don't unlink an active swapfile

Igor Mammedov (1):
      Fixed parsing of mount options when doing DFS submount

Ilpo Järvinen (1):
      pcmcia: fix indentation & braces disagreement - add braces

Ingo Molnar (5):
      tracing: fix mmiotrace resizing crash
      lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c
      sched: fix kernel warning on /proc/sched_debug access
      MAINTAINERS: remove me as RAID maintainer
      x86, PEBS/DS: fix code flow in ds_request()

Isaku Yamahata (2):
      [IA64] ia64/pv_ops/pv_cpu_ops: fix _IA64_REG_IP case.
      [IA64] xen: fix xen_get_eflags.

J. K. Cliburn (2):
      atl1e: fix broken multicast by removing unnecessary crc inversion
      atl1: Do not enumerate options unsupported by chip

Jack Steiner (1):
      GRU: fix for debug option

James Bottomley (1):
      x86, voyager: fix smp generic helper voyager breakage

Jarkko Nikula (1):
      gpiolib: extend gpio label column width in debugfs file

Jeff Kirsher (2):
      e1000e: fix warn_on reload after phy_id error
      e1000e: fix IPMI traffic

Jeff Layton (3):
      cifs: disable sharing session and tcon and add new TCP sharing code
      cifs: reinstate sharing of SMB sessions sans races
      cifs: reinstate sharing of tree connections

Jens Axboe (1):
      block: hold extra reference to bio in blk_rq_map_user_iov()

Jeremy Fitzhardinge (1):
      xen: fix scrub_page()

Jesse Brandeburg (1):
      e100: fix dma error in direction for mapping

Jie Zhang (1):
      Blackfin arch: fix bug - shared lib function in L2 failed be called

Jiri Slaby (2):
      HID: fix start/stop cycle in usbhid driver
      HID: don't grab devices with no input

Joerg Roedel (4):
      AMD IOMMU: add parameter to disable device isolation
      AMD IOMMU: enable device isolation per default
      AMD IOMMU: fix fullflush comparison length
      AMD IOMMU: check for next_bit also in unmapped area

Joey Zhuo (1):
      via-velocity: enable perfect filtering for multicast packets

Johannes Berg (4):
      rtnetlink: propagate error from dev_change_flags in do_setlink()
      libertas_tf: fix skb tail pointer
      mac80211: remove ieee80211_notify_mac
      iwlagn: fix RX skb alignment

Julia Lawall (3):
      ALSA: sound/pci/pcxhr/pcxhr.c: introduce missing kfree and pci_disable_device
      tracing: kernel/trace/trace.c: introduce missing kfree()
      drivers/video/backlight/da903x.c: introduce missing kfree

Julien Brunel (1):
      drivers/video: bad error test before a dereference

KAMEZAWA Hiroyuki (1):
      cgroup: fix potential deadlock in pre_destroy

Kay Sievers (2):
      pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
      sparc: struct device - replace bus_id with dev_name(), dev_set_name()

Komuro (1):
      pcmcia: setup resource information for pseudo multifunction devices.

Kumar Gala (1):
      Remove -mno-spe flags as they dont belong

Lai Jiangshan (1):
      relay: fix cpu offline problem

Lennert Buytenhek (3):
      phylib: fix premature freeing of struct mii_bus
      mv643xx_eth: fix the order of mdiobus_{unregister, free}() calls
      mv643xx_eth: fix recycle check bound

Li Zefan (2):
      cpuset: fix regression when failed to generate sched domains
      cgroups: fix a serious bug in cgroupstats

Linus Torvalds (2):
      acpi: fix oops in acpi_system_wakeup_device_seq_show
      Linux 2.6.28-rc6

M Kondrin (1):
      USB: ACE1001 patch for cp2101.c

Marc Pignat (1):
      pcmcia: add another pata/ide ID

Mark Brown (1):
      mfd: Correct WM8350 I2C return code usage

Markus Metzger (1):
      x86, bts: fix unlock problem in ds.c

Matthew Ranostay (1):
      ALSA: hda: STAC_VREF_EVENT value change

Matthew Wilcox (1):
      x86: Fix interrupt leak due to migration

Miao Xie (1):
      cpuset: update top cpuset's mems after adding a node

Michael Halcrow (1):
      eCryptfs: Allocate up to two scatterlists for crypto ops on keys

Michael Hennerich (1):
      Blackfin arch: fix bug - Cpufreq assumes clocks in kHz and not Hz.

Mike Frysinger (7):
      Blackfin arch: don't copy bss when copying L1
      Blackfin arch: fix bug - dmacopy test case fail on all platform
      Blackfin arch: fix bug - kernel build with write back policy fails to be booted up
      Blackfin arch: dont warn when running a kernel on the oldest supported silicon
      Blackfin arch: fix incorrect limit check for bf54x check_gpio
      Blackfin arch: fix a broken define in dma-mapping
      Parport driver: disable pc-style parport on Blackfin systems

Mike Rapoport (2):
      mfd: fix event masking for da9030
      drivers/video/backlight/da903x.c: introduce one more missing kfree

Nadia Derbey (1):
      sysvipc: fix the ipc structures initialization

Ned Forrester (1):
      pxa2xx_spi: bugfix full duplex dma data corruption

Nick Piggin (2):
      mm: vmalloc allocator off by one
      mm: vmalloc failure flush fix

Nobuhiro Iwamatsu (1):
      sh: sh_eth: Update to change of mii_bus

Oleg Nesterov (1):
      sched, signals: fix the racy usage of ->signal in account_group_xxx/run_posix_cpu_timers

Oliver Neukum (1):
      HID: fix locking in hidraw_open()

Pantelis Koukousoulas (1):
      asix: Fix asix-based cards connecting to 10/100Mbs LAN.

Patrick McHardy (1):
      pkt_sched: fix missing check for packet overrun in qdisc_dump_stab()

Paulius Zaleckas (1):
      phylib: fix phy name example in documentation

Pavel Emelyanov (1):
      scm: fix scm_fp_list->list initialization made in wrong place

Pete Zaitcev (1):
      USB: usbmon: fix read(2)

Phil Sutter (1):
      MIPS: RB532: Provide functions for gpio configuration

Philipp Kohlbecher (1):
      x86: more general identifier for Phoenix BIOS

Rafael J. Wysocki (2):
      x86, hibernate: fix breakage on x86_32 with CONFIG_NUMA set
      x86: make NUMA on 32-bit depend on EXPERIMENTAL again

Rakib Mullick (1):
      kernel/profile.c: fix section mismatch warning

Ralf Baechle (2):
      MIPS: csrc-r4k: Fix spelling mistake.
      MIPS: csrc-r4k: Fix declaration depending on the wrong CONFIG_ symbol.

Randy Dunlap (3):
      9p: restrict RDMA usage
      Documentation/kernel-parameters.txt: add min_addr, fix max_addr
      cciss: fix DEBUG printk formats

Richard Röjfors (1):
      USB: gadget rndis: send notifications

Rik van Riel (1):
      vmscan: fix get_scan_ratio() comment

Robert Olsson (1):
      pktgen: fix multiple queue warning

Robert Reif (1):
      sparc: Fix tty compile warnings.

Robin Getz (1):
      Blackfin arch: Fix typo when adding CONFIG_DEBUG_VERBOSE

Ron Madrid (1):
      phy: Add support for Marvell 88E1118 PHY

Ron Mercer (1):
      qla3xxx: Cleanup: Fix link print statements.

Rusty Russell (1):
      stop_machine: fix race with return value (fixes Bug #11989)

Rémi Denis-Courmont (1):
      Phonet: refuse to send bigger than MTU packets

Santwona Behera (1):
      NIU: Add Sun CP3260 ATCA blade support

Sheng Yang (1):
      PCI: Fix disable IRQ 0 in pci_reset_function()

Stanley.Miao (1):
      W1 OMAP: Fix OMAP LDP boot crash

Steve Conklin (1):
      x86: quirk for reboot stalls on a Dell Optiplex 330

Steve French (9):
      [CIFS] Can't rely on iov length and base when kernel_recvmsg returns error
      [CIFS] Fix cifs reconnection flags
      [CIFS] remove unused list, add new cifs sock list to prepare for mount/umount fix
      [CIFS] clean up server protocol handling
      [CIFS] minor cleanup to cifs_mount
      [CIFS] Fix build break
      [CIFS] Fix check for tcon seal setting and fix oops on failed mount from earlier patch
      [CIFS] fix check for dead tcon in smb_init
      [CIFS] Do not attempt to close invalidated file handles

Steven Rostedt (6):
      ring-buffer: buffer record on/off switch
      ring-buffer: no preempt for sched_clock()
      ftrace: fix set_ftrace_filter
      ftrace: make filtered functions effective on setting
      ftrace: fix dyn ftrace filter selection
      MAINTAINERS: change email address for rostedt

Takashi Iwai (6):
      ALSA: hda - Add digital beep playback switch for STAC/IDT codecs
      ALSA: hda - Missing NULL check in hda_beep.c
      ALSA: hda - Check model type instead of SSID in patch_92hd71bxx()
      ALSA: hda - Fix GPIO initialization in patch_stac92hd71bxx()
      ALSA: hda - Add quirks for HP Pavilion DV models
      ALSA: hda - Fix resume of GPIO unsol event for STAC/IDT

Tejun Heo (3):
      block: fix add_partition() error path
      block: make add_partition() return pointer to hd_struct
      block/md: fix md autodetection

Tim Pepper (1):
      Blackfin arch: handle case of d_path() returning error in decode_address()

Tony Luck (1):
      [IA64] Rationalize kernel mode alignment checking

Trent Piepho (1):
      phylib: Fix auto-negotiation restart avoidance

Trond Myklebust (1):
      SUNRPC: Fix a performance regression in the RPC authentication code

Ulrich Drepper (1):
      reintroduce accept4

Vegard Nossum (1):
      trace: introduce missing mutex_unlock()

Venki Pallipadi (1):
      x86: add rdtsc barrier to TSC sync check

Vernon Sauder (1):
      smc911x: Fix printf format typo in smc911x driver.

Vlada Peric (1):
      cirrusfb: remove unused variables

WANG Cong (1):
      hostfs: fix a duplicated global function name

Yevgeny Petrilin (1):
      mlx4_en: Pause parameters per port

Yinghai Lu (1):
      x86: fix es7000 compiling

Zhang, Yanmin (1):
      block: fix boot failure with CONFIG_DEBUG_BLOCK_EXT_DEVT=y and nash

Zhaolei (1):
      Release old elevator on change elevator

\"Rafael J. Wysocki\ (3):
      e1000e: Use device_set_wakeup_enable
      e1000: Use device_set_wakeup_enable
      igb: Use device_set_wakeup_enable

walimis (1):
      function tracing: fix wrong pos computing when read buffer has been fulfilled
