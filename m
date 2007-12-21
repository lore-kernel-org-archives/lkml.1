Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXLUMbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXLUMbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXLUMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:31:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbXLUMbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:31:40 -0500
Date: Fri, 21 Dec 2007 13:31:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221123113.GA19136@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220161934.0f55029a.akpm@linux-foundation.org> <20071221003035.GA10123@elte.hu> <20071220164000.58c43b42.akpm@linux-foundation.org> <20071221102727.GB22452@elte.hu> <20071221024211.f4207136.akpm@linux-foundation.org> <20071221111207.GC29047@elte.hu> <20071221033443.058b1b63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221033443.058b1b63.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +/*
> > + * Migration helpers - the proper API is the local_read_flags API.
> > + * Will go away in v2.6.26.
> > + */
> > +#define local_save_flags		local_read_flags
> > +#define __local_save_flags		__local_read_flags
> > +#define raw_local_save_flags		raw_local_read_flags
> > +#define __raw_local_save_flags		__raw_local_read_flags
> > +
> 
> Looks good.  We also have local_irq_save(), raw_local_irq_save() and 
> __raw_local_irq_save() which might or might not disable interrupts.  
> (Do we really need three flavours of these?)

all disable interrupts. All the raw_ and __ APIs are for internal use 
only, they should _not_ be used by anything but directly lockdep related 
code.

> I guess that people's understanding of spin_lock_irqsave() (note the 
> irqsave versus irq_save inconsistency) is sufficiently good for nobody 
> to get tripped up by local_irq_save().  But it's a poor name 
> nonetheless.

yeah, but it's the historic name that stems from the old cli() API that 
had "global scope". I guess these days people know that irq-disabling is 
a CPU-local business, not a global thing? I cannot think of any good 
alternative name though.

	Ingo
