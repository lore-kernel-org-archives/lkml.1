Return-Path: <linux-kernel-owner+w=401wt.eu-S939398AbXHINkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939398AbXHINkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938351AbXHINkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:40:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64873 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672AbXHINkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:40:06 -0400
Message-ID: <46BB190E.2030102@oracle.com>
Date: Thu, 09 Aug 2007 09:39:26 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DMA CRC errors with SiS chipset and notebook drive
Content-Type: multipart/mixed;
 boundary="------------000501060502000304020403"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000501060502000304020403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

For various reasons I want a silent PC, so I'm using a notebook hard
drive in my desktop system.  I've recycled an ancient Foxconn Socket 754
mainboard in it with this IDE controller:

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev
01) (prog-if 80 [Master])
         Subsystem: Foxconn International, Inc. Unknown device 0c92
         Flags: bus master, medium devsel, latency 128
         I/O ports at 01f0 [size=8]
         I/O ports at 03f4 [size=1]
         I/O ports at 0170 [size=8]
         I/O ports at 0374 [size=1]
         I/O ports at 4000 [size=16]

On boot, the kernel reports:

SCSI subsystem initialized
libata version 2.21 loaded.
pata_sis 0000:00:02.5: version 0.5.1
scsi0 : pata_sis
scsi1 : pata_sis
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 
bmdma 0x00
00000000014000 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 
bmdma 0x00
00000000014008 irq 15
ata1.00: ATA-6: ST94813A, 3.04, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA48
ata1.01: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB00, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST94813A         3.04 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO
  or FUA
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO
  or FUA
  sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB00 PQ: 0 ANSI: 5

Then later in the log, I see:

Aug  9 07:41:29 monet kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x2
Aug  9 07:41:29 monet kernel: ata1.00: (BMDMA stat 0x64)
Aug  9 07:41:29 monet kernel: ata1.00: cmd
c8/00:10:73:15:00/00:00:00:00:00/e1 tag 0 cdb 0x12 data 8192 in
Aug  9 07:41:29 monet kernel:          res
51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
Aug  9 07:41:29 monet kernel: ata1: soft resetting port
Aug  9 07:41:29 monet kernel: ata1.00: configured for UDMA/100
Aug  9 07:41:29 monet kernel: ata1.01: configured for UDMA/33
Aug  9 07:41:29 monet kernel: ata1: EH complete

And eventually:

Aug  9 07:41:29 monet kernel: ata1.00: limiting speed to UDMA/66:PIO4
Aug  9 07:41:29 monet kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x2
Aug  9 07:41:29 monet kernel: ata1.00: (BMDMA stat 0x64)
Aug  9 07:41:29 monet kernel: ata1.00: cmd
c8/00:08:fb:7c:a1/00:00:00:00:00/e0 tag 0 cdb 0x12 data 4096 in
Aug  9 07:41:29 monet kernel:          res
51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
Aug  9 07:41:29 monet kernel: ata1: soft resetting port
Aug  9 07:41:29 monet kernel: ata1.00: configured for UDMA/66
Aug  9 07:41:29 monet kernel: ata1.01: configured for UDMA/33
Aug  9 07:41:29 monet kernel: ata1: EH complete

After that, no more DMA error messages (until the next system reboot).

I've tried this with a brand-new Seagate Momentus 5400.2 and a fairly 
new Western Digital WD800VE.  According to the disk specifications 
available on the vendor web sites, both drives are capable of UDMA/100 
speeds.

This error occurs whether the drive is on the primary IDE controller by
itself, or whether it's sharing the controller with an optical drive
(ata1.01 in the above listing).  I've changed the disk to the secondary
controller, I've swapped IDE cables, and changed out the 44-40
pin notebook drive adapter; no change.

The system is running 2.6.22.1-41.fc7 (x86-64, of course), but I've seen 
this on 2.6.21-based kernels as well.  I've noticed similar errors with 
a Dell Latitude D600 (x86, not SiS), also running recent Fedora 7 kernels.

Searching the web seems to indicate that either the drive or the
controller is bad, but since the error appears in so many different
hardware configurations, I'm beginning to think this is a problem with
libata, as that is an obvious common element.

This e-mail is mostly an experience report, but I'm also wondering if I
should be concerned about data on the drive, or have I missed the real
problem entirely?

Addendum: The internal SMART error log on the Seagate shows these errors 
repeatedly:

Error 103 occurred at disk power-on lifetime: 296 hours (12 days + 8 hours)
   When the command that caused the error occurred, the device was
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 00 00 00 e0  Error: ICRC, ABRT at LBA = 0x00000000 = 0

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 fb 7c a1 e0 00      00:08:31.088  READ DMA
   c8 00 08 ab 7c a1 e0 00      00:08:31.080  READ DMA
   c8 00 08 f3 7c a1 e0 00      00:08:31.079  READ DMA
   c8 00 08 eb 7c a1 e0 00      00:08:31.077  READ DMA
   c8 00 08 5b f6 fc e0 00      00:08:31.077  READ DMA

Error 102 occurred at disk power-on lifetime: 296 hours (12 days + 8 hours)
   When the command that caused the error occurred, the device was
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 00 00 00 e0  Error: ICRC, ABRT at LBA = 0x00000000 = 0

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 10 73 15 00 e1 00      00:08:28.555  READ DMA
   27 00 00 00 00 00 e0 00      00:08:28.241  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 a0 02      00:08:27.695  IDENTIFY DEVICE
   ef 03 45 00 00 00 a0 02      00:08:27.536  SET FEATURES [Set transfer
mode]
   27 00 00 00 00 00 e0 00      00:08:27.532  READ NATIVE MAX ADDRESS EXT

--------------000501060502000304020403
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------000501060502000304020403--
