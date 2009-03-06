Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZCFRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZCFRrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbZCFRrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:47:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40778 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbZCFRrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:47:00 -0500
Date: Fri, 6 Mar 2009 18:46:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [Patch] mm tracepoints
Message-ID: <20090306174629.GA16513@elte.hu>
References: <1233306324.11332.11.camel@nigel-laptop> <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com> <20090306105627.3EF0.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com> <20090306110423.GD21168@elte.hu> <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com> <20090306135547.GB21907@elte.hu> <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com> <20090306171016.GA32128@elte.hu> <1236361106.6326.595.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236361106.6326.595.camel@laptop>
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

> On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
> > Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
> > it would be nice to hear their opinion about these tracepoints.
> > 
> > Andrew, Nick, Peter, what do you think?
> 
> Bit sad we use the struct mm_struct * as mm identifier (little 
> %lx vs %p confusion there too), but I suppose there simply 
> isn't anything better.

the other option would be to trace the pgd physical pfn value. 
The physical address of the pagetable is a pretty fundamental 
thing so that abstraction is unlikely to change.

> Exposing kernel pointers like that might upset some of the 
> security folks, not sure if I care though.

it's admin-only.

> I'm missing the fault_filemap_read counterpart of 
> fault_anon_pgin.
> 
> Once you have anon/filemap symmetric, you might consider 
> folding these and doing the anon argument thing you do 
> elsewhere.
> 
> Initially I was thinking we lacked the kswapd vs direct 
> reclaim information on the pgout data, but since we log the 
> pid:comm for each event...
> 
> Which brings us to mm_pdflush_*, we can already see its 
> pdflush from pid:comm, then again, it fits the naming style. 
> Same for mm_directreclaim*() - we already know its direct, 
> since its not kswapd doing it.
> 
> Finally, we have page_free, but not page_alloc? Oh, it is 
> there, just not in the obvious place.
> 
> Things missing, we trace unmap, but not mmap, mprotect, mlock?
> 
> pagelock perhaps?

yeah, pagelock would be nice. In a similar way to lockdep 
tracing. Maybe it should be part of lock tracing?

	Ingo
