Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZCFSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZCFSZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZCFSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:24:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZCFSYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:24:53 -0500
Date: Fri, 6 Mar 2009 19:24:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [Patch] mm tracepoints
Message-ID: <20090306182419.GA28631@elte.hu>
References: <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com> <20090306110423.GD21168@elte.hu> <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com> <20090306135547.GB21907@elte.hu> <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com> <20090306171016.GA32128@elte.hu> <1236361106.6326.595.camel@laptop> <1236362197.6326.615.camel@laptop> <20090306180154.GA20292@elte.hu> <1236363625.6326.641.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236363625.6326.641.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-03-06 at 19:01 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2009-03-06 at 18:38 +0100, Peter Zijlstra wrote:
> > > > On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
> > > > > Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
> > > > > it would be nice to hear their opinion about these tracepoints.
> > > > > 
> > > > > Andrew, Nick, Peter, what do you think?
> > > > 
> > > > Bit sad we use the struct mm_struct * as mm identifier (little %lx vs %p
> > > > confusion there too), but I suppose there simply isn't anything better.
> > > 
> > > > Things missing, 
> > > 
> > > Why only anon and filemap, that misses out on all the funky 
> > > driver ->fault() handlers.
> > 
> > btw., does it include shm faults? I think all of this would 
> > be handled if the tracepoint was at handle_mm_fault(), 
> > right?
> 
> Partially, you wouldn't be able to do the file:offset thing 
> you asked for.

That could be done further down in filemap_fault(). I.e. have an 
all-encompassing tracepoint for all things [user-] page faults, 
and a few opt-in places for more interesting specific fault 
types.

> But yeah, also hugetlb seems to be missing.

Probably not that huge of an issue, given how rare those faults 
are ;-)

	Ingo
