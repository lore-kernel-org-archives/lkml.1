Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbXG2Aag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbXG2Aag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 20:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXG2Aa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 20:30:28 -0400
Received: from zaphod.dth.net ([85.159.112.68]:54906 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483AbXG2Aa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 20:30:27 -0400
Date: Sun, 29 Jul 2007 02:30:24 +0200
From: Danny ter Haar <dth@dth.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Message-ID: <20070729003024.GA30132@dth.net>
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707290142.53689.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bartlomiej Zolnierkiewicz (bzolnier@gmail.com):
> Should be harmless for now but we would like to fix it the long-term,
> please send "hdparm --Istdout /dev/hda" output.


I allready made that available in the same subdir:

http://www.dth.net/kernel/

Output repeated here:


voyage:~# hdparm -I /dev/hda

/dev/hda:

ATA device, with non-removable media
        Model Number:       PQI IDE DiskOnModule                    
        Serial Number:      
        Firmware Revision:  db01.20a
Standards:
        Likely used: 1
Configuration:
        hard sectored
        not MFM encoded 
        head switch time > 15us
        fixed drive
        disk xfer rate > 5Mbs
        Logical         max     current
        cylinders       500     500
        heads           16      16
        sectors/track   32      32
        --
        bytes/track: 0  bytes/sector: 528
        CHS current addressable sectors:     256000
        LBA    user addressable sectors:     256000
        device size with M = 1024*1024:         125 MBytes
        device size with M = 1000*1000:         131 MBytes 
Capabilities:
        LBA, IORDY not likely
        Buffer type: 0002: dual port, multi-sector
        Buffer size: 1.0kB      bytes avail on r/w long: 4
        Cannot perform double-word IO
        R/W multiple sector transfer: Max = 1   Current = 0
        DMA: not supported
        PIO: pio0 pio1 pio2 

voyage:~# hdparm -tT /dev/hda
/dev/hda:
 Timing cached reads:   116 MB in  2.00 seconds =  57.92 MB/sec
 Timing buffered disk reads:   16 MB in  3.01 seconds =   5.32 MB/sec
# hdparm --Istdout /dev/hda

/dev/hda:
045a 01f4 0000 0010 0000 0210 0020 0003
e800 0000 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 0002 0002 0004 6462
3031 2e32 3061 5051 4920 4944 4520 4469
736b 4f6e 4d6f 6475 6c65 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 0001
0000 0200 0000 0200 0000 0001 01f4 0010
0020 e800 0003 0100 e800 0003 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000

> No IDE changes yet after 2.6.22-git17 so something else must have broke down.

darn....

I also tried with libata driver on the 2.6.22 series but that wouldn't 
work as well. I contacted Alan Cox and he made some patches/suggestions
that made 2.6.22-git16 with libata work!
I hope his patch will make it into mainline soon.

For the dmesg output of this kernel 
http://www.dth.net/kernel/via_output_2.6.22-git16-libata_fix_alan_cox

> Please retry with the latest -git kernel and if the problem is still
> there install git, get kernel tree and run git-bisect.
> 
> Since 2.6.22-git17 works fine the initial "good" commit would be
> e51f802babc5e368c60fbfd08c6c11269c9253b0 and the initial "bad" one
> f695baf2df9e0413d3521661070103711545207a (for 2.6.23-rc1).
> 
> If you need some practical examples on using git-bisect, this one
> 
> http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
> 
> is a very good one (IMO).

I will certainly will read/try that.

> > VP_IDE: VIA vt8231 (rev 10) IDE UDMA100 controller on pci0000:00:11.1
> >     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
> >     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
> > Marking TSC unstable due to: possible TSC halt in C2.
> > Time: acpi_pm clocksource has been installed.
> > hda: PQI IDE DiskOnModule, ATA DISK drive
> > hda: IRQ probe failed (0xfff2)
> 
> This message would indicate broken IRQ routing, however it is no
> longer present in the log for the kernel 2.6.23-rc1-git4 ([3]).

i booted with routeirq=pci but gave the same negative result.
 
> Interesting that the kernel 2.6.22-git17 (log [2]) doesn't use via82cxxx
> IDE host driver while the kernel 2.6.23-rc1-git4 (log [3]) does...?

kernel configs are also in above mentioned webdir

basically copied the 2.6.22-git17 and ran a make oldconfig.


Did a diff -u on those config files and there is really a lot different:

[snip]
-# ATA/IDE/MFM/RLL support
+# Device Drivers
 #
[snip]
 #
 # IDE chipset support/bugfixes
 #
+# CONFIG_BLK_DEV_TRM290 is not set
 CONFIG_BLK_DEV_VIA82CXXX=y
-# CONFIG_IDE_CHIPSETS is not set
-# CONFIG_IDEDMA_AUTO is not set
+# CONFIG_BLK_DEV_TC86C001 is not set
+# CONFIG_IDE_ARM is not set
+CONFIG_BLK_DEV_IDEDMA=y
 # CONFIG_IDEDMA_IVB is not set
-# CONFIG_DMA_NONPCI is not set


I will run a make menuconfig and see if i can clean things up.

> > I know my hardware is "ancient" and the flash thing is probably
> > not current. My firewall however is solar powerpowered (10 watt 
> 
> Neat. :)
> 
> > power consumption) and it would be fun if i could run the latest/
> > greatest kernels on it.
> 
> With the buggy commit number obtained from git-bisect it should be
> fixed quite quickly.


Thanks for your feedback/enthousiasm!

Danny
-- 
