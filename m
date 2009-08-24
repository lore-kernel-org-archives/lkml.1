Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbZHXHam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbZHXHam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZHXHal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:30:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:38214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZHXHak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:30:40 -0400
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090821142151.GC11098@elte.hu>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.728070630@chello.nl> <1250690853.8282.59.camel@twins>
	 <1250769606.8282.181.camel@twins>  <20090821142151.GC11098@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 09:29:22 +0200
Message-Id: <1251098962.7538.143.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 16:21 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:

> > diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> > index 9ba1822..2b0528f 100644
> > --- a/include/linux/perf_counter.h
> > +++ b/include/linux/perf_counter.h
> > @@ -439,6 +439,7 @@ enum perf_callchain_context {
> >  struct perf_callchain_entry {
> >  	__u64				nr;
> >  	__u64				ip[PERF_MAX_STACK_DEPTH];
> > +	int				restricted;
> >  };
> 
> i'd love to have something more specific here - i.e. a context type 
> ID that identifies these basic types:
> 
>  - process
>  - softirq
>  - hardirq
>  - NMI
> 
> and then let it be up to upper layers to decide what they do with a 
> restricted entry, and how to further process this information.
> 
> And it's not just security: for example it would be interesting to 
> sample pure, non-irq overhead - as IRQ overhead is often unrelated 
> to the process being measured.

Yes it is, this is purely about not showing some data. If you don't want
to sample IRQ stuff that's something else, we'd have to grow that
capability in hardware (like the OS/USR bits) or put perf enable/disable
hooks into the irq entry/exit hooks (which doesn't sound all too hot an
idea to me).

Simply not showing the call-trace is something all-together different
from not profiling it.
