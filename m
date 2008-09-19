Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYISVXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYISVXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYISVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:23:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbYISVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:23:44 -0400
Date: Fri, 19 Sep 2008 14:23:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, steven@uplinklabs.net
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-Id: <20080919142326.29834d11.akpm@linux-foundation.org>
In-Reply-To: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 03:06:43 -0700
Steven Noonan <steven@uplinklabs.net> wrote:

> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -339,6 +339,10 @@ extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
>  extern int trace_selftest_startup_wakeup(struct tracer *trace,
>  					 struct trace_array *tr);
>  #endif
> +#ifdef CONFIG_NOP_TRACER
> +extern int trace_selftest_startup_nop(struct tracer *trace,
> +					 struct trace_array *tr);
> +#endif
>  #ifdef CONFIG_CONTEXT_SWITCH_TRACER
>  extern int trace_selftest_startup_sched_switch(struct tracer *trace,
>  					       struct trace_array *tr);

Consider omitting the ifdefs around the declarations.

pro: the code looks nicer and is less likely to suffer build errors
with weird config combinations.

con: build errors are reported at link-time rather than at compile-time.

Personally, I think pro>con here.
