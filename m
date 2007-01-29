Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXA2PSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXA2PSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXA2PSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:18:36 -0500
Received: from mail.tmr.com ([64.65.253.246]:55958 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXA2PSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:18:35 -0500
Message-ID: <45BE1018.4010402@tmr.com>
Date: Mon, 29 Jan 2007 10:17:44 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
References: <478459.76045.qm@web52503.mail.yahoo.com> <45BCDFAE.5090602@tmr.com> <45BCFE33.3000600@tls.msk.ru>
In-Reply-To: <45BCFE33.3000600@tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Bill Davidsen wrote:
> []
>> RAID-10 is not the same as RAID 0+1.
> 
> It is.  Yes, there's separate module for raid10, but what it - basically -
> does is the same as raid0 module over two raid1 modules will do.  It's
> just a bit more efficient (less levels, more room for optimisations),
> easy to use (you'll have single array instead of at least 3), and a bit
> more flexible;  at the same way it's less widely tested...
> 
> But the end result is basically the same for both ways.
> 
For values of "same" which exclude consideration of the disk layout, 
throughput, overhead, system administration, and use of spares. Those 
are different. But both methods do write multiple copies of ones and 
zeros to storage media.

Neil brown, 08/23/2005:
- A raid10 can consist of an odd number of drives (if you have a
    cabinet with, say, 8 slots, you can have 1 hot spare, and 7 drives
    in a raid10.  You cannot do that with LVM (or raid0) over raid1).
  - raid10 has a layout ('far') which theoretically can provide
    sequential read throughput that scales by number of drives, rather
    than number of raid1 pairs.  I say 'theoretically' because I think
    there are still issues with the read-balancing code that make this
    hard to get in practice (though increasing the read-ahead seems to
    help).


After about 40 configurations tested, I can say that write performance 
is better as well, for any given stripe cache size up to 4x stripe size. 
I was looking at something else, but the numbers happen to be available.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
