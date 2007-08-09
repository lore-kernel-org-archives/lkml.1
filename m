Return-Path: <linux-kernel-owner+w=401wt.eu-S937732AbXHIB4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937732AbXHIB4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbXHIB4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:56:40 -0400
Received: from vscan02.westnet.com.au ([203.10.1.132]:59501 "EHLO
	vscan02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbXHIB4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:56:39 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 21:56:38 EDT
Message-ID: <46BA6E79.8090706@parkingdenied.com>
Date: Thu, 09 Aug 2007 09:31:37 +0800
From: Ross Fawcett <claymen@parkingdenied.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sata_sil24 problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2007 01:31:37.0979 (UTC) FILETIME=[079E04B0:01C7DA25]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to track down whats causing the problems with a Silicon Image
3124 PCI/PCI-X sata card and running it under linux.

A quick rundown on the hardware that is in use.

Athlon X2 4200+
Asus A8S-X Mobo
Silicon Image 3124 4port SATA RAID card (using a PCI slot)
5x500gb WDJB 500gb SATA/SATA2
1x200gb WDJB 200gb IDE

Running pure 64bit ubunutu and tested with both a hand compiled kernel
as well as the ones that were supplied (2.6.20, 2.6.22)

The drives themselves are in a 5disk software raid5 array. Now initially
I didnt have any problems but after a bit of use I get errors like
below. It seems to only be when the drives are put under high load and
ive not been able to pinpoint the problem. I've swapped drives around as
well as run complete bad block scans over the drives (as at times it
reports that there are medium errors) to which there are none. I've
updated the firmware/bios on the sata card and the motherboard and also
replaced a number of cables in the system.

The errors I get are like these.

[ 1073.018375] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1073.018382] ata4.00: (irq_stat 0x00020002, device error via SDB FIS)
[ 1073.018389] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1073.018391]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1073.041841] ata4.00: configured for UDMA/100
[ 1073.041851] ata4: EH complete
[ 1073.043029] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1073.043052] sd 3:0:0:0: [sdc] Write Protect is off
[ 1073.043056] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1073.043091] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1075.249554] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1075.249561] ata4.00: (irq_stat 0x00060002, device error via SDB FIS)
[ 1075.249567] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1075.249569]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1075.272989] ata4.00: configured for UDMA/100
[ 1075.273001] ata4: EH complete
[ 1075.274169] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1075.274186] sd 3:0:0:0: [sdc] Write Protect is off
[ 1075.274189] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1075.274213] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1077.563989] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1077.563996] ata4.00: (irq_stat 0x00060002, device error via SDB FIS)
[ 1077.564002] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1077.564003]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1077.587390] ata4.00: configured for UDMA/100
[ 1077.587399] ata4: EH complete
[ 1077.588566] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1077.588581] sd 3:0:0:0: [sdc] Write Protect is off
[ 1077.588583] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1077.588605] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1079.778501] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1079.778508] ata4.00: (irq_stat 0x00060002, device error via SDB FIS)
[ 1079.778514] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1079.778516]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1079.801949] ata4.00: configured for UDMA/100
[ 1079.801961] ata4: EH complete
[ 1079.803132] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1079.803150] sd 3:0:0:0: [sdc] Write Protect is off
[ 1079.803153] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1079.803174] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1082.509203] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1082.509210] ata4.00: (irq_stat 0x00060002, device error via SDB FIS)
[ 1082.509216] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1082.509218]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1082.532624] ata4.00: configured for UDMA/100
[ 1082.532637] ata4: EH complete
[ 1082.533808] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1082.533821] sd 3:0:0:0: [sdc] Write Protect is off
[ 1082.533824] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1082.533852] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1084.757027] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[ 1084.757034] ata4.00: (irq_stat 0x00060002, device error via SDB FIS)
[ 1084.757040] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
cdb 0x0 data 65536 in
[ 1084.757042]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
0x9 (media error)
[ 1084.780484] ata4.00: configured for UDMA/100
[ 1084.780499] ata4: EH complete
[ 1084.781912] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors
(500108 MB)
[ 1084.781921] sd 3:0:0:0: [sdc] Write Protect is off
[ 1084.781924] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1084.781947] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

Eventually of course it gives up and kicks the drive out of the array.
This problem has been ongoing. I'm about to give 2.6.23-mm a go and see
if that helps as there were a few libata fixups but they dont appear to
be related specifically to this card however I'm willing to test it out.

Another example of the errors I have been seeing are these.

[ 885.460000] ata5.00: exception Emask 0x0 SAct 0x1ff SErr 0x0 action
0x2 frozen
[ 885.460000] ata5.00: cmd 61/00:00:00:ee:e1/01:00:01:00:00/40 tag 0 cdb
0x0 data 131072 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/08:08:00:ef:e1/00:00:01:00:00/40 tag 1 cdb
0x0 data 4096 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/00:10:00:f3:e1/01:00:01:00:00/40 tag 2 cdb
0x0 data 131072 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/f8:18:08:ef:e1/00:00:01:00:00/40 tag 3 cdb
0x0 data 126976 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/08:20:00:f0:e1/00:00:01:00:00/40 tag 4 cdb
0x0 data 4096 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/f8:28:08:f0:e1/00:00:01:00:00/40 tag 5 cdb
0x0 data 126976 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/00:30:00:ed:e1/01:00:01:00:00/40 tag 6 cdb
0x0 data 131072 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/00:38:00:f1:e1/01:00:01:00:00/40 tag 7 cdb
0x0 data 131072 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.460000] ata5.00: cmd 61/00:40:00:f2:e1/01:00:01:00:00/40 tag 8 cdb
0x0 data 131072 out
[ 885.460000] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 885.772000] ata5: soft resetting port
[ 895.860000] ata5: softreset failed (timeout)
[ 895.860000] ata5: hard resetting port
[ 898.252000] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 898.252000] ata5.00: ata_hpa_resize 1: hpa sectors (0) is smaller than
sectors (976773168)
[ 898.252000] ata5.00: failed to set xfermode (err_mask=0x1)
[ 898.252000] ata5: failed to recover some devices, retrying in 5 secs
[ 903.256000] ata5: hard resetting port
[ 905.648000] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 905.684000] ata5.00: ata_hpa_resize 1: hpa sectors (0) is smaller than
sectors (976773168)
[ 905.684000] ata5.00: failed to set xfermode (err_mask=0x1)
[ 905.684000] ata5: limiting SATA link speed to 1.5 Gbps
[ 905.684000] ata5.00: limiting speed to UDMA/100:PIO3
[ 905.684000] ata5: failed to recover some devices, retrying in 5 secs
[ 910.688000] ata5: hard resetting port
[ 913.080000] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 913.116000] ata5.00: ata_hpa_resize 1: hpa sectors (0) is smaller than
sectors (976773168)
[ 913.116000] ata5.00: failed to set xfermode (err_mask=0x1)
[ 913.120000] ata5.00: disabled
[ 913.624000] ata5: EH complete
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584768
[ 913.624000] raid5: Disk failure on sdd, disabling device. Operation
continuing on 4 devices
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584512
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31583488
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584264
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584256
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584008
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31585024
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31584000
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] end_request: I/O error, dev sdd, sector 31583744
[ 913.624000] sd 4:0:0:0: [sdd] READ CAPACITY failed
[ 913.624000] sd 4:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[ 913.624000] sd 4:0:0:0: [sdd] Sense not available.
[ 913.624000] sd 4:0:0:0: [sdd] Write Protect is off
[ 913.624000] sd 4:0:0:0: [sdd] Mode Sense: 00 00 00 00
[ 913.624000] sd 4:0:0:0: [sdd] Asking for cache data failed
[ 913.624000] sd 4:0:0:0: [sdd] Assuming drive cache: write through

As you can see it does try and attempt to recover but then just fails
out. I've also tried locking the SATA link to SATA1/SATA150 using
jumpers on the actual hdd's themselves.

I'm at a total loss as to what is causing the problem as the drives do
seem to work ok on their own and the smartctl doesnt seem to return
anything meaningful.

Anyone able to figure out whats happening?
