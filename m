Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZHFDWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZHFDWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZHFDWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:22:12 -0400
Received: from [222.73.24.84] ([222.73.24.84]:53084 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZHFDWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:22:11 -0400
Message-ID: <4A7A4C45.3040008@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 11:21:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ftrace: add tracepoint for timer
References: <4A7A4153.3040207@cn.fujitsu.com> <20090806024804.GB4685@kryten>
In-Reply-To: <20090806024804.GB4685@kryten>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Anton Blanchard wrote:
> Hi,
> 
>> Example ftrace output:
>>   insmod-1712  [000]   145.901459: timer_init: timer=d0ace4b4
>>   insmod-1712  [000]   145.901469: timer_start: timer=d0ace4b4 func=timer_fun expires=4294813629 timeout=199
>>   <idle>-0     [000]   146.100230: timer_cancel: timer=d0ace4b4
>>   <idle>-0     [000]   146.100233: timer_expire: timer=d0ace4b4 jiffies=4294813629
>>   <idle>-0     [000]   146.100627: timer_callback_done: func=d0ace4b4
> 
> Sorry I haven't followed the thread, but I was wondering why you changed
> the name of the entry and exit tracepoints (ie timer_entry/timer_exit). 
> 
> I think consistent naming is important to match the other static
> tracepoints, such as softirq_entry/softirq_exit, irq_entry/irq_exit and
> tasklet_entry/tasklet_exit.
> 

I rename timer_entry/timer_exit to timer_expire/timer_callback_done just to
match this series:

*_init() -> *_start() -> *_expire()...

It's a complete timer's lifecycle.

Thanks,
Xiao

> Anton
> 
> 
