Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYDGBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYDGBLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 21:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYDGBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 21:11:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbYDGBLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 21:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FOLLWGuS92csCHWYLOn8/+9qymWB48QoVH2G1TO6beR7O4vMHJpCfPoZ122SdnBMlkK8DLFN/S3ZqxfztO+mRYeVnR9xLvQ6QIT/hzEF6J3IbV9JFP6SLhX1XLh4nqyAM407SaNOBLvyrTlwYDDk6QfRDbtaUE4EP2Vo9jCJrNQ=
Message-ID: <a573e3040804061811h35560b27reedfdca8d14c7d55@mail.gmail.com>
Date: Sun, 6 Apr 2008 21:11:03 -0400
From: "James Sumners" <jsumners.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CRC errors using nForce 520 northbridge chipset
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a BIOSTAR NF520-A2 motherboard[1] with the nForce 520 chipset.
It seems I am getting constant CRC errors no matter how I transfer
data. Downloading files over the NIC results in a hit or miss as to a
complete file. Transferring files over USB seems to result in a bad
transfer every time -- the md5sums don't match before and after the
transfer. I have two SATA drives in the machine from two different
manufacturers. One is brand new, and the other is an old drive I
purchased at retail. I don't believe this problem is with drives. The
BIOS is configure to automatic for all settings (not trying to
overclock anything). I have also ran memtest86+ on the memory; it
returned zero errors. I doubt I am unlucky enough to have two bad SATA
cables; particularly since one was being used before with no issues.
The CRC errors occur no matter which SATA drive I transfer the data
to.

The CRC errors occur if I am using an x86_64 kernel or an i686 kernel
(verified with SystemRescueCD 1.0.1). I am using the 2.6.24.4 kernel
as packaged by Arch Linux. When the machine boots I get the following
information:

scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 23
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 23
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD2500AAJS-00VTA0, 01.01B01, max UDMA/133
ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: Maxtor 6Y120M0, YAR51HW0, max UDMA/133
ata4.00: 240121728 sectors, multi 16: LBA
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 01.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6Y120M0   YAR5 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 240121728 512-byte hardware sectors (122942 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdb] 240121728 512-byte hardware sectors (122942 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk

I am particularly concerned about the "Driver sd needs updating" line.
Could this be the cause of my problem? What can be done to fix this
problem?

Thanks in advance,

James Sumners

[1] -- http://www.newegg.com/Product/Product.aspx?Item=N82E16813138077
