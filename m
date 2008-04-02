Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbYDBUrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbYDBUrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYDBUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:47:41 -0400
Received: from smtp1.bizmail.net4india.com ([202.71.129.104]:37887 "EHLO
	smtp.bizmail.net4india.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754709AbYDBUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:47:40 -0400
X-Greylist: delayed 26890 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 16:47:39 EDT
Message-ID: <47F38841.9080300@tidaldata.com>
Date: Wed, 02 Apr 2008 18:51:05 +0530
From: Chaitanya Huilgol <chaitanya@tidaldata.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.13pre) Gecko/20070719 CentOS/1.0.9-4.el4.centos SeaMonkey/1.0.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ATA Bus Error with ICH7R and WDC WD7500AAKS-0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am getting frequent 'ATA bus error' with ICH7R & WD7500AAKS-0.
I have tried the following combinations of NCQ and Write Cache disabled,
Write I/O is done with dd:
dd if=/dev/zero of=/dev/sdc bs=1048576

(1) With Write Cache is Disabled and NCQ is enabled then the
errors are seen immediately on starting I/O
(2) With Write Cache enabled and NCQ enabled the errors are less frequent
(3) With NCQ disabled using "echo 1 >/sys/block/sdc/device/queue_depth"
the errors are rare but do occur.

I have tried with different SATA Cables & Sata port combinations to
rule out cable/bad port issues.

I am wondering if the WDC WD7500AAKS-0 is another candidate for NCQ blacklist?


Configuration Details:
------------------------

MotherBoard: S975XBX2
AHCI controller: ICH7R

Kernel     version:        2.6.21.1
ahci.ko    version:        2.1
libata.ko  version:        2.20

Relevant dmesg output:
-------------------------
ata3: SATA max UDMA/133 cmd 0xf8822200 ctl 0x00000000 bmdma 0x00000000 irq 220
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi3 : ahci
scsi 2:0:0:0: Direct-Access     ATA      WDC WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

ata3.00: exception Emask 0x10 SAct 0x7fffffff SErr 0x810000 action 0x2 frozen
ata3.00: (irq_stat 0x08400000, interface fatal error, PHY RDY changed)
ata3.00: cmd 61/00:00:78:96:fd/04:00:00:00:00/40 tag 0 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:08:78:9a:fd/04:00:00:00:00/40 tag 1 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:10:78:aa:fd/04:00:00:00:00/40 tag 2 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:18:78:ae:fd/04:00:00:00:00/40 tag 3 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:20:78:b2:fd/04:00:00:00:00/40 tag 4 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:28:78:b6:fd/04:00:00:00:00/40 tag 5 cdb 0x0 data 524288 out
	res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:30:78:ba:fd/04:00:00:00:00/40 tag 6 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:38:78:be:fd/04:00:00:00:00/40 tag 7 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:40:78:c2:fd/04:00:00:00:00/40 tag 8 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:48:78:c6:fd/04:00:00:00:00/40 tag 9 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:50:78:ca:fd/04:00:00:00:00/40 tag 10 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:58:78:ce:fd/04:00:00:00:00/40 tag 11 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:60:78:d2:fd/04:00:00:00:00/40 tag 12 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:68:78:d6:fd/04:00:00:00:00/40 tag 13 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:70:78:da:fd/04:00:00:00:00/40 tag 14 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:78:78:de:fd/04:00:00:00:00/40 tag 15 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:80:78:e2:fd/04:00:00:00:00/40 tag 16 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:88:78:e6:fd/04:00:00:00:00/40 tag 17 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:90:78:ea:fd/04:00:00:00:00/40 tag 18 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:98:78:ee:fd/04:00:00:00:00/40 tag 19 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:a0:78:f2:fd/04:00:00:00:00/40 tag 20 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:a8:78:f6:fd/04:00:00:00:00/40 tag 21 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:b0:78:fa:fd/04:00:00:00:00/40 tag 22 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:b8:78:fe:fd/04:00:00:00:00/40 tag 23 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:c0:78:02:fe/04:00:00:00:00/40 tag 24 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:c8:78:06:fe/04:00:00:00:00/40 tag 25 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:d0:78:0a:fe/04:00:00:00:00/40 tag 26 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:d8:78:92:fd/04:00:00:00:00/40 tag 27 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:e0:78:9e:fd/04:00:00:00:00/40 tag 28 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:e8:78:a2:fd/04:00:00:00:00/40 tag 29 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: cmd 61/00:f0:78:a6:fd/04:00:00:00:00/40 tag 30 cdb 0x0 data 524288 out
          res 40/00:cc:78:06:fe/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata3: waiting for device to spin up (7 secs)
ata3: soft resetting port
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: configured for UDMA/133
ata3: EH complete
SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00


lspci output:
-----------------

00:00.0 Host bridge: Intel Corporation Memory Controller Hub
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 5 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 6 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controllers cc=AHCI (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
02:00.0 SATA controller: Marvell Technology Group Ltd. Unknown device 6145 (rev a1)
03:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet Controller (Copper) (rev 03)
03:00.3 Serial controller: Intel Corporation Unknown device 108f (rev 03)
03:00.4 Class 0c07: Intel Corporation Unknown device 108e (rev 03)
04:00.0 VGA compatible controller: S3 Inc. 86c764/765 [Trio32/64/64V+] (rev 54)
04:04.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)








