Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZGNQ1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZGNQ1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZGNQ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:27:02 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:48746 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZGNQ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:27:00 -0400
X-Greylist: delayed 3835 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 12:26:57 EDT
Date: Tue, 14 Jul 2009 11:19:22 -0400 (EDT)
From: "James H. Anderson" <anderson@cs.unc.edu>
To: Chris Friesen <cfriesen@nortel.com>
cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
In-Reply-To: <4A5C9ABA.9070909@nortel.com>
Message-ID: <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
References: <200907102350.47124.henrik@austad.us>  <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>  <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>  <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
 <4A5C9ABA.9070909@nortel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I've been reading these email messages for a few days
now and wanted to make some comments... maybe what I
have to say will be useful to you... maybe not.

First, I thought I should introduce myself because I
think some of you may not know me.  I lead the LITMUS^RT
project at UNC (http://www.cs.unc.edu/~anderson/litmus-rt/).
I think it is important to mention this because the goals
of our LITMUS^RT-related research mean that I'm coming at
all of this from a rather different place than (I think)
most of you.  The main goal of our research has been to
identify those real-time scheduling and synchronization
algorithms that work best on multicore platforms.  We
define "work best" in terms *schedulability* with *real
overheads* from *real implementations* considered.  There
are two important aspects of this that will influence my
comments (so take them with a grain of salt):

1. By emphasizing schedulability, we are clearly defining
"real-time" to mean predictable, and not real-fast.

2. We use Linux as a platform for implementing the algorithms
we test and getting overheads.  It has never been among our
goals to actually change mainline Linux (although this may become
a goal in the future).  This means that we haven't focused too
much on legacy-related hindrances.  I'm using the word
"hindrances" with intention.  I think in particular anything that
is POSIX-based is going to be fraught with problems in a multicore
world.  Such legacy issues seem to be at the heart of many of
the problematic scenarios you are discussing.  Anyway, maybe
these things are a fact of life.

The first email in this thread that I was cc'ed on talked about
implementing global EDF, but the discussion since has been
entirely about synchronization issues.  To the best of my
knowledge, the only published real-time locking protocol that
can be used under global EDF (and many other algorithms) without
restricting critical sections (like not allowing certain resources
to be accessed in a nested manner) is a protocol we designed called
the flexible multiprocessor locking protocol (FMLP).  Please see
the following papers at http://www.cs.unc.edu/~anderson/papers.html:

B. Brandenburg and J. Anderson, "Reader-Writer Synchronization for
Shared-Memory Multiprocessor Real-Time Systems",  Proceedings of the
21st Euromicro Conference on Real-Time Systems, pp. 184-193, July 2009.

B. Brandenburg and J. Anderson, "A Comparison of the M-PCP, D-PCP, and
FMLP on LITMUSRT",  Proceedings of the 12th International Conference
on Principles of Distributed Systems, pp. 105-124, December 2008.

B. Brandenburg and J. Anderson, "An Implementation of the PCP, SRP,
D-PCP, M-PCP, and FMLP Real-Time Synchronization Protocols in LITMUSRT",
Proceedings of the 14th IEEE International Conference on Embedded and
Real-Time Computing Systems and Applications, pp. 185-194, August 2008.

B. Brandenburg, J. Calandrino, A. Block, H. Leontyev, and J. Anderson,
"Real-Time Synchronization on Multiprocessors: To Block or Not to
Block, to Suspend or Spin?",  Proceedings of the 14th IEEE Real-Time
and Embedded Technology and Applications Symposium, pp. 342-353, April 2008.

A. Block, H. Leontyev, B. Brandenburg, and J. Anderson, "A Flexible
Real-Time Locking Protocol for Multiprocessors",  Proceedings of the
13th IEEE International Conference on Embedded and Real-Time Computing
Systems and Applications, pp. 47-57, August 2007.

(BTW, most papers on this page with "Bjoern Brandenburg" as a co-author
are LITMUS^RT-related.  I've added Bjoern to the cc list.)

The underlying philosophy of our synchronization-related work is
"simplicity wins".  Simplicity is obviously a good thing from an
implementation perspective, but it is also good from an *analysis*
perspective.  Correctly computing task blocking terms for multiprocessor
real-time locking protocols is *really* hard.  There are many
mistakes in analysis presented in the literature (in fact, I think a
new one was pointed out ECRTS two weeks ago).  It is really hard
to nail down all the corner cases, and simple mechanisms have far
fewer corner cases.  In our work, we first carefully write up all
blocking analysis and then have a multi-hour group meeting where
6 to 8 people review and discuss the analysis.

The FMLP is really embarrassingly simple.  It's main mechanisms are:

1. Require critical sections to execute non-preemptively (I know,
non-preemption violates the "real-fast" religion -- I've been in
these discussion before :-)).

2. Execute critical sections in FIFO order (I know, FIFO violates
the "real-time" religion).

3. Deal with nested lock accesses by requiring a higher-level,
coarser lock to be acquired.  While this many seem "too dumb", traces
we have taken of real systems (including Linux) indicate that
two-level nesting is not that common and deep nesting is quite rare.
Why design complicated mechanisms that are both hard to implement
and analyze to deal with something that is not so common?

In the FMLP, waiting can be implemented via either spinning or
suspension (technically, critical sections are categorized as
"short" or "long" and spinning is used for short CSs and suspension
for long ones -- this categorization is entirely up to the user).
Spinning is done non-preemptively (suspending obviously is not).

The beauty of non-preemptive, FIFO is that on an m-processor system,
blocking behavior is easy to analyze.  For example, with spin-based
waiting, the blocking per critical-section access is (m-1) times the
cost of one critical section.  Someone remarked in an earlier email
that we're really thinking of m being somewhat small (4, maybe 8).
As such, this is a blocking term that is really hard to beat.  As I
said, simplicity wins.  With suspension-based waiting, things are a
bit more complicated, but not much.

In our experience, the blocking analysis of any multiprocessor protocol
that uses priority-inheritance-related mechanisms is a nightmare.  The
problem is that, to handle all the corner cases, pessimistic assumptions
have to be made.  This pessimism can really add up and lead to huge
blocking terms.

This email thread has also touched on group-based scheduling.  We
proposed a very simple scheme several years ago called "skipping"
in the context of Pfair scheduling that makes this easy:

P. Holman and J. Anderson, "Locking under Pfair Scheduling",  ACM
Transactions on Computer Systems , Volume 24, Number 2, pp. 140-174,
May 2006.

(An earlier version in appeared in RTSS 2002).

In this approach, critical-section lengths must be known, and any
lock request that occurs when a task doesn't have sufficient
budget is simply denied -- the request is done later when that task
receives additional budget.  This avoids a task in one group from
holding a lock while it is preempted (which could severely hurt
lock-requesting tasks in other groups).  This scheme is really easy
to implement in conjunction with the FMLP and it doesn't require
complicated budget tracking.  Its effects on blocking terms are
also easy to analyze.  Thomas Nolte and colleagues (in Sweden) have
written some papers where they've used skip-based locks in
hierarchically-scheduled systems.

I'll stop rambling now.  I guess my overall point is that these
legacy issues like POSIX seem to be forcing you into complex
solutions.  Unless there is a way to shed this baggage, I think
it'll be a matter of where you put the complexity -- you'll never
be able to eliminate it (and again, I think complexity is *bad*).

I hope you find my comments worthwhile (and if not, sorry for
sending such a long message).

-Jim Anderson

