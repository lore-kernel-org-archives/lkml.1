Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYLHOOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYLHOOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYLHOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:14:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYLHOOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:14:18 -0500
Date: Mon, 8 Dec 2008 15:14:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/function-graph-tracer: introduce
	__notrace_funcgraph to filter special functions
Message-ID: <20081208141406.GA14856@elte.hu>
References: <4939E600.804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939E600.804@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: trace more functions
> 
> When the function graph tracer is configured, three more files are not 
> traced to prevent only four functions to be traced. And this impacts 
> the normal function tracer too.
> 
> arch/x86/kernel/process_64/32.c:
> 
> I had crashes when I let this file traced. After some debugging, I saw 
> that the "current" task point was changed inside__swtich_to(), ie: 
> "write_pda(pcurrent, next_p);" inside process_64.c Since the tracer 
> store the original return address of the function inside current, we 
> had crashes. Only __switch_to() has to be traced.
> 
> kernel/module.c and kernel/extable.c:
> 
> Because of a function used internally by the function graph tracer: 
> __kernel_text_address()
> 
> To let the other functions inside these files to be traced, this patch 
> introduces the __notrace_funcgraph function prefix which is __notrace 
> if function graph tracer is configured and nothing if not.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/function-graph-tracer, thanks Frederic!

[ one small request: would it be possible to include the diffstat in the 
  patches you send? If you use git-diff then it's the --patch-with-stat 
  option. ]

	Ingo
