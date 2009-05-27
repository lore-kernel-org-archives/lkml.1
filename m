Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbZE0Hoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbZE0Hoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764056AbZE0Hjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:39:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50847 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1764096AbZE0Hjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:39:36 -0400
Message-ID: <4A1CEE62.7020305@cn.fujitsu.com>
Date: Wed, 27 May 2009 15:40:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 3/3] ftrace: add tracepoint for itimer
References: <4A16767D.8030907@cn.fujitsu.com> <alpine.LFD.2.00.0905262344160.1762@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905262344160.1762@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Fri, 22 May 2009, Xiao Guangrong wrote:
>> +TRACE_EVENT(itimer_start,
>> +
>> +	TP_PROTO(int which, struct itimerval *value),
>> +
>> +	TP_ARGS(which, value),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	int,			which		)
>> +		__field(	unsigned long long,	it_value	)
>> +		__field(	unsigned long long,	it_interval	)
>> +		__string(	comm,   		current->comm   )
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->which		= which;
>> +		__entry->it_value	= (which == ITIMER_REAL ?
>> +			ktime_to_ns(timeval_to_ktime(value->it_value)) :
>> +			timeval_to_cputime(&value->it_value));
>> +		 __entry->it_interval 	= (which == ITIMER_REAL ?
>> +			ktime_to_ns(timeval_to_ktime(value->it_interval)) :
>> +			timeval_to_cputime(&value->it_interval));
>> +		__assign_str(comm, current->comm);
>> +	),
> 
>   Again, conversion of raw values needs to be done when we analyse the
>   trace and not in the fast path.
> 

OK 

> ....
> 
>> +		} else{
>   
>   } else {
> 
>   please
>>  			tsk->signal->it_real_incr.tv64 = 0;
>> +			trace_itimer_cancel(ITIMER_REAL);
>> +		}
>>  
>>  		spin_unlock_irq(&tsk->sighand->siglock);
>>  		break;
>> @@ -186,7 +191,10 @@ again:
>>  						   jiffies_to_cputime(1));
>>  			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
>>  					      &nval, &cval);
>> -		}
>> +			trace_itimer_start(ITIMER_VIRTUAL, value);
>> +		}else
> 
>   Please run your patches through checkpatch.pl
> 

Thank for you advice.

> Thanks,
> 
> 	tglx
> 
> 
