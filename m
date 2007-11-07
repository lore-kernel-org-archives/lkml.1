Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbXKGWLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbXKGWLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXKGWLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:11:06 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:56980 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXKGWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:11:03 -0500
Date: Wed, 7 Nov 2007 17:10:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       pwil3058@bigpond.net.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
Message-ID: <20071107221007.GA31008@goodmis.org>
References: <1194434956.6289.111.camel@twins> <1194437820.6289.114.camel@twins> <20071107102725.64514fde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107102725.64514fde.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 10:27:25AM -0800, Andrew Morton wrote:
> > On Wed, 07 Nov 2007 13:17:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > +	{
> > +		.ctl_name	= CTL_UNNUMBERED,
> > +		.procname	= "sched_nr_migrate",
> > +		.data		= &sysctl_sched_nr_migrate,
> > +		.maxlen		= sizeof(unsigned int),
> > +		.mode		= 644,
> > +		.proc_handler	= &proc_dointvec,
> > +	},
> 
> This (and all the other stuff in that table) should be described in
> Documentation/, please.
> 
> It would be nice if sched_nr_migrate didn't exist, really.  It's hard to
> imagine anyone wanting to tweak it, apart from developers.

I'm not so sure about that. It is a tunable for RT. That is we can tweak
this value to be smaller if we don't like the latencies it gives us.

This is one of those things that sacrifices performance for latency.
The higher the number, the better it can spread tasks around, but it
also causes large latencies.

I've just included this patch into 2.6.23.1-rt11 and it brought down an
unbounded latency to just 42us. (previously we got into the
milliseconds!).

Perhaps when this feature matures, we can come to a good defined value
that would be good for all. But until then, I recommend keeping this a
tunable.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

