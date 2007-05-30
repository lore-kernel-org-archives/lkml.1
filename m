Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbXE3WKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbXE3WKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbXE3WKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:10:32 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:32465 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbXE3WKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ubi3+5R0hWhotIdEl3mDx9zpZV+Nebdx+VVtFz67ZlN1YeLq7QGZyCPS/IpS/6ovgTQJ5GWAhyLvbPqx78RSqnrVISAxCd1Zh7pVFuRnHBVTaqkbvwuqNGbpbnnuzT+X8bjBzS9xwOvVZL7aCX6LOFosstf7wZFHIZiRkE/xVxo=
Message-ID: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
Date: Wed, 30 May 2007 23:10:18 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: bzolnier@gmail.com
Subject: Compact Flash performance...
Cc: linux-ide@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a SanDisk Extreme IV 4GB CF card, capable of 40MB/s read, but
am seeing 30MB/s read [1], connected directly to the IDE bus on my
ICH8 controller.

How can I find out if this would be a timing or configuration issue?
On 2.6.20.5 [2], the 120nS timing looks to be right [3], but perhaps
no multi-word transfer is hurting here...alas, it can't be enabled
with the libata subsystem and 'hdparm -m', so what else?

Daniel

--- [1]

# hdparm -t /dev/sdb
/dev/sdb:
 Timing buffered disk reads:   94 MB in  3.05 seconds =  30.79 MB/sec

--- [2]

ata7: PATA max UDMA/100 cmd 0x000000000001bc00 ctl 0x000000000001b882
bmdma 0x000000000001b400 irq 17
ata7.00: CFA: SanDisk SDCFX-4096, HDX 4.04, max UDMA/66
ata7.00: 8027712 sectors, multi 0: LBA
ata7.00: configured for UDMA/66
ATA: abnormal status 0x7F on port 0x000000000001b807
scsi 6:0:0:0: Direct-Access     ATA      SanDisk SDCFX-40 HDX  PQ: 0 ANSI: 5
SCSI device sdb: 8027712 512-byte hdwr sectors (4110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdb: 8027712 512-byte hdwr sectors (4110 MB)
sdb: sdb1
sd 6:0:0:0: Attached scsi removable disk sdb

--- [3]

# hdparm -I /dev/sdb

/dev/sdb:

CompactFlash ATA device, with removable media
        Model Number:       SanDisk SDCFX-4096
        Serial Number:      116802D2807J3335
        Firmware Revision:  HDX 4.04
Standards:
        Supported: 4
        Likely used: 4
Configuration:
        Logical         max     current
        cylinders       7964    7964
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    8027712
        LBA    user addressable sectors:    8027712
        device size with M = 1024*1024:        3919 MBytes
        device size with M = 1000*1000:        4110 MBytes (4 GB)
Capabilities:
        LBA, IORDY(may be)(cannot be disabled)
        Standby timer values: spec'd by Vendor
        R/W multiple sector transfer: Max = 4   Current = 0
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 *udma4
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
                Write cache
           *    CFA feature set
-- 
Daniel J Blueman
