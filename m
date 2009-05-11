Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZEKH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZEKH2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZEKH2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:28:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61167 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZEKH2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:28:05 -0400
Message-ID: <4A07D3B3.10605@cn.fujitsu.com>
Date: Mon, 11 May 2009 15:28:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for	__raise_softirq_irqoff()
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal>
In-Reply-To: <20090505161604.GA15524@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mathieu Desnoyers wrote:
> * Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
>> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>>

>> +#ifdef CONFIG_TRACEPOINTS
>> +extern void __raise_softirq_irqoff(unsigned int nr);
>> +#else
>>  #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
> 
> Can you put the 
> 	trace_irq_softirq_raise(nr);
> 
> directly in the define rather than adding this weird CONFIG_TRACEPOINTS?
> (and change the define for a static inline), something like :
> 
> static inline void __raise_softirq_irqoff(unsigned int nr)
> {
> 	trace_irq_softirq_raise(nr);
> 	or_softirq_pending(1UL << (nr);
> }
> 
> This would ensure we don't add a function call on the
> __raise_softirq_irqoff() fast-path.
> 

We did this in v2, and we think it is better for same reason.
But ...

> Beware of circular include dependencies though. The tracepoints are
> meant not to have this kind of problems (I try to keep the dependencies
> very minimalistic), but I wonder if Steven's TRACE_EVENT is now ok on
> this aspect.
> 

We encount this type of problem in v2.
So we move to this version(v3).

> If TRACE_EVENT happens to pose problems with circular header
> dependencies, then try moving to the DECLARE_TRACE/DEFINE_TRACE scheme
> which has been more thoroughly tested as a first step.
> 

IMHO, TRACE_EVENT framework is better for its more generic as ingo said,
and it also provide ftrace support which means user can view tracepoint
information from /debug/tracing/events.

Although this TRACE_EVENT happens to expose problems with circular header
dependencies, we should not refuse using TRACE_EVENT, instead we should
try to fix it for the whole TRACE_EVENT facility later.

Thanks

> Mathieu
> 
