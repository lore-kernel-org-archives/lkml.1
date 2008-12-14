Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYLNRw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYLNRw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYLNRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:52:49 -0500
Received: from mail-qy0-f22.google.com ([209.85.221.22]:53397 "EHLO
	mail-qy0-f22.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLNRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:52:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qpICnjcgOqyl5kx3g717LvbgwaBTiEzRswwPw2kKH41HzWzZPM8jXtd91f8S9ZOpXn
         680/SMJP0+pR51DV4hf4l1dgarr0UaWYe+yNy4Q/LebWJLPLnSpDGWcgt6ItliD6/RpU
         Qx+511w3B8INwoZf0KAdvggc0uElL1oHvMSP0=
Message-ID: <c62985530812140952q7874046dl19c6f9e62cefc0b5@mail.gmail.com>
Date: Sun, 14 Dec 2008 18:52:46 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/ftrace: add the printk-msg-only option
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812141200230.20467@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49440A75.301@gmail.com>
	 <alpine.DEB.1.10.0812141200230.20467@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/14 Steven Rostedt <rostedt@goodmis.org>:
>
> On Sat, 13 Dec 2008, Frederic Weisbecker wrote:
>
>> Impact: display ftrace_printk messages "as is"
>>
>> By default, ftrace_printk() messages find their output with some other
>> informations like pid, caller, ...
>> Sometimes a developer just want to have the ftrace_printk left "as is", without
>> other information.
>>
>> This is done by providing a default-off option called printk-msg-only.
>> To enable it, just do `echo printk-msg-only > /debugfs/tracing/trace_options`
>>
>> Before the patch:
>>
>>            <...>-2739  [000]   145.692153: __might_sleep: I'm an ftrace_printk msg in __might_sleep
>>            <...>-2739  [000]   145.692155: __might_sleep: I'm another ftrace_printk msg in __might_sleep
>>
>> After the patch and the printk-msg-only option enabled:
>>
>> I'm an ftrace_printk msg in __might_sleep
>> I'm another ftrace_printk msg in __might_sleep
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 8fd3c5a..cd4dbf2 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -287,6 +287,7 @@ static const char *trace_options[] = {
>>       "annotate",
>>       "userstacktrace",
>>       "sym-userobj",
>> +     "printk-msg-only",
>
> Hmm, I'm a bit apprehensive about this approach. We are adding a lot of
> options that I'm not sure will be used. Is this needed because you added a
> ftrace printk that you want to not have the header, or because there are
> ftrace printks that exist that you want to turn on and off. Or perhaps,
> you want to see the header sometimes and sometimes you do not?
>
> If it is the later two, then sure we could have this option. But if it is
> the former, then we probably should have another type of ftrace_printk
> that takes an option to make another event type to tell the output not to
> print?
>
> Oh well, I have patches in mind to clean up the output code anyway.
>
> -- Steve
>

Actually, it's not for my needs but Ingo requested it to have only the
message output without
the headers while debugging with ftrace_printk.
