Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYKWQLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYKWQLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKWQLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:11:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:36143 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYKWQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dnK2lcDdkcf/4H4F5+uejRWXefe9FjHMk3drufP21wfMVkRSKo/zUYj1CvklzTIquJ
         kaEXrux9q97pieT+zh6lq5tCo2LJbsK4hr45g4L0sTSI1w+Y9fNsyRKX2QDmNXeIShes
         Drll25r78VC54iUy32tHHdhz+OaKcHvBVpR0w=
Message-ID: <c62985530811230811q633349e5neb79fb6841c642ff@mail.gmail.com>
Date: Sun, 23 Nov 2008 17:11:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-return-tracer: clean up task start/exit callbacks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081123082132.GB30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4928E8B0.1090103@gmail.com> <20081123082132.GB30453@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/23 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: use deeper tracing depth safely
>>
>> Some tests showed that function return tracing needed a more deeper depth
>> of function calls. But it could be unsafe to store these return addresses
>> to the stack.
>> So these arrays will now be allocated dynamically into task_struct of current
>> only when the tracer is activated.
>>
>> Typical scheme when tracer is activated:
>> _ allocate a return stack for each task in global list.
>> _ fork: allocate the return stack for the newly created task
>> _ exit: free return stack of current
>> _ idle init: same as fork
>>
>> I chose a default depth of 50. I don't have anymore overruns (didn't tested for
>> a long time).
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  arch/x86/include/asm/ftrace.h      |    1 -
>>  arch/x86/include/asm/thread_info.h |   29 -----------
>>  arch/x86/kernel/ftrace.c           |   29 ++++++-----
>>  include/linux/ftrace.h             |    5 ++
>>  include/linux/sched.h              |   23 ++++-----
>>  kernel/exit.c                      |    5 ++-
>>  kernel/fork.c                      |    4 ++
>>  kernel/sched.c                     |    3 +
>>  kernel/trace/ftrace.c              |   96 +++++++++++++++++++++++++++++++++++-
>>  9 files changed, 137 insertions(+), 58 deletions(-)
>
> nice! Applied to tip/tracing/function-return-tracer and i started
> testing it as well.
>
> I've done the small cleanup below on top of your patch - we try to
> avoid #ifdefs in core kernel code as much as possible, by hiding
> .config details into include files.
>
>        Ingo

Ok thanks!
