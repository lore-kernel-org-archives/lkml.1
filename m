Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZCJPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZCJPGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZCJPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:06:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZCJPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:06:08 -0400
Subject: Re: [PATCH 2/4] perf_counter: provide pagefault software events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090310145915.GK3850@elte.hu>
References: <20090310141913.961861111@chello.nl>
	 <20090310142015.761644317@chello.nl>  <20090310145915.GK3850@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 16:06:03 +0100
Message-Id: <1236697563.25234.374.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 15:59 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Index: linux-2.6/arch/powerpc/mm/fault.c
> > ===================================================================
> > --- linux-2.6.orig/arch/powerpc/mm/fault.c
> > +++ linux-2.6/arch/powerpc/mm/fault.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/module.h>
> >  #include <linux/kprobes.h>
> >  #include <linux/kdebug.h>
> > +#include <linux/perf_counter.h>
> >  
> >  #include <asm/firmware.h>
> >  #include <asm/page.h>
> > @@ -170,6 +171,8 @@ int __kprobes do_page_fault(struct pt_re
> >  		die("Weird page fault", regs, SIGSEGV);
> >  	}
> >  
> > +	perf_swcount_event(PERF_COUNT_PAGE_FAULTS, 1, regs);
> 
> Wow, that's really nice - this way we can display a profile of 
> pagefault events in KernelTop - as if it was a real cycles or 
> other hw event based profile. Have you tried it out?

Yeah, but unsurprising all pagefaults I generated were in userspace, so
kerneltop stayed empty.

Found that perfstat went bokers though, forgot to handle the case where
there's no overflow interrupt.

/me goes poke at the code a bit more.



