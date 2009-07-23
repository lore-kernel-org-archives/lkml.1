Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZGWKB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZGWKB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGWKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:01:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60479 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGWKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:01:26 -0400
Message-ID: <4A6834EA.3070303@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 18:01:14 +0800
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
References: <4A604E46.5050903@cn.fujitsu.com>	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>	 <4A641BFC.2050508@cn.fujitsu.com> <1248091771.15751.8578.camel@twins>	 <4A66DDB6.4000700@cn.fujitsu.com> <1248257598.27058.1227.camel@twins>
In-Reply-To: <1248257598.27058.1227.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:

> OK, so what you want to measure is the time of the actual callback
> happening (hrtimer_entry) vs that where you would have expected it to
> happen (hrtimer_start + delay), right?
> 

Yes

> So what's wrong with printing the expected expiration time in the
> hrtimer_start tracepoint in the cheap clock units?
> 

Is "cheap clock units" means jiffies time?

If so, we need to convert "expire time" into jiffies time, but
I searched ways for this type of converting but found nothing.

I'm afraid it's hard to do as below example:
  insmod-3821  [001]  3192.239335: hrtimer_start: timer=d08a1480  expires=1245162841000000000 ns
  <idle>-0     [001]  3201.506127: hrtimer_expire: timer=d08a1480

We can't convert 1245162841000000000ns to jiffies if we don't know
the xtime/wall_to_monotonic at hrimter_start.
And the expire time that got by _start() maybe wrong because user
can change time of day between hrtimer_start() and hrtimer_expire().

What your opinion?

> 
> 
> 
