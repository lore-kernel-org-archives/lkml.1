Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZBVJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZBVJ0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBVJ0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:26:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZBVJ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:26:23 -0500
Date: Sun, 22 Feb 2009 10:26:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: fault.c, simplify kmmio_fault()
Message-ID: <20090222092608.GD6964@elte.hu>
References: <tip-b814d41f0987c7648d7ed07471258101c95c026b@kernel.org> <20090221013845.718d507a@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221013845.718d507a@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> On Fri, 20 Feb 2009 22:40:09 GMT
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri, 20 Feb 2009 22:32:10 +0100
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 21 Feb 2009 00:09:42 +0100
> > 
> > x86, mm: fault.c, simplify kmmio_fault()
> > 
> > Impact: cleanup
> > 
> > Remove an #ifdef from kmmio_fault() - we can do this by
> > providing default implementations for is_kmmio_active()
> > and kmmio_handler(). The compiler optimizes it all away
> > in the !CONFIG_MMIOTRACE case.
> > 
> > Also, while at it, clean up mmiotrace.h a bit:
> > 
> >  - standard header guards
> >  - standard vertical spaces for structure definitions
> > 
> > No code changed (both with mmiotrace on and off in the config):
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >    2947	     12	     12	   2971	    b9b	fault.o.before
> >    2947	     12	     12	   2971	    b9b	fault.o.after
> > 
> > Cc: Pekka Paalanen <pq@iki.fi>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> 
> Acked-by: Pekka Paalanen <pq@iki.fi>
> except for one minor detail below.
> 
> > 
> > ---
> >  arch/x86/mm/fault.c       |    5 ++-
> >  include/linux/mmiotrace.h |   78 +++++++++++++++++++++++++++------------------
> >  2 files changed, 50 insertions(+), 33 deletions(-)
> > 
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 3e36614..fe99af4 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -55,13 +55,14 @@ enum x86_pf_error_code {
> >  	PF_INSTR	=		1 << 4,
> >  };
> >  
> > +/*
> > + * (returns 0 if mmiotrace is disabled)
> 
> Returns 0 if the fault was not handled in mmiotrace.

ok, i've updated the comment. I did not mean the comment to be 
an exclusive statement, but in hindsight it's indeed ambiguous.

	Ingo
