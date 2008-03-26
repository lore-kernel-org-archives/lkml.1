Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYCZCIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYCZCIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYCZCH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:07:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYCZCHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:07:54 -0400
Date: Tue, 25 Mar 2008 19:07:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc7
Message-ID: <alpine.LFD.1.00.0803251856450.2775@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So this hopefully continues closing various regressions, and most of the 
changes are pretty small (ie diffstat shows a lot of oneliners). The 
biggest patches are the trivial powerpc defconfig updates which show up 
pretty clearly in the dirstat:

	  38.7% arch/powerpc/configs/
	  39.6% arch/powerpc/
	  42.9% arch/
	   2.4% drivers/ata/
	   7.6% drivers/block/
	   2.3% drivers/char/
	   2.0% drivers/message/fusion/
	   2.0% drivers/mmc/core/
	   4.1% drivers/net/
	   7.2% drivers/video/
	  38.0% drivers/
	   3.0% fs/hppfs/
	   7.8% fs/
	   2.8% kernel/
	   2.0% net/

ie if it weren't for those, the arch/ updates would hardly show up at all. 
In the drivers, the two "big" changes are also totally trivial: 
drivers/block/ shows up because of the ps2esdi driver removal (it's been 
marked BROKEN for years), and drivers/video/ shows up because of a new 
metronomefb.c driver for the E-Ink Metronome controller.

Apart from those, most of the changes really are fairly small and spread 
out. The scheduler got some tweaking, the memstick driver got some TLC, 
and cifs and reiserfs had some fixes.

The shortlog has more details, but it boils down to some reverts, some 
docbook fixes, some sparse annotation fixups, a number of trivial patches, 
and a healthy sprinkling of small fixups.

Give it a good testing, because we're hopefully now well on our way 
towards that eventual real 2.6.25 release!

		Linus

---
Adrian Bunk (4):
      The ps2esdi driver was marked as BROKEN more than two years ago due to being
      make selinux_parse_opts_str() static
      V4L/DVB (7251): VIDEO_VIVI must depend on VIDEO_DEV
      V4L/DVB (7328): usb/opera1.c: fix a memory leak

Ahmed S. Darwish (2):
      smack: do not dereference NULL ipc object
      smackfs: remove redundant lock, fix open(,O_RDWR)

Akinobu Mita (1):
      [SCSI] a100u2w: fix bitmap lookup routine

Al Viro (21):
      r6040 endianness fixes
      wan/farsync: copy_from_user() to iomem is wrong
      fore2000 - fix misannotations
      more misannotations: ne2k-pci
      ipg fix
      epic100 endianness annotations and fixes
      hfs_bnode_find() can fail, resulting in hfs_bnode_split() breakage
      restore export of do_kern_mount()
      [NET] endianness noise: INADDR_ANY
      [PKT_SCHED]: annotate cls_u32
      [SCTP]: fix misannotated __sctp_rcv_asconf_lookup()
      [SUNRPC]: net/* NULL noise
      [IPV4]: ipv4_is_lbcast() misannotations
      xfrm: ->eth_proto is __be16
      [8021Q]: vlan_dev misannotations
      [IPV4]: esp_output() misannotations
      sanitize hppfs
      double dput() on failure exit in tiny-shmem
      double iput() on failure exit in hugetlb
      get stack footprint of pathname resolution back to relative sanity
      drivers/char/rocket portability fixes

Alan Cox (1):
      3c501: Further coding style fixes

Alan Stern (1):
      USB: new quirk flag to avoid Set-Interface

Alessandro Zummo (1):
      rtc: fix kconfig help

Alex Deucher (1):
      drm/radeon: fixup RV550 chip family

Alex Dubov (3):
      memstick: automatically retrieve "INT" value from command response
      memstick: add support for 8-bit parallel mode
      memstick: optimize setup of JMicron host parameters

Alexey Starikovskiy (2):
      ACPI: battery: Don't return -EFAIL on broken packages.
      Revert "ACPI: EC: Handle IRQ storm on Acer laptops"

Amit Shah (1):
      virtio: Enable netpoll interface for netconsole logging

Anand Gadiyar (1):
      ARM: OMAP: Fix chain_a_transfer return value

Anatolij Gustschin (1):
      [POWERPC] Fix Oops with TQM5200 on TQM5200

Andre Noll (1):
      [NET]: Fix permissions of /proc/net

Andrew Burton (1):
      HID: BADPAD entry for NATSU Playstation USB adapter

Andrew Morton (11):
      Input: ads7846 - fix uninitialized var warning
      [RT2X00] drivers/net/wireless/rt2x00/rt2x00dev.c: remove dead code, fix warning
      memstick: drivers/memstick/host/jmb38x_ms.c needs dma-mapping.h
      memstick: drivers/memstick/host/jmb38x_ms.c: suppress uninitialized var warning
      drivers/md/raid5.c: fix printk warnings
      fs/ufs/balloc.c: fix sparc64 printk warning
      revert "clocksource: make clocksource watchdog cycle through online CPUs"
      V4L/DVB (7291): em28xx: correct use of and fix
      revert "kswapd should only wait on IO if there is IO"
      driver core: debug for bad dev_attr_show() return value.
      PCI: revert "pcie: utilize pcie transaction pending bit"

Andrew Victor (2):
      [ARM] 4861/1: AT91: Update maintainer email address (again)
      [ARM] 4863/1: AT91: CAP9 USART definitions for early debug

Anthony Liguori (1):
      virtio: Use spin_lock_irqsave/restore for virtio-pci

Anton Blanchard (1):
      [POWERPC] Fix PMU + soft interrupt disable bug

Arnaud Patard (1):
      [ARM] 4864/1: Enable write buffer coalescing on IOP

Avi Kivity (3):
      KVM: VMX: Restore tss even on x86_64
      KVM: MMU: Fix is_rmap_pte() with io ptes
      KVM: MMU: Fix memory leak on guest demand faults

Ayaz Abdulla (1):
      forcedeth: limit tx to 16

Bartlomiej Zolnierkiewicz (6):
      ide: remove commented out entries from ide_pio_blacklist[]
      ide: mark special "ide0=" kernel parameters as obsoleted
      ide: Documentation/ide/ide.txt fixes
      ide: mark "hdx=[driver_name]" and "hdx=scsi" kernel parameters as obsoleted
      ide: mark "hdx=remap" and "hdx=remap63" kernel parameters as obsoleted
      Revert "ide-tape: schedule driver for removal after 6 months"

Bjorn Helgaas (2):
      ISAPNP: fix limits of logical device register set
      ACPI: fix Medion _PRT quirk (use "ISA_", not "ISA")

Boaz Harrosh (2):
      [SCSI] isd200: Allocate sense_buffer for hacked up scsi_cmnd
      USB: isd200: fix memory leak in isd200_get_inquiry_data

Bryan Wu (1):
      i2c-bfin-twi: Disable BF54x support for now

Chien Tung (1):
      RDMA/nes: Fix MSS calculation on RDMA path

Christian Borntraeger (1):
      virtio: fix race in enable_cb

Christoph Hellwig (1):
      check for null vfsmount in dentry_open()

Christoph Lameter (1):
      slub page alloc fallback: Enable interrupts for GFP_WAIT.

Chuck Lever (1):
      x86: fix {clear,copy}_user_page() declarations in page.h

Coleman Kane (1):
      x86: add the DFF (Desktop Form Factor) Dell Optiplex 745 to the reboot errata list

Constantin Baranov (1):
      USB: add support for Motorola ROKR Z6 cellphone in mass storage mode

Cyrill Gorcunov (1):
      V4L/DVB (7330): V4L1 - fix v4l_compat_translate_ioctl possible NULL deref

Dan Williams (1):
      async_tx: avoid the async xor_zero_sum path when src_cnt > device->max_xor

Daniel Hokka Zakrisson (1):
      [NETFILTER]: ipt_recent: sanity check hit count

Darren Salt (1):
      PNP: increase the number of PnP memory resources from 12 to 24

Darrick J. Wong (3):
      ibmpex: correct power use multipliers for QS2x blade
      ibmpex: update Kconfig to list more supported models
      ibmpex: report temperatures in mC, not C

Dave Airlie (1):
      drm/ati_pcigart: fix the PCIGART to use drm_pci to allocate GART table.

Dave Hansen (2):
      hppfs pass vfsmount to dentry_open()
      fix up new filp allocators

Dave Young (1):
      zisofs: fix readpage() outside i_size

David Brownell (2):
      rtc-at91sam9 fixes
      hw_random doc updates

David Howells (1):
      ROMFS: Fix up an error in iget removal

David S. Miller (5):
      [SPARC64]: Fix atomic backoff limit.
      [TG3]: Fix build warning on sparc32.
      [SCTP]: Fix build warnings with IPV6 disabled.
      [SPARC64]: Remove most limitations to kernel image size.
      [SUNGEM]: Fix NAPI assertion failure.

Davide Rizzo (1):
      [ARM] 4872/1: Replaces buggy macro in S3C2410 irq include

Divy Le Ray (1):
      cxgb3: Fix transmit queue stop mechanism

Dmitry Torokhov (1):
      Input: ALPS - put secondary device in proper place in sysfs

Duane Griffin (2):
      jbd: correctly unescape journal data blocks
      jbd2: correctly unescape journal data blocks

Eliezer Tamir (1):
      BNX2X: prevent ethtool from setting port type

Eric Paris (1):
      export sessionid alongside the loginuid in procfs

Evgeniy Polyakov (1):
      connector: convert to single-threaded workqueue

Fabio Checconi (1):
      bridge: use time_before() in br_fdb_cleanup()

Franck Bui-Huu (1):
      sh: Use relative paths for mach/cpu symlinks.

Fred Isaman (1):
      nfs: don't ignore return value from nfs_pageio_add_request

Gadiyar, Anand (1):
      ARM: OMAP: Fix DMA CLINK mask, clear spurious interrupt

Gordon Farquharson (1):
      [ARM] 4865/1: Register the F75375 device in the GLAN Tank platform code

Grant Grundler (1):
      2.6.25-rc4 de_stop_rxtx polling wrong

Grant Likely (3):
      [POWERPC] mpc5200-fec: Fix possible NULL dereference in mdio driver
      [POWERPC] mpc5200: Fix null dereference if bestcomm fails to initialize
      [POWERPC] mpc5200: Fix incorrect compatible string for the mdio node

Hans Rosenfeld (1):
      Change pagemap output format to allow for future reporting of huge pages

Harvey Harrison (4):
      [CIFS] cifs: replace remaining __FUNCTION__ occurrences
      b43: phy.c fix typo in register write
      ioc3.c: replace remaining __FUNCTION__ occurrences
      V4L/DVB (7236): bttv: struct member initialized twice

Heiko Carstens (3):
      [S390] futex: let futex_atomic_cmpxchg_pt survive early functional tests.
      sched: add exported arch_reinit_sched_domains() to header file.
      sched: add arch_update_cpu_topology hook.

Heinz-Ado Arnolds (1):
      x86: fix reboot problem with Dell Optiplex 745, 0KW626 board

Herbert Xu (1):
      [TCP]: Let skbs grow over a page on fast peers

Holger Macht (1):
      ACPI: Set flag DOCK_UNDOCKING when triggered via sysfs

Ian Armstrong (2):
      V4L/DVB (7242): ivtv: fix for yuv filter table check
      V4L/DVB (7279): ivtv: Add missing sg_init_table()

Igor Mammedov (1):
      [CIFS]  DFS patch that connects inode with dfs handling ops

Ingo Molnar (8):
      sched: clean up wakeup balancing, move wake_affine()
      sched: clean up wakeup balancing, rename variables
      sched: clean up wakeup balancing, code flow
      sched, net: socket wakeups are sync
      sched: improve affine wakeups
      sched: wakeup-buddy tasks are cache-hot
      sched: retune wake granularity
      sched: tune multi-core idle balancing

Ingo van Lil (1):
      mtd: memory corruption in block2mtd.c

Ivo van Doorn (1):
      rt2x00: Add suspend/resume handlers to rt2x00rfkill

James Bottomley (1):
      [SCSI] Fix dependency problems in SCSI drivers

Jan Kara (1):
      quota: add possibly missing iput() when quotaon and quotaoff races

Jan Slupski (1):
      prism54: support for 124a:4025 - another version of IOGear GWU513 802.11g

Jarek Poplawski (2):
      netpoll: zap_completion_queue: adjust skb->users counter
      [NET] ifb: set separate lockdep classes for queue locks

Jaya Kumar (1):
      fbdev: defio and Metronomefb

Jean Delvare (1):
      ASoC/TLV320AIC3X: Stop I2C driver ID abuse

Jean-Christophe Dubois (1):
      rndis_host: fix transfer size negotiation

Jean-Samuel Chenard (1):
      UIO: add pgprot_noncached() to UIO mmap code

Jeff Garzik (1):
      [libata] ahci: SB600 workaround is suspect... play it safe for now

Jeff Mahoney (1):
      reiserfs: eliminate private use of struct file in xattr

Jens Axboe (2):
      relay: fix subbuf_splice_actor() adding too many pages
      Revert "unexport bio_{,un}map_user"

Jeremy Katz (1):
      virtio: Fix sysfs bits to have proper block symlink

Jiri Kosina (3):
      Input: i8042 - add Lenovo 3000 N100 to nomux blacklist
      Input: document i8042.noloop
      HID: fix comment in hid_input_report()

Jiri Slaby (1):
      x86: fix fault_msg nul termination

Joakim Tjernlund (1):
      ucc_geth: use correct thread number for 10/100Mbps link

Jose Alberto Reguero (1):
      ahci: Add Marvell 6121 SATA support

Josef Bacik (1):
      ext3: fix wrong gfp type under transaction

Julia Lawall (7):
      drivers/net/ipg.c: remove unused variable
      drivers/net/atl1/atl1_main.c: remove unused variable
      asus_acpi: remove misleading mask
      HID: Use DIV_ROUND_UP
      V4L/DVB (7285): em28xx: Correct use of ! and &
      [IPV6] net/ipv6/ndisc.c: remove unused variable
      [9P] net/9p/trans_fd.c: remove unused variable

Kay Sievers (2):
      [SCSI] sd, sr: do not emit change event at device add
      [SCSI] fix media change events for polled devices

Kevin Hilman (2):
      ARM: OMAP: Fix clockevent support for hrtimers
      ARM: OMAP: Fix GPIO IRQ unmask

Kevin Lloyd (1):
      USB: sierra: add another device id

Kieran Bingham (1):
      sh: Fix up the address error exception handler for SH-2.

Kumar Gala (1):
      [POWERPC] Update some defconfigs

Laszlo Kajan (1):
      Input: ALPS - fix forward/back buttons reversed on Acer 5520-5290

Len Brown (5):
      ACPI: fix ATA_ACPI build
      Revert "thermal: fix generic thermal I/F for hwmon"
      thermal: delete "default y"
      Revert "ACPI: video: Ignore ACPI video devices that aren't present in hardware"
      Revert "ACPI: video: Ignore devices that aren't present in hardware"

Linus Torvalds (5):
      IDE: Make taskfile interface more robust wrt unexpected end-of-command
      Don't 'printk()' while holding xtime lock for writing
      x86-32: Pass the full resource data to ioremap()
      Make printk() console semaphore accesses sensible
      Linux 2.6.25-rc7

Marcelo Tosatti (2):
      KVM: MMU: handle page removal with shadow mapping
      KVM: VMX: convert init_rmode_tss() to slots_lock

Mark Fasheh (1):
      ocfs2: MAINTAINERS update

Mark Gross (1):
      PCI: iova: lockdep false alarm fix

Mark Lord (1):
      pciehp: don't enable slot unless forced

Martin Devera (1):
      sch_htb: fix "too many events" situation

Masakazu Mokuno (2):
      PS3: gelic: ignore scan info from zero SSID beacons
      PS3: gelic: change the prefix of the net interface for wireless

Mathieu Desnoyers (3):
      x86: cast cmpxchg and cmpxchg_local result for 386 and 486
      markers: update preempt_disable. call_rcu, rcu_barrier comments
      markers: remove ACCESS_ONCE

Matthew Wilcox (1):
      [SCSI] advansys: Fix bug in AdvLoadMicrocode

Matti Linnanvuori (1):
      sync_bitops: fix wrong comments [Bug 10247]

Mauro Carvalho Chehab (3):
      V4L/DVB (7267): cx88: Fix: Loads tuner module before sending commands to it
      V4L/DVB (7268): saa7134: fix: tuner should be loaded before calling saa7134_board_init2()
      V4L/DVB (7367): bug #10211: Fix depencencies for cx2341x

Max Arnold (1):
      USB: pl2303: another product ID

Michael Ellerman (2):
      [POWERPC] Fix cell IOMMU code to cope with empty dma-ranges and non-PCI devices
      [POWERPC] Hide resources on Axon PCIE root complex nodes

Michael Halcrow (1):
      eCryptfs: Swap dput() and mntput()

Michael Hanselmann (1):
      HID: update key codes for Apple aluminium

Mikael Pettersson (1):
      sata_promise: fix hardreset hotplug events, take 2

Mike Christie (1):
      [SCSI] fix bsg queue oops with iscsi logout

Mike Isely (1):
      drm: Fix race that can lockup the kernel

Mitch Williams (1):
      igb: Correctly get protocol information

NeilBrown (1):
      md: remove the 'super' sysfs attribute from devices in an 'md' array

Olaf Hering (1):
      [POWERPC] Fix crash in init_ipic_sysfs on efika

Oliver Neukum (1):
      USB: sierra: dma fixes

Pascal Terjan (1):
      V4L/DVB (7334): usb video: add a device link to usbvideo devices, else hal will ignore them

Patrick McHardy (1):
      [TCP]: Fix shrinking windows with window scaling

Paul E. McKenney (1):
      rcu: fix misplaced mb() in rcu_enter/exit_nohz()

Paul Gortmaker (1):
      [POWERPC] Fix build failure for tqm8540 and sbc85xx defconfigs

Paul Mackerras (2):
      [POWERPC] Update some defconfigs
      [POWERPC] Don't use 64k pages for ioremap on pSeries

Paul Mundt (3):
      sh: Fix up the timer IRQ definition for SH7203.
      sh: Fix uImage build error.
      sh: Fix more user header breakage from sh64 integration.

Pavel Emelyanov (5):
      memcgroup: fix check for thread being a group leader in memcgroup
      audit: netlink socket can be auto-bound to pid other than current->pid (v2)
      [DLCI]: Fix tiny race between module unload and sock_ioctl.
      bsd_acct: plain current->real_parent access is not always safe
      bsd_acct: using task_struct->tgid is not right in pid-namespaces

Pavel Machek (3):
      MAINTAINERS: bluez-devel is subscribers-only
      x86: fix long standing bug with usb after hibernation with 4GB ram
      kernel-parameters.txt: document memmap option better

Pavel Roskin (1):
      ath5k: disable irq handling in ath5k_hw_detach()

Peter Zijlstra (1):
      sched: cleanup old and rarely used 'debug' features.

Phil Oester (1):
      [IPV4]: Fix null dereference in ip_defrag

Pierre Ossman (1):
      mmc: use sysfs groups to handle conditional attributes

Ping Cheng (1):
      Input: wacom - add support for Bamboo1, BambooFun, and Cintiq 12WX

Prakash, Sathya (1):
      [SCSI] mpt fusion: Power Management fixes for MPT SAS PCI-E controllers

Pravin M. Bathija (1):
      NEWEMAC: fix support for pause packets

Quentin Barnes (1):
      aio: bad AIO race in aio_complete() leads to process hang

Ralf Baechle (1):
      [IOC3] Fix section missmatch

Randy Dunlap (10):
      mm: fix various kernel-doc comments
      mm/shmem and tiny-shmem: fix some kernel-doc
      mm/oom_kill: fix kernel-doc
      mm: highmem kernel-doc additions
      mm: rmap kernel-doc fixes
      jbd: fix jbd kernel-doc notation
      fs: fix kernel-doc notation warnings
      mm/readahead: fix kernel-doc notation
      x86/visws: fix printk format warnings
      i2c: Fix docbook problem

Rene Herman (1):
      USB: ehci: stop vt6212 bus hogging

Robert P. J. Day (3):
      SH: Use newer, non-deprecated __SPIN_LOCK_UNLOCKED macro.
      [SPARC64]: Use shorter list_splice_init() for brevity.
      USB: Fix cut-and-paste error in rtl8150.c

Roel Kluin (3):
      V4L/DVB (7362): tvp5150.c: logical-bitwise and confusion
      [NETFILTER]: nf_conntrack_h323: logical-bitwise & confusion in process_setup()
      sched: remove double unlikely from schedule()

Roland Dreier (2):
      Input: i8042 - fix warning on non-x86 builds
      SVCRDMA: Use only 1 RDMA read scatter entry for iWARP adapters

Roland McGrath (2):
      [POWERPC] user_regset PTRACE_SETREGS regression fix
      [SPARC64]: exec PT_DTRACE

Roy Hashimoto (1):
      USB: fix gadgetfs class request delegation

Rusty Russell (1):
      virtio: handle > 2 billion page balloon targets

Sam Ravnborg (1):
      kbuild: soften modpost checks when doing cross builds

Samuel Thibault (1):
      Input: add keyboard notifier documentation

Serge Hallyn (1):
      file capabilities: remove cap_task_kill()

Stefan Bauer (1):
      i810fb: fix console switch regression

Stefan Richter (1):
      firewire: fix panic in handle_at_packet

Stefan Roese (1):
      NEWEMAC: Add compatible "ibm,tah" to tah matching table

Stephen Hemminger (1):
      [IPV4] fib_trie: fix warning from rcu_assign_poinger

Steve French (4):
      [CIFS] Fix build problem
      [CIFS] Fix mtime on cp -p when file data cached but written out too late
      [CIFS] file create with acl support enabled is slow
      [CIFS] Fix mem leak on dfs referral

Sven Schnelle (1):
      [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference

Tejun Heo (9):
      libata-acpi: improve dock event handling
      devres: implement pcim_iomap_regions_request_all()
      ahci: request all PCI BARs
      ahci: implement skip_host_reset parameter
      pata_ali: use atapi_cmd_type() to determine cmd type instead of transfer size
      libata: implement ata_qc_raw_nbytes()
      pata_it821x: use raw nbytes in check_atapi_dma
      libata: assume no device is attached if both IDENTIFYs are aborted
      libata: improve HPA error handling

Thomas Bogendoerfer (1):
      Input: i8042 - add SNI RM support

Thomas Gleixner (1):
      x86: revert: reserve dma32 early for gart

Thomas Hellstrom (1):
      drm/via: attempt again to stabilise the AGP DMA command submission.

Tobias Mueller (1):
      HID: remove HID_QUIRK_APPLE_ISO_KEYBOARD for 4th generation macbook

Tony Lindgren (3):
      ARM: OMAP: Fix missing makefile options
      [ARM] 4869/1: ARM: OMAP: Fix compile for mcbsp
      i2c-omap: Fix unhandled fault

Venki Pallipadi (1):
      ACPI: lockdep warning on boot, 2.6.25-rc5

Vlad Yasevich (1):
      [SCTP]: Fix a race between module load and protosw access

Wang Chen (1):
      [ATM]: When proc_create() fails, do some error handling work and return -ENOMEM.

Will Newton (1):
      ARM: OMAP1: Fix typo in OMAP1 MPU clock source initialization

YOSHIFUJI Hideaki (1):
      [IPV6] KCONFIG: Fix description about IPV6_TUNNEL.

Yinghai Lu (6):
      x86: fix dma_alloc_pages
      x86: tight online check in setup_per_cpu_areas
      x86: reserve dma32 early for gart
      x86: trim mtrr don't close gap for resource allocation.
      x86_64: free_bootmem should take phys
      mm: fix boundary checking in free_bootmem_core

Yoichi Yuasa (1):
      Input: cobalt_btns - assorted fixes

Yuri Funduryan (1):
      V4L/DVB (7228): saa7134: fix FM radio support for the Pinnacle PCTV 110i

Yutaro Ebihara (1):
      serial: sh-sci: Fix fifo stall on SH7760/SH7780/SH7785 SCIF.

Zbigniew Luszpinski (1):
      x86: hpet clock enable quirk on nVidia nForce 430

Zhang Wei (1):
      fsldma: Fix the DMA halt when using DMA_INTERRUPT async_tx transfer.

Zhang, Rui (1):
      thermal: re-document thermal units

janboe (1):
      [ARM] 4870/1: fix signal return code when enable CONFIG_OABI_COMPAT

nickcheng (1):
      [SCSI] arcmsr: fix iounmap error for Type B adapter
