Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYH1X1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYH1X1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYH1X0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:26:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbYH1X0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:26:48 -0400
Date: Thu, 28 Aug 2008 16:26:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-rc5
Message-ID: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week (my weeks do seem to be eight days, don't they? Very odd), 
another -rc.

The dirstat pretty much says it all:

  43.0% arch/arm/configs/
  43.9% arch/arm/
  25.5% arch/powerpc/configs/
  26.8% arch/powerpc/
  73.9% arch/
   4.4% drivers/usb/musb/
   5.4% drivers/usb/
   4.0% drivers/watchdog/
  16.0% drivers/
   3.5% fs/

yeah, the bulk of it is all config updates, and with arm and powerpc 
leading the pack.

But seriously, while the config updates amount to about three quarters of 
the diff, and if you don't use a rename-aware diff the blackfin include 
file movement pretty much accounts for the rest, hidden behind all those 
trivial (but bulky) changes are a lot of small changes that hopefully fix 
a number of regressions.

The most exciting (well, for me personally - my life is apparently too 
boring for words) was how we had some stack overflows that totally 
corrupted some basic thread data structures. That's exciting because we 
haven't had those in a long time.  The cause turned out to be a somewhat 
overly optimistic increase in the maximum NR_CPUS value, but it also 
caused some introspection about our stack usage in general. Including 
things like a patch to gcc to fix insane stack usage for vararg functions 
on x86-64.

But that one would only hit anybody who was a bit too adventurous and 
selected the big 4096 CPU configuration. The rest of the regressions fixed 
are a bit more pedestrian.

---
Adel Gadllah (1):
      block: clean up cmdfilter sysfs interface

Adrian Bunk (5):
      ocfs2/cluster/tcp.c: make some functions static
      removed unused #include <linux/version.h>'s
      KVM: fix userspace ABI breakage
      Blackfin arch: let PCI depend on BROKEN
      [ARM] use bcd2bin/bin2bcd

Al Viro (8):
      fix efs_lookup()
      fix osf_getdirents()
      fix hpux_getdents()
      fix regular readdir() and friends
      fix ->llseek() for a bunch of directories
      deal with the first call of ->show() generating no output
      ipv4: sysctl fixes
      ipv6: sysctl fixes

Alan Cox (4):
      libata: Fix a large collection of DMA mode mismatches
      [netdrvr] fix build issue: undefined reference to `NS8390p_init'
      tty: TIOCGSOFTCAR/SSOFTCAR on pty is wron
      tty: Fix termios tty window resize race with pty/tty pair

Alan Stern (6):
      PM: don't skip device PM init when CONFIG_PM_SLEEP isn't set and CONFIG_PM is set
      USB: Add udev argument to interface suspend/resume functions
      USB: Defer Set-Interface for suspended devices
      USB: Add new PM callback methods for USB
      USB: Don't rebind before "complete" callback
      USB: automatically enable RHSC interrupts

Alex Chiang (2):
      PCI: pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
      PCI: shpchp: Rename duplicate slot name N as N-1, N-2, N-M...

Alexander Beregalov (1):
      ocfs2/cluster/netdebug.c: fix warning

Alexander Duyck (5):
      ixgbe: fix vlan filtering
      igb: force all queues to interrupt once every 2 seconds
      igb: ethtool -d reads EICR which is incorrect as it is read on clear
      igb: fix setting the number of tx queues
      igb: remove 82576 quad adapter

Alexey Dobriyan (2):
      USB: cdc-acm: don't unlock acm->mutex on error path
      proc: inode number fixlet

Alok Kataria (1):
      x86: fix VMI for early params

Anand Gadiyar (1):
      MUSB: Fix index register corruption seen with g_ether and Windows host

Andi Kleen (1):
      x86: fix oprofile + hibernation badness

Andrew Morton (1):
      powerpc: Export CMO_PageSize

Aneesh Kumar K.V (5):
      ext4: Handle unwritten extent properly with delayed allocation
      ext4: Rework the ext4_da_writepages() function
      ext4: make sure ext4_has_free_blocks returns 0 for ENOSPC
      ext4: Initialize writeback_index to 0 when allocating a new inode
      ext4: Fix small file fragmentation

Anthony Liguori (1):
      virtio_balloon: fix towards_target when deflating balloon

Anton Vorontsov (1):
      [WATCHDOG] mpc8xxx_wdt: fix modular build

Arjan van de Ven (3):
      x86: use WARN() in arch/x86/mm/ioremap.c
      x86: use WARN() in arch/x86/kernel
      Fix oops in acer_wmi driver (acer_wmi_init)

Arnd Bergmann (1):
      net/usb/mcs7830: new device IDs

Atsushi Nemoto (2):
      [MIPS] TXx9: Fix mips_hpt_frequency initialization
      [MIPS] kgdb: Do not call fixup_exception

Austin Zhang (1):
      x86: add X86_FEATURE_XMM4_2 definitions

Avi Kivity (1):
      KVM: MMU: Fix torn shadow pte

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

Ben Dooks (9):
      [WATCHDOG] Fix NULL usage in s3c2410_wdt driver.
      [WATCHDOG] Clean out header of s3c2410_wdt driver.
      [WATCHDOG] Fix s3c2410_wdt driver coding style issues
      [ARM] S3C24XX: Fix nor-simtec driver sparse errors
      [ARM] S3C24XX: Fix sparse warnings in arch/arm/plat-s3c24xx/gpiolib.c
      [ARM] S3C24XX: Fix spare errors in pwm-clock driver
      [ARM] S3C24XX: Fix sparse warnings in pwm.c
      [ARM] S3C24XX: pwm.c: stop debugging output
      [ARM] JIVE: Fix the spi bus numbering

Benjamin Herrenschmidt (1):
      ibm_newemac: Don't call dev_mc_add() before device is registered

Bernd Schmidt (1):
      Blackfin arch: fix bug - MPU crashes under stress

Brice Goglin (1):
      myri10ge: update version string to 1.4.3-1.358

Bryan Wu (1):
      Blackfin arch: move include/asm-blackfin header files to arch/blackfin

Carl Love (1):
      powerpc/cell/oprofile: Avoid double vfree of profile buffer

Christoph Hellwig (2):
      change d_add_ci argument ordering
      ntfs: use d_add_ci

Christoph Lameter (1):
      slub: Disable NUMA remote node defragmentation by default

Clemens Ladisch (1):
      ALSA: oxygen: prevent muting of nonexistent AC97 controls

Cliff Wickman (1):
      x86, SGI UV: hardcode the TLB flush interrupt system vector

Dan Williams (2):
      atmel: return ENOENT on request_firmware failure
      atmel: try open system authentication too

Dave Airlie (1):
      drm: don't set the signal blocker on the master process.

Dave Olson (1):
      IB/ipath: Fix incorrect check for max physical address in TID

David Brownell (1):
      driver model: anti-oopsing medicine

David Howells (1):
      werror: fix pci calgary

David S. Miller (1):
      sparc64: Make NUMA depend upon SMP.

David Woodhouse (1):
      Fix userspace export of <linux/net.h>

Denis Joseph Barrow (2):
      [netdrvr] hso: icon 322 detection fix
      [netdrvr] hso: dev_kfree_skb crash fix

Denis V. Lunev (1):
      icmp: icmp_sk() should not use smp_processor_id() in preemptible code

Dirk Behme (1):
      [ARM] OMAP: Change mailing list for OMAP in MAINTAINERS

Eduardo Habkost (1):
      KVM: Use .fixup instead of .text.fixup on __kvm_handle_fault_on_reboot

Eilon Greenstein (5):
      bnx2x: Rx work check
      bnx2x: Fan failure mechanism on additional design
      bnx2x: Minimize lock time
      bnx2x: HW lock timeout
      bnx2x: Version update

Enrico Scholz (1):
      USB: ISP1760: fixed trivial math in comment

Eric Sandeen (3):
      ext4: Fix bug where we return ENOSPC even though we have plenty of inodes
      USB: cdc-acm: quirk for Conexant CX93010 USB modem
      [S390] fix ext2_find_next_bit

Eugene Teo (1):
      wan: Missing capability checks in sbni_ioctl()

FUJITA Tomonori (5):
      block: move cmdfilter from gendisk to request_queue
      sg: restore command permission for TYPE_SCANNER
      block: rename blk_scsi_cmd_filter to blk_cmd_filter
      bio: fix bio_copy_kern() handling of bio->bv_len
      bio: fix __bio_copy_iov() handling of bio->bv_len

Felipe Balbi (3):
      usb: musb: get rid of procfs entry
      usb: musb: get rid of MUSB_LOGLEVEL and use parameter
      net: rfkill: add missing line break

Florian Fainelli (4):
      [MIPS] RB532: Do not define registers that are already defined
      [MIPS] Ignore vmlinux.lds generated files
      [WATCHDOG] Add support for the built-int RDC R-321x SoC watchdog
      [WATCHDOG] Add support for the IDT RC32434 watchdog

Francois Romieu (1):
      r8169: balance pci_map / pci_unmap pair

Frank Blaschka (2):
      qeth: l2 write unicast list to hardware
      qeth: preallocated header account offset

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

Gerald Schaefer (1):
      [S390] dcssblk: fix race in dcssblk_add_store()

Greg Kroah-Hartman (2):
      driver core: add init_name to struct device
      PCI: fix reference leak in pci_get_dev_by_id()

H. Peter Anvin (7):
      smp: have smp_call_function_single() detect invalid CPUs
      x86: msr: propagate errors from smp_call_function_single()
      x86: cpuid: propagate error from smp_call_function_single()
      x86: msr: correct return value on partial operations
      x86: cpuid: correct return value on partial operations
      x86: msr: fix bogus return values from rdmsr_safe/wrmsr_safe
      x86: update defconfigs

Harvey Harrison (1):
      [ARM] use the new byteorder headers

Heiko Carstens (3):
      [S390] Remove unneeded spinlock initialization.
      [S390] Fix linker script.
      [S390] dcss: fix build bug.

Heiko Schocher (1):
      fs_enet: Fix SCC Ethernet on CPM2, and crash in fs_enet_rx_napi()

Herbert Xu (1):
      crypto: authenc - Avoid using clobbered request pointer

Hiroshi Miura (1):
      usb-serial: option support HSDPA modem A2502

Huang Weiyi (1):
      [WATCHDOG] removed unused #include <version.h>

Hugh Dickins (1):
      ipv4: mode 0555 in ipv4_skeleton

Ian Molton (6):
      [ARM] eseries: whitespace fixes and cleanup
      [ARM] clocklib: Allow dynamic alias creation
      [ARM] clocklib: Update users of aliases to new API
      [ARM] Fix eseries IRQ limit
      [ARM] e740 config use MFP
      [ARM] e400 config use MFP

Ilpo Jarvinen (1):
      [WATCHDOG] at91rm9200_wdt.c: fix misleading indentation

Ilpo Järvinen (2):
      [CIFS] reindent misindented statement
      atl1e: multistatement if missing braces

Ingo Molnar (2):
      x86: work around MTRR mask setting, v2
      rtc: fix deadlock

Ingo Oeser (1):
      kobject: Replace ALL occurrences of '/' with '!' instead of only the first one.

James Bottomley (1):
      [IA64] Fix __{in,out}s{w,l} to handle unaligned data

Jan Beulich (2):
      x86: fix 1:1 mapping init on 64-bit (memory hotplug case)
      x86: fix two modpost warnings in mm/init_64.c

Jan Glauber (3):
      [S390] qdio: prevent oopsing if qdio_establish fails
      [S390] qdio: improve s390 debug feature usage
      [S390] qdio: remove the module_get & module_put pair

Jan-Espen Pettersen (1):
      mac80211: don't send empty extended rates IE

Jarek Poplawski (6):
      pkt_sched: Fix qdisc_watchdog() vs. dev_deactivate() race
      pkt_sched: Fix qdisc list locking
      pkt_sched: Fix dev_graft_qdisc() locking
      pkt_sched: Use rcu_assign_pointer() to change dev_queue->qdisc
      pkt_sched: Fix gen_estimator locks
      pkt_sched: Fix sch_tree_lock()

Jarkko Nikula (1):
      ALSA: ASoC: Fix error paths in N810 machine driver init and release clocks at exit

Jay Cliburn (1):
      atl1: disable TSO by default

Jean Delvare (4):
      dev_printk(): constify the `dev' argument
      ALSA: ASoC: Fix double free and memory leak in many codec drivers
      i2c: Add missing kerneldoc descriptions
      i2c: Prevent log spam on some DVB adapters

Jean-Christophe DUBOIS (1):
      [ARM] 5226/1: remove unmatched comment end.

Jeff Garzik (2):
      [libata] pata_it821x: fix warning
      [netdrvr] smc91x: fix resource removal (null ptr deref)

Jeff Layton (2):
      cifs: add local server pointer to cifs_setup_session
      [CIFS] Add destroy routine for dns_resolver

Jens Axboe (2):
      block: submit_bh() inadvertently discards barrier flag on a sync write
      block: remove blk_queue_tag_depth() and blk_queue_tag_queue()

Jeremy Fitzhardinge (1):
      x86: export pv_lock_ops non-GPL

Jerome Glisse (1):
      radeon: fix some hard lockups on r3/4/500s

Jiri Kosina (1):
      x86 iommu: remove unneeded parenthesis

Jiri Slaby (3):
      Ath5k: lock beacons
      Ath5k: fix bintval setup
      e100, fix iomap read

Jochen Friedrich (1):
      [WATHDOG] delete unused driver mpc8xx_wdt.c

Joe Korty (2):
      lockstat: fix numerical output rounding error
      lockstat: repair erronous contention statistics

Joe Perches (1):
      drivers/base/driver.c: remove unused to_dev() macro

Joel Becker (1):
      ocfs2: Increment the reference count of an already-active stack.

John Blackwood (1):
      sched: fix sched_rt_rq_enqueue() resched idle

John W. Linville (1):
      mac80211: quiet chatty IBSS merge message

Josef 'Jeff' Sipek (1):
      [S390] Fix uninitialized spinlock use

Josef Bacik (1):
      ext4: don't try to resize if there are no reserved gdt blocks left

Jouni Malinen (2):
      mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM
      mac80211: Fix debugfs file add/del for netdev

Julia Lawall (1):
      net/mac80211/mesh.c: correct the argument to __mesh_table_free

Julien Brunel (1):
      [S390] drivers/s390: Use an IS_ERR test rather than a NULL test

Kay Sievers (3):
      block: fix partial read() of /proc/{partitions,diskstats}
      block: drop references taken by class_find_device()
      pnp: fix "add acpi:* modalias entries"

Klaus-D. Wacker (1):
      LCS recovery dumps when cable reconnect

Kumar Gala (2):
      powerpc: Fix whitespace merge in mpc8641 hpcn device tree
      powerpc: Update defconfigs for FSL PPC boards

Laurent Pinchart (1):
      cpm2: Fix race condition in CPM2 GPIO library.

Lennert Buytenhek (6):
      mv643xx_eth: fix NAPI 'rotting packet' issue
      mv643xx_eth: fix double add_timer() on the receive oom timer
      mv643xx_eth: fix inconsistent lock semantics
      mv643xx_eth: fix NULL pointer dereference in rxq_process()
      mv643xx_eth: enforce multiple-of-8-bytes receive buffer size restriction
      mv643xx_eth: bump version to 1.3

Linus Torvalds (6):
      x86: do not enable TSC notifier if we don't need it
      [module] Don't let gcc inline load_module()
      [x86] Clean up MAXSMP Kconfig, and limit NR_CPUS to 512
      Revert "pktcdvd: push BKL down into driver"
      e1000: fix stack size
      Linux 2.6.27-rc5

Louis Rilling (1):
      configfs: Consolidate locking around configfs_detach_prep() in configfs_rmdir()

Magnus Damm (1):
      UIO: generic irq handling for some uio platform devices

Marc Pignat (1):
      i2c: Fix device_init_wakeup place

Marcin Slusarz (2):
      x86, mmiotrace: silence section mismatch warning - leave_uniprocessor
      x86: fix section mismatch warning - uv_cpu_init

Mark Brown (1):
      [ARM] 5225/1: zaurus: Register I2C controller for audio codecs

Mark Fasheh (2):
      ocfs2: Fix sleep-with-spinlock recovery regression
      ocfs2: correctly set i_blocks after inline dir gets expanded

Martin Habets (1):
      sparc: Add target for a stripped kernel

Martin Michlmayr (3):
      [ARM] Orion: fix MAC detection on QNAP TS-209 and TS-409
      [ARM] Orion: activate lm75 driver on DNS-323
      [ARM] Orion: register UART1 on QNAP TS-209 and TS-409

Martin Schwidefsky (2):
      [S390] Update default configuration.
      claw: fix memory leak in claw_probe.

Masakazu Mokuno (2):
      powerpc/ps3: Rework htab code to remove ioremap
      powerpc/ps3: Fix ioremap of spu shadow regs

Matthew Wilcox (1):
      block: remove unused ->busy part of the block queue tag map

Mel Gorman (1):
      [ARM] Skip memory holes in FLATMEM when reading /proc/pagetypeinfo

Miao Xie (1):
      nohz: fix wrong event handler after online an offlined cpu

Michael Hennerich (2):
      Blackfin arch: Add MTD Partitions for MTD_DATAFLASH, increase max SPI SCLK
      Blackfin arch: Fix PM building on BF52x: No ROTWE on BF52x, add USBWE

Mike Crowe (1):
      [MIPS] Convert printk statements during kernel setup to use severity levels

Mike Frysinger (2):
      Blackfin arch: dont actually need to muck with EMAC_SYSTAT for BF52x for demuxing
      Blackfin EMAC Driver: the BF526 also supports the MAC,

Mike Rapoport (1):
      [ARM] 5212/1: pxa: fix build error when CPU_PXA310 is not defined

Mingming Cao (5):
      ext4: Fix delalloc release block reservation for truncate
      ext4: journal credits calulation cleanup and fix for non-extent writepage
      ext4: journal credits reservation fixes for extent file writepage
      ext4: journal credits reservation fixes for DIO, fallocate
      ext4: journal credit fix for the delayed allocation's writepages() function

Nicolai Haehnle (2):
      drm/radeon: r300_cmdbuf: Always emit INDX_BUFFER immediately after DRAW_INDEX
      r300: Fix cliprect emit

Nicolas Pitre (1):
      [ARM] orion5x: update defconfig to v2.6.27-rc4

Oliver Martin (1):
      net/usb/mcs7830: add set_mac_address

Oliver Neukum (1):
      USB: fix bug in usb_unlink_anchored_urbs()

Paul Mackerras (1):
      powerpc: Update defconfigs for most non-embedded platforms

Peer Chen (1):
      ALSA: hda_intel: enable snoop for nvidia HDA controller

Per Andersson (1):
      [ARM] Orion: Fix boot crash on Kurobox Pro

Peter Oberparleiter (2):
      [S390] cio: fix ccw group device cleanup
      [S390] cio: call ccw driver notify function with lock held

Peter Tiedemann (2):
      claw: netdev->priv vs. netdev->ml_priv
      ctcm: netdev->priv vs. netdev->ml_priv

Peter Zijlstra (4):
      sched: enable LB_BIAS by default
      x86: fix cpufreq + sched_clock() regression
      sched_clock: fix cpu_clock()
      sched: rt-bandwidth accounting fix

Philip Love (1):
      tcp: fix tcp header size miscalculation when window scale is unused

Rafael J. Wysocki (3):
      PM: Remove WARN_ON from device_pm_add
      x86 MCE: Fix CPU hotplug problem with multiple multicore AMD CPUs
      ftrace: disable tracing for hibernation

Ralf Baechle (6):
      [MIPS] Wire up new syscalls.
      [MIPS] Jazz: Fix build error by header file inclusion weeding.
      [MIPS] emma2rh: Fix build error by header file inclusion weeding.
      [MIPS] kgdb: smp_call_function's 3rd argument is a pointer.
      [MIPS] kgdb: s/(void *)0)/NULL/
      [MIPS] IP27: Export symbol pcibus_to_node to modules.

Ralph Campbell (1):
      IB/ipath: Fix lost UD send work request

Randy Dunlap (1):
      rcu: fix synchronize_rcu() so that kernel-doc works

Robert Jarzmik (1):
      USB: Fix pxa27x_udc usb speed handling.

Robert Richter (2):
      x86: fix: do not run code in amd_bus.c on non-AMD CPUs
      x86: fix: make PCI ECS for AMD CPUs hotplug capable

Robin Holt (1):
      [IA64] Fix ia64 build failure when CONFIG_SFC=m

Roland Dreier (1):
      IPoIB: Fix deadlock on RTNL in ipoib_stop()

Russell King (3):
      [ARM] fix impd1.c build warning
      [ARM] OMAP: Add and update OMAP default configuration files
      [ARM] OMAP: Fix 2430 SMC91x ethernet IRQ

Rusty Russell (3):
      stop_machine: wean Xen off stop_machine_run
      stop_machine: Remove deprecated stop_machine_run
      lguest: update commentry

Saeed Bishara (1):
      sata_mv: add the Gen IIE flag to the SoC devices.

Samuel Sieb (1):
      x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

Santiago Leon (1):
      ibmveth: fix bad UDP checksums

Scott Wood (1):
      powerpc: Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target

Sebastian Siewior (1):
      net: don't grab a mutex within a timer context in gianfar

Seth Heasley (2):
      ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
      ata_piix: IDE Mode SATA patch for Intel Ibex Peak DeviceIDs

Sonic Zhang (1):
      Blackfin arch: Fix bug - when to rmmod the L1_module, it stucks and then reboot the board.

Stefan Lippers-Hollmann (1):
      USB: sisusbvga: add USB ID for 0711:0918 Magic Control Technology Corp.

Stefan Weinhuber (1):
      [S390] dasd: fix data size for PSF/PRSSD command

Stephen Hemminger (1):
      ipv6: protocol for address routes

Stephen Rothwell (1):
      ALSA: fix for CA0106 on MSI K8N Diamond PLUS Motherboard

Steve French (5):
      [CIFS] distinguish between Kerberos and MSKerberos in upcall
      [CIFS] Kerberos support not considered experimental anymore
      [CIFS] check version in spnego upcall response
      [CIFS] Correct keys dependency for cifs kerberos support
      [CIFS] Reorder cifs config item for better clarity

Steve VanDeBogart (1):
      exit signals: use of uninitialized field notify_count

Steven Rostedt (1):
      ftrace: disable tracing for suspend to ram

Takashi Iwai (2):
      ALSA: hda - Fix call of alc888_coef_init()
      drivers/net/skfp/ess.c: fix compile warnings

Takenori Nagano (1):
      Japanese translation of Documentation/SubmitChecklist

Tao Ma (1):
      ocfs2: Jump to correct label in ocfs2_expand_inline_dir()

Tejun Heo (8):
      libata: implement no[hs]rst force params
      sata_mv: don't issue two DMA commands concurrently
      libata: fix EH action overwriting in ata_eh_reset()
      libata: always do follow-up SRST if hardreset returned -EAGAIN
      libata: use ata_link_printk() when printing SError
      libata: restore SControl on detach
      pata_via: clean up recent tf_load changes
      ahci: sis controllers actually can do PMP

Theodore Ts'o (4):
      ext4: Fix potential truncate BUG due to i_prealloc_list being non-empty
      ext4: Fix ext4_dx_readdir hash collision handling
      ext4: Use ext4_discard_reservations instead of mballoc-specific call
      ext4: Update documentation to remind users to update mke2fs.conf

Thomas Hellstrom (1):
      drm: don't call the vblank tasklet with irqs disabled.

Thomas Mingarelli (1):
      [WATCHDOG] hpwdt.c kdebug support

Timur Tabi (1):
      powerpc: fix memory leaks in QE library

Tomasz Chmielewski (1):
      [ARM] 5208/1: fsg-setup.c fixes

Travis Place (1):
      ALSA: CA0106 on MSI K8N Diamond PLUS Motherboard

Tsugikazu Shibata (1):
      Documentation: HOWTO-ja_JP-sync patch

Ursula Braun (1):
      qeth: use -EOPNOTSUPP instead of -ENOTSUPP.

Uwe Kleine-König (2):
      UIO: uio_pdrv: fix memory leak
      UIO: uio_pdrv: fix license specification

Vegard Nossum (2):
      x86: fix BUG: unable to handle kernel paging request (numaq_tsc_disable)
      Blackfin arch: sram: use 'unsigned long' for irqflags

Venki Pallipadi (1):
      x86: fix Xorg startup/shutdown slowdown with PAT

Vlad Yasevich (4):
      sctp: fix potential panics in the SCTP-AUTH API.
      sctp: add verification checks to SCTP_AUTH_KEY option
      sctp: correct bounds check in sctp_setsockopt_auth_key
      sctp: fix random memory dereference with SCTP_HMAC_IDENT option.

Vladimir Sokolovsky (1):
      IB/mlx4: Actually return L_Key and R_Key for fast register MRs

Wei Shuai (1):
      [ARM] S3C2443: Fix the S3C2443 clock register definitions

Wolfgang Grandegger (1):
      powerpc/85xx: TQM8548: DTS file fixes and cleanup

Yinghai Lu (2):
      x86: work around MTRR mask setting
      x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

Yitchak Gertner (4):
      bnx2x: Initialization structure
      bnx2x: NIC load failure cleanup
      bnx2x: NAPI and interrupts enable/disable
      bnx2x: Multi Queue

Zhu Yi (1):
      lockdep: fix invalid list_del_rcu in zap_class

venkatesh.pallipadi@intel.com (3):
      x86: PAT proper tracking of set_memory_uc and friends
      devmem, x86: PAT Change /dev/mem mmap with O_SYNC to use UC_MINUS
      x86: PAT Update validate_pat_support for intel CPUs
