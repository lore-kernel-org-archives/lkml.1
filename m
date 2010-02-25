Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0BYPpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:45:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759374Ab0BYPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:45:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=Lp5yzKHX74QA:10 a=7U3hwN5JcxgA:10 a=xj_yx8YI2LJz39zCu94A:9 a=FUKiAcdBgy5EyGriy4oA:7 a=0TuB9ulzm-C9oVrhjk4wfrKY-A4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <4B832CD1.3010602@am.sony.com>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com>
	 <20100220144302.GB5354@nowhere>
	 <1266850663.24271.4425.camel@gandalf.stny.rr.com>
	 <20100222181705.GF5055@nowhere>  <4B832CD1.3010602@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 10:44:59 -0500
Message-ID: <1267112699.6328.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 17:18 -0800, Tim Bird wrote:
> On 02/22/2010 10:17 AM, Frederic Weisbecker wrote:
> > On Mon, Feb 22, 2010 at 09:57:43AM -0500, Steven Rostedt wrote:
> >> On Sat, 2010-02-20 at 15:43 +0100, Frederic Weisbecker wrote:
> >>>
> >>> Instead of having yet another check here, may be should we
> >>> have a dedicated stub trace_graph_entry?
> >>>
> >>>> @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
> >>>>  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
> >>>>  		return;
> >>>>
> >>>> +	if (tracing_thresh &&
> >>>> +		(trace->rettime - trace->calltime < tracing_thresh))
> >>>> +		return;
> >>>> +
> >>>
> >>>
> >>>
> >>> And perhaps we can do the same for the return handler?
> >>> We could have a trace_graph_return_threshold that
> >>> performs the above check and then relies on trace_graph_return.
> >>
> >> So you mean to register a different type of function to the graph tracer
> >> if trace_thresh is enabled? That does sound like a better idea.
> > 
> > 
> > Yeah, this is going to optimize both types of tracing. And I would
> > also like to prevent from adding new checks in the common graph
> > tracing if possible. User's cpus and cachelines deserve better :)
> 
> I'll take a look at doing it this way, and see what I come
> up with.  If I can re-use most of trace_graph_entry and
> trace_graph_return (and I don't see why not), it should be
> a pretty small patch.

If you can get this out quickly, it may still be able to make the merge
window.

-- Steve


