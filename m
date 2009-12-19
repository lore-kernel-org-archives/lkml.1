Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZLSRgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZLSRgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 12:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZLSRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 12:36:12 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:50813 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZLSRgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 12:36:10 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-c6-4b2d0f07369c
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261195412.8240.153.camel@marge.simson.net>
References: <1261042383.14314.0.camel@localhost>
	 <20091218052344.GD41 <28f2fcbc0912180305p47468508ybcb2f60cacb66c35@mail.gmail.com>
	 <200912191208.57907.kernel@kolivas.org>
	 <1261195412.8240.153.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 19 Dec 2009 18:36:03 +0100
Message-Id: <1261244163.14314.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARIa6uU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-19 at 05:03 +0100, Mike Galbraith wrote:
> On Sat, 2009-12-19 at 12:08 +1100, Con Kolivas wrote:
> > On Fri, 18 Dec 2009 22:05:34 Jason Garrett-Glaser wrote:
> > > On Fri, Dec 18, 2009 at 2:57 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > > > On Fri, 2009-12-18 at 08:30 +0100, Mike Galbraith wrote:
> > > >> On Fri, 2009-12-18 at 06:23 +0100, Ingo Molnar wrote:
> > > >> > Having said that, we generally try to make things perform well without
> > > >> > apps having to switch themselves to SCHED_BATCH. Mike, do you think we
> > > >> > can make x264 perform as well (or nearly as well) under SCHED_OTHER as
> > > >> > under SCHED_BATCH?
> > > >>
> > > >> It's not bad as is, except for ultrafast mode.  START_DEBIT is the
> > > >> biggest problem there.  I don't think SCHED_OTHER will ever match
> > > >> SCHED_BATCH for this load, though I must say I haven't full-spectrum
> > > >> tested.  This load really wants RR scheduling, and wakeup preemption
> > > >> necessarily perturbs run order.
> > > >>
> > > >> I'll probably piddle with it some more, it's an interesting load.
> > > >
> > > > Yes, i must say, very interresting, its very complicated and... oh wait,
> > > > its just encoding a movie!
> > > 
> > > Your trolling is becoming a bit over-the-top at this point.  You
> > > should also considering replying to multiple people in one email as
> > > opposed to spamming a whole bunch in sequence.
> > > 
> > > Perhaps as the lead x264 developer I'm qualified to say that it
> > > certainly is a very complicated load due to the strict ordering
> > > requirements of the threading model--and that you should tone down the
> > > whining just a tad and perhaps read a bit more about how BFS and CFS
> > > work before complaining about them.
> > 
> > Your workload is interesting because it is a well written real world 
> > application with a solid threading model written in a cross platform portable 
> > way.  Your code is valuable as a measure for precisely this reason, and 
> > there's a trap in trying to program in a way that "the scheduler might like". 
> > That's presumably what Kasper is trying to point out, albeit in a much blunter 
> > fashion.
> 
> If using a different kernel facility gives better results, go for what
> works best.  Programmers have been doing that since day one.  I doubt
> you'd call it a trap to trade a pipe for a socketpair if one produced
> better results than the other.

Ofcourse in this case that is what performs best one a single
scheduler...

> 
> Mind you, we should be able to better service the load with plain
> SCHED_OTHER, no argument there.
Great, so when you said "i dont think it will get better"(or words to
that effect), that didnt mean anything?
> 
> > The only workloads I'm remotely interested in are real world workloads 
> > involving real applications like yours, software compilation, video playback, 
> > audio playback, gaming, apache page serving, mysql performance and so on that 
> > people in the real world use on real hardware all day every day. These are, of 
> > course, measurable even above and beyond the elusive and impossible to measure 
> > and quantify interactivity and responsiveness.
> > 
> > I couldn't care less about some artificial benchmark involving LTP, timing 
> > mplayer playing in the presence of 100,000 pipes, volanomark which is just a 
> > sched_yield benchmark, dbench and hackbench which even their original 
> > programmers don't like them being used as a meaningful measure, and so on, and 
> > normal users should also not care about the values returned by these artificial 
> > benchmarks when they bear no resemblance to their real world performance cases 
> > as above.
> 
> I find all programs interesting and valid in their own right, whether
> they be a benchmark or not, though I agree that vmark and hackbench are
> a bit over the top.

Yes.. its interresting to SEE, whether its relevant and something to
care about is entirely different.

Yes, its very interresting that something craps out, now, this thing is
_NEVER_ going to occur in real life, and if it happens to do by some
magical christmas fluke, then that is fortunately only ONE time you're
seeing that problem, and as such, its irellevant, and certainly doesnt
merit workarounds which makes other very common stuff perform
significantly worse.

> 
> > I have zero interest in adding any "tweaks" to BFS to perform well in X 
> > benchmark, for there be a path where dragons lie. I've always maintained that, 
> > and still stick to it, that the more tweaks you add for corner cases, the more 
> > corner cases you introduce yourself. BFS will remain for a targeted audience 
> > and I care not to appeal to any artificial benchmarketing obsessed population 
> > that drives mainline, since I don't -have- to. Mainline can do what it wants, 
> > and hopefully uses BFS as a yardstick for comparison when appropriate.
> 
> Interesting rant.  IMO, benchmarks are all merely programs that do some
> work and quantify.  Whether you like what they measure or not, whether
> they emit flattering numbers or not, they can all tell you something if
> you're willing to listen.

I suspect con is very interrested in listening, however, as he have
stated, if fixing some corner case in an artificial load requires
damaging a realworld load, that is an unacceptable modification to him,
and I agree. I ask you this, would you rather some artificial benchmark
ran better, but your own everyday applications ran slower as a result?
It seems to me you do, which i can not understand.

> 
> Oh, and for the record, timing mplayer thing was NOT in the presence of
> 100000 pipes, it was in the presence of one cpu hog, as was the time
> amarok loading thing.  Those were UP tests showing you a weakness.  All
> of the results I sent you were intended to show you areas that could use
> some improvement, but you don't want to hear, so label and hand-wave.
> 
> Below is a quote of the results I sent you.
> 
> <quote>
> 
> I've taken BFS out for a few spins while looking into BFS vs CFS latency
> reports, and noticed a couple problems I'll share, comparison testing
> has been healthy for CFS, so maybe BFS can profit as well.  Below are
> some bfs304 vs my working tree numbers from a run this morning, looking
> to see if some issues seen in earlier releases were still present.
> 
> Comments on noted issues: 
> 
> It looks like there may be some affinity troubles, and there definitely
> seems to be a fairness bug still lurking.  No idea what's up with that,
> but see data below, it's pretty nasty.  Any sleepy load competing with a
> pure hog seems to be troublesome. 
> 
> The pgsql+oltp test data is very interesting to me, pgsql+oltp hates
> preemption with a passion, because of it's USERLAND spinlocks.  Preempt
> the lock holder, and watch the fun.  Your preemption model suits it very
> well at the low end, and does pretty well all the way though.  Really
> interesting to me is the difference in 1 and 2 client throughput, why
> I'm including these.
> 
> msql+oltp and tbench look like they're griping about affinity to me, but
> I haven't instrumented anything, so can't be sure.  mysql+oltp I know is
> a wakeup preemption and is very affinity sensitive.  Too little wakeup
> preemption, it suffers, any load balancing, it suffers.
> 
> What vmark is so upset about, I have no idea.  I know it's very affinity
> sensitive, and hates wakeup preemption passionately.
> 
> Numbers:
> 
> vmark
> tip           108841 messages per second 
> tip++         116260 messages per second
> 31.bfs304      28279 messages per second
> 
> tbench 8
> tip           938.421 MB/sec 8 procs
> tip++         952.302 MB/sec 8 procs
> 31.bfs304     709.121 MB/sec 8 procs
> 
> mysql+oltp
> clients             1          2          4          8         16         32         64        128        256
> tip           9999.36   18493.54   34652.91   34253.13   32057.64   30297.43   28300.96   25450.14   20675.99
> tip++        10041.16   18531.16   34934.22   34192.65   32829.65   32010.55   30341.31   27340.65   22724.87
> 31.bfs304     9459.85   14952.44   32209.07   29724.03   28608.02   27051.10   24851.44   21223.15   15809.46
> 
> pgsql+oltp
> clients             1          2          4          8         16         32         64        128        256
> tip          13577.63   26510.67   51871.05   51374.62   50190.69   45494.64   37173.83   27767.09   22795.23
> tip++        13685.69   26693.42   52056.45   51733.30   50854.75   49790.95   48972.02   47517.34   44999.22
> 31.bfs304    15467.03   21126.57   52673.76   50972.41   49652.54   46015.73   44567.18   40419.90   33276.67
> 
> fairness bug in 31.bfs304?
> 
> prep:
> set CPU governor to performance first, as in all benchmarking.
> taskset -c 0 pert (100% CPU hog TSC perturbation measurement proggy)
> taskset -p 0x1 `pidof Xorg`
> 
> perf stat taskset -c 0 konsole -e exit
> 31.bfs304    2.073724549  seconds time elapsed
> tip++        0.989323860  seconds time elapsed
> 
> note: amarok pins itself to CPU0, and is set up to use mysql database.
> 
> prep: cache warmup run.
> perf stat amarokapp (quit after 12000 song mp3 collection is loaded)
> 
> 31.bfs304    136.418518486  seconds time elapsed
> tip++         19.439268066  seconds time elapsed
> 
> prep: restart amarok, wait for load, start playing
> 
> perf stat taskset -c 0 mplayer -nosound 3DMark2000.mkv (exact 6 minute movie)
> 31.bfs304    432.712500554  seconds time elapsed
> tip++        363.622519583  seconds time elapsed
> 

But presumably the cpu hog is running at same priority, and if this is
done on a UP system, that will obviously mean fairness will make stuff
slower..

Try this on a dualcore or quadcore system, or ofcourse just set the
niceness accordingly...

> 

