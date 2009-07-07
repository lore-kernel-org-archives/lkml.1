Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZGGJaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZGGJaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZGGJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:30:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZGGJaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:30:04 -0400
Message-ID: <4A5315A4.9080405@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 17:30:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com> <alpine.LFD.2.00.0907062104240.19480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907062104240.19480@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for your review.

Thomas Gleixner wrote:
> On Mon, 6 Jul 2009, Xiao Guangrong wrote:
>> +TRACE_EVENT(itimer_state,
>> +
>> +	TP_PROTO(int which, struct itimerval *value, cputime_t expires),
>> +
>> +	TP_ARGS(which, value, expires),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	int,		which		)
>> +		__field(	void *,		timer		)
>> +		__field(	int,		state		)
>> +		__field(	cputime_t,	expires		)
>> +		__field(	long,		value_sec	)
>> +		__field(	long,		value_usec	)
>> +		__field(	long,		interval_sec	)
>> +		__field(	long,		interval_usec	)
>> +		__string(	comm,		current->comm	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->which		= which;
>> +		__entry->timer		= which == ITIMER_REAL ?
>> +						&current->signal->real_timer : NULL;
> 
>   Why do we need this information at all ? There is no value in the
>   address of real_timer AFAICT.
>   

Thanks for your review. I'll send a new patch with your comments addressed.
