Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbXH2Gna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbXH2Gna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 02:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbXH2GnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 02:43:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759982AbXH2GnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 02:43:18 -0400
Date: Wed, 29 Aug 2007 08:43:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Keith Packard <keith.packard@intel.com>
Subject: Re: CFS review
Message-ID: <20070829064303.GA32371@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708290719.24422.a1426z@gawab.com> <20070829045316.GA15064@elte.hu> <200708290858.32909.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708290858.32909.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> >  se.sleep_max             :          2194711437
> >  se.block_max             :                   0
> >  se.exec_max              :              977446
> >  se.wait_max              :             1912321
> >
> > the scheduler itself had a worst-case scheduling delay of 1.9
> > milliseconds for that glxgears instance (which is perfectly good - in
> > fact - excellent interactivity) - but the task had a maximum sleep time
> > of 2.19 seconds. So the 'glitch' was not caused by the scheduler.
> 
> 2.19sec is probably the time you need to lay them out side by side. 
> [...]

nope, i cleared the stats after i laid the glxgears out, via:

   for N in /proc/*/sched; do echo 0 > $N; done

and i did the strace (which showed a 1+ seconds latency) while the 
glxgears was not manipulated in any way.

> [...]  You see, gears sleeps when it is covered by another window, 
> [...]

none of the gear windows in my test were overlaid...

> [...] so once you lay them out it starts running, and that's when they 
> start to stutter for about 10sec.  After that they should run 
> smoothly, because they used up all the sleep bonus.

that's plain wrong - at least in the test i've reproduced. In any case, 
if that were the case then that would be visible in the stats. So please 
send me your cfs-debug-info.sh output captured while the test is running 
(with a CONFIG_SCHEDSTATS=y and CONFIG_SCHED_DEBUG=y kernel) - you can 
download it from:

   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

for best data, execute this before running it:

   for N in /proc/*/sched; do echo 0 > $N; done

> If you like, I can send you my straces, but they are kind of big 
> though, and you need to strace each gear, as stracing itself changes 
> the workload balance.

sure, send them along or upload them somewhere - but more importantly, 
please send the cfs-debug-info.sh output.

	Ingo
