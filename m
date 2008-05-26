Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYEZSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYEZSlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYEZSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:41:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbYEZSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:41:39 -0400
Date: Mon, 26 May 2008 11:41:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc4
Message-ID: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You know the drill by now: another week, another -rc.

There's a lot of small stuff in here, most people won't even notice. The 
most noticeable thing is for all you 32-bit x86 people who use PAE 
(enabled by the HIGHMEM64G config option) due to having too much memory in 
your machine - mprotect() was broken due to some of the PAT fix/cleanup 
patches, causing the NX bit to be not set correctly.

So if you had PAE enabled _and_ a recent enough CPU to have NX, but not 
recent enough to be 64-bit (or you were just perverse and wanted to run a 
32-bit kernel despite having a chip that could do 64-bit and enough memory 
that you _really_ should have used a 64-bit kernel), you'd get various 
random program failures with SIGSEGV. It ranged from X not starting up to 
apparently OpenOffice not working if it did.

But most of the changes, as usual, are in drivers, at 60%, with some DRI 
changes leading the way (fixing a number of other regressions, mainly by 
reverting the under-cooked vblank update). Network, MMC, USB, watchdog and 
IDE drivers also got updates.

We had CIFS and NFS updates, and some arch updates as usual. The dirstat 
gives the overview:

   2.0% arch/blackfin/
   3.3% arch/powerpc/configs/
   3.7% arch/powerpc/
  10.4% arch/
   4.5% drivers/ata/
  15.4% drivers/char/drm/
  15.8% drivers/char/
   9.6% drivers/hwmon/
   6.4% drivers/mmc/card/
   6.5% drivers/mmc/
   2.6% drivers/net/sfc/
   8.4% drivers/net/
   5.8% drivers/usb/class/
   6.1% drivers/usb/
   3.5% drivers/watchdog/
  60.9% drivers/
   7.7% fs/cifs/
   2.5% fs/nfs/
  12.7% fs/
   4.5% include/
   2.4% net/ipv4/
   2.0% net/sunrpc/xprtrdma/
   2.3% net/sunrpc/
   6.7% net/

and I append the shortlog for a sense of the details. Nothing really 
hugely exciting, I think we're doing pretty ok in the release cycle, and 
I'm getting the feeling that things are calming down.

Hopefully I'm not wrong about that "calming down" feeling, but on the 
whole this release cycle doesn't seem to have become _too_ painful.

			Linus

---
Abhijeet Kolekar (1):
      mac80211 : Association with 11n hidden ssid ap.

Adrian Bunk (10):
      nfs: make nfs4_drop_state_owner() static
      [POWERPC] powerpc/mm/hash_low_32.S: Remove CVS keyword
      sparc64: remove CVS keywords
      sparc: remove CVS keywords
      HID: remove CVS keywords
      drivers/atm/: remove CVS keywords
      make myri10ge_get_firmware_capabilities() static
      md: proper extern for mdp_major
      frv: export empty_zero_page
      sparc64: global_reg_snapshot is not for userspace

Al Viro (26):
      [Blackfin] arch: Blackfin checksum annotations
      take init_files to fs/file.c
      dup_fd() fixes, part 1
      dup_fd() part 2
      dup_fd() - part 3
      dup_fd() part 4 - race fix
      avoid multiplication overflows and signedness issues for max_fds
      get rid of leak in compat_execve()
      return to old errno choice in mkdir() et.al.
      missed kmalloc() in pcap_user.c
      fix include order in sys-i386/registers.c
      fix hppfs Makefile breakage
      uml: add missing exports for UML_RANDOM=m
      missing export of csum_partial() on uml/amd64
      thanks to net/mac80211 we need to pull drivers/leds/Kconfig on uml
      misc drivers/net endianness noise
      ecryptfs fixes
      sbus bpp: instances missed in s/dev_name/bpp_dev_name/
      irda-usb endianness annotations and fixes
      ocfs2 endianness fixes
      missing dependencies on HAS_DMA
      msnd_* is ISA-only
      MODULE_LICENSE expects "GPL v2", not "GPLv2"
      caiaq endianness fix
      provide out-of-line strcat() for m68k
      HTC_EGPIO is ARM-only

Alan Cox (4):
      iphase: Fix 64bit warning.
      MAINTAINERS needs further order fixing
      mm: fix atomic_t overflow in vm
      ip2: fix crashes on load/unload

Andi Kleen (2):
      kbuild: disable modpost warnings for linkonce sections
      x86: use explicit copy in vdso_gettimeofday()

Andrew Morton (7):
      hysdn: No longer broken on SMP.
      IB/mlx4: Fix uninitialized-var warning in mlx4_ib_post_send()
      [patch 1/1] audit_send_reply(): fix error-path memory leak
      [netdrvr] dm9000: use delayed work to update mii phy state fix
      pcnet32: fix warning
      drivers/net/tokenring/3c359.c: squish a warning
      drivers/net/tokenring/olympic.c: fix warning

Andrew Price (1):
      [GFS2] Fix cast from unsigned int to s64

Andy Fleming (1):
      ucc_geth: Fix arguments to dma map/unmap functions

Andy Whitcroft (1):
      zonelists: handle a node zonelist with no applicable entries

Anton Vorontsov (1):
      uli526x: add support for netpoll

Arjan van de Ven (2):
      Fix a deadlock in the bttv driver
      serial: fix enable_irq_wake/disable_irq_wake imbalance in serial_core.c

Arnaldo Carvalho de Melo (1):
      USB: OPTION: fix name of Onda MSA501HS HSDPA modem

Arnd Bergmann (1):
      [POWERPC] Update Cell MAINTAINERS entry, add spufs entry

Atsushi Nemoto (1):
      usb-serial: Use ftdi_sio driver for RATOC REX-USB60F

Aurelien Nephtali (1):
      net/usb: add support for Apple USB Ethernet Adapter

Avi Kivity (2):
      KVM: x86 emulator: fix writes to registers with modrm encodings
      KVM: Update MAINTAINERS for new mailing lists

Becky Bruce (1):
      e1000e: use resource_size_t, not unsigned long, for phys addrs

Ben Dooks (8):
      [ARM] 5040/1: BAST: Fix DM9000 IRQ flags initialisation
      [ARM] 5041/1: VR1000: Fix DM9000 IRQ flags initialisation
      [ARM] 5039/1: S3C244X: Rename SDI device if running on S3C244X.
      SM501: reverse FPEN/VBIASEN flags behaviour
      S3C2410: ensure that FB_BLANK_POWERDOWN shuts down the controller
      S3C2410: add error print if we cannot add attribute
      S3C2410: clean out changelog header and tidy
      S3C2410: fix driver MODULE_ALIAS()

Ben Hutchings (16):
      sfc: Use mod_timer() to set expiry and add_timer() together
      sfc: Removed casts to void
      sfc: Simplified efx_rx_calc_buffer_size() using get_order()
      sfc: Removed unncesssary UL suffixes on 0 literals
      sfc: Added and removed braces to comply with kernel style
      sfc: Replaced various macros with inline functions
      sfc: Merged efx_page_offset() into efx_rx_buf_offset()
      sfc: Use resource_size_t for PCI bus address
      sfc: Correct and expand some comments
      sfc: Use DMA_BIT_MASK() instead of our own DMA mask macros
      sfc: Do not define inline macro
      sfc: Use __packed macro
      sfc: Change type of efx_nic::nic_data to struct falcon_nic_data *
      sfc: Remove redundant casts to and from void *
      sfc: Added checks for heap allocation failure
      sfc: Remove sub-minor component from driver version

Bernd Schubert (2):
      md: md: raid5 rate limit error printk
      md: allow parallel resync of md-devices.

Bob Copeland (1):
      ath5k: Fix loop variable initializations

Bob Peterson (1):
      [GFS2] filesystem consistency error from do_strip

Brian Cavagnolo (1):
      libertas: fix command timeout after firmware failure

Brian King (1):
      ehea: Fix use after free on reboot

Brice Goglin (1):
      Add maintainers for myri10ge driver

Bryan Wu (1):
      Blackfin arch: Fix bug - USB fails to build for BF524/BF526

Cedric Le Goater (1):
      cgroups: remove node_ prefix_from ns subsystem

Chen Gong (1):
      [WATCHDOG] Fix booke_wdt.c on MPC85xx SMP system's

Christian Borntraeger (1):
      stop_machine: make stop_machine_run more virtualization friendly

Christoph Hellwig (2):
      [XFS] Fix memory corruption with small buffer reads
      md: kill file_path wrapper

Christophe Jaillet (3):
      kconfig: incorrect 'len' field initialisation ?
      avr32/pata: avoid unnecessary memset (updated after comments)
      iop-adma: fixup some kzalloc/memset confusions

Chuck Ebbert (1):
      x86: don't read maxlvt before checking if APIC is mapped

Cliff Cai (1):
      Blackfin arch: enable a choice to provide 4M DMA memory

Cyrill Gorcunov (2):
      module loading ELF handling: use SELFMAG instead of numeric constant
      ecryptfs: fix missed mutex_unlock

Dan Williams (1):
      md: notify userspace on 'stop' events

Darrick J. Wong (2):
      i5k_amb: support Intel 5400 chipset
      ibmaem: new driver for power/energy/temp meters in IBM System X hardware

Dave Airlie (1):
      Revert "drm/vbl rework: rework how the drm deals with vblank."

Dave Jones (2):
      [CPUFREQ] Remove documentation of removed ondemand tunable.
      [CIFS] Fix reversed memset arguments

Dave Olson (1):
      IB/mad: Fix kernel crash when .process_mad() returns SUCCESS|CONSUMED

David Brownell (3):
      gpio: pca953x driver handles pca9554 too
      gpio: build fixes
      spi: remove some spidev oops-on-rmmod paths

David Chinner (4):
      [XFS] Include linux/random.h in all builds, not just debug builds.
      [XFS] Fix fsync() b0rkage.
      [XFS] Don't allow memory reclaim to wait on the filesystem in inode
      [XFS] Fix inode list allocation size in writeback.

David Gibson (1):
      [POWERPC] Fix __set_fixmap() for STRICT_MM_TYPECHECKS

David S. Miller (7):
      sparc64: Add global register dumping facility.
      sunhv: Fix locking in non-paged I/O case.
      cassini: Only use chip checksum for ipv4 packets.
      xfrm_user: Remove zero length key checks.
      sparc64: Fix kernel thread stack termination.
      sparc64: Fix stack tracing through trap frames.
      sparc64: Prevent stack backtrace false positives on trap frames.

David Teigland (1):
      dlm: fix plock dev_write return value

David Woodhouse (2):
      net: Fix call to ->change_rx_flags(dev, IFF_MULTICAST) in dev_change_flags()
      libertas: Fix ethtool statistics

Denis Cheng (1):
      net/ipv4/arp.c: Use common hex_asc helpers

Denis V. Lunev (3):
      pktgen: make sure that pktgen_thread_worker has been executed
      modules: proper cleanup of kobject without CONFIG_SYSFS
      proc: proc_get_inode() should get module only once

Diego 'Flameeyes' Petteno (1):
      HID: split Numlock emulation quirk from HID_QUIRK_APPLE_HAS_FN.

Dominik Brodowski (1):
      [CPUFREQ] clarify license of freq_table.c

Dylan R Semler (1):
      HID: Add iMON LCDs to blacklist

Eric Paris (1):
      nfs/lsm: make NFSv4 set LSM mount options

Fernando Luis Vazquez Cao (1):
      for_each_online_pgdat(): kerneldoc fix

Francois Romieu (1):
      au1000_eth: remove useless check

Fred Isaman (1):
      nfs: fix race in nfs_dirty_request

Gabor Czigola (1):
      hdaps: invert the axes for HDAPS on Lenovo R61i ThinkPads

Gabriel C (2):
      [WATCHDOG] Add ICH9DO into the iTCO_wdt.c driver
      scripts/ver_linux use 'gcc -dumpversion'

Geoff Levand (1):
      [POWERPC] PS3: Fix memory hotplug

Gerrit Renker (1):
      [SC92031] Using padto turned driver into an IPv6-only interface

Greg Kroah-Hartman (14):
      Driver core: add device_create_vargs and device_create_drvdata
      mm: bdi: fix race in bdi_class device creation
      fbdev: fix race in device_create
      ide: fix race in device_create
      IB: fix race in device_create
      LEDS: fix race in device_create
      Power Supply: fix race in device_create
      UIO: fix race in device_create
      SOUND: fix race in device_create
      s390: fix race in device_create
      USB: Phidget: fix race in device_create
      USB: Core: fix race in device_create
      SCSI: fix race in device_create
      USB: add TELIT HDSPA UC864-E modem to option driver

Greg Ungerer (3):
      [ARM] 5051/1: define pgtable_t for the !CONFIG_MMU case too
      [ARM] 5052/1: export clock functions for the at91x40
      [ARM] 5053/1: define before use of processor_id

Harvey Harrison (8):
      sh: use the common ascii hex helpers
      nfs: replace remaining __FUNCTION__ occurrences
      ata: remove FIT() macro
      x86: fix integer as NULL pointer warning
      acpi: fix integer as NULL pointer warning
      isdn: fix integer as NULL pointer warning
      scsi: fix integer as NULL pointer warning
      fbdev: fix integer as NULL pointer warning

Heiko Carstens (2):
      s390: KVM guest: fix compile error
      memory hotplug: fix early allocation handling

Helmut Schaa (1):
      mac80211: fix NULL pointer dereference in ieee80211_compatible_rates

Herbert Xu (1):
      ipsec: Use the correct ip_local_out function

Hideo Saito (2):
      sh: Fix up optimized SH-4 memcpy on big endian.
      sh: Fix up thread info pointer in syscall_badsys resume path.

Huang Weiyi (1):
      Blackfin EMAC Driver: Removed duplicated include <linux/ethtool.h>

Hugh Dickins (1):
      x86: strengthen 64-bit p?d_bad()

Ignacio García Pérez (1):
      serial: support for InstaShield IS-400 four port RS-232 PCI card

Igor Mammedov (4):
      Fixed DFS code to work with new 'build_path_from_dentry', that returns full path if share in the dfs, now.
      CIFSGetDFSRefer cleanup + dfs_referral_level_3 fixed to conform REFERRAL_V3 the MS-DFSC spec.
      Fix possible access to undefined memory region.
      Adds username in the upcall key for unattended mounts with keytab

Ilpo Järvinen (3):
      tcp: Make prior_ssthresh a u32
      hamradio/scc: add missing block braces to multi-statement if
      s2io: add missing block braces to multistatement if statement

Ingo Molnar (3):
      USB: build fix
      namespacecheck: automated fixes
      x86: prevent PGE flush from interruption/preemption

Ivo van Doorn (1):
      mac80211: Add RTNL version of ieee80211_iterate_active_interfaces

J. Bruce Fields (2):
      nfsd: reorder printk in do_probe_callback to avoid use-after-free
      svcrpc: fix proc/net/rpc/auth.unix.ip/content display

Jack Morgenstein (1):
      IPoIB: Test for NULL broadcast object in ipiob_mcast_join_finish()

James Chapman (1):
      l2tp: avoid skb truesize bug if headroom is increased

Jan Beulich (1):
      x86/xen: fix arbitrary_virt_to_machine()

Jan Blunck (2):
      nfs: path_{get,put}() cleanups
      Don't clean bounds.h and asm-offsets.h

Javier Herrero (2):
      8250 Serial Driver: Added support for 8250-class UARTs in HV Sistemas H8606 board
      Blackfin serial driver: add extra IRQ flag for 8250 serial driver

Jay Fenlason (1):
      firewire: prevent userspace from accessing shut down devices

Jean Delvare (1):
      [GFS2] Prefer strlcpy() over snprintf()

Jeff Garzik (1):
      drivers/ata: trim trailing whitespace

Jeff Layton (4):
      [CIFS] CIFS currently allows for permissions to be changed on files, even
      fix memory leak in CIFSFindNext
      clarify return value of cifs_convert_flags()
      add function to convert access flags to legacy open mode

Jeremy Fitzhardinge (8):
      x86: define PTE_MASK in a universally useful way
      x86: fix warning on 32-bit non-PAE
      x86: rearrange __(VIRTUAL|PHYSICAL)_MASK
      x86: use PTE_MASK in 32-bit PAE
      x86: use PTE_MASK in pgtable_32.h
      x86: clarify use of _PAGE_CHG_MASK
      x86: use PTE_MASK rather than ad-hoc mask
      xen: use PTE_MASK in pte_mfn()

Jesse Barnes (3):
      drm/i915: fix off by one in VGA save/restore of AR & CR regs.
      PCI: correct mailing list address
      remove debug printk from DRM suspend path

Jike Song (1):
      .gitignore: match ncscope.out

Jiri Slaby (1):
      i2c: Align i2c_device_id

Joe Perches (1):
      drivers/net/ehea - remove unnecessary memset after kzalloc

Johannes Berg (1):
      mac80211: don't claim iwspy support

Johannes Weiner (1):
      mm: don't drop a partial page in a zone's memory map size

Jordan Crouse (1):
      [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers

Josh Boyer (1):
      [POWERPC] 4xx: Workaround for CHIP_11 Errata

Julia Lawall (1):
      drivers/net/fs_enet: remove null pointer dereference

Karel Zak (1):
      MAINTAINERS: add util-linux-ng package

Kazunori MIYAZAWA (1):
      af_key: Fix selector family initialization.

Keith Packard (1):
      drm/i915: save and restore dsparb and d_state registers.

Komuro (2):
      xirc2ps_cs: re-initialize the multicast address in do_reset
      fmvj18x_cs: add NextCom NC5310 rev B support

Krzysztof Halasa (2):
      WAN: protect Cisco HDLC state changes with a spinlock.
      WAN: protect HDLC proto list while insmod/rmmod

Kumar Gala (5):
      lmb: Fix compile warning
      [POWERPC] Remove generated files on make clean
      [POWERPC] Update arch/powerpc/boot/.gitignore
      [POWERPC] Fix mpc8377_mds.dts DMA nodes to match spec
      edac: mpc85xx: fix building as a module

Lennert Buytenhek (1):
      USB: ehci-orion: the Orion EHCI root hub does have a Transaction Translator

Leonardo Potenza (1):
      dlm: section mismatch warning fix

Linus Torvalds (1):
      Linux 2.6.26-rc4

Maciej W. Rozycki (1):
      PHYLIB: Kconfig: Fix the dependency on S390

Magnus Damm (5):
      sh: fix USBF resource for sh7722
      sh: fix VPU interrupt vector for sh7723
      sh: add probe support for new sh7723 cut
      sh: use sm501 8250 mfd support on r2d boards
      sh: update Migo-R defconfig

Marc Pignat (1):
      at91_mci: minor cleanup

Marcelo Tosatti (3):
      KVM: PIT: take inject_pending into account when emulating hlt
      KVM: Fix kvm_vcpu_block() task state race
      KVM: LAPIC: ignore pending timers if LVTT is disabled

Marcin Krol (1):
      brd: don't show ramdisks in /proc/partitions

Marcin Slusarz (4):
      [CIFS] CIFSSMBPosixLock should return -EINVAL on error
      isdn/capi: Return proper errnos on module init.
      dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL
      ntfs: le*_add_cpu conversion

Mariusz Kozlowski (2):
      fix parenthesis in include/asm-mips/gic.h
      fix parenthesis in include/asm-mips/mach-au1x00/au1000.h

Mark Asselstine (1):
      hysdn: Remove cli()/sti() calls.

Mark Langsdorf (1):
      [CPUFREQ] powernow-k8: improve error messages

Mark Lord (10):
      sata_mv: always do softreset
      sata_mv: fis irq register fixes
      sata_mv: group genIIe flags
      sata_mv: async notify for genIIe only
      sata_mv: don't blindly enable IRQs
      sata_mv: consolidate main_irq_mask updates
      sata_mv: fix pmp drives not found
      sata_mv: disregard masked irqs
      sata_mv: cache main_irq_mask register in hpriv
      sata_mv: ensure empty request queue for FBS-NCQ EH

Masakazu Mokuno (1):
      wireless: Create 'device' symlink in sysfs

Masatake YAMATO (1):
      kbuild: escape meta characters in regular expression in make TAGS

Mathieu Chouquet-Stringer (1):
      hostap: fix "registers" registration in procfs

Matteo Croce (1):
      cpmac bugfixes and enhancements

Matthew Garrett (1):
      Fixups to ATA ACPI hotplug

Matthias Kaehlcke (1):
      dlm: convert connections_lock in a mutex

Matti Linnanvuori (1):
      doc: add a chapter about trylock functions [Bug 9011]

Mauro Carvalho Chehab (1):
      [ALSA] hda - Fix capture mute Widget for stac9250/9251

Michael Ellerman (1):
      [POWERPC] Add kernstart_addr to list of allowed symbols in prom_init

Michael F. Robbins (1):
      USB: serial: ch341: New VID/PID for CH341 USB-serial

Michael Hennerich (5):
      Blackfin arch: Check for Anomaly 05000182
      Blackfin arch: Sync channel defines with struct dma_register dma_io_base_addr.
      Blackfin arch: Add workaround to read edge triggered GPIOs
      Blackfin arch: IO Port functions to read/write unalligned memory
      Blackfin arch: update boards defconfig files

Michael Krufky (1):
      tuner: Do not alter i2c_client.name

Mikael Pettersson (3):
      sata_promise: fix irq clearing buglets
      sata_promise: mmio access cleanups
      sata_promise: other cleanups

Mike Frysinger (5):
      [Blackfin] arch: rename bf5xx-flash to bfin-async-flash
      atm: Cleanup atm_tcp.h and atm.h for userspace.
      Blackfin arch: cleanup the icplb/dcplb multiple hit checks
      Blackfin SPORTS UART Driver: converting BFIN->BLACKFIN
      [WATCHDOG] Blackfin Watchdog Driver: split platform device/driver

Miklos Szeredi (1):
      fuse: fix bdi naming conflict

MinChan Kim (1):
      slob: Fix to return wrong pointer

Mingarelli, Thomas (1):
      [WATCHDOG] hpwdt: Fix NMI handling.

NeilBrown (4):
      md: fix possible oops when removing a bitmap from an active array
      md: raid1: Fix restoration of bio between failed read and write.
      md: notify userspace on 'write-pending' changes to array_state
      md: restart recovery cleanly after device failure.

Nick Piggin (1):
      mm: allow pfnmap ->fault()s

Oleg Nesterov (3):
      signals: fix sigqueue_free() vs __exit_signal() race
      posix timers: sigqueue_free: don't free sigqueue if it is queued
      posix timers: discard SI_TIMER signals on exec

Oliver Neukum (2):
      USB: CDC WDM driver
      rtl8187: resource leak in error case

Patrick McHardy (5):
      net_sched: cls_api: fix return value for non-existant classifiers
      vlan: Correctly handle device notifications for layered VLAN devices
      [VLAN]: Propagate selected feature bits to VLAN devices
      netfilter: Move linux/types.h inclusions outside of #ifdef __KERNEL__
      vlan: Use bitmask of feature flags instead of seperate feature bits

Paul E. McKenney (1):
      list_for_each_rcu must die: audit

Paul Gortmaker (1):
      phylib: do EXPORT_SYMBOL on get_phy_id

Paul Mackerras (1):
      [POWERPC] Update defconfigs for desktop/server systems

Paul Mundt (5):
      sh: display boot params by default on entry.
      sh: disable initrd defaults in .empty_zero_page.
      sh: Make is_valid_bugaddr() more intelligent on nommu.
      sh: Fix up restorer in debug_trap exception return path.
      sh: Drop broken URAM support on SH7723.

Pavel Roskin (2):
      hostap_cs: add ID for Conceptronic CON11CPro
      orinoco_cs: add ID for SpeedStream wireless adapters

Pekka Enberg (1):
      slub: ksize() abuse checks

Philipp Zabel (1):
      [ARM] 5043/1: pxafb: remove unused mode variable in pxafb_init_fbinfo

Pierre Ossman (1):
      mmc: mmc host test driver

Pierre Ynard (1):
      rndis_host: increase delay in command response loop

Ralph Campbell (1):
      IB/ipath: Fix UC receive completion opcode for RDMA WRITE with immediate

Rami Rosen (1):
      net: The world is not perfect patch.

Randy Dunlap (1):
      kernel-doc: allow unnamed bit-fields

Robert P. J. Day (2):
      dlm: <linux/dlm_plock.h> should be "unifdef"ed.
      ipv6: Move <linux/in6.h> from header-y to unifdef-y.

Roel Kluin (2):
      wireless, airo: waitbusy() won't delay
      gpio: mcp23s08 debug fix

Roland Dreier (4):
      IB/ipath: Fix printk format for ipath_sdma_status
      RDMA/cxgb3: Fix uninitialized variable warning in iwch_post_send()
      IB/mthca: Fix max_sge value returned by query_device
      IB/mlx4: Fix creation of kernel QP with max number of send s/g entries

Russell King (4):
      [ARM] omap: fix omap clk support build errors
      Revert "[ARM] pxa: spitz wants PXA27x UDC definitions"
      [ARM] fix OMAP include loops
      [ARM] integrator: fix build warnings and errors

S.Çağlar Onur (1):
      Remove *.rej pattern from .gitignore

Sam Ravnborg (3):
      MAINTAINERS: document names of new kbuild trees
      kbuild: filter away debug symbols from kernel symbols
      Kconfig: introduce ARCH_DEFCONFIG to DEFCONFIG_LIST

Samuel Tardieu (3):
      [WATCHDOG] Make w83697h_wdt void-like functions void
      [WATCHDOG] Make w83697h_wdt timeout option string similar to others
      [WATCHDOG] Add w83697h_wdt early_disable option

Shi Weihua (1):
      sys_prctl(): fix return of uninitialized value

Sonic Zhang (1):
      pata-bf54x: Set ATAPI HSM to control IDE device terminate sequence.

Sreenivasa Honnur (3):
      S2io: Move all the transmit completions to a single msi-x (alarm) vector
      S2io: Added napi support when MSIX is enabled.
      S2io: Version update for napi and MSI-X patches

Sridhar Samudrala (1):
      tcp: TCP connection times out if ICMP frag needed is delayed

Stas Sergeev (6):
      snd-pcsp: adjust help texts to frighten users
      snd-pcsp: put back the compatibility code for the older alsa-libs
      snd-pcsp: depend on CONFIG_EXPERIMENTAL
      snd-pcsp: silent misleading warning
      snd-pcsp: use HRTIMER_CB_SOFTIRQ
      [ALSA] snd-pcsp - fix pcsp_treble_info() to honour an item number

Stefan Richter (1):
      ieee1394: sbp2: use correct size of command descriptor block

Stephen Hemminger (5):
      net: handle errors from device_rename
      sysfs: remove error messages for -EEXIST case
      bonding: handle case of device named bonding_master
      sky2: restore vlan acceleration on reset
      sb1250: use netdev_alloc_skb

Stephen Rothwell (2):
      [POWERPC] mpic: Fix use of uninitialized variable
      [POWERPC] iSeries: Remove unused mail address

Steve French (14):
      [CIFS] cleanup old checkpatch warnings
      [CIFS] don't explicitly do a FindClose on rewind when directory search has ended
      [CIFS] Fix paths when share is in DFS to include proper prefix
      [CIFS] suppress duplicate warning
      [CIFS] BKL-removal: convert CIFS over to unlocked_ioctl
      [CIFS] Finishup DFS code
      [CIFS] enable parsing for transport encryption mount parm
      [CIFS] Add missing defines for DFS
      [CIFS] add more complete mount options to cifs_show_options
      [CIFS] add missing seq_printf to cifs_show_options for hard mount option
      [CIFS] Enable DFS support for Unix query path info
      [CIFS] Enable DFS support for Windows query path info
      [CIFS] Remove debug statement
      [CIFS] Remove redundant NULL check

Steve Grubb (1):
      open sessionid permissions

Steve Wise (1):
      MAINTAINERS: Add cxgb3 and iw_cxgb3 NIC and iWARP driver entries

Takashi Iwai (3):
      [ALSA] hda - Fix ALC262 fujitsu model
      [ALSA] hda - Fix noise on VT1708 codec
      [ALSA] hda - Fix COEF and EAPD in ALC889 auto-configuration mode

Tejun Heo (10):
      libata: fix sata_link_hardreset() @online out parameter handling
      libata: reorganize ata_eh_reset() no reset method path
      libata: move reset freeze/thaw handling into ata_eh_reset()
      libata: kill hotplug related race condition
      libata: ignore recovered PHY errors
      libata: increase PMP register access timeout to 3s
      libata: make sure PMP notification is turned off during recovery
      libata: don't schedule LPM action seperately during probing
      sata_sil24: don't use NCQ if marvell 4140 PMP is attached
      libata: ignore SIMG4726 config pseudo device

Thomas Gleixner (3):
      x86: fix setup of cyc2ns in tsc_64.c
      x86: distangle user disabled TSC from unstable
      x86: disable TSC for sched_clock() when calibration failed

Thomas Graf (1):
      netlink: Fix nla_parse_nested_compat() to call nla_parse() directly

Thomas Hellstrom (1):
      drm: disable tasklets not IRQs when taking the drm lock spinlock

Thomas Kunze (1):
      [ARM] 5025/2: fix collie cpu initialisation

Tobias Diedrich (1):
      [netdrvr] forcedeth: Restore multicast settings on resume

Tom Tucker (23):
      svc: Remove extra check for XPT_DEAD bit in svc_xprt_enqueue
      svc: Remove unused header files from svc_xprt.c
      svcrdma: Simplify receive buffer posting
      svcrdma: Fix race with dto_tasklet in svc_rdma_send
      svcrdma: Fix return value in svc_rdma_send
      svcrdma: Add put of connection ESTABLISHED reference in rdma_cma_handler
      svcrdma: Free context on ib_post_recv error
      svcrdma: Free context on post_recv error in send_reply
      svcrdma: Fix error handling during listening endpoint creation
      svcrdma: Return error from rdma_read_xdr so caller knows to free context
      svcrdma: Remove unused READ_DONE context flags bit
      svcrdma: Simplify RDMA_READ deferral buffer management
      svcrdma: Use standard Linux lists for context cache
      svcrdma: Shrink scope of spinlock on RQ CQ
      svcrdma: Move destroy to kernel thread
      svcrdma: Add reference for each SQ/RQ WR
      svcrdma: Move the QP and cm_id destruction to svc_rdma_free
      svcrdma: Cleanup queued, but unprocessed I/O in svc_rdma_free
      svcrdma: Use ib verbs version of dma_unmap
      svcrdma: Set rqstp transport address in rdma_read_complete function
      svcrdma: Copy transport address and arm CQ before calling rdma_accept
      svcrdma: Change svc_rdma_send_error return type to void
      svcrdma: Verify read-list fits within RPCSVC_MAXPAGES

Tony Camuso (1):
      PCI: Correct last two HP entries in the bfsort whitelist

Tony Lindgren (2):
      mmc: Fix omap compile by replacing dev_name with dma_dev_name
      [ARM] 5038/1: ARM: OMAP: Remove tsc2102 references from board-palmte.c

Travis Place (3):
      [ALSA] hda - Fix ASUS P5GD1 model
      [ALSA] hda - Add model for ASUS P5K-E/WIFI-AP
      [ALSA] hda - Added support for Foxconn P35AX-S mainboard

Trent Piepho (1):
      gpiolib: fix off by one errors

Trond Myklebust (3):
      NFS: Ensure that 'noac' and/or 'actimeo=0' turn off attribute caching
      NFSv4: Check the return value of decode_compound_hdr_arg()
      SUNRPC: AUTH_SYS "machine creds" shouldn't use negative valued uid/gid

WANG Cong (2):
      [Patch] fs/binfmt_elf.c: fix a wrong free
      [Patch] fs/binfmt_elf.c: fix wrong return values

Wang Chen (3):
      VIRTIO: Use __skb_queue_purge()
      NETFRONT: Use __skb_queue_purge()
      3C509: rx_bytes should not be increased when alloc_skb failed

Xiantao Zhang (3):
      KVM: ia64: Define new kvm_fpreg struture to replace ia64_fpreg
      KVM: ia64: fix GVMM module including position-dependent objects
      KVM: ia64: Set KVM_IOAPIC_NUM_PINS to 48

Xiaofan Chen (1):
      HID: add Microchip PICKit 1 and PICkit 2 to blacklist

YOSHIFUJI Hideaki (4):
      ndisc: Add missing strategies for per-device retrans timer/reachable time settings.
      ipv6 addrconf: Fix route lifetime setting in corner case.
      ipv6 route: Fix lifetime in netlink.
      ipv6 addrconf: Allow infinite prefix lifetime.

Yoshihiro Shimoda (1):
      sh: fix sh7785 master clock value

Zhang Wei (1):
      fsldma: update the fsldma driver MAINTAINERS info

karl beldan (1):
      USB: pxa27x_udc - Fix Oops

maximilian attems (2):
      [CPUFREQ] Crusoe: longrun cpufreq module reports false min freq
      types.h: don't expose struct ustat to userspace
