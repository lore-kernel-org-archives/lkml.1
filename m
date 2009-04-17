Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbZDQPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbZDQPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZDQPxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:53:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZDQPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:53:07 -0400
Date: Fri, 17 Apr 2009 11:53:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 4/4] tracing: avoid warnings from zero-arg tracepoints
In-Reply-To: <1239950139-1119-5-git-send-email-jeremy@goop.org>
Message-ID: <alpine.DEB.2.00.0904171152500.14919@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-5-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:

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
>  									\

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

