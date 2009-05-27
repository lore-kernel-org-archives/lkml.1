Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbZE0Hn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbZE0Hn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbZE0Hij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763993AbZE0Hii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:38 -0400
Message-ID: <4A1CEE27.3010805@cn.fujitsu.com>
Date: Wed, 27 May 2009 15:39:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 2/3] ftrace: add tracepoint for hrtimer
References: <4A16764F.2040307@cn.fujitsu.com> <alpine.LFD.2.00.0905262340510.1762@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905262340510.1762@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Fri, 22 May 2009, Xiao Guangrong wrote:
>> +TRACE_EVENT(hrtimer_start,
>> +
>> +	TP_PROTO(struct hrtimer *timer),
>> +
>> +	TP_ARGS(timer),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( void *,	timer		)
>> +		__field( void *,	function	)
>> +		__field( s64,		expires		)
>> +		__field( s64,		softexpires	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->timer		= timer;
>> +		__entry->function	= timer->function;
>> +		__entry->expires	= ktime_to_ns(hrtimer_get_expires(timer));
>> +		__entry->softexpires	= ktime_to_ns(hrtimer_get_softexpires(timer));
>> +	),
> 
>   Yuck, we really do not want expensive conversions in the fast
>   path. This can be done by printk or user space tools.
> 

Yes, you are right. I'will correct it.

>> @@ -1119,6 +1122,7 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
>>  {
>>  	debug_hrtimer_init(timer);
>>  	__hrtimer_init(timer, clock_id, mode);
>> +	trace_hrtimer_init(timer, clock_id, mode);
> 
>   The comments I made about the timer.c tracepoints vs. debugobjects
>   apply here as well.
> 
> Thanks,
> 
> 	tglx
> 
> 
