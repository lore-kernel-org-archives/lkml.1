Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZLSBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZLSBJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 20:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZLSBJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 20:09:13 -0500
Received: from home.kolivas.org ([59.167.196.135]:35171 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZLSBJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 20:09:12 -0500
From: Con Kolivas <kernel@kolivas.org>
To: "Jason Garrett-Glaser" <darkshikari@gmail.com>
Subject: Re: x264 benchmarks BFS vs CFS
Date: Sat, 19 Dec 2009 12:08:57 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.32-ck1; KDE/4.3.2; x86_64; ; )
Cc: Kasper Sandberg <lkml@metanurb.dk>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1261042383.14314.0.camel@localhost> <20091218052344.GD41 <28f2fcbc0912180305p47468508ybcb2f60cacb66c35@mail.gmail.com>
In-Reply-To: <28f2fcbc0912180305p47468508ybcb2f60cacb66c35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912191208.57907.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 22:05:34 Jason Garrett-Glaser wrote:
> On Fri, Dec 18, 2009 at 2:57 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > On Fri, 2009-12-18 at 08:30 +0100, Mike Galbraith wrote:
> >> On Fri, 2009-12-18 at 06:23 +0100, Ingo Molnar wrote:
> >> > Having said that, we generally try to make things perform well without
> >> > apps having to switch themselves to SCHED_BATCH. Mike, do you think we
> >> > can make x264 perform as well (or nearly as well) under SCHED_OTHER as
> >> > under SCHED_BATCH?
> >>
> >> It's not bad as is, except for ultrafast mode.  START_DEBIT is the
> >> biggest problem there.  I don't think SCHED_OTHER will ever match
> >> SCHED_BATCH for this load, though I must say I haven't full-spectrum
> >> tested.  This load really wants RR scheduling, and wakeup preemption
> >> necessarily perturbs run order.
> >>
> >> I'll probably piddle with it some more, it's an interesting load.
> >
> > Yes, i must say, very interresting, its very complicated and... oh wait,
> > its just encoding a movie!
> 
> Your trolling is becoming a bit over-the-top at this point.  You
> should also considering replying to multiple people in one email as
> opposed to spamming a whole bunch in sequence.
> 
> Perhaps as the lead x264 developer I'm qualified to say that it
> certainly is a very complicated load due to the strict ordering
> requirements of the threading model--and that you should tone down the
> whining just a tad and perhaps read a bit more about how BFS and CFS
> work before complaining about them.

Your workload is interesting because it is a well written real world 
application with a solid threading model written in a cross platform portable 
way.  Your code is valuable as a measure for precisely this reason, and 
there's a trap in trying to program in a way that "the scheduler might like". 
That's presumably what Kasper is trying to point out, albeit in a much blunter 
fashion.

The only workloads I'm remotely interested in are real world workloads 
involving real applications like yours, software compilation, video playback, 
audio playback, gaming, apache page serving, mysql performance and so on that 
people in the real world use on real hardware all day every day. These are, of 
course, measurable even above and beyond the elusive and impossible to measure 
and quantify interactivity and responsiveness.

I couldn't care less about some artificial benchmark involving LTP, timing 
mplayer playing in the presence of 100,000 pipes, volanomark which is just a 
sched_yield benchmark, dbench and hackbench which even their original 
programmers don't like them being used as a meaningful measure, and so on, and 
normal users should also not care about the values returned by these artificial 
benchmarks when they bear no resemblance to their real world performance cases 
as above. 

I have zero interest in adding any "tweaks" to BFS to perform well in X 
benchmark, for there be a path where dragons lie. I've always maintained that, 
and still stick to it, that the more tweaks you add for corner cases, the more 
corner cases you introduce yourself. BFS will remain for a targeted audience 
and I care not to appeal to any artificial benchmarketing obsessed population 
that drives mainline, since I don't -have- to. Mainline can do what it wants, 
and hopefully uses BFS as a yardstick for comparison when appropriate.

Regards,
-- 
-ck
