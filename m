Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYLBIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYLBIXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYLBIXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:23:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYLBIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:23:42 -0500
Date: Tue, 2 Dec 2008 09:23:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] function trace: fix a bug of single thread
	function trace
Message-ID: <20081202082337.GB5424@elte.hu>
References: <1228185188-10422-1-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228185188-10422-1-git-send-email-liming.wang@windriver.com>
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


* Liming Wang <liming.wang@windriver.com> wrote:

> Impact: fix a bug in ftrace_update_pid_func
> 
> When disabling single thread function trace using
> "echo -1 > set_ftrace_pid", the normal function trace
> has to restore to original function, otherwise the normal
> function trace will not work well.
> Without this commit, something like below:
> 
> 	$ ps |grep 850
> 	  850 root      2556 S    -/bin/sh
> 	$ echo 850 > /debug/tracing/set_ftrace_pid
> 	$ echo function > /debug/tracing/current_tracer
> 	$ echo 1 > /debug/tracing/tracing_enabled
> 	$ sleep 1
> 	$ echo 0 > /debug/tracing/tracing_enabled
> 	$ cat /debug/tracing/trace_pipe |wc -l
> 	59704
> 	$ echo -1 > /debug/tracing/set_ftrace_pid
> 	$ echo 1 > /debug/tracing/tracing_enabled
> 	$ sleep 1
> 	$ echo 0 > /debug/tracing/tracing_enabled
> 	$ more /debug/tracing/trace_pipe
> 		<====== nothing output now!
> 			it should output trace record.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  kernel/trace/ftrace.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

applied to tip/tracing/ftrace, thanks!

	Ingo
