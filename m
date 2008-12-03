Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYLCLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYLCLtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYLCLtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:49:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYLCLtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:49:11 -0500
Date: Wed, 3 Dec 2008 06:49:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: function graph return for function entry
In-Reply-To: <20081203081301.GF21006@elte.hu>
Message-ID: <alpine.DEB.1.10.0812030645370.29045@gandalf.stny.rr.com>
References: <20081203045001.367443457@goodmis.org> <20081203045044.002248353@goodmis.org> <20081203081301.GF21006@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: feature, let entry function decide to trace or not
> > 
> > This patch lets the graph tracer entry function decide if the tracing 
> > should be done at the end as well. This requires all function graph 
> > entry functions return 1 if it should trace, or 0 if the return should 
> > not be traced.
> 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 47aa5f0..cef05a2 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -119,6 +119,9 @@ ENTRY(mcount)
> >  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >  	cmpq $ftrace_stub, ftrace_graph_return
> >  	jnz ftrace_graph_caller
> > +
> > +	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
> > +	jnz ftrace_graph_caller
> 
> hm, that's in the hotpath. What's the point of this? Do we want some sort 
> of configuration vector that allows per function graphing versus 
> entry-only traces?

Actually, I'm fine with taking it out. But when we register a function 
graph, we register both a entry and exit. I would think it should still 
work if one was still set as the default. Unless we document it someplace 
that either the entry or exit must be set.

This change has the function graph work if one or the other is set to 
something other than the default.

Also, this is only in the static ftrace path, not dynamic, but then again, 
maybe that means it is even hotter.

I'm fine with pulling this out. It was not really needed, I was just 
trying to make it intuitive.

-- Steve
