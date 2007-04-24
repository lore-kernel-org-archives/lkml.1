Return-Path: <linux-kernel-owner+w=401wt.eu-S1161602AbXDXGhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161602AbXDXGhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161667AbXDXGhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:37:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161602AbXDXGhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:37:50 -0400
Date: Tue, 24 Apr 2007 08:36:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424063633.GA17257@elte.hu>
References: <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <462D7D8F.7000401@bigpond.net.au> <1177390323.3244.16.camel@laptopd505.fenrus.org> <462DA1E8.9080201@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462DA1E8.9080201@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> > The cases are fundamentally different in behavior, because in the 
> > first case, X hardly consumes the time it would get in any scheme, 
> > while in the second case X really is CPU bound and will happily 
> > consume any CPU time it can get.
> 
> Which still doesn't justify an elaborate "points" sharing scheme. 
> Whichever way you look at that that's just another way of giving X 
> more CPU bandwidth and there are simpler ways to give X more CPU if it 
> needs it.  However, I think there's something seriously wrong if it 
> needs the -19 nice that I've heard mentioned.

Gene has done some testing under CFS with X reniced to +10 and the 
desktop still worked smoothly for him. So CFS does not 'need' a reniced 
X. There are simply advantages to negative nice levels: for example 
screen refreshes are smoother on any scheduler i tried. BUT, there is a 
caveat: on non-CFS schedulers i tried X is much more prone to get into 
'overscheduling' scenarios that visibly hurt X's performance, while on 
CFS there's a max of 1000-1500 context switches a second at nice -10. 
(which, considering the cost of a context switch is well under 1% 
overhead.)

So, my point is, the nice level of X for desktop users should not be set 
lower than a low limit suggested by that particular scheduler's author. 
That limit is scheduler-specific. Con i think recommends a nice level of 
-1 for X when using SD [Con, can you confirm?], while my tests show that 
if you want you can go as low as -10 under CFS, without any bad 
side-effects. (-19 was a bit too much)

> [...]  You might as well just run it as a real time process.

hm, that would be a bad idea under any scheduler (including CFS), 
because real time processes can starve other processes indefinitely.

	Ingo
