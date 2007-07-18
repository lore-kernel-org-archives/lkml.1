Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbXGRGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbXGRGcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXGRGcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:32:10 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:49046 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbXGRGcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:32:08 -0400
Message-ID: <469DB3D9.60204@cateee.net>
Date: Wed, 18 Jul 2007 08:31:53 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       hddtemp@guzu.net
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
>> ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well
>>
>> Probably some dumb application is sending packet commands without
>> checking the device type...
> 
> Ok, we should definitely try to just translate the things, and instead of 
> having user apps that have to know about the (generally not very 
> interesting) differences between IDE and SCSI command set, and when the 
> IDE driver gets a SCSI request (whether from the new generic SG layer or 
> obviously the older SCSI-ioctl layer) it should "just work".
> 
> So I object to that "dumb application" statement. It's the kernel that has 
> traditionally been dumb in not smoothing over the differences between 
> devices well enough.

BTW I found the application: it is hddtemp

Debian description:
Utility to monitor the temperature of your hard drive
.
hddtemp will give you the temperature of your PATA, SATA or SCSI hard
drive by reading Self-Monitoring Analysis and Reporting Technology
(S.M.A.R.T.) information (on drives that support this feature). Only
modern hard drives have a temperature sensor.

See http://www.guzu.net/linux/hddtemp.php , CCed to author.

ciao
	cate


PS: more info about /dev/hdc:

# hdparm -i /dev/hdc

/dev/hdc:

 Model=HDS722525VLAT80, FwRev=V36OA6EA, SerialNo=VN69TECFDDLE3A
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=52
 BuffType=DualPortCache, BuffSize=7938kB, MaxMultSect=16, MultSect=off
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=yes: disabled (255) WriteCache=enabled
 Drive conforms to: ATA/ATAPI-6 T13 1410D revision 3a:  ATA/ATAPI-2,3,4,5,6

 * signifies the current active mode


# hdparm -I /dev/hdc

/dev/hdc:

ATA device, with non-removable media
powers-up in standby; SET FEATURES subcmd spins-up.
        Model Number:       HDS722525VLAT80
        Serial Number:      VN69TECFDDLE3A
        Firmware Revision:  V36OA6EA
Standards:
        Used: ATA/ATAPI-6 T13 1410D revision 3a
        Supported: 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   65535
        heads           16      1
        sectors/track   63      63
        --
        CHS current addressable sectors:    4128705
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  488397168
        device size with M = 1024*1024:      238475 MBytes
        device size with M = 1000*1000:      250059 MBytes (250 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 0
        Advanced power management level: unknown setting (0x0000)
        Recommended acoustic management value: 128, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Release interrupt
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    READ/WRITE_DMA_QUEUED
                Advanced Power Management feature set
                Power-Up In Standby feature set
                SET_FEATURES required to spinup after power up
                Address Offset Reserved Area Boot
                SET_MAX security extension
                Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
        not     supported: enhanced erase
        120min for SECURITY ERASE UNIT.
HW reset results:
        CBLID- above Vih
        Device num = 0 determined by the jumper
Checksum: correct
       *    General Purpose Logging feature set

