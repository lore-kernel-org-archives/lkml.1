Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZDQPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZDQPxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZDQPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:53:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33662 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZDQPx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:53:29 -0400
Date: Fri, 17 Apr 2009 17:53:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 4/4] tracing: avoid warnings from zero-arg tracepoints
Message-ID: <20090417155313.GC8253@elte.hu>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-5-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239950139-1119-5-git-send-email-jeremy@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Tracepoints with no arguments can issue two warnings:
> 	"field" defined by not used
> 	"ret" is uninitialized in this function
> 
> Mark field as being OK to leave unused, and initialize ret.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/trace/ftrace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 60c5323..39a3351 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -160,8 +160,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  static int								\
>  ftrace_format_##call(struct trace_seq *s)				\
>  {									\
> -	struct ftrace_raw_##call field;					\
> -	int ret;							\
> +	struct ftrace_raw_##call field __attribute__((unused));		\
> +	int ret = 0;							\
>  									\
>  	tstruct;							\

This looks like a fix we should pick up straight away. I've applied 
it to tip:tracing/ftrace - Steve is it fine with you too?

	Ingo
