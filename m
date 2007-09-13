Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXIMMsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXIMMsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXIMMru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:47:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52570 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031AbXIMMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:47:49 -0400
Date: Thu, 13 Sep 2007 14:47:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913124738.GA4450@elte.hu>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709121405130.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709121405130.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> The rest of the math is indeed different - it's simply missing. What 
> is there is IMO not really adequate. I guess you will see the 
> differences, once you test a bit more with different nice levels.

Roman, i disagree strongly. I did test with different nice levels. Here 
are some hard numbers: the CPU usage table of 40 busy loops started at 
once, all running at a different nice level, from nice -20 to nice +19:

 top - 12:25:07 up 19 min,  2 users,  load average: 40.00, 39.15, 28.35
 Tasks: 172 total,  41 running, 131 sleeping,   0 stopped,   0 zombie

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 2455 root       0 -20  1576  248  196 R   20  0.0   3:47.56 loop        
 2456 root       1 -19  1576  244  196 R   16  0.0   3:03.96 loop        
 2457 root       2 -18  1576  244  196 R   13  0.0   2:24.80 loop        
 2458 root       3 -17  1576  248  196 R   10  0.0   1:58.63 loop        
 2459 root       4 -16  1576  244  196 R    8  0.0   1:33.04 loop        
 2460 root       5 -15  1576  248  196 R    7  0.0   1:14.73 loop        
 2461 root       6 -14  1576  248  196 R    5  0.0   0:59.61 loop        
 2462 root       7 -13  1576  244  196 R    4  0.0   0:47.95 loop        
 2463 root       8 -12  1576  248  196 R    3  0.0   0:38.31 loop        
 2464 root       9 -11  1576  244  196 R    3  0.0   0:30.54 loop        
 2465 root      10 -10  1576  244  196 R    2  0.0   0:24.47 loop        
 2466 root      11  -9  1576  244  196 R    2  0.0   0:19.52 loop        
 2467 root      12  -8  1576  248  196 R    1  0.0   0:15.63 loop        
 2468 root      13  -7  1576  248  196 R    1  0.0   0:12.56 loop        
 2469 root      14  -6  1576  248  196 R    1  0.0   0:10.00 loop        
 2470 root      15  -5  1576  244  196 R    1  0.0   0:07.99 loop        
 2471 root      16  -4  1576  244  196 R    1  0.0   0:06.40 loop        
 2472 root      17  -3  1576  244  196 R    0  0.0   0:05.09 loop        
 2473 root      18  -2  1576  244  196 R    0  0.0   0:04.05 loop        
 2474 root      19  -1  1576  248  196 R    0  0.0   0:03.26 loop        
 2475 root      20   0  1576  244  196 R    0  0.0   0:02.61 loop        
 2476 root      21   1  1576  244  196 R    0  0.0   0:02.09 loop        
 2477 root      22   2  1576  244  196 R    0  0.0   0:01.67 loop        
 2478 root      23   3  1576  244  196 R    0  0.0   0:01.33 loop        
 2479 root      24   4  1576  248  196 R    0  0.0   0:01.07 loop        
 2480 root      25   5  1576  244  196 R    0  0.0   0:00.84 loop        
 2481 root      26   6  1576  248  196 R    0  0.0   0:00.68 loop        
 2482 root      27   7  1576  248  196 R    0  0.0   0:00.54 loop        
 2483 root      28   8  1576  248  196 R    0  0.0   0:00.43 loop        
 2484 root      29   9  1576  248  196 R    0  0.0   0:00.34 loop        
 2485 root      30  10  1576  244  196 R    0  0.0   0:00.27 loop        
 2486 root      31  11  1576  248  196 R    0  0.0   0:00.21 loop        
 2487 root      32  12  1576  244  196 R    0  0.0   0:00.17 loop        
 2488 root      33  13  1576  244  196 R    0  0.0   0:00.13 loop        
 2489 root      34  14  1576  244  196 R    0  0.0   0:00.10 loop        
 2490 root      35  15  1576  244  196 R    0  0.0   0:00.08 loop        
 2491 root      36  16  1576  248  196 R    0  0.0   0:00.06 loop        
 2493 root      38  18  1576  248  196 R    0  0.0   0:00.03 loop        
 2492 root      37  17  1576  244  196 R    0  0.0   0:00.04 loop        
 2494 root      39  19  1576  244  196 R    0  0.0   0:00.02 loop        

check a few select rows (the ratio of CPU time should be 1.25 at every 
step) and see that CPU time is distributed very exactly. (and the same 
is true for both -rc6 and -rc6-cfs-devel)

So even in this pretty extreme example (who on this planet runs 40 busy 
loops with each loop on exactly one separate nice level, creating a load 
average of 40.0 and expects perfect distribution after just a few 
minutes?) CFS still distributes CPU time perfectly.

When you first raised accuracy issues i have asked you to provide 
specific real-world examples showing any of the "problems" with nice 
levels you implied to repeatedly:

    http://lkml.org/lkml/2007/9/2/38

In the announcement of your "Really Fair Scheduler" patch you used the 
following very strong statement:

    " This model is far more accurate than CFS is [...]"

    http://lkml.org/lkml/2007/8/30/307

but when i stressed you for actual real-world proof of CFS misbehavior, 
you said:

    "[...] they have indeed little effect in the short term, [...] "

    http://lkml.org/lkml/2007/9/2/282

so how can CFS be "far less accurate" (paraphrased) while it has "little 
effect in the short term"?

so to repeat my question: my (and Peter's) claim is that there is no 
real-world significance of much of the complexity you added to avoid 
rounding effects. You do disagree with that, so our follow-up question 
is: what actual real-world significance does it have in your opinion? 
What is the worst-case effect? Do we even care? We have measured it 
every which way and it just does not matter. (but we could easily be 
wrong, so please be specific if you know about something that we 
overlooked.) Thanks,

	Ingo
