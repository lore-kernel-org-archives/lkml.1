Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYF0T36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYF0T36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbYF0T3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:29:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:48038 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbYF0T3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kpTZLGoqgjYcsGwj5jzIiK+HTTnYZytnL2c5Y8sA56ySJyLOdUa67koP30o05iHOP4
         DMKgFwZdTxRtmqTrRDe7eiCtJ6mkUO4HtmoZQQ2eMtYeQVT9yZAyJeZOd0B5U2iLPwQz
         yG2fPF94pBJPB6WlFUCZH8Q3eclFKycaddQFw=
Message-ID: <19f34abd0806271229v6119e6f8ub9fb1b6e231abebf@mail.gmail.com>
Date: Fri, 27 Jun 2008 21:29:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RESEND][PATCH 1/2] stacktrace: add saved stack traces to backtrace self-test
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080627192055.GA8435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627160448.GB8852@damson.getinternet.no>
	 <20080627160821.GA30232@elte.hu> <20080627192055.GA8435@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 9:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> FYI, it needed the fixlet below.
>
>        Ingo
>

Oh. I'm sorry :-(

(I'll admit that I've never worked with modules before. I'll try to
remember now.)

> ------------->
> commit 7bcebd2e3ee8435e2ff0f674a409f46961fda3cc
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jun 27 21:20:17 2008 +0200
>
>    stacktrace: export print_stack_trace and save_stack_trace
>
>    fix:
>
>    ERROR: "print_stack_trace" [kernel/backtracetest.ko] undefined!
>    ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>    Conflicts:
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
> index c28c342..b7b483b 100644
> --- a/arch/x86/kernel/stacktrace.c
> +++ b/arch/x86/kernel/stacktrace.c
> @@ -74,10 +74,4 @@ void save_stack_trace(struct stack_trace *trace)
>        if (trace->nr_entries < trace->max_entries)
>                trace->entries[trace->nr_entries++] = ULONG_MAX;
>  }
> -
> -void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
> -{
> -       dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
> -       if (trace->nr_entries < trace->max_entries)
> -               trace->entries[trace->nr_entries++] = ULONG_MAX;
> -}

Why is this removed, though? (It seems unrelated, and that's a useful function.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
