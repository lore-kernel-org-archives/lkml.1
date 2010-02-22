Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0BVO5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:57:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0BVO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:57:51 -0500
X-Authority-Analysis: v=1.0 c=1 a=Lp5yzKHX74QA:10 a=bvlAmaRIi62YJpkBrPQA:9 a=er4tAr7PPB6MDohw_wsA:7 a=S0LMAwYPEqPgHTHjaUk5JTF_B1UA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20100220144302.GB5354@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com>
	 <20100220144302.GB5354@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 22 Feb 2010 09:57:43 -0500
Message-ID: <1266850663.24271.4425.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 15:43 +0100, Frederic Weisbecker wrote:
> 
> Instead of having yet another check here, may be should we
> have a dedicated stub trace_graph_entry?
> 
> 
> 
> > @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
> >  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
> >  		return;
> >  
> > +	if (tracing_thresh &&
> > +		(trace->rettime - trace->calltime < tracing_thresh))
> > +		return;
> > +
> 
> 
> 
> And perhaps we can do the same for the return handler?
> We could have a trace_graph_return_threshold that
> performs the above check and then relies on trace_graph_return.

So you mean to register a different type of function to the graph tracer
if trace_thresh is enabled? That does sound like a better idea.

-- Steve


