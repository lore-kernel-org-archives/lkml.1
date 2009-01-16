Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZAPGu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZAPGu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZAPGuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:50:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZAPGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:50:23 -0500
Date: Thu, 15 Jan 2009 22:49:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/6] ftrace: move function tracer functions out of
 trace.c
Message-Id: <20090115224925.6b0e6c24.akpm@linux-foundation.org>
In-Reply-To: <20090116045417.632296101@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
	<20090116045417.632296101@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 23:53:43 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

>  static void
> +function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
> +{
> +	struct trace_array *tr = func_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu, resched;
> +	int pc;
> +
> +	if (unlikely(!ftrace_function_enabled))
> +		return;

We're optimizing for the tracing-is-enabled case.  What's the thinking
here?
