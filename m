Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXJCG7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXJCG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXJCG6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:58:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34450 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbXJCG6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:58:52 -0400
Date: Tue, 2 Oct 2007 23:58:49 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071002235849.56dbe9fb.pj@sgi.com>
In-Reply-To: <200710022305.23713.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709301335.00441.nickpiggin@yahoo.com.au>
	<20070930204252.45e20bb4.pj@sgi.com>
	<200710022305.23713.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yup - it's asking for load balancing over that set.  That is why it is
> > called that.  There's no idea here of better or worse load balancing,
> > that's an internal kernel scheduler subtlety -- it's just a request that
> > load balancing be done.
> 
> OK, if it prohibits balancing when sched_load_balance is 0, then it is
> slightly more useful.

It doesn't prohibit load balancing just because sched_load_balance is 0.
Only if there are no overlapping cpusets still needing balancing does it
prohibit balancing when 0.

> Yeah, but the interface is not very nice. As an interface for hard
> partitioning, it doesn't work nicely because it is hierarchical.

Yeah -- cpusets are hierarchical.  And some of the use cases for
which cpusets are designed are hierarchical.

> > > You would do this by creating partitioning cpusets which carve up the
> > > root cpuset (basically -- have multiple roots).
> >
> > You would do this with the current, single rooted cpuset (and now
> > cgroup) mechanism by having multiple immediate child cpusets of the
> > root cpuset, which partition the system CPUs.  There is no need to
> > invent some bastardized multiple root structure.
> 
> What do you mean by bastardized?

Changing cpusets from single root to multiple roots would be
bastardizing it.

My proposed sched_load_balance API is already quite capable of
representing what you see the need for - hard partitioning.  It is also
quite capable of representing some other situations, such as I've
described in other replies, that you don't seem to see the need for.

To repeat myself, in some cases, such as batch schedulers running in a
subset of the CPUs on a large system, the code that knows some of the
needs for load balancing does not have system wide control to mandate
hard partitioning.  The batch scheduler can state where it is depending
on load balancing being present, and the system administrator can choose
or not to turn off load balancing in the top cpuset, thereby granting or
not control over load balancing on the CPUs controlled by the batch
scheduler to the batch scheduler.

Hard partitioning is not the only use case here.

If you don't appreciate the other cases, then fine ... but I don't think
that gives you grounds to reject a patch just because it is not precisely
the ideal, narrowly focused, API for the case you do appreciate.

>  What's wrong with having a real
> (and sane) representation of the requested hard-partitions in the system?

What's wrong with it is that 1) it doesn't cover all the use cases,
2) it would require a new and different mechanism other than cpusets
which are not multiple rooted, and do robustly support overlapping
sets and hence are not a hard partitioning, and 3) we'd still need
the cpuset based API to cover the remaining use cases.

Good grief -- I must be misunderstanding you here, Nick.  I can't
imagine that you want to turn cpusets into a multiple rooted hard
partition mechanism.  If you are, then "bastardized" is the right word.

> Not your proposal, just the idea to have enough information to be able
> to work out a more optimal set of sched-domains automatically.

I can't figure out what the sentence is saying ... sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
