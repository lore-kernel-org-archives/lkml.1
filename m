Return-Path: <linux-kernel-owner+w=401wt.eu-S934661AbXGXLrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661AbXGXLrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXGXLrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:47:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXGXLrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:47:31 -0400
Date: Tue, 24 Jul 2007 13:47:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070724114713.GA9817@elte.hu>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com> <46A5E39D.7030009@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5E39D.7030009@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@shadowen.org> wrote:

> > within the last 3 weeks, this script went from *really usable* to *a 
> > big noise maker*.

seconded ...

v0.06 was "almost there". I fixed kernel/sched.c to be completely clean, 
except for 3 false positives. That was a real improvement, and i started 
to like checkpatch.pl.

v0.08 is a clear step backwards: it emits 61 warnings now, 90% of which 
are totally bogus. The only 'fix' for many of those warnings is to make 
the code _worse_. That is unacceptable.

> > Warning on multiple declarations on a line is nice, but IMO really 
> > too verbose (why is "int i, j;" bad? Did C somehow change syntax 
> > today?).
> 
> No the normal response is two fold:
> 
> 1) "what the heck are i and j those are meaningless names"
> 2) "please can we have some comments for those variables"

you really should not even be arguing about this. LOOK AT the many false 
positives in sched.c. This is perfectly readable code:

 void __init sched_init(void)
 {
         u64 now = sched_clock();
         int highest_cpu = 0;
         int i, j;

         for_each_possible_cpu(i) {
                 struct rt_prio_array *array;
                 struct rq *rq;

                 rq = cpu_rq(i);

this warning for "i, j" is clearly bogus. So are many of the other 
warnings. checkpatch.pl went from a useful tool that improved the 
quality of the kernel to a rigid, unflexible policeman. It needs to be 
fixed or needs to be gotten rid of.

> which normally leads to the suggestion that it be the following form:
> 
> 	int source;		/* source clock hand */
> 	int destination;	/* destination clock hand */

what the hell are you thinking? Not every trivial line of code needs to 
be commented. Comments are needed for the _nontrivial_ lines of code, 
and there's no way a tool can decide that. The longer "destination" 
variable suggested by you can _easily_ make a previously readable piece 
of code unreadable.

	Ingo
