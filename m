Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYHMCda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYHMCda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 22:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYHMCdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 22:33:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbYHMCdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 22:33:19 -0400
Date: Tue, 12 Aug 2008 19:33:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-rc3
Message-ID: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Things really _have_ calmed down, and hopefully we've also resolved a lot 
of the regressions in -rc3.

That said, the diffstat shows two things standing out:

 - continued rename of arch include files (if you don't enable rename 
   detection and filter it out). ARM, AVR32 and m68knommu this time.

 - the inclusion of the ath9k wireless driver (and to a smaller degree, 
   watchdog driver updates). The dirstat says it all:

	   2.0% arch/avr32/configs/
	   2.1% arch/avr32/
	   2.2% arch/
	   2.4% drivers/char/
	   3.4% drivers/net/wan/
	  58.8% drivers/net/wireless/ath9k/
	  58.9% drivers/net/wireless/
	  65.3% drivers/net/
	   7.9% drivers/watchdog/
	  84.1% drivers/

   ie that ath9k driver is the bulk of the whole patch.

But all the small changes are where the regression fixes are, and other 
random improvements. And they're all over. The ShortLog (appended) 
probably gives a taste of it.

		Linus

---
Adam Langley (1):
      tcp: (whitespace only) fix confusing indentation

Adrian Bunk (18):
      mm: unexport ksize
      V4L/DVB (8562): DVB_DRX397XD: remove FW_LOADER select
      V4L/DVB (8563): fix drivers/media/video/arv.c compilation
      xen-blkfront.c: make blkif_ioctl() static
      remove bogus CONFIG_GFAR_NAPI's
      ath9k: work around gcc ICEs
      [ARM] 5177/1: arm/mach-sa1100/Makefile: remove CONFIG_SA1100_USB
      [NFSD] uninline nfsd4_op_name()
      uninline atl1e_setup_mac_ctrl()
      [WATCHDOG] MAINTAINERS: remove ZF MACHZ WATCHDOG entry
      [WATCHDOG] fix watchdog/txx9wdt.c compilation
      [WATCHDOG] fix watchdog/shwdt.c compilation
      [WATCHDOG] fix watchdog/at91rm9200_wdt.c compilation
      [WATCHDOG] fix watchdog/wdt285.c compilation
      [WATCHDOG] fix watchdog/ixp4xx_wdt.c compilation
      make struct scsi_dh_devlist's static
      [IA64] use bcd2bin/bin2bcd
      feature-removal-schedule.txt: remove the NCR53C9x entry

Alan Cox (59):
      [WATCHDOG 01/57] Clean acquirewdt and check for BKL dependancies
      [WATCHDOG 02/57] clean up and check advantech watchdog
      [WATCHDOG 03/57] ali: watchdog locking and style
      [WATCHDOG 04/57] AR7 watchdog
      [WATCHDOG 05/57] atp watchdog
      [WATCHDOG 06/57] at91: watchdog to unlocked_ioctl
      [WATCHDOG 07/57] cpu5_wdt: switch to unlocked_ioctl
      [WATCHDOG 08/57] davinci_wdt: unlocked_ioctl and check locking
      [WATCHDOG 09/57] ep93xx_wdt: unlocked_ioctl
      [WATCHDOG 10/57] eurotechwdt: unlocked_ioctl, code lock check and tidy
      [WATCHDOG 11/57] hpwdt: couple of include cleanups
      [WATCHDOG 12/57] ib700wdt: clean up and switch to unlocked_ioctl
      [WATCHDOG 13/57] i6300esb: Style, unlocked_ioctl, cleanup
      [WATCHDOG 14/57] ibmasr: coding style, locking verify
      [WATCHDOG 15/57] indydog: Clean up and tidy
      [WATCHDOG 16/57] iop: watchdog switch to unlocked_ioctl
      [WATCHDOG 17/57] it8712f: unlocked_ioctl
      [WATCHDOG 18/57] iTCO: unlocked_ioctl, coding style and cleanup
      [WATCHDOG 19/57] bfin: watchdog cleanup and unlocked_ioctl
      [WATCHDOG 20/57] booke watchdog: clean up and unlocked_ioctl
      [WATCHDOG 21/57] ixp2000_wdt: clean up and unlocked_ioctl
      [WATCHDOG 22/57] ixp4xx_wdt: unlocked_ioctl
      [WATCHDOG 23/57] ks8695_wdt: clean up, coding style, unlocked_ioctl
      [WATCHDOG 24/57] machzwd: clean up, coding style, unlocked_ioctl
      [WATCHDOG 25/57] mixcomwd: coding style locking, unlocked_ioctl
      [WATCHDOG 26/57] mpc watchdog: clean up and locking
      [WATCHDOG 27/57] mpcore watchdog: unlocked_ioctl and BKl work
      [WATCHDOG 28/57] mtx-1_wdt: clean up, coding style, unlocked ioctl
      [WATCHDOG 29/57] mv64x60_wdt: clean up and locking checks
      [WATCHDOG 30/57] omap_wdt: locking, unlocked_ioctl, tidy
      [WATCHDOG 31/57] pc87413_wdt: clean up, coding style, unlocked_ioctl
      [WATCHDOG 32/57] pcwd: clean up, unlocked_ioctl usage
      [WATCHDOG 33/57] pnx4008_wdt: unlocked_ioctl setup
      [WATCHDOG 34/57] rm9k_wdt: clean up
      [WATCHDOG 35/57] s3c2410: watchdog cleanup and switch to unlocked_ioctl
      [WATCHDOG 36/57] sa1100_wdt: Switch to unlocked_ioctl
      [WATCHDOG 37/57] sbc60xxwdt: clean up and switch to unlocked_ioctl
      [WATCHDOG 38/57] stg7240_wdt: unlocked_ioctl
      [WATCHDOG 39/57] sbc8360: clean up
      [WATCHDOG 40/57] sbc_epx_c3_wdt: switch to unlocked_ioctl
      [WATCHDOG 41/57] sb_wdog: Clean up and switch to unlocked_ioctl
      [WATCHDOG 42/57] sc1200_wdt: clean up, fix locking and use unlocked_ioctl
      [WATCHDOG 43/57] sc520_wdt: Clean up and switch to unlocked_ioctl
      [WATCHDOG 44/57] scx200_wdt: clean up and switch to unlocked_ioctl
      [WATCHDOG 45/57] shwdt: coding style, cleanup, switch to unlocked_ioctl
      [WATCHDOG 46/57] smsc37b787_wdt: coding style, switch to unlocked_ioctl
      [WATCHDOG 47/57] softdog: clean up, coding style and switch to unlocked_ioctl
      [WATCHDOG 48/57] txx9: Fix locking, switch to unlocked_ioctl
      [WATCHDOG 49/57] w83627hf: coding style, clean up and switch to unlocked_ioctl
      [WATCHDOG 50/57] w83697hf_wdt: cleanup, coding style and switch to unlocked_ioctl
      [WATCHDOG 51/57] w83877f_wdt: clean up code, coding style, switch to unlocked_ioctl
      [WATCHDOG 52/57] w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
      [WATCHDOG 53/57] wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
      [WATCHDOG 54/57] wdrtas: clean up, coding style, switch to unlocked_ioctl
      [WATCHDOG 55/57] wdt285: switch to unlocked_ioctl and tidy up oddments of coding style
      [WATCHDOG 56/57] wdt977: clean up, coding style and switch to unlocked_ioctl
      [WATCHDOG 57/57] wdt501/pci: Clean up, coding style and switch to unlocked_ioctl
      [WATCHDOG] pcwd: a couple of watchdogs escaped conversion
      Remove bogons from the iSeries console

Alessandro Zummo (1):
      rtc-isl1208: fix double removal of a sysfs entry

Alex Naslednikov (1):
      IB/mlx4: Allow 4K messages for UD QPs

Alexander Beregalov (2):
      IB/ipath: Fix printk format warnings
      sparc: i8042-sparcio.h: fix warning

Alexander Clouter (1):
      ALi M7101 PMU also available on Sun Netra's too

Alexander Duyck (6):
      igb: fix comments
      igb: fix null pointer dereference seen with fiber NICs
      igb: fixes 82576 serdes init to correctly support manual flow control changes
      igb: correct issue of set_mta member of mac.ops not being populated
      igb: remove three redundant functions left in the code
      igb: remove igb_init_managability as it is deprecated

Alexander Schmidt (5):
      IB/ehca: Update qp_state on cached modify_qp()
      IB/ehca: Rename goto label in ehca_poll_cq_one()
      IB/ehca: Repoll CQ on invalid opcode
      IB/ehca: Check idr_find() return value
      IB/ehca: Discard double CQE for one WR

Alexey Dobriyan (2):
      seq_file: add seq_cpumask(), seq_nodemask()
      genirq: switch /proc/irq/*/smp_affinity et al to seqfiles

Alok Kataria (1):
      x86: Fix broken VMI in 2.6.27-rc..

Andrew Morton (3):
      drivers/net/netxen/netxen_nic_hw.c: fix printk warnings
      PCI: make pci_register_driver() a macro
      fs/eventpoll.c: fix sys_epoll_create1() comment

Andrew Paprocki (2):
      hwmon: (it87) Support for 16-bit fan reading in it8712 >= rev 0x07
      hwmon: (it87) Support for 16-bit fan reading in it8705 >= rev 0x03

Andy Whitcroft (2):
      hugetlbfs: allocate structures for reservation tracking outside of spinlocks
      allocate structures for reservation tracking in hugetlbfs outside of spinlocks v2

Anton Vorontsov (6):
      [WATCHDOG] mpc83xx_wdt: convert to the OF platform driver
      [WATCHDOG] mpc83xx_wdt: add support for MPC86xx CPUs
      [WATCHDOG] mpc83xx_wdt: rename to mpc8xxx_wdt
      [WATCHDOG] mpc8xxx_wdt: various renames, mostly s/mpc83xx/mpc8xxx/g
      [WATCHDOG] mpc8xxx_wdt: fix build
      [WATCHDOG] mpc8xxx_wdt: add support for MPC8xx watchdogs

Arjan van de Ven (1):
      modules: extend initcall_debug functionality to the module loader

Auke Kok (1):
      e1000e: perform basic 82573 EEPROM checks for known issues

Ayaz Abdulla (4):
      forcedeth: fix rx error policy
      forcedeth: add new tx stat counters
      forcedeth: add jumbo frame support for mcp79
      forcedeth: add tx pause limit

Ben Collins (1):
      pegasus: add blacklist support to fix Belkin bluetooth dongle.

Benjamin Herrenschmidt (2):
      powerpc/pci: Don't keep ISA memory hole resources in the tree
      powerpc/mm: Fix attribute confusion with htab_bolt_mapping()

Bernhard Walle (1):
      firmware/memmap: cleanup

Bjorn Helgaas (2):
      amd64-agp: run fallback when no bridges found, not when driver registration fails
      agp: use dev_printk when possible

Brandon Philips (1):
      ethtool: Expand ethtool_cmd.speed to 32 bits

Brice Goglin (2):
      myri10ge: update firmware headers
      myri10ge: set 64bits consistent DMA mask

Bruce Allan (1):
      e1000e: remove inapplicable test for ioport

Christian Borntraeger (3):
      Fix race/oops in tty layer after BKL pushdown
      export virtio_rng.h
      fix spinlock recursion in hvc_console

Christian Lamparter (1):
      p54: swap short slot time dcf values

Dan Williams (1):
      async_tx: fix missing braces in async_xor_zero_sum

Dave Jones (5):
      [CPUFREQ] Remove EXPERIMENTAL annotation from VIA C7 powersaver kconfig.
      [CPUFREQ] Fix -Wshadow warning in conservative governor.
      [CPUFREQ] Fix warning in elanfreq
      [CPUFREQ] Update MAINTAINERS to reflect new mailing list.
      lockdep: shrink held_lock structure

David Brownell (2):
      i2c: correct some size_t printk formats
      revert "rtc: cdev lock_kernel() pushdown"

David J. Wilder (1):
      IPoIB/cm: Use vmalloc() to allocate rx_rings

David Miller (3):
      lockdep: fix combinatorial explosion in lock subgraph traversal
      debug_locks: set oops_in_progress if we will log messages.
      radeonfb: fix accel engine hangs

David Moore (1):
      firewire: Preserve response data alignment bug when it is harmless

David S. Miller (5):
      ipv4: Fix over-ifdeffing of ip_static_sysctl_init.
      sparc64: Use kernel/uid16.c helpers instead of own copy.
      pkt_sched: Fix "parent is root" test in qdisc_create().
      pkt_sched: Fix qdisc config when link is down.
      sparc64: Fix end-of-stack checking in save_stack_trace().

Dean Hildebrand (1):
      PCI: Limit VPD length for Broadcom 5708S

Denis ChengRq (2):
      bio: make use of bvec_nr_vecs
      kbuild: a better way to generate cscope database change

Dhananjay Phadke (5):
      netxen: fix link status, link speed
      netxen: add new board types
      netxen: fix legacy interrupts
      netxen: fix cmd ring init
      netxen: fix promisc mode, mtu setting

Dmitry Adamushko (1):
      sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks

Dmitry Baryshkov (4):
      DMA: make dma-coherent.c documentation kdoc-friendly
      ALSA: wm8750: it's MONO1, not MONO
      ALSA: spitz: MONO -> MONO1
      ALSA: wm8750: add missing VREF output

Dominik Geyer (1):
      hwmon: (w83627hf) Add pwm_enable sysfs interface

Eduardo Habkost (1):
      xen-netfront: use netif_start_queue() on xennet_open()

Eric Dumazet (1):
      PCI: add Broadcom 5708S to VPD length quirk

Eric Miao (3):
      [ARM] pxa: introduce reset.h for reset specific header information
      [ARM] pxa: introduce reset_status and clear_reset_status for driver's usage
      [ARM] sa1100_wdt: use reset_status to remember watchdog reset status

Eric W. Biederman (2):
      x86: Restore proper vector locking during cpu hotplug
      x86_64: restore the proper NR_IRQS define so larger systems work.

Erkki Lintunen (1):
      bugfix for scripts/patch-kernel in 2.6 sublevel stepping

Eugene Teo (1):
      hamradio: add missing sanity check to tty operation

Eugeniy Meshcheryakov (1):
      V4L/DVB (8582): set mts_firmware for em2882 based Pinnacle Hybrid Pro

Francois Romieu (2):
      via-velocity: separated struct allow wholesale copy during MTU changes.
      via-velocity: velocity_init_{rd/tx}_ring use kcalloc(..., GFP_KERNEL).

Frank Myhr (2):
      hwmon: (hwmon-vid) Trivial format multi-line comments per CodingStyle
      hwmon: (hwmon-vid) Add 6-bit vid codes for AMD NPT 0Fh cpus

Geert Uytterhoeven (2):
      m68k/amiserial: fix fallout of tty break handling rework
      m68k{,nommu}: Wire up new system calls

Gerald Schaefer (1):
      hugetlb: call arch_prepare_hugepage() for surplus pages

Grant Coady (1):
      hwmon: (adm9240) Remove EXPERIMENTAL dependency

Greg Ungerer (1):
      Move all of include/asm-m68knommu to arch/m68knommu/include/asm.

Gui Jianfeng (1):
      tcp: Fix kernel panic when calling tcp_v(4/6)_md5_do_lookup

Gustavo F. Padovan (3):
      drivers/net: Remove 'return' of void function NS8390p_init()
      drivers/net: coding styles fixes to drivers/net/8390p.c
      drivers/net: coding styles fixes to drivers/net/8390.c

Haavard Skinnemoen (12):
      avr32: Move include/asm-avr32 to arch/avr32/include/asm
      avr32: Introduce arch/avr32/mach-*/include/mach
      avr32: Use <mach/foo.h> instead of <asm/arch/foo.h>
      avr32: Remove include/asm-avr32/arch-at32ap
      avr32: Introduce <mach/chip.h>
      avr32: Add MMIO address definitions for certain controllers
      avr32: Clean up HMATRIX code
      avr32: Update defconfigs
      avr32: Reduce DataFlash bus speed to 8 MHz on ATNGW100
      avr32: Make atstk1006_nand_data definition static
      atmel_lcdfb: set ypanstep to 1 and enable y-panning on AT91
      atmel_lcdfb: add board parameter specify framebuffer memory size

Hans Verkuil (1):
      i2c: Fix NULL pointer dereference in i2c_new_probed_device

Harvey Harrison (3):
      lockd: trivial sparse endian annotations
      byteorder: add a new include/linux/swab.h to define byteswapping functions
      byteorder: add include/linux/byteorder.h to define endian helpers

Heiko Carstens (1):
      cpu hotplug: s390 doesn't support additional_cpus anymore.

Huang Weiyi (3):
      mm/sparse.c: removed duplicated include
      drivers/char/rtc.c: removed duplicated include
      reiserfs: removed duplicated #include

Hugh Dickins (2):
      sched: move sched_clock before first use
      memcg: fix oops in mem_cgroup_shrink_usage

Ian Molton (8):
      mfd: TMIO MMC structures and accessors.
      mfd: driver for the T7L66XB TMIO SoC
      mfd: driver for the TC6387XB TMIO controller.
      mfd: tc6387 MMC platform data
      mfd: t7l66 MMC platform data
      mfd: driver for the TMIO NAND controller
      mfd: TMIO MMC driver
      mfd: tc6393 cleanup and update

Ingo Molnar (7):
      sched clock: revert various sched_clock() changes
      sched clock: clean up sched_clock_cpu()
      sched: eliminate scd->prev_raw
      sched clock: simplify __update_sched_clock()
      sched clock: couple local and remote clocks
      lockdep: rename map_[acquire|release]() => lock_map_[acquire|release]()
      lockdep: increase MAX_LOCKDEP_KEYS

Isaku Yamahata (1):
      [IA64] pv_ops: fix ivt.S paravirtualization

Ivo van Doorn (1):
      rt2x00: Block all unsupported modes

J. Bruce Fields (1):
      MAINTAINERS: mention lockd and sunrpc in nfs entries

Jack Steiner (1):
      [IA64] Eliminate trailing backquote in IA64_SGI_UV

Jamal Hadi Salim (1):
      pkt_sched: Fix actions referencing

Jan Beulich (1):
      page allocator: use no-panic variant of alloc_bootmem() in alloc_large_system_hash()

Jan Kara (1):
      quota: documentation for sending "below quota" messages via netlink and tiny doc update

Jay Cliburn (1):
      atl1: deal with hardware rx checksum bug

Jay Vosburgh (1):
      bonding: refactor mii monitor

Jean Delvare (10):
      hwmon: (f71882fg) Delete needless forward declarations
      hwmon: (w83627hf) Drop reset module parameter
      [WATCHDOG] Fix build with CONFIG_ITCO_VENDOR_SUPPORT=n
      i2c: Fix oops on bus multiplexer driver loading
      i2c: Let users select algorithm drivers manually again
      i2c: Check for address business before creating clients
      hwmon: (lm75) Drop legacy i2c driver
      matrox maven: fix a broken error path
      matroxfb: i2c structure templates clean-up
      matrox maven: convert to a new-style i2c driver

Jean-Francois Moine (10):
      V4L/DVB (8550): gspca: Change a bit the init of ov7660 and Sonix JPEG bridges.
      V4L/DVB (8552): gspca: Bad pixel format in the spca508 subdriver.
      V4L/DVB (8567): gspca: hflip and vflip controls added for ov519 - ov7670 plus init cleanup.
      V4L/DVB (8569): gspca: Set back the old values of Sonix sn9c120 and cleanup source.
      V4L/DVB (8571): gspca: Don't use CONFIG_VIDEO_ADV_DEBUG as a compile option.
      V4L/DVB (8572): gspca: Webcam 0c45:6143 in documentation.
      V4L/DVB (8573): gspca: Bad scan of frame in spca505/506/508.
      V4L/DVB (8574): gspca: Bad bytesperlines of pixelformat in spca505/506/508 and vc023x.
      V4L/DVB (8602): gspca: Fix small bugs, simplify and cleanup ov519.
      V4L/DVB (8604): gspca: Fix of "scheduling while atomic" crash.

Jeff Kirsher (1):
      e1000e: convert ndev_ printks to something smaller

Jeff Layton (10):
      [CIFS] remove level of indentation from decode_negTokenInit
      [CIFS] properly account for new user= field in SPNEGO upcall string allocation
      remove locking around tcpSesAllocCount atomic variable
      bundle up Unix SET_PATH_INFO args into a struct and change name
      change CIFSSMBSetTimes to CIFSSMBSetPathInfo
      Rename CIFSSMBSetFileTimes to CIFSSMBSetFileInfo and add PID arg
      [CIFS] cifs_mkdir and cifs_create should respect the setgid bit on parent dir
      spin off cifs_setattr with unix extensions to its own function
      move file time and dos attribute setting logic into new function
      turn cifs_setattr into a multiplexor that calls the correct function

Jeremy Fitzhardinge (1):
      x86: work around gcc 3.4.x bug

Jesse Barnes (1):
      PCI: fully restore MSI state at resume time

Jesse Brandeburg (1):
      e1000e: fix drv load issues

Joakim Koskela (2):
      ipsec: Interfamily IPSec BEET
      ipsec: Interfamily IPSec BEET, ipv4-inner ipv6-outer

Joe Eykholt (3):
      net/core: Uninline skb_bond().
      net/core: Allow certain receives on inactive slave.
      net/core: Allow receive on active slaves.

Jonathan Cameron (1):
      [ARM] 5185/1: Fix spi num_chipselect for lubbock

Josh Boyer (1):
      powerpc/4xx: Update defconfig files for 2.6.27-rc1

Juerg Haefliger (3):
      hwmon: (dme1737) Cleanups
      hwmon: (dme1737) Skip detection if forced
      hwmon: (dme1737) Add support for the SMSC SCH5027

Julia Lawall (1):
      fs/nfsd/export.c: Adjust error handling code involving auth_domain_put

Julien Brunel (1):
      IB/mad: Test ib_create_send_mad() return with IS_ERR(), not == NULL

Junio C Hamano (2):
      powerpc: Do not ignore arch/powerpc/include
      powerpc: Do not ignore arch/powerpc/include

Keith Packard (1):
      intel/agp: rewrite GTT on resume

Krzysztof Halasa (1):
      WAN: remove extra help text from HDLC_PPP config option

Krzysztof Ha³asa (15):
      WAN: cosmetic changes to generic HDLC
      Remove bogus dosyncppp variable from synclink drivers.
      Remove bogus variables from syncppp.[ch]
      Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
      wanmain.c doesn't need syncppp.h
      WAN: Remove unneeded "#include <net/syncppp.h>"
      WAN: Remove dead code from PC300 driver, part #1
      WAN: Remove dead code from PC300 driver, part #2
      WAN: Convert PC300 driver to use normal u8/u16/u32 types
      WAN: farsync driver no longer uses syncppp.c directly
      WAN: Port COSA driver to generic HDLC.
      WAN: Convert Zilog-based drivers to generic HDLC
      WAN: Port LMC driver to generic HDLC
      WAN: don't mention syncppp in z8530 DocBook.
      WAN: Use u32 type instead of u_int32_t in LMC driver.

Krzysztof Helt (4):
      x86: fdiv bug detection fix
      hwmon: (thmc50) Add support for critical temperature limits
      agp: fix SIS 5591/5592 wrong PCI id
      fbcon: prevent cursor disappearance after switching to 512 character font

Krzysztof Piotr Oledzki (1):
      netfilter: fix two recent sysctl problems

Larry Finger (1):
      p54: Fix for TX sequence number problem

Laurent Pinchart (3):
      V4L/DVB (8616): uvcvideo: Add support for two Bison Electronics webcams
      V4L/DVB (8617): uvcvideo: don't use stack-based buffers for USB transfers.
      dm9000: Support MAC address setting through platform data.

Li Yang (1):
      net/fs_enet: remove redundant messages for performance

Li Zefan (1):
      stop_machine: remove unused variable

Libin Yang (1):
      ALSA: hda - support new AMD HDMI Audio (1002:970f)

Linus Torvalds (7):
      Revert duplicate "mm/hugetlb.c must #include <asm/io.h>"
      pcm_native.c: remove unused label
      iSeries: Fix up viotty_ioctl BKL locking fallout
      Revert "pcm_native.c: remove unused label"
      Fix up duplicate '__s3c2410wdt_stop()' function
      Revert "fbcon: bgcolor fix"
      Linux 2.6.27-rc3

Luis Carlos Cobo (2):
      mac80211: fix use of skb->cb for mesh forwarding
      mac80211: keep mesh ifaces in allmulti mode

Luis R. Rodriguez (4):
      list.h: Add list_splice_tail() and list_splice_tail_init()
      list.h: add list_cut_position()
      ath5k: remove Atheros 11n devices from supported list
      ath9k: Add new Atheros IEEE 802.11n driver

Marc Hulsman (1):
      hwmon: (w83791d) Use fan divisor bits from vbat register

Marcel Holtmann (3):
      [Bluetooth] Add parameters to control BNEP header compression
      [Bluetooth] Removal of unnecessary ignore module parameter
      [Bluetooth] Add full quirk implementation for btusb driver

Mark Langsdorf (2):
      [CPUFREQ][1/2] whitespace fix for powernow-k8
      [CPUFREQ][2/2] preregister support for powernow-k8

Mauro Carvalho Chehab (1):
      V4L/DVB (8558): media/video/Kconfig: fix a typo

Michael Abbott (1):
      Make ioctl.h compatible with userland

Mike Galbraith (1):
      sched: fix mysql+oltp regression

Mike Miller (6):
      cciss: make rebuild_lun_table behave better
      cciss: remove redundant code
      cciss: fix negative logical drive count in procfs
      cciss: change the way we notify scsi midlayer of tape drives
      cciss: add support for multi lun tape devices
      cciss: fix bug if scsi tape support is disabled

MinChan Kim (1):
      do_migrate_pages(): remove unused variable

Moni Shoua (1):
      bonding: Don't destroy bonding master when removing slave via sysfs

Nathan Fontenot (1):
      powerpc: Zero fill the return values of rtas argument buffer

Nick Piggin (2):
      generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask()
      generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask(), fix

Nikanth Karthikesan (1):
      cciss: return -EFAULT if copy_from_user() fails

OGAWA Hirofumi (1):
      sched: fix SCHED_HRTICK dependency

Oleg Nesterov (2):
      posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
      posix-timers: fix posix_timer_event() vs dequeue_signal() race

Parag Warudkar (1):
      isight_firmware: fix a leak and double kfree()

Paul Mackerras (1):
      powerpc: Remove include/linux/harrier_defs.h

Paul Mundt (1):
      V4L/DVB (8609): media: Clean up platform_driver_unregister() bogosity.

Pekka Enberg (1):
      SLUB: dynamic per-cache MIN_PARTIAL

Peter Zijlstra (12):
      sched: fix warning in hrtick_start_fair()
      lockdep: change scheduler annotation
      sched_clock: delay using sched_clock()
      lockdep: lock_set_subclass - reset a held lock's subclass
      lockdep: re-annotate scheduler runqueues
      lockdep: map_acquire
      lockdep: lock protection locks
      lockdep: spin_lock_nest_lock()
      lockdep: annotate mm_take_all_locks()
      mm: fix mm_take_all_locks() locking order
      lockdep: fix overflow in the hlock shrinkage code
      lockdep: fix debug_lock_alloc

Philipp Zabel (1):
      [ARM] 5166/1: magician: add MAINTAINERS entry

Rabin Vincent (3):
      V4L/DVB (8605): gspca: Fix of gspca_zc3xx oops - 2.6.27-rc1
      lockdep: handle chains involving classes defined in modules
      cpuidle: make sysfs attributes sysdev class attributes

Rafael J. Wysocki (1):
      PCI PM: Export pci_pme_active to drivers

Rami Rosen (2):
      ipv4: replace dst_metric() with dst_mtu() in net/ipv4/route.c.
      ipv6: replace dst_metric() with dst_mtu() in net/ipv6/route.c.

Randy Dunlap (12):
      V4L/DVB (8549a): fix kernel-doc warning, function name, and docbook filename
      docbook: fix v4l fatal filename error
      bnx2x: fix logical op
      list.h: fix fatal kernel-doc error
      x86, pci-calgary: fix function declaration
      EFI, x86: fix function prototype
      GRU: fix preprocessor symbol for sparse
      docsrc: build Documentation/ sources
      docsrc: fix procfs example
      docsrc: fix ifenslave type
      docsrc: fix crc32hash type
      docsrc: fix getdelays printk formats

Rene Herman (3):
      x86, debug: tone down arch/x86/kernel/mpparse.c debugging printk
      x86: make "apic" an early_param() on 32-bit
      x86: make "apic" an early_param() on 32-bit, NULL check

Robert Jarzmik (2):
      V4L/DVB (8610): Add suspend/resume capabilities to soc_camera.
      V4L/DVB (8611): Add suspend/resume to pxa_camera driver

Robert Lowery (1):
      V4L/DVB (8607): cxusb: fix OOPS and broken tuning regression on FusionHDTV Dual Digital 4

Robert Olsson (1):
      pktgen: multiqueue etc.

Robert P. J. Day (2):
      Kconfig: Extend "menuconfig" for modules to simplify Kconfig file
      powerpc: Delete completed "ppc removal" task from feature removal file

Robin Holt (4):
      [IA64] Cleanup generated file not ignored by .gitignore
      [IA64] Allow ia64 to CONFIG_NR_CPUS up to 4096
      [IA64] update generic_defconfig for 2.6.27-rc1
      [IA64] update generic_defconfig to support sn2.

Roland Dreier (2):
      IPoIB/cm: Set correct SG list in ipoib_cm_init_rx_wr()
      RDMA/cma: Remove padding arrays by using struct sockaddr_storage

Roland McGrath (1):
      tracehook: fix CLONE_PTRACE

Ron Mercer (4):
      qla3xxx: fix: Remove unused set_multicast function.
      qla3xxx: fix: Fix IFF_MULTICAST setting.
      qla3xxx: cleanup: Remove some unused defined constants in the header file.
      qla3xxx: cleanup: Remove some unused structure definitions and structure elements.

Russell King (7):
      [ARM] Fix circular include dependency with IRQ headers
      [ARM] Eliminate useless includes of asm/mach-types.h
      [ARM] Remove asm/hardware.h, use asm/arch/hardware.h instead
      [ARM] Add support for arch/arm/mach-*/include and arch/arm/plat-*/include
      [ARM] Move include/asm-arm/arch-* to arch/arm/*/include/mach
      [ARM] Fix SMP booting with non-zero PHYS_OFFSET
      [ARM] fix pnx4008 build errors

Rusty Russell (3):
      lguest: don't set MAC address for guest unless specified
      mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
      lguest: use get_user_pages_fast() instead of get_user_pages()

Sam Ravnborg (1):
      kbuild: fix O=.. build with arm

Samuel Ortiz (3):
      mfd: Fix tc6393 according to the new tmio.h
      mfd: Fix 7l66 and 6387 according to the new mfd-core API
      mfd: have TMIO drivers and subdevices depend on ARM

Sean MacLennan (4):
      powerpc/4xx: Cleanup Warp for i2c driver changes.
      powerpc/44x: Warp DTS changes for board updates
      powerpc/44x: Incorrect NOR offset in Warp DTS
      hwmon: ad7414 driver

Seth Heasley (1):
      ALSA: hda_intel: ALSA HD Audio patch for Intel Ibex Peak DeviceIDs

Shirish Pargaonkar (1):
      [CIFS] cifs send2 not retrying enough in some cases on full socket

Simon Horman (1):
      PCI: check the return value of device_create_bin_file() in pci_create_bus()

Stephen Hemminger (2):
      sky2: fix PM related regressions
      3c59x: use netdev_alloc_skb

Stephen Rothwell (3):
      of/sparc: remove include of linux/of_platform.h from asm/of_platform.h
      sparc: don't use asm/of_device.h
      powerpc/iseries: remove the old viocons driver

Steve French (4):
      [CIFS] oid should also be checked against class in cifs asn
      [CIFS] fix trailing whitespace
      [CIFS] Code cleanup in old sessionsetup code
      [CIFS] list entry can not return null

Steve Wise (3):
      RDMA/cxgb3: Fix QP capabilities
      RDMA/cxgb3: Fix up MW access rights
      RDMA/cxgb3: Fix deadlock initializing iw_cxgb3 device

Sujith (6):
      ath9k: Cleanup data structures related to HW capabilities
      ath9k: Remove redundant data structure ath9k_txq_info
      ath9k: Use mac80211's band macros and remove enum hal_freq_band
      ath9k: Remove a few unused macros and fix indentation
      ath9k: More unused macros
      ath9k: Revamp wireless mode usage

Suresh Jayaraman (1):
      Fix missing braces in cifs_revalidate()

Thomas Bogendoerfer (1):
      METH: fix MAC address setup

Timur Tabi (1):
      ALSA: ASoC: fix SNDCTL_DSP_SYNC support in Freescale 8610 sound drivers

Tomas Winkler (1):
      iwlwifi: cleanup iwl_tx_skb

Tony Luck (3):
      [IA64] Fix uniprocessor build w.r.t. SGI_XP and SGI_GRU
      [IA64] Update generic config
      [IA64] Ensure cpu0 can access per-cpu variables in early boot code

Uwe Kleine-König (1):
      move kernel-doc comment for might_sleep directly before its defining block

Valentine Barshak (1):
      powerpc/44x: Adjust warp-nand resource end address

Vegard Nossum (1):
      IB/ipath: Use unsigned long for irq flags

Wang Chen (1):
      [netdrvr] Drivers should not set IFF_* flag themselves

Wim Van Sebroeck (7):
      [WATCHDOG] hpwdt.c - fix double includes
      [WATCHDOG] Clean-up includes
      [WATCHDOG] Coding style - Indentation - part 1
      [WATCHDOG] Coding style - Indentation - part 2
      [WATCHDOG] sbc8360.c - move stop code into a function
      [WATCHDOG] more coding style clean-up's
      [WATCHDOG] pcwd.c - fix open_allowed type.

Yevgeny Petrilin (1):
      mlx4_core: Add ethernet fields to CQE struct

Yi Yang (1):
      lib/vsprintf.c: wrong conversion function used

Yinghai Lu (1):
      x86: fix 2.6.27rc1 cannot boot more than 8CPUs

Yoichi Yuasa (1):
      V4L/DVB (8564): fix vino driver build error

Yoshinori Sato (2):
      [netdrvr] sh_eth: Add SH7619 support
      h8300: fix section mismatches

Zhenyu Wang (1):
      intel_agp: official name for GM45 chipset

akpm@linux-foundation.org (1):
      PCI: remove duplicate symbol from pci_ids.h

roel kluin (1):
      sched: test runtime rather than period in global_rt_runtime()

root (1):
      qla3xxx: driver version change.

