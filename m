Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXDCGBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXDCGBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDCGBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:01:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:46576 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751647AbXDCGBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:01:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gZDYywT1gYIC0JSmPbXXgzzfCA05/j3RNvVsVJu
	31ip3TVNAfd6ia
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <1175578270.6342.12.camel@Homer.simpson.net>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
	 <1175578270.6342.12.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:00:55 +0200
Message-Id: <1175580055.6751.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 07:31 +0200, Mike Galbraith wrote:
> On Tue, 2007-04-03 at 12:37 +1000, Con Kolivas wrote:
> > On Thursday 29 March 2007 15:50, Mike Galbraith wrote:
> > > On Thu, 2007-03-29 at 09:44 +1000, Con Kolivas wrote:
> > > + * This contains a bitmap for each dynamic priority level with empty slots
> > > + * for the valid priorities each different nice level can have. It allows
> > > + * us to stagger the slots where differing priorities run in a way that
> > > + * keeps latency differences between different nice levels at a minimum.
> > > + * ie, where 0 means a slot for that priority, priority running from left
> > > to + * right:
> > > + * nice -20 0000000000000000000000000000000000000000
> > > + * nice -10 1001000100100010001001000100010010001000
> > > + * nice   0 0101010101010101010101010101010101010101
> > > + * nice   5 1101011010110101101011010110101101011011
> > > + * nice  10 0110111011011101110110111011101101110111
> > > + * nice  15 0111110111111011111101111101111110111111
> > > + * nice  19 1111111111111111111011111111111111111111
> > 
> > Try two instances of chew.c at _differing_ nice levels on one cpu on mainline, 
> > and then SD. This is why you can't renice X on mainline.
> 
> How about something more challenging instead :)
> 
> The numbers below are from my scheduler tree with massive_intr running
> at nice 0, and chew at nice 5.  Below these numbers are 100 lines from
> the exact center of chew's output.
> 
> (interactivity remains intact with this rather heavy load)

Here are the numbers for 2.6.21-rc5 with only the earlier mentioned
patch.  Chew's log is only 20% as long as that from my other tree, and
interactivity suffers badly while running this exploit, but as you can
see, chew isn't dying of boredom.

	-Mike

root@Homer: ./massive_intr 30 180
006701  00001509
006693  00001571
006707  00001072
006690  00001582
006691  00001547
006692  00001336
006695  00001759
006710  00001766
006699  00001531
006688  00001405
006709  00001907
006703  00001572
006705  00001501
006697  00001617
006686  00001344
006713  00001922
006714  00001885
006704  00001491
006694  00001482
006689  00001395
006711  00001176
006715  00001471
006708  00001527
006687  00001200
006706  00001451
006698  00001246
006702  00001495
006696  00001421
006712  00001414
006700  00001047


pid 6683, prio   5, out for   46 ms, ran for    0 ms, load   0%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for    6 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for 3527 ms, ran for   69 ms, load   1%
pid 6683, prio   5, out for   52 ms, ran for    1 ms, load   2%
pid 6683, prio   5, out for   15 ms, ran for    1 ms, load   6%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  15%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  13%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for 3925 ms, ran for   56 ms, load   1%
pid 6683, prio   5, out for   30 ms, ran for    1 ms, load   3%
pid 6683, prio   5, out for   24 ms, ran for    1 ms, load   6%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  11%
pid 6683, prio   5, out for    5 ms, ran for    0 ms, load  16%
pid 6683, prio   5, out for  376 ms, ran for   54 ms, load  12%
pid 6683, prio   5, out for 3320 ms, ran for    9 ms, load   0%
pid 6683, prio   5, out for 3895 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  26%
pid 6683, prio   5, out for 3364 ms, ran for   68 ms, load   2%
pid 6683, prio   5, out for 4676 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for 3726 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for 3223 ms, ran for   74 ms, load   2%
pid 6683, prio   5, out for    7 ms, ran for    0 ms, load   4%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  13%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  20%
pid 6683, prio   5, out for    9 ms, ran for    1 ms, load  12%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for 3562 ms, ran for   67 ms, load   1%
pid 6683, prio   5, out for 4372 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for 6831 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for  756 ms, ran for   74 ms, load   9%
pid 6683, prio   5, out for   27 ms, ran for    0 ms, load   1%
pid 6683, prio   5, out for    4 ms, ran for    1 ms, load  20%
pid 6683, prio   5, out for 3619 ms, ran for   71 ms, load   1%
pid 6683, prio   5, out for    7 ms, ran for    0 ms, load  11%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  30%
pid 6683, prio   5, out for    7 ms, ran for   34 ms, load  82%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  30%
pid 6683, prio   5, out for 3182 ms, ran for   34 ms, load   1%
pid 6683, prio   5, out for 4559 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for 2937 ms, ran for   74 ms, load   2%
pid 6683, prio   5, out for   19 ms, ran for    1 ms, load   8%
pid 6683, prio   5, out for 3869 ms, ran for   72 ms, load   1%
pid 6683, prio   5, out for    5 ms, ran for    0 ms, load   3%
pid 6683, prio   5, out for 3375 ms, ran for   75 ms, load   2%
pid 6683, prio   5, out for 4300 ms, ran for   74 ms, load   1%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  31%
pid 6683, prio   5, out for 5949 ms, ran for   72 ms, load   1%
pid 6683, prio   5, out for 5314 ms, ran for   73 ms, load   1%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  14%
pid 6683, prio   5, out for    9 ms, ran for    1 ms, load  14%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  34%
pid 6683, prio   5, out for 4067 ms, ran for   70 ms, load   1%
pid 6683, prio   5, out for   16 ms, ran for    7 ms, load  32%
pid 6683, prio   5, out for 4149 ms, ran for   66 ms, load   1%
pid 6683, prio   5, out for    3 ms, ran for    1 ms, load  27%
pid 6683, prio   5, out for 2366 ms, ran for   72 ms, load   2%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for    7 ms, ran for    0 ms, load  10%
pid 6683, prio   5, out for 1459 ms, ran for   73 ms, load   4%
pid 6683, prio   5, out for 3121 ms, ran for   74 ms, load   2%
pid 6683, prio   5, out for 3070 ms, ran for   74 ms, load   2%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  11%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  12%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for 1303 ms, ran for   66 ms, load   4%
pid 6683, prio   5, out for   10 ms, ran for    1 ms, load  10%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  16%
pid 6683, prio   5, out for    5 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for 2350 ms, ran for   68 ms, load   2%
pid 6683, prio   5, out for    5 ms, ran for    0 ms, load  15%
pid 6683, prio   5, out for 3242 ms, ran for   75 ms, load   2%
pid 6683, prio   5, out for 2684 ms, ran for   74 ms, load   2%
pid 6683, prio   5, out for 4941 ms, ran for   75 ms, load   1%
pid 6683, prio   5, out for 1119 ms, ran for   74 ms, load   6%
pid 6683, prio   5, out for    8 ms, ran for    0 ms, load  10%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    5 ms, ran for    1 ms, load  17%
pid 6683, prio   5, out for 3701 ms, ran for   67 ms, load   1%
pid 6683, prio   5, out for    2 ms, ran for    1 ms, load  43%
pid 6683, prio   5, out for 3486 ms, ran for   72 ms, load   2%
pid 6683, prio   5, out for    8 ms, ran for    0 ms, load   5%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  20%
pid 6683, prio   5, out for    5 ms, ran for    1 ms, load  24%
pid 6683, prio   5, out for 5413 ms, ran for   69 ms, load   1%
pid 6683, prio   5, out for 2251 ms, ran for   74 ms, load   3%
pid 6683, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 6683, prio   5, out for    7 ms, ran for    1 ms, load  20%
pid 6683, prio   5, out for    5 ms, ran for    1 ms, load  20%


