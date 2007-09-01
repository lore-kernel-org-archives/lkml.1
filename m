Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXIAQIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXIAQIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXIAQHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:07:51 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:6621 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXIAQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PT52/Nru8QahT8kLEJtYrFs2yWPI6X9dNxj/K2TaGZ4nFQ1HRJhCaMeMnrdYPe+qBPZsNu6SG6AoaNnrpQkZ9LaLSWCuuOWJE8+lSeROOr++NhVbkXGH9y36NHLX8/i43oeAT5895jw7pttYXiVA5OOd2qW/BNL3kBKQQG9pIks=
Message-ID: <64bb37e0709010907x5a73f9dbof8e5b2c92425452e@mail.gmail.com>
Date: Sat, 1 Sep 2007 18:07:48 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/

The good:
> +hpet-force-enable-on-vt8235-37-chipsets.patch
> +hpet-force-enable-on-vt8235-37-chipsets-fix.patch

Kernel 2.6.23-rc4-mm1 works on one of my systems with:
00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host
Bridge (rev 01)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
[K8T800/K8T890 South]
00:0e.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA
RAID Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)

It now has a working HPET.

The bad:
sata_sil24 and/or libata are broken.
On my second system (MCP55 + SiI 3132) I see this:
[    3.890000] scsi0 : sata_sil24
[    3.900000] scsi1 : sata_sil24
[    3.900000] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 16
[    3.920000] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 16
[    4.300000] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.360000] ata1.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    4.370000] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.430000] ata1.00: configured for UDMA/100
[    4.500000] ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0010dc00005cc354]
[    4.500000] ieee1394: Host added: ID:BUS[0-01:1023]  GUID[0011d80000c4c261]
[    4.790000] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.850000] ata2.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    4.860000] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.920000] ata2.00: configured for UDMA/100
[    4.930000] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    4.960000] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    4.980000] sd 0:0:0:0: [sda] Write Protect is off
[    4.990000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.990000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.020000] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    5.040000] sd 0:0:0:0: [sda] Write Protect is off
[    5.050000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.050000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.080000]  sda: sda1 sda2
[    5.110000] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.120000] scsi 1:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    5.140000] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    5.170000] sd 1:0:0:0: [sdb] Write Protect is off
[    5.180000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.180000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.210000] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    5.230000] sd 1:0:0:0: [sdb] Write Protect is off
[    5.240000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.240000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.270000]  sdb: sdb1 sdb2
[    5.300000] sd 1:0:0:0: [sdb] Attached SCSI disk
[snip]
[   12.120000] Freeing unused kernel memory: 340k freed
[   33.210000] md: Autodetecting RAID arrays.
[   33.300000] md: Scanned 5 and added 5 devices.
[   33.300000] md: autorun ...
[   33.300000] md: considering sdc2 ...
[   33.300000] md:  adding sdc2 ...
[   33.300000] md:  adding sdb2 ...
[   33.300000] md: sdb1 has different UUID to sdc2
[   33.300000] md:  adding sda2 ...
[   33.300000] md: sda1 has different UUID to sdc2
[   33.300000] md: created md1
[   33.300000] md: bind<sda2>
[   33.300000] md: bind<sdb2>
[   33.300000] md: bind<sdc2>
[   33.300000] md: running: <sdc2><sdb2><sda2>
[   33.310000] raid5: device sdc2 operational as raid disk 2
[   33.310000] raid5: device sdb2 operational as raid disk 1
[   33.310000] raid5: device sda2 operational as raid disk 0
[   33.310000] raid5: allocated 3224kB for md1
[   33.310000] raid5: raid level 5 set md1 active with 3 out of 3
devices, algorithm 2
[   33.310000] RAID5 conf printout:
[   33.310000]  --- rd:3 wd:3
[   33.310000]  disk 0, o:1, dev:sda2
[   33.310000]  disk 1, o:1, dev:sdb2
[   33.310000]  disk 2, o:1, dev:sdc2
[   33.320000] md1: bitmap initialized from disk: read 10/10 pages, set 115 bits
[   33.320000] created bitmap (145 pages) for device md1
[   63.420000] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   63.420000] ata2.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
cdb 0x0 data 4096 out
[   63.420000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   63.420000] ata2.00: status: {DRDY }
[   63.420000] ata2: hard resetting link
[   65.720000] ata2: softreset failed (port not ready)
[   65.720000] ata2: reset failed (errno=-5), retrying in 8 secs
[   73.420000] ata2: hard resetting link
[   75.720000] ata2: softreset failed (port not ready)
[   75.720000] ata2: reset failed (errno=-5), retrying in 8 secs
[   83.420000] ata2: hard resetting link
[   85.720000] ata2: softreset failed (port not ready)
[   85.720000] ata2: reset failed (errno=-5), retrying in 33 secs
[  118.420000] ata2: limiting SATA link speed to 1.5 Gbps
[  118.420000] ata2: hard resetting link
[  120.720000] ata2: softreset failed (port not ready)
[  120.720000] ata2: reset failed, giving up
[  120.720000] ata2.00: disabled
[  120.720000] ata2: EH complete
[  120.720000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.720000] end_request: I/O error, dev sdb, sector 625137161
[  120.720000] md: super_written gets error=-5, uptodate=0
[  120.720000] raid5: Disk failure on sdb2, disabling device.
Operation continuing on 2 devices
[  120.750000] md: considering sdb1 ...
[  120.750000] RAID5 conf printout:
[  120.750000]  --- rd:3 wd:2
[  120.750000] md:  adding sdb1 ...
[  120.750000]  disk 0, o:1, dev:sda2
[  120.750000]  disk 1, o:0, dev:sdb2
[  120.750000]  disk 2, o:1, dev:sdc2
[  120.750000] md:  adding sda1 ...
[  120.750000] md: created md0
[  120.750000] md: bind<sda1>
[  120.750000] md: bind<sdb1>
[  120.750000] md: running: <sdb1><sda1>
[  120.760000] raid1: raid set md0 active with 2 out of 2 mirrors
[  120.760000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.760000] end_request: I/O error, dev sdb, sector 19550919
[  120.780000] RAID5 conf printout:
[  120.780000]  --- rd:3 wd:2
[  120.780000]  disk 0, o:1, dev:sda2
[  120.780000]  disk 2, o:1, dev:sdc2
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550927
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550935
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550943
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550951
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550959
[  120.780000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.780000] end_request: I/O error, dev sdb, sector 19550967
[  120.790000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.790000] end_request: I/O error, dev sdb, sector 19550975
[  120.790000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.790000] end_request: I/O error, dev sdb, sector 19550983
[  120.790000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.790000] end_request: I/O error, dev sdb, sector 19550991
[  120.790000] md0: bitmap initialized from disk: read 10/10 pages, set 0 bits
[  120.790000] created bitmap (150 pages) for device md0
[  120.790000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  120.790000] end_request: I/O error, dev sdb, sector 19550919
[  120.790000] md: super_written gets error=-5, uptodate=0
[  120.790000] raid1: Disk failure on sdb1, disabling device.
[  120.790000]  Operation continuing on 1 devices
[  120.810000] md: ... autorun DONE.
[  120.810000] RAID1 conf printout:
[  120.810000]  --- wd:1 rd:2
[  120.810000]  disk 0, wo:0, o:1, dev:sda1
[  120.810000]  disk 1, wo:1, o:0, dev:sdb1
[  120.860000] RAID1 conf printout:
[  120.860000]  --- wd:1 rd:2
[  120.860000]  disk 0, wo:0, o:1, dev:sda1
[  129.360000] Filesystem "dm-0": Disabling barriers, trial barrier write failed
[  129.390000] XFS mounting filesystem dm-0
[  129.600000] Ending clean XFS mount for filesystem: dm-0
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137153
[  132.850000] Buffer I/O error on device sdb2, logical block 75698256
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137153
[  132.850000] Buffer I/O error on device sdb2, logical block 75698256
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137153
[  132.850000] Buffer I/O error on device sdb2, logical block 75698256
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 19551105
[  132.850000] Buffer I/O error on device sdb2, logical block 0
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 19551113
[  132.850000] Buffer I/O error on device sdb2, logical block 1
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 19551105
[  132.850000] Buffer I/O error on device sdb2, logical block 0
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 19551105
[  132.850000] Buffer I/O error on device sdb2, logical block 0
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137337
[  132.850000] Buffer I/O error on device sdb2, logical block 75698279
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137337
[  132.850000] Buffer I/O error on device sdb2, logical block 75698279
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137337
[  132.850000] Buffer I/O error on device sdb2, logical block 75698279
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137337
[  132.850000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  132.850000] end_request: I/O error, dev sdb, sector 625137337
...

After that the system booted up fine, only running with the two of
three RAID drives.
(sda is on sata_sil24, sdc on sata_nv. I used the sata_nv.swncq=1 switch)

The ugly:
I wanted to verify that this was not a onetime bug and rebooted the system.
This time md kicked sdb because it was stale and then also kicked sda
with an error similar to the above. Which killed the RAID5 completely.
:(
At least I was able to resurrect it with mdadm --force.

So the sata_sil24 error seems repeatable, but also not limited to one
specific port.

The system is now up again running 2.6.23-rc3-mm1 with all three drives.

Torsten
