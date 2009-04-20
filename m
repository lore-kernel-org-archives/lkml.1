Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZDTBal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZDTBal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZDTBac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:30:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52586 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDTBab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:30:31 -0400
Message-ID: <8B355A33A87242028FF3EF61F39BDFB8@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueuetracepoints use TRACE_EVENT macro
Date: Mon, 20 Apr 2009 09:30:03 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3K1Ujqu011102

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
>> +TRACE_EVENT(workqueue_insertion,
>> +TRACE_EVENT(workqueue_execution,
>> +TRACE_EVENT(workqueue_creation,
>> +TRACE_EVENT(workqueue_destruction,
> 
> I'm missing all the worklet tracepoints i suggested. (and i think 
> which you had in earlier versions)
> 
> Basically, i'd suggest the following complete set of events instead:
> 
> TRACE_EVENT(workqueue_create
> TRACE_EVENT(workqueue_flush              /* NEW */
> TRACE_EVENT(workqueue_destroy
> 
> TRACE_EVENT(worklet_enqueue              /* NEW */
> TRACE_EVENT(worklet_enqueue_delayed      /* NEW */
> 
> TRACE_EVENT(worklet_execute              /* instead of workqueue_execution */
> TRACE_EVENT(worklet_complete             /* NEW */
> 
> TRACE_EVENT(worklet_cancel               /* NEW */
> 
> This allows the understanding of the life cycle of a workqueue and 
> of worklets that enter that workqueue. Note the distinction between 
> workqueue and worklet (work) - that is essential.
Hello, Ingo

Thanks for your suggest.
I read distinction between workqueue and worklet.
In my schedule, this patch is first step of our target, my image of steps is:
  1: Move current workqueuetracepoints into TRACEEVENT (this patch)
  2: Make workqueuetrace support per-worklet output (doing)
  3: Add time information to workqueuetrace's worklet stat (need above new TRACEPOINT)

So, i prepared to add new worklet tracepoints in step3.
What's your opinion?

Thanks
Zhaolei
> 
> The parameters of the events are obvious, with one detail: i'd 
> suggest a 'cpu' parameter to the enqueue events, to allow the 
> mapping of the _on(..cpu) variants too.
> 
> I would not bother with schedule_on_each_cpu() instrumentation - 
> it's rarely used.
> 
> Ingo
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
