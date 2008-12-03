Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLCINY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLCINY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYLCINQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:13:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLCINP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:13:15 -0500
Date: Wed, 3 Dec 2008 09:13:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: function graph return for function entry
Message-ID: <20081203081301.GF21006@elte.hu>
References: <20081203045001.367443457@goodmis.org> <20081203045044.002248353@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203045044.002248353@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: feature, let entry function decide to trace or not
> 
> This patch lets the graph tracer entry function decide if the tracing 
> should be done at the end as well. This requires all function graph 
> entry functions return 1 if it should trace, or 0 if the return should 
> not be traced.

> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 47aa5f0..cef05a2 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -119,6 +119,9 @@ ENTRY(mcount)
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	cmpq $ftrace_stub, ftrace_graph_return
>  	jnz ftrace_graph_caller
> +
> +	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
> +	jnz ftrace_graph_caller

hm, that's in the hotpath. What's the point of this? Do we want some sort 
of configuration vector that allows per function graphing versus 
entry-only traces?

	Ingo
