Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0BTOVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:21:12 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39928 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0BTOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r47Jg4R1dDoL31Tt6bp+B4eGZmFAbCFNuFQblK7v7BRA8TBfFV3kGXlK0kNILDCgzJ
         HqQN8iPHXv8ho/htOKDqR9BgElfsgoRRUB+HIZDKZ6STFLgei1qo1pEN8xWeMd49pXM/
         BuVtcmD6RxqJyhDoc3Xs4AfBDVWEzz0aKl6bo=
Date: Sat, 20 Feb 2010 15:21:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
	function_graph tracer
Message-ID: <20100220142054.GA5354@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com> <1265929831.2737.340.camel@localhost.localdomain> <4B749A42.2080703@am.sony.com> <1265934415.2737.344.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265934415.2737.344.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 07:26:55PM -0500, Steven Rostedt wrote:
> On Thu, 2010-02-11 at 16:01 -0800, Tim Bird wrote:
> > On 02/11/2010 03:10 PM, Steven Rostedt wrote:
> > > On Wed, 2010-02-10 at 14:52 -0800, Tim Bird wrote:
> > >>  static struct tracer_opt trace_opts[] = {
> > >>  	/* Display overruns? (for self-debug purpose) */
> > >> @@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
> > >>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
> > >>  	/* Display absolute time of an entry */
> > >>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> > >> +	/* Display function name on exit, instead of just closing brace */
> > >> +	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
> > >>  	{ } /* Empty entry */
> > > 
> > > I wonder if this should be enabled on start up of the function graph
> > > tracer if the threshold is set?
> > > 
> > > Otherwise people will wonder WTF?
> > 
> > Indeed.  I'm not sure exactly how to do this.
> > 
> > Would it be better to set the option when current_tracer
> > is set with 'function_graph', and tracing_thresh is non-zero?
> 
> The above is the only one I would do. If tracing_thresh is non-zero when
> the function_graph tracer is set, on the start up code in the function
> tracer (graph_trace_init).
> 
> Just enable the option if trace_thresh is set. If you enable function
> graph tracer and have the trace_thresh set, then this type of tracing
> starts immediately. It also keeps the code nicely in the
> trace_function_graph.c file, and does not need to touch the setting of
> tracing_thresh.


Actually why do we encumber with both tracing_thresh and the funcgraph-exit
option?

We could just have the output and the record check tracing_thresh instead
of the funcgraph-exit option.

