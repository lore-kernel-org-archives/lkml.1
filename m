Return-Path: <linux-kernel-owner+w=401wt.eu-S1761116AbXH1Tkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116AbXH1Tkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbXH1Tkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:40:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2320 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXH1Tkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:40:31 -0400
Date: Tue, 28 Aug 2007 21:19:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Xavier Bestel <xavier.bestel@free.fr>, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070828191924.GT6002@1wt.eu>
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <1188287015.1131.232.camel@frg-rhel40-em64t-04> <20070828080218.GA12247@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828080218.GA12247@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 10:02:18AM +0200, Ingo Molnar wrote:
> 
> * Xavier Bestel <xavier.bestel@free.fr> wrote:
> 
> > Are you sure they are stalled ? What you may have is simple gears 
> > running at a multiple of your screen refresh rate, so they only appear 
> > stalled.
> > 
> > Plus, as said Linus, you're not really testing the kernel scheduler. 
> > gears is really bad benchmark, it should die.
> 
> i like glxgears as long as it runs on _real_ 3D hardware, because there 
> it has minimal interaction with X and so it's an excellent visual test 
> about consistency of scheduling. You can immediately see (literally) 
> scheduling hickups down to a millisecond range (!). In this sense, if 
> done and interpreted carefully, glxgears gives more feedback than many 
> audio tests. (audio latency problems are audible, but on most sound hw 
> it takes quite a bit of latency to produce an xrun.) So basically 
> glxgears is the "early warning system" that tells us about the potential 
> for xruns earlier than an xrun would happen for real.
> 
> [ of course you can also run all the other tools to get numeric results,
>   but glxgears is nice in that it gives immediate visual feedback. ]

Al could also test ocbench, which brings visual feedback without harnessing
the X server :  http://linux.1wt.eu/sched/

I packaged it exactly for this problem and it has already helped. It uses
X after each loop, so if you run it with large run time, X is nearly not
sollicitated. 

Willy

