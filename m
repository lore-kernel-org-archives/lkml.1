Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZGGJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZGGJ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZGGJ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:28:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZGGJ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:28:12 -0400
Message-ID: <4A531532.4010803@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 17:28:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ftrace: add tracepoint for timer
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C653.4040401@cn.fujitsu.com> <alpine.LFD.2.00.0907062140010.19480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907062140010.19480@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Mon, 6 Jul 2009, Xiao Guangrong wrote:
>> Changelog v1->v2:
>> 1: Add jiffies info into timer
>> 2: Combine debugobjects and trace as Thomas's suggestion
> 
> I like it that way. Some minor nitpicks below.
>  
>> +TRACE_EVENT(timer_expire,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,	function	)
> 
>   Do we really need the function here? It does not change between
>   start and expiry.
> 

Yeah, I'll fix.

>> +TRACE_EVENT(timer_cancel,
>> +
>> +	TP_PROTO(struct timer_list *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,	function	)
> 
>   Ditto.
> 

Will fix.

>> +
>> +static inline void debug_and_trace_timer_expire(struct timer_list *timer)
> 
>   Technically not really necessary. The debug code does not care about
>   it.
> 

Will fix.

>>  			timer = list_first_entry(head, struct timer_list,entry);
>> +			debug_and_trace_timer_expire(timer);
>>  			fn = timer->function;
>>  			data = timer->data;
>>  
> 
> Can you please add the tracepoint which was suggested by Anton (IIRC)
> which allows us to measure the execution time of the callback function
> ? There is no need to dereference timer in the expiry tracepoint, we
> just store the pointer. So we can safely move the tracepoints just
> around the function call.
> 
>    trace_timer_expire(timer);
>    fn(data);
>    trace_timer_callback_done(timer);
> 
> Or whatever fancy name you come up with.
> 

OK, I'll fix it base on your suggestion.
 
trace_timer_expire/trace_timer_callback_done are already in Frederic' tree
but with different name, see below URL:
 	http://marc.info/?l=linux-kernel&m=124331396919301&w=2
 
I'll modify those tracepoint's name to match ours.
 
Thank you very much!
 
Xiao

> 
> 	tglx
> 
> 
