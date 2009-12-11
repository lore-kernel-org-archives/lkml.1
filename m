Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbZLKHac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbZLKHac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZLKHa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:30:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:21179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZLKHa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:30:28 -0500
Message-ID: <4B21F4F6.5080600@monstr.eu>
Date: Fri, 11 Dec 2009 08:29:58 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: Re: dynamic ftrace - graph
References: <4AF848C0.7010807@monstr.eu> <1260506225.2146.347.camel@gandalf.stny.rr.com>
In-Reply-To: <1260506225.2146.347.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Hi Michal,
> 
> Sorry for such a late reply, you sent this email to me at the worst
> time. My wife was having shoulder surgery and I heading for a
> conference. I fell very far behind in email and I only now just noticed
> this.

No problem. I prepared Microblaze ftrace patches. You can find them in 
linux-next. I am going to send pull request to Linus soon that's why if 
you have any your comments please let me know.

> 
> 
> I'll answer these ever though you may already figured it out.
> 
> On Mon, 2009-11-09 at 17:52 +0100, Michal Simek wrote:
>> Hi Steve and others,
>>
>> I have working dynamic ftrace function. :-)
>>
>> I look at __ftrace_modify_code function and I have one question about.
>> Below are function which are called when I enable function_graph.
>>
>> I personally think that make more sense to call 
>> ftrace_enable_ftrace_graph_caller before ftrace_update_ftrace_func.
>> The reason for it is that graph_caller enable calling graph tracing 
>> which should be setup before ftrace_update_ftrace_func which enable 
>> whole tracing function.
> 
> Have you seen any difference in output with this?

I haven't tested it. It was just suggestion. I don't know if is relevant 
or not.

Michal

> 
> I never thought about this order too much.
> 
> -- Steve
> 
>>
>>
>> # cd ; mkdir /debug; mount -t debugfs none /debug; cat 
>> /debug/tracing/available_tracers; echo function_graph > 
>> /debug/tracing/current_tracer;echo 0 > /debug/tra
>> cing/tracing_enabled;cat /debug/tracing/trace | head -n 10
>> function_graph function sched_switch nop
>>
>> ftrace_update_ftrace_func 0xc0009100 0xc00091c4, 0xb000c000, 0x32809100
>> ftrace_enable_ftrace_graph_caller
>> # tracer: function_graph
>>
>>
>> For disabling graph trace is sequence ok I think.
>>
>> # echo function > /debug/tracing/current_tracer
>> ftrace_disable_ftrace_graph_caller
>> ftrace_update_ftrace_func 0xc006afe4 0xc00091c4, 0xb000c006, 0x3280afe4
>>
>>
>> What do you think?
>>
>> Thanks,
>> Michal
>>
>>
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
