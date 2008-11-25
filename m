Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbYKYQCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbYKYQCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYKYQBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:01:54 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:45153 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYKYQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YFuMuKZdJki4TIEYlJfjIptvNEibi3SjJNbavq0Ep6ugwa0ctiwtDIl1WeOxZ8isO2
         se+/Y4CAFnleqnmFNyytm/OSCMuaWATiNRbkR77nN+ZYUhN0OJfnj0byF4/+xbi20ns4
         2Kgrud4LyY1w1k5euSJa9FjDGg6jkh8AVkAlE=
Message-ID: <c62985530811250801u5429a346p1df8160b57b69a3e@mail.gmail.com>
Date: Tue, 25 Nov 2008 17:01:50 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Human readable output for function return tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081125155631.GA22006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124162719.GA11532@elte.hu>
	 <c62985530811250718q3aa5f2ednd795b7c927abb8e4@mail.gmail.com>
	 <20081125153653.GA21001@elte.hu> <20081125154054.GA21493@elte.hu>
	 <20081125155631.GA22006@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>> > > Do you agree with "full function tracer" (since we hook now on the
>> > > two sides)?
>> >
>> > "full function tracer" sounds a bit funny and quirky. How about
>> > "function call tracer"? Versus the "function tracer" or "function
>> > entry tracer" which is the lighter variant - both in name and in
>> > overhead. So we'd have:
>> >
>> >  # cat /debug/tracing/available_tracers
>> >  mmiotrace wakeup irqsoff function function-call sysprof sched_switch initcall nop
>> >
>> > note how intuitive it is: "function-call" is 'more' than just the
>> > plain function-tracer. It also expresses its main property: it
>> > traces the full call, entry and exit and return code as well.
>>
>> another similar naming would be: the "function-graph" tracer.
>> function-callgraph would be too long.
>
> Steve thinks function-graph is even more expressive, so lets go with
> that instead :)
>
> it will certainly make sure there's no misunderstanding about the role
> and scope of this tracer, and it's short and expressive as well.
>
> so i'd suggest the following sed -i rules:
>
>  s/FUNCTION_RET_TRACER/FUNCTION_GRAPH_TRACER/g
>
> i'd suggest to keep the ret_stack names - those are proper. (the thing
> that is used to construct the graph is the return stack)
>
> also, please do:
>
>   git mv kernel/tracing/trace_functions_return.c kernel/tracing/trace_functions_graph.c
>
> and Makefile glue fixup:
>
>   s/functions_return/functions_graph/g
>
>        Ingo
>

Ok, and perhaps even several structures and functions.... There are
some in trace_functions_return.c, arch/x86/kernel/ftrace.c,
kernel/trace/ftrace.c
Some of them which act very close to "return hooking" should keep
their name, but for some others, I should put the graph semantics....
