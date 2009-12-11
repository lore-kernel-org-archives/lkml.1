Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbZLKEkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbZLKEkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZLKEkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:40:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbZLKEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:37:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=_cG03E38plRnBDtgQpoA:9 a=0dO0sVypdoL8blQtEaZTvRfsGckA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: dynamic ftrace - graph
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4AF848C0.7010807@monstr.eu>
References: <4AF848C0.7010807@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 23:37:05 -0500
Message-ID: <1260506225.2146.347.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Sorry for such a late reply, you sent this email to me at the worst
time. My wife was having shoulder surgery and I heading for a
conference. I fell very far behind in email and I only now just noticed
this.


I'll answer these ever though you may already figured it out.

On Mon, 2009-11-09 at 17:52 +0100, Michal Simek wrote:
> Hi Steve and others,
> 
> I have working dynamic ftrace function. :-)
> 
> I look at __ftrace_modify_code function and I have one question about.
> Below are function which are called when I enable function_graph.
> 
> I personally think that make more sense to call 
> ftrace_enable_ftrace_graph_caller before ftrace_update_ftrace_func.
> The reason for it is that graph_caller enable calling graph tracing 
> which should be setup before ftrace_update_ftrace_func which enable 
> whole tracing function.

Have you seen any difference in output with this?

I never thought about this order too much.

-- Steve

> 
> 
> 
> # cd ; mkdir /debug; mount -t debugfs none /debug; cat 
> /debug/tracing/available_tracers; echo function_graph > 
> /debug/tracing/current_tracer;echo 0 > /debug/tra
> cing/tracing_enabled;cat /debug/tracing/trace | head -n 10
> function_graph function sched_switch nop
> 
> ftrace_update_ftrace_func 0xc0009100 0xc00091c4, 0xb000c000, 0x32809100
> ftrace_enable_ftrace_graph_caller
> # tracer: function_graph
> 
> 
> For disabling graph trace is sequence ok I think.
> 
> # echo function > /debug/tracing/current_tracer
> ftrace_disable_ftrace_graph_caller
> ftrace_update_ftrace_func 0xc006afe4 0xc00091c4, 0xb000c006, 0x3280afe4
> 
> 
> What do you think?
> 
> Thanks,
> Michal
> 
> 


