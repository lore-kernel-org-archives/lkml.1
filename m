Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZLCFrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZLCFrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZLCFrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:47:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbZLCFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:46:58 -0500
Date: Wed, 2 Dec 2009 21:47:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32
Message-ID: <alpine.LFD.2.00.0912022125400.2872@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This release _feels_ long overdue due to two empty weeks for me (kernel 
summit and thanksgiving week vacation), but it's actually less than three 
months since 2.6.31, so I guess it's actually not that far off the normal 
schedule.

I've been merging a few things that were pending while I was offline, but 
it really seems to have been pretty quiet. The biggest thing since -rc8 
is the horribly timed stability fixes for fscache, which caused some 
hickups and I really wish it hadn't happened that way, but apart from that 
it's mainly small updates (and mainly drivers).

The dirstat from -rc8 looks like

   2.7% arch/blackfin/
   5.8% arch/
   2.1% drivers/misc/eeprom/
   3.5% drivers/net/e1000e/
   9.6% drivers/net/
   3.9% drivers/staging/
   2.0% drivers/usb/musb/
   2.8% drivers/usb/
  34.8% drivers/
   4.1% fs/cachefiles/
  24.9% fs/fscache/
  32.6% fs/
  14.5% kernel/
   3.7% net/

and that fs/ and kernel/ noise is mostly from that fscache thing (the 
kernel subdirectory part is the "slow-work" stuff that fscache uses), and 
the shortlog is appended.

As to the "big feature" changes in 2.6.32 since 31 - I think we have a 
release without any actual new filesystem for once, but there's been a 
fair amount of changes to btrfs, and the block layer writeback itself has 
been through major updates, and the whole per-bdi writeback thing is a 
pretty big change.

Other rather noticeable changes are in KSM (both intel and radeon) and in 
drivers all over the place. As usual, kernelnewbies (and other sites, for 
that matter) has more details for people who want to delve into it all by 
subsystem.

		Linus

---
Ajay Kumar Gupta (2):
      USB: musb: Remove unwanted message in boot log
      USB: musb: fix ISOC Tx programming for CPPI DMAs

Alan Cox (2):
      V4L/DVB (13530): Fix wrong parameter order in memset
      tty_port: handle the nonblocking open of a dead port corner case

Alan Stern (2):
      PM: fix irq enable/disable in runtime PM code
      USB: EHCI: don't send Clear-TT-Buffer following a STALL

Alek Du (1):
      gpio: Langwell GPIO driver bugfixes

Alex Chiang (1):
      cciss: make device attrs static

Alexander Beregalov (1):
      Au1x00: fix crash when trying register_netdev()

Alexey Kuznetsov (1):
      [SCSI] fix crash when disconnecting usb storage

Alexey Starikovskiy (1):
      ACPICA: Silence the warning about _BIF returning the buffer

Amit Kumar Salecha (1):
      netxen: fix memory initialization

Andrei Pelinescu-Onciul (1):
      sctp: on T3_RTX retransmit all the in-flight chunks

Andrew Morton (1):
      drivers/media/dvb/dvb-core/dvb_frontend.c: needs semaphore.h

André Goddard Rosa (1):
      Blackfin: fix cache Kconfig typo

Anisse Astier (1):
      Input: i8042 - add Dell Vostro 1320, 1520 and 1720 to the reset list

Antti Kaijanmäki (2):
      hso: fix debug routines
      hso: fix soft-lockup

Antti Palosaari (1):
      V4L/DVB (13366): em28xx: fix Reddo DVB-C USB TV Box GPIO

Anuj Aggarwal (1):
      ASoC: AIC23: Fixing infinite loop in resume path

Atsushi Nemoto (1):
      SPI: spi_txx9: Fix bit rate calculation

Bartlomiej Zolnierkiewicz (1):
      Staging: update TODO files

Becky Bruce (1):
      powerpc: Fix DEBUG_HIGHMEM build break from d4515646699

Bruce Allan (7):
      e1000e: partial revert of 3ec2a2b8 plus FC workraround for 82577/8
      e1000e: read of PHY register may access wrong page on 82578
      e1000e: set flow control thresholds properly after enabling/disabling pause
      e1000e: add Tx timeout factor for 100Mbps
      e1000e: flow control thresholds not correct when changing mtu
      e1000e: remove unnecessary 82577 workaround causing link issues
      e1000e: do not initiate autonegotiation during OEM configuration

Chris Wilson (2):
      drm/i915: Avoid potential sleep whilst holding spinlock
      drm/i915: Select CONFIG_SHMEM

Chuck Ebbert (1):
      crypto: padlock-aes - Use the correct mask when checking whether copying is required

Clemens Ladisch (1):
      drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling

Coly Li (1):
      ocfs2: return f_fsid info in ocfs2_statfs()

Csaba Henk (1):
      fuse: reject O_DIRECT flag also in fuse_create

Dan Carpenter (2):
      wan: cosa: drop chan->wsem on error path
      drivers/rtc/rtc-pcf50633.c: fix use after free in pcf50633_rtc_probe()

Dan Williams (9):
      ioat: silence "dca disabled" messages
      ioat3: dca and raid operations are incompatible
      ioat2,3: disable asynchronous error notifications
      ioat3: specify valid address for disabled-Q or disabled-P
      ioat2,3: report all uncorrectable errors
      dmaengine: include xor/pq validate in device_has_all_tx_types()
      async_tx: build-time toggling of async_{syndrome,xor}_val dma support
      ioat3: fix pq completion versus channel deallocation race
      shdma: fix initialization error handling

Daniel Glöckner (2):
      USB: musb: respect usb_request->zero in control requests
      USB: musb: Fix CPPI IRQs not being signaled

Daniel Mack (2):
      [ARM] pxa/cpufreq: fix index assignments for end marker
      [ARM] pxamci: call mmc_remove_host() before freeing resources

Dave Airlie (3):
      drm/radeon/kms: resume AGP by calling init.
      drm/radeon/kms: fix handling of d1/d2 vga
      drm/radeon/kms: read back register before writing in IIO.

Dave Jones (1):
      Staging: hv: Fix argument order in incorrect memset invocations in hyperv driver.

David Daney (3):
      MIPS: Octeon: Fix compile error in drivers/staging/octeon/ethernet-mdio.c
      Staging: Octeon: Use symbolic values for irq numbers.
      Staging: octeon-ethernet: Assign proper MAC addresses.

David Ford (1):
      ipv4: additional update of dev_net(dev) to struct *net in ip_fragment.c, NULL ptr OOPS

David Howells (31):
      SLOW_WORK: Wait for outstanding work items belonging to a module to clear
      SLOW_WORK: Allow the work items to be viewed through a /proc file
      SLOW_WORK: Allow the owner of a work item to determine if it is queued or not
      SLOW_WORK: Allow a requeueable work item to sleep till the thread is needed
      FS-Cache: Annotate slow-work runqueue proc lines for FS-Cache work items
      FS-Cache: Allow the current state of all objects to be dumped
      FS-Cache: Add counters for entry/exit to/from cache operation functions
      FS-Cache: Clear netfs pointers in cookie after detaching object, not before
      FS-Cache: Use radix tree preload correctly in tracking of pages to be stored
      FS-Cache: Permit cache retrieval ops to be interrupted in the initial wait phase
      FS-Cache: The object-available state can't rely on the cookie to be available
      FS-Cache: Fix lock misorder in fscache_write_op()
      FS-Cache: Don't delete pending pages from the page-store tracking tree
      FS-Cache: Handle read request vs lookup, creation or other cache failure
      FS-Cache: Handle pages pending storage that get evicted under OOM conditions
      FS-Cache: Add a retirement stat counter
      FS-Cache: Make sure FSCACHE_COOKIE_LOOKING_UP cleared on lookup failure
      FS-Cache: Start processing an object's operations on that object's death
      FS-Cache: Actually requeue an object when requested
      CacheFiles: Don't write a full page if there's only a partial page to cache
      CacheFiles: Handle truncate unlocking the page we're reading
      CacheFiles: Mark parent directory locks as I_MUTEX_PARENT to keep lockdep happy
      CacheFiles: Better showing of debugging information in active object problems
      CacheFiles: Catch an overly long wait for an old active object
      CacheFiles: Don't log lookup/create failing with ENOBUFS
      SLOW_WORK: Fix CIFS to pass THIS_MODULE to slow_work_register_user()
      SLOW_WORK: Fix GFS2 to #include <linux/module.h> before using THIS_MODULE
      FS-Cache: Provide nop fscache_stat_d() if CONFIG_FSCACHE_STATS=n
      9p: fix build breakage introduced by FS-Cache
      SLOW_WORK: Fix the CONFIG_MODULES=n case
      SLOW_WORK: Move slow_work's proc file to debugfs

David J. Choi (1):
      drivers/net: ks8851_mll ethernet network driver -resubmit

David S. Miller (8):
      sparc64: Fix definition of VMEMMAP_SIZE.
      sunsab: Do not set sunsab_reg.cons right before registering minors.
      sunsu: Fix detection of SU ports which are RSC console or control.
      serial: suncore: Add 'ignore_line' argument to sunserial_console_match().
      serial: suncore: Fix RSC/LOM handling in sunserial_console_termios().
      sunsu: Pass true 'ignore_line' to console match when RSC or LOM console.
      sunsu: Use sunserial_console_termios() in sunsu_console_setup().
      b44: Fix wedge when using netconsole.

David Woodhouse (1):
      jffs2: Fix memory corruption in jffs2_read_inode_range()

Eric Dumazet (4):
      ieee802154: dont leak skbs in ieee802154_fake_xmit()
      veth: Fix veth_get_stats()
      pktgen: Fix device name compares
      pktgen: Fix netdevice unregister

Eric W. Biederman (1):
      USB: ftdi_sio: Keep going when write errors are encountered.

Florian Fainelli (3):
      ep93xx-eth: check for zero MAC address on probe, not on device open
      rc32434_wdt: fix compilation failure
      MIPS: RB532: Fix devices.c compilation.

Geert Uytterhoeven (3):
      net: ETHOC should depend on HAS_DMA
      V4L/DVB (13412): SMS_SIANO_MDTV should depend on HAS_DMA
      fbdev: Migrate mailing lists to vger

Gernot Hillier (1):
      USB: Add support for Mobilcom Debitel USB UMTS Surf-Stick to option driver

Gertjan van Wingerde (1):
      .gitignore: Add bzip2 compressed files

Giuseppe CAVALLARO (2):
      stmmac: fixed a compilation error when use the external timer
      stmmac: do not fail when the timer cannot be used.

Graf Yang (1):
      Blackfin: fix SMP build error in start_thread()

Guennadi Liakhovetski (2):
      V4L/DVB (13343): v4l: add more missing linux/sched.h includes
      V4L/DVB (13344): soc-camera: properly initialise the device object when reusing

H Hartley Sweeten (1):
      [WATCHDOG] rc32434_wdt.c: use resource_size()

Haiyang Zhang (2):
      Staging: hv: Fix vmbus event handler bug
      Staging: hv: Fix some missing author names

Hans Verkuil (3):
      V4L/DVB (13321): radio-gemtek-pci: fix double mutex_lock
      V4L/DVB (13371): davinci: remove stray duplicate config pointer
      V4L/DVB (13481): sh_mobile_ceu_camera: fix compile warning

Harald Welte (1):
      [CPUFREQ] Enable ACPI PDC handshake for VIA/Centaur CPUs

Helge Deller (2):
      parisc: fix unwind with recent gcc versions
      modules: don't export section names of empty sections via sysfs

Hemant Pedanekar (1):
      ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode instead of UDMA6

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix detection of old ThinkPads

Huang Ying (1):
      crypto: gcm - fix another complete call in complete fuction

Ivan Vecera (1):
      r8169: restore mac addr in rtl8169_remove_one and rtl_shutdown

James Bottomley (1):
      [SCSI] fix async scan add/remove race resulting in an oops

Jaswinder Singh Rajput (1):
      ixgbe: move tc variable to CONFIG_IXGBE_DCB

Jay Fenlason (2):
      firewire: ohci: Make cycleMatch ISO transmission work
      firewire: ohci: pass correct iso xmit timestamps to core

Jean Delvare (2):
      MAINTAINERS: Add missing i2c files
      i2c: Fix userspace_device list corruption

Jean PIHET (1):
      ARM: 5793/1: ARM: Check put_user fail in do_signal when enable OABI_COMPAT

Jens Axboe (3):
      SLOW_WORK: Make slow_work_ops ->get_ref/->put_ref optional
      SLOW_WORK: Add support for cancellation of slow work
      SLOW_WORK: Add delayed_slow_work support

Jeremy Fitzhardinge (1):
      drm: make sure page protections are updated after changing vm_flags

Jerome Glisse (3):
      drm/radeon/kms: Disable TV load detect on RS400,RC410,RS480
      drm: mm always protect change to unused_nodes with unused_lock spinlock
      drm/radeon/kms: Report vga connector is connected according to ddc_probe

Jerone Young (1):
      ACPI: Add Thinkpad T400, T500 to OSI(Linux) white-list

Jesse Barnes (1):
      drm: work around EDIDs with bad htotal/vtotal values

Jiang Yutang (1):
      sata_fsl: Split hard and soft reset

Jie Zhang (1):
      Blackfin: fix typo in ptrace poking

Joel Becker (1):
      ocfs2: Return -EINVAL when a device is not ocfs2.

Johannes Berg (5):
      mac80211: fix addba timer (again...)
      mac80211: fix resume
      rfkill: fix miscdev ops
      mac80211: fix two remote exploits
      mac80211: fix spurious delBA handling

Johannes Weiner (2):
      rtc-x1205: fix rtc_time to y2k register value conversion
      rtc-x1205: reset clock to sane state after power failure

John W. Linville (1):
      ath9k: set ps_default as false

Julia Lawall (3):
      arch/alpha/kernel/sys_ruffian.c: Use DIV_ROUND_CLOSEST
      arch/alpha/kernel: Add kmalloc NULL tests
      VIDEO: Correct use of request_region/request_mem_region

Kevin Wells (3):
      i2c: i2c-pnx: Limit minimum jiffie timeout to 2
      i2c: i2c-pnx: Made buf type unsigned to prevent sign extension
      i2c: i2c-pnx: Added missing mach/i2c.h and linux/io.h header file includes

Kuninori Morimoto (1):
      V4L/DVB (13345): soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable

Len Brown (1):
      ACPI: DMI init_set_sci_en_on_resume for HP-Compaq C700

Linus Torvalds (1):
      Linux 2.6.32

Marc Dionne (1):
      CacheFiles: Update IMA counters when using dentry_open

Mark Brown (3):
      ASoC: Fix suspend with active audio streams
      mfd: Correct WM831X_MAX_ISEL_VALUE
      regulator: Initialise wm831x structure pointor for ISINK driver

Martin K. Petersen (1):
      [SCSI] sd: Return correct error code for DIF

Martin Michlmayr (1):
      MIPS: IP22/IP28 Disable early printk to fix boot problems on some systems.

Mauro Carvalho Chehab (1):
      staging/go7007: Fix compilation by re-adding the missing s2250-loader.h

Maxime Bizon (1):
      bcm63xx_uart: Fix serial driver compile breakage.

Michael Cree (1):
      Alpha: Rearrange thread info flags fixing two regressions

Michael Hennerich (1):
      Blackfin: fix suspend/resume failure with some on-chip ROMs

Michal Simek (1):
      tty/of_serial: add missing ns16550a id

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in extended mode

Mike Frysinger (3):
      Blackfin: update anomaly lists
      Blackfin: work around testset anomaly 05000477
      Blackfin: check for anomaly 05000475

Narender Kumar (2):
      netxen: fix promisc for NX2031.
      netxen : fix BOND_MODE_TLB/ALB mode.

NeilBrown (1):
      md: revert incorrect fix for read error handling in raid1.

Oliver Neukum (1):
      USB: work around for EHCI with quirky periodic schedules

Olivier Lorin (1):
      V4L/DVB (13372a): MAINTAINERS: addition of gspca_gl860 driver

Patrick McHardy (4):
      netfilter: xt_osf: fix xt_osf_remove_callback() return value
      netfilter: nf_log: fix sleeping function called from invalid context in seq_show()
      netfilter: xt_limit: fix invalid return code in limit_mt_check()
      macvlan: fix gso_max_size setting

Pavel Machek (1):
      [ARM] pxa/spitz: fix compile regression on spitz

Pete Eberlein (1):
      V4L/DVB (13372): staging/go7007: fix mutex function usage for s2250

Peter Feuerer (1):
      acerhdf: return temperature in milidegree instead of degree

Peter Horton (1):
      aoe: prevent cache aliases

Ralf Baechle (3):
      MIPS: Fix build error if __xchg() is not getting inlined.
      MIPS: Add missing definition for MADV_HWPOISON.
      MIPS: Fix MIPS I build.

Randy Dunlap (1):
      sysfs: fix SYSFS_DEPRECATED_V2 prompt

Robert Lowery (1):
      V4L/DVB (13436): cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)

Roel Kluin (3):
      netfilter: xt_osf: fix xt_osf_remove_callback() return value
      thinkpad-acpi: fix sign of ERESTARTSYS return
      Blackfin: fix memset in smp_send_reschedule() and -stop()

Roger Oksanen (1):
      e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failure

Romit Dasgupta (1):
      Thaw refrigerated bdi flusher threads before invoking kthread_stop on them

Russell King (7):
      [ARM] kmap: fix build errors with DEBUG_HIGHMEM enabled
      ARM: PNX4008: fix watchdog device driver name
      ARM: PNX4008: i2c-pnx: use the same dev_id for request_irq and free_irq
      MAINTAINERS: add maintainer information for AMBA primecell drivers
      [ARM] Update mach-types
      ALSA: AACI: fix AC97 multiple-open bug
      ALSA: AACI: fix recording bug

Russell King - ARM Linux (1):
      NET: smc91x: Fix irq flags

Rusty Russell (1):
      param: don't complain about unused module parameters.

Sam Ravnborg (1):
      kbuild: stepping down as maintainer

Samuel Thibault (1):
      Input: keyboard - fix braille keyboard keysym generation

Sergei Shtylyov (1):
      USB: musb_gadget: fix STALL handling

Steve French (3):
      [CIFS] fix oops in cifs_lookup during net boot
      [CIFS] Duplicate data on appending to some Samba servers
      [CIFS] Fix sparse warning

Steve Glendinning (1):
      smsc9420: prevent BUG() if ethtool is called with interface down

Steven Rostedt (1):
      kconfig: Fix make O=<dir> local{mod,yes}config

Sudhakar Rajashekhara (1):
      davinci: fb: fix frame buffer driver issues

Sunil Mushran (2):
      ocfs2: Refresh documentation
      ocfs2: Trivial cleanup of jbd compatibility layer removal

Tao Ma (2):
      ocfs2: Move ocfs2_complete_reflink to the right place.
      ocfs2: duplicate inline data properly during reflink.

Thomas Dahlmann (1):
      usb: amd5536udc: fixed shared interrupt bug and warning oops

Thomas Gleixner (1):
      alpha: Fixup last users of irq_chip->typename

Wolfram Sang (1):
      at24: Use timeout also for read

Wu Fengguang (1):
      netfilter: nf_log: fix sleeping function called from invalid context in seq_show()

Wu Zhangjin (2):
      MIPS: Loongson: Disallow 4kB pages
      MIPS: Loongson: Switch from flatmem to sparsemem

Zhenyu Wang (5):
      drm/i915: Fix and cleanup DPLL calculation for Ironlake
      drm/i915: HDMI hardware workaround for Ironlake
      drm/i915: Add more registers save/restore for Ironlake suspend
      agp/intel: new host bridge support
      drm/i915: Fix CRT hotplug detect by checking really no channels attached

Zou, Nanhai (1):
      drm/i915: Fix IRQ stall issue on Ironlake

chaithrika@ti.com (1):
      TI DaVinci EMAC: Minor macro related updates
