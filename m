Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXEaVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXEaVjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXEaVjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:39:35 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:20155 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXEaVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yc/MxOxxkZWlBR1nDqvMfZZL7SJCmaMbVsYO7VfgBfp5+gl+IxJIIpl5b15jrzlB5YlwLGY3SGHFeypH3v2M/Ch4JQd0qHZeAL77reoZxQca3hTF4T/sIqGJHyhj4R2ncrhVHvco3bkElCCXz81tgC8QQAoIZaPBtzP3+wLfOSk=
Message-ID: <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com>
Date: Thu, 31 May 2007 22:39:29 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mark Lord" <liml@rtr.ca>
Subject: Re: Compact Flash performance...
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <465F360D.6020603@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
	 <465E3FF0.9010709@rtr.ca>
	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>
	 <465EBE20.6090803@rtr.ca>
	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>
	 <465F360D.6020603@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/07, Mark Lord <liml@rtr.ca> wrote:
> Daniel J Blueman wrote:
> > Whoops, yes. Here is the expected data:
[snip]
>
> Thanks.  I'll use that data to update/validate future versions of hdparm.
> At UDMA66, it *should* be capable of the 40MByte/sec realm of readback perf,
> assuming the card itself is really that fast.

hdparm in the other identify mode does list the UDMA3/4 modes twice
[1], which looks odd.

> I don't know too much about the specifics, though, but perhaps the
> card is only capable of full speed in PIO6, which requires special cabling
> and is currently unsupported in libata (?).

Seems less likely, as the Extreme IV reader (and another) supports
UDMA mode 4; in PIO mode 6, they apparently top out at 17MB/s [2],
which seems reasonable.

> Another factor, is that hdparm performs discrete, non-overlapping,
> reads of 1MByte chunks for its timing test.  Some drives cannot achieve
> full performance with such (relatively) large gaps between IO's.

100MB transfers still achieve 32MB/s:

# dd if=/dev/sdb of=/dev/null bs=100000k count=10
10+0 records in
10+0 records out
1024000000 bytes (1.0 GB) copied, 31.9328 seconds, 32.1 MB/s

> Also, just for fun, you could try "hdparm --direct -t /dev/sdb"

# hdparm --direct -t /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   96 MB in  3.05 seconds =  31.47 MB/sec

It is conceivable that the controller in the two particular readers
which get 40MB/s are doing some kind of prefetching, but seems seems
like an extreme gain.

I'll check things out with the IDE PIIX code also. Thanks for your help!
  Daniel

> Cheers

--- [1]

# hdparm -i /dev/sdb

/dev/sdb:

 Model=SanDisk SDCFX-4096                      , FwRev=HDX 4.04,
SerialNo=    116802D2807J3335
 Config={ HardSect NotMFM Removeable DTR>10Mbs nonMagnetic }
 RawCHS=7964/16/63, TrkSize=0, SectSize=576, ECCbytes=4
 BuffType=DualPort, BuffSize=1kB, MaxMultSect=4, MultSect=?0?
 CurCHS=7964/16/63, CurSects=8027712, LBA=yes, LBAsects=8027712
 IORDY=no, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 *udma4 udma3 *udma4
 AdvancedPM=no WriteCache=disabled
 Drive conforms to: Unspecified:  ATA/ATAPI-4

 * signifies the current active mode

--- [2]

http://www.robgalbraith.com/bins/content_page.asp?cid=7-7896-8475
-- 
Daniel J Blueman
