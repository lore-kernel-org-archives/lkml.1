Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZCRDih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZCRDih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZCRDi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:38:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZCRDi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:38:27 -0400
Message-ID: <73A3CDD08FF1439AA767D691B6F67845@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
References: <1237239660-6342-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903161808530.5094@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing/ftrace: fix the check on nopped sites
Date: Wed, 18 Mar 2009 11:37:15 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2I3cdqu003016

* From: "Steven Rostedt" <rostedt@goodmis.org>
> 
> 
> On Mon, 16 Mar 2009, Frederic Weisbecker wrote:
> 
>> Impact: fix a dynamic tracing failure
>> 
>> Recently, the function and function graph tracers failed to use dynamic
>> tracing after the following commit:
>> 
>> fa9d13cf135efbd454453a53b6299976bea245a9
>> (ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec)
>> 
>> The patch is right except a mistake on the check for the FTRACE_FL_CONVERTED
>> flag. The code patching is aborted in case of successfully nopped sites.
>> What we want is the opposite: ignore the callsites that haven't been nopped.
>> 
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/ftrace.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 90d5729..7847806 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -537,7 +537,7 @@ static void ftrace_replace_code(int enable)
>>  */
>>  if (rec->flags & FTRACE_FL_FREE ||
>>      rec->flags & FTRACE_FL_FAILED ||
>> -     rec->flags & FTRACE_FL_CONVERTED)
>> +     !(rec->flags & FTRACE_FL_CONVERTED))
>>  continue;
>>  
>>  /* ignore updates to this record's mcount site */
>> -- 
Hello, 

Sorry for my fault.

B.R.
Zhaolei
> 
> Heh, I just found this bug too, and wrote a patch. But you posted before I 
> did, so I'll let you have it ;-)
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> -- Steve
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
