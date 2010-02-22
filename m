Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0BVSRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:17:15 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43761 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0BVSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RAMvdX66QEF7HLMApp0xdeFllKyK4zpHxzCnTj2QIV9IcFtGOM3Mz28uQ1EL7h91/m
         15S4m67RQ0H0W/I9ZRzqrXGshfv73o9OtQVRv4NB+8JN13Mw6PUXehS7qjVU3R8K/f5A
         1EdEYdmpxLypfT1oSzeg/axAv59wJ61lJJGGk=
Date: Mon, 22 Feb 2010 19:17:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
	function_graph tracer
Message-ID: <20100222181705.GF5055@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com> <20100220144302.GB5354@nowhere> <1266850663.24271.4425.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266850663.24271.4425.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:57:43AM -0500, Steven Rostedt wrote:
> On Sat, 2010-02-20 at 15:43 +0100, Frederic Weisbecker wrote:
> > 
> > Instead of having yet another check here, may be should we
> > have a dedicated stub trace_graph_entry?
> > 
> > 
> > 
> > > @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
> > >  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
> > >  		return;
> > >  
> > > +	if (tracing_thresh &&
> > > +		(trace->rettime - trace->calltime < tracing_thresh))
> > > +		return;
> > > +
> > 
> > 
> > 
> > And perhaps we can do the same for the return handler?
> > We could have a trace_graph_return_threshold that
> > performs the above check and then relies on trace_graph_return.
> 
> So you mean to register a different type of function to the graph tracer
> if trace_thresh is enabled? That does sound like a better idea.


Yeah, this is going to optimize both types of tracing. And I would
also like to prevent from adding new checks in the common graph
tracing if possible. User's cpus and cachelines deserve better :)

