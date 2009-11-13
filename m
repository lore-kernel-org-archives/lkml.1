Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZKMA55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZKMA55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZKMA54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:57:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbZKMA5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:57:53 -0500
Date: Thu, 12 Nov 2009 16:57:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc7
Message-ID: <alpine.LFD.2.01.0911121649241.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another rc.

This time I held off the -rc for fear of an ugly-looking resume regression 
that Rafael had been looking at, but instead of being something nasty and 
fundamental, it turned out to be a trivial driver bug (where "trivial" 
here means "nasty and hard to figure out, but not some fundamental code 
breakage")

So that's fixed, along with a number of other small regressions. Most of 
the commits are the kinds I like at this stage: one-liners and few-liners, 
but I have to admit that there's some bigger-than-I-would-have-liked 
patches to the Radeon KMS driver. Hopefully it's nearing stability now.

Apart from the Radeon thing (and some powerpc defconfig updates), the rest 
really is just a lot of small stuff, spread all over. Mostly in drivers, 
but there's a sprinking of arch updates (arm, m32r), some filesystem 
updates (btrfs, ext3, ext4, cifs, nilfs) etc.

		Linus
---
Ajit Khaparde (2):
      be2net: fix to set proper flow control on resume
      be2net: Bug fix to send config commands to hardware after netdev_register

Alberto Bertogli (2):
      bio_put(): add bio_clone() to the list of functions in the comment
      Fix bio_alloc() and bio_kmalloc() documentation

Alex Deucher (32):
      drm/radeon/kms: make sure LVDS panel is valid in detect()
      drm/radeon/kms/atom: reorder crtc dpms
      drm/radeon/kms/atom: add support for AdjustDisplayPll
      drm/radeon/kms/atom: rework crtc modeset
      drm/radeon/kms: use drm_mode directly for panel modes
      drm/radeon/kms: also check for edid in lvds detect
      drm/radeon/kms: properly handle mode id with native mode changes
      drm/radeon/kms: move active_device setup into encoder fixup()
      drm/radeon/kms: fix internal tmds setup on legacy display engine
      drm/radeon/kms: fix connector edid handling
      drm/radeon/kms/atom: fix tv-out
      drm/radeon/kms: limit default tv modes to <= 1024x768
      drm/radeon/kms: fix legacy quirk handling
      drm/radeon/kms: fix support for original r100
      drm/radeon/kms: fix vram_width calculation on r6xx/r7xx
      drm/radeon/kms: add quirk for acer 5102
      drm/radeon/kms/r7xx: add regs for 40 bit CUR/GRPH addresses
      drm/radeon/kms/atom: add support for spread spectrum (v2)
      drm/radeon/kms: add support for msi
      drm/radeon/kms/atom: loosen pll min output limits
      drm/radeon/kms/atom: Fix DVO support
      drm/radeon/kms/atom: fix potential oops in spread spectrum code
      drm/radeon/kms: add quirk for hp dc5750
      drm/radeon/kms: Don't RMW CP_RB_CNTL
      drm/radeon/kms: remove some misleading debugging output
      drm/radeon/kms/r700: fix some typos in chip init
      drm/radeon/kms/r600: fix rs880 support v2
      drm/radeon/kms/atom/dce3: fix up usPixelClock calculation for Transmitter tables
      drm/radeon/kms: store detailed connector info
      drm/radeon/kms/atom/dce3: call transmitter init on mode set
      drm/radeon/kms: initial mode validation support
      drm/radeon/r600: CS parser updates

Amit Kucheria (1):
      acpi: thermal: Add EOL to the trip_point_N_type strings

Anand V. Avati (1):
      fuse: prevent fuse_put_request on invalid pointer

Andre Detsch (1):
      powerpc/pci: Fix regression in powerpc MSI-X

Andrew Morton (1):
      alpha: move THREAD_SIZE definition outside #ifndef ASSEMBLY

Andy Lutomirski (1):
      drm/i915: Fix render reclock availability detection.

Aneesh Kumar K.V (1):
      ext4: discard preallocation when restarting a transaction during truncate

Anton Blanchard (1):
      exec: setup_arg_pages() fails to return errors

Anton Vorontsov (2):
      powerpc/85xx: Fix USB GPIOs for MPC8569E-MDS boards
      powerpc/83xx: Fix u-boot partion size for MPC8377E-WLAN boards

Arjan van de Ven (1):
      ACPI: clean up video.c boundary checks and types

Atsushi Nemoto (1):
      mtd/maps: Fix accidental removal in Makefile

Ben Dooks (1):
      ARM: S3C64XX: Tidy definition and comments in s3c_dma_has_circular()

Ben Hutchings (1):
      ALSA: snd-aica: declare MODULE_FIRMWARE

Benjamin Herrenschmidt (4):
      powerpc: Cleanup Kconfig selection of hugetlbfs support
      powerpc/mm: Remove debug context clamping from nohash code
      powerpc: Avoid giving out RTC dates below EPOCH
      powerpc/kvm: Remove problematic BUILD_BUG_ON statement

Bob Moore (1):
      ACPICA: avoid "Info: mapping multiple BARs. Your kernel is fine."

Borislav Petkov (2):
      amd64_edac: fix CECCs reporting
      x86, amd-ucode: Check UCODE_MAGIC before loading the container file

Catalin Marinas (3):
      Check whether the SCU was already initialised
      RealView: Add default memory configuration
      RealView: Add sparsemem support for the RealView PBX platform

Chris Lalancette (1):
      x86: Make sure get_user_desc() doesn't sign extend.

Chris Mason (1):
      Btrfs: allow more metadata chunk preallocation

Chris Wilson (1):
      drm/i915: Install a fence register for fbc on g4x

Clemens Ladisch (3):
      sound: rawmidi: fix double init when opening MIDI device with O_APPEND
      sound: rawmidi: fix checking of O_APPEND when opening MIDI device
      sound: rawmidi: fix MIDI device O_APPEND error handling

Colin Tuckley (1):
      RealView: Remove duplicated #define REALVIEW_SYS_FLAGS* statements

Corentin Chary (1):
      Revert "eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated"

Crane Cai (1):
      i2c-piix4: Modify code name SB900 to Hudson-2

Cyrill Gorcunov (1):
      sched: Use root_task_group_empty only with FAIR_GROUP_SCHED

Dan Carpenter (2):
      misdn: Fix reversed 'if' in st_own_ctrl
      Btrfs: avoid null deref in unpin_extent_cache()

Daniel Drake (2):
      ALSA: hda - Add OLPC XO-1.5 PCI ID
      ALSA: hda - Tweak OLPC XO-1.5 microphone bias

Daniel T Chen (2):
      ALSA: intel8x0: Mute External Amplifier by default for another Sony model
      ALSA: hda: Use model=auto quirk for Sony VAIO VGN-FW170J using ALC262

Darrick J. Wong (1):
      acpi-power-meter: Don't leak ACPI error codes to userspace

Dave Airlie (8):
      drm/radeon/kms: don't refuse LUT because no framebuffer.
      drm/radeon: Revert "drm/r600: avoid assigning vb twice in blit code"
      drm/radeon/kms: fix use of index before proper initialisation.
      drm/kms: fix kms/fbdev colormap support properly.
      drm/radeon/kms: fix rc410 suspend/resume.
      drm/radeon/kms: fix coherency issues on AGP cards.
      drm/radeon/kms: disable D1VGA and D2VGA if enabled
      drm/radeon/kms: stop putting VRAM at 0 in MC space on r600s.

Dave Jones (1):
      x86: Fix printk message typo in mtrr cleanup code

David S. Miller (3):
      sparc64: Add a comment about why we only use certain memory barriers these days.
      Revert "ide: try to use PIO Mode 0 during probe if possible"
      sparc: Move of_set_property_mutex acquisition outside of devtree_lock grab.

Denis Turischev (1):
      [WATCHDOG] SBC-FITPC2 watchdog driver registration fix

Devin Heitmueller (1):
      V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming

Don Skidmore (1):
      ixgbe: fix traffic hangs on Tx with ioatdma loaded

Eric Dumazet (3):
      rose: device refcount leak
      decnet: netdevice refcount leak
      can: should not use __dev_get_by_index() without locks

Eric Sandeen (1):
      ext3: retry failed direct IO allocations

Eric W. Biederman (1):
      sysfs: Don't leak secdata when a sysfs_dirent is freed.

Erik Andrén (3):
      V4L/DVB (13255): gspca - m5602-s5k4aa: Add vflip quirk for the Bruneinit laptop
      V4L/DVB (13256): gspca - m5602-s5k4aa: Add another MSI GX700 vflip quirk
      V4L/DVB (13257): gspca - m5602-s5k4aa: Add vflip for Fujitsu Amilo Xi 2528

Finn Thain (1):
      macsonic: fix crash on PowerBook 520

Francisco Jerez (1):
      drm/kms: Init the CRTC info fields for modes forced from the command line.

Frans Pop (2):
      thermal: sysfs-api.txt - reformat for improved readability
      thermal: sysfs-api.txt - document passive attribute for thermal zones

Gleb Natapov (1):
      KVM: get_tss_base_addr() should return a gpa_t

Gottfried Haider (1):
      x86: Add reboot quirk for 3 series Mac mini

Grazvydas Ignotas (2):
      omap3: pandora: Fix keypad keymap
      omap3: update Pandora defconfig

Guennadi Liakhovetski (4):
      V4L/DVB (13129): sh_mobile_ceu_camera: fix cropping for scaling clients
      V4L/DVB (13131): pxa_camera: fix camera pixel format configuration
      V4L/DVB (13132): fix use-after-free Oops, resulting from a driver-core API change
      fb: put framebuffer drivers back under the "frame buffer devices" menu

Gustavo Maciel Dias Vieira (1):
      ACPI: add DMI entry for SCI_EN resume quirk on HP dv4

HIRANO Takahito (1):
      V4L/DVB (13167): pt1: Fix a compile error on arm

Hans de Goede (1):
      V4L/DVB (13122): gscpa - stv06xx + ov518: dont discard every other frame

Haojian Zhuang (1):
      [ARM] pxa: fix resume failure by saving/restoring IPRx registers

Heiko Carstens (1):
      fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl

Henrik Kurelid (1):
      V4L/DVB (13237): firedtv: length field corrupt in ca2host if length>127

Herbert Xu (1):
      ipip: Fix handling of DF packets when pmtudisc is OFF

Hirokazu Takata (3):
      m32r: add NOTES to vmlinux.lds.S to remove .note.gnu.build-id section
      m32r: bzip2/lzma kernel compression support
      m32r: fix arch/m32r/boot/compressed/Makefile

Hugh Dickins (1):
      ksm: cond_resched in unstable tree

James Simmons (1):
      drm/kms: typo fix

Jan Beulich (1):
      x86/PCI: Adjust GFP mask handling for coherent allocations

Jan Engelhardt (1):
      netfilter: xt_connlimit: fix regression caused by zero family value

Jan Kara (1):
      ext3: Wait for proper transaction commit on fsync

Jan Kiszka (1):
      KVM: x86: Catch potential overrun in MCE setup

Janusz Krzysztofik (3):
      ASoC: OMAP: Don't try to set unsupported OMAP_DMA_DATA_BURST_16 on OMAP1
      omap: Fix omapfb/lcdc on OMAP1510 broken when PM set
      omap1: Amstrad Delta defconfig fixes

Jarkko Nikula (1):
      omap3: beagle: Fix USB host port power control

Jassi Brar (6):
      ASoC: S3C64XX I2S: Enable audio-bus clock
      ARM: S3C64XX: DMA: Protect buffer pointers while manipulation
      ARM: S3C64XX: DMA: Unify callback functions for success/failure
      ARM: S3C64XX: DMA: Make src and dst transfer size same
      ARM: S3C64XX: DMA: Callback with correct buffer pointer
      ARM: S3C64XX: DMA: Free node for non-circular queues

Jaswinder Singh Rajput (1):
      mtd: nand: fix htmldocs warnings

Jean Delvare (2):
      i2c: Add an interface to lock/unlock an I2C bus segment
      V4L/DVB (13287): ce6230 - saa7164-cmd: Fix wrong sizeof

Jean-Christop PLAGNIOL-VILLARD (1):
      ARM: 5779/1: ep93xx/micro9.c: fix implicit declaration of function __raw_readl and IOMEM

Jeff Layton (2):
      cifs: clean up handling when server doesn't consistently support inode numbers
      cifs: don't use CIFSGetSrvInodeNumber in is_path_accessible

Jens Axboe (3):
      backing-dev: bdi sb prune should be in the unregister path, not destroy
      cfq-iosched: fix bad return value cfq_should_preempt()
      fuse: fix kunmap in fuse_ioctl_copy_user

Jeremy Fitzhardinge (2):
      xen/hvc: make sure console output is always emitted, with explicit polling
      xen: mask extended topology info in cpuid

Jesse Barnes (5):
      drm/i915: Save and restore the GM45 FBC regs on suspend and resume.
      drm/i915: save/restore BLC histogram control reg across suspend/resume
      drm/i915: add FIFO watermark support for G4x
      drm/i915: update watermarks before enabling PLLs
      drm/i915: kill warning in intel_find_pll_g4x_dp

Jiri Slaby (4):
      isdn: hisax: Fix lock imbalance.
      isdn: eicon: Use offsetof
      isdn: eicon: Return on error
      NET: cassini, fix lock imbalance

Joe Perches (8):
      MAINTAINERS: Add git net-next-2.6
      MAINTAINERS: ASUS ACPI EXTRAS - remove F:arch/x86/kernel/acpi/boot.c
      MAINTAINERS: BROCADE BFA - Use single line M: and tabs
      MAINTAINERS: SERVER ENGINES 10Gbps iSCSI - Use single line M:
      MAINTAINERS: VMWARE VMXNET3 - Quote name with comma and period, use tabs
      MAINTAINERS: correct 9P FILE SYSTEM git entry
      MAINTAINERS: correct NETFILTER git entry format
      MAINTAINERS: correct SECURITY SUBSYSTEM git entry

Joerg Roedel (3):
      x86/amd-iommu: Workaround for erratum 63
      x86/amd-iommu: Un__init function required on shutdown
      dma-debug: Fix compile warning with PAE enabled

John W. Linville (1):
      Revert "ipw2200: fix oops on missing firmware"

Jonathan Cameron (1):
      V4L/DVB (13286): pxa-camera: Fix missing sched.h

Josef Bacik (7):
      Btrfs: fix data allocation hint start
      Btrfs: cleanup transaction starting and fix journal_info usage
      Btrfs: fix how we set max_size for free space clusters
      Btrfs: fix some metadata enospc issues
      Btrfs: find ideal block group for caching
      Btrfs: fallback on uncompressed io if compressed io fails
      Btrfs: fix panic when trying to destroy a newly allocated

JosephChan@via.com.tw (1):
      sata_via: Remove redundant device ID for VIA VT8261

Jozsef Kadlecsik (1):
      netfilter: nf_nat: fix NAT issue in 2.6.30.4+

Julia Lawall (3):
      drivers/ata/libata: Move dereference after NULL test
      arch/m32r: Use DIV_ROUND_CLOSEST
      ACPI: Move dereference after NULL test

Julian Anastasov (1):
      ALSA: usb-audio: fix combine_word problem

KAMEZAWA Hiroyuki (1):
      memcg: fix wrong pointer initialization at page migration when memcg is disabled.

Kenji Kaneshige (1):
      PCI ASPM: fix oops on root port removal

Kim Phillips (1):
      powerpc/8xxx: enable IPsec ESP by default on mpc83xx/mpc85xx

Krzysztof Helt (2):
      fb: remove fb_save_state() and fb_restore_state operations
      savagefb: fix blanking mode on CRT display

Kumar Gala (1):
      powerpc: 2.6.32 update of defconfigs for embedded 6xx/7xxx, 8xx, 8{3,5,6}xxx

Ladislav Michl (1):
      mmci-omap: free irq resource

Lai Jiangshan (1):
      ring-buffer: Synchronize resizing buffer with reader lock

Larry Finger (1):
      rtl8187: Fix kernel oops when device is removed when LEDS enabled

Laurent Pinchart (2):
      V4L/DVB (13309): uvcvideo: Ignore the FIX_BANDWIDTH for compressed video
      V4L/DVB (13311): uvcvideo: Fix compilation warning with 2.6.32 due to type mismatch with abs()

Lennert Buytenhek (5):
      [ARM] properly report mv78100 stepping A1
      [ARM] kirkwood: fix PCI I/O port assignment
      [ARM] Kirkwood: clarify PCIe MEM bus/physical address distinction
      serial: fix printk format specifiers for struct uart_port::iobase
      serial: add support for the Lava Quattro PCI quad-port 16550A card

Li Dongyang (1):
      Btrfs: skip btrfs_release_path in btrfs_update_root and btrfs_del_root

Li Hong (1):
      amd64_edac: fix a wrong goto clause in amd64_edac.c

Li Jie (1):
      [ARM] kirkwood: fix section mismatch

Li Zefan (1):
      ftrace: Fix unmatched locking in ftrace_regex_write()

Linus Torvalds (3):
      sgi-gru: decrapfiy options_write() function
      btusb bluetooth driver: wait for 'waker' work too before closing
      Linux 2.6.32-rc7

Luca Niccoli (1):
      eeepc-laptop: don't enable camera at startup if it's already on.

Magnus Damm (1):
      serial: sh-sci: disable callback typo fix

Mark Brown (2):
      ARM: SMDK6410: Configure GPIO pull up for WM835x IRQ line
      ARM: SMDK6410: Allocate more GPIO space for WM1190-EV1

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on MSI K9A2 Platinum v2

Martin Michlmayr (1):
      hisax: remove bad udelay call to fix build error on ARM

Martin Samek (1):
      V4L/DVB (13079): dib0700: fixed xc2028 firmware loading kernel oops

Mathias Fröhlich (3):
      drm/radeon/kms: fix cs parser tex bit 11 check
      drm/radeon/kms/atom: get better min pixel clock info
      drm/radeon/kms/atom: Make card_info per device

Matt Fleming (1):
      sh: Account for cache aliases in flush_icache_range()

Matt Turner (1):
      drm/radeon/kms: use RADEON_GPU_PAGE_SIZE instead of 4096

Maurus Cuelenaere (1):
      ARM: S3C64XX: Remove duplicate s3c_dma_has_circular() definition for S3C64xx.

Mel Gorman (2):
      page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed
      page allocator: Do not allow interrupts to use ALLOC_HARDER

Michael Krufky (5):
      V4L/DVB (13048): dib0070: fix build dependency when driver is disabled
      V4L/DVB (13107): tda18271: fix overflow in FM radio frequency calculation
      V4L/DVB (13202): smsusb: add autodetection support for three additional Hauppauge USB IDs
      V4L/DVB (13313): saa7134: add support for FORCE_TS_VALID mode for mpeg ts input
      V4L/DVB (13314): saa7134: set ts_force_val for the Hauppauge WinTV HVR-1150

Michel Dänzer (2):
      drm/radeon/kms: Update memory bandwidth requirements in mode_set_base hook.
      drm/radeon/kms: Fix apparent typo in legacy CRTC memory bandwidth calculation.

Mike Frysinger (2):
      mtd/maps: gpio-addr-flash: pull in linux/ headers rather than asm/
      mtd/maps: gpio-addr-flash: depend on GPIO arch support

Mike Galbraith (3):
      sched: Strengthen buddies and mitigate buddy induced latencies
      sched: Disable SD_PREFER_LOCAL at node level
      sched: Fix kthread_bind() by moving the body of kthread_bind() to sched.c

Mike Hommey (1):
      __generic_block_fiemap(): fix for files bigger than 4GB

Mike Isely (3):
      V4L/DVB (13169): bttv: Fix potential out-of-order field processing
      V4L/DVB (13170): bttv: Fix reversed polarity error when switching video standard
      V4L/DVB (13230): s2255drv: Don't conditionalize video buffer completion on waiting processes

Mike Turquette (1):
      omap3: Decrease cpufreq transition latency

Miklos Szeredi (1):
      fuse: invalidate target of rename

Mingming (4):
      ext4: fix ext4_ext_direct_IO()'s return value after converting uninit extents
      ext4: skip conversion of uninit extents after direct IO if there isn't any
      ext4: code clean up for dio fallocate handling
      ext4: Fix return value of ext4_split_unwritten_extents() to fix direct I/O

NeilBrown (2):
      md: don't clear endpoint for resync when resync is interrupted.
      md/raid5: make sure curr_sync_completes is uptodate when reshape starts

Nicolas Ferre (1):
      atmel_lcdfb: new alternate pixel clock formula

Nicolas Pitre (3):
      [ARM] Kirkwood: update defconfig
      [ARM] orion5x: update defconfig
      ARM: 5784/1: fix early boot machine ID mismatch error display

Olof Johansson (1):
      powerpc: pasemi_defconfig update

Ondrej Zajicek (1):
      [ARM] pxa/palm: fix incorrect initialization of Palm Tungsten C keyboard

Patrick Boettcher (1):
      V4L/DVB (13050): DIB0700: fix-up USB device ID for Terratec/Leadtek

Paul E. McKenney (1):
      rcu: Fix long-grace-period race between forcing and initialization

Paul Gortmaker (1):
      powerpc/85xx: sbc8548 - fixup of PCI-e related DTS fields

Paul Mundt (1):
      sh: unwinder: Fix up invalid PC refetch in dwarf unwinder.

Pavel Machek (1):
      drivers/video/msm: update to new kernel

Pekka Enberg (1):
      perf tools: Fix permission checks

Peter Zijlstra (1):
      alpha: fix F_SETOWN_EX and F_GETLK64 conflict

Rafa³ Mi³ecki (1):
      drm/radeon/kms: add debugfs for power management for AtomBIOS devices

Rakib Mullick (1):
      ACPI: add __cpuinit to acpi_processor_add()

Randy Dunlap (4):
      sound: Use KERN_WARNING instead of KERN_WARN, which does not exist
      ALSA: hda, move hp_bseries_system
      sched: Fix kernel-doc function parameter name
      MAINTAINERS: openipmi list is moderated

Rask Ingemann Lambertsen (1):
      rtc: pcf50633: fix month off-by-one error

Robert Noland (2):
      drm/radeon/r600: Replace repeated calculations with variable.
      drm/radeon/r600: only assign vb after we know space is available.

Rodolfo Giometti (2):
      pps: locking scheme fix up for PPS_GETPARAMS
      pps: events reporting fix up

Roel Kluin (7):
      m32r: Should index be positive?
      isdn: hisax: Fix test in waitforxfw
      isdn: hfc_usb: Fix read buffer overflow
      powerpc/82xx: kmalloc failure ignored in ep8248e_mdio_probe()
      sparc64: replace parentheses in pmul()
      ALSA: hda - possible read past array alc88[02]_parse_auto_config()
      get_maintainer: fix usage comment

Ron Mercer (2):
      qlge: Fix early exit from mbox cmd complete wait.
      qlge: Set PCIe reset type for EEH to fundamental.

Russell King (2):
      [ARM] Fix test for unimplemented ARM syscalls
      ARM: Use a definition for the userspace cmpxchg emulation syscall

Rusty Russell (1):
      sched: Fix boot crash by zalloc()ing most of the cpu masks

Ryusuke Konishi (2):
      nilfs2: fix kernel oops in error case of nilfs_ioctl_move_blocks
      nilfs2: fix missing cleanup of gc cache on error cases

Sathya Perla (1):
      be2net: Fix CQE_STATUS_EXTD_SHIFT define

Scott Valentine (1):
      rtc: v3020: fix v3020_mmio_read_bit()

Sean Cross (1):
      rt2x00: Don't queue ieee80211 work after USB removal

Sebastian Haas (1):
      ems_usb: Fix byte order issues on big endian machines

Sebastian Siewior (1):
      net/fsl_pq_mdio: add module license GPL

Sergei Shtylyov (1):
      gpiolib: fix device_create() result check

Sergio Aguirre (1):
      omap3: 3430sdp: Enable Linux Regulator framework

Seth Barry (1):
      V4L/DVB (13109): tda18271: fix signedness issue in tda18271_rf_tracking_filters_init

Shaohua Li (2):
      drm/i915: disable FBC for Pineview, fixing a boot hang.
      cfq-iosched: limit coop preemption

Simon Kagstrom (2):
      [ARM] OpenRD base: Initialize PCI express and i2c
      x86: Add Phoenix/MSC BIOSes to lowmem corruption list

Soeren Sandmann (2):
      highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow
      highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE

Stanislav Brabec (1):
      [ARM] pxa/zaurus: fix NAND flash OOB layout for Borzoi

Stefan Richter (1):
      V4L/DVB (13240): firedtv: fix regression: tuning fails due to bogus error return

Stefan Schmidt (1):
      fs/jbd: Export log_start_commit to fix ext3 build.

Stefani Seibold (1):
      x86, fs: Fix x86 procfs stack information for threads on 64-bit

Stephen Hemminger (1):
      bridge: prevent bridging wrong device

Sukadev Bhattiprolu (1):
      pidns: fix a leak in /proc dentries and inodes with pid namespaces.

Takashi Iwai (2):
      ALSA: hda - Don't initialize CORB/RIRB for single_cmd mode
      ALSA: hda - Avoid quirk for HP dc5750

Tao Hu (1):
      omap: Fix race condition in omap dma driver

Tao Ma (1):
      JBD/JBD2: free j_wbuf if journal init fails.

Thadeu Lima de Souza Cascardo (1):
      perf_events: Fix some typo in the perf events config description

Theodore Kilgore (1):
      V4L/DVB (13264): gspca_mr97310a: Change vstart for CIF sensor type 1 cams

Theodore Ts'o (1):
      ext4: partial revert to fix double brelse WARNING()

Thomas Gleixner (3):
      uids: Prevent tear down race
      sound: Replace old style lock initializer
      sh: Replace old style lock initializer

Tobias Klauser (1):
      omap: Use resource_size

Tony Thompson (1):
      ARMv7: Check whether the SMP/nAMP mode was already enabled

Tonyliu (1):
      DaVinci EMAC: correct param for ISR

Torgny Johansson (1):
      cdc_ether: additional Ericsson MBM PID's to the whitelist

Uwe Kleine-König (1):
      virtio_net: rename driver struct to please modpost

Vaibhav Verma (1):
      ACPI: sleep: another HP/Compaq DMI entries for init_set_sci_en_on_resume

Vitaliy Kulikov (1):
      ALSA: hda - Enable GPIO control for mute LED on HP systems

Werner Almesberger (1):
      rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm

Wolfgang Grandegger (1):
      can: fix WARN_ON dump in net/core/rtnetlink.c:rtmsg_ifinfo()

Xiaotian Feng (1):
      x86: Fix error return sequence in __ioremap_caller()

Yi Zou (2):
      ixgbe: Fix gso_max_size for 82599 when DCB is enabled
      ixgbe: Fix checking TFCS register for TXOFF status when DCB is enabled

Yoichi Yuasa (1):
      rtc-vr41xx: fix do_div() warning

Yong Zhang (1):
      genirq: try_one_irq() must be called with irq disabled

Zhao Yakui (2):
      drm/i915: Set the LVDS_BORDER when using LVDS scaling mode
      drm: Add the basic check for the detailed timing in EDID

Zhenyu Wang (6):
      drm/i915: disable powersave feature for Ironlake currently
      drm/i915: Fix FDI M/N setting according with correct color depth
      drm/i915: fix to setup display reference clock control on Ironlake
      drm/i915: fix panel fitting filter coefficient select for Ironlake
      drm/i915: quiet DP i2c init
      drm/i915: Ironlake suspend/resume support

zeal (1):
      ARM: 5780/1: KS8695: Fix macro definition bug in regs-switch.c
