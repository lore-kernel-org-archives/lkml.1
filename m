Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbYKMIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbYKMIk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKMIkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:40:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMIkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:40:18 -0500
Date: Thu, 13 Nov 2008 09:39:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: do not update max buffer with no users
Message-ID: <20081113083935.GC25479@elte.hu>
References: <20081113013041.086583690@goodmis.org> <20081113013247.974941878@goodmis.org> <20081112183745.07af124d.akpm@linux-foundation.org> <alpine.DEB.1.10.0811122145360.7458@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811122145360.7458@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Wed, 12 Nov 2008, Andrew Morton wrote:
> > 
> > 
> > This sort of thing:
> > 
> > +#ifdef CONFIG_TRACER_MAX_TRACE
> >  	if (current_trace && current_trace->print_max)
> >  		iter->tr = &max_tr;
> >  	else
> > +#endif
> >  		iter->tr = inode->i_private;
> > 
> > is particularly regrettable.
> 
> Another answer is to not allocate it and check for NULL before using it. 
> But this would mean that I would have to find all the places that touch it 
> (the same as the ifdefs) and make sure they are safe.
> 
> The reason I picked the ifdefs was to guarantee that there were no users 
> if it was not being used.

Since this is a regression, the best answer is usually the smallest 
possible patch. Which by all likelyhood would be the removal of 
CONFIG_TRACER_MAX_TRACE uses:

 ./kernel/trace/trace.c:#ifdef CONFIG_TRACER_MAX_TRACE
 ./trace.c:#ifdef CONFIG_TRACER_MAX_TRACE
 ./trace.c:#ifdef CONFIG_TRACER_MAX_TRACE

Note, please dont touch the Kconfig - that's just unnecessary churn 
that does nothing to resolve the regression. We'll have an unused 
symbol (and we'll fix it for real in the devel branches) but that's 
not an issue for .28.

Ok?

	Ingo
