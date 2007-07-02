Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXGBOKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXGBOKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXGBOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:10:41 -0400
Received: from mail.tmr.com ([64.65.253.246]:48264 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbXGBOKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:10:40 -0400
Message-ID: <46890803.3020501@tmr.com>
Date: Mon, 02 Jul 2007 10:13:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v18
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
In-Reply-To: <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hello,
> 
> On 6/23/07, Ingo Molnar <mingo@elte.hu> wrote:
>> i'm pleased to announce release -v18 of the CFS scheduler patchset.
> 
>> As usual, any sort of feedback, bugreport, fix and suggestion is more
>> than welcome!
> 
> I have been running cfs-v18 for a couple of days now, and today I
> stumbled upon a rather strange problem. Consider the following short
> program:
> 
> while(1)
>        printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);
> 
> Running this in an xterm makes the xterm totally unresponsive. Ctrl-C
> takes about two seconds to terminate the program, during which the
> program will keep running. In fact, it seems that the longer it runs,
> the longer it takes to terminate (towards 5 seconds after running for
> a couple of minutes). This is rather surprising, as the rest of the
> system is quite responsive (even remarkably so). I think this is also
> in contrast with the expected behaviour, that Ctrl-C/program
> termination should be prioritized somehow.
> 
This sounds as though it might be related to the issues I see with my 
"glitch1" script, posted here a while ago. With cfs-v18 the effect of 
having multiple xterms scrolling is obvious, occasionally they behave as 
if they were "owed" more CPU and get paid back all at once. I've seen 
this effect to one degree or another since cfs-v13, which did NOT show 
the effect.

> Some other observations: X.Org seems to be running at about 75% CPU on
> CPU 1, the xterm at about 45% on CPU 0, and a.out at about 20% on CPU
> 0. (HT processor)
> 
> Killing with -2 or -9 from another terminal works immediately. Ctrl-Z
> takes the same time as Ctrl-C.
> 
I think this is because the shell to read the keypress is getting high 
latency, rather than the process taking a long time to react. I have 
been wrong before...

I read Ingo's reply to this, I'll gather the same information when the 
test machine is available later this morning and send it off to Ingo.

> Another thing to note is that simply looping with no output retains
> the expected responsiveness of the xterm. Printing i++ is somewhere
> halfway in between.
> 
See http://www.tmr.com/~public/source  (note the tilde) for glitch1.

> Is this behaviour expected or even intended? My main point is that
> Ctrl-C is a safety fallback which suddenly doesn't work as usual. I
> might even go so far as to call it a regression.
> 
> I'd also like to point out that Folding@Home seems to draw more CPU
> than it should. Or, at least, in top, it shows up as using 50% CPU
> even though other processes are demanding as much as they can get. The
> FAH program should be running with idle priority. I expect it to fall
> to near 0% when other programs are running at full speed, but it keeps
> trotting along. And I am pretty sure that this is not due to SMP/HT (I
> made sure to utilize both CPUs).
> 
> Lastly, I'd like to mention that I got BUGs (soft lockups) with -v8,
> though it has not been reproducible with -v18, so I suppose it must
> have been fixed already.
> 
> Otherwise, I am satisfied with the performance of CFS. Especially the
> desktop is noticably smoother. Thanks!
> 
> Kind regards,
> Vegard Nossum


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
