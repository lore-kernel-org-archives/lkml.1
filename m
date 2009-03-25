Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZCYHW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZCYHW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZCYHWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:22:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZCYHWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:22:17 -0400
Date: Wed, 25 Mar 2009 08:21:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ptrace: remove incorrect unlikelys
Message-ID: <20090325072129.GB25833@elte.hu>
References: <20090325051920.406564281@goodmis.org> <20090325052022.747507467@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325052022.747507467@goodmis.org>
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

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Impact: clean up
> 
> Accounding to the annotated branch profiler, the unlikelys used by
> ptrace is incorrect every time.
> 
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
> 
>        0    24176 100 syscall_trace_leave            ptrace.c             1444
>        0    21478 100 syscall_trace_enter            ptrace.c             1424
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/ptrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 06ca07f..74a16db 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -1421,7 +1421,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
>  	    tracehook_report_syscall_entry(regs))
>  		ret = -1L;
>  
> -	if (unlikely(current->audit_context)) {
> +	if (current->audit_context) {

i suspect you got this result because you are running Fedora with 
auditd enabled and running, right? Does SuSE and Ubuntu run with 
auditing enabled as well? If yes then removing this annotation would 
be right - otherwise the auditing-enabled case is considered the 
less likely variant. (despite it being 100% wrong for your 
particular configuration)

	Ingo
