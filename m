Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXJXUpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXJXUpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXJXUox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:44:53 -0400
Received: from beast.tiendalinux.com ([65.99.217.191]:35134 "EHLO
	beast.tiendalinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbXJXUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:44:52 -0400
X-Greylist: delayed 1641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 16:44:51 EDT
X-SMTP-Auth: no
Message-ID: <471FA857.8060702@tiendalinux.com>
Date: Wed, 24 Oct 2007 15:17:27 -0500
From: "Nestor A. Diaz" <nestor@tiendalinux.com>
Organization: TiendaLinux.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RAID 10 w AHCI w NCQ = Spurius  I/O error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello People,

I need your help, this problem is turning me crazy.

I have created a RAID 10 using  a RAID0 configuration on top of a two 
RAID1 devices (all software raid), like this:

Personalities : [raid0] [raid1]
md4 : active raid0 md2[0] md3[1]
      605071872 blocks 64k chunks

md0 : active raid1 sdd3[3] sda3[0] sdc3[2] sdb3[1]
      9791552 blocks [4/4] [UUUU]

md3 : active raid1 sdd2[2](F) sdb2[0]
      302536000 blocks [2/1] [U_]

md1 : active raid1 sdd1[3] sda1[0] sdc1[2] sdb1[1]
      240832 blocks [4/4] [UUUU]

md2 : active raid1 sda2[0] sdc2[1]
      302536000 blocks [2/2] [UU]

unused devices: <none>

But the sdd device sometimes fail, i have changed the hard disk, check 
the older sata drive, reformat using mke2fs -c -c (to check for media 
errrors both read and write, no media problems found, change the sata 
disk and the problem remains, also with a new sata hard disk).

The systema is a supermicro server 5015-mt+ with an ich7 ahci controller

All SATA hard disk are hitachi, here is a copy of the kernel log:

Oct 19 14:01:08 rogue kernel: scsi0 : ahci
Oct 19 14:01:08 rogue kernel: scsi1 : ahci
Oct 19 14:01:08 rogue kernel: scsi2 : ahci
Oct 19 14:01:08 rogue kernel: scsi3 : ahci
Oct 19 14:01:08 rogue kernel: ata1: SATA max UDMA/133 cmd 
0xffffc20001434500 ctl 0x0000000000000000 bmdma 0x00000000
00000000 irq 1275
Oct 19 14:01:08 rogue kernel: ata2: SATA max UDMA/133 cmd 
0xffffc20001434580 ctl 0x0000000000000000 bmdma 0x00000000
00000000 irq 1275
Oct 19 14:01:08 rogue kernel: ata3: SATA max UDMA/133 cmd 
0xffffc20001434600 ctl 0x0000000000000000 bmdma 0x00000000
00000000 irq 1275
Oct 19 14:01:08 rogue kernel: ata4: SATA max UDMA/133 cmd 
0xffffc20001434680 ctl 0x0000000000000000 bmdma 0x00000000
00000000 irq 1275
Oct 19 14:01:08 rogue kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 19 14:01:08 rogue kernel: ata1.00: ATA-7: Hitachi HDT725032VLA360, 
V54OA73A, max UDMA/133
Oct 19 14:01:08 rogue kernel: ata1.00: 625142448 sectors, multi 16: 
LBA48 NCQ (depth 31/32)
Oct 19 14:01:08 rogue kernel: ata1.00: configured for UDMA/133
Oct 19 14:01:08 rogue kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 19 14:01:08 rogue kernel: ata2.00: ATA-7: Hitachi HDT725032VLA360, 
V54OA73A, max UDMA/133
Oct 19 14:01:08 rogue kernel: ata2.00: 625142448 sectors, multi 16: 
LBA48 NCQ (depth 31/32)
Oct 19 14:01:08 rogue kernel: ata2.00: configured for UDMA/133
Oct 19 14:01:08 rogue kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 19 14:01:08 rogue kernel: ata3.00: ATA-7: Hitachi HDT725032VLA360, 
V54OA73A, max UDMA/133
Oct 19 14:01:08 rogue kernel: ata3.00: 625142448 sectors, multi 16: 
LBA48 NCQ (depth 31/32)
Oct 19 14:01:08 rogue kernel: ata3.00: configured for UDMA/133
Oct 19 14:01:08 rogue kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 19 14:01:08 rogue kernel: ata4.00: ATA-7: Hitachi HDT725032VLA360, 
V54OA73A, max UDMA/133
Oct 19 14:01:08 rogue kernel: ata4.00: 625142448 sectors, multi 16: 
LBA48 NCQ (depth 31/32)
Oct 19 14:01:08 rogue kernel: ata4.00: configured for UDMA/133
Oct 19 14:01:08 rogue kernel: scsi 0:0:0:0: Direct-Access     ATA      
Hitachi HDT72503 V54O PQ: 0 ANSI: 5
Oct 19 14:01:08 rogue kernel: scsi 1:0:0:0: Direct-Access     ATA      
Hitachi HDT72503 V54O PQ: 0 ANSI: 5
Oct 19 14:01:08 rogue kernel: scsi 2:0:0:0: Direct-Access     ATA      
Hitachi HDT72503 V54O PQ: 0 ANSI: 5
Oct 19 14:01:08 rogue kernel: scsi 3:0:0:0: Direct-Access     ATA      
Hitachi HDT72503 V54O PQ: 0 ANSI: 5
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: hda: ATAPI<5>sd 0:0:0:0: [sda] Write 
cache: enabled, read cache: enabled, doesn't supp
ort DPO or FUA
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 0:0:0:0: [sda] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sda: sda1 sda2 sda3
Oct 19 14:01:08 rogue kernel: 24X<5>sd 0:0:0:0: [sda] Attached SCSI disk
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 1:0:0:0: [sdb] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sdb: sdb1 sdb2 sdb3
Oct 19 14:01:08 rogue kernel: CD-ROM<5>sd 1:0:0:0: [sdb] Attached SCSI disk
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 2:0:0:0: [sdc] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sdc: sdc1 sdc2 sdc3
Oct 19 14:01:08 rogue kernel: drive<5>sd 2:0:0:0: [sdc] Attached SCSI disk
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Write Protect is off
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Oct 19 14:01:08 rogue kernel: sd 3:0:0:0: [sdd] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 14:01:08 rogue kernel: Uniform CD-ROM driver Revision: 3.20
Oct 19 14:01:08 rogue kernel: Probing IDE interface ide1...
Oct 19 14:01:08 rogue kernel: md: raid0 personality registered for level 0
Oct 19 14:01:08 rogue kernel: md: raid1 personality registered for level 1
Oct 19 14:01:08 rogue kernel: md: md2 stopped.
Oct 19 14:01:08 rogue kernel: md: bind<sdc2>
Oct 19 14:01:08 rogue kernel: md: bind<sda2>
Oct 19 14:01:08 rogue kernel: raid1: raid set md2 active with 2 out of 2 
mirrors
Oct 19 14:01:08 rogue kernel: md: md1 stopped.
Oct 19 14:01:08 rogue kernel: md: bind<sdb1>
Oct 19 14:01:08 rogue kernel: md: bind<sdc1>
Oct 19 14:01:08 rogue kernel: md: bind<sda1>
Oct 19 14:01:08 rogue kernel: raid1: raid set md1 active with 3 out of 4 
mirrors
Oct 19 14:01:08 rogue kernel: md: md3 stopped.
Oct 19 14:01:08 rogue kernel: md: bind<sdb2>
Oct 19 14:01:08 rogue kernel: raid1: raid set md3 active with 1 out of 2 
mirrors
Oct 19 14:01:08 rogue kernel: md: md0 stopped.
Oct 19 14:01:08 rogue kernel: md: bind<sdb3>
Oct 19 14:01:08 rogue kernel: md: bind<sdc3>
Oct 19 14:01:08 rogue kernel: md: bind<sda3>
Oct 19 14:01:08 rogue kernel: raid1: raid set md0 active with 3 out of 4 
mirrors
Oct 19 14:01:08 rogue kernel: md: md4 stopped.
Oct 19 14:01:08 rogue kernel: md: bind<md3>
Oct 19 14:01:08 rogue kernel: md: bind<md2>
Oct 19 14:01:08 rogue kernel: md4: setting max_sectors to 128, segment 
boundary to 32767
Oct 19 14:01:08 rogue kernel: raid0: looking at md2
Oct 19 14:01:08 rogue kernel: raid0:   comparing md2(302535936) with 
md2(302535936)
Oct 19 14:01:08 rogue kernel: raid0:   END
Oct 19 14:01:08 rogue kernel: raid0:   ==> UNIQUE
Oct 19 14:01:08 rogue kernel: raid0: 1 zones
Oct 19 14:01:08 rogue kernel: raid0: looking at md3
Oct 19 14:01:08 rogue kernel: raid0:   comparing md3(302535936) with 
md2(302535936)
Oct 19 14:01:08 rogue kernel: raid0:   EQUAL
Oct 19 14:01:08 rogue kernel: raid0: FINAL 1 zones
Oct 19 14:01:08 rogue kernel: raid0: done.
Oct 19 14:01:08 rogue kernel: raid0 : md_size is 605071872 blocks.
Oct 19 14:01:08 rogue kernel: raid0 : conf->hash_spacing is 605071872 
blocks.
Oct 19 14:01:08 rogue kernel: raid0 : nb_zone is 1.
Oct 19 14:01:08 rogue kernel: raid0 : Allocating 8 bytes for hash.

I add another drive to the failed raid10 device and i get:

Oct 19 19:25:25 rogue kernel: sd 3:0:0:0: [sdd] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 19:25:25 rogue kernel: sd 3:0:0:0: [sdd] Write Protect is off
Oct 19 19:25:25 rogue kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Oct 19 19:25:25 rogue kernel: sd 3:0:0:0: [sdd] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 19:25:25 rogue kernel: sdd: sdd1
Oct 19 19:25:28 rogue kernel: sd 3:0:0:0: [sdd] 625142448 512-byte 
hardware sectors (320073 MB)
Oct 19 19:25:28 rogue kernel: sd 3:0:0:0: [sdd] Write Protect is off
Oct 19 19:25:28 rogue kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Oct 19 19:25:28 rogue kernel: sd 3:0:0:0: [sdd] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FU
A
Oct 19 19:25:28 rogue kernel: sdd: sdd1 sdd2 sdd3
Oct 19 19:26:13 rogue kernel: md: bind<sdd3>
Oct 19 19:26:13 rogue kernel: RAID1 conf printout:
Oct 19 19:26:13 rogue kernel: --- wd:3 rd:4
Oct 19 19:26:13 rogue kernel: disk 0, wo:0, o:1, dev:sda3
Oct 19 19:26:13 rogue kernel: disk 1, wo:0, o:1, dev:sdb3
Oct 19 19:26:13 rogue kernel: disk 2, wo:0, o:1, dev:sdc3
Oct 19 19:26:13 rogue kernel: disk 3, wo:1, o:1, dev:sdd3
Oct 19 19:26:13 rogue kernel: md: recovery of RAID array md0
Oct 19 19:26:13 rogue kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Oct 19 19:26:13 rogue kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for re
covery.
Oct 19 19:26:13 rogue kernel: md: using 128k window, over a total of 
9791552 blocks.
Oct 19 19:26:34 rogue kernel: md: bind<sdd1>
Oct 19 19:26:34 rogue kernel: RAID1 conf printout:
Oct 19 19:26:34 rogue kernel: --- wd:3 rd:4
Oct 19 19:26:34 rogue kernel: disk 0, wo:0, o:1, dev:sda1
Oct 19 19:26:34 rogue kernel: disk 1, wo:0, o:1, dev:sdb1
Oct 19 19:26:34 rogue kernel: disk 2, wo:0, o:1, dev:sdc1
Oct 19 19:26:34 rogue kernel: disk 3, wo:1, o:1, dev:sdd1
Oct 19 19:26:34 rogue kernel: md: delaying recovery of md1 until md0 has 
finished (they share one or more physical u
nits)
Oct 19 19:27:10 rogue kernel: md: bind<sdd2>
Oct 19 19:27:10 rogue kernel: RAID1 conf printout:
Oct 19 19:27:10 rogue kernel: --- wd:1 rd:2
Oct 19 19:27:10 rogue kernel: disk 0, wo:0, o:1, dev:sdb2
Oct 19 19:27:10 rogue kernel: disk 1, wo:1, o:1, dev:sdd2
Oct 19 19:27:10 rogue kernel: md: delaying recovery of md3 until md0 has 
finished (they share one or more physical u
nits)
Oct 19 19:27:22 rogue kernel: ata4: D2H reg with I during NCQ, this 
message won't be printed again
Oct 19 19:48:40 rogue kernel: md: md0: recovery done.
Oct 19 19:48:40 rogue kernel: md: delaying recovery of md3 until md1 has 
finished (they share one or more physical u
nits)
Oct 19 19:48:40 rogue kernel: md: delaying recovery of md1 until md3 has 
finished (they share one or more physical u
nits)
Oct 19 19:48:40 rogue kernel: md: recovery of RAID array md3
Oct 19 19:48:40 rogue kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Oct 19 19:48:40 rogue kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for re
covery.
Oct 19 19:48:40 rogue kernel: md: using 128k window, over a total of 
302536000 blocks.
Oct 19 19:48:41 rogue kernel: RAID1 conf printout:
Oct 19 19:48:41 rogue kernel: --- wd:4 rd:4
Oct 19 19:48:41 rogue kernel: disk 0, wo:0, o:1, dev:sda3
Oct 19 19:48:41 rogue kernel: disk 1, wo:0, o:1, dev:sdb3
Oct 19 19:48:41 rogue kernel: disk 2, wo:0, o:1, dev:sdc3
Oct 19 19:48:41 rogue kernel: disk 3, wo:0, o:1, dev:sdd3
Oct 20 09:16:10 rogue kernel: md: md3: recovery done.
Oct 20 09:16:10 rogue kernel: md: recovery of RAID array md1
Oct 20 09:16:10 rogue kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Oct 20 09:16:10 rogue kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for re
covery.
Oct 20 09:16:10 rogue kernel: md: using 128k window, over a total of 
240832 blocks.
Oct 20 09:16:11 rogue kernel: RAID1 conf printout:
Oct 20 09:16:11 rogue kernel: --- wd:2 rd:2
Oct 20 09:16:11 rogue kernel: disk 0, wo:0, o:1, dev:sdb2
Oct 20 09:16:11 rogue kernel: disk 1, wo:0, o:1, dev:sdd2
Oct 20 09:16:30 rogue kernel: md: md1: recovery done.
Oct 20 09:16:30 rogue kernel: RAID1 conf printout:
Oct 20 09:16:30 rogue kernel: --- wd:4 rd:4
Oct 20 09:16:30 rogue kernel: disk 0, wo:0, o:1, dev:sda1
Oct 20 09:16:30 rogue kernel: disk 1, wo:0, o:1, dev:sdb1
Oct 20 09:16:30 rogue kernel: disk 2, wo:0, o:1, dev:sdc1
Oct 20 09:16:30 rogue kernel: disk 3, wo:0, o:1, dev:sdd1

The RAID 1 builds perfectly, but five days after that, the system shows a:

end_request: I/O error, dev sdd, sector 144006110
raid1: Disk failure on sdd2, disabling device.
Operation continuing on 1 devices
end_request: I/O error, dev sdd, sector 144006222
end_request: I/O error, dev sdd, sector 144268814
RAID1 conf printout:
--- wd:1 rd:2
disk 0, wo:0, o:1, dev:sdb2
disk 1, wo:1, o:0, dev:sdd2
RAID1 conf printout:
--- wd:1 rd:2
disk 0, wo:0, o:1, dev:sdb2

a week before i get (under 2.6.18) the following message:

Oct 10 12:10:56 rogue kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 
0x0 action 0x2 frozen
Oct 10 12:10:56 rogue kernel: ata4.00: tag 0 cmd 0xea Emask 0x4 stat 
0x40 err 0x0 (timeout)
Oct 10 12:10:56 rogue kernel: ata4: soft resetting port
Oct 10 12:10:57 rogue kernel: ata4: softreset failed (1st FIS failed)
Oct 10 12:10:57 rogue kernel: ata4: softreset failed, retrying in 5 secs
Oct 10 12:11:02 rogue kernel: ata4: hard resetting port
Oct 10 12:11:09 rogue kernel: ata4: port is slow to respond, please be 
patient
Oct 10 12:11:32 rogue kernel: ata4: port failed to respond (30 secs)
Oct 10 12:11:32 rogue kernel: ata4: COMRESET failed (device not ready)
Oct 10 12:11:32 rogue kernel: ata4: hardreset failed, retrying in 5 secs
Oct 10 12:11:37 rogue kernel: ata4: hard resetting port
Oct 10 12:11:37 rogue kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 10 12:11:37 rogue kernel: ata4.00: configured for UDMA/133
Oct 10 12:11:37 rogue kernel: ata4: EH complete
Oct 10 12:11:37 rogue kernel: SCSI device sdd: 625142448 512-byte hdwr 
sectors (320073 MB)
Oct 10 12:11:37 rogue kernel: sdd: Write Protect is off
Oct 10 12:11:37 rogue kernel: sdd: Mode Sense: 00 3a 00 00
Oct 10 12:11:37 rogue kernel: SCSI device sdd: drive cache: write back
Oct 10 12:12:54 rogue kernel: ata4.00: exception Emask 0x0 SAct 0x50 
SErr 0x0 action 0x2 frozen
Oct 10 12:12:54 rogue kernel: ata4.00: tag 4 cmd 0x61 Emask 0x4 stat 
0x40 err 0x0 (timeout)
Oct 10 12:12:54 rogue kernel: ata4.00: tag 6 cmd 0x61 Emask 0x4 stat 
0x40 err 0x0 (timeout)
Oct 10 12:12:55 rogue kernel: ata4: soft resetting port
Oct 10 12:13:02 rogue kernel: ata4: port is slow to respond, please be 
patient
Oct 10 12:13:25 rogue kernel: ata4: port failed to respond (30 secs)
Oct 10 12:13:25 rogue kernel: ata4: softreset failed (device not ready)
Oct 10 12:13:25 rogue kernel: ata4: softreset failed, retrying in 5 secs
Oct 10 12:13:30 rogue kernel: ata4: hard resetting port
Oct 10 12:13:37 rogue kernel: ata4: port is slow to respond, please be 
patient
Oct 10 12:14:00 rogue kernel: ata4: port failed to respond (30 secs)
Oct 10 12:14:00 rogue kernel: ata4: COMRESET failed (device not ready)
Oct 10 12:14:00 rogue kernel: ata4: hardreset failed, retrying in 5 secs
Oct 10 12:14:05 rogue kernel: ata4: hard resetting port
Oct 10 12:14:06 rogue kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 10 12:14:06 rogue kernel: ata4.00: configured for UDMA/133
Oct 10 12:14:06 rogue kernel: sd 3:0:0:0: SCSI error: return code = 
0x06000000
Oct 10 12:14:06 rogue kernel: end_request: I/O error, dev sdd, sector 
1268542
Oct 10 12:14:06 rogue kernel: raid1: Disk failure on sdd2, disabling device.
Oct 10 12:14:06 rogue kernel:   Operation continuing on 1 devices
Oct 10 12:14:06 rogue kernel: sd 3:0:0:0: SCSI error: return code = 
0x06000000
Oct 10 12:14:06 rogue kernel: end_request: I/O error, dev sdd, sector 
1268558
Oct 10 12:14:06 rogue kernel: ata4: EH complete
Oct 10 12:14:06 rogue kernel: SCSI device sdd: 625142448 512-byte hdwr 
sectors (320073 MB)
Oct 10 12:14:06 rogue kernel: sdd: Write Protect is off
Oct 10 12:14:06 rogue kernel: sdd: Mode Sense: 00 3a 00 00
Oct 10 12:14:06 rogue kernel: RAID1 conf printout:
Oct 10 12:14:06 rogue kernel: SCSI device sdd: drive cache: write back
Oct 10 12:14:06 rogue kernel: --- wd:1 rd:2
Oct 10 12:14:06 rogue kernel: disk 0, wo:0, o:1, dev:sdb2
Oct 10 12:14:06 rogue kernel: disk 1, wo:1, o:0, dev:sdd2
Oct 10 12:14:06 rogue kernel: RAID1 conf printout:
Oct 10 12:14:06 rogue kernel: --- wd:1 rd:2
Oct 10 12:14:06 rogue kernel: disk 0, wo:0, o:1, dev:sdb2

I have updated from 2.6.18 to 2.6.22 expecting to not have the problem, 
but the problem remains and i didn't know what could be the problem, the 
problem  always happen on /dev/sdd, i use LVM on top of the RAID 10 
software device.

I am not sure if the problem was because i create the RAID10 using two 
RAID1 devices and then do a RAID0, or should i have to be used mdadm and 
the level 10 option ?

Any suggestions will be welcome.

Thanks for your help.

-- 
Nestor A. Diaz
Ingeniero de Sistemas
Tel. +57 1-600-5490 x 211
Cel. +57 316-227-3593
Tel. SIP: sip:211@tiendalinux.com
Email/MSN: nestor@tiendalinux.com
http://www.tiendalinux.com/
Bogota, Colombia 

