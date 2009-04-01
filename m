Return-Path: <linux-kernel-owner+w=401wt.eu-S1764517AbZDAMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764517AbZDAMz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbZDAMzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:55:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39911 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZDAMzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:55:12 -0400
Date: Wed, 1 Apr 2009 13:55:07 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, alexn@dsv.su.se,
       akpm@linux-foundation.org, alexn@telia.com, apw@shadowen.org,
       cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090401125506.GA6406@csn.ul.ie>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090401111540.GC15442@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 01:15:40PM +0200, Ingo Molnar wrote:
> > <VAST AMOUNTS OF SNIPPAGE>
> >
> > +static inline void __stack_trace(struct page *page, unsigned long *stack,
> > +			unsigned long bp)
> > +{
> > +	int i = 0;
> > +	unsigned long addr;
> > +	struct thread_info *tinfo = (struct thread_info *)
> > +		((unsigned long)stack & (~(THREAD_SIZE - 1)));
> > +
> > +	memset(page->trace, 0, sizeof(long) * 8);
> > +
> > +#ifdef CONFIG_FRAME_POINTER
> > +	if (bp) {
> > +		while (valid_stack_ptr(tinfo, (void *)bp)) {
> > +			addr = *(unsigned long *)(bp + sizeof(long));
> > +			page->trace[i] = addr;
> > +			if (++i >= 8)
> > +				break;
> > +			bp = *(unsigned long *)bp;
> > +		}
> > +		return;
> > +	}
> > +#endif /* CONFIG_FRAME_POINTER */
> > +	while (valid_stack_ptr(tinfo, stack)) {
> > +		addr = *stack++;
> > +		if (__kernel_text_address(addr)) {
> > +			page->trace[i] = addr;
> > +			if (++i >= 8)
> > +				break;
> > +		}
> > +	}
> > +}
> 
> Uhm, this is not acceptable and broken, we have generic stacktrace 
> saving facilities for this precise purpose. It has other problems 
> too.
> 
> The purpose of the patch seems genuinely useful and i support the 
> concept, but the current design is limiting (we could do much 
> better) and the implementation is awful. Please.
> 
> Has this patch been reviewed by or Cc:-ed to anyone versed in kernel 
> instrumentation details, before it was applied to -mm? Those folks 
> hang around the tracing tree usually so they are easy to find. :)
> 

This patch is ancient, predating most of the instrumentation stuff by years. It
was dropped from -mm a few months ago because of changes in proc and this is
a rebase because it came up as being potentially useful pinning down memory
leaks when they occur.

I'm not sure when exactly it was introduced to -mm, but I see references
going back as far as 2.6.12-rc1 so it's no surprise this is now extremly
odd looking. However, there is no plan to merge this to mainline making the
effort of redoing it from scratch a questionable expenditure of time.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
