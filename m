Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYC1KQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYC1KQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYC1KPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:15:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYC1KPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:15:43 -0400
Date: Fri, 28 Mar 2008 11:15:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328101500.GF30863@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp> wrote:

> >      text    data     bss     dec     hex filename
> >     37642    7014     384   45040    aff0 sched.o.before
> >     37930    7134     384   45448    b188 sched.o.after
> >
> >  288 bytes for only 3 markers in the scheduler - that's 96 bytes added
> >  per every marker (44 bytes of that in the fastpath).
> >
> >  and the tracer codepath is now slower and more complex as well.
> >
> >  A classic lose-lose situation, so let's apply this patch. Not!
> >
> >  NACK-ed-by: Ingo Molnar <mingo@elte.hu>
> 
> I wonder why nobody doesn't fix this serious problem until now. and I 
> am interesting to what difference to ftrace and marker.

i warned and moaned about it ad nauseum.

furthermore, and because it's Friday again, let me remind folks that 
SystemTap has an even more significant bloat problem: the fact that it 
needs a huge download:

 Installing:
   kernel-debuginfo         x86_64     2.6.25-0.163.rc7.git1.fc9  
   development-debuginfo  198 M
 Installing for dependencies:
   kernel-debuginfo-common  x86_64     2.6.25-0.163.rc7.git1.fc9  
   development-debuginfo   30 M

 Total download size: 229 M

for _every_ updated kernel. That 229 MB size reduces the user base of 
SystemTap (which is otherwise a totally brilliant and cool tool) to 1% 
of its potential userbase, to those truly desperate persons who really 
_need_ to get their problem debugged somehow. But it's nowhere near 
usable as an easy, ad-hoc kernel instrumentation tool, just due to the 
sheer size it brings.

for heaven's sake, we can have 3 years of _full Linux kernel history_, 
with all 87875 commits, with full changelog and dependencies and full 
source code included, packed into a rather tight, 180 MB git repository 
...

[ and then i havent even begun about the on-disk footprint of this 
  monstrum, after the packages have been installed: an additional 850 MB.
  Puh-lease ... ]

there's a huge disconnect with reality here.

	Ingo
