Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYKULiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYKULiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYKULiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:38:07 -0500
Received: from arx.rabbit.us ([76.244.88.238]:58025 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYKULiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:38:05 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2008 06:38:05 EST
Message-ID: <49269D97.2010301@rabbit.us>
Date: Fri, 21 Nov 2008 12:37:59 +0100
From: Peter Rabbitson <rabbit+list@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, smartmontools-support@lists.sourceforge.net,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
References: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan> <49269BCF.8060300@rabbit.us> <alpine.DEB.1.10.0811210632130.5577@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0811210632130.5577@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Fri, 21 Nov 2008, Peter Rabbitson wrote:
> 
>> It might very well be a WD bug. I had three (3) identical WDC
>> WD2500AAJS-08B4A0 drives fail on me with the same _identical_ error
>> (same sector number to the last digit):
>>
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
>> SErr 0x80000 action 0xe frozen
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
>> changed
>> Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
>> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
>> Emask 0x12 (ATA bus error)
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
>> Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
>> Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
>> SControl 0)
>> Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
>> Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
>> hardware sectors (250059 MB)
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
>> read cache: enabled, doesn't support DPO or FUA
>> Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
>> 488166955
>> Oct 27 11:33:46 Arzamas kernel: md: super_written gets error=-5,
>> uptodate=0
>>
>>
>> All 3 drives endured the same multiple rewriting of the sector in
>> question, as they did multiple smart self-tests. I am currently in the
>> process of replacing these two drives with Seagates, (the other 2 in the
>> 4 member array are Maxtors). Will see what happens.
>>
>> Peter
>>
>> P.S. See threads http://marc.info/?l=linux-raid&m=122523835815697 and
>> http://marc.info/?l=linux-raid&m=122669103213041 for more info on my
> 
> Pete,
> 
> Are these -new- 250GiB drives, recently purchased?
> 
> # hdparm -iv /dev/sda
>  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7
> 
> What does yours conform to, just curious?
> 

All 3 were new, bought from trusted channels as replacements (in 2 - 5
week intervals) for two of the Maxtors which went flaky after 4.5 years
of service. All showed usages hours starting from 1, confirming I am the
first user:

root@Arzamas:~# hdparm -iv /dev/sde

/dev/sde:
 IO_support    =  0 (default)
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 30401/255/63, sectors = 488397168, start = 0

 Model=WDC WD2500AAJS-08B4A0                   , FwRev=01.03A01,
SerialNo=     WD-WMAT14036837
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
 BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=488397168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode

root@Arzamas:~#

root@Arzamas:~# hdparm -iv /dev/sdc

/dev/sdc:
 IO_support    =  0 (default)
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 30401/255/63, sectors = 488397168, start = 0

 Model=WDC WD2500AAJS-00B4A0                   , FwRev=01.03A01,
SerialNo=     WD-WCAT11572764
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
 BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=488397168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode

root@Arzamas:~#


The 3rd drive is already gone back to MFG.

Peter




