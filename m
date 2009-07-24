Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZGXJkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZGXJkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZGXJkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:40:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55707 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZGXJko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:40:44 -0400
Message-ID: <4A698195.3020504@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 17:40:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
References: <4A604E46.5050903@cn.fujitsu.com>	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>	 <4A641BFC.2050508@cn.fujitsu.com> <1248091771.15751.8578.camel@twins>	 <4A66DDB6.4000700@cn.fujitsu.com> <1248257598.27058.1227.camel@twins>	 <4A6834EA.3070303@cn.fujitsu.com> <1248343661.27058.1722.camel@twins>
In-Reply-To: <1248343661.27058.1722.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Thu, 2009-07-23 at 18:01 +0800, Xiao Guangrong wrote:
>> Peter Zijlstra wrote:
>>
>>> OK, so what you want to measure is the time of the actual callback
>>> happening (hrtimer_entry) vs that where you would have expected it to
>>> happen (hrtimer_start + delay), right?
>>>
>> Yes
>>
>>> So what's wrong with printing the expected expiration time in the
>>> hrtimer_start tracepoint in the cheap clock units?
>>>
>> Is "cheap clock units" means jiffies time?
> 
> Nah, something like cpu_clock() which is monotonic per-cpu and should
> have high resolution where available.
> 

Hi Peter,

Thanks for your valuable suggestion.

I have do some test for it, and it very suitable for CLOCK_MONOTONIC clock,
but if the hrtimer's clock is CLOCK_REALTIME, however xtime is needed to get
the real time.

In addition, it make TP_fast_assign() become a slow path, we should avoid it
if possible.

Thanks,
Xiao

> 
