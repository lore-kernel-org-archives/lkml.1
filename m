Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYDKUwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYDKUwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbYDKUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:52:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759709AbYDKUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:52:28 -0400
Date: Fri, 11 Apr 2008 13:51:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc9
Message-ID: <alpine.LFD.1.00.0804111340240.3143@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I really don't want to do this, and I was actually hoping to release 
2.6.25 last weekend (which is why -rc9 is a few days late - just me hoping 
to not do another -rc at all), but I've done an -rc9.

The changes in -rc9 are pretty small (shortlog appended), and 60% of them 
are m68k updates - mostly defconfigs. And some doc updates.

But there's some network driver updates (tg3 and wireless hostap stand 
out), some late XFS patches and a mvsas driver update (the mvsas driver is 
new in 2.6.25, so that's not going to regress anything ;).

The rest is mostly one-liners, with a few reverts going on.

Dirstat:

	   4.2% Documentation/filesystems/
	   3.2% Documentation/networking/
	  11.4% Documentation/
	  55.7% arch/m68k/configs/
	  59.4% arch/m68k/
	   2.0% arch/powerpc/
	  65.7% arch/
	   3.6% drivers/net/
	   4.2% drivers/scsi/
	  12.7% drivers/
	   2.3% fs/
	   2.2% include/
	   3.9% net/

anyway, the reason for not doing a 2.6.25 is that some people are making 
noises about slab/page-alloc setup issues, and I wanted something out this 
week, but didn't feel comfy doing a final release.

That said, I think I'll have to do 2.6.25 early next week regardless, 
because we can't just keep holding things back forever. At some point it 
will have to turn into a 2.6.25.x issue, and the developers with stuff 
pending for the next version need to be able to start merging.

			Linus

PS. This has been a somewhat frustrating last week or so. So if I was even 
less polite to somebody than usual in public or private emails, my 
apologies. You know who you are.

---
Abhijeet Kolekar (1):
      iwlwifi: fix n-band association problem

Adrian Bunk (18):
      [ATM]: Make atm/he.c:read_prom_byte() static
      [ATM] atm/idt77252.c: Make 2 functions static
      [NET]: Remove Documentation/networking/sk98lin.txt
      V4L/DVB (7485): v4l2-int-device.c: add MODULE_LICENSE
      ide-pnp.c: add MODULE_LICENSE
      ide/pci/cmd640.c: add MODULE_LICENSE
      ide/ppc/mpc8xx.c: add MODULE_LICENSE
      ide/ppc/pmac.c: add MODULE_LICENSE
      ide/arm/ide_arm.c: add MODULE_LICENSE
      ide/cris/ide-cris.c: add MODULE_LICENSE
      ide/h8300/ide-h8300.c: add MODULE_LICENSE
      ide/legacy/gayle.c: add MODULE_LICENSE
      ide/legacy/buddha.c: add MODULE_LICENSE
      ide/legacy/falconide.c: add MODULE_LICENSE
      ide/legacy/macide: add MODULE_LICENSE
      ide/legacy/q40ide.c: add MODULE_LICENSE
      net/tokenring/olympic.c section fixes
      m68k: use KBUILD_DEFCONFIG

Al Viro (1):
      fix endian lossage in forcedeth

Alan Stern (1):
      USB: fix bug in sg initialization in usbtest

Alexey Korolev (1):
      mtd: fix broken state in CFI driver caused by FL_SHUTDOWN

Alok Kataria (1):
      acpi: fix "buggy BIOS check" when CPUs are hot removed

Andi Kleen (1):
      [NET]: srandom32 fixes for networking v2

Andrea Arcangeli (1):
      Fix bounce setting for 64-bit

Andrew Morton (1):
      alpha: get_current(): don't add zero to current_thread_info()->task

Andrew Paprocki (1):
      [WATCHDOG] it8712f_wdt Zero MSB timeout byte when disabling watchdog

Anthony Liguori (1):
      virtio_net: remove overzealous printk

Anton Vorontsov (1):
      [POWERPC] 83xx: Fix wrong USB phy type in mpc837xrdb dts

Arjan van de Ven (1):
      es1968: fix sleep-while-holding-lock bug

Balbir Singh (1):
      memory controller: make memory resource control aware of boot options

Bartlomiej Sieka (1):
      [POWERPC] mpc5200: Amalgamated DTS fixes and updates

Bartlomiej Zolnierkiewicz (3):
      ide-h8300: 32-bit I/O is unsupported
      ide: use ->ata_input_data in ide_driveid_update()
      libata: fix IDENTIFY order in ata_bus_probe()

Benjamin Herrenschmidt (3):
      [POWERPC] Fix iSeries hard irq enabling regression
      [POWERPC] Fix deadlock with mmu_hash_lock in hash_page_sync
      pata_sil680: Fix build on arch/ppc

Benoit Boissinot (2):
      IPv6: only update the lifetime of the relevant temporary address
      IPv6: do not create temporary adresses with too short preferred lifetime

Bjorn Helgaas (2):
      V4L/DVB (7486): radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP
      pnp: increase number of devices supported per protocol

Brad Sawatzky (1):
      USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24

Bryan Wu (1):
      fix bug - executing FDPIC ELF on NFS mount triggers BUG() at mm/nommu.c:862:/do_mmap_private()

Carol Hebert (1):
      ipmi: change device node ordering to reflect probe order

Christian Borntraeger (1):
      kvm: provide kvm.h for all architecture: fixes headers_install

Chuck Lever (1):
      SUNRPC: Fix a memory leak in rpc_create()

Clark Rawlins (1):
      USB: Allow initialization of broken keyspan serial adapters.

Cyrill Gorcunov (2):
      V4L/DVB (7461): bttv: fix missed index check
      V4L/DVB (7460): bttv: Bt832 - fix possible NULL pointer deref

Dan Williams (1):
      md: close a livelock window in handle_parity_checks5

Daniel Drake (1):
      ipw2200: set MAC address on radiotap interface

Daniel Lezcano (1):
      [NETNS][IPV6] tcp - assign the netns for timewait sockets

Daniel Wagner (1):
      rt61pci: rt61pci_beacon_update do not free skb twice

Dave Young (2):
      bluetooth : use lockdep sub-classes for diffrent bluetooth protocol
      bluetooth : __rfcomm_dlc_close lock fix

David Brownell (3):
      drivers/net/usb/pegasus.c: remove in_atomic() check
      USB: another ehci_iaa_watchdog fix
      spi: documentation tweaks

David Chinner (1):
      [XFS] Fix superblock features2 field alignment problem

David Howells (5):
      FRV: Handle update_mmu_cache() being called when current->mm is NULL [try #2]
      FRV: Move STACK_TOP_MAX up [try #2]
      FRV: Add support for emulation of userspace atomic ops [try #2]
      FRV: Make NOMMU-mode work with base addresses other than 0xC0000000 [try #2]
      FRV: Don't make smp_{r, w, }mb() interpolate MEMBAR when CONFIG_SMP=n [try #2]

David S. Miller (11):
      [NET]: Use local_irq_{save,restore}() in napi_complete().
      [SPARC64]: Don't open-code {get,put}_cpu_var() in flush_tlb_pending().
      [BOND]: Fix warning in bond_sysfs.c
      [ATM] firestream: Fix uninitialized var warning.
      [INET]: inet_frag_evictor() must run with BH disabled
      [LLC]: Kill llc_station_mac_sa symbol export.
      [SPARC64]: Fix FPU saving in 64-bit signal handling.
      [SPARC64]: Fix user accesses in regset code.
      [NET]: Undo code bloat in hot paths due to print_mac().
      [SPARC]: Fix several regset and ptrace bugs.
      [IPV4]: Fix byte value boundary check in do_ip_getsockopt().

Davide Libenzi (2):
      eventfd/kaio integration fix
      signalfd: fix for incorrect SI_QUEUE user data reporting

Denis V. Lunev (4):
      [NETFILTER]: Replate direct proc_fops assignment with proc_create call.
      [IPV6]: Event type in addrconf_ifdown is mis-used.
      [IPV6]: inet6_dev on loopback should be kept until namespace stop.
      [IPV6]: Fix refcounting for anycast dst entries.

Dmitri Vorobiev (1):
      Fix typos in Documentation/unaligned-memory-access.txt

Dmitry Adamushko (1):
      mtd/chips: add missing set_current_state() to cfi_{amdstd,staa}_sync()

Eliezer Tamir (1):
      BNX2X: Correct bringing chip out of reset

Eric Paris (1):
      SELinux: don't BUG if fs reuses a superblock

Eric Sandeen (2):
      [XFS] remove shouting-indirection macros from xfs_sb.h
      [XFS] Ensure "both" features2 slots are consistent

FUJITA Tomonori (2):
      sparc64: add the segment boundary checking to IOMMUs while merging SG entries
      sparc64: remove unused calc_npages() in iommu_common.h

Fabio Checconi (2):
      cfq-iosched: fix rcu freeing of cfq io contexts
      cfq-iosched: do not leak ioc_data across iosched switches

Florian Fainelli (1):
      USB: cp2101: Add identifiers for the Telegesys ETRX2USB

Geert Uytterhoeven (1):
      m68k: update defconfigs for 2.6.25

Grant Grundler (1):
      [netdrvr] tulip_read_eeprom fixes for BUG 4420

Harvey Harrison (2):
      net: marvell.c fix sparse shadowed variable warning
      lzo: fix typo in decompressor

Heiko Carstens (1):
      Fix "$(AS) -traditional" compile breakage caused by asmlinkage_protect

Herbert Xu (3):
      [NET]: Add preemption point in qdisc_run
      [IPV6]: Fix ICMP relookup error path dst leak
      [ICMP]: Ensure that ICMP relookup maintains status quo

Holger Schurig (2):
      libertas: fix spinlock recursion bug
      libertas: fix mode initialization problem

Hugh Dickins (2):
      splice: use mapping_gfp_mask
      scsi: fix sense_slab/bio swapping livelock

Ilpo Järvinen (4):
      [TCP]: Restore 2.6.24 mark_head_lost behavior for newreno/fack
      [TCP]: Fix NewReno's fast rexmit/recovery problems with GSOed skb
      [TCP]: tcp_simple_retransmit can cause S+L
      [TCP]: Don't allow FRTO to take place while MTU is being probed

Ingo Molnar (4):
      forcedeth: fix locking bug with netconsole
      x86: fix nmi_watchdog=2 on Pentium-D CPUs
      x86: print message if nmi_watchdog=2 cannot be enabled
      revert "x86: tsc prevent time going backwards"

Ivan Kokshaysky (1):
      alpha: fix ALSA DMA mmap crash

Ivo van Doorn (1):
      rt2x00: Ignore set_state(STATE_SLEEP) failure

J. Bruce Fields (4):
      Spell out behavior of atomic_dec_and_lock() in kerneldoc
      Documentation: move nfsroot.txt to filesystems/
      Documentation: move rpc-cache.txt to filesystems/
      Move sched-rt-group.txt to scheduler/

James Bottomley (2):
      Revert "[SCSI] fix bsg queue oops with iscsi logout"
      [SCSI] libsas: Warn if ATA device detected but CONFIG_SCSI_SAS_ATA not set

James Smart (1):
      [SCSI] hosts.c: fixes for "no error" reported after error scenarios

Jan Engelhardt (2):
      Fixes to the seq_file document
      [NETFILTER]: nf_nat: autoload IPv4 connection tracking

Jan Niehusmann (1):
      mac80211: trigger ieee80211_sta_work after opening interface

Jarek Poplawski (1):
      [ROSE/AX25] af_rose: rose_release() fix

Jeff Layton (1):
      NFS: initialize flags field in nfs_open_context

Jens Axboe (1):
      splice: fix infinite loop in generic_file_splice_read()

Jesse Barnes (1):
      fix IS_I9XX macro in i915 DRM driver

Jim Meyering (1):
      doc: fix typo in SubmittingPatches

Jiri Slaby (2):
      Char: ip2, fix sparse warnings
      Char: rio, fix sparse warnings

Johann Felix Soden (1):
      ata/sata_fsl: Remove unused variable in sata_fsl_probe

Johannes Berg (1):
      nl80211: fix STA AID bug

Jonathan Corbet (2):
      Add the seq_file documentation
      Fill out information on patch tags in SubmittingPatches

Joonwoo Park (3):
      [LLC]: bogus llc packet length
      [LLC]: station source mac address
      [LLC]: skb allocation size for responses

Josef Bacik (1):
      selinux: prevent rentry into the FS

Joy Latten (1):
      [CRYPTO] xcbc: Fix crash when ipsec uses xcbc-mac with big data chunk

Julia Lawall (1):
      drivers/net/wireless/iwlwifi/iwl-4965.c: correct use of ! and &

KAMEZAWA Hiroyuki (1):
      memcg: fix node_state handling

Karsten Wiese (1):
      x86: fix call to set_cyc2ns_scale() from time_cpufreq_notifier()

Kay Sievers (5):
      spi: fix platform driver hotplug/coldplug
      usb gadget: fix platform driver hotplug/coldplug
      usb host: fix platform driver hotplug/coldplug
      watchdog: fix platform driver hotplug/coldplug
      rtc: fix platform driver hotplug/coldplug

Ke Wei (8):
      [SCSI] mvsas: fill in error info record and phy mode6 bits.
      [SCSI] mvsas: a tag handler implementation
      [SCSI] mvsas : interrupt handling
      [SCSI] mvsas: check hd whether unplugged
      [SCSI] mvsas: retry aborting task.
      [SCSI] mvsas: fix the buffer of rx DMA overflow bug
      [SCSI] mvsas: get phy info.
      [SCSI] mvsas: check subsystem id

Ken'ichi Ohmichi (1):
      vmcoreinfo: add the symbol "phys_base"

Kim Phillips (2):
      [POWERPC] 83xx: enable usb in 837x rdb and 83xx defconfigs
      [POWERPC] sata_fsl: reduce compatibility to fsl,pq-sata

Krzysztof Helt (1):
      acpi thermal: fix result check

Kumar Gala (2):
      [POWERPC] fsldma: Use compatiable binding as spec
      [POWERPC] Fix defconfigs so we dont set both GENRTC and RTCLIB

Larry Finger (1):
      ssb-pcicore: Fix IRQ TPS flag handling

Laurent Pinchart (1):
      [POWERPC] Fix CPM2 SCC1 clock initialization.

Leonardo Potenza (1):
      [ATM] drivers/atm/iphase.c: compilation warning fix

Linus Torvalds (6):
      parport_pc: make sure to release IO ports after probing for IT87XX
      Be more careful about marking buffers dirty
      Revert "ACPI: Ignore _BQC object when registering backlight device"
      Revert "smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade"
      Add commentary about the new "asmlinkage_protect()" macro
      Linux 2.6.25-rc9

Marc Pignat (1):
      atmel_serial: fix uart/console concurrent access

Mark Fasheh (1):
      Add additional examples in Documentation/spinlocks.txt

Mark McLoughlin (3):
      xen: refactor xen_{alloc,release}_{pt,pd}()
      xen: Do not pin/unpin PMD pages
      xen: Clear PG_pinned in release_{pt,pd}()

Mathieu Desnoyers (1):
      markers: use synchronize_sched()

Matt Carlson (1):
      [TG3]: Add PHY workaround for 5784

Matti Linnanvuori (1):
      net: Comment dev_kfree_skb_irq and dev_kfree_skb_any better

Mauro Carvalho Chehab (1):
      V4L/DVB (7499): v4l/dvb Kconfig: Fix bugzilla #10067

Maxim Shchetynin (1):
      [POWERPC] Fix rtas_flash procfs interface

Michael Abd-El-Malek (1):
      xen: fix grant table bug

Michael Buesch (3):
      b43: Add DMA mapping failure messages
      b43: Fix PCMCIA IRQ routing
      ssb-mipscore: Fix interrupt vectors

Michael Ellerman (1):
      Make pasemi_mac.c depend on PPC_PASEMI to prevent link errors

Michael Hennerich (1):
      spi: spi_bfin5xx: remove unused label

Michael Krufky (4):
      V4L/DVB (7495): s5h1409: fix blown-away bit in function s5h1409_set_gpio
      V4L/DVB (7496): pvrusb2: add new usb pid for 75xxx models
      V4L/DVB (7497): pvrusb2: add new usb pid for 73xxx models
      pvrusb2: fix broken build due to patch order dependency

Michael Trimarchi (1):
      atmel_serial: avoid stopping pdc during transmission

Mike Frysinger (3):
      Blackfin EMAC Driver: delete unused variables to fixup gcc warnings
      usb net: asix does not really need 10/100mbit
      spi: spi_bfin5xx build fix

Mike Pagano (1):
      cciss: error: implicit declaration of function 'sg_init_table'

Mike Snitzer (1):
      nbd: prevent sock_xmit from attempting to use a NULL socket

Patrick McHardy (3):
      [LLC]: Restrict LLC sockets to root
      [XFRM]: xfrm_user: fix selector family initialization
      [NETFILTER]: xt_hashlimit: fix mask calculation

Paul Menage (2):
      cgroups: add cgroup support for enabling controllers at boot time
      cgroups: include hierarchy ids in /proc/<pid>/cgroup

Paul Mundt (1):
      i2c-ibm_iic: Fast mode parm desc fixup

Pavel Emelyanov (2):
      [VLAN]: Proc entry is not renamed when vlan device name changes.
      [VLAN]: Fix egress priority mappings leak.

Pavel Machek (1):
      x86, agpgart: scary messages are fortunately obsolete

Pete Zaitcev (1):
      ub: remove BUG() after __blk_end_request and fix the condition causing it

Peter Korsgaard (1):
      dm9601: Fix multicast hash table handling

Ralf Baechle (1):
      [MIPS] Handle aliases in vmalloc correctly.

Randy Dunlap (1):
      rtc: rtc-s35390a.c needs the bitreverse library

Ravikiran G Thirumalai (1):
      x86: fix breakage of vSMP irq operations

René Bürgel (1):
      [POWERPC] Fix MPC5200 (not B!) device tree so FEC ethernet works

Richard Kennedy (1):
      USB: ohci: fix 2 timers to fire at jiffies + 1s

Robert Fitzsimons (3):
      V4L/DVB (7277): bttv: Re-enabling radio support requires the use of struct bttv_fh
      V4L/DVB (7278): bttv: Re-enable radio tuner support for VIDIOCGFREQ/VIDIOCSFREQ ioctls
      V4L/DVB (7400): bttv: Add a radio compat_ioctl file operation

Robert P. J. Day (3):
      lapb: use the shorter LIST_HEAD form for brevity
      bluetooth: replace deprecated RW_LOCK_UNLOCKED macros
      efs: update error msg to not refer to deleted read_inode()

Robert Spanton (1):
      USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint requirements.

Roland McGrath (3):
      x86 ptrace: avoid unnecessary wrmsr
      asmlinkage_protect replaces prevent_tail_call
      asmlinkage_protect sys_io_getevents

Roman Zippel (1):
      HFS+: fix unlink of links

Rusty Russell (3):
      [NET]: Don't send ICMP_FRAG_NEEDED for GSO packets
      Fix booting pentium+ with dodgy TSC
      virtio: remove overzealous BUG_ON.

Sergei Shtylyov (3):
      [MIPS] Pb1200: Fix header breakage
      [MIPS] Make KGDB compile on UP
      siimage: fix kernel oops on PPC 44x

Sreenivasa Honnur (1):
      S2io: Version update for Tx completion patch

Stefano Brivio (1):
      b43legacy: fix bcm4303 crash

Stephen Hemminger (1):
      sky2: fix suspend/resume races

Stephen Smalley (2):
      selinux: handle files opened with flags 3 by checking ioctl permission
      SELinux: more GFP_NOFS fixups to prevent selinux from re-entering the fs code

Steven Rostedt (1):
      pop previous section in alternative.c

Steven Toth (3):
      V4L/DVB (7464): Convert driver to use a single SRAM memory map
      V4L/DVB (7465): Fix eeprom parsing and errors on the HVR1800 products
      V4L/DVB (7466): Avoid minor model number warning when an OEM HVR1250 board is detected

Suresh Siddha (1):
      x86: fix 64-bit asm NOPS for CONFIG_GENERIC_CPU

Sven Schnelle (3):
      afs: add missing up_write() on return
      afs: remove smp_prcessor_id() from debug macro
      rxrpc: remove smp_processor_id() from debug macro

Tejun Heo (3):
      libata: uninline atapi_cmd_type()
      libata: ATA_12/16 doesn't fall into ATAPI_MISC
      pata_ali: disable ATAPI DMA

Thomas Gleixner (2):
      x86: tsc prevent time going backwards
      x86: revert assign IRQs to hpet timer

Thomas Graf (1):
      [ESP]: Ensure IV is in linear part of the skb to avoid BUG() due to OOB access

Till Harbaum (1):
      i2c-tiny-usb: New VID/PID pair

Tobias Mueller (1):
      Input: appletouch - add product IDs for the 4th generation MacBooks

Trond Myklebust (1):
      SUNRPC: don't call flush_dcache_page() with an invalid pointer

Troy Kisky (1):
      i2c-davinci: Fix lost interrupt

Valentine Barshak (1):
      ibm_newemac: emac_tx_csum typo fix

Venki Pallipadi (1):
      x86: Simplify cpu_idle_wait

Vitja Makarov (1):
      spi: spi_bfin5xx: fix probe() sequencing

Vladimir Koutny (2):
      mac80211: correct use_short_preamble handling
      mac80211: use short_preamble mode from capability if ERP IE not present

Will Newton (1):
      Fix a typo in highres.txt

YOSHIFUJI Hideaki (2):
      [IPV6] MCAST: Ensure to check multicast listener(s).
      [IP] UDP: Use SEQ_START_TOKEN.
