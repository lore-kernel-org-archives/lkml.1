Return-Path: <linux-kernel-owner+w=401wt.eu-S1031207AbXDSLes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031207AbXDSLes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993230AbXDSLes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:34:48 -0400
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:47936 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031207AbXDSLer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:34:47 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: Announce - Staircase Deadline cpu scheduler v0.42
Date: Thu, 19 Apr 2007 21:53:48 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200704190959.06432.kernel@kolivas.org> <200704191940.04715.kernel@kolivas.org> <20070419102245.GD14885@wotan.suse.de>
In-Reply-To: <20070419102245.GD14885@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192153.48530.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 20:22, Nick Piggin wrote:
> On Thu, Apr 19, 2007 at 07:40:04PM +1000, Con Kolivas wrote:
> > On Thursday 19 April 2007 13:22, Nick Piggin wrote:
> > > On Thu, Apr 19, 2007 at 12:12:14PM +1000, Con Kolivas wrote:
> > > > Version 0.42
> > > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.42.p
> > > >atch
> > >
> > > OK, I run some tests later today...
> >
> > Thank you very much.
>
> lmbench numbers are roughly comparable to mainline (lmbench seems to be
> a bit erratic, but there isn't the obvious drop that cfs has).

Great.

Thanks again for doing these.

> Didn't worry about hackbench ;)
>
> kbuild:
> 2.6.21-rc7
> 508.87user 32.47system 2:17.82elapsed 392%CPU
> 509.05user 32.25system 2:17.84elapsed 392%CPU
> 508.75user 32.26system 2:17.83elapsed 392%CPU
> 508.63user 32.17system 2:17.88elapsed 392%CPU
> 509.01user 32.26system 2:17.90elapsed 392%CPU
> 509.08user 32.20system 2:17.95elapsed 392%CPU
>
> 2.6.21-rc7-sd42
> 512.78user 31.99system 2:18.41elapsed 393%CPU
> 512.55user 31.90system 2:18.57elapsed 392%CPU
> 513.05user 31.78system 2:18.48elapsed 393%CPU
> 512.46user 32.06system 2:18.63elapsed 392%CPU
> 512.78user 31.81system 2:18.49elapsed 393%CPU
> 512.41user 32.08system 2:18.70elapsed 392%CPU
>
> sd42 is doing about 745 context switches per second here, and perfomance is
> slightly below mainline. But it isn't doing badly.

Not bad. It's always impossible to know where the sweet spot will lie with 
these things. Basically the higher the better.... for this one thing of 
course.

> 507.87user 32.53system 2:17.50elapsed 392%CPU
> 508.47user 32.40system 2:17.56elapsed 393%CPU
> 508.59user 32.27system 2:17.53elapsed 393%CPU
>
> A few runs with rr_interval at 100 show that ctxsw numbers drop to 587, and
> performance is up to slightly above mainline.

Well they're nice numbers indeed. I don't even need to leave the maximum at 
100ms but I seriously doubt we'd see much improvement beyond there... I'm 
sure some renderfarm might enjoy values of 1 second though (like my -ck 
patchet already offers in compute mode for old fashioned staircase cpu 
sched).

> With the results I've got so far with all scedulers (actually I didn't try
> nicksched with a small timeslice, but I'm sure it would give the expected
> result)... I'd say 5ms might be too small a timeslice. Even 15ms will hurt
> some people I think.

On 4x (that's what your hardware was IIRC) SD would be setting it to 15ms. 
Mainline would be timeslice granularity setting 4x to about 40ms. Pulling a 
number out of my rear end generator I'd say 20ms for SD should make it close 
enough without sacrificing latency too much more.

> Although we could arguably tolerate this kind of regression, my box only
> has 1MB caches, and kbuild is naturally context switching at over 500 per
> second anyway. On something with bigger caches and less context switchy /
> more cache sensitive workloads, the regression could be quite a bit worse.
>
> (not directed at anyone in particular, but food for thought)

Heck if I'm going to keep offering SD as an alternative for comparison I may 
as well use the food you've offered me. I guess I better work on a v0.43 with 
some more of these very easy to do tweaks then. Thanks!

-- 
-ck
