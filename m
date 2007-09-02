Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXIBCYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXIBCYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933438AbXIBCXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:23:55 -0400
Received: from mail.tmr.com ([64.65.253.246]:38801 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbXIBCXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:23:54 -0400
Message-ID: <46DA1DBF.7090509@tmr.com>
Date: Sat, 01 Sep 2007 22:19:43 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu> <Pine.LNX.4.64.0709010206400.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0709010206400.1817@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> Hi,
> 
> On Fri, 31 Aug 2007, Ingo Molnar wrote:
> 
> Maybe I should explain for everyone else (especially after seeing some of 
> the comments on kerneltrap), why I reacted somewhat irritated on what 
> looks like such an innocent mail.
> The problem is without the necessary background one can't know how wrong 
> such statements as this are, the level of confidence is amazing though:
> 
>> Peter's work fully solves the rounding corner-cases you described as:
> 
> I'd expect Ingo to know better, but the more he refuses to answer my 
> questions, the more I doubt it, at least than it comes to the math part.
> 
The "math part" is important if you're doing a thesis defense, but 
demonstrating better behavior under some realistic load would probably 
be a better starting point. Maybe Ingo missed something in your math, 
and maybe he just didn't find a benefit.

The ck and sd schedulers developed over a long time of public use and 
redefinition of goals. The cfs developed faster, but still had months of 
testing and the benefit of rt experience. Your scheduler is more of a 
virgin birth, no slow public discussion before, no time yet for people 
to run it under real loads, you're seeing first impressions.

You dropped this on the world two days before a major US holiday, at the 
end of the summer when those of us not on vacation may be covering for 
those who are, did you expect Ingo to drop his regular work to look at 
your stuff? And do you think there are many people who can look at your 
math, and look at your code, and then have any clue how well it works in 
practice? I bet there aren't ten people in the world who would even 
claim to do that, and half of them are kidding themselves.

So give people a few weeks to see if the rounding errors you eliminated 
mean anything in practice. Faster context is nice, but it's not 
something most people count as their major problem. I did a *lot* of cfs 
vs. sd testing, not just all the glitch1 tests I posted here, lots of 
stuff I just send to Ingo, and lots of tests like IPCbench and NNTP 
server loading showed nothing. (That's good, it means cfs isn't worse 
than the old scheduler for those loads.) I played with the tuning, I 
even diddled the code a bit, without finding meaningful improvement, so 
your possibly better math may not change the overall behavior much.

I will wait until I post actual test results before I say any more.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
