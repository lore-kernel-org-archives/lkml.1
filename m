Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZA2V2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZA2V2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA2V22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:28:28 -0500
Received: from relay3.sgi.com ([192.48.171.31]:50614 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489AbZA2V21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:28:27 -0500
Date: Thu, 29 Jan 2009 15:30:29 -0600
From: Cliff Wickman <cpw@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       tj@kernel.org
Subject: Re: [PATCH] x86: UV cleanup
Message-ID: <20090129213029.GA29154@sgi.com>
References: <E1LScjM-00073R-Cu@eag09.americas.sgi.com> <20090129203517.GE12819@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129203517.GE12819@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jan 29, 2009 at 09:35:17PM +0100, Ingo Molnar wrote:
> 
> * Cliff Wickman <cpw@sgi.com> wrote:
> 
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > This patch tweaks a couple things:
> > 
> > - uv_flush_tlb_others()
> >   the WARN_ON(!in_atomic()); fails if CONFIG_PREEMPT is not enabled
> > 
> >   The #ifdef may not be the right fix. The fix is probably in the
> >   in_atomic macro, but I'm not sure what in_atomic() should return
> >   if CONFIG_PREEMPT is turned off.  I tested making it return 1 in that
> >   case, but that yielded tons of warnings.
> > 
> >   The simpler fix for tlb_uv.c would be to just drop the WARN_ON.
> > 
> > - uv_flush_send_and_wait() should return a pointer if the broadcast
> >   remote tlb shootdown requests fail. That causes the conventional IPI
> >   method of shootdown to be used.
> 
> hm, this isnt a cleanup but a fix - i.e. needs to go into x86/urgent as a 
> separate patch, right?

Yes, it is a fix.  I'll re-post, and send the WARN_ON issue as a
separate patch.

 
> and this:
> 
> > @@ -316,7 +316,9 @@ const struct cpumask *uv_flush_tlb_other
> >  	int locals = 0;
> >  	struct bau_desc *bau_desc;
> >  
> > +#ifdef CONFIG_PREEMPT
> >  	WARN_ON(!in_atomic());
> > +#endif
> 
> is indeed somewhat ugly - and we have no proper primitive to test for 
> atomicity. (mainly because we dont know about atomicity on a non-preempt 
> kernel)
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
