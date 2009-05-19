Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZESO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZESO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZESO6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:58:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZESO6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:58:05 -0400
Date: Tue, 19 May 2009 16:53:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090519145308.GB20865@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local> <20090518194749.GA3501@redhat.com> <1242676857.32543.1343.camel@laptop> <20090518201650.GA4384@redhat.com> <1242679221.32543.1396.camel@laptop> <20090518221403.GA7393@redhat.com> <1242724380.26820.482.camel@twins> <1242730154.26820.501.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242730154.26820.501.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Peter Zijlstra wrote:
>
> > There is a solution to this, Gautham suggested it a while back, we could
> > make lockdep scan a lock (Z) his dependencies and if in every chain a
> > particular other lock (L2) was taken, ignore this lock (Z) his
> > dependency for the circular analysis at hand.
> >
> > That would mean we would not find the Z->L1 dep to violate the existing
> > one, because we would ignore L2->Z (because in every Z we hold L2), and
> > we would indeed fail on the next: L2->L1 on the next line in your
> > initial program.
> >
> > Implementing this however might be slightly less trivial than this
> > explanation -- it would however rid us of the spin_lock_nest_lock()
> > annotation's need.
>
> Ingo pointed out that that would weaken the possible deadlock detection
> in that it would have to observe a Z outside of L2 before reporting the
> problem, which might be a very rare, but existing, code path.
>
> Another possible way might be to find the smallest cycle instead of just
> any (the first) cycle.

Yes, thanks Peter for your explanations. Not that I fully understand them,
but at least I do understand this is not trivial.

Oleg.

