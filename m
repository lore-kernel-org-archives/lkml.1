Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZGNRRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZGNRRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZGNRRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:17:38 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:36411 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZGNRRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:17:37 -0400
Date: Tue, 14 Jul 2009 13:16:52 -0400 (EDT)
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
Message-ID: <alpine.LRH.2.00.0907141259100.16818@anderson.cs.unc.edu>
References: <200907102350.47124.henrik@austad.us>  <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>  <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>  <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
  <4A5C9ABA.9070909@nortel.com>  <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jul 2009, Peter Zijlstra wrote:

> On that, how does the priority ceiling/protection protocol extend to
> deadline schedulers?

Sorry -- I should have responded to this.

These things are pretty easy to extend to deadline scheduling if
partitioning is assumed, and this has been done.  However, it is not
easy to do under global scheduling.  Having tasks pinned to processors
(partitioning) makes it much easier to compute blocking terms (it's much
easier to predict what is happening on each processor at any time).
Without this, it is *really* hard to compute reasonable blocking
terms.  Even doing something as mundane as avoiding deadlocks without a lot
of overhead may not be trivial.  At the time we developed the FMLP
(a couple of years ago), there was *no* published locking protocol (to my
knowledge) that worked under GEDF.  To my knowledge, the FMLP is still the
only one that works under GEDF.  (BTW, I should say that I am not
familiar with the PEP protocol that has been discussed in this thread.
I assume it doesn't work under GEDF, or you wouldn't have asked the
question.)

BTW, FIFO waiting makes blocking terms in the global case much easier
to compute: once a lock request is initiated, the set of blocking lock
requests (onces initiated earlier) is fixed.  (This is actually a bit
of an over-simplification if waiting is by suspending.)  With priority-based
waiting, higher-priority requests can come later.  Determining a
reasonable bound on the number of such requests is hard.

You can find references to papers by others in our FMLP papers.

-Jim
