Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZEYD4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZEYD4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZEYD4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:56:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57624 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZEYD4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:56:01 -0400
Message-ID: <8F90215D2B2846BDBCD0FACB72CD2B6C@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Tom Zanussi" <tzanussi@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <4A1678F1.1060706@cn.fujitsu.com> <20090524204240.GB6471@nowhere>
Subject: Re: [PATCH v2 1/2] ftrace: Add task_comm support for trace_event
Date: Mon, 25 May 2009 11:54:27 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n4P3uM7M026691

* From: "Frederic Weisbecker" <fweisbec@gmail.com>
> Hi,
> 
> 
> On Fri, May 22, 2009 at 06:05:37PM +0800, Zhaolei wrote:
>> If we use trace_event alone(without function trace, .etc),
>> it can't output enough task command information.
>> 
>> Before patch:
>>  # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
>>  # cat debugfs/tracing/trace
>>  # tracer: nop
>>  #
>>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>>  #              | |       |          |         |
>>             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>>             <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
>>             <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>>             <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
>>            <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>>             <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
>>  ...
>> 
>> After patch:
>>  # tracer: nop
>>  #
>>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>>  #              | |       |          |         |
>>              bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>>              sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
>>              bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>>              sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
>>            <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>>          events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
>>  ...
>> 
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> 
> Thanks!
> This is fine but I think it can be factorized.
> 
> You could call start_cmdline_record() from
> 
> ftrace_raw_reg_event_##call()
> 
> and the stop in
> 
> ftrace_raw_unreg_event_##call()
> 
> No?

Hello, Frederic

Thanks for your advice.

Actually, I considered to put start_cmdline_record() into ftrace_raw_reg_event_##call(),
but finally I selected to put it into tracing_start_cmdline_record().

IMHO, we have following reason:
1: It can make source more readable.
   Read function is more easy than read macro.
2: These two way have same performance.
3: Put start_cmdline_record() into ftrace_event_enable_disable() will reduce
   binary file size than ftrace_raw_reg_event_##call().

So I think put start_cmdline_record() into ftrace_event_enable_disable() maybe better.

What is your opinion?

Thanks
Zhaolei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
