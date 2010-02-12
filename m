Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0BLA1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab0BLA1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:27:00 -0500
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <srostedt@redhat.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B749A42.2080703@am.sony.com>
References: <4B733721.3030503@am.sony.com>  <4B7338BF.1070505@am.sony.com>
	 <1265929831.2737.340.camel@localhost.localdomain>
	 <4B749A42.2080703@am.sony.com>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 11 Feb 2010 19:26:55 -0500
Message-Id: <1265934415.2737.344.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 16:01 -0800, Tim Bird wrote:
> On 02/11/2010 03:10 PM, Steven Rostedt wrote:
> > On Wed, 2010-02-10 at 14:52 -0800, Tim Bird wrote:
> >>  static struct tracer_opt trace_opts[] = {
> >>  	/* Display overruns? (for self-debug purpose) */
> >> @@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
> >>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
> >>  	/* Display absolute time of an entry */
> >>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> >> +	/* Display function name on exit, instead of just closing brace */
> >> +	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
> >>  	{ } /* Empty entry */
> > 
> > I wonder if this should be enabled on start up of the function graph
> > tracer if the threshold is set?
> > 
> > Otherwise people will wonder WTF?
> 
> Indeed.  I'm not sure exactly how to do this.
> 
> Would it be better to set the option when current_tracer
> is set with 'function_graph', and tracing_thresh is non-zero?

The above is the only one I would do. If tracing_thresh is non-zero when
the function_graph tracer is set, on the start up code in the function
tracer (graph_trace_init).

Just enable the option if trace_thresh is set. If you enable function
graph tracer and have the trace_thresh set, then this type of tracing
starts immediately. It also keeps the code nicely in the
trace_function_graph.c file, and does not need to touch the setting of
tracing_thresh.

-- Steve


