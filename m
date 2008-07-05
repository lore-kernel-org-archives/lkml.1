Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYGEXQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYGEXQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYGEXPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:15:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbYGEXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:15:43 -0400
Date: Sat, 5 Jul 2008 16:15:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc9
Message-ID: <alpine.LFD.1.10.0807051557500.3016@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, the last -rc obviously wasn't the last one after all, since here's a 
new one. Enough changes that we needed another -rc, and the regression 
list isn't emptying fast enough either (probably because a number of 
people, including reporters, are vacationing).

But this should in fact close a number of entries, so it's not all doom 
and gloom.

The actual bulk of this all is a new UVC video driver for the standard USB 
Video Class specification. It's a new driver, so shouldn't cause any 
regressions, but it's fairly sizable, which explains the dirstat:

   1.3% drivers/media/video/cx18/
   1.4% drivers/media/video/saa7134/
  78.0% drivers/media/video/uvc/
  83.4% drivers/media/video/
  84.4% drivers/media/
   1.4% drivers/net/wireless/
   2.3% drivers/net/
  91.9% drivers/
   2.6% fs/
   1.7% net/

ie 78% is just that one new driver, and almost 92% is driver updates in 
general (although some of them are reverts, so they show up as diffs 
against -rc8, but they actually cause the _total_ diff against 2.6.25 to 
shrink a bit).

The fs updates are partly some minor updates to 9p, ecryptfs, proc and 
udf, but partly some delayed cleanup patches that went through Al. Bad Al. 
But when Al sends me patches, I apply them. I worry what would happen if I 
didn't.

The rest is mainly small fixes (one-liners and "few-liners") all over the 
place, many of them merged from Andrew's -mm queue.

			Linus

---
Adrian Bunk (2):
      pkt_sched: Remove CONFIG_NET_SCH_RR
      include/linux/netdevice.h: don't export MAX_HEADER to userspace

Akinobu Mita (1):
      add kernel-doc for simple_read_from_buffer and memory_read_from_buffer

Al Viro (2):
      fix cgroup-inflicted breakage in block_dev.c
      [netdrvr] netxen: fix netxen_pci_tbl[] breakage

Alan Cox (1):
      tty: Fix inverted logic in send_break

Alan Stern (1):
      USB: don't lose disconnections during suspend

Alex Chiang (1):
      PCI: acpiphp: cleanup notify handler on all root bridges

Andi Kleen (1):
      [netdrvr] Fix IOMMU overflow checking in s2io.c

Andre Haupt (1):
      hamradio: remove unused variable

Andreas Gruenbacher (1):
      vfs: make d_path() consistent across mount operations

Andres Salomon (2):
      olpc: sdhci: add quirk for the Marvell CaFe's vdd/powerup issue
      olpc: sdhci: add quirk for the Marvell CaFe's interrupt timeout

Andrew G. Morgan (2):
      security: filesystem capabilities: fix fragile setuid fixup code
      security: filesystem capabilities: fix CAP_SETPCAP handling

Andrew Morton (3):
      arch/x86/mm/init_64.c: early_memtest(): fix types
      Fix clear_refs_write() use of struct mm_walk
      Fix pagemap_read() use of struct mm_walk

Andy Gospodarek (1):
      e1000: only enable TSO6 via ethtool when using correct hardware

Andy Walls (5):
      V4L/DVB (8063): cx18: Fix unintended auto configurations in cx18-av-core
      V4L/DVB (8066): cx18: Fix audio mux input definitions for HVR-1600 Line In 2 and FM radio
      V4L/DVB (8067): cx18: Fix firmware load for case when digital capture happens first
      V4L/DVB (8068): cx18: Add I2C slave reset via GPIO upon initialization
      V4L/DVB (8069): cx18: Fix S-Video and Compsite inputs for the Yuan MPC718 and enable card entry

Anton Vorontsov (1):
      fsl_diu_fb: fix build with CONFIG_PM=y, plus fix some warnings

Antti Palosaari (3):
      V4L/DVB (8012): gl861: sleep a little to avoid I2C errors
      V4L/DVB (8013): gl861: remove useless identify_state
      V4L/DVB (8015): gl861: replace non critical msleep(0) with msleep(1) to be on the safe side

Arjan van de Ven (2):
      V4L/DVB (8108): Fix open/close race in saa7134
      softlockup: print a module list on being stuck

Atsushi Nemoto (3):
      tc35815: Mark carrier-off before starting PHY
      tc35815: Fix receiver hangup on Rx FIFO overflow
      [MIPS] cevt-txx9: Reset timer counter on initialization

Austin Lund (1):
      V4L/DVB (8042): DVB-USB UMT-010 channel scan oops

Balbir Singh (1):
      delay accounting: maintainer update

Bartlomiej Zolnierkiewicz (5):
      Revert "BAST: Remove old IDE driver"
      ide: fix /proc/ide/ide?/mate reporting
      ide: fix hwif->gendev refcounting
      ide: ide_unregister() warm-plug bugfix
      ide: ide_unregister() locking bugfix

Bastian Blank (1):
      Alpha Linux kernel fails with inconsistent kallsyms data

Bastien Nocera (1):
      Input: add KEY_MEDIA_REPEAT definition

Ben Dooks (5):
      I2C: S3C2410: Check ACK on byte transmission
      I2C: S3C2410: Fixup error codes returned rom a transfer.
      I2C: S3C2410: Add MODULE_ALIAS() for s3c2440 device.
      i2c: Documentation: fix device matching description
      OHCI: Fix problem if SM501 and another platform driver is selected

Ben Hutchings (3):
      qla3xxx: Hold RTNL while calling dev_close()
      Hold RTNL while calling dev_close()
      PCI: Restrict VPD read permission to root

Benjamin Li (1):
      PCI: Limit VPD read/write lengths for Broadcom 5706, 5708, 5709 rev.

Bryan Wu (1):
      Blackfin arch: fix up section mismatch warning

Catalin Marinas (1):
      [ARM] 5131/1: Annotate platform_secondary_init with trace_hardirqs_off

Christoph Lameter (2):
      slub: Do not use 192 byte sized cache if minimum alignment is 128 byte
      Christoph has moved

Daniel J Blueman (1):
      x86: section/warning fixes

David Brownell (4):
      USB: ehci - fix timer regression
      USB: ohci - record data toggle after unlink
      rtc: rtc_read_alarm() handles wraparound
      gpio: pca953x (i2c) handles max7310 too

David Howells (2):
      mn10300: export certain arch symbols required to build allmodconfig
      mn10300: provide __ucmpdi2() for MN10300

David Rientjes (1):
      mempolicy: mask off internal flags for userspace API

David S. Miller (1):
      [SCSI] esp: Fix OOPS in esp_reset_cleanup().

David Woodhouse (1):
      kbuild: fix a.out.h export to userspace with O= build.

Denis V. Lunev (1):
      [patch 4/4] flock: remove unused fields from file_lock_operations

Devin Heitmueller (4):
      V4L/DVB (8010): em28xx: Properly register extensions for already attached devices
      V4L/DVB (8011): em28xx: enable DVB for HVR-900
      V4L/DVB (8017): Ensure em28xx extensions only get run against devs that support them
      V4L/DVB (8018): Add em2860 chip ID

Divyesh Shah (1):
      block: Fix the starving writes bug in the anticipatory IO scheduler

Dmitri Belimov (1):
      V4L/DVB (8020): Fix callbacks functions of saa7134_empress

Dmitry Adamushko (1):
      sched: fix cpu hotplug

Dmitry Torokhov (1):
      Input: fix locking in force-feedback core

Doug Chapman (1):
      [IA64] export account_system_vtime

Eduard - Gabriel Munteanu (2):
      Fix and clean top .gitignore
      Move _RET_IP_ and _THIS_IP_ to include/linux/kernel.h

Eli Cohen (1):
      net/inet_lro: remove setting skb->ip_summed when not LRO-able

Emmanuel Grumbach (2):
      mac80211: fix an oops in several failure paths in key allocation
      mac80211: don't accept WEP keys other than WEP40 and WEP104

Eric Van Hensbergen (1):
      9p: fix O_APPEND in legacy mode

Gautham R Shenoy (1):
      rcu: fix hotplug vs rcu race

Geert Uytterhoeven (2):
      drivers/input/ff-core.c needs <linux/sched.h>
      MAINTAINERS: update the email address of Andreas Dilger

Greg Kroah-Hartman (2):
      USB: another option device id
      USB: add a pl2303 device id

Guennadi Liakhovetski (3):
      V4L/DVB (8039): pxa-camera: fix platform_get_irq() error handling.
      V4L/DVB (8040): soc-camera: remove soc_camera_host_class class
      serial: fix serial_match_port() for dynamic major tty-device numbers

H. Peter Anvin (1):
      x86 ACPI: normalize segment descriptor register on resume

Hans Verkuil (3):
      V4L/DVB (8007): cx18/cx25840: the S-Video LUMA input can use all In1-In8 inputs
      V4L/DVB (8008): cx18: remove duplicate audio and video input enums
      V4L/DVB (8092): videodev: simplify and fix standard enumeration

Harvey Harrison (1):
      prism: islpci_eth.c endianness fix

Hiroshi Shimamoto (1):
      Update taskstats-struct document for scaled time accounting

Huacai Chen (1):
      rtc: fix CMOS time error after writing /proc/acpi/alarm

Hugh Dickins (1):
      x86: fix Intel Mac booting with EFI

Ingo Molnar (1):
      [netdrvr] 3c59x: remove irqs_disabled warning from local_bh_enable

Ivo van Doorn (2):
      rt2x00: Fix unbalanced mutex locking
      rt2x00: Fix lock dependency errror

J. Bruce Fields (1):
      svcrpc: fix handling of garbage args

James Bottomley (2):
      [SCSI] esp: tidy up target reference counting
      firmware: fix the request_firmware() dummy

Jan Blunck (1):
      [patch 1/4] vfs: path_{get,put}() cleanups

Jan Engelhardt (1):
      [patch 2/4] fs: make struct file arg to d_path const

Jan Kara (3):
      ext3: add missing unlock to error path in ext3_quota_write()
      ext4: add missing unlock to an error path in ext4_quota_write()
      reiserfs: add missing unlock to an error path in reiserfs_quota_write()

Jarkko Nikula (1):
      ARM: OMAP: DMA: Don't mark channel active in omap_enable_channel_irq

Jaya Kumar (3):
      [ARM] 5115/1: pxafb: fix ifdef for command line option handling
      [ARM] 5116/1: pxafb: cleanup and fix order of failure handling
      [ARM] 5117/1: pxafb: fix __devinit/exit annotations

Jeff Kirsher (2):
      igb: fix EEH recovery during reset on PPC
      e1000e: fix EEH recovery during reset on PPC

Jens Axboe (1):
      Properly notify block layer of sync writes

Jeremy Fitzhardinge (1):
      xen: fix address truncation in pte mfn<->pfn conversion

Jess Guerrero (1):
      ntfs: update help text

Jesse Barnes (1):
      DRM/i915: only use tiled blits on 965+

John Blackwood (1):
      mm: switch node meminfo Active & Inactive pages to Kbytes

John Linn (2):
      powerpc/bootwrapper: update for initrd with simpleImage
      powerpc/legacy_serial: Bail if reg-offset/shift properties are present

Jon K Hellan (1):
      USB: New device ID for ftdi_sio driver

Joonwoo Park (1):
      textsearch: fix Boyer-Moore text search bug

Jozsef Kadlecsik (1):
      netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid ACK

Julia Lawall (1):
      drivers/net/r6040.c: Eliminate double sizeof

Julius Volz (1):
      netlink: Fix some doc comments in net/netlink/attr.c

Kevin Hao (1):
      e100: Do pci_dma_sync after skb_alloc for proper operation on ixp4xx

Komuro (1):
      pcnet_cs, axnet_cs: clear bogus interrupt before request_irq

Laurent Pinchart (1):
      V4L/DVB (8145a): USB Video Class driver

Len Brown (1):
      dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.

Li Zefan (3):
      CONNECTOR: add a proc entry to list connectors
      cgroups: document the effect of attaching PID 0 to a cgroup
      devcgroup: fix odd behaviour when writing 'a' to devices.allow

Marcin Slusarz (3):
      vfs: fix ERR_PTR abuse in generic_readlink
      V4L/DVB (8022): saa7134: fix race between opening and closing the device
      V4L/DVB (8100): V4L/vivi: fix possible memory leak in vivi_fillbuff

Mark Lord (1):
      sata_mv: safer logic for limit_warnings

Matthew Wilcox (1):
      [SCSI] ses: Fix timeout

Matthias Schwarzott (1):
      V4L/DVB (8027): saa7134: Avermedia A700: only s-video and composite input are working

Matthieu CASTET (1):
      USB: mass storage: new id for US_SC_CYP_ATACB

Mauro Carvalho Chehab (6):
      V4L/DVB (8004): Fix INPUT dependency at budget-ci
      V4L/DVB (8005): Fix OOPS if frontend is null
      V4L/DVB (8026): Avoids an OOPS if dev struct can't be successfully recovered
      V4L/DVB (8028): Improve error messages for tda1004x attach
      V4L/DVB (8029): Improve error message at tda1004x_attach
      V4L/DVB (8178): uvc: Fix compilation breakage for the other drivers, if uvc is selected

Max Asbock (1):
      x86: shift bits the right way in native_read_tscp

Mel Gorman (1):
      Do not overwrite nr_zones on !NUMA when initialising zlcache_ptr

Michael Buesch (4):
      b43: Do not return TX_BUSY from op_tx
      b43legacy: Do not return TX_BUSY from op_tx
      b43: Fix possible MMIO access while device is down
      b43legacy: Fix possible NULL pointer dereference in DMA code

Michael Halcrow (1):
      ecryptfs: remove unnecessary mux from ecryptfs_init_ecryptfs_miscdev()

Michael Hamel (1):
      rtc-x1205: Fix alarm set

Michael Kerrisk (5):
      vfs: utimensat(): be consistent with utime() for immutable and append-only files
      vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT or UTIME_NOW
      vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT} case
      vfs: utimensat(): fix write access check for futimens()
      man-pages is supported

Michael Krufky (7):
      V4L/DVB (8034): tda18271: fix IF notch frequency handling
      V4L/DVB (8035): tda18271: dont touch EB14 if rf_cal lookup is out of range
      V4L/DVB (8036): tda18271: toggle rf agc speed mode on TDA18271HD/C2 only
      V4L/DVB (8037): tda18271: ensure that the thermometer is off during channel configuration
      V4L/DVB (8043): au0828: add support for additional USB device id's
      V4L/DVB (8044): au8522: tuning optimizations
      V4L/DVB (8061): cx18: only select tuner / frontend modules if !DVB_FE_CUSTOMISE

Michal Schmidt (1):
      s2io: fix documentation about intr_type

Miguel Ojeda (1):
      Miguel Ojeda has moved

Mike Miller (1):
      cciss: read config to obtain max outstanding commands per controller

Miklos Szeredi (2):
      vfs: dcache sparse fixes
      vfs: dcache cleanups

Milan Broz (1):
      dm crypt: use cond_resched

Miquel van Smoorenburg (1):
      tcp: calculate tcp_mem based on low memory instead of all memory

Neil Brown (3):
      Ensure interrupted recovery completed properly (v1 metadata plus bitmap)
      Don't acknowlege that stripe-expand is complete until it really is.
      Fix error paths if md_probe fails.

Octavian Purdila (1):
      tcp: fix for splice receive when used with software LRO

Oleg Nesterov (1):
      get_user_pages(): fix possible page leak on oom

Oliver Endriss (4):
      V4L/DVB (8071): tda10023: Fix possible kernel oops during initialisation
      V4L/DVB (8073): av7110: Catch another type of ARM crash
      V4L/DVB (8074): av7110: OSD transfers should not be interrupted
      V4L/DVB (8075): stv0299: Uncorrected block count and bit error rate fixed

Oliver Neukum (3):
      USB: fix cdc-acm resume()
      USB: fix Oops on loading ipaq module since 2.6.26
      USB: adding comment for ipaq forcing number of ports

Patrick McHardy (4):
      netfilter: ip6table_mangle: don't reroute in LOCAL_IN
      net-sched: change tcf_destroy_chain() to clear start of filter list
      net-sched: fix filter destruction in atm/hfsc qdisc destruction
      net: fib_rules: fix error code for unsupported families

Paul Jackson (2):
      cpusets: document proc status cpus and mems allowed lists
      doc: document the relax_domain_level kernel boot argument

Paul Larson (1):
      ixgbe: fix EEH recovery during reset on PPC

Paul Mackerras (1):
      Update maintainers for powerpc

Paul Moore (1):
      netlabel: Fix a problem when dumping the default IPv6 static labels

Paul Mundt (1):
      lib: taint kernel in common report_bug() WARN path.

Pavel Emelyanov (1):
      inet fragments: fix race between inet_frag_find and inet_frag_secret_rebuild

Pavel Machek (1):
      Doc*/kernel-parameters.txt: fix stale references

Pavel Roskin (2):
      hostap: don't report useless WDS frames by default
      hostap: fix sparse warnings

Pekka Enberg (2):
      ipg: fix jumbo frame compilation
      ipg: use NULL, not zero, for pointers

Peng Haitao (2):
      kernel/audit.c: nlh->nlmsg_type is gotten more than once
      remove useless argument type in audit_filter_user()

Peter Zijlstra (1):
      mm: dirty page accounting vs VM_MIXEDMAP

Philipp Zabel (2):
      w100fb: do not depend on SHARPSL
      w100fb: add 80 MHz modeline

Pierre Ossman (1):
      mmc: don't use DMA on newer ENE controllers

Rafael J. Wysocki (1):
      x86 ACPI: fix resume from suspend to RAM on uniprocessor x86-64

Rainer Weikusat (1):
      af_unix: fix 'poll for write'/connected DGRAM sockets

Raistlin (1):
      sched: fix divide error when trying to configure rt_period to zero

Rajiv Andrade (1):
      Update MAINTAINERS file for the TPM device driver

Ralf Baechle (1):
      [MIPS] Fix bug in atomic_sub_if_positive.

Randy Dunlap (2):
      audit: fix kernel-doc parameter notation
      doc: doc maintainers

Rene Herman (1):
      thermal: Create CONFIG_THERMAL_HWMON=n

Richard Sharpe (1):
      firewire: fw-sbp2: fix parsing of logical unit directories

Ron Rindjunsky (1):
      iwlwifi: improve scanning band selection management

Russell King (1):
      [ARM] Export dma_sync_sg_for_device()

Samuel Ortiz (1):
      MFD maintainer

Sebastian Siewior (1):
      spi: fix the read path in spidev

Sonic Zhang (1):
      Blackfin arch: fix bug - kernel boot fails when Spinlock and rw-lock debugging enabled

Stefan Becker (1):
      USB: fix interrupt disabling for HCDs with shared interrupt handlers

Stephen Hemminger (2):
      tcp: /proc/net/tcp rto,ato values not scaled properly (v2)
      ipv4: fix sysctl documentation of time related values

Stephen M. Cameron (1):
      cciss: fix regression that no device nodes are created if no logical drives are configured.

Stephen Rothwell (2):
      Introduce rculist.h
      cpumask: introduce new APIs

Steven Rostedt (1):
      hrtimer: prevent migration for raising softirq

Steven Toth (2):
      V4L/DVB (8096): au8522: prevent false-positive lock status
      V4L/DVB (8097): xc5000: check device hardware state to determine if firmware download is needed

TAKADA Yoshihito (1):
      ptrace GET/SET FPXREGS broken

Tejun Heo (6):
      sata_uli: hardreset is broken
      sata_sil24: add DID for another adaptec flavor
      ahci: always clear all bits in irq_stat
      libata-sff: improve HSM violation reporting
      pci: VT3336 can't do MSI either
      ahci: give another shot at clearing all bits in irq_stat

Thara Gopinath (1):
      ARM: OMAP: Correcting the gpmc prefetch control register address

Thomas Bogendoerfer (2):
      [MIPS] IP32: Fix unexpected irq 71
      [MIPS] IP22: Fix crashes due to wrong L1_CACHE_BYTES

Thomas Gleixner (1):
      x86: fix NODES_SHIFT Kconfig range

Tim Farrington (1):
      V4L/DVB (8048): saa7134: Fix entries for Avermedia A16d and Avermedia E506

Tim Yamin (1):
      powerpc/mpc5200: Fix lite5200b suspend/resume

Tomas Janousek (1):
      udf: Fix regression in UDF anchor block detection

Tony Luck (1):
      [IA64] Bugfix for system with 32 cpus

Tony Vroon (1):
      mac80211: implement EU regulatory domain

Uli Luckas (1):
      [ARM] 5109/1: Mark rtc sa1100 driver as wakeup source before registering it

Vegard Nossum (2):
      debugobjects: fix lockdep warning
      ACPI: don't walk tables if ACPI was disabled

WANG Cong (1):
      pkt_sched: ERR_PTR() ususally encodes an negative errno, not positive.

Wang Chen (4):
      netdevice: Fix typo of dev_unicast_add() comment
      netlink: Unneeded local variable
      net: Tyop of sk_filter() comment
      netdevice: Fix wrong string handle in kernel command line parsing

Will Newton (1):
      sisusbvga: Fix oops on disconnect.

Wolfram Sang (1):
      i2c: Fix bad hint about irqs in i2c.h

YOSHIFUJI Hideaki (1):
      ipv6 route: Convert rt6_device_match() to use RT6_LOOKUP_F_xxx flags.

Zhang, Yanmin (1):
      x86: fix cpu hotplug crash

maximilian attems (1):
      hdaps: add support for various newer Lenovo thinkpads

