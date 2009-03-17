Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZCQF2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZCQF2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZCQF2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:28:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZCQF2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:28:12 -0400
Date: Tue, 17 Mar 2009 06:24:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090317052442.GA32674@redhat.com>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com> <20090316214526.GA15119@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316214526.GA15119@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Mathieu Desnoyers wrote:
>
> utrace_add_engine()
>   set_notify_resume(target);
>
> ok, so this is where the TIF_NOTIFY_RESUME thread flag is set. I notice
> that it is set asynchronously with the execution of the target thread
> (as I do with my TIF_KERNEL_TRACE thread flag).
>
> However, on x86_64, _TIF_DO_NOTIFY_MASK is only tested in
> entry_64.S
>
> int_signal:
> and
> retint_signal:
>
> code paths. However, if there is no syscall tracing to do upon syscall
> entry, the thread flags are not re-read at syscall exit and you will
> miss the syscall exit returning from your target thread if this thread
> was blocked while you set its TIF_NOTIFY_RESUME.

Afaics, TIF_NOTIFY_RESUME is not needed to trace syscall entry/exit.
If engine wants the syscall tracing, utrace_set_events(UTRACE_SYSCALL_xxx)
sets TIF_SYSCALL_TRACE. And syscall_trace_enter/syscall_trace_leave call
tracehook_report_syscall_xxx().

Oleg.

