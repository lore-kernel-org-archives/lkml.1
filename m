Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYFTXni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYFTXni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYFTXn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:43:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218AbYFTXnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:43:25 -0400
Date: Fri, 20 Jun 2008 16:42:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc7
Message-ID: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc.

And as usual, it's mainly drivers and arch updates - over 90% of changes 
are in one or the other. A big part of it (about two thirds of the driver 
update, in fact) is a late-dropping AGP/DRM update that adds support for 
some new Intel and ATI graphics cards. And a big part of the arch update 
is the inevitable def_config updates, of course.

I'm not all that happy about the timing of the support for the new cards, 
but at the same time I also hate delaying new drivers. Obviously the hope 
is that it can't cause any regressions, since the added code is almost 
entirely for stuff that simply wasn't supported at all before.

If you ignore the driver and arch updates, the rest is pretty minor. About 
half is in networking, and half of the remaining is filesystems updates 
(mainly ocfs2). And random smatterings elsewhere, like some scheduler 
updates.

Full shortlog appended.

		Linus

---

Abhijeet Kolekar (1):
      mac80211 : fix for iwconfig in ad-hoc mode

Adrian Bunk (1):
      [POWERPC] Build fix for drivers/macintosh/mediabay.c

Alex Chiang (1):
      [IA64] Update check_sal_cache_flush to use platform_send_ipi()

Alex Deucher (9):
      radeon: add production microcode from AMD
      drm/radeon: IGP clean up register and magic numbers.
      drm/radeon: merge IGP chip setup and fixup RS400 vs RS480 support
      drm/radeon: write AGP_BASE_2 on chips that support it.
      drm/radeon: fix pixcache and purge/cache flushing registers
      drm/radeon: fixup radeon_do_engine_reset
      drm/radeon: init pipe setup in kernel code.
      drm/radeon: switch IGP gart to use radeon_write_agp_base()
      drm/radeon: use DSTCACHE_CTLSTAT rather than RB2D_DSTCACHE_CTLSTAT

Amit Kucheria (1):
      agp: add support for Radeon Mobility 9000 chipset

Andrew G. Morgan (1):
      capabilities: add (back) dummy support for KEEPCAPS

Andrew Morton (1):
      [POWERPC] Fix warning in pseries/eeh_driver.c

Aneesh Kumar K.V (1):
      m68k: Add ext2_find_{first,next}_bit() for ext4

Ang Way Chuang (1):
      tun: Proper handling of IPv6 header in tun driver when TUN_NO_PI is set

Anton Vorontsov (1):
      [POWERPC] 83xx: MPC837xRDB's VSC7385 ethernet switch isn't on the MDIO bus

Atsushi Nemoto (1):
      [MIPS] Fix the fix for divide by zero error in build_{clear,copy}_page

Bartlomiej Zolnierkiewicz (13):
      opti621: disable read prefetch
      opti621: remove DMA support
      opti621: use PCI clock value provided by controller
      opti621: program devices timings separately in ->set_pio_mode
      opti621: use pre-calculated PIO timings
      opti621: add PIO 4 support
      ide-pmac: bugfix for media-bay support rework
      ide-pmac: add ->cable_detect method
      ide-pmac: remove bogus comment about pmac_ide_setup_device()
      ide-cs: fix probing and add warm-plug support
      ide-cs: fix releasing I/O resources
      ide-generic: don't probe all legacy ISA IDE ports by default
      ide: increase timeout in wait_drive_not_busy()

Ben Dooks (2):
      LIBATA: Add HAVE_PATA_PLATFORM to select PATA_PLATFORM driver
      BAST: Remove old IDE driver

Ben Hutchings (1):
      net: Fix test for VLAN TX checksum offload capability

Ben Nizette (1):
      proc_fs.h: move struct mm_struct forward-declaration

Bernhard Walle (1):
      x86: use BOOTMEM_EXCLUSIVE on 32-bit

Bertram Felgenhauer (1):
      pci, x86: add workaround for bug in ASUS A7V600 BIOS (rev 1005)

Bharath Ravi (1):
      sched, delay accounting: fix incorrect delay time when constantly waiting on runqueue

Chas Williams (2):
      atm: [he] only support suni driver on multimode interfaces
      atm: [he] send idle cells instead of unassigned when in SDH mode

Chris Dearman (1):
      [MIPS] vpe_id is required for VSMP and SMTC builds

Christophe Jaillet (1):
      drivers/net/r6040.c: correct bad use of round_jiffies()

Christophe Niclaes (1):
      pcmcia ide kingston compactflash's have a new manufacturer id

Chuck Ebbert (1):
      mmc: wbsd: initialize tasklets before requesting interrupt

Clemens Ladisch (1):
      sound: oxygen: fix NULL pointer dereference when loading snd-oxygen

Dario Faggioli (1):
      sched: NULL pointer dereference while setting sched_rt_period_us

Dave Airlie (12):
      drm: the sg alloc ioctl should write back the handle to userspace
      agp: more boolean conversions.
      drm: pcigart use proper pci map interfaces.
      drm/rs690: set all of gart base address.
      drm/rs690: set base 2 to 0.
      drm/radeon: add initial r500 support.
      drm/r500: add support for AGP based cards.
      drm/radeon: add hier-z registers for r300 and r500 chipsets
      agp/intel: cleanup some serious whitespace badness
      agp: brown paper bag patch - put back the two lines it took out.
      agp: brown paper bag patch - put back two lines that got lost
      drm: only trust core drm ioctls - driver ioctls are a mess.

Dave Hansen (2):
      pagemap: pass mm into pagewalkers
      pagemap: fix large pages in pagemap

David Brownell (3):
      rtc: make HPET_RTC_IRQ track HPET_EMULATE_RTC
      net/enc28j60: section fix
      net/enc28j60: low power mode

David Howells (1):
      MN10300: Kill linux/a.out.h inclusions

David S. Miller (5):
      net: Eliminate flush_scheduled_work() calls while RTNL is held.
      ipv6: Fix duplicate initialization of rawv6_prot.destroy
      tcp: Revert 'process defer accept as established' changes.
      tcp: Revert reset of deferred accept changes in 2.6.26
      Revert "mac80211: Use skb_header_cloned() on TX path."

David Woodhouse (4):
      Include <asm/a.out.h> in fs/exec.c only for Alpha.
      Remove last traces of a.out support from ELF loader.
      Remove #ifdef CONFIG_ARCH_SUPPORTS_AOUT from <linux/a.out.h>
      Export <linux/a.out.h> to userspace again.

Dennis Kasprzyk (1):
      drm/radeon: Restore sw interrupt on resume

Dhananjay Phadke (4):
      netxen: fix portnum for hp mezz cards
      netxen: remove global physical_port array
      netxen: cleanup debug messages
      netxen: download firmware in pci probe

Eduard - Gabriel Munteanu (1):
      Unignore vmlinux.lds.h from Git.

Eilon Greenstein (1):
      bnx2x: Updating the Maintainer

Emil Medve (1):
      [POWERPC] Fix return value check logic in debugfs virq_mapping setup

Eric Dumazet (1):
      raw: Restore /proc/net/raw correct behavior

Eric Kinzie (1):
      atm: [br2864] fix routed vcmux support

Eric Leblond (1):
      netfilter: Make nflog quiet when no one listen in userspace.

Eric Miao (1):
      MAINTAINERS: update maintainership of pxa2xx/pxa3xx

Gerrit Renker (6):
      dccp ccid-3: Bug-Fix - Zero RTT is possible
      dccp: Fix sparse warnings
      dccp ccid-2: Bug-Fix - Ack Vectors need to be ignored on request sockets
      dccp ccid-3: TFRC reverse-lookup Bug-Fix
      dccp ccid-3: X truncated due to type conversion
      dccp: Bug in initial acknowledgment number assignment

Gertjan van Wingerde (1):
      rt2x00: Restrict DMA to 32-bit addresses.

Grant Likely (1):
      [POWERPC] bootwrapper: add simpleImage* to list of boot targets

Greg Kroah-Hartman (1):
      agp/via: fixup pci ids

Guennadi Liakhovetski (1):
      [ARM] 5077/1: spi: fix list scan success verification in PXA ssp driver

Haavard Skinnemoen (1):
      rtc-at32ap700x: fix bug in at32_rtc_readalarm()

Ivo van Doorn (2):
      rt2x00: Don't kill guardian_urb when it wasn't created
      rt2x00: Add D-link DWA111 support

Jack Morgenstein (1):
      IB/uverbs: Fix check of is_closed flag check in ib_uverbs_async_handler()

Jack Steiner (1):
      [IA64] Fix CONFIG_IA64_SGI_UV build error

James Bottomley (1):
      [SCSI] sr: fix corrupt CD data after media change and delay

Jan Beulich (1):
      agp: two-stage page destruction issue

Jason Wessel (1):
      softlockup: fix NMI hangs due to lock race - 2.6.26-rc regression

Jeff Dike (2):
      uml: remove include of asm/user.h
      uml: work around broken host PTRACE_SYSEMU

Jeff Mahoney (1):
      [SCSI] dpt_i2o: Add PROC_IA64 define

Jeremy Fitzhardinge (1):
      x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.

Jesper Dangaard Brouer (2):
      pkt_sched: HTB scheduler, change default hysteresis mode to off.
      pkt_sched: Change HTB_HYSTERESIS to a runtime parameter htb_hysteresis.

Jesse Barnes (1):
      PCI: fixup write combine comment in pci_mmap_resource

Jiri Bohac (1):
      console keyboard mapping broken by 04c71976

Jiri Kosina (2):
      Input: i8042 - add Fujitsu-Siemens Amilo Pro V2030 to nomux table
      Input: i8042 - retry failed CTR writes when resuming

Joe Perches (1):
      drivers/char/agp - use bool

Joel Becker (3):
      ocfs2: Move the hb_ctl_path sysctl into the stack glue.
      ocfs2: Move the call of ocfs2_hb_ctl into the stack glue.
      ocfs2: Remove ->hangup() from stack glue operations.

Johannes Weiner (1):
      drm: use drms ioctl cmd not what we get passed from userspace.

Jordan Crouse (1):
      x86, geode: add a VSA2 ID for General Software

Jorge Boncompte [DTI2] (3):
      atm: [br2684] Fix oops due to skb->dev being NULL
      atm: [iphase] set drvdata before enabling interrupts
      atm: [iphase] doesn't call phy->start due to a bogus #ifndef

Josh Boyer (2):
      ibm_newemac: select CRC32 in Kconfig
      [POWERPC] 4xx: Clear new TLB cache attribute bits in Data Storage vector

Julia Lawall (4):
      drivers/isdn/sc/ioctl.c: add missing kfree
      [POWERPC] Add missing of_node_put in pseries/nvram.c
      [POWERPC] Add missing of_node_put in drivers/macintosh/smu.c
      [POWERPC] Add missing of_node_put in drivers/macintosh/therm_adt746x.c

Jürgen Schindele (1):
      [ARM] 5090/1: Correct pxafb palette typo error

Kristoffer Ericson (1):
      pcmcia: add another pata/ide ID

Krzysztof Helt (1):
      hgafb: resource management fix

Kumar Gala (5):
      [POWERPC] 85xx: MPC85xx MDS - Unconditionally select PHYLIB for board fixups
      [POWERPC] 85xx: MPC8548CDS - Fix size of PCIe IO space
      [POWERPC] Updated Freescale PPC defconfigs
      [POWERPC] Fix bootwrapper builds with newer gcc versions
      [POWERPC] Fix -Os kernel builds with newer gcc versions

Kyle McMartin (7):
      Revert "parisc: fix trivial section name warnings"
      parisc: move head.S to head.text section
      parisc: export copy_user_page_asm
      parisc: export empty_zero_page
      parisc: fix off by one in setup_sigcontext32
      parisc: fix miscompilation of ip_fast_csum with gcc >= 4.3
      parisc: update my email address

Len Brown (1):
      ACPI: no AC status notification

Li Zefan (1):
      cpuset: limit the input of cpuset.sched_relax_domain_level

Linus Torvalds (4):
      x86-64: Fix "bytes left to copy" return value for copy_from_user()
      Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix XIP
      [watchdog] hpwdt: fix use of inline assembly
      Linux 2.6.26-rc7

Luke Browning (4):
      powerpc/spufs: wait for stable spu status in spu_stopped()
      powerpc/spufs: remove class_0_dsisr from spu exception handling
      powerpc/spufs: synchronize interaction between spu exception handling and time slicing
      powerpc/spufs: fix missed stop-and-signal event

Maciej W. Rozycki (3):
      [MIPS] SB1250: Initialize io_map_base
      [MIPS] Sibyte: Build RTC support as an object
      [MIPS] Bring the SWARM defconfig up to date

Mark Lord (2):
      sata_mv: enable async_notify for 60x1 Rev.C0 and higher
      sata_mv: warn on PIO with multiple DRQs

Mark McLoughlin (1):
      virtio: Complete feature negotation before updating status

Masami Hiramatsu (1):
      kprobes: fix error checking of batch registration

Matt Reimer (1):
      pcmcia: add an pata/ide ID

Max Krasnyansky (1):
      sched: CPU hotplug events must not destroy scheduler domains created by the cpusets

Michael Buesch (3):
      b43: Fix possible NULL pointer dereference in DMA code
      b43: Fix noise calculation WARN_ON
      ssb: Fix coherent DMA mask for PCI devices

Mikael Pettersson (1):
      x86, 32-bit: fix boot failure on TSC-less processors

Mike Christie (1):
      [SCSI] scsi_host regression: fix scsi host leak

Mike Miller (1):
      cciss: add new hardware support

Miklos Szeredi (1):
      fuse: fix thinko in max I/O size calucation

Miquel van Smoorenburg (2):
      x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
      x86, pci-dma.c: don't always add __GFP_NORETRY to gfp

Nick Piggin (2):
      radix-tree: fix small lockless radix-tree bug
      [POWERPC] Fix rmb to order cacheable vs. noncacheable

OGAWA Hirofumi (1):
      fat: relax the permission check of fat_setattr()

Oliver Neukum (1):
      Input: appletouch - implement reset-resume logic

Patrick McHardy (5):
      netfilter: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()
      netfilter: nf_nat: fix RCU races
      netfilter: nf_conntrack_h323: fix memory leak in module initialization error path
      netfilter: nf_conntrack_h323: fix module unload crash
      netlink: genl: fix circular locking

Paul Collins (1):
      udf: restore UDFFS_DEBUG to being undefined by default

Paul Jackson (1):
      cpusets: provide another web page URL in MAINTAINERS file

Paul Mackerras (2):
      [POWERPC] Turn on ATA_SFF so we get SATA_SVW back in defconfigs
      [POWERPC] Clear sub-page HPTE present bits when demoting page size

Paul Menage (1):
      /proc/sysvipc/shm: fix 32-bit truncation of segment sizes

Pavel Machek (1):
      suspend-vs-iommu: prevent suspend if we could not resume

Peter Zijlstra (3):
      sched: rt-group: fix hierarchy
      sched: rt-group: heirarchy aware throttle
      sched: rt-group: fix RR buglet

Philippe De Muyter (3):
      m68knommu: init coldfire timer TRR with n - 1, not n
      drivers/video/cirrusfb: fix RAM address printk
      driver/char/generic_nvram: fix banner

Rabin Vincent (1):
      sched: fix defined-but-unused warning

Radu Cristescu (1):
      atl1: relax eeprom mac address error check

Rainer Weikusat (1):
      af_unix: fix 'poll for write'/ connected DGRAM sockets

Ralf Baechle (4):
      [MIPS] Export empty_zero_page for sake of the ext4 module.
      [MIPS] Fix build for PNX platforms.
      [MIPS] Fix buggy use of kmap_coherent.
      [MIPS] Malta: Always compile MTD platform device registration code.

Rami Rosen (1):
      ipv4: Remove unused definitions in net/ipv4/tcp_ipv4.c.

Randy Dunlap (2):
      rt2x00: INPUT build failure
      rt2x00: LEDS build failure

Robert Reif (1):
      sparc: get leo framebuffer working

Robert T. Johnson (1):
      atm: [he] limit queries to the device's register space

Roel Kluin (2):
      ipg: fix receivemode IPG_RM_RECEIVEMULTICAST{,HASH} in ipg_nic_set_multicast_list()
      fec_mpc52xx: MPC52xx_MESSAGES_DEFAULT: 2nd NETIF_MSG_IFDOWN => IFUP

Roland Dreier (1):
      RDMA/nes: Fix off-by-one in nes_reg_user_mr() error path

Roland Scheidegger (1):
      drm/radeon: fix texture uploads with large 3d textures (bug 13980)

Sergei Shtylyov (2):
      [MIPS] Au1200: MMC resource size off by one
      palm_bk3710: fix resource management

Sergey Lapin (1):
      rtc: Ramtron FM3130 RTC support

Shan Wei (1):
      ipv6: Check the hop limit setting in ancillary data.

Shane Huang (1):
      ahci: Workaround HW bug for SB600/700 SATA controller PMP support

Sonic Zhang (2):
      Blackfin arch: fix typo error in bf548 serial header file
      Blackfin Serial Driver: Use timer to poll CTS PIN instead of workqueue.

Stas Sergeev (2):
      Input: pcspkr - remove negative dependency on snd-pcsp
      provide rtc_cmos platform device

Stefan Richter (9):
      firewire: don't panic on invalid AR request buffer
      firewire: fw-ohci: use of uninitialized data in AR handler
      firewire: fw-ohci: disable PHY packet reception into AR context
      firewire: fw-ohci: write selfIDBufferPtr before LinkControl.rcvSelfID
      firewire: fill_bus_reset_event needs lock protection
      firewire: fw-ohci: unify printk prefixes
      firewire: deadline for PHY config transmission
      firewire: Kconfig menu touch-up
      ieee1394: Kconfig menu touch-up

Stefan Schmidt (1):
      [ARM] 5091/1: Add missing bitfield include to regs-lcd.h

Steffen Klassert (1):
      xfrm: fix fragmentation for ipv4 xfrm tunnel

Stephen Hemminger (2):
      intel_rng: make device not found a warning
      sky2: 88E8040T pci device id

Stephen Rothwell (1):
      [POWERPC] Remove ppc32's export of console_drivers

Steven Rostedt (1):
      rcupreempt: remove export of rcu_batches_completed_bh

Suresh Siddha (1):
      x86: fix NULL pointer deref in __switch_to

Tejun Heo (5):
      ahci: workarounds for mcp65
      ahci: jmb361 has only one port
      libata: don't check whether to use DMA or not for no data commands
      ata_piix: add TECRA M4 to broken suspend list
      ahci: sis can't do PMP

Thomas Bogendoerfer (3):
      [MIPS] Better load address for big endian SNI RM
      [MIPS] Add RM200 with R5000 CPU to known ARC machines
      [MIPS] Malta: Fix build errors for 64-bit kernels

Thomas Horsten (2):
      [MIPS] Lasat: bring back from the dead
      [MIPS] Lasat: sysctl fixup

Thomas Mingarelli (2):
      Revert "[WATCHDOG] make watchdog/hpwdt.c:asminline_call() static"
      [WATCHDOG] hpwdt: Add CFLAGS to get driver working

Timur Tabi (1):
      [POWERPC] 8610: Update defconfig for MPC8610 HPCD

Tomas Winkler (1):
      mac80211: add missing new line in debug print HT_DEBUG

Tony Camuso (1):
      PCI: Correct last two HP entries in the bfsort whitelist

Vlad Yasevich (1):
      sctp: Correclty set changeover_active for SFR-CACC

Wei Yongjun (1):
      sctp: Correctly cleanup procfs entries upon failure.

Wim Van Sebroeck (1):
      Revert "[WATCHDOG] hpwdt: Fix NMI handling."

YOSHIFUJI Hideaki (5):
      ipv6 mcast: Check address family of gf_group in getsockopt(MS_FILTER).
      ipv6 route: Fix route lifetime in netlink message.
      ipv6: Check IPV6_MULTICAST_LOOP option value.
      ipv6: Fail with appropriate error code when setting not-applicable sockopt.
      ipv6 sit: Avoid extra need for compat layer in PRL management.

Yinghai Lu (1):
      PCI: use dev_to_node in pci_call_probe

Yoichi Yuasa (2):
      [MIPS] Vr41xx: Initialize PCI io_map_base
      [MIPS] TANBAC: Update defconfig

Zenon Fortuna (1):
      [MIPS] Export smp_call_function and smp_call_function_single.

Zhang Rui (1):
      ACPI Exception (video-1721): UNKNOWN_STATUS_CODE, Cant attach device

Zhenyu Wang (4):
      [AGP] intel_agp: extra stolen mem size available for IGD_GM chipset
      [AGP] intel_agp: Add support for Intel 4 series chipsets
      [agp]: fixup chipset flush for new Intel G4x.
      drm/i915: add support for Intel series 4 chipsets.

bruno randolf (1):
      [MIPS] Alchemy: Add au1500 reserved interrupt

kosaki.motohiro@jp.fujitsu.com (1):
      mm: fix incorrect variable type in do_try_to_free_pages()

stephane eranian (1):
      [IA64] perfmon: fix async exit bug

venkatesh.pallipadi@intel.com (1):
      x86: PAT export resource_wc in pci sysfs
