Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZGNQzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZGNQzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZGNQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:55:12 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:38494 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbZGNQzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:55:11 -0400
Date: Tue, 14 Jul 2009 12:54:13 -0400 (EDT)
From: "James H. Anderson" <anderson@cs.unc.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
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
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       "James H. Anderson" <anderson@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
In-Reply-To: <1247589099.7500.191.camel@twins>
Message-ID: <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
References: <200907102350.47124.henrik@austad.us>  <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>  <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>  <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
  <4A5C9ABA.9070909@nortel.com>  <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jul 2009, Peter Zijlstra wrote:

>
> Hi Jim,
>
> On Tue, 2009-07-14 at 11:19 -0400, James H. Anderson wrote:
>> The first email in this thread that I was cc'ed on talked about
>> implementing global EDF,
>
> Hendrik says that its a modified Modified-Least-Laxity-First, so
> something like M^2-LLF, and I cc'ed you (and I meant to add Bjorn too,
> but now see I failed to actually do so) in the hope that you would have
> some thoughts on his scheduling algorithm, since that is what you do a
> lot of ;-)
>
> It could well be he modified M-LLF into G-EDF, but I'm behind in my
> reading here, so I'll have to leave that up to others.

I meant to say something about this algorithm earlier that may be
worthwhile.  If I understand Hendrik's algorithm correctly, it falls
within a class of global schedulers for which bounded deadline
tardiness is guaranteed (as long as total utilization doesn't exceed
the system's capacity).  This follows from results in:

H. Leontyev and J. Anderson, "Generalized Tardiness Bounds for Global
Multiprocessor Scheduling",  Proceedings of the 28th IEEE Real-Time
Systems Symposium, pp. 413-422, December 2007.

This is a positive thing w.r.t. wanting to support soft real-time
workloads.  However, global EDF also has this property and (I would
think) is easier to implement (I'm just guessing here -- we haven't
actually implemented any algorithm that involves laxities in
LITMUS^RT).  Ted Baker did some work on an algorithm called EDZL
(EDF until zero laxity) that is essentially a hybrid of these two
algorithms.  In simulations we've done (not based on real implementations),
EDZL exhibits really low tardiness (almost non-existent).  EDZL may
give you the benefits of using laxities where useful and be easier
to implement (but that's just my guess)

Regarding all these "legacy" issues, I think it would be helpful to
write them all down carefully and formally, and then think about
what are the *simplest* mechanisms that will do the job in the common
case.  It is not worthwhile (in my opinion) to introduce tons of
complexity to nip at corner cases that aren't that common.  Of course,
this begs the question of what is "common" and what is not: something
that may also be worth trying to find evidence for and writing down.

Or better yet, someone needs to define a new standard for multicore...
but I'm not sure how that gets done.

Gotta go....

-Jim
