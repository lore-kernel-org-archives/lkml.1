Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXERGex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXERGex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXERGeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:34:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44335 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXERGeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:34:46 -0400
Date: Fri, 18 May 2007 08:33:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: DervishD <lkml@dervishd.net>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: usb-storage nice value
In-Reply-To: <20070518061512.GA32730@DervishD>
Message-ID: <Pine.LNX.4.61.0705180829120.3231@yvahk01.tjqt.qr>
References: <20070517100308.GA14667@DervishD> <464CB2B3.50506@s5r6.in-berlin.de>
 <20070518061512.GA32730@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 08:15, DervishD wrote:

>Date: Fri, 18 May 2007 08:15:12 +0200
>From: DervishD <lkml@dervishd.net>
>To: Stefan Richter <stefanr@s5r6.in-berlin.de>
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: usb-storage nice value

Try ionice.

>> DervishD wrote:
>> >     I'm having problems when reading/writing to external USB harddisks:
>> > my *internal* harddisk stalls from time to time, so watching a movie
>> > while copying data is a PITA (well, if the movie is bad, the leaps help
>> > a bit...).
>> 
>> If the internal harddisk is source or target of these copy operations...
>
>    Not...
> 
>> ...
>> > is there any way of modifying the pdflush behaviour so
>> > large buffered writes are less "agressive" and doesn't block apps which
>> > are just reading?
>> 
>> ...then switching to another IO scheduler might perhaps help.
>> 
>> # cat /sys/block/hda/queue/scheduler
>> 
>> # echo deadline > /sys/block/hda/queue/scheduler
>

Or try echo 10 >/proc/sys/kernel/dirty_ratio

>    That's another thing I wanted to test, but I'm already using
>"deadline" scheduler. How about changing "read_ahead_kb" to a much
>higher value so there's plenty of data buffered? The problem seems to
>be, according to Alan Cox, that my VIA mobo fills completely the PCI bus
>when doing IO bursts, so I can take advantage of that "bug" and fill the
>bus when reading.
>
>    My only doubt is if it will affect performance negatively in other
>usage patterns (e.g. while writing CD's, since the hard disk will take
>the bus on each read operation, and will read more than the current 128
>kB).


	Jan
-- 
