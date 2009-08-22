Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbZHVB01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbZHVB01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 21:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933052AbZHVB01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 21:26:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933051AbZHVB0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 21:26:25 -0400
Date: Fri, 21 Aug 2009 18:26:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31-rc7
Message-ID: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You know the drill, so all together now: "Another week, another -rc 
kernel".

Most of the changes are small one-liners, but the dirstat shows the areas 
that got a bit more tender loving care:

  17.4% arch/arm/mach-omap2/
   2.2% arch/arm/mm/
   3.8% arch/arm/plat-omap/
  24.3% arch/arm/
   2.5% arch/microblaze/
  29.2% arch/
   9.6% drivers/gpu/drm/radeon/
  13.2% drivers/gpu/drm/
   3.2% drivers/i2c/busses/
   2.8% drivers/media/dvb/frontends/
   4.7% drivers/media/dvb/siano/
   7.6% drivers/media/dvb/
   2.6% drivers/media/video/em28xx/
   8.2% drivers/media/video/
  16.2% drivers/media/
   3.0% drivers/net/e1000e/
   3.4% drivers/net/ixgbe/
   2.6% drivers/net/netxen/
  16.6% drivers/net/
  50.2% drivers/
   2.9% fs/xfs/
   5.7% fs/
   2.5% include/linux/
   3.1% include/
   3.1% mm/
   2.0% net/
   2.5% security/
 290 files changed, 3366 insertions(+), 1777 deletions(-)

ie we have some arm and microblaze updates, radeon/drm and media updates, 
and network drivers. The rest tends to be a random smattering all over.

But apart from a couple of bigger ones (OMAP GPIO/UART fixes and the 
radeom/kms changes), it's really pretty small. The bulk of those 290 files 
changed are basically few-liners in 213 commits (shortlog below), and in 
general we should have cut down the regression list another tiny bit.

Worth testing: if you've seen NULL pointer oopses with reiserfs under 
load, I committed something I hope fixes it. I'd have wished to get 
a firm confirmation before doing that, but I wanted to get the fix in 
before -rc7, so now I'll just have to wait for results after.

And if you had odd lock-ups with older dual-CPU machines (PPro, P2, P3, 
Athlon XP), that should be fixed too.

There's some inotify fixes here too, but I don't think we've confirmed 
whether they help the (apparently very  hard to trigger) oopses some 
people have seen. So please test and report.

	Thanks,
		Linus

---
Alex Deucher (1):
      drm/radeon: add GET_PARAM/INFO support for Z pipes

Amerigo Wang (1):
      percpu: use the right flag for get_vm_area()

Amit Kumar Salecha (1):
      netxen: remove netxen workqueue

Andreas Schwab (1):
      security: Fix prompt for LSM_MMAP_MIN_ADDR

Andrew Morton (1):
      mmc: add the new linux-mmc mailing list to MAINTAINERS

Andy Walls (1):
      V4L/DVB (12338): cx18: Read buffer overflow

Anton Blanchard (1):
      AFS: Documentation updates

Antonio Ospite (1):
      V4L/DVB (12330): pxa_camera: Fix Oops in pxa_camera_probe

Arnaldo Carvalho de Melo (1):
      perf record: Fix typo in pid_synthesize_comm_event

Atsushi Nemoto (1):
      MIPS: Fix HPAGE_SIZE redefinition

Bartlomiej Zolnierkiewicz (1):
      x86, mce: don't log boot MCEs on Pentium M (model == 13) CPUs

Ben Dooks (2):
      spi_s3c24xx: fix clock rate calculation
      spi_s3c24xx: fix transfer setup code

Bo Liu (1):
      mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()

Bob Dunlop (1):
      libertas: correct packing of rxpd structure

Brian Johnson (1):
      V4L/DVB (12373a): Add gspca sn9c20x subdriver entry to MAINTAINERS file

Bruce Allan (3):
      e1000e: fix acquisition of SW/FW/HW semaphore for ICHx parts
      e1000e: fix potential NVM corruption on ICH9 with 8K bank size
      e1000e: WoL does not work on 82577/82578 with manageability enabled

Carlos R. Mafra (1):
      perf: Rename perf-examples.txt to examples.txt

Chris Snook (1):
      MAINTAINERS: update atlx contact info

Christian Lamparter (1):
      ar9170usb: fix spurious firmware related message

Christoph Hellwig (2):
      xfs: fix locking in xfs_iget_cache_hit
      microblaze: use the generic ack_bad_irq implementation

Cliff Wickman (1):
      x86: Fix UV BAU destination subnode id

Dan Carpenter (1):
      ar9170: fix read & write outside array bounds

Dave Airlie (10):
      drm/edid: fixup detailed timings like the X server.
      drm/radeon/kms: add rv530 R300_SU_REG_DEST + reloc for ZPASS_ADDR
      drm/radeon/kms: cut down indirects in register accesses.
      drm/radeon/kms: implement bo busy check + current domain
      drm/radeon/kms: although LVDS might be possible on crtc 1 don't do it.
      drm/radeon/kms: memset the allocated framebuffer before using it.
      drm/kms/radeon: cleanup combios TV table like DDX.
      drm/kms: teardown crtc correctly when fb is destroyed.
      drm/radeon/kms: implement the bo busy ioctl properly.
      drm/radeon/kms: add r100/r200 OQ support.

Dave Jones (1):
      security: Make LSM_MMAP_MIN_ADDR default match its help text.

David S. Miller (1):
      Revert "libertas: Read buffer overflow"

Davide Rizzo (1):
      ARM: S3C24XX: Fix clkout mpx error

Devin Heitmueller (3):
      V4L/DVB (12393): cx88: fix regression in tuning for Geniatech X8000 MT
      V4L/DVB (12394): cx88: Disable xc3028 power management for Geniatech x8000
      V4L/DVB (12432): em28xx: fix regression in Empire DualTV digital tuning

Dhananjay Phadke (2):
      netxen: fix dma mask update calculation
      netxen: free napi resources during detach

Dmitry Eremin-Solenikov (2):
      af_ieee802154: fix ioctl processing
      af_ieee802154: provide dummy get/setsockopt

Don Skidmore (1):
      ixgbe: fix issues setting rx-usecs with legacy interrupts

Dongdong Deng (1):
      drivers/net: fixed drivers that support netpoll use ndo_start_xmit()

Eero Nurkkala (1):
      OMAP: PM: CPUfreq: obey min/max settings of policy

Eric Dumazet (8):
      phonet: phonet_device_get() fix
      rose: Fix rose_getname() leak
      econet: Fix econet_getname() leak
      netrom: Fix nr_getname() leak
      appletalk: fix atalk_getname() leak
      irda: Fix irda_getname() leak
      can: Fix raw_getname() leak
      net: restore gnet_stats_basic to previous definition

Eric Paris (7):
      Capabilities: move cap_file_mmap to commoncap.c
      SELinux: call cap_file_mmap in selinux_file_mmap
      Security/SELinux: seperate lsm specific mmap_min_addr
      security: define round_hint_to_min in !CONFIG_SECURITY
      notify: unused event private race
      inotify: tail drop inotify q_overflow events
      inotify: start watch descriptor count at 1

Francois Romieu (1):
      8139cp: balance dma_map_single vs dma_unmap_single pair

From: Nick Piggin (1):
      btrfs: fix inode rbtree corruption

Graff Yang (1):
      nommu: check fd read permission in validate_mmap_request()

Greg Ungerer (1):
      fec: fix FEC driver packet transmission breakage

Guennadi Liakhovetski (2):
      mx3: Fix double pin allocation in pcm037_eet.c
      V4L/DVB (12424): soc-camera: fix recursive locking in .buf_queue()

Guillaume Knispel (1):
      poll/select: initialize triggered field of struct poll_wqueues

Hans Verkuil (2):
      V4L/DVB (12428): hdpvr: add missing initialization of current_norm
      V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM default handlers

Herbert Xu (1):
      tun: Extend RTNL lock coverage over whole ioctl

Hugh Dickins (1):
      x86, mce: therm_throt: Don't log redundant normality

Ingo Molnar (3):
      x86, mce: Don't initialize MCEs on unknown CPUs
      perf_counter: Fix the PARISC build
      perf annotate: Fix segmentation fault

Jan Nikitenko (1):
      V4L/DVB (12341): zl10353 and qt1010: fix stack corruption bug

Janboe Ye (1):
      OMAP3: Fix omap3 sram virtual addres overlap vmalloc space after increasing vmalloc size

Jean Pihet (2):
      OMAP3 SDRC: add support for 2 SDRAM chip selects
      OMAP3: Setup MUX settings for SDRC CKE signals

Jeff Layton (1):
      vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed

Jerome Glisse (1):
      drm/radeon/kms: Add specific rs690 authorized register table

Joe Perches (3):
      MAINTAINERS: additional NETWORKING [GENERAL] and NETWORKING DRIVERS patterns
      MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
      REPORTING-BUGS: add get_maintainer.pl blurb

John Williams (1):
      microblaze: Sane handling of missing timer/intc in device tree

Jouni Hogander (1):
      OMAP3: PM: Fix wrong sequence in suspend.

Jussi Mäki (1):
      Fix xfrm hash collisions by changing __xfrm4_daddr_saddr_hash to hash addresses with addition

KOSAKI Motohiro (1):
      mm: revert "oom: move oom_adj value"

Kevin Hilman (11):
      OMAP2/3: PM: make PM __init calls static
      OMAP3: PM: CM_REGADDR macros using wrong name
      OMAP3: PM: Ensure PRCM interrupts are cleared at boot
      OMAP3: PM: Clear pending PRCM reset flags on init
      OMAP3: PM: prevent module wakeups from waking IVA2
      OMAP3: PM: Do not build suspend code if SUSPEND is not enabled
      OMAP4: UART: cleanup special case IRQ handling
      OMAP2/3/4: UART: Allow per-UART disabling wakeup for serial ports
      OMAP2/3/4: UART: allow in-order port traversal
      OMAP: GPIO: clear/restore level/edge detect settings on mask/unmask
      OMAP3: Overo: add missing pen-down GPIO definition

Kyle McMartin (1):
      perf tools: Make 'make html' work

Laurent Pinchart (2):
      V4L/DVB (12328): uvcvideo: Don't apply the FIX_BANDWIDTH quirk to all ViMicro devices
      V4L/DVB (12380): uvcvideo: Avoid flooding the kernel log with "unknown event type" messages

Lennert Buytenhek (5):
      mwl8k: fix NULL pointer dereference on receive out-of-memory
      mwl8k: add various missing GET_HW_SPEC endian conversions
      mwl8k: call pci_unmap_single() before accessing command structure again
      mwl8k: prevent crash in ->configure_filter() if no interface was added
      mwl8k: prevent module unload hang

Leonardo Potenza (1):
      x86: Annotate section mismatch warnings in kernel/apic/x2apic_uv_x.c

Linus Torvalds (5):
      x86: don't send an IPI to the empty set of CPU's
      Make bitmask 'and' operators return a result code
      x86: don't call '->send_IPI_mask()' with an empty mask
      Re-introduce page mapping check in mark_buffer_dirty()
      Linux 2.6.31-rc7

Linus Walleij (2):
      ARM: 5673/1: U300 fix initsection compile warning
      i2c-stu300: I2C STU300 stability updates

Lucy Liu (1):
      ixgbe: Fix receive on real device when VLANs are configured

Luis R. Rodriguez (1):
      mac80211: fix panic when splicing unprepared TIDs

Magnus Damm (4):
      sh: skip disabled LCDC channels
      sh: CMT suspend/resume
      sh: use in-soc KEYSC on se7724
      sh: sh7724 ddr self-refresh changes

Matthias Schwarzott (1):
      V4L/DVB (12440): Use kzalloc for frontend states to have struct dvb_frontend properly

Mauro Carvalho Chehab (12):
      V4L/DVB (12340): mtv9v011: Add a missing chip version to the driver
      V4L/DVB (12344): em28xx: fix support for Plextor ConvertX PX-TV100U
      V4L/DVB (12399): mt9v011: Add support for controlling frame rates
      V4L/DVB (12400): em28xx: Allow changing fps on webcams
      V4L/DVB (12401): m9v011: add vflip/hflip controls to control mirror/upside down
      V4L/DVB (12402): em28xx: fix: some em2710 chips use a different vendor ID
      V4L/DVB (12403): em28xx: properly reports some em2710 chips
      V4L/DVB (12406): em28xx: fix: don't do image interlacing on webcams
      V4L/DVB (12407): em28xx: Adjust Silvercrest xtal frequency
      V4L/DVB (12410): em28xx: Move the non-board dependent part to be outside em28xx_pre_card_setup()
      V4L/DVB (12411): em28xx: Fix artifacts with Silvercrest webcam
      V4L/DVB (12405): em28xx-cards: move register 0x13 setting to the proper place

Michael Chan (5):
      cnic: Fix symbol_put_addr() panic on ia64.
      cnic: Refine registration with bnx2.
      bnx2: Use mutex on slow path cnic calls.
      cnic: Fix locking in start/stop calls.
      cnic: Fix locking in init/exit calls.

Michael Krufky (5):
      V4L/DVB (12362): cx23885-417: fix manipulation of tvnorms
      V4L/DVB (12374): sms1xxx: fix broken Hauppauge devices
      V4L/DVB (12386): sms1xxx: fix build warning: unused variable 'board'
      V4L/DVB (12390): saa7134: Use correct product name for Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid
      V4L/DVB (12391): saa7134: Use correct product name for Hauppauge WinTV-HVR1120 DVB-T/Hybrid

Michal Simek (3):
      microblaze: Enable ppoll syscall
      microblaze: Use klimit instead of _end for memory init
      microblaze: Update Microblaze defconfigs

Michel Dänzer (1):
      drm/radeon/kms: Fix up vertical blank interrupt support.

Mikael Pettersson (1):
      IXP4xx: Fix IO_SPACE_LIMIT for 2.6.31-rc core PCI changes

Moiz Sonasath (2):
      i2c-omap: ACK pending [R/X]DR and [R/X]RDY interrupts
      i2c-omap: Enable workaround for Errata 1.153 based on

NeilBrown (1):
      Fix new incorrect error return from do_md_stop.

Nils Kassube (1):
      V4L/DVB (12371): af9015: Fix for crash in dvb-usb-af9015

Nishanth Menon (1):
      i2c-omap: Fix I2C status ACK

Oliver Hartkopp (1):
      can: fix oops caused by wrong rtnl newlink usage

Pascal Terjan (1):
      Add IDs for 3C905B-TX Fast Etherlink XL PCI

Paul Mackerras (1):
      perf_counter: Check task on counter read IPI

Paul Walmsley (4):
      OMAP2/3 SDRC: don't set SDRC_POWER.PWDENA on boot
      OMAP2/3 clock: split, rename omap2_wait_clock_ready()
      OMAP2 clock: 2430 I2CHS uses non-standard CM_IDLEST register
      OMAP3 clock: correct module IDLEST bits: SSI; DSS; USBHOST; HSOTGUSB

Pavel Roskin (1):
      rt2x00: fix memory corruption in rf cache, add a sanity check

Petko Manolov (1):
      pegasus: Add new device ID.

Rafael Laufer (1):
      sctp: fix missing destroy of percpu counter variable in sctp_proc_exit()

Rajendra Nayak (2):
      OMAP3 SDRC: Fix freeze when scaling CORE dpll to < 83Mhz
      OMAP3 SDRC: Move the clk stabilization delay to the right place

Ralf Baechle (1):
      NETROM: Fix use of static buffer

Ramax Lo (1):
      ARM: S3C64XX: serial: Fix a typo in Kconfig

Randy Dunlap (3):
      V4L/DVB (12422): media/zr364xx: fix build errors
      V4L/DVB (12437): dvb: siano uses/depends on INPUT
      dm-log-userspace: fix printk format warning

Roel Kluin (6):
      irda: fix read buffer overflow
      atlx: strncpy does not null terminate string
      V4L/DVB (12337): ivtv: Read buffer overflow
      V4L/DVB (12436): stk-webcam: read buffer overflow
      V4L/DVB (12438): Read buffer overflow
      V4L/DVB (12441): siano: read buffer overflow

Roger Quadros (4):
      OMAP: GPIO: Fix incorrect gpio_get logic for output GPIOs
      OMAP3: RX51: Define TWL4030 USB transceiver in board file
      OMAP2/3: mmc-twl4030: Free up MMC regulators while cleaning up
      OMAP3: RX51: Updated rx51_defconfig

Russell King (1):
      ARM: Fix broken highmem support

Ryusuke Konishi (1):
      nilfs2: fix oopses with doubly mounted snapshots

Sergio Aguirre (1):
      OMAP3: Overo: Fix smsc911x platform device resource value

Sohail Syyed (1):
      V4L/DVB (12349): cx88: HVR1300 ensure switching from Encoder to DVB-T and back is reliable

Steven Whitehouse (1):
      GFS2: Fix permissions on "recover" file

Takashi Iwai (1):
      ALSA: hda - Fix probe of Toshiba laptops with ALC268 codec

Tejun Heo (2):
      init: set nr_cpu_ids before setup_per_cpu_areas()
      percpu, sparc64: fix sparse possible cpu map handling

Tero Kristo (1):
      OMAP3: Fixed crash bug with serial + suspend

Thomas Gleixner (1):
      genirq: Wake up irq thread after action has been installed

Thomas Hellstrom (1):
      drm: Fix sysfs device confusion.

Tom Goff (1):
      gre: Fix MTU calculation for bound GRE tunnels

Tony Lindgren (1):
      OMAP: Fix testing of cpu defines for mach-omap1

Valentin Longchamp (1):
      mx31moboard: invert sdhc ro signal sense

Vikram Pandita (1):
      OMAP2/3: DMA errata correction

Wei Yongjun (1):
      dccp: missing destroy of percpu counter variable while unload module

Wu Fengguang (2):
      ALSA: hda: enable speaker output for Compaq 6530s/6531s
      ALSA: hda: add model for Intel DG45ID/DG45FC boards

Xiaotian Feng (1):
      e1000e: fix use of pci_enable_pcie_error_reporting

Yi Zou (3):
      ixgbe: Pass rx_ring directly in ixgbe_configure_srrctl()
      ixgbe: Disable packet split only on FCoE queues in 82599
      ixgbe: Do not return 0 in ixgbe_fcoe_ddp() upon FCP_RSP in DDP completion

Yong Zhang (1):
      gianfar: keep vlan related state when restart

Zhang Qiang (1):
      nilfs2: missing a read lock for segment writer in nilfs_attach_checkpoint()

Zhu Yi (1):
      ipw2x00: Write outside array bounds

roel kluin (4):
      pcnet32: Read buffer overflow
      zorro8390: Fix read buffer overflow in zorro8390_init_one()
      mlx4_en: Fix read buffer overflow in mlx4_en_complete_rx_desc()
      via-velocity: Fix test of mii_status bit VELOCITY_DUPLEX_FULL
