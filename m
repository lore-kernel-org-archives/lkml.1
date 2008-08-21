Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYHUCwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYHUCwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYHUCwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:52:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090AbYHUCwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:52:07 -0400
Date: Wed, 20 Aug 2008 19:52:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.27-rc4
Message-ID: <alpine.LFD.1.10.0808201941490.3487@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc.

This time the diffstat is almost totally dominated by the addition of the 
musb driver that drives the MUSB and TUSB controllers integrated into 
omap2430 and davinci. That, together with the removal of the auerswald USB 
driver (replaced by libusb version) is more than half of the bulk of the 
patch, and obviously most users won't ever notice.

Apart from those bulky USB updates, there's some arch updates (blackfin 
and ia64), network and input driver updates, and an XFS and UBIFS update. 
The rest is mostly random stuff all over, probably best described by the 
appended shortlog. A number of regressions should be off the table, but 
more remain...

		Linus

---
Adrian Bunk (8):
      fix SH7705_CACHE_32KB compilation
      [netdrvr] uninline atl1e_setup_mac_ctrl()
      [ARM] Fix a pile of broken watchdog drivers
      [ARM] 5191/1: ARM: remove CVS keywords
      ath9k: work around gcc ICEs (again)
      drivers/ide/pci/: use __devexit_p()
      cleanup powerpc/include/asm/ide.h
      ide-cd: use bcd2bin/bin2bcd

Adrian Hunter (8):
      UBIFS: fix error return in failure mode
      UBIFS: ensure UBIFS switches to read-only on error
      UBIFS: make ubifs_ro_mode() not inline
      UBIFS: do not union creat_sqnum and del_cmtno
      UBIFS: fix typos in comments
      UBIFS: correct orphan deletion order
      UBIFS: correct spelling of "thrice".
      UBIFS: always set i_generation to 0

Akinobu Mita (1):
      brd: fix name argument of unregister_blkdev()

Al Viro (1):
      cramfs: fix named-pipe handling

Alan Cox (1):
      tty: remove resize window special case

Alan Stern (8):
      USB: add missing kerneldoc line for "needs_binding"
      USB: OHCI: fix system hang caused by earlier patch
      usb-serial: don't release unregistered minors
      USB: fix interface unregistration logic
      usb-storage: automatically recognize bad residues
      usb-storage: unusual_devs entries for iRiver T10 and Datafab CF+SM reader
      usb-storage: unusual_devs entry for Nokia 5300
      USB: fix compiler warning fix

Alex Nixon (1):
      x86: change init_gdt to update the gdt via write_gdt, rather than a direct write.

Alexander Beregalov (2):
      usb/core/driver: fix warning
      security.h: fix build failure

Alexander Inyukhin (1):
      cdrom: handle TOC

Alistair John Strachan (2):
      abituguru3: update MAINTAINERS
      abituguru3: prefer DMI probing to manual probing

Anders Grafström (1):
      netfilter: ipt_addrtype: Fix matching of inverted destination address type

Andi Kleen (4):
      x86/PCI: allow scanning of 255 PCI busses
      x86: Fix ioremap off by one BUG
      Move sysctl check into debugging section and don't make it default y
      x86: fix build warnings in real mode code

Andreas Herrmann (1):
      documentation: describe bootmem_debug kernel parameter

Andrew Gallatin (1):
      pktgen: prevent pktgen from using bad tx queue

Andrew Morton (5):
      Input: xilinx_ps2 - fix warning
      net/tipc/subscr.c: don't use ___constant_swab32
      lockdep: spin_lock_nest_lock(), checkpatch fixes
      kexec: use a mutex for locking rather than xchg()
      drivers/char/ipmi/ipmi_si_intf.c:default_find_bmc(): fix leak

Andrew Vasquez (6):
      [SCSI] qla2xxx: Correct synchronization of software/firmware fcport states.
      [SCSI] qla2xxx: Correct vport-state management issues during ISP-ABORT.
      [SCSI] qla2xxx: Don't leak SG-DMA mappings while aborting commands.
      [SCSI] qla2xxx: Reference proper ha during SBR handling.
      [SCSI] qla2xxx: Explicitly tear-down vports during PCI remove_one().
      [SCSI] qla2xxx: Update version number to 8.02.01-k7.

André Schenk (1):
      USB: ftdi_sio: Add USB Product Id for ELV HS485

Anton Vorontsov (1):
      rtc: rtc-ds1374: fix 'no irq' case handling

Aristeu Rozanski (2):
      x86, perfctr: don't use CCCR_OVF_PMI1 on Pentium 4Ds
      x86, NMI: fix watchdog failure message

Arjan van de Ven (2):
      x86: use WARN() in arch/x86/mm/pageattr.c
      lockdep: use WARN() in kernel/lockdep.c

Arnaldo Carvalho de Melo (1):
      dccp: change L/R must have at least one byte in the dccpsf_val field

Arnaud Patard (1):
      [ARM] S3C24XX: Fix SERIAL_SAMSUNG entry

Artem Bityutskiy (18):
      UBIFS: print volume name as well
      UBIFS: fix budgeting calculations
      UBIFS: improve debugging
      UBIFS: free budget in delete_inode as well
      UBIFS: do not write orphans back
      UBIFS: remove unneeded function parameter
      UBIFS: remove another unneeded function parameter
      UBIFS: increment commit number earlier
      UBIFS: optimize deletions
      UBIFS: improve budgeting checks
      UBIFS: align inode data to eight
      UBIFS: print pid in dump function
      UBIFS: reserve more space for index
      UBIFS: minor tweaks in commit
      UBIFS: improve arguments checking in debugging messages
      UBIFS: few commentary fixes
      UBIFS: remove unneeded check
      UBIFS: xattr bugfixes

Atsushi Nemoto (2):
      [netdrvr] ne: Use CONFIG_MACH_TX49XX
      rtc: fix double lock on UIE emulation

Bartlomiej Zolnierkiewicz (4):
      sgiioc4: fixup message on resource allocation failure
      ata: add missing ATA_ID_* defines (take 2)
      ata: add missing ATA_CMD_* defines
      ata: add missing ATA_* defines

Ben Dooks (10):
      [ARM] S3C24XX: s3c243xx_clock_register() data can be __initdata
      [ARM] CATS: Do not try and map bad PCI IRQ numbers
      [ARM] S3C24XX: Fix section mismatch for s3c_lookup_cpu
      [ARM] S3C24XX: Documentation: update platform docs
      [ARM] S3C24XX: Documentation: Update suported CPU list
      [ARM] S3C24XX: Documentation: update SD/MMC status
      [ARM] S3C24XX: Documentation: Update GPIO status
      AX88796: Fix locking in ethtool support
      s3cmci: fix sparse errors from non-exported functions
      s3cmci: attach get_cd host ops

Benjamin Herrenschmidt (2):
      powerpc: Fix loss of vdso on fork on 32-bit
      powerpc: Fix lockdep IRQ tracing bug

Benjamin Matthews (1):
      Blackfin arch: add support for the BlackStamp board

Bjorn Helgaas (1):
      ACPI: bounds check IRQ to prevent memory corruption

Bob Copeland (2):
      omfs: fix potential oops when directory size is corrupted
      omfs: fix oops when file metadata is corrupted

Bob Moore (2):
      ACPICA: Fix memory leak when deleting thermal/processor objects
      ACPICA: Additional error checking for pathname utilities

Borislav Petkov (2):
      viocd: add dummy audio ioctl handler
      gdrom: add dummy audio_ioctl handler

Brian Haley (2):
      ipv6: Fix OOPS, ip -f inet6 route get fec0::1, linux-2.6.26, ip6_route_output, rt6_fill_node+0x175
      netns: Add network namespace argument to rt6_fill_node() and ipv6_dev_get_saddr()

Brian King (9):
      [SCSI] ibmvscsi: Fixup desired DMA value for shared memory partitions
      [SCSI] ibmvfc: Fix another hang on module removal
      [SCSI] ibmvfc: Fixup host state during reinit
      [SCSI] ibmvfc: Fix for lost async events
      [SCSI] ibmvfc: Sanitize response lengths
      [SCSI] ibmvfc: Add details to async event log
      [SCSI] ibmvfc: Driver version 1.0.2
      powerpc: Fix CMM page loaning on 64k page kernel with 4k hardware pages
      powerpc: Fix vio_bus_probe oops on probe error

Brice Goglin (1):
      myri10ge: myri10ge_fw_name also overrides the rss firmware

Bruce Allan (7):
      e1000e: Return 1 instead of a non-zero value for link up indication
      e1000e: Set InterruptThrottleRate to default when invalid value used
      e1000e: Use skb_copy_to_linear_data_offset introduced in 2.6.22
      e1000e: Increase Tx timeout factor for 10Mbps
      e1000e: increase minimum frame size allowed
      e1000e: test for unusable MSI support
      e1000e: remove unnecessary snippet missed in prior check_options update

Bryan Wu (1):
      Blackfin arch: hook up some missing new system calls

Carlos Corbacho (3):
      Input: i8042 - Add Dritek quirk for Acer TravelMate 4280
      ACPI: WMI: Set instance for query block calls
      acer-wmi: Fix wireless and bluetooth on early AMW0 v2 laptops

Chandra Seetharaman (2):
      [SCSI] scsi_dh: Do not use scsilun in rdac hardware handler
      [SCSI] scsi_dh: Initialize lun_state in check_ownership()

Chris Mason (1):
      fs/inode.c: properly init address_space->writeback_index

Christian Lamparter (3):
      p54: Fix regression due to "net: Delete NETDEVICES_MULTIQUEUE kconfig option"
      p54: move p54_vdcf_init to the right place.
      p54u: reset skb's data/tail pointer on requeue

Christoph Hellwig (24):
      [XFS] don't leak m_fsname/m_rtname/m_logname
      [XFS] Remove vn_from_inode()
      [XFS] kill vn_to_inode
      [XFS] remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
      [XFS] remove remaining VN_HOLD calls
      [XFS] implement IHOLD/IRELE directly
      [XFS] kill INDUCE_IO_ERROR
      [XFS] kill xfs_lock_dir_and_entry
      [XFS] remove some easy bhv_vnode_t instances
      [XFS] kill bhv_vnode_t
      [XFS] sanitize xfs_initialize_vnode
      [XFS] small cleanups in xfs_btree.c
      [XFS] Use the same btree_cur union member for alloc and inobt trees.
      [XFS] update timestamp in xfs_ialloc manually
      [XFS] optimize xfs_ichgtime
      [XFS] stop using file_update_time
      [XFS] move root inode IRELE into xfs_unmountfs
      [XFS] cleanup xfs_mountfs
      [XFS] xfs_unmountfs should return void
      [XFS] don't call xfs_freesb from xfs_unmountfs
      [XFS] refactor xfs_mount_free
      [XFS] use KM_MAYFAIL in xfs_mountfs
      powerpc: Use generic compat_sys_old_readdir
      [IA64] use generic compat_old_sys_readdir

Clemens Ladisch (1):
      ALSA: virtuoso: add Xonar D1 support

Clement Calmels (1):
      /proc/self/maps doesn't display the real file offset

Dan Williams (1):
      md: cancel check/repair requests when recovery is needed

Daniel Lezcano (1):
      netns: Fix crash by making igmp per namespace

Darrick J. Wong (6):
      x86, msr: fix NULL pointer deref due to msr_open on nonexistent CPUs
      i5k_amb: provide labels for temperature sensors
      ibmaem: update the documentation to reflect the current name
      ibmaem: prevent infinite probing loop on x3650 M2 systems
      ibmaem: don't query the entire sensor repository when reading energy meter
      coretemp: recognize Nehalem CPUs

Dave Chinner (1):
      completions: uninline try_wait_for_completion and completion_done

Dave Jones (2):
      USB: usb-storage: quirk around v1.11 firmware on Nikon D4
      x86: silence mmconfig printk

David Brownell (9):
      USB: fix USB boot crash, ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
      USB: serial gadget: rx path data loss fixes
      usb gadget: remove needless struct members
      usb gadget: issue notifications from ACM function
      usb: cdc-acm: bugfix release()
      usb: cdc-acm: stop dropping tx buffers
      usb: cdc-acm: drain writes on close
      Kconfig: HSO driver bugfixes and updates
      spi: bugfix spi_add_device() with duplicate chipselects

David Chinner (12):
      [XFS] Use the generic bitops rather than implementing them ourselves.
      [XFS] Avoid directly referencing the VFS inode.
      [XFS] kill shouty XFS_ITOV_NULL macro
      [XFS] Kill shouty XFS_ITOV() macro
      [XFS] XFS: Kill xfs_vtoi()
      [XFS] Use KM_NOFS for incore inode extent tree allocation V2
      [XFS] clean up stale references to semaphores
      [XFS] replace the XFS buf iodone semaphore with a completion
      [XFS] extend completions to provide XFS object flush requirements
      [XFS] replace inode flush semaphore with a completion
      [XFS] replace dquot flush semaphore with a completion
      [XFS] remove the sema_t from XFS.

David Fries (1):
      x86: fix i486 suspend to disk CR4 oops

David Howells (4):
      CRED: Introduce credential access wrappers
      security: Fix setting of PF_SUPERPRIV by __capable()
      MN10300: Supply ioremap_wc() for MN10300
      FRV: Provide ioremap_wc() for FRV

David S. Miller (23):
      pkt_sched: Fix ingress deletion and filter attachment.
      sparc64: Don't MAGIC_SYSRQ ifdef smp_fetch_global_regs and support code.
      sparc64: Fix recursion in stack overflow detection handling.
      sparc64: Implement IRQ stacks.
      pkt_sched: Add queue stopped test back to qdisc_run().
      pkt_sched: Fix queue quiescence testing in dev_deactivate().
      sparc64: Handle stack trace attempts before irqstacks are setup.
      sparc64: Fix overshoot in nid_range().
      sparc64: Fix cmdline_memory_size handling bugs.
      loopback: Remove rest of LOOPBACK_TSO code.
      bnx2: Fix build with VLAN_8021Q disabled.
      lmb: Fix reserved region handling in lmb_enforce_memory_limit().
      pkt_sched: Add 'deactivated' state.
      pkt_sched: Simplify dev_deactivate() polling loop.
      pkt_sched: No longer destroy qdiscs from RCU.
      sch_prio: Use NET_XMIT_SUCCESS instead of "0" constant.
      pkt_sched: Fix missed RCU unlock in dev_queue_xmit()
      pkt_sched: Fix return value corruption in HTB and TBF.
      pkt_sched: Never schedule non-root qdiscs.
      pkt_sched: Don't hold qdisc lock over qdisc_destroy().
      Revert "pkt_sched: Protect gen estimators under est_lock."
      Revert "pkt_sched: Add BH protection for qdisc_stab_lock."
      pkt_sched: Prevent livelock in TX queue running.

David Teigland (2):
      dlm: add missing kfrees
      dlm: rename structs

David Woodhouse (3):
      Fix header export of videodev2.h, ivtv.h, ivtvfb.h
      Reduce brokenness of CRIS headers_install
      Reserve NFS fileid values for btrfs

Dhananjay Phadke (6):
      netxen: fix mac addr setup
      netxen: fix rxbuf leak across driver reload
      netxen: force link update across ifdown/ifup
      netxen: fix dma watchdog
      netxen: cleanup interrupt code
      netxen: update driver version

Dmitry Baryshkov (6):
      [ARM] 5183/2: Provide Poodle LoCoMo GPIO names
      USB: ohci: make distrust_firmware a quirk
      USB: Hook start_hnp into ohci struct
      USB: isp1301: fix compilation
      USB: omap_udc: fix compilation with debug enabled
      lockdep: fix spurious 'inconsistent lock state' warning

Dmitry Torokhov (2):
      Input: paper over a bug in Synaptics X driver
      Input: bcm5974 - implement autosuspend support

Eilon Greenstein (14):
      bnx2x: FW (bootcode) interface fixes
      bnx2x: Not dropping packets with L3/L4 checksum error
      bnx2x: FW Internal Memory structure
      bnx2x: HW attention lock
      bnx2x: Memory allocation
      bnx2x: PBA Table Page Alignment Workaround
      bnx2x: WoL capability
      bnx2x: Change GPIO for any port
      bnx2x: 1G LED does not turn off
      bnx2x: Driver info
      bnx2x: Minor code improvements
      bnx2x: Spelling mistakes
      bnx2x: Checkpatch compliance
      bnx2x: Version update

Enrico Scholz (1):
      usb: ISP1760: improve pre-fetch timing

Eric Miao (3):
      [ARM] pxafb: fix the incorrect configuration of GPIO77 as ACBIAS for TFT LCD
      [ARM] pxafb: add flag to specify output format on LDD pins when base is RGBT16
      [ARM] pxafb: fix the warning of incorrect lccr when lcd_conn is specified

Eric Sandeen (3):
      [XFS] remove INT_GET and friends
      [XFS] convert xfs to use ERR_CAST
      [XFS] remove shouting-indirection macros from xfs_trans.h

Felipe Balbi (4):
      usb: gadget: protect gadget_chips.h from been included twice
      USB: Add MUSB and TUSB support
      usb: musb: fix hanging when rmmod gadget driver
      usb: musb: pass configuration specifics via pdata

Frederik Kriewitz (1):
      USB: ftdi_sio: add support for Luminance Stellaris Evaluation/Development Kits

Geert Uytterhoeven (1):
      Input: evdev - fix printf() format for sizeof

Gerrit Renker (2):
      skbuff: Code readability NiT
      dccp: Fix panic caused by too early termination of retransmission mechanism

Graf Yang (1):
      Blackfin RTC Driver: BF561 not have on-chip RTC

Greg Kroah-Hartman (3):
      USB: serial: remove CONFIG_USB_DEBUG from sierra and option drivers
      USB: HSO: make tty_operations const
      USB: HSO: minor fixes due to code review

Guilherme M. Schroeder (1):
      applesmc: add support for Macbook

H. Peter Anvin (1):
      x86: cleanup for setup code crashes during IST probe

Harley Laue (1):
      Input: xpad - add Pelican Eclipse D-Pad to the list of devices

Harvey Harrison (1):
      [XFS] use get_unaligned_* helpers

Henrik Rydberg (1):
      Input: bcm5974 - add driver for Macbook Air and Pro Penryn touchpads

Henrique de Moraes Holschuh (1):
      rfkill: protect suspended rfkill controllers

Herbert Xu (8):
      udp: Drop socket lock for encapsulated packets
      crypto: tcrypt - Fix AEAD chunk testing
      crypto: hash - Fix digest size check for digest type
      crypto: hash - Add missing top-level functions
      ipv4: Disable route secret interval on zero interval
      loopback: Enable TSO
      net: Preserve netfilter attributes in skb_gso_segment using __copy_skb_header
      loopback: Drop obsolete ip_summed setting

Holger Macht (1):
      ACPI: Properly clear flags on false-positives and send uevent on sudden unplug

Holger Schurig (1):
      ssb: allow compilation on systems without PCI

Huang Weiyi (6):
      [ARM] JIVE: Remove duplicated mtd includes
      [netdrvr] remove unnecessary #include
      removed unused #include <version.h>
      sdricoh_cs: removed unused #include <version.h>
      Input: remove version.h from drivers that don't need it
      removed unused #include <version.h>

Huang Ying (8):
      kexec: fix compilation warning on xchg(&kexec_lock, 0) in kernel_kexec()
      kexec jump: clean up #ifdef and comments
      kexec jump: rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE
      kexec jump: check code size in control page
      kexec jump: remove duplication of kexec_restart_prepare()
      kexec jump: in sync with hibernation implementation
      kexec jump: __ftrace_enabled_save/restore
      kexec jump: fix for ftrace

Hugh Dickins (5):
      [SCSI] sd: fix USB devices incorrectly reporting DIF support
      x86: fix /proc/meminfo DirectMap
      mm: VM_flags comment fixes
      mm: page_remove_rmap comments on PageAnon
      mm: show free swap as signed

Ian Campbell (1):
      fbdefio: add set_page_dirty handler to deferred IO FB

Ilpo Järvinen (2):
      pkt_sched: remove bogus block (cleanup)
      powerpc/spufs: Remove invalid semicolon after if statement

Ingo Molnar (4):
      lockdep: build fix
      x86, nmi: clean UP NMI watchdog failure message
      x86: add MAP_STACK mmap flag
      x86: add MAP_STACK mmap flag

Jack Steiner (1):
      MAINTAINERS: add maintainers for GRU, XPC, XPNET and XP

Jamal Hadi Salim (3):
      wext: Send name on events
      net-sched: Fix actions flushing
      net-sched: fix Action flushing return code

Jan Beulich (2):
      x86: fix spin_is_contended()
      x86-64: fix overlap of modules and fixmap areas

Jarek Poplawski (7):
      pkt_sched: Add BH protection for qdisc_stab_lock.
      pkt_sched: Fix oops in htb_delete.
      pkt_sched: Protect gen estimators under est_lock.
      pkt_sched: Fix unlocking in tc_ctl_tfilter()
      net: Change handling of the __QDISC_STATE_SCHED flag in net_tx_action().
      pkt_sched: Grab correct lock in notify_and_destroy().
      pkt_sched: Add lockdep annotation for qdisc locks

Jean Delvare (1):
      hwmon-vid: Fix AMD K8 VID decoding

Jean-Christophe DUBOIS (1):
      xfrm: remove unnecessary variable in xfrm_output_resume() 2nd try

Jens Rottmann (1):
      x86, geode-mfgpt: check IRQ before using MFGPT as clocksource

Jeremy Kerr (2):
      powerpc/spufs: fix npc setting for NOSCHED contexts
      powerpc/spufs: reference context while dropping state mutex in scheduler

Jesse Brandeburg (1):
      ixgbe: add cx4 device ID

Jie Zhang (1):
      Blackfin arch: Fix bug - This change eliminates impact on application debugging

Jiri Slaby (3):
      iwlwifi: fix printk newlines
      PCI: acpi_pcihp: run _OSC on a root bridge
      PCI: add acpi_find_root_bridge_handle

Joachim Fenkes (1):
      powerpc/ibmebus: Restore "name" sysfs attribute on ibmebus devices

Jochen Friedrich (1):
      rt2x00: Fix txdone_entry_desc_flags

Joe Malicki (1):
      [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable permissions

Joerg Roedel (5):
      x86: fix setup code crashes on my old 486 box
      x86, AMD IOMMU: use status bit instead of memory write-back for completion wait
      x86, AMD IOMMU: initialize device table properly
      x86m AMD IOMMU: cleanup: replace LOW_U32 macro with generic lower_32_bits
      x86, AMD IOMMU: initialize dma_ops after sysfs registration

Johannes Weiner (2):
      x86: propagate new nonpanic bootmem macros to CONFIG_HAVE_ARCH_BOOTMEM_NODE
      bootmem: fix aligning of node-relative indexes and offsets

John Keller (1):
      x86: allow MMCONFIG above 4GB on x86_64

Jost Diederichs (1):
      USB: usb-storage Motorola Phone Razr v3xx US_FL_FIX_CAPACITY patch

Julien Brunel (1):
      net/rxrpc: Use an IS_ERR test rather than a NULL test

Jussi Kivilinna (1):
      sch_prio: Use return value from inner qdisc requeue

Ken Chen (1):
      fix setpriority(PRIO_PGRP) thread iterator breakage

Kevin Lloyd (4):
      USB Serial Sierra: clean-up
      USB Serial Sierra: Dynamic interface detection
      USB Serial Sierra: TRU-Install feature update
      USB Storage Sierra: TRU-Install feature update

Krzysztof Helt (2):
      [ARM] S3C24XX: Compilation fix if s3c2410 is not selected
      pm2fb: free cmap memory on module remove

Lachlan McIlroy (4):
      [XFS] Do not access buffers after dropping reference count
      [XFS] Fix compile failure in xfs_buf_trace()
      [XFS] Use KM_NOFS for debug trace buffers
      [XFS] Fix use after free in xfs_log_done().

Larry Finger (2):
      b43: Fix for SPROM coding error in Linksys WMP54G (BCM4306/3)
      b43: Fix for another Bluetooth Coexistence SPROM Programming error for BCM4306

Lee Nipper (1):
      crypto: talitos - Add handling for SEC 3.x treatment of link table

Lennert Buytenhek (4):
      [ARM] Move include/asm-arm/plat-orion to arch/arm/plat-orion/include/plat
      [ARM] Orion: support D0 5281 silicon
      [ARM] prevent crashing when too much RAM installed
      [ARM] Kirkwood: instantiate the orion_spi driver in the platform code

Leon Leong (1):
      USB: BandRich BandLuxe C150/C250 HSPA Data Card Driver

Lex Ross (1):
      USB: ftdi_sio: add support for PHI Fisco data cable (FT232BM based, VID/PID 0403:e40b)

Libin Yang (1):
      USB: quirk PLL power down mode

Lin Ming (1):
      ACPICA: Fix possible memory leak in Unload() operator

Linus Torvalds (6):
      Input: evdev - split EVIOCGBIT handlig into a separate function
      [h8300] move include/asm-h8300 to arch/h8300/include/asm
      alpha: move include/asm-alpha to arch/alpha/include/asm
      Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
      vfat: fix 'sync' mount deadlock due to BKL->lock_super conversion
      Linux v2.6.27-rc4

Luis R. Rodriguez (1):
      mac80211: remove kdoc references to IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE

Magnus Damm (5):
      sh: remove MSTPCR defines from Migo-R header file
      input: migor_ts compile and detection fix
      sh: export sh7723 VEU as VEU2H
      sh: select memchunk size using kernel cmdline
      video: export sh_mobile_lcdc panel size

Marc Pignat (1):
      hwmon: ADC124S501 generic driver

Marcel Holtmann (3):
      [Bluetooth] Add SCO support to btusb driver
      [Bluetooth] Fix userspace breakage due missing class links
      [Bluetooth] Consolidate maintainers information

Marcin Slusarz (13):
      x86: fix 2 section mismatch warnings - map_high()
      x86: fix 2 section mismatch warnings - find_and_reserve_crashkernel
      x86, acpi: cleanup, temp_stack is used only when CONFIG_SMP is set
      suspend: fix section mismatch warning - register_nosave_region
      x86: fix section mismatch warning - spp_getpage()
      x86, tsc: fix section mismatch warning
      x86: fix MP_processor_info section mismatch warning
      x86: mmconf: fix section mismatch warning
      x86: mpparse.c: fix section mismatch warning
      x86, percpu: silence section mismatch warnings related to EARLY_PER_CPU variables
      x86: silence section mismatch warning - get_local_pda
      x86, calgary: fix section mismatch warning - get_tce_space_from_tar
      mm: mminit_loglevel cannot be __meminitdata anymore

Marek Va¨ut (1):
      [ARM] 5198/1: PalmTX: PCMCIA fixes

Mark Brown (3):
      Input: wm97xx - enable sub-drivers by default
      ALSA: wm8990: Fix routing of left DAC to speaker mixer
      ALSA: wm8990: Implement speaker volume PGA

Mark Langsdorf (1):
      x86: invalidate caches before going into suspend

Mark McLoughlin (1):
      tun: TUNGETIFF interface to query name and flags

Martin Michlmayr (7):
      [ARM] Orion: export red SATA lights on TS-409, fix SATA presence/activity
      [ARM] Orion: use better key codes for the TS-209/TS-409 buttons
      [ARM] Orion: Export the reset button of the QNAP TS-409
      [ARM] Orion: enable KEYBOARD_GPIO in the defconfg
      [ARM] Orion: enable RTC_DRV_PCF8563 in the defconfig for HP mv2120
      [ARM] Orion: enable CONFIG_RTC_DRV_S35390A in the defconfg for QNAP devices
      Input: cobalt_btns - add missing MODULE_LICENSE

Mathieu Desnoyers (1):
      x86: correct register constraints for 64-bit atomic operations

Matt Carlson (6):
      tg3: Add APE register access locking
      tg3: Refine APE status check
      tg3: Preserve register settings for DASH
      tg3: Turn off ASF "driver alive" heartbeats for APE
      tg3: Fix firmware event timeouts
      tg3: Update version to 3.94

Matthew Garrett (1):
      eeepc-laptop: fix use after free

Max Krasnyansky (1):
      x86: resurrect proper handling of maxcpus= kernel option (v2)

Michael Borisov (1):
      drivers/hwmon/w83791d.c: fix unused var warning

Michael Chan (4):
      bnx2: Fix logic to setup VLAN rx tagging.
      bnx2: Use proper CONFIG_VLAN_8021Q to compile the VLAN code.
      bnx2: Reinsert VLAN tag when necessary.
      bnx2: Update version to 1.8.0.

Michael Ellerman (1):
      powerpc: Fix /dev/oldmem interface for kdump

Michael Hennerich (4):
      Blackfin arch: Functional power management support
      Blackfin arch: Fix Bug - System with EMAC driver enabled - Core not idling
      Blackfin arch: workaround SIC_IWR1 reset bug, by keeping MDMA0/1 always enabled in SIC_IWR1.
      Video/Framebuffer: add fuctional power management support to Blackfin BF54x LQ043 framebuffer driver

Michael Karcher (1):
      ath5k: Don't fiddle with MSI on suspend/resume.

Michael Kerrisk (1):
      Documentation/vm/page_migration: update reference to numa_maps + fix download URI

Mikael Pettersson (2):
      ixp4xx_eth: fix dma_mapping_error() compile errors
      x86: fix readb() et al compile error with gcc-3.2.3

Mike Frysinger (25):
      Blackfin arch: remove useless mtd defines in uClinux
      Blackfin arch: add board resources for parallel flash on cm-bf537
      Blackfin arch: add support for board tcm-bf537
      Blackfin arch: remove pata resources from generic board
      Blackfin arch: use symbolic IRQ_PF define rather than hardcoded
      Blackfin arch: remove support for Anomaly 05000125 as it doesnt exist on any supported processor/silicon
      Blackfin arch: unify the duplicated _real_start functions
      Blackfin arch: make sure the BSS and kernel load address are 4 byte aligned
      Blackfin arch: move async memory programming into common setup_arch() as the banks dont really need to be setup fully as early as head.S
      Blackfin arch: add asm/thread_info.h for THREAD_SIZE define
      Blackfin arch: unify the duplicated portions of __start and split mach-specific pieces into _mach_early_start where they will be easier to trim over time
      Blackfin arch: convert L2 defines to be the same as the L1 defines
      Blackfin arch: delete unused cache functions
      Blackfin arch: cleanup cache lock code
      Blackfin arch: delete dead prototypes
      Blackfin arch: mark some functions as __init as they are only called from __init functions
      Blackfin arch: move fixed code defines into fixed_code.h as very few things actually need to know these details
      Blackfin arch: shuffle related prototypes together -- no functional changes
      Blackfin arch: use %pF when printing out the double fault address so we get symbol names
      Blackfin arch: clear EMAC_SYSTAT during IRQ init rather than early head.S as we dont need it setup that early
      Blackfin arch: do not muck with the UART during boot -- let the serial driver worry about it
      Blackfin arch: fix missing digit in SCLK range checking
      Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected
      Blackfin RTC Driver: do all initialization before we register the rtc and make it available
      Blackfin RTC Driver: dont let RTC programming in bootloaders randomly cause ~5 second boot delays

Mike Hernandez (1):
      [SCSI] qla2xxx: Set npiv_supported flag for FCoE HBAs.

Mikulas Patocka (1):
      bootmem allocator: alloc_bootmem_core(): page-align the end offset

Milan Broz (1):
      ACPI: Fix thermal shutdowns

NeilBrown (6):
      Make writes to md/safe_mode_delay immediately effective.
      Restore force switch of md array to readonly at reboot time.
      Fail safely when trying to grow an array with a write-intent bitmap.
      Don't let a blocked_rdev interfere with read request in raid5/6
      Allow faulty devices to be removed from a readonly array.
      Allow raid10 resync to happening in larger chunks.

Nick Piggin (3):
      mm: dirty page tracking race fix
      mm: xip fix fault vs sparse page invalidate race
      mm: xip/ext2 fix block allocation race

Nicolas Pitre (2):
      [ARM] 5194/1: update .gitignore
      [ARM] 5196/1: fix inline asm constraints for preload

Niv Sardi (2):
      [XFS] Move attr log alloc size calculator to another function.
      [XFS] Move xfs_attr_rolltrans to xfs_trans_roll

Nobuhiro Iwamatsu (3):
      sh: Add support sh_eth to sh7763rdp board
      sh: Add support sh7760fb to sh7763rdp board
      sh: Update sh7763rdp defconfig

Oliver Martin (1):
      USB: Add vendor/product id of ZTE MF628 to option

Oliver Neukum (1):
      USB: update to Documentation

Olivier Blin (2):
      hso: fix oops in read/write callbacks
      hso: fix refcounting on the ttyHSx devices

Pablo Neira Ayuso (3):
      netfilter: ctnetlink: fix double helper assignation for NAT'ed conntracks
      netfilter: ctnetlink: fix sleep in read-side lock section
      netfilter: ctnetlink: sleepable allocation with spin lock bh

Paul Collins (1):
      powerpc/kexec: Fix up KEXEC_CONTROL_CODE_SIZE missed during conversion

Paul Mundt (2):
      sh: mach-x3proto: Fix up smc91x platform data.
      sh: Disable 64kB hugetlbpage size when using 64kB PAGE_SIZE.

Paul Walmsley (1):
      [ARM] 5192/1: ARM TLB: add v7wbi_{possible,always}_flags to {possible,always}_tlb_flags

Pavel Emelyanov (1):
      binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers

Pavel Machek (2):
      acpi: trivial cleanups
      arch/x86/Kconfig: clean up, experimental adjustement

Peter Zijlstra (2):
      sched: fix rt-bandwidth hotplug race
      sched: scale sysctl_sched_shares_ratelimit with nr_cpus

Rafael J. Wysocki (1):
      sky2: Fix suspend/hibernation/shutdown regression with WOL enabled (rev. 2)

Rami Rosen (2):
      ipv6: ip6_route.h cleanup.
      ipv6: Kill unused ip6_prohibit_entry and ip6_blk_hole_entry declarations.

Robert Fitzsimons (1):
      tlan: Fix two regressions introduced by 64bit conversion.

Robert Jennings (2):
      powerpc: Make CMO paging space pool ID and page size available
      powerpc: Add CMO enabled flag and paging space data to lparcfg

Roberto De Ioris (1):
      applesmc: support for Intel iMac

Robin Getz (4):
      Blackfin arch: be consistant with parition names, and ensure the bus is identified
      Blackfin arch: Fix bug - when expanding the trace buffer, it does not print out the decoded instruction.
      Blackfin arch: Print out doublefault addresses, so debug can occur
      Blackfin arch: Allow ins functions to have a low latency version

Robin Holt (2):
      [IA64] Remove sn2_defconfig.
      [IA64] Shrink shadow_flush_counts to a short array to save 8k of per_cpu area.

Rocky Craig (1):
      powerpc: Fix TLB invalidation on boot on 32-bit

Roland McGrath (1):
      tracehook: fix SA_NOCLDWAIT

Ron Rindjunsky (1):
      mac80211: update new sta's rx timestamp

Ruben Porras (1):
      [XFS] Make xfs_bmap_*_count_leaves void.

Russell King (5):
      [ARM] dma-mapping: improve type-safeness of DMA translations
      [ARM] dma-mapping: provide sync_range APIs
      [ARM] traps: don't call undef hook functions with spinlock held
      [ARM] add proc-macros.S include to proc-arm940 and proc-arm946
      [ARM] update mach-types

Rusty Russell (2):
      net: skb_copy_datagram_from_iovec()
      tun: fallback if skb_alloc() fails on big packets

Saeed Bishara (2):
      [ARM] Orion: Instantiate mv_xor driver for 5182
      [ARM] Kirkwood: Instantiate mv_xor driver

Scott Wood (1):
      gianfar: Call gfar_halt_nodisable() from gfar_halt().

Sebastian Siewior (3):
      Documentation: fix typo in ubifs.txt
      usb: return error code instead of 0 in the enqueue function.
      usb: isp1760: don't be noisy about short packets.

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Ibex Peak PCHs

Simon Arlott (2):
      USB: Move usb/mon/ up to misc options in Kconfig
      USB: cxacru: Fix printk format flag in error message

Simon Horman (2):
      ipvs: Explictly clear ip_vs_stats members
      ipvs: add lvs-devel as a list contact

Sonic Zhang (1):
      Blackfin arch: Fix bugs - Make kgdb code apparent to app debugging.

Stefan Buehler (1):
      tg3: fix 64 bit counter for ethtool stats

Stefan Richter (4):
      ieee1394: regression in 2.6.25: updates should happen before probes
      ieee1394: don't drop nodes during bus reset series
      ieee1394: sbp2: let nodemgr retry node updates during bus reset series
      firewire: Kconfig help update

Stefan Schmidt (1):
      [ARM] 5193/1: Wire up missing syscalls

Stephen Hemminger (3):
      lockdep: fix build if CONFIG_PROVE_LOCKING not defined
      bridge: show offload settings
      nf_nat: use secure_ipv4_port_ephemeral() for NAT port randomization

Stephen Rothwell (2):
      sparc/drivers: use linux/of_device.h instead of asm/of_device.h
      sparc: remove include of linux/of_device.h from asm/of_device.h

Steve French (3):
      [CIFS] if get root inode fails during mount, cleanup tree connection
      [CIFS] remove trailing whitespace
      [CIFS] mount of IPC$ breaks with iget patch

Steven Rostedt (1):
      powerpc: Remove dead module_find_bug code

Suresh Siddha (2):
      x64, fpu: fix possible FPU leakage in error conditions
      crypto: padlock - fix VIA PadLock instruction usage with irq_ts_save/restore()

Sven Wegener (10):
      ipvs: Fix possible deadlock in sync code
      ipvs: Fix possible deadlock in estimator code
      ipvs: Use ARRAY_SIZE()
      ipvs: Use list_empty() instead of open-coding the same functionality
      ipvs: Initialize schedulers' struct list_head at compile time
      ipvs: Annotate init functions with __init
      ipvs: Mark net_vs_ctl_path const
      ipvs: Embed estimator object into stats object
      ipvs: No need to zero out ip_vs_stats during initialization
      nbd: fix memory leak of nbd_dev array

Takashi Iwai (2):
      USB: cdc-acm.c: Fix compile warnings
      ALSA: hda - Fix capture source widgets on ALC codecs

Takashi YOSHII (2):
      binfmt_flat: Stub in a FLAT_PLAT_INIT().
      sh: Provide a FLAT_PLAT_INIT() definition.

Thomas Gleixner (1):
      x86: hpet: workaround SB700 BIOS

Tollef Fog Heen (1):
      USB: pl2023: Remove USB id (4348:5523) handled by ch341

Tony Luck (1):
      [IA64] pci_acpi_scan_root cleanup

Uwe Kleine-König (2):
      Input: gpio-keys - fix possible NULL pointer dereference
      Input: gpio-keys - make gpio_keys_device_driver static

Vegard Nossum (1):
      au1000_eth: use 'unsigned long' for irqflags

Vladislav Zolotarov (2):
      bnx2x: Load/Unload under traffic
      bnx2x: No LRO without Rx checksum

Wolfgang Mües (1):
      usb: auerswald: remove driver (obsolete)

Yang Hongyang (1):
      ipv6: Fix the return interface index when get it while no message is received.

Yang, Bo (4):
      [SCSI] megaraid_sas: add readl to force PCI posting flush
      [SCSI] megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
      [SCSI] megaraid_sas: add new controllers (0x78 0x79)
      [SCSI] megaraid_sas: version and Documentation Update

Yaniv Rosner (3):
      bnx2x: Link order with external PHY
      bnx2x: Pause settings
      bnx2x: 8073 PHY changes

Yinghai Lu (5):
      pci: debug extra pci resources range
      pci: debug extra pci bus resources
      x86, pci: detect end_bus_number according to acpi/e820 reserved, v2
      x86: don't call e820_regiter_active_regions if out of range on node
      x86: check bigsmp in smp_sanity_check instead of cpu_up

Yitchak Gertner (6):
      bnx2x: Statistics
      bnx2x: HW lock mechanism
      bnx2x: Self-test false positive
      bnx2x: Delay in while loops
      bnx2x: Clearing MAC addresses filters
      bnx2x: Wrong structure size

York Sun (2):
      freescale DIU: add virtual resolution and panning support
      freescale DIU: bug fix: add sanity check for AOI position

Yoshihiro Shimoda (1):
      USB: sh: r8a66597-hcd: fix disconnect regression

Yoshinori Sato (1):
      sh: Don't export __{s,u}divsi3_i4i from SH-2 libgcc.

Zhang, Yanmin (1):
      sched: fix the race between walk_tg_tree and sched_create_group

Zhao Yakui (2):
      ACPI : Add the EC dmi table to fix the incorrect ECDT table
      ACPI: Avoid bogus EC timeout when EC is in Polling mode

Zoltan Sogor (2):
      UBIFS: support splice_write
      UBIFS: fix budgeting request alignment in xattr code

matthieu Barthélemy (1):
      rtl8187: Add USB ID for Netgear WG111V3

roel kluin (1):
      atl1e: WAKE_MCAST 2x. 1st WAKE_UCAST?

venkatesh.pallipadi@intel.com (3):
      cpuidle: Do not use poll_idle unless user asks for it
      cpuidle: Menu governor fix wrong usage of measured_us
      cpuidle: Make ladder governor honor latency requirements fully
