Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbXEaWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbXEaWk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXEaWkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:40:21 -0400
Received: from rtr.ca ([64.26.128.89]:4762 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbXEaWkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:40:19 -0400
Message-ID: <465F4ED0.10508@rtr.ca>
Date: Thu, 31 May 2007 18:40:16 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca>	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>	 <465F360D.6020603@rtr.ca> <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com>
In-Reply-To: <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> On 31/05/07, Mark Lord <liml@rtr.ca> wrote:
>> Daniel J Blueman wrote:
...
>> I don't know too much about the specifics, though, but perhaps the
>> card is only capable of full speed in PIO6, which requires special 
>> cabling
>> and is currently unsupported in libata (?).
> 
> Seems less likely, as the Extreme IV reader (and another) supports
> UDMA mode 4; in PIO mode 6, they apparently top out at 17MB/s [2],
> which seems reasonable.

That's pio4 (16.6666MBytes/sec).
pio6 should have the same cycle time as udma4.

>> Another factor, is that hdparm performs discrete, non-overlapping,
>> reads of 1MByte chunks for its timing test.  Some drives cannot achieve
>> full performance with such (relatively) large gaps between IO's.
> 
> 100MB transfers still achieve 32MB/s:

But internally libata is probably breaking those up into 64KB transfers,
with gaps between requests.  The best it could do would be 128KB transfers.
To maximize throughput, some kind of host-queuing would be needed,
or just have the driver sit in a tight loop, starting the next I/O
immediately when the previous one finishes.  Linux isn't that quick (yet).

Cheers
