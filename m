Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZHGMPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZHGMPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbZHGMPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:15:46 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:51432 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZHGMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:15:45 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 08:15:45 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ujuWL4XVxjPh8B78x7bV96+/VJUyJ14pQMUhBva+P8TwnbZT8ttAyOYgjHkd75y4FT
         5l2T9nyKSqb7dhKcLH7/eFpAM+1ZQfZ4WeJ+d8yhpe1RL/f9haTz77BN05WlQO4vg2qw
         tPOhb1bDzP/HA7gg0wfOY/GPySopTsXJxv4j4=
Message-ID: <4A7C1979.9020508@gmail.com>
Date: Fri, 07 Aug 2009 20:09:29 +0800
From: Xiao Guangrong <ericxiao.gr@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ftrace: add tracepoint for timer
References: <4A7A4153.3040207@cn.fujitsu.com> <20090806024804.GB4685@kryten> <4A7A4C45.3040008@cn.fujitsu.com> <20090807105616.GA24916@elte.hu>
In-Reply-To: <20090807105616.GA24916@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Anton Blanchard wrote:
>>> Hi,
>>>
>>>> Example ftrace output:
>>>>   insmod-1712  [000]   145.901459: timer_init: timer=d0ace4b4
>>>>   insmod-1712  [000]   145.901469: timer_start: timer=d0ace4b4 func=timer_fun expires=4294813629 timeout=199
>>>>   <idle>-0     [000]   146.100230: timer_cancel: timer=d0ace4b4
>>>>   <idle>-0     [000]   146.100233: timer_expire: timer=d0ace4b4 jiffies=4294813629
>>>>   <idle>-0     [000]   146.100627: timer_callback_done: func=d0ace4b4
>>> Sorry I haven't followed the thread, but I was wondering why you 
>>> changed the name of the entry and exit tracepoints (ie 
>>> timer_entry/timer_exit).
>>>
>>> I think consistent naming is important to match the other static 
>>> tracepoints, such as softirq_entry/softirq_exit, 
>>> irq_entry/irq_exit and tasklet_entry/tasklet_exit.
>> I rename timer_entry/timer_exit to 
>> timer_expire/timer_callback_done just to match this series:
>>
>> *_init() -> *_start() -> *_expire()...
>>
>> It's a complete timer's lifecycle.
> 
> timer _handler_ entry/exit is a pretty good lifecycle name as well - 
> and it nicely fits into the irq/softirq naming Anton mentioned. 
> Maybe this list:
> 

Hi Ingo,

Yeah, maybe you are right.
I'll fix those, or do you mind apply this patchset first and I'll send
a fix patch for those?

Thank you very much!
Xiao

>  timer_init
>  timer_start
>  timer_expire_entry
>  timer_expire_exit
>  timer_cancel
> 
> works for you Anton?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

