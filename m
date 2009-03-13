Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZCMJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZCMJcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZCMJbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:31:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58843 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZCMJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:31:51 -0400
Message-ID: <18199AAD941A4071B7FD8A0D6C67733A@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Steven Rostedt ;" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
References: <49BA23D9.1050900@cn.fujitsu.com> <20090313092558.GD2571@elte.hu>
Subject: Re: [PATCH] ftrace: Avoid double-free of dyn_ftrace
Date: Fri, 13 Mar 2009 17:30:40 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2D9WMqu006570

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
>> If dyn_ftrace is free before ftrace_release(), 
>> ftrace_release() will free it again and make 
>> ftrace_free_records wrong.
>> 
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> ---
>>  kernel/trace/ftrace.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index d33d306..26c45aa 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
>>  
>>  mutex_lock(&ftrace_lock);
>>  do_for_each_ftrace_rec(pg, rec) {
>> - if ((rec->ip >= s) && (rec->ip < e))
>> + if ((rec->ip >= s) && (rec->ip < e) &&
>> +     !(rec->flags & FTRACE_FL_FREE))
>>  ftrace_free_rec(rec);
> 
> Applied to tip:tracing/ftrace, thanks!
> 
> I'm wondering, did you trigger this in practice (if yes, how?), 
> or have you found it via code review?
Hello, Ingo

It is found via code review.

B.R.
Zhaolei
> 
> Ingo
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
