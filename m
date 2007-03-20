Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXCTOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXCTOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCTOnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:43:53 -0400
Received: from mail.tmr.com ([64.65.253.246]:44587 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXCTOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:43:51 -0400
Message-ID: <45FFF35C.20003@tmr.com>
Date: Tue, 20 Mar 2007 10:44:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: jg@laptop.org
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>, linux-pm@lists.osdl.org,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       linux-usb-devel@lists.sourceforge.net,
       Jeff Chua <jeff.chua.linux@gmail.com>, Meelis Roos <mroos@linux.ee>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas.mey@web.de>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [2/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>	 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>	 <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>	 <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu>	 <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>	 <20070309111957.GA3928@elf.ucw.cz>  <20070318160707.GC12673@elte.hu>	 <1174236045.6832.9.camel@localhost>  <45FEF395.9050409@tmr.com> <1174342101.6832.173.camel@localhost>
In-Reply-To: <1174342101.6832.173.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Gettys wrote:
> On Mon, 2007-03-19 at 16:33 -0400, Bill Davidsen wrote:
>
>   
>> What you say sounds good, assuming that the cost of a sleep is less than 
>> the cost of the busy wait. But this may be hardware, the waits may be 
>> very small and frequent, and if it's hitting a small hardware window 
>> like retrace, delays in response will cause the time period to be missed 
>> completely. This probably less critical with very smart cards, many of 
>> us don't run them.
>>     
>
> Actually, various strategies involving short busy waiting, or looking at
> DMA address registers before sleeping were commonplace.  But a
> syscall/sleep/wakeup is/was pretty fast.  If you have an operation
> blitting the screen (e.g. scrolling), it takes a bit of time for the GPU
> to execute the command.  I see this right now on OLPC, where a wonderful
> music application needs to scroll (most of) the screen left),
> periodically, and we're losing samples sometimes at those operation.
>   
None of that conflicts with what I said, but what works on an LCD may 
not be appropriate for a CRT. With even moderate 1024x768@70 timing the 
horizontal retrace happens ~50k/sec, and that's not an appropriate 
syscall rate. I'm just pointing out that some things a video interface 
does with simple hardware involve lots of very small windows. Don't read 
that as "don't do it," just "be careful HOW you do it."
> Remember also, that being nice to everyone else by sleeping, there are
> more cycles to go around, and the scheduler can nicely boost the X
> server's priority as it will for "interactive" processes that are being
> cooperative.
I'm going to cautiously guess that the problem might be not "how much" 
but "how soon." That is, latency might be more important than giving the 
server a lot of CPU.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

