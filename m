Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYCUPDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYCUPDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYCUPDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:03:35 -0400
Received: from rtr.ca ([76.10.145.34]:4054 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYCUPDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:03:35 -0400
Message-ID: <47E3CE44.4000000@rtr.ca>
Date: Fri, 21 Mar 2008 11:03:32 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>	<20080316140118.891732DC044@tippex.mynet.homeunix.org>	<alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>	<200803161907.04581.bzolnier@gmail.com>	<alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>	<20080316185602.79064f7c@core>	<alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org> <20080316203109.50e8c526@core>
In-Reply-To: <20080316203109.50e8c526@core>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 16 Mar 2008 12:39:43 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Sun, 16 Mar 2008, Alan Cox wrote:
>>> No it doesn't. DRQ simply means "drive has more data for the controller
>>> if you want it". Interrupts are controlled via IEN and the interrupt line.
>> A _lot_ of chips require you to clear the DRQ by taking the data they 
>> have.
> 
> Almost none and mostly very old ones. I'm not saying we shouldn't do it
> (except where it hangs the hardware - hence the FIFO flag) but for the
> traces presented and hardware reported it appears to be a bit of a red
> herring.
> 
>>> If the drive wants to give us data and we end the transaction that is
>>> fine. In practice a tiny few devices crap themselves if we don't.
>> More than a few tiny devices from what I remember. It tends to be the 
>> other way around - most devices do *not* want to get new commands until 
>> you've finished the previous one by draining the queues.
> 
> Not in my experience having maintained a lot of ATA drivers for a very
> long time. In fact the changes for draining the DRQ went into libata only
> very recently because it was only when we had a distro sized userbase
> with PATA devices that it became apparent that a few corner case problems
> remained.
..

Err.. I have a fairly modern PATA drive (160GB seagate 2.5")
that gets pissed if we leave DRQ hanging.  So it's not just
something for old/obsolete drives.

Or maybe it's the also-modern-ish ICH chipset that gets stuck.  Whatever.

-ml
