Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZIZKHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZIZKHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 06:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZIZKHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 06:07:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZIZKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 06:07:05 -0400
Subject: Re: [tip:tracing/core] tracing/bkl: Add bkl ftrace events
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-96a2c464de07d7c72988db851c029b204fc59108@git.kernel.org>
References: <tip-96a2c464de07d7c72988db851c029b204fc59108@git.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 06:05:54 -0400
Message-Id: <1253959554.12145.88.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 06:19 +0000, tip-bot for Frederic Weisbecker
wrote:
> Commit-ID:  96a2c464de07d7c72988db851c029b204fc59108

> +#if !defined(_TRACE_BKL_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_BKL_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(lock_kernel,
> +
> +	TP_PROTO(const char *func, const char *file, int line),
> +
> +	TP_ARGS(func, file, line),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,		lock_depth		)

FYI,

By your request I added this as a common field ;-)

With commit:

 637e7e864103a7a68c1ce43ada27dfc25c0d113f

But since other utilities outside of ftrace may use this trace point, it
may be OK to keep the duplicate information in the kernel lock API trace
points.

-- Steve

> +		__field_ext(	const char *,	func, FILTER_PTR_STRING	)
> +		__field_ext(	const char *,	file, FILTER_PTR_STRING	)
> +		__field(	int,		line			)
> +	),
> +
> +	TP_fast_assign(
> +		/* We want to record the lock_depth after lock is acquired */
> +		__entry->lock_depth = current->lock_depth + 1;
> +		__entry->func = func;
> +		__entry->file = file;
> +		__entry->line = line;
> +	),
> +
> +	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
> +		  __entry->file, __entry->line, __entry->func)
> +);
> +

