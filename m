Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZLSU6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZLSU6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 15:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZLSU6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 15:58:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:37347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753449AbZLSU6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 15:58:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9gfdtgVW9eeEQ0o8IF+01Jc//8C2PbqORFhsnvi
	8Uz144SLxaZkt3
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Con Kolivas <kernel@kolivas.org>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261244163.14314.62.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
	 <20091218052344.GD41 <28f2fcbc0912180305p47468508ybcb2f60cacb66c35@mail.gmail.com>
	 <200912191208.57907.kernel@kolivas.org>
	 <1261195412.8240.153.camel@marge.simson.net>
	 <1261244163.14314.62.camel@localhost>
Content-Type: text/plain
Date: Sat, 19 Dec 2009 21:57:59 +0100
Message-Id: <1261256279.28300.182.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-19 at 18:36 +0100, Kasper Sandberg wrote:
> On Sat, 2009-12-19 at 05:03 +0100, Mike Galbraith wrote:
> > On Sat, 2009-12-19 at 12:08 +1100, Con Kolivas wrote:

> > > Your workload is interesting because it is a well written real world 
> > > application with a solid threading model written in a cross platform portable 
> > > way.  Your code is valuable as a measure for precisely this reason, and 
> > > there's a trap in trying to program in a way that "the scheduler might like". 
> > > That's presumably what Kasper is trying to point out, albeit in a much blunter 
> > > fashion.
> > 
> > If using a different kernel facility gives better results, go for what
> > works best.  Programmers have been doing that since day one.  I doubt
> > you'd call it a trap to trade a pipe for a socketpair if one produced
> > better results than the other.
> 
> Ofcourse in this case that is what performs best one a single
> scheduler...

I have no idea what you're talking about here.
 
> > Mind you, we should be able to better service the load with plain
> > SCHED_OTHER, no argument there.
> Great, so when you said "i dont think it will get better"(or words to
> that effect), that didnt mean anything?

Or here.

Look.  BFS handles this load well, a little better than CFS in fact.  I
don't have a problem with that, but you seem to think it's a big hairy
deal for some strange reason.
 
> > > The only workloads I'm remotely interested in are real world workloads 
> > > involving real applications like yours, software compilation, video playback, 
> > > audio playback, gaming, apache page serving, mysql performance and so on that 
> > > people in the real world use on real hardware all day every day. These are, of 
> > > course, measurable even above and beyond the elusive and impossible to measure 
> > > and quantify interactivity and responsiveness.
> > > 
> > > I couldn't care less about some artificial benchmark involving LTP, timing 
> > > mplayer playing in the presence of 100,000 pipes, volanomark which is just a 
> > > sched_yield benchmark, dbench and hackbench which even their original 
> > > programmers don't like them being used as a meaningful measure, and so on, and 
> > > normal users should also not care about the values returned by these artificial 
> > > benchmarks when they bear no resemblance to their real world performance cases 
> > > as above.
> > 
> > I find all programs interesting and valid in their own right, whether
> > they be a benchmark or not, though I agree that vmark and hackbench are
> > a bit over the top.
> 
> Yes.. its interresting to SEE, whether its relevant and something to
> care about is entirely different.
> 
> Yes, its very interresting that something craps out, now, this thing is
> _NEVER_ going to occur in real life, and if it happens to do by some
> magical christmas fluke, then that is fortunately only ONE time you're
> seeing that problem, and as such, its irellevant, and certainly doesnt
> merit workarounds which makes other very common stuff perform
> significantly worse.

Haven't you noticed yet that nobody but you and Con has suggested any
course of action whatsoever?  That it is you two who both mention then
condemn workarounds and load specific tweaks all in the same breath with
not one word having come from any other source?

> > > I have zero interest in adding any "tweaks" to BFS to perform well in X 
> > > benchmark, for there be a path where dragons lie. I've always maintained that, 
> > > and still stick to it, that the more tweaks you add for corner cases, the more 
> > > corner cases you introduce yourself. BFS will remain for a targeted audience 
> > > and I care not to appeal to any artificial benchmarketing obsessed population 
> > > that drives mainline, since I don't -have- to. Mainline can do what it wants, 
> > > and hopefully uses BFS as a yardstick for comparison when appropriate.
> > 
> > Interesting rant.  IMO, benchmarks are all merely programs that do some
> > work and quantify.  Whether you like what they measure or not, whether
> > they emit flattering numbers or not, they can all tell you something if
> > you're willing to listen.
> 
> I suspect con is very interrested in listening, however, as he have
> stated, if fixing some corner case in an artificial load requires
> damaging a realworld load, that is an unacceptable modification to him,
> and I agree. I ask you this, would you rather some artificial benchmark
> ran better, but your own everyday applications ran slower as a result?
> It seems to me you do, which i can not understand.

You can hand-wave all you want, I really do not care, but kindly keep
your words out of my mouth.
 
> > fairness bug in 31.bfs304?
> > 
> > prep:
> > set CPU governor to performance first, as in all benchmarking.
> > taskset -c 0 pert (100% CPU hog TSC perturbation measurement proggy)
> > taskset -p 0x1 `pidof Xorg`
> > 
> > perf stat taskset -c 0 konsole -e exit
> > 31.bfs304    2.073724549  seconds time elapsed
> > tip++        0.989323860  seconds time elapsed
> > 
> > note: amarok pins itself to CPU0, and is set up to use mysql database.
> > 
> > prep: cache warmup run.
> > perf stat amarokapp (quit after 12000 song mp3 collection is loaded)
> > 
> > 31.bfs304    136.418518486  seconds time elapsed
> > tip++         19.439268066  seconds time elapsed
> > 
> > prep: restart amarok, wait for load, start playing
> > 
> > perf stat taskset -c 0 mplayer -nosound 3DMark2000.mkv (exact 6 minute movie)
> > 31.bfs304    432.712500554  seconds time elapsed
> > tip++        363.622519583  seconds time elapsed
> > 
> 
> But presumably the cpu hog is running at same priority, and if this is
> done on a UP system, that will obviously mean fairness will make stuff
> slower..
> 
> Try this on a dualcore or quadcore system, or ofcourse just set the
> niceness accordingly...

Amazing that you can actually say that with a straight face.

Look.  You can hand-wave all results into irrelevance, I do not care.
You've both made it perfectly clear that test results are not welcome.

	-Mike

