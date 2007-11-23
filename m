Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXKWHVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXKWHVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 02:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXKWHVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 02:21:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbXKWHVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 02:21:33 -0500
Date: Thu, 22 Nov 2007 23:21:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata NCQ blacklist entry
Message-Id: <20071122232109.efdbf1b4.akpm@linux-foundation.org>
In-Reply-To: <200711132155.15506.dl9pf@gmx.de>
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
	<200711132155.15506.dl9pf@gmx.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 21:55:15 +0100 Jan-Simon M__ller <dl9pf@gmx.de> wrote:

> Hi!

You removed from cc the guys who are most likely to fix this.  Please always
do reply-to-all.

> Just using kernel 2.6.24-rc2 (325d22df7b19e0116aff3391d3a03f73d0634ded).
> 
> When booting the system hangs, using the emergency-sync a couple of times gets 
> the system to go on at some point. 
> Its always around starting X/Firewall (can't actually say whats done in this 
> moment).
> 
> Looking at dmesg i found this (NCQ disabled ...)
> 
> dmesg output
> 
> ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
> ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 
> FIS=004040a1:00000002
> ata1.00: cmd 61/08:10:bc:b2:5d/00:00:08:00:00/40 tag 2 cdb 0x0 data 4096 out
>          res 40/00:14:bc:b2:5d/00:00:08:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> ata1.00: NCQ disabled due to excessive errors
> ata1.00: exception Emask 0x2 SAct 0xfffd3 SErr 0x0 action 0x2 frozen
> ata1.00: spurious completions during NCQ issue=0x0 SAct=0xfffd3 
> FIS=004040a1:00000020
> ata1.00: cmd 60/10:00:14:05:69/00:00:06:00:00/40 tag 0 cdb 0x0 data 8192 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:08:cc:dd:12/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/18:20:84:54:a3/00:00:05:00:00/40 tag 4 cdb 0x0 data 12288 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:30:bc:b1:07/00:00:06:00:00/40 tag 6 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:38:dc:b1:07/00:00:06:00:00/40 tag 7 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/10:40:3c:b2:07/00:00:06:00:00/40 tag 8 cdb 0x0 data 8192 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:48:2c:cf:07/00:00:06:00:00/40 tag 9 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:50:3c:cf:07/00:00:06:00:00/40 tag 10 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:58:64:b4:12/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/28:60:6c:b4:12/00:00:04:00:00/40 tag 12 cdb 0x0 data 20480 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/f8:68:7c:e1:07/00:00:06:00:00/40 tag 13 cdb 0x0 data 126976 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:70:a4:04:69/00:00:06:00:00/40 tag 14 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/18:78:b4:04:69/00:00:06:00:00/40 tag 15 cdb 0x0 data 12288 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:80:a4:5c:6a/00:00:06:00:00/40 tag 16 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/20:88:2c:05:69/00:00:06:00:00/40 tag 17 cdb 0x0 data 16384 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/30:90:54:05:69/00:00:06:00:00/40 tag 18 cdb 0x0 data 24576 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:98:94:05:69/00:00:06:00:00/40 tag 19 cdb 0x0 data 4096 in
>          res 40/00:04:14:05:69/00:00:06:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> 
> 
> 
> hdparm -i /dev/sda
> 
> /dev/sda:
> 
>  Model=WDC WD2500BEVS-22UST0                   , FwRev=01.01A01, SerialNo=     
> WD-WXE807E07297
>  Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
>  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
>  BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=?16?
>  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
>  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
>  PIO modes:  pio0 pio3 pio4
>  DMA modes:  mdma0 mdma1 mdma2
>  UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
>  AdvancedPM=yes: disabled (255) WriteCache=enabled
>  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7
> 
>  * signifies the current active mode
> 

So is this problem (which in another email you attributed to smartd) also
present in 2.6.23?

And is is still present in 2.6.24-rc3?

Thanks.
