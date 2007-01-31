Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXAaE2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXAaE2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 23:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXAaE2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 23:28:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXAaE2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 23:28:42 -0500
Date: Tue, 30 Jan 2007 20:28:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.20-rc7
Message-ID: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Yes, I know I said I would only do -rc6 and then the final 2.6.20, but the 
thing is, the known regressions list didn't get whittled down as quickly 
as I hoped, and as a result we now have a -rc7.

It's in good enough shape that I'd probably have been happy to just 
release it as 2.6.20, but since I want 2.6.20 to be a stability release, I 
didn't want to risk any stupid bugs while the regressions got fixed, so 
here's a final -rc7.

In other words, please do give it a good testing. We should have fixed the 
nasty stuff on Adrian's list (and here's another thanks to Adrian for 
keeping me on my toes!) and it's all good. But please give it a quick 
shake-down to make sure that nothing silly happened while fixing the bad 
stuff.

The shortlog really does say most of it - this is just various fixes for a 
number of mostly fairly inconsequential things, but the SG_IO timeout bug 
that hit any NeroLinux user would quite possibly impact other DVD/CD 
reader/writer programs too that used raw commands with timeouts.

The diffstat just looks like line-noise: 244 files changed with an average 
of less than 10 lines per file changed in 179 commits. In other words, 
really no big diffs: it's just a lot of really small stuff.

		Linus

---
Adam Litke (1):
      Don't allow the stack to grow into hugetlb reserved regions

Adrian Bunk (1):
      fs/lockd/clntlock.c: add missing newlines to dprintk's

Ahmed S. Darwish (1):
      [CPUFREQ] check sysfs_create_link return value

Al Viro (9):
      b44: src_desc->addr is little-endian
      missing exports of pm_power_off() on alpha and sparc32
      mtd/nand/cafe.c missing include of dma-mapping.h
      sym53c500_cs: remove bogus call fo free_dma()
      pata_platform: fallout from set_mode() change
      missing dma_sync_single_range_for{cpu,device} on alpha
      dma-mapping.h stubs fix
      b44: src_desc->addr is little-endian
      fix indentation-related breakage in Kconfig.i386

Alan Cox (5):
      ide/generic: Jmicron has its own drivers now
      libata cmd64x: whack into a shape that looks like the documentation
      libata hpt3xn: Hopefully sort out the DPLL logic versus the vendor code
      libata: set_mode, Fix the FIXME
      libata-sff: Don't call bmdma_stop on non DMA capable controllers

Alexey Dobriyan (2):
      Fix NULL ->nsproxy dereference in /proc/*/mounts
      core-dumping unreadable binaries via PT_INTERP

Andrew Morton (5):
      jmicron: fix warning
      pata_platform: set_mode fix
      82596 warning fixes
      m68k: uaccess.h needs sched.h
      ntfs: kmap_atomic() atomicity fix

Andrew Victor (6):
      [ARM] 4084/1: Remove CONFIG_DEBUG_WAITQ
      [ARM] 4085/1: AT91: Header fixes.
      [ARM] 4086/1: AT91: Whitespace cleanup
      [ARM] 4087/1: AT91: CPU reset for SAM9x processors
      [ARM] 4088/1: AT91: Unbalanced IRQ in serial driver suspend/resume
      [ARM] 4089/1: AT91: GPIO wake IRQ cleanup

Andy Gospodarek (1):
      bonding: ARP monitoring broken on x86_64

Atsushi Nemoto (1):
      SPI: alternative fix for spi_busnum_to_master

Auke Kok (1):
      e100: fix irq leak on suspend/resume

Avi Kivity (3):
      KVM: Emulate IA32_MISC_ENABLE msr
      KVM: MMU: Perform access checks in walk_addr()
      KVM: MMU: Report nx faults to the guest

Bartlomiej Zolnierkiewicz (3):
      ide: update MAINTAINERS entry
      ia64: add pci_get_legacy_ide_irq()
      ide: add missing __init tags to IDE PCI host drivers

Baruch Even (1):
      [TCP]: Fix sorting of SACK blocks.

Ben Dooks (4):
      [ARM] 4095/1: S3C24XX: Fix GPIO set for Bank A
      [ARM] 4096/1: S3C24XX: change return code form s3c2410_gpio_getcfg()
      S3C24XX: fix passing spi chipselect to select routine
      [ARM] 4117/1: S3C2412: Fix writel() usage in selection code

Benjamin Herrenschmidt (1):
      [POWERPC] Fix sys_pciconfig_iobase bus matching

Catalin Marinas (2):
      [ARM] 4112/1: Only ioremap to supersections if DOMAIN_IO is zero
      [ARM] 4111/1: Allow VFP to work with thread migration on SMP

Conke Hu (3):
      atiixp.c: remove unused code
      atiixp.c: sb600 ide only has one channel
      atiixp.c: add cable detection support for ATI IDE

Dan Williams (1):
      [ARM] 4100/1: iop3xx: fix cpu mask for iop333

Dave Jones (5):
      [AGPGART] Prevent (unlikely) memory leak in amd_create_gatt_pages()
      [AGPGART] Remove pointless typedef in ati-agp
      [AGPGART] Remove pointless assignment.
      [AGPGART] Add new IDs to VIA AGP.
      [CPUFREQ] Remove unneeded errata workaround from p4-clockmod.

David Barksdale (1):
      IPMI: fix timeout list handling

David Milburn (1):
      libata-scsi: ata_task_ioctl should return ATA registers from sense data

David S. Miller (4):
      [AF_PACKET]: Fix BPF handling.
      [AF_PACKET]: Check device down state before hard header callbacks.
      [TCP]: Restore SKB socket owner setting in tcp_transmit_skb().
      [SPARC64]: Set g4/g5 properly in sun4v dtlb-prot handling.

David Woodhouse (1):
      Fix Maple PATA IRQ assignment.

Dmitriy Monakhov (1):
      Broadcom 4400 resume small fix

Eric Van Hensbergen (5):
      9p: fix bogus return code checks during initialization
      9p: fix rename return code
      9p: update documentation regarding server applications
      9p: fix segfault caused by race condition in meta-data operations
      9p: null terminate error strings for debug print

Eric W. Biederman (3):
      [IPV4]: Fix the fib trie iterator to work with a single entry routing tables
      [DECNET]: Handle a failure in neigh_parms_alloc (take 2)
      i386: In assign_irq_vector look at all vectors before giving up

Evgeniy Dushistov (3):
      ufs: alloc metadata null page fix
      ufs: truncate negative to unsigned fix
      ufs: reallocation fix

Francois Romieu (1):
      netdev: add a MAINTAINERS entry for via-velocity and update my address

Geert Uytterhoeven (3):
      [POWERPC] PS3: Fix uniprocessor kernel build
      [POWERPC] ps3_free_io_irq: Fix inverted error check
      `make help' in build tree doesn't show headers_* targets

Geoff Levand (1):
      [POWERPC] PS3: add not complete comment to kconfig

H. Peter Anvin (1):
      Boot loader ID for Gujin

Haavard Skinnemoen (2):
      [AVR32] Export clear_page symbol
      [AVR32] Update ATSTK1000 defconfig: Enable macb by default

Hugh Dickins (1):
      mm: mremap correct rmap accounting

Ingo Molnar (1):
      ACPI: fix cpufreq regression

Jan Altenberg (1):
      Malta: Fix build if CONFIG_MTD is diabled.

Jan Engelhardt (1):
      cdev.h: forward declarations

Jean Delvare (1):
      Fix VIA quirks

Jeff Dike (2):
      Fix UML on non-standard VM split hosts
      uml: fix signal frame alignment

Jiri Kosina (3):
      HID: fix memleaking of collection
      USB HID: fix hid_blacklist clash for 0x08ca/0x0010
      HID: fix pb_fnmode and move it to generic HID

Joerg Roedel (1):
      KVM: SVM: Propagate cpu shutdown events to userspace

Johannes Stezenbach (1):
      uml: fix mknod

Josepch Chan (1):
      via82cxxx/pata_via: correct PCI_DEVICE_ID_VIA_SATA_EIDE ID and add support for CX700 and 8237S

Jun'ichi Nomura (1):
      dm-multipath: fix stall on noflush suspend/resume

Justin Clacherty (1):
      spi: fix error setting the spi mode in pxa2xx_spi.c

Lennert Buytenhek (1):
      ata_if_xfermask() word 51 fix

Leonard Norrgard (1):
      KVM: SVM: Fix SVM idt confusion

Linus Torvalds (6):
      Resurrect 'try_to_free_buffers()' VM hackery
      Write back inode data pages even when the inode itself is locked
      Fix balance_dirty_page() calculations with CONFIG_HIGHMEM
      Revert "[PATCH] namespaces: fix exit race by splitting exit"
      Revert "net: ifb error path loop fix"
      Linux 2.6.20-rc7

Linus Walleij (1):
      [ARM] 4102/1: Allow for PHYS_OFFSET on any valid 2MiB address

Mariusz Kozlowski (1):
      net: ifb error path loop fix

Mark Fasheh (1):
      ocfs2: fix thinko in ocfs2_backup_super_blkno()

Masami Hiramatsu (1):
      kprobes: replace magic numbers with enum

Matt Domsch (1):
      Fix race in efi variable delete code

Matt Reimer (1):
      [ARM] 4106/1: S3C2410: typo fixes in register definitions

Michael Chan (2):
      [BNX2]: Fix 2nd port's MAC address.
      b44: Fix frequent link changes

Mike Christie (1):
      Fix SG_IO timeout jiffy conversion

Mike Frysinger (4):
      remove __devinit markings from rtc_sysfs_add_device()
      use __u8/__u32 in userspace ioctl defines for I2O
      use __u8 rather than u8 in userspace SIZE defines in hdreg.h
      translate dashes in filenames for headers install

Miklos Szeredi (1):
      fuse: fix bug in control filesystem mount

Neil Brown (1):
      Remove warning: VFS is out of sync with lock manager

NeilBrown (12):
      knfsd: update email address and status for NFSD in MAINTAINERS
      knfsd: fix setting of ACL server versions
      knfsd: fix an NFSD bug with full sized, non-page-aligned reads
      knfsd: replace some warning ins nfsfh.h with BUG_ON or WARN_ON
      md: update email address and status for MD in MAINTAINERS
      md: make 'repair' actually work for raid1
      md: make sure the events count in an md array never returns to zero
      md: avoid reading past the end of a bitmap file
      knfsd: Fix type mismatch with filldir_t used by nfsd
      md: fix potential memalloc deadlock in md
      md: remove unnecessary printk when raid5 gets an unaligned read.
      knfsd: ratelimit some nfsd messages that are triggered by external events

Nick Piggin (1):
      Fix try_to_free_buffer() locking

Patrick McHardy (3):
      [NETFILTER]: nf_nat: fix ICMP translation with statically linked conntrack
      [NETFILTER]: nf_nat_pptp: fix expectation removal
      [NETFILTER]: nf_conntrack_pptp: fix NAT setup of expected GRE connections

Pavel Pisa (1):
      [ARM] 4092/1: i.MX/MX1 CPU Frequency scaling latency definition

Peter Staubach (1):
      knfsd: Don't mess with the 'mode' when storing a exclusive-create cookie

Ralf Baechle (1):
      [MIPS] Ocelot G: Fix a few misspellings of CONFIG_GALILEO_GT64240_ETH

Robert Hancock (1):
      libata: fix translation for START STOP UNIT

Robert Olsson (1):
      [IPV4]: Fix single-entry /proc/net/fib_trie output.

Robert P. J. Day (3):
      fix various kernel-doc in header files
      [MIPS] Fix typo of "CONFIG_MT_SMP".
      Fix "CONFIG_X86_64_" typo in drivers/kvm/svm.c

Roland McGrath (8):
      x86_64: fix put_user for 64-bit constant
      Fix CONFIG_COMPAT_VDSO
      Fix gate_vma.vm_flags
      Add VM_ALWAYSDUMP
      i386 vDSO: use VM_ALWAYSDUMP
      x86_64 ia32 vDSO: use VM_ALWAYSDUMP
      powerpc vDSO: use VM_ALWAYSDUMP
      x86_64 ia32 vDSO: define arch_vma_name

Russell King (3):
      [ARM] Fix show_mem() for discontigmem
      [ARM] Update mach-types
      [ARM] Fix AMBA serial drivers for non-first serial ports

Serge E. Hallyn (2):
      namespaces: fix exit race by splitting exit
      namespaces: fix task exit disaster

Sergei Shtylyov (1):
      pata_sil680: PIO1 taskfile transfers overclocking fix (repost)

Simon Bennett (1):
      HID: fix hid-input mapping for Firefly Mini Remote Control

Stephen Hemminger (1):
      sky2: revert IRQ dance on suspend/resume

Takashi Iwai (1):
      ALSA: Fix sysfs breakage

Tejun Heo (9):
      sata_via: don't diddle with ATA_NIEN in ->freeze
      ahci: improve and limit spurious interrupt messages, take#3
      libata: implement ATA_FLAG_IGN_SIMPLEX and use it in sata_uli
      ahci: fix endianness in spurious interrupt message
      sata_via: style clean up, no indirect method call in LLD
      ahci: use 0x80 as wait stat value instead of 0xff
      ahci: port_no should be used when clearing IRQ in ahci_thaw()
      libata: fix ata_eh_suspend() return value
      ide: unregister idepnp driver on unload

Thomas Klein (2):
      ehea: Fixed wrong jumbo frames status query
      ehea: Fixed missing tasklet_kill() call

Tilman Schmidt (1):
      Gigaset ISDN driver error handling fixes

Trond Myklebust (1):
      MM: Remove [PATCH] invalidate_inode_pages2_range() debug

Venkat Yekkirala (1):
      [SELINUX]: Fix 2.6.20-rc6 build when no xfrm

Vitaly Bordug (1):
      FS_ENET: OF-related fixup for FEC and SCC MAC's

Wang Zhenyu (1):
      [AGPGART] intel_agp: restore graphics device's pci space early in resume

ethanhsiao@jmicron.com (1):
      jmicron: 40/80pin primary detection

