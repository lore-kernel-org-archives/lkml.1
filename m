Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZBNUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZBNUS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZBNUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:18:48 -0500
Received: from hermes.cicese.mx ([158.97.1.34]:40898 "EHLO hermes.cicese.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZBNUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:18:47 -0500
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 15:18:47 EST
From: Serguei Miridonov <mirsev@cicese.mx>
To: linux-kernel@vger.kernel.org
Subject: Intel ICH9M/M-E SATA error-handling/reset problems
Date: Sat, 14 Feb 2009 12:06:05 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27.12-170.2.5.fc10.i686; KDE/4.2.0; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uQylJjptwfnlsoG"
Message-Id: <200902141206.06419.mirsev@cicese.mx>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (hermes.cicese.mx [158.97.1.34]); Sat, 14 Feb 2009 12:06:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uQylJjptwfnlsoG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have some problems with SATA in a new notebook PC (HP Pavilion dv5t, 
Intel chipset). Seagate FreeAgent Pro 1TB external drive practically 
can not be used with eSATA in Linux (fresh install from DVD Fedora 10, 
now fully updated), and yesterday I also had problem with DVD 
recording using internal HL-DT-ST BDDVDRW drive.

More details in attachment.

Both devices work with Windows Vista. Seagate external drive even in 
Vista produces "parity error" messages in Windows event log but OS is 
somehow recovering from these errors and continues to use the drive 
with slight slowdown (average speed varies between 60 and 110 MB/s). 
Of course, it could be cable/Seagate issue, but again - Vista can 
handle this.

It appears that Linux kernel has problems with error-handling/reset of 
SATA hardware. I have found a lot of reports regarding SATA problems: 
data transfer failures, CD/DVD recording, waking up from suspend to 
RAM, etc. Aren't they all related? Can Linux SATA chipsets drivers 
properly reset hardware into predictable state? Sure, I could be wrong 
and my issue may have nothing to do with others... Any idea?

Please, CC any reply to my e-mail.
Thank you.


--Boundary-00=_uQylJjptwfnlsoG
Content-Type: text/plain;
  charset="UTF-8";
  name="sata-errors-report.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sata-errors-report.txt"

1. Problem with Seagate FreeAgent Pro 1TB drive connected with eSATA cable

  SUMMARY

  The drive can be recognized by the system.
  I could copy large file FROM the external drive to the internal disk.
  When I tried to copy the same file TO the drive the drive stopped responding.

2. Problem with DVD+R recording

  SUMMARY

  Happened only once, so far...
  k3b recognized the drive and empty media inside.
  Attempt to record DVD+R using k3b failed, Bluray/DVD/CD drive stopped responding.
  Reboot was required in order to use it again.
  Attempt to record DVD+R after reboot was successful.

Hardware: HP Pavilion dv5t Intel(R) Core(TM)2 Duo CPU P8600  @ 2.40GHz, 3GB RAM
# lspci
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem (rev 03)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 9200M GS (rev a1)
02:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
06:00.0 FireWire (IEEE 1394): JMicron Technologies, Inc. IEEE 1394 Host Controller
06:00.1 System peripheral: JMicron Technologies, Inc. SD/MMC Host Controller
06:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller
06:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
06:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller

/var/log/messages:

=========== Seagate FreeAgent Pro 1TB drive connected: ===============

Feb  8 18:37:23 localhost kernel: ata6: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
Feb  8 18:37:23 localhost kernel: ata6: irq_stat 0x00000040, connection status changed
Feb  8 18:37:23 localhost kernel: ata6: SError: { CommWake DevExch }
Feb  8 18:37:23 localhost kernel: ata6: hard resetting link
Feb  8 18:37:30 localhost kernel: ata6: link is slow to respond, please be patient (ready=0)
Feb  8 18:37:33 localhost kernel: ata6: softreset failed (device not ready)
Feb  8 18:37:33 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:37:33 localhost kernel: ata6: link online but device misclassified, retrying
Feb  8 18:37:33 localhost kernel: ata6: hard resetting link
Feb  8 18:37:37 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:37:37 localhost kernel: ata6.00: ATA-6: Seagate FreeAgent Pro, 4109, max UDMA/133
Feb  8 18:37:37 localhost kernel: ata6.00: 1953525168 sectors, multi 0: LBA48
Feb  8 18:37:37 localhost kernel: ata6.00: configured for UDMA/133
Feb  8 18:37:37 localhost kernel: ata6: EH complete
Feb  8 18:37:37 localhost kernel: scsi 5:0:0:0: Direct-Access     ATA      Seagate FreeAgen 4109 PQ: 0 ANSI: 5
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] Write Protect is off
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] Write Protect is off
Feb  8 18:37:37 localhost kernel: sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  8 18:37:38 localhost kernel: sdb: sdb1
Feb  8 18:37:38 localhost kernel: sd 5:0:0:0: [sdb] Attached SCSI disk
Feb  8 18:37:38 localhost kernel: sd 5:0:0:0: Attached scsi generic sg2 type 0
Feb  8 18:37:53 localhost hald: mounted /dev/sdb1 on behalf of uid 0

=========== Attempt to copy large file TO the external drive ================

Feb  8 18:40:41 localhost kernel: ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
Feb  8 18:40:41 localhost kernel: ata6.00: irq_stat 0x40000001
Feb  8 18:40:41 localhost kernel: ata6.00: cmd 35/00:00:b9:21:cb/00:04:21:00:00/e0 tag 0 dma 524288 out
Feb  8 18:40:41 localhost kernel:         res 51/84:00:b8:25:cb/00:00:21:00:00/e0 Emask 0x10 (ATA bus error)
Feb  8 18:40:41 localhost kernel: ata6.00: status: { DRDY ERR }
Feb  8 18:40:41 localhost kernel: ata6.00: error: { ICRC ABRT }
Feb  8 18:40:41 localhost kernel: ata6: hard resetting link
Feb  8 18:40:46 localhost kernel: ata6: link is slow to respond, please be patient (ready=0)
Feb  8 18:40:51 localhost kernel: ata6: softreset failed (device not ready)
Feb  8 18:40:51 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:40:56 localhost kernel: ata6.00: qc timeout (cmd 0xec)
Feb  8 18:40:56 localhost kernel: ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb  8 18:40:56 localhost kernel: ata6.00: revalidation failed (errno=-5)
Feb  8 18:40:56 localhost kernel: ata6: hard resetting link
Feb  8 18:41:02 localhost kernel: ata6: link is slow to respond, please be patient (ready=0)
Feb  8 18:41:06 localhost kernel: ata6: softreset failed (device not ready)
Feb  8 18:41:06 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:41:16 localhost kernel: ata6.00: qc timeout (cmd 0xec)
Feb  8 18:41:16 localhost kernel: ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb  8 18:41:16 localhost kernel: ata6.00: revalidation failed (errno=-5)
Feb  8 18:41:16 localhost kernel: ata6: hard resetting link
Feb  8 18:41:22 localhost kernel: ata6: link is slow to respond, please be patient (ready=0)
Feb  8 18:41:26 localhost kernel: ata6: softreset failed (device not ready)
Feb  8 18:41:26 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:41:56 localhost kernel: ata6.00: qc timeout (cmd 0xec)
Feb  8 18:41:56 localhost kernel: ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb  8 18:41:56 localhost kernel: ata6.00: revalidation failed (errno=-5)
Feb  8 18:41:56 localhost kernel: ata6.00: disabled
Feb  8 18:41:56 localhost kernel: ata6: hard resetting link
Feb  8 18:42:02 localhost kernel: ata6: link is slow to respond, please be patient (ready=0)
Feb  8 18:42:06 localhost kernel: ata6: softreset failed (device not ready)
Feb  8 18:42:06 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  8 18:42:06 localhost kernel: ata6: EH complete
Feb  8 18:42:06 localhost kernel: sd 5:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Feb  8 18:42:06 localhost kernel: end_request: I/O error, dev sdb, sector 566960569
...
Last pair of lines repeated many times for different sectors. Then

Feb  8 18:42:06 localhost kernel: sd 5:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Feb  8 18:42:06 localhost kernel: end_request: I/O error, dev sdb, sector 64
Feb  8 18:42:06 localhost kernel: Buffer I/O error on device sdb1, logical block 1
Feb  8 18:42:06 localhost kernel: lost page write due to I/O error on sdb1
...

After that drive becomes unaccessable and can be accessed again only after power off/on.

================= Detecting Bluray/DVD/CD drive on boot =======================

Feb 13 16:56:20 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb 13 16:56:20 localhost kernel: ata2.00: ATAPI: HL-DT-ST BDDVDRW CT10L, YC07, max UDMA/100
Feb 13 16:56:20 localhost kernel: ata2.00: configured for UDMA/100
...
Feb 13 16:56:20 localhost kernel: scsi 1:0:0:0: CD-ROM            HL-DT-ST BDDVDRW CT10L    YC07 PQ: 0 ANSI: 5
Feb 13 16:56:20 localhost kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 13 16:56:20 localhost kernel: Uniform CD-ROM driver Revision: 3.20
Feb 13 16:56:20 localhost kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5

================= Insert empty DVD+R (Sony) ===================================

Feb 13 19:43:11 localhost kernel: cdrom: This disc doesn't have any tracks I recognize!
Feb 13 19:43:11 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:43:11 localhost kernel: Buffer I/O error on device sr0, logical block 0
Feb 13 19:43:11 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:43:11 localhost kernel: Buffer I/O error on device sr0, logical block 0

================= Attempt to write DVD =========================================

Feb 13 19:48:33 localhost kernel: warning: `growisofs' uses 32-bit capabilities (legacy support in use)
Feb 13 19:49:35 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Feb 13 19:49:35 localhost kernel: ata2.00: cmd a0/01:00:00:00:80/00:00:00:00:00/a0 tag 0 dma 32768 out
Feb 13 19:49:35 localhost kernel:         cdb 2a 00 00 00 00 00 00 00  10 00 00 00 00 00 00 00
Feb 13 19:49:35 localhost kernel:         res 40/00:03:00:0c:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Feb 13 19:49:35 localhost kernel: ata2.00: status: { DRDY }
Feb 13 19:49:35 localhost kernel: ata2: hard resetting link
Feb 13 19:49:35 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb 13 19:49:35 localhost kernel: ata2.00: configured for UDMA/100
Feb 13 19:49:35 localhost kernel: ata2: EH complete

================= k3b reports error and ejects the disc, I load the same disc back ============

Feb 13 19:50:02 localhost kernel: cdrom: This disc doesn't have any tracks I recognize!
Feb 13 19:50:02 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:50:02 localhost kernel: Buffer I/O error on device sr0, logical block 0
Feb 13 19:50:02 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:50:02 localhost kernel: Buffer I/O error on device sr0, logical block 0
Feb 13 19:51:30 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Feb 13 19:51:30 localhost kernel: ata2.00: cmd a0/01:00:00:00:80/00:00:00:00:00/a0 tag 0 dma 32768 out
Feb 13 19:51:30 localhost kernel:         cdb 2a 00 00 00 00 00 00 00  10 00 00 00 00 00 00 00
Feb 13 19:51:30 localhost kernel:         res 40/00:03:00:0c:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Feb 13 19:51:30 localhost kernel: ata2.00: status: { DRDY }
Feb 13 19:51:30 localhost kernel: ata2: hard resetting link
Feb 13 19:51:31 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb 13 19:51:31 localhost kernel: ata2.00: configured for UDMA/100
Feb 13 19:51:31 localhost kernel: ata2: EH complete

================= k3b reports error and ejects the disc, I load the same disc back again =====

Feb 13 19:51:54 localhost kernel: cdrom: This disc doesn't have any tracks I recognize!
Feb 13 19:52:58 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Feb 13 19:52:58 localhost kernel: ata2.00: cmd a0/01:00:00:00:80/00:00:00:00:00/a0 tag 0 dma 32768 out
Feb 13 19:52:58 localhost kernel:         cdb 2a 00 00 00 00 00 00 00  10 00 00 00 00 00 00 00
Feb 13 19:52:58 localhost kernel:         res 40/00:03:00:0c:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Feb 13 19:52:58 localhost kernel: ata2.00: status: { DRDY }
Feb 13 19:52:58 localhost kernel: ata2: hard resetting link
Feb 13 19:52:58 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb 13 19:52:58 localhost kernel: ata2.00: configured for UDMA/100
Feb 13 19:52:58 localhost kernel: ata2: EH complete
Feb 13 19:54:01 localhost kernel: cdrom: This disc doesn't have any tracks I recognize!
Feb 13 19:54:01 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:54:01 localhost kernel: Buffer I/O error on device sr0, logical block 0
Feb 13 19:54:01 localhost kernel: end_request: I/O error, dev sr0, sector 0
Feb 13 19:54:01 localhost kernel: Buffer I/O error on device sr0, logical block 0
Feb 13 19:55:20 localhost kernel: ata2: limiting SATA link speed to 1.5 Gbps
Feb 13 19:55:20 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Feb 13 19:55:20 localhost kernel: ata2.00: cmd a0/01:00:00:00:80/00:00:00:00:00/a0 tag 0 dma 32768 out
Feb 13 19:55:20 localhost kernel:         cdb 2a 00 00 00 00 00 00 00  10 00 00 00 00 00 00 00
Feb 13 19:55:20 localhost kernel:         res 40/00:03:00:0c:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Feb 13 19:55:20 localhost kernel: ata2.00: status: { DRDY }
Feb 13 19:55:20 localhost kernel: ata2: hard resetting link
Feb 13 19:55:26 localhost kernel: ata2: link is slow to respond, please be patient (ready=0)
Feb 13 19:55:30 localhost kernel: ata2: softreset failed (device not ready)
Feb 13 19:55:30 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Feb 13 19:55:35 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
Feb 13 19:55:35 localhost kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb 13 19:55:35 localhost kernel: ata2.00: revalidation failed (errno=-5)
Feb 13 19:55:35 localhost kernel: ata2: hard resetting link
Feb 13 19:55:41 localhost kernel: ata2: link is slow to respond, please be patient (ready=0)
Feb 13 19:55:45 localhost kernel: ata2: softreset failed (device not ready)
Feb 13 19:55:45 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Feb 13 19:55:55 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
Feb 13 19:55:55 localhost kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb 13 19:55:55 localhost kernel: ata2.00: revalidation failed (errno=-5)
Feb 13 19:55:55 localhost kernel: ata2: hard resetting link
Feb 13 19:56:01 localhost kernel: ata2: link is slow to respond, please be patient (ready=0)
Feb 13 19:56:05 localhost kernel: ata2: softreset failed (device not ready)
Feb 13 19:56:05 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Feb 13 19:56:35 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
Feb 13 19:56:35 localhost kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Feb 13 19:56:35 localhost kernel: ata2.00: revalidation failed (errno=-5)
Feb 13 19:56:35 localhost kernel: ata2.00: disabled
Feb 13 19:56:35 localhost kernel: ata2: hard resetting link
Feb 13 19:56:41 localhost kernel: ata2: link is slow to respond, please be patient (ready=0)
Feb 13 19:56:45 localhost kernel: ata2: softreset failed (device not ready)
Feb 13 19:56:45 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Feb 13 19:56:45 localhost kernel: ata2: EH complete

============== The drive does not respond, I can not eject disc ==========================

After reboot everything worked OK...

============== Additional info: ==========================================================

lspci -vv (related to SATA controller):

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Hewlett-Packard Company Device 3603
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at a108 [size=8]
        Region 1: I/O ports at a114 [size=4]
        Region 2: I/O ports at a100 [size=8]
        Region 3: I/O ports at a110 [size=4]
        Region 4: I/O ports at a020 [size=32]
        Region 5: Memory at df305000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/16 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA <?>
        Capabilities: [b0] PCIe advanced features <?>
        Kernel driver in use: ahci

# dmesg | egrep '^ata.:|^ahci'
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ems
ahci 0000:00:1f.2: setting latency timer to 64
ata1: SATA max UDMA/133 abar m2048@0xdf305000 port 0xdf305100 irq 19
ata2: SATA max UDMA/133 abar m2048@0xdf305000 port 0xdf305180 irq 19
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xdf305000 port 0xdf305300 irq 19
ata6: SATA max UDMA/133 abar m2048@0xdf305000 port 0xdf305380 irq 19
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)


# uname -a
Linux localhost 2.6.27.12-170.2.5.fc10.i686 #1 SMP Wed Jan 21 02:09:37 EST 2009 i686 i686 i386 GNU/Linux

--Boundary-00=_uQylJjptwfnlsoG--
