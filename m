Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZCTDED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZCTDED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZCTDDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:03:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZCTDDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:03:51 -0400
Message-ID: <49C3078F.5090202@redhat.com>
Date: Thu, 19 Mar 2009 23:03:43 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 1/9] tracing: kprobe-tracer plugin core
References: <49C2B4AA.9050506@redhat.com> <20090320003533.GB6895@nowhere>
In-Reply-To: <20090320003533.GB6895@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Mar 19, 2009 at 05:10:02PM -0400, Masami Hiramatsu wrote:
[...]
>> +/* event recording functions */
>> +static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
>> +				struct pt_regs *regs)
>> +{
>> +	__trace_printk(ip, "%s%s%+ld\n",
>> +			probe_is_return(tp) ? "<-" : "@",
>> +			probe_symbol(tp), probe_offset(tp));
> 
> 
> Ah, it means we should implement a sort of trace_printk where
> we can put a custom ip.

Yeah, trace_printk() always shows this function address, instead of
probing address.

> Anyway I don't recommend you to use __trace_printk() because
> trace_printk() wrap it by doing some choices of implementation.
> 
> If the format is a builtin string like here, it will choose a binary
> insertion to the ring buffer (the format is not copied but only its address,
> and the arguments are inserted by their binary values). It is more lightweight
> and fast.
> 
> If you are using such builtin format, use __trace_bprintk instead.

Sure, I'll try to use it.

Thanks!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

