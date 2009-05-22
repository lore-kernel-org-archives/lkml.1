Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZEVAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZEVAoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZEVAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:44:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZEVAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:44:14 -0400
Message-ID: <B831A92AD5954A1582BE0215D2DD4FE7@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Tom Zanussi" <tzanussi@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4A153345.3040905@cn.fujitsu.com> <20090521130528.GA14149@redhat.com>
Subject: Re: [PATCH] tracing/workqueue: Get rid of searching last executedworklet in probe_worklet_complete()
Date: Fri, 22 May 2009 08:42:44 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4M0iZlL028317

* From: "Oleg Nesterov" <oleg@redhat.com>
> On 05/21, Zhaolei wrote:
>>
>> We don't need search workqueue's worklet list for worklet which was latest
>> executed, instead, we can use a pointer in cpu_workqueue_stats to remember
>> which worklet was just executed.
> 
> Minor nit,
> 
>> @@ -192,22 +192,11 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
>>  goto end;
>>
>>  found_wq:
>> - list_for_each_entry(wfnode, &node->workfunclist, list) {
>> - u64 executed_time;
>> + executed_time = trace_clock_global() - node->last_workfunc->start_time;
>> + node->last_workfunc->total_time += executed_time;
> 
> Suppose that "enqueue" handler fails to allocate the memory for the new
> work_struct.
> 
> This means that the "execute" handler does not record ->last_workfunc.
> 
> In that case probe_worklet_complete() uses the wrong workfunc_stats or
> we can even crash if ->last_workfunc == NULL.
> 
> I think _execute() should set ->last_workfunc = NULL first, then serach
> for wfnode. _complete() should check ->last_workfunc != NULL and return
> if it is NULL.
Hello, Oleg

Thanks!
You are right, I will send v2 to fix this.

Zhaoleiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
