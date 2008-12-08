Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYLHPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYLHPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYLHPZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:25:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:36018 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYLHPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sZRzL/+YNtk5L0Bop0Ndh0Z7fqC+TjC9PJVlNdPvfccGngE3v0+TeqBCnjjQIPAad9
         zxZWJUrAn2N1Fx6Emr7UJXeQO2qbjrw1C2IZ7bnyLPEYyDqYGjCnnoU/3BJHVknsm2EO
         MD0tjUJyJt0hEvkqfvlSCSRjoTQ8xsx3ag8oE=
Message-ID: <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
Date: Mon, 8 Dec 2008 16:25:40 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/3] tracing/function-graph-tracer: introduce __notrace_funcgraph to filter special functions
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081208141406.GA14856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/8 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: trace more functions
>>
>> When the function graph tracer is configured, three more files are not
>> traced to prevent only four functions to be traced. And this impacts
>> the normal function tracer too.
>>
>> arch/x86/kernel/process_64/32.c:
>>
>> I had crashes when I let this file traced. After some debugging, I saw
>> that the "current" task point was changed inside__swtich_to(), ie:
>> "write_pda(pcurrent, next_p);" inside process_64.c Since the tracer
>> store the original return address of the function inside current, we
>> had crashes. Only __switch_to() has to be traced.
>>
>> kernel/module.c and kernel/extable.c:
>>
>> Because of a function used internally by the function graph tracer:
>> __kernel_text_address()
>>
>> To let the other functions inside these files to be traced, this patch
>> introduces the __notrace_funcgraph function prefix which is __notrace
>> if function graph tracer is configured and nothing if not.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> applied to tip/tracing/function-graph-tracer, thanks Frederic!

Thanks!

> [ one small request: would it be possible to include the diffstat in the
>  patches you send? If you use git-diff then it's the --patch-with-stat
>  option. ]


Ok.
BTW. I wanted to give a try on linux-next to test the last ftrace
stuffs, but the auto-ftrace-next branch
seems too much old. Are the auto branches updated every week or
something like this...?
