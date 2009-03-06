Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZCFN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZCFN4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZCFN4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:56:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZCFN4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:56:01 -0500
Date: Fri, 6 Mar 2009 14:55:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Larry Woodman <lwoodman@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Patch] mm tracepoints
Message-ID: <20090306135547.GB21907@elte.hu>
References: <1233306324.11332.11.camel@nigel-laptop> <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com> <20090306105627.3EF0.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com> <20090306110423.GD21168@elte.hu> <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
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


* Larry Woodman <lwoodman@redhat.com> wrote:

> On Fri, 2009-03-06 at 12:04 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > On Fri, 6 Mar 2009, KOSAKI Motohiro wrote:
> > > 
> > > > > I've implemented several mm tracepoints to track page allocation and
> > > > > freeing, various types of pagefaults and unmaps, and critical page
> > > > > reclamation routines.  This is useful for debugging memory allocation
> > > > > issues and system performance problems under heavy memory loads:
> > > > > 
> > > > > # tracer: mm
> > > > > #
> > > > > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > > > #              | |       |          |         |
> > > > >          pdflush-624   [004]   184.293169: wb_kupdate:
> > > > > (mm_pdflush_kupdate) count=3e48
> > > > >          pdflush-624   [004]   184.293439: get_page_from_freelist:
> > > > > (mm_page_allocation) pfn=447c27 zone_free=1940910
> > > > >         events/6-33    [006]   184.962879: free_hot_cold_page:
> > > > > (mm_page_free) pfn=44bba9
> > > > >       irqbalance-8313  [001]   188.042951: unmap_vmas:
> > > > > (mm_anon_userfree) mm=ffff88044a7300c0 address=7f9a2eb70000 pfn=24c29a
> > > > >              cat-9122  [005]   191.141173: filemap_fault:
> > > > > (mm_filemap_fault) primary fault: mm=ffff88024c9d8f40 address=3cea2dd000
> > > > > pfn=44d68e
> > > > >              cat-9122  [001]   191.143036: handle_mm_fault:
> > > > > (mm_anon_fault) mm=ffff88024c8beb40 address=7fffbde99f94 pfn=24ce22
> > > > > ...
> > > > 
> > > > Hi Larry,
> > > > 
> > > > I've started to evaluate your patch.
> > > > 
> > > > firstly, this patch can't apply tip/master.
> > 
> > yeah, would be nice to have a patch against:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> 
> Yeah I'll fix that, it is a moving target.
> > 
> > > > secondly, I don't think the address of mm_struct and pfn 
> > > > help to analysis. administrator don't know the page is which 
> > > > file's cache.
> > > 
> > > The mm_struct may not be helpful since there should be a 1 to 
> > > 1 mapping between user tasks and the mm struct. Hmm, maybe 
> > > not, due to threads?
> > 
> > Correct - so the mm ID looks useful.
> > 
> > > But the pfn is helpful since it is a unique identifier for 
> > > what physical page was mapped.
> > 
> > Yeah. Nevertheless some sort of filename:offset indicator 
> > would be nice too. (as an add-on)
> 
> You mean in the filemap pagefault case???

Would that be useless or controversial? We know from 
vma->mapping which inode it maps to. Knowing which file is 
faulting in can be useful - especially when addresses are a 
moving target such as under PIE or with dlopen(), etc.

	Ingo
