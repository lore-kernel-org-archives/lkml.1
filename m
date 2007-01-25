Return-Path: <linux-kernel-owner+w=401wt.eu-S965220AbXAYC6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbXAYC6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXAYC6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:58:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220AbXAYC6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:58:14 -0500
Date: Wed, 24 Jan 2007 18:58:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.20-rc6
Message-ID: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1993476379-1169693891=:25027"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1993476379-1169693891=:25027
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


It's been more than a week since -rc5, but I blame everybody (including 
me) being away for Linux.conf.au and then me waiting for a few days 
afterwards to let everybody sync up.

So there it is, -rc6, hopefully the last -rc of the series.

I'd like everybody to take a really good look at any regressions that 
Adrian has been pointing out, and that very much includes the people who 
reported them too, so that we can confirm whether they are still active 
and relevant.

As to -rc6 itself: the bulk of it are the MTD updates (including a few new 
drivers), and the POWER update (and the bulk of _that_ in terms of patch 
size being defconfig updates ;)

But there's various random fixes in infiniband, DVB, network drivers, 
scsi, usb, some filesystems (cifs, jffs2, nfs, ntfs, ocfs2) as well as 
core networking too.

Oh, and KVM, of course.

And stuff I probably have already forgotten.

ShortLog appended.

		Linus

---
Adrian Bunk (7):
      [MTD] SSFDC must depend on BLOCK
      [MTD] [NAND] rtc_from4.c: use lib/bitrev.c
      [MTD] make drivers/mtd/cmdlinepart.c:mtdpart_setup() static
      [SCSI] qla2xxx: make qla2x00_reg_remote_port() static
      more ftape removal
      [IRDA] vlsi_ir.{h,c}: remove kernel 2.4 code
      [NET]: Process include/linux/if_{addr,link}.h with unifdef

Adrian Friedli (1):
      HID: GEYSER4_ISO needs quirk

Adrian Hunter (2):
      [MTD] OneNAND: Implement read-while-load
      [MTD] OneNAND: Handle DDP chip boundary during read-while-load

Akinobu Mita (2):
      [JFFS2] Use rb_first() and rb_last() cleanup
      [SCSI] iscsi: fix crypto_alloc_hash() error check

Al Viro (5):
      funsoft: ktermios fix
      horizon.c: missing __devinit
      s2io bogus memset
      fix prototype of csum_ipv6_magic() (ia64)
      s2io bogus memset

Alan Cox (1):
      [MTD] MAPS: esb2rom: use hotplug safe interfaces

Alexey Dobriyan (2):
      [MTD] JEDEC probe: fix comment typo (devic)
      [MIPS] There is no __GNUC_MAJOR__

Amit Choudhary (1):
      [JFFS2] Fix error-path leak in summary scan

Amit S. Kale (2):
      NetXen: Firmware check modifications
      NetXen: Use pci_register_driver() instead of pci_module_init() in init_module

Andres Salomon (1):
      USB: asix: Detect internal PHY and enable/use accordingly

Andrew Hendry (1):
      [X.25]: Add missing sock_put in x25_receive_data

Andrew Morton (4):
      [MTD] Tidy bitrev usage in rtc_from4.c
      fix "kvm: add vm exit profiling"
      blockdev direct_io: fix signedness bug
      SubmitChecklist update

Andrew Vasquez (9):
      [SCSI] qla2xxx: Don't log trace-control async-events.
      [SCSI] qla2xxx: Correct endianess issue while interrogating MS status.
      [SCSI] qla2xxx: Use proper prep_ms_iocb() function during GFPN_ID.
      [SCSI] qla2xxx: Detect GPSC capabilities within a fabric.
      [SCSI] qla2xxx: Correct IOCB queueing mechanism for ISP54XX HBAs.
      [SCSI] qla2xxx: Correct reset handling logic.
      [SCSI] qla2xxx: Perform a fw-dump when an ISP23xx RISC-paused state is detected.
      [SCSI] qla2xxx: Use generic isp_ops.fw_dump() function.
      [SCSI] qla2xxx: Update version number to 8.01.07-k4.

Andrew Victor (2):
      [MTD] NAND: AT91 NAND driver
      [MTD] NAND: Support for 16-bit bus-width on AT91.

Anssi Hannula (1):
      HID: put usb_interface instead of usb_device into hid->dev to fix udevinfo breakage

Anton Altaparmakov (2):
      NTFS: 2.1.28 - Fix deadlock reported by Sergey Vlasov due to ntfs_put_inode().
      NTFS: Forgot to bump version number in makefile to 2.1.28...

Arne Redlich (1):
      [SCSI] iscsi: fix 2.6.19 data digest calculation bug

Artem Bityutskiy (10):
      [MTD] core: trivial comments fix
      [MTD] NAND: nandsim: support subpage write
      [MTD] increase MAX_MTD_DEVICES
      [MTD] add get_mtd_device_nm() function
      [MTD] add get and put methods
      [MTD] return error code from get_mtd_device()
      [MTD] nandsim: bugfix in page addressing
      [JFFS2] add cond_resched() when garbage collecting deletion dirent
      [JFFS2] Reschedule in loops
      [MTD] OneNAND: release CPU in cycles

Atsushi Nemoto (1):
      [MIPS] Fix wrong checksum calculation on 64-bit MIPS

Avi Kivity (4):
      KVM: make sure there is a vcpu context loaded when destroying the mmu
      KVM: fix race between mmio reads and injected interrupts
      KVM: x86 emulator: fix bit string instructions
      KVM: fix bogus pagefault on writable pages

Benjamin Herrenschmidt (2):
      [POWERPC] Remove bogus sanity check in pci -> OF node code
      [POWERPC] Fix cell's mmio nvram to properly parse device tree

Brian Haley (1):
      [SCTP]: Fix compiler warning.

Brian King (2):
      libata: Fixup n_elem initialization
      libata: Initialize qc->pad_len

Brice Goglin (3):
      myri10ge: make wc_fifo usage load-time tunable
      myri10ge: check that we can get an irq
      myri10ge: update driver version to 1.2.0

Burman Yan (1):
      [MTD] replace kmalloc+memset with kzalloc

Carlos Eduardo Aguiar (1):
      omap: Update MMC response types

Chen, Kenneth W (1):
      fix blk_direct_IO bio preparation

Chris Lalancette (1):
      8139cp: Don't blindly enable interrupts

Christoph Lameter (1):
      mbind: restrict nodes to the currently allowed cpuset

Dale Farnsworth (1):
      mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs

Daniel Gollub (1):
      USB: rndis_host: fix crash while probing a Nokia S60 mobile

Daniel Ritz (1):
      usbtouchscreen: make ITM screens report BTN_TOUCH as zero when not touched

Dave Olsen (1):
      [MTD] [MAPS] Support for BIOS flash chips on the nvidia ck804 southbridge

David Anders (1):
      [MTD] NOR: leave Intel chips in read-array mode on suspend

David Woodhouse (22):
      [MTD NAND] Initial import of CAFÉ NAND driver.
      [MTD NAND] OLPC CAFÉ driver update
      [MTD] NAND: Combined oob buffer so it's contiguous with data
      [MTD] NAND: Correct setting of chip->oob_poi OOB buffer
      [MTD] NAND: Add hardware ECC correction support to CAFÉ NAND driver
      [MTD] NAND: CAFÉ NAND driver cleanup, fix ECC on reading empty flash
      [MTD] NAND: Disable ECC checking on CAFÉ since it's broken for now
      [MTD] NAND: Café ECC -- remove spurious BUG_ON() in err_pos()
      [MTD] NAND: Reset Café controller before initialising.
      [MTD] CAFÉ NAND: Add 'slowtiming' parameter, default usedma and checkecc on
      [MTD] NAND: Add ECC debugging for CAFÉ
      [MTD] NAND: Remove empty block ECC workaround
      [MTD] NAND: Fix timing calculation in CAFÉ debugging message
      [MTD] NAND: Use register #defines throughout CAFÉ driver, not numbers
      [MTD] NAND: Add register debugging spew option to CAFÉ driver
      [MTD] NAND: Fix ECC settings in CAFÉ controller driver.
      [MTD] [NAND] Update CAFÉ driver interrupt handler prototype
      [MTD] Use EXPORT_SYMBOL_GPL() for exported symbols.
      [MTD] Remove trailing whitespace
      [MTD] Fix SSFDC build for variable blocksize.
      [MTD] Fix ssfdc blksize typo
      [JFFS2] debug.h: include <linux/sched.h> for current->pid

Eric Moore (4):
      [SCSI] fusion: fibre channel: return DID_ERROR for MPI_IOCSTATUS_SCSI_IOC_TERMINATED
      [SCSI] fusion: power pc and miscellaneous bug fixs
      [SCSI] fusion: MODULE_VERSION support
      [SCSI] fusion: bump version

FUJITA Tomonori (1):
      [SCSI] iscsi: simplify IPv6 and IPv4 address printing

Francois Romieu (1):
      sis190: failure to set the MAC address from EEPROM

Gerd Hoffmann (1):
      V4L/DVB (5069): Fix bttv and friends on 64bit machines with lots of memory

Gong Jun (3):
      hwmon/w83793: Remove the description of AMDSI and update the voltage formula
      hwmon/w83793: Ignore disabled temperature channels
      hwmon/w83793: Hide invalid VID readings

Grant Grundler (1):
      PCI: rework Documentation/pci.txt

Grant Likely (2):
      V4L/DVB (5024): Fix quickcam communicator driver for big endian architectures
      [POWERPC] Make it blatantly clear; mpc5200 device tree is not yet stable

Greg Kroah-Hartman (1):
      USB: disable USB_MULTITHREAD_PROBE

Guy Streeter (1):
      correct sys_shmget allocation check

Haavard Skinnemoen (1):
      [MTD] bugfix: DataFlash is not bit writable

Herbert Xu (3):
      vmx: Fix register constraint in launch code
      [IPSEC] flow: Fix potential memory leak
      [IPSEC]: Policy list disorder

Hoang-Nam Nguyen (2):
      IB/ehca: Fix improper use of yield() with spinlock held
      IB/ehca: Fix mismatched spin_unlock in irq handler

Horms (2):
      Kdump documentation update: kexec-tools update
      Kdump documentation update: ia64 portion

Ingo Molnar (2):
      paravirt: mark the paravirt_ops export internal
      notifiers: fix blocking_notifier_call_chain() scalability

Ishai Rabinovitz (1):
      IB/srp: Check match_strdup() return

James Bottomley (4):
      [SCSI] scsi_transport_spi: fix sense buffer size error
      [SCSI] seagate: remove BROKEN tag
      [SCSI] scsi_scan: fix report lun problems with CDROM or RBC devices
      x86: fix PDA variables to work during boot

Jamie Lenehan (1):
      rtc-sh: act on rtc_wkalrm.enabled when setting an alarm

Jarek Poplawski (1):
      [TCP]: rare bad TCP checksum with 2.6.19

Jean Delvare (2):
      hwmon: Fix the VRD 11 decoding
      PCI: Unhide the SMBus on the Asus P4P800-X

Jeff Chua (1):
      acpi: remove "video device notify" message

Jeff Garzik (2):
      [JFFS2] kill warning RE debug-only variables
      Note that JFFS (v1) is to be deleted, in feature-removal-schedule.txt

Jeremy Roberson (1):
      hid-core.c: Adds GTCO CalComp Interwrite IPanel PIDs to blacklist

Jes Sorensen (1):
      [SCSI] qla1280: set residual correctly

Jiri Kosina (3):
      HID: update MAINTAINERS entry for USB-HID
      HID: compilation fix when DEBUG_DATA is defined
      HID: hid/hid-input.c doesn't need to include linux/usb/input.h

Josh Boyer (1):
      [MTD] add MTD_BLKDEVS Kconfig option

Karsten Wiese (1):
      [ALSA] Repair snd-usb-usx2y over OHCI

Komuro (1):
      modify 3c589_cs to be SMP safe

Kumar Gala (1):
      PHY: Export phy ethtool helpers

Kyungmin Park (9):
      MTD: OneNAND: interrupt based wait support
      [MTD] OneNAND: lock support
      [MTD] OneNAND: Single bit error detection
      [MTD] OneNAND: fix oob handling in recent oob patch
      [JFFS2] use the ref_offset macro
      [MTD] OneNAND: fix onenand_wait bug
      [MTD] OneNAND: add subpage write support
      [MTD] OneNAND: fix onenand_wait bug in read ecc error
      [MTD] OneNAND: return ecc error code only when 2-bit ecc occurs

Larry Finger (1):
      bcm43xx: Fix failure to deliver PCI-E interrupts

Lew Glendenning (1):
      [MTD] MAPS: Support for BIOS flash chips on Intel ESB2 southbridge

Li Yang (1):
      [POWERPC] Fix OF node refcnt underflow in 836x and 832x platform code

Linas Vepstas (2):
      [POWERPC] Fix broken DMA on non-LPAR pSeries
      elevator: move clearing of unplug flag earlier

Linus Torvalds (4):
      Revert "[PATCH] Fix up mmap_kmem"
      Clear spurious irq stat information when adding irq handler
      Change Linus' email address too
      Linux 2.6.20-rc6

Luca Pedrielli (1):
      sata_via: add PCI ID 0x5337

Manuel Osdoba (1):
      USB: unusual_devs.h entry for nokia 6233

Marcel Holtmann (2):
      [Bluetooth] Missing endian swapping for L2CAP socket list
      [Bluetooth] Restrict well known PSM to privileged users

Mariusz Kozlowski (2):
      [MTD] [NAND] Compile fix in rfc_from4.c
      [SCSI] scsi: lpfc error path fix

Mark Fasheh (4):
      ocfs2: Don't print errors when following symlinks
      ocfs2: Directory c/mtime update fixes
      ocfs2: cleanup ocfs2_iget() errors
      ocfs2: Add backup superblock info to ocfs2_fs.h

Mark Gross (1):
      tlclk: bug fix + misc fixes

Martin Samuelsson (1):
      V4L/DVB (5029): Ks0127 status flags

Masahide NAKAMURA (1):
      [IP] TUNNEL: Fix to be built with user application.

Masayuki Nakagawa (1):
      [TCP]: skb is unexpectedly freed.

Matthew Wilcox (1):
      [SCSI] Add missing completion to scsi_complete_async_scans()

Mauro Carvalho Chehab (2):
      V4L/DVB (5020): Fix: disable interrupts while at KM_BOUNCE_READ
      V4L/DVB (5023): Fix compilation on ppc32 architecture

Meelis Roos (1):
      [SCSI] iscsi: newline in printk

Michael Krufky (1):
      V4L/DVB (5071): Tveeprom: autodetect LG TAPC G701D as tuner type 37

Mikael Pettersson (1):
      [NETFILTER]: fix xt_state compile failure

Mike Christie (1):
      [SCSI] libiscsi: fix senselen calculation

Noriaki TAKAMIYA (1):
      [IPV6]: Fixed the size of the netlink message notified by inet6_rt_notify().

Oleg Nesterov (1):
      V4L/DVB (5123): Buf_qbuf: fix: videobuf_queue->stream corruption and lockup

Oliver Neukum (1):
      USB: make usbhid ignore Imation Disc Stakka

Olof Johansson (1):
      sata_mv HighPoint 2310 support (88SX7042)

Patrick McHardy (2):
      [NETFILTER]: ctnetlink: fix leak in ctnetlink_create_conntrack error path
      [NETFILTER]: Fix iptables ABI breakage on (at least) CRIS

Paul Mackerras (1):
      [POWERPC] Update defconfigs

Pete Zaitcev (1):
      USB: unusual_devs.h for 0x046b:ff40

Petr Stetiar (1):
      USB: Fix for typo in ohci-ep93xx.c

Philip Langdale (1):
      mmc: Correct definition of R6

Qi Yong (1):
      [JFFS2] Fix jffs2_follow_link() typo

Ralf Baechle (8):
      [MTD] Nuke IVR leftovers
      [MIPS] SMTC: Fix cp0 hazard.
      [MIPS] Delete duplicate call to load_irq_save.
      [MIPS] SMTC: Instant IPI replay.
      [MIPS] Fix APM build
      [MIPS] SMTC: Fix TLB sizing bug for TLB of 64 >= entries
      [MIPS] SMTC: Fix module build by exporting symbol
      [MIPS] VPE loader: Initialize lists before they're actually being used ...

Randy Dunlap (4):
      [MTD] Fix printk format warning in physmap. (resources again)
      [MTD] ESB2ROM uses PCI
      [SCSI] advansys: wrap PCI table inside ifdef CONFIG_PCI
      PCI: fix pci-driver kernel-doc

Ricard Wanderlöf (2):
      [MTD] mtdchar: Fix MEMGETOOBSEL and ECCGETLAYOUT ioctls
      [MTD] NAND: Fix nand_default_mark_blockbad() when flash-based BBT disabled

Richard Purdie (1):
      [MTD] Allow variable block sizes in mtd_blkdevs

Robert Hancock (2):
      V4L/DVB (5021): Cx88xx: Fix lockup on suspend
      sata_nv: don't rely on NV_INT_DEV indication with ADMA

Robert Jennings (1):
      [POWERPC] atomic_dec_if_positive sign extension fix

Robert P. J. Day (1):
      libata doc: "error : unterminated entity reference exceptions"

Rod Whitby (1):
      [MTD] Support combined RedBoot FIS directory and configuration area

Rudolf Marek (1):
      hwmon/w83793: Fix the fan input detection

Russell King (1):
      HID: fix some ARM builds due to HID brokenness - make USB_HID depend on INPUT

Ryan Jackson (2):
      [MTD] MAPS: Add parameter to amd76xrom to override rom window size
      [MTD] CHIPS: Support for SST 49LF040B flash chip

Salyzyn, Mark (1):
      [SCSI] aacraid: Product List Update

Samuel Ortiz (2):
      [IrDA]: irda-usb TX path optimization (was Re: IrDA spams logfiles - since 2.6.19)
      [IrDA]: Removed incorrect IRDA_ASSERT()

Simon Budig (2):
      HID: proper LED-mapping for SpaceNavigator
      HID: add missing RX, RZ and RY enum values to hid-debug output

Stefan Roese (1):
      [MTD] [NAND] Fix endianess bug in ndfc.c

Stephen Hemminger (1):
      email change for shemminger@osdl.org

Steve French (4):
      [CIFS] Update CIFS version number
      [CIFS] Remove 2 unneeded kzalloc casts
      [CIFS]  cifs sprintf fix
      [CIFS] Fix oops when Windows server sent bad domain name null terminator

Sumant Patro (1):
      [SCSI] megaraid_sas: Update module author

Tejun Heo (5):
      [SCSI] sr: fix error code check in sr_block_ioctl()
      libata: initialize qc->dma_dir to DMA_NONE
      libata: fix handling of port actions in per-dev action mask
      ahci: make ULi M5288 ignore interface fatal error bit
      ahci: don't enter slumber on power down

Thiemo Seufer (1):
      [MIPS] Fix reported amount of freed memory - it's in kB not bytes

Thierry MERLE (1):
      V4L/DVB (5019): Fix the frame->grabstate update in read() entry point.

Thomas Gleixner (1):
      [MTD] NAND: add subpage write support

Thomas Klein (7):
      ehea: Fixed wrong dereferencation
      ehea: Fixing firmware queue config issue
      ehea: Modified initial autoneg state determination
      ehea: New method to determine number of available ports
      ehea: Improved logging of permission issues
      ehea: Added logging off associated errors
      ehea: Fixed possible nullpointer access

Timo Lindhorst (2):
      [MTD] [NAND] fix ifdef option in nand_ecc.c
      [MTD] NAND: use SmartMedia ECC byte order for ndfc

Timur Tabi (2):
      Update ucc_geth.c for new workqueue structure
      Fix phy_read/write redefinition errors in ucc_geth_phy.c

Trond Myklebust (2):
      NFS: Fix Oops in rpc_call_sync()
      NFS: Fix races in nfs_revalidate_mapping()

Venkat Yekkirala (1):
      [SELINUX]: increment flow cache genid

Venkatesh Pallipadi (1):
      Revert nmi_known_cpu() check during boot option parsing

Vijay Kumar (3):
      [MTD] NAND: nandsim page-wise allocation (1/2)
      [MTD] NAND: nandsim page-wise allocation (2/2)
      [MTD] NAND: nandsim coding style fix

Vitaly Wool (2):
      [MTD] [NAND] remove len/ooblen confusion.
      [MTD] of_device-based physmap driver

Vlad Yasevich (4):
      [SCTP]: Set correct error cause value for missing parameters
      [SCTP]: Verify some mandatory parameters.
      [SCTP]: Correctly handle unexpected INIT-ACK chunk.
      [SCTP]: Fix SACK sequence during shutdown

Vladimir Saveliev (1):
      resierfs: avoid tail packing if an inode was ever mmapped

YOSHIFUJI Hideaki (1):
      [IPV6] MCAST: Fix joining all-node multicast group on device initialization.

Yan Burman (1):
      [JFFS2] replace kmalloc+memset with kzalloc

Yoichi Yuasa (4):
      [MTD] MAPS: Remove ITE 8172G and Globespan IVR MTD support
      [MTD] fix map probe name for cstm_mips_ixx
      [MIPS] Vr41xx: Fix after GENERIC_HARDIRQS_NO__DO_IRQ change
      [MIPS] vr41xx: need one more nop with mtc0_tlbw_hazard()

Yoshinori Sato (1):
      [MTD] redboot partition combined fis / config problem

adam radford (1):
      [SCSI] 3ware 8000 serialize reset code

garrett_damore@tadpole.com (1):
      USB: add vendor/device id for Option GT Max 3.6 cards

hermann pitton (1):
      V4L/DVB (5033): MSI TV@nywhere Plus fixes

---1463790079-1993476379-1169693891=:25027--
