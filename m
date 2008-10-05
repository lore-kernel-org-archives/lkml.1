Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYJEJxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYJEJxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJEJxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:53:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYJEJxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:53:38 -0400
Date: Sun, 5 Oct 2008 11:53:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Add a C-state tracer to help power
	optimization
Message-ID: <20081005095326.GD29909@elte.hu>
References: <20081004105447.0e48d6d4@infradead.org> <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> My comments are more towards Ingo than to Arjan.
> 
> On Sat, 4 Oct 2008, Arjan van de Ven wrote:
> > +++ b/kernel/trace/Kconfig
> > @@ -134,6 +134,17 @@ config BOOT_TRACER
> >  	  be enabled if this tracer is selected since only one tracer
> >  	  should touch the tracing buffer at a time.
> >  
> > +config CSTATE_TRACER
> > +	bool "Trace C-state behavior"
> > +	depends on HAVE_FTRACE
> 
> Ingo, here's the confusion again between the FTRACE infrastructure and 
> the ftrace "function tracer". the HAVE_FTRACE should really be 
> HAVE_FUNCTION_TRACER. The infrastructure of a lot of the ftrace 
> tracers do not depend on the function tracer.
> 
> The CSTATE_TRACER also does not depend on HAVE_FTRACE. Think we should 
> rename this? Otherwise more kernel developers will get confused by it. 
> :-(

agreed, please send a rename patch to make it more consistent.

> > +static enum print_line_t cstate_print_line(struct trace_iterator *iter)
> > +{
> > +	int ret;
> > +	struct trace_entry *entry = iter->ent;
> > +	struct trace_cstate *field = (struct trace_cstate *)entry;
> 
> Ingo, isn't the trace_assign_type in your latest tree?

yeah, it is, and it should be used here instead of a direct cast.

	Ingo
