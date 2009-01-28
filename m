Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZA1TmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZA1TmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZA1Tlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:41:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZA1Tlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:41:44 -0500
Date: Wed, 28 Jan 2009 11:41:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29-rc3
Message-ID: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there, and while it's a bit larger than I'd wish for, that size 
is pretty understandable considering that it's closer to two weeks than 
one in between -rc2 and -rc3 (due to LCA, obviously).

And it isn't really _that_ big: part of the reason it looks bigger as a 
traditional patch (which is what I upload when I upload patches) than it 
really is due to a lot of m68k include file renames, so if you look at the 
git rename-aware patches it all actually looks much smaller.

About a quarter of it is arch updates (of which a third is ppc defconfig 
updates): mainly sh, arm and m68k. Almost another quarter is some 
filesystem updates, but the bulk of that is literally just splitting up 
the core fs Kconfig file and moving out the filesystem config information 
into the individual filesystems. With some xfs updates to round it all up.

And half (which is pretty much "the rest" for you guys keeping count) is 
driver updates. As usual. USB and the dmaengine code dominates in pure 
lines, but there's a couple of new drivers like the i.MX31 framebuffer 
thing etc.

But the most interesting part (at least for me) of the driver update is 
likely the continued fixing of the PCI suspend/resume handling, which for 
me now finally results in a _reliable_ suspend/resume on one of my laptops 
(admittedly I still have an X problem, but the discussions on the exact 
way to fix that are still on-going, and it's technically a userlevel 
problem that will likely result in a kernel change just to make the DRI 
interfaces not be as fragile).

We have historically been in a situation where suspend/resume often works, 
but may not be reliable due to interrupt timings, especially if there are 
any shared interrupts going on between drivers. We already had some parts 
of the suspend/resume changes in -rc1, but I hope it's approaching more 
stability now.

[ In the longer run, the changes will also allow us to simplify a lot of 
  device drivers thanks to the code PCI driver code doing more of it for 
  us, but that's a largely independent later cleanup issue. ]

The thing about suspend/resume though is that partly exactly _because_ 
it's been very fragile historically (a driver may have been totally solid 
on one machine for example, but flaky on another due to different 
interrupt configuration), I'm not going out on much of a limb when I say 
that we'll really need user feedback on any drivers that now don't 
suspend/resume cleanly.

So please, people - especially if you use suspend/resume, we want to hear 
about regressions, and will need to know what hardware and drivers you 
have active. Hearing about success stories is obviously always fun, but 
it's the regressions that we really want to track.

			Linus
---

Abbas, Mohamed (1):
      iwlwifi: fix rs_get_rate WARN_ON()

Adrian Bunk (3):
      m68knommu: set NO_DMA
      m68knommu: remove obsolete and unused eLIA board
      m68knommu: remove the no longer used PCI support option

Adrian McMenamin (1):
      dma-coherent: per-device coherent area is in pages, not bytes.

Ajay Kumar Gupta (1):
      USB: musb free_irq bugfix

Alan Cox (1):
      USB: cdc-acm: Add another conexant modem to the quirks

Alan Stern (3):
      USB: fix toggle mismatch in disable_endpoint paths
      USB: don't enable wakeup by default for PCI host controllers
      USB: fix char-device disconnect handling

Alex Williamson (1):
      virtio_net: Fix MAX_PACKET_LEN to support 802.1Q VLANs

Alex.Cheng@quantatw.com (1):
      USB: option: add QUANTA HSDPA Data Card device ids

Alexey Dobriyan (37):
      fs/Kconfig: move reiserfs out
      fs/Kconfig: move jfs out
      fs/Kconfig: move ocfs2 out
      fs/Kconfig: move btrfs out
      fs/Kconfig: move autofs, autofs4 out
      fs/Kconfig: move fuse out
      fs/Kconfig: move iso9660, udf out
      fs/Kconfig: move fat out
      fs/Kconfig: move ntfs out
      fs/Kconfig: move sysfs out
      fs/Kconfig: move configfs out
      fs/Kconfig: move adfs out
      fs/Kconfig: move affs out
      fs/Kconfig: move ecryptfs out
      fs/Kconfig: move hfs, hfsplus out
      fs/Kconfig: move befs out
      fs/Kconfig: move bfs out
      fs/Kconfig: move efs out
      fs/Kconfig: move cramfs out
      fs/Kconfig: move squashfs out
      fs/Kconfig: move vxfs out
      fs/Kconfig: move minix out
      fs/Kconfig: move omfs out
      fs/Kconfig: move hpfs out
      fs/Kconfig: move qnx4 out
      fs/Kconfig: move romfs out
      fs/Kconfig: move sysv out
      fs/Kconfig: move ufs out
      fs/Kconfig: move nfs out
      fs/Kconfig: move nfsd out
      fs/Kconfig: move sunrpc out
      fs/Kconfig: move smbfs out
      fs/Kconfig: move the rest of ncpfs out
      fs/Kconfig: move coda out
      fs/Kconfig: move afs out
      fs/Kconfig: move 9p out
      Fix longstanding "error: storage size of '__mod_dmi_device_table' isn't known"

Anand Gadiyar (1):
      ARM: OMAP: Fix DMA CCR programming for request line > 63, v3

Andi Kleen (3):
      x86, generic: mark complex bitops.h inlines as __always_inline
      kbuild: print usage with no arguments in scripts/config
      x86: use early clobbers in usercopy*.c

Andreas Schwab (1):
      ide: fix IDE PMAC breakage

Andrew Lunn (1):
      USB: CDC-ACM quirk for MTK GPS

Andrew Morton (1):
      mlx4_core: Fix min() warning

Andrew Vasquez (8):
      [SCSI] qla2xxx: Simplify sector-mask calculation in preparation for larger flash parts.
      [SCSI] qla2xxx: Ensure RISC-interrupt-enabled consistency for IS_NOPOLLING_TYPE() ISPs.
      [SCSI] qla2xxx: Always serialize mailbox command execution.
      [SCSI] qla2xxx: Modify firmware-load order precedence for ISP81XX parts.
      [SCSI] qla2xxx: Correct endianness issue during flash manipulation.
      [SCSI] qla2xxx: Correct regression in EH abort handling.
      [SCSI] qla2xxx: Correct regression in DMA-mask setting prior to allocations.
      [SCSI] qla2xxx: Update version number to 8.03.00-k2.

Andrey Borzenkov (1):
      orinoco: move kmalloc(..., GFP_KERNEL) outside spinlock in orinoco_ioctl_set_genie

Andrey Yurovsky (1):
      libertas: Fix alignment issues in libertas core

Anirban Chakraborty (1):
      [SCSI] qla2xxx: Fix memory leak in error path

Anton Vorontsov (3):
      phylib: Fix oops in suspend/resume paths
      gianfar: Revive VLAN support
      USB: Driver for Freescale QUICC Engine USB Host Controller

Artur Skawina (1):
      p54: set_tim must be atomic.

Arun KS (1):
      ARM: OMAP: Fix OSK ASoC by registering I2C board info for tlvaic23

Atsushi Nemoto (1):
      dmatest: Use custom map/unmap for destination buffer

Ben Greear (1):
      vlan: Export symbols as non GPL symbols.

Ben Nizette (1):
      ASoC: atmel_pcm: Remove non-existant header

Brandon Philips (1):
      USB: usblp.c: add USBLP_QUIRK_BIDIR to Brother HL-1440

Brian Cavagnolo (1):
      mac80211: decrement ref count to netdev after launching mesh discovery

Brian King (1):
      [SCSI] ibmvfc: Fix DMA mapping leak on memory allocation failure

Brice Goglin (1):
      myri10ge: don't forget pci_disable_device()

Bryan Wu (2):
      USB: composite: Fix bug: should test set_alt function pointer before use it
      USB: composite: Fix bug: low byte of w_index is the usb interface number not the whole 2 bytes of w_index

Casey Schaufler (1):
      smackfs load append mode fix

Chr (1):
      p54: add missing break in eeprom parser

Christian Borntraeger (1):
      [CVE-2009-0029] sparc: Enable syscall wrappers for 64-bit

Christian Eggers (1):
      usb/mcs7830: Don't use buffers from stack for USB transfers

Christian Lamparter (6):
      p54: fix oops caused by bad eeproms
      p54: fix p54_set_key's return code
      mac80211: fix slot time debug message
      p54: more cryptographic accelerator fixes
      p54usb: fix nasty use after free
      p54usb: fix packet loss with first generation devices

Christoph Hellwig (7):
      xfs: fix dentry aliasing issues in open_by_handle
      xfs: use mnt_want_write in compat_attrmulti ioctl
      xfs: add a separate lock class for the per-mount list of dquots
      xfs: lockdep annotations for xfs_dqlock2
      xfs: add a lock class for group/project dquots
      xfs: fix bad_features2 fixups for the root filesystem
      xfs: sanity check attr fork size

Clemens Ladisch (3):
      sound: virtuoso: enable UART on Xonar HDAV1.3
      sound: virtuoso: add newline
      sound: virtuoso: document HDAV1.3 driver status

Cliff Wickman (1):
      x86, UV: cpu_relax in uv_wait_completion

Dan Carpenter (1):
      fuse: fix NULL deref in fuse_file_alloc()

Dan Magenheimer (1):
      xen: actually release memory when shrinking domain

Dan Williams (3):
      fsldma: use a valid 'device' for dma_pool_create
      dmaengine: kill some dubious WARN_ONCEs
      dmaengine: dma_issue_pending_all == nop when CONFIG_DMA_ENGINE=n

Daniele Venzano (1):
      isdn: Fix missing ifdef in isdn_ppp

Dave Airlie (2):
      drm: fix leak of device mappings since multi-master changes.
      i915: fix freeing path for gem phys objects.

Dave Chinner (1):
      Long btree pointers are still 64 bit on disk

David Brownell (6):
      drivers/ide/palm_bk3710.c buildfix
      [ARM] 5368/1: arch/arm/mach-davinci/usb.c buildfix
      USB: omap1 ohci buildfix (otg related)
      USB: musb davinci buildfix
      USB: musb_hdrc: another davinci buildfix (otg related)
      USB: musb: Kconfig fix

David Daney (2):
      Make irq_*_affinity depend on CONFIG_GENERIC_HARDIRQS too.
      cpumask fallout: Initialize irq_default_affinity earlier

David S. Miller (4):
      sparc64: Initialize FHC/CLOCK LED platform_device 'id' field correctly.
      sparc64: Annotate sparc64 specific syscalls with SYSCALL_DEFINEx()
      sparc64: Fix DAX handling via userspace access from kernel.
      Revert "xfrm: For 32/64 compatability wrt. xfrm_usersa_info"

David Teigland (1):
      dlm: fix plock notify callback to lockd

Dhananjay Phadke (2):
      netxen: fix vlan tso/checksum offload
      netxen: reduce memory footprint

Divy Le Ray (1):
      cxgb3: Fix LRO misalignment

Don Skidmore (2):
      ixgbe: fix dca issue with relaxed ordering turned on
      ixgbe: fix tag stripping for VLAN ID 0

Eilon Greenstein (22):
      bnx2x: Free IRQ
      bnx2x: Handling probe failures
      bnx2x: Potential race after iSCSI boot
      bnx2x: Wrong HDR offset in CAM
      bnx2x: Read chip ID
      bnx2x: Block nvram access when the device is inactive
      bnx2x: Overstepping array bounds
      bnx2x: 1G-10G toggling race
      bnx2x: Prevent self test loopback failures
      bnx2x: Legacy speeds autoneg failures
      bnx2x: Handling PHY FW load failure
      bnx2x: Driver description update
      bnx2x: Barriers for the compiler
      bnx2x: Version update
      bnx2x: Reset HW before use
      bnx2x: Disable napi
      bnx2x: Handling load failures
      bnx2x: Carrier off first call
      bnx2x: Calling napi_del
      bnx2x: Missing rmb when waiting for FW response
      bnx2x: loopback test failure
      bnx2x: Version

Eric Anholt (3):
      drm: stash AGP include under the do-we-have-AGP ifdef
      x86: work around PAGE_KERNEL_WC not getting WC in iomap_atomic_prot_pfn.
      drm: Rip out the racy, unused vblank signal code.

Eric Paris (1):
      tty_open can return to userspace holding tty_mutex

Eric Sandeen (1):
      [XFS] Remove the rest of the macro-to-function indirections.

Gabriel Paubert (1):
      mv643xx_eth: prevent interrupt storm on ifconfig down

Gary Hade (1):
      x86: remove kernel_physical_mapping_init() from init section

Gerhard Pircher (1):
      powerpc/mm: Fix handling of _PAGE_COHERENT in BAT setup code

Grant Erickson (1):
      powerpc/4xx: DTS: Add Add'l SDRAM0 Compatible and Interrupt Info

Greg Kroah-Hartman (1):
      sysfs: fix problems with binary files

Greg Ungerer (4):
      m68knommu: fix cache flushing for the 527x ColdFire processors
      m68knommu: remove the obsolete and long unused comempci chip support
      m68knommu: fix syscall restarting
      uclinux: add process name to allocation error message

Guennadi Liakhovetski (3):
      dmaengine: add async_tx_clear_ack() macro
      i.MX31: Image Processing Unit DMA and IRQ drivers
      i.MX31: framebuffer driver

H. Peter Anvin (2):
      x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>
      x86: unmask CPUID levels on Intel CPUs

Harvey Harrison (1):
      m68k{nommu}: fixups after the header move

Heiko Carstens (4):
      [S390] personality: fix personality loss on execve
      [S390] cputime: fix lowcore initialization on cpu hotplug
      [S390] etr/stp: fix possible deadlock
      lcs: fix compilation for !CONFIG_IP_MULTICAST

Henrik Kretzschmar (1):
      sound: Remove removed OSS kernel parameters from doc

Herbert Xu (6):
      crypto: authenc - Fix zero-length IV crash
      net: Add debug info to track down GSO checksum bug
      gro: Fix handling of complete checksums in IPv6
      gro: Fix error handling on extremely short frags
      gro: Fix merging of paged packets
      crypto: blkcipher - Fix WARN_ON handling in walk_done

Hidetoshi Seto (1):
      PCI/MSI: bugfix/utilize for msi_capability_init()

Hin-Tak Leung (1):
      zd1211rw: adding Sitecom WL-603 (0df6:0036) to the USB id list

Huang Weiyi (1):
      ARM: OMAP: remove duplicated #include's

Hugo Villeneuve (1):
      USB: musb cppi bugfixes

Ian Campbell (2):
      xen: handle highmem pages correctly when shrinking a domain
      xen: unitialised return value in xenbus_write_transaction

Ihar Hrachyshka (1):
      MIPS: enable serial UART support on PNX833X devices.

Inaky Perez-Gonzalez (3):
      wimax/i2400m: error paths that need to free an skb should use kfree_skb()
      debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n
      USB: add kernel-doc for wusb_dev in struct usb_device

Ingo Molnar (5):
      x86, cpufreq: remove leftover copymask_copy()
      fix: crash: IP: __bitmap_intersects+0x48/0x73
      Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
      x86: use standard PIT frequency
      x86: unmask CPUID levels on Intel CPUs, fix

Ivo van Doorn (1):
      rt2x00: Fix TX rate short preamble detection

J. Bruce Fields (3):
      nfs: note that CONFIG_SUNRPC_XPRT_RDMA turns on server side support too
      nfsd: fix null dereference on error path
      nfsd: fix cred leak on every rpc

James A. Treacy (1):
      USB: cdc-acm: support some gps data loggers

James Lentini (1):
      update port number in NFS/RDMA documentation

Jan Beulich (2):
      x86: avoid early crash in disable_local_APIC()
      x86: fix assumed to be contiguous leaf page tables for kmap_atomic region (take 2)

Jan Kara (2):
      quota: Improve locking
      ocfs2: Remove ocfs2_dquot_initialize() and ocfs2_dquot_drop()

Jarek Poplawski (1):
      net: Fix data corruption when splicing from sockets.

Jarkko Nikula (1):
      ARM: OMAP: Fix gpio by switching to generic gpio calls, v2

Jarod Wilson (1):
      crypto: ccm - Fix handling of null assoc data

Jaswinder Singh Rajput (1):
      time-sched.c: tick_nohz_update_jiffies should be static

Jean Delvare (5):
      i2c: Delete 10 unused driver IDs
      i2c: Delete many unused adapter IDs
      i2c: Quilt tree has moved
      eeprom: More consistent symbol names
      i2c: Warn on deprecated binding model use

Jean-Baptiste Onofre (1):
      USB: storage: support of Dane-Elec MediaTouch USB device

Jean-Christop PLAGNIOL-VILLARD (1):
      [ARM] 5370/1: at91: fix rm9200 watchdog

Jeff Layton (2):
      dlm: initialize file_lock struct in GETLK before copying conflicting lock
      nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is found

Jeff Mahoney (1):
      x86: define ARCH_WANT_FRAME_POINTERS

Jesper Nilsson (1):
      klist.c: bit 0 in pointer can't be used as flag

Jesse Barnes (6):
      drm: create mode_config idr lock
      drm/i915: remove unnecessary debug output in KMS init
      drm/i915: hook up LVDS DPMS property
      drm: don't whine about not reading EDID data
      drm/i915: Fix cursor physical address choice to match the 2D driver.
      networking: document "nc" in addition to "netcat" in netconsole.txt

Jesse Brandeburg (1):
      e1000e: workaround hw errata

Jiri Slaby (3):
      relay: fix lock imbalance in relay_late_setup_files
      PCI hotplug: fix lock imbalance in pciehp
      NET: net_namespace, fix lock imbalance

Joe Carnuccio (1):
      [SCSI] qla2xxx: Correct descriptions in flash manipulation routines.

John Adamson (1):
      m68knommu: fix ColdFire 5272 serial baud rates in mcf.c

JosephChan@via.com.tw (1):
      [libata] pata_via: support VX855, future chips whose IDE controller use 0x0571

Josh Boyer (4):
      powerpc/40x: Update PowerPC 40x defconfigs
      powerpc/44x: Update PowerPC 44x defconfigs
      powerpc/4xx: Update multi-board PowerPC 4xx defconfigs
      powerpc: Remove arch/ppc cruft from Kconfig

Jouni Malinen (2):
      ath9k: Fix an operator typo in phy rate validation
      ath9k: Fix an operator typo in REG_DOMAIN_2GHZ_MASK

Julia Lawall (2):
      arch/sh/mm: Move a dereference below a NULL test
      USB: musb uses endpoint functions

Kalle Valo (1):
      USB: musb: tusb6010 buildfix

Kay Sievers (1):
      PNP: fix broken pnp lowercasing for acpi module aliases

Krzysztof Ha³asa (1):
      net: Fix linux/if_frad.h's suitability for userspace.

Kumar Gala (7):
      powerpc/85xx: Fix typo in mpc8572ds dts
      powerpc/85xx: Update defconfigs
      powerpc/83xx: Update defconfigs
      powerpc/86xx: Update defconfigs
      powerpc/8xx: Update defconfigs
      powerpc/embedded6xx: Update defconfigs
      dmi: Fix build breakage

Kuninori Morimoto (3):
      sh: mach-migor: Add ov772x support.
      sh: mach-migor: Delete soc_camera_platform setup.
      sh: mach-migor: Add tw9910 support.

Lai Jiangshan (2):
      rcu: add __cpuinit to rcu_init_percpu_data()
      rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR

Lalit Chandivade (1):
      [SCSI] qla2xxx: Correct MSI-X vector allocation for single queue mode.

Larry Finger (1):
      rtl8187: Add termination packet to prevent stall

Lennert Buytenhek (2):
      Revert "mv643xx_eth: use longer DMA bursts".
      mv643xx_eth: fix multicast filter programming

Leonardo Potenza (1):
      x86: fix section mismatch warnings in kernel/setup_percpu.c

Li Yang (1):
      powerpc/mpc8313erdb: fix kernel panic because mdio device is not probed

Linus Torvalds (3):
      Fix annoying DRM_ERROR() string warning
      Fix "multiple definition of `debugfs_create_size_t'"
      Linux 2.6.29-rc3

Luis R. Rodriguez (3):
      cfg80211: make handle_band() and handle_channel() wiphy specific
      cfg80211: Fix regression with 11d on bands
      cfg80211: Fix parsed country IE info for 5 GHz

Luke Yelavich (1):
      ALSA: hda - add quirks for some 82801H variants to use ALC883_MITAC

Madhusudhan Chikkature (1):
      [ARM] 5369/1: omap mmc: Add new omap hsmmc controller for 2430 and 34xx, v3

Magnus Damm (4):
      sh: ap325rxa MMC support using spi_gpio and mmc_spi
      sh: Migo-R MMC support using spi_gpio and mmc_spi.
      sh: export the sh7343 JPU to user space
      sh: fix sh-sci / early printk build on sh7723

Mandeep Singh Baines (1):
      softlock: fix false panic which can occur if softlockup_thresh is reduced

Marcel Sebek (1):
      USB: 'option' driver - onda device MT503HS has wrong id

Mark Lord (5):
      sata_mv: fix 8-port timeouts on 508x/6081 chips
      sata_mv: don't read hc_irq_cause
      sata_mv: remove bogus nsect restriction
      sata_mv: msi masking fix (v2)
      sata_mv: no longer experimental (v2)

Matt Carlson (1):
      tg3: Fix firmware loading

Matt Helsley (1):
      net: Move config NET_NS to from net/Kconfig to init/Kconfig

Matt Waddel (3):
      m68knommu: add ColdFire M532x to the FEC configuration options
      m68knommu: correct the mii calculations for 532x ColdFire FEC
      m68knommu: fix 5329 ColdFire periphal addressing

Matthew Ranostay (4):
      ALSA: hda: fix invalid power mapping masks
      ALSA: hda: 83xxx port 0xe DAC selection
      ALSA: hda: revert change to 92hd83xxx power mapping
      ALSA: hda: Add STAC92HD83XXX_PWR_REF quirk

Mhayk Whandson (1):
      USB: ftdi_sio driver support of bar code scanner from Diebold

Michael Bramer (1):
      Add support for '8-port RS-232 MIC-3620 from advantech'

Michael Holzheu (2):
      [S390] fix compat sigaltstack syscall table entry
      [S390] Add missing compat system call wrappers.

Michael Schmitz (1):
      ide: fix Falcon IDE breakage

Mike Christie (2):
      [SCSI] libiscsi: fix iscsi pool leak
      [SCSI] qla4xxx: do not reuse session when connecting to different target port

Mike Frysinger (1):
      asm-sh/posix_types_{32,64}.h: drop __GLIBC__/__USE_ALL usage

Mike Travis (3):
      rcu: move Kconfig menu
      x86: put trigger in to detect mismatched apic versions
      cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Miklos Szeredi (4):
      fuse: fix missing fput on error
      fuse: fuse_fill_super error handling cleanup
      fuse: destroy bdi on umount
      fuse: fix poll notify

Oliver Neukum (2):
      USB: storage: add unusual devs entry
      USB: new id for ti_usb_3410_5052 driver

Patrick McHardy (1):
      netfilter: ctnetlink: fix scheduling while atomic

Paul Mundt (8):
      sh: Drop the BKL from sys_execve() on SH-5.
      sh: mach-x3proto: needs linux/irq.h.
      sh: sh7785lcr/highlander/hp6xx need linux/irq.h.
      sh: Kill off obsolete busses from arch/sh/Kconfig.
      serial: sh-sci: Fix up SH7720/SH7721 SCI build.
      sh: update defconfigs.
      nommu: Stub in vm_map_ram()/vm_unmap_ram()/vm_unmap_aliases().
      dma-coherent: Restore dma_alloc_from_coherent() large alloc fall back policy.

Pavel Roskin (2):
      dell_rbu: use scnprintf() instead of less secure sprintf()
      orinoco: use KERN_DEBUG for link status messages

Pete Zaitcev (1):
      USB: usbmon: Implement compat_ioctl

Peter Korsgaard (2):
      fsldma: check for NO_IRQ in fsl_dma_chan_remove()
      fsldma: print correct IRQ on mpc83xx

Peter P Waskiewicz Jr (1):
      ixgbe: Fix usage of netif_*_all_queues() with netif_carrier_{off|on}()

Peter Ujfalusi (1):
      ASoC: Add missing comma to SND_SOC_DAPM_SWITCH_E in soc-dapm.h

Peter Zijlstra (4):
      itimers: remove the per-cpu-ish-ness
      locking, hpet: annotate false positive warning
      hrtimers: fix inconsistent lock state on resume in hres_timers_resume
      x86, mm: fix pte_free()

Phil Dibowitz (3):
      USB: Remove ZTE modem from unusual_devices
      USB: unusual_dev: usb-storage needs to ignore a device
      USB: storage: Add another unusual_dev for off-by-one bug

Phil Sutter (4):
      korina: fix loop back of receive descriptors
      korina: adjust headroom for new skb's also
      korina: drop leftover assignment
      pata-rb532-cf: remove set_irq_type from finish_io

Philipp Zabel (1):
      power_supply: pda_power: Don't request shared IRQs w/ IRQF_DISABLED

Rafael J. Wysocki (8):
      PCI PM: Restore standard config registers of all devices early
      Hibernation: Introduce system_entering_hibernation
      DMI: Introduce dmi_first_match to make the interface more flexible
      SATA: Blacklisting of systems that spin off disks during ACPI power off
      SATA AHCI: Blacklist system that spins off disks during ACPI power off
      SATA Sil: Blacklist system that spins off disks during ACPI power off
      SATA PIIX: Blacklist system that spins off disks during ACPI power off
      USB: Fix suspend-resume of PCI USB controllers

Rakib Mullick (1):
      x86: fix section mismatch warning

Ramax Lo (1):
      [ARM] 5365/1: s3cmci: Use new include path of dma.h

Rami Rosen (1):
      rt2x00: fix a wrong parameter for __test_and_clear_bit() in rt2x00rfkill_free().

Randy Dunlap (2):
      kbuild: fix kbuild.txt typos
      mac80211: more kernel-doc fixes

Reinette Chatre (1):
      iwlwifi: return NETDEV_TX_OK from _tx ops

Richard Röjfors (1):
      macb: avoid lockup when TGO during underrun

Robert Jennings (1):
      powerpc/pseries: Correct VIO bus accounting problem in CMO env.

Robert Richter (1):
      oprofile: fix uninitialized use of struct op_entry

Robie Basak (1):
      USB: ftdi_sio: added Alti-2 VID and Neptune 3 PID

Roel Kluin (2):
      net/9p: fid->fid is used uninitialized
      USB: GADGET: fix !x & y

Roland Dreier (4):
      IPoIB: Fix hang in napi_disable() if P_Key is never found
      IPoIB: Fix deadlock between ipoib_open() and child interface create
      IB/mlx4: Fix memory ordering problem when posting LSO sends
      driver core: Convert '/' to '!' in dev_set_name()

Russell King (6):
      [ARM] omap: ensure OMAP drivers pass a struct device to clk_get()
      [ARM] fix StrongARM-11x0 page copy implementation
      [ARM] clkdev: fix clock matching
      [ARM] omap: watchdog: allow OMAP watchdog driver on OMAP34xx platforms
      [ARM] omap: usb: thou shalt not provide empty release functions
      [ARM] fix section-based ioremap

Rusty Russell (2):
      work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.

SUGIOKA Toshinobu (1):
      sh: fix unaligned and nonexistent address handling

Sam Ravnborg (4):
      Revert "kbuild: strip generated symbols from *.ko"
      m68k,m68knommu: merge header files
      sparc64: fix readout of cpu/fpu type
      sparc64: fix modpost failure

Sean MacLennan (1):
      powerpc/44x: Warp patches for the new NDFC driver

Sebastian Siewior (1):
      m68knommu: use one exist from execption

Seokmann Ju (1):
      [SCSI] qla2xxx: Add checks for a valid fcport in dev-loss-tmo/terminate_rport_io callbacks.

Stephen Rothwell (4):
      IB/ehca: Fix printk format warnings from u64 type change
      IB/ehca: Use consistent types for ehca_plpar_hcall9()
      powerpc: Printing fix for l64 to ll64 conversion: phyp_dump.c
      powerpc: More printing warning fixes for the l64 to ll64 conversion

Steve Glendinning (5):
      sh: convert ap325rxa platform to use smsc911x.
      sh: convert magicpanelr2 platform to use smsc911x.
      sh: convert rsk7203 to use smsc911x.
      usbnet: allow type check of devdbg arguments in non-debug build
      phy: Add suspend/resume support to SMSC PHYs

Steven Noonan (1):
      kernel/fork.c: unused variable 'ret'

Suresh Siddha (3):
      x86, pat: fix reserve_memtype() for legacy 1MB range
      x86: fix page attribute corruption with cpa()
      x86: fix PTE corruption issue while mapping RAM using /dev/mem

Swaminathan S (1):
      USB: musb cppi dma fix

Takashi Iwai (2):
      ALSA: hda - Fix (yet more) STAC925x issues
      ALSA: hda - Add model entry for HP dv4

Tejun Heo (4):
      libata-sff: fix incorrect EH message
      libata: set NODEV_HINT for 0x7f status
      sata_nv: rename nv_nf2_hardreset()
      sata_nv: fix MCP5x reset

Thomas Gleixner (1):
      debugobjects: add and use INIT_WORK_ON_STACK

Thomas Reitmayr (1):
      sata_mv: Properly initialize main irq mask

Thomas Renninger (1):
      x86: mtrr fix debug boot parameter

Timo Teras (1):
      af_key: initialize xfrm encap_oa

Timur Tabi (1):
      ASoC: fix registration of the SoC card in the Freescale MPC8610 drivers

Tomasz K (1):
      USB: cp2101 device

Tony Lindgren (7):
      ARM: OMAP: Fix compile for various McBSP
      ARM: OMAP: Fix compile for palmte
      ARM: OMAP: Fix compile for beagle
      ARM: OMAP: Fix gpio.c compile on 15xx with CONFIG_DEBUGFS
      ARM: OMAP: Fix ASoC by enabling writes to XCCR and RCCR McBSP registers, v3
      ARM: OMAP: Remove unused platform devices, v3
      ARM: OMAP: Fix compile for h3 MMC

Uwe Kleine-König (3):
      move wm8400-regulator's probe function to .devinit.text
      [NET] am79c961a: fix spin_lock usage
      Move jsm_remove_one to .devexit.text

Vegard Nossum (2):
      security: introduce missing kfree
      inotify: clean up inotify_read and fix locking problems

Vlad Yasevich (4):
      sctp: Fix crc32c calculations on big-endian arhes.
      sctp: Correctly start rtx timer on new packet transmissions.
      sctp: Properly timestamp outgoing data chunks for rtx purposes
      sctp: Fix another socket race during accept/peeloff

Vladislav Zolotarov (1):
      bnx2x: tx_has_work should not wait for FW

Wolfgang Glas (1):
      USB: cp2101: add fasttrax GPS evaluation kit vendor/product ID

Wolfram Sang (4):
      i2c: Move at24 to drivers/misc/eeprom
      i2c: Move old eeprom driver to /drivers/misc/eeprom
      spi: Move at25 (for SPI eeproms) to /drivers/misc/eeprom
      eeprom: Move 93cx6 eeprom driver to /drivers/misc/eeprom

Yossi Etigin (1):
      IPoIB: Do not print error messages for multicast join retries

Yuri Tikhonov (1):
      dmaengine: fix dependency chaining

Zhu Yi (1):
      iwlwifi: remove CMD_WANT_SKB flag if send_cmd_sync failure

roel kluin (1):
      via-velocity: fix hot spin

sware (1):
      USB: remove vernier labpro from ldusb
