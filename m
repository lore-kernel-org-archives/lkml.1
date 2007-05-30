Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbXE3PzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbXE3PzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXE3PzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:55:14 -0400
Received: from web54504.mail.re2.yahoo.com ([206.190.49.154]:44168 "HELO
	web54504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751424AbXE3PzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:55:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=05AwfxP5ilb7gjCfthMdeox0jigMeFQo89iUMcY1ovLnDT2babWaTPAfLybgaEzhriupjLPlOj9WrFWVomsHX49yqVOXYOTBjSP5ZJEoIVPLtgk1E3dCfrvXcandKP5DYyFSbYLEaQ6oqMTkxVTBX0chC4VtPrNFmiWJFIpQdcI=;
X-YMail-OSG: QOLRU7MVM1kHhX25wrFxMQZ8d4OrKEO8PVqNbFhKkuCMO2SwgWHipDzE.FQvHzEveA--
Date: Thu, 31 May 2007 00:55:11 +0900 (KST)
From: yong Jung <yong_jk@yahoo.com>
Subject: Bug #82314 in linux-source-2.6.20 (Ubuntu), test result
To: linux-kernel@vger.kernel.org
Cc: sleuthkit-users@lists.sourceforge.net, kyle.canonical@gmail.com,
       fabrice@bellet.info
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Message-ID: <272111.8568.qm@web54504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
.
According to Kyle's recommendation,
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/82314,
we tested ignore_hpa option after upgrading to
kernel-2.6.20.10.
But it didn't work as the following messages.
In fdisk output, it can't show us the whole disk size.
In messages file, we found that the system found hpa
area and it's size.
We are ready to more test after the patch modification
soon.
If you don't mind, please check my mistakes in this
test.
............................
[root@localhost log]# df -k
Filesystem           1K-blocks      Used Available
Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                      21092956   5174144  15704872 
25% /
/dev/sda2               101105     18457     77427 
20% /boot
tmpfs                   448556         0    448556  
0% /dev/shm
[root@localhost log]# fdisk -l
Disk /dev/sda: 239.2 GB, 239282664960 bytes
255 heads, 63 sectors/track, 29091 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
   Device Boot      Start         End      Blocks   Id
 System
/dev/sda1   *           1       26181   210298851    7
 HPFS/NTFS
/dev/sda2           26182       26194      104422+  83
 Linux
/dev/sda3           26195       29091    23270152+  8e
 Linux LVM
[root@localhost log]# 
 
/var/log/messages
..
May 28 17:36:49 localhost kernel: ata3: SATA link up
1.5 Gbps (SStatus 113 SControl 300)
May 28 17:36:49 localhost kernel: ata3.00:
ata_hpa_resize 1: sectors = 467348955, hpa_sectors =
488397168
May 28 17:36:49 localhost kernel: ata3.00: Host
Protected Area detected:
May 28 17:36:49 localhost kernel:       current size:
467348955 sectors
May 28 17:36:49 localhost kernel:       native size:
488397168 sectors
May 28 17:36:49 localhost kernel: ata3.00: ATA-7:
SAMSUNG SP2504C, VT100-50, max UDMA7
May 28 17:36:49 localhost kernel: ata3.00: 467348955
sectors, multi 16: LBA48 NCQ (depth 0/32)
May 28 17:36:49 localhost kernel: ata3.00:
ata_hpa_resize 1: sectors = 467348955, hpa_sectors =
488397168
May 28 17:36:49 localhost kernel: ata3.00: Host
Protected Area detected:
May 28 17:36:49 localhost kernel:       current size:
467348955 sectors
May 28 17:36:49 localhost kernel:       native size:
488397168 sectors
May 28 17:36:49 localhost kernel: ata3.00: configured
for UDMA/100
May 28 17:36:49 localhost kernel: scsi3 : sata_sil
May 28 17:36:49 localhost kernel: ata4: SATA link down
(SStatus 0 SControl 300)
May 28 17:36:49 localhost kernel: scsi 2:0:0:0:
Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0
ANSI: 5
May 28 17:36:49 localhost kernel: SCSI device sda:
467348955 512-byte hdwr sectors (239283 MB)
May 28 17:36:49 localhost kernel: sda: Write Protect
is off
May 28 17:36:49 localhost kernel: SCSI device sda:
write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
May 28 17:36:49 localhost kernel: SCSI device sda:
467348955 512-byte hdwr sectors (239283 MB)
May 28 17:36:49 localhost kernel: sda: Write Protect
is off
May 28 17:36:49 localhost kernel: SCSI device sda:
write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
..

dmesg
..
libata version 2.00 loaded.
sata_sil 0000:00:11.0: version 2.0
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 23 (level,
low) -> IRQ 17
ata1: SATA max UDMA/100 cmd 0xF884E080 ctl 0xF884E08A
bmdma 0xF884E000 irq 17
ata2: SATA max UDMA/100 cmd 0xF884E0C0 ctl 0xF884E0CA
bmdma 0xF884E008 irq 17
scsi0 : sata_sil
PM: Adding info for No Bus:host0
ata1: SATA link down (SStatus 0 SControl 300)
scsi1 : sata_sil
..

grub boot command:
root (hd0,1)
kernel /vmlinuz-2.6.20.10 ro root=LABEL=/ rhgb quiet
initrd /initrd-2.6.20.10.img
boot libata.ignore_hpa=1
 
Friendly,
Nobel


      ________________________________________________________ 
180도 달라진 야후! 메일 - 신세대 메일? 이제 새로운 야후! 메일에서 만나보세요.
http://kr.content.mail.yahoo.com/cgland
