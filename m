Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXEaUyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXEaUyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXEaUyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:54:41 -0400
Received: from rtr.ca ([64.26.128.89]:2962 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXEaUyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:54:40 -0400
Message-ID: <465F360D.6020603@rtr.ca>
Date: Thu, 31 May 2007 16:54:37 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca> <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>
In-Reply-To: <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
>
> Whoops, yes. Here is the expected data:
> 
> # hdparm --Istdout /dev/sdb
> 
> /dev/sdb:
> 848a 1f1c 0000 0010 0000 0240 003f 007a
> 7e40 0000 2020 2020 3131 3638 3032 4432
> 3830 374a 3333 3335 0002 0002 0004 4844
> 5820 342e 3034 5361 6e44 6973 6b20 5344
> 4346 582d 3430 3936 2020 2020 2020 2020
> 2020 2020 2020 2020 2020 2020 2020 0004
> 0000 0300 0000 0200 0000 0007 1f1c 0010
> 003f 7e40 007a 0100 7e40 007a 0000 0007
> 0003 0078 0078 0078 0078 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0010 0000 0020 4004 4000 0000 0004 4000
> 101f 0000 0000 0000 0000 2000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0082 001b 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000

Thanks.  I'll use that data to update/validate future versions of hdparm.
At UDMA66, it *should* be capable of the 40MByte/sec realm of readback perf,
assuming the card itself is really that fast.

I don't know too much about the specifics, though, but perhaps the
card is only capable of full speed in PIO6, which requires special cabling
and is currently unsupported in libata (?).

Another factor, is that hdparm performs discrete, non-overlapping,
reads of 1MByte chunks for its timing test.  Some drives cannot achieve
full performance with such (relatively) large gaps between IO's.

Also, just for fun, you could try "hdparm --direct -t /dev/sdb"

Cheers
