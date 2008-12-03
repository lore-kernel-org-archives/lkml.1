Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYLCQcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYLCQcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYLCQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:31:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYLCQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:31:50 -0500
Date: Wed, 3 Dec 2008 11:31:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
 output
In-Reply-To: <c62985530812030744p7c55bc69g251553f369c6fcf@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812031129260.29045@gandalf.stny.rr.com>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>  <20081203081906.GH21006@elte.hu>  <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>  <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>  <alpine.DEB.1.10.0812030821050.29045@gandalf.stny.rr.com>
 <c62985530812030744p7c55bc69g251553f369c6fcf@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> A proposition about this. I want to use __ftrace_printk, make it
> generic for both function tracers and have a way to store the current
> depth.
> One solution: changing the print_entry to have the ip available for
> function-tracer and depth available for return-function_tracer.
> 
> struct print_entry {
> 	struct trace_entry	ent;
>         union {
> 	    unsigned long	ip;
>             unsigned long       depth;
>         } from;
> 	char			buf[];
> };
> 
> We could make __ftrace_printk verify which tracer is running.
> 
> If normal tracer then
>      trace_vprintk(__builtin_return_address(0), .....)
> else if graph-tracer
>      trace_vprintk(current->curr_ret_stack, ......)
> 
> This way we can even forget the ip argument of __trace_printk.
> I prefer to ask before changing an exported symbol API....

Actually, I would prefer to keep both.

	struct print_entry {
		struct trace_entry	ent;
		unsigned long		ip;
		int			depth;
		char			buf[];
	};

And pass in both. Have the readers of the functions figure out what to do 
with either, and keep the messiness away from the API.

-- Steve

