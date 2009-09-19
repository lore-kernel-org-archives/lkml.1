Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZISNrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZISNrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 09:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZISNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 09:47:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZISNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 09:47:13 -0400
Subject: Re: [tip:tracing/urgent] tracing: Allocate the ftrace event
 profile buffer dynamically
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-20ab4425a77a1f34028cc6ce57053c22c184ba5f@git.kernel.org>
References: <tip-20ab4425a77a1f34028cc6ce57053c22c184ba5f@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 19 Sep 2009 09:47:15 -0400
Message-Id: <1253368035.20020.339.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 10:06 +0000, tip-bot for Frederic Weisbecker
wrote:
> Commit-ID:  20ab4425a77a1f34028cc6ce57053c22c184ba5f
> Gitweb:     http://git.kernel.org/tip/20ab4425a77a1f34028cc6ce57053c22c184ba5f
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Fri, 18 Sep 2009 06:10:28 +0200
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Fri, 18 Sep 2009 07:25:44 +0200
> 
> tracing: Allocate the ftrace event profile buffer dynamically
> 
> Currently the trace event profile buffer is allocated in the stack. But
> this may be too much for the stack, as the events can have large
> statically defined field size and can also grow with dynamic arrays.
> 
> Allocate two per cpu buffer for all profiled events. The first cpu
> buffer is used to host every non-nmi context traces. It is protected
> by disabling the interrupts while writing and committing the trace.
> 
> The second buffer is reserved for nmi. So that there is no race between
> them and the first buffer.
> 
> The whole write/commit section is rcu protected because we release
> these buffers while deactivating the last profiling trace event.
> 
> v2: Move the buffers from trace_event to be global, as pointed by
>     Steven Rostedt.

OK, now I'm confused ;-)

This version looks like the correct one.

-- Steve

> 
> v3: Fix the syscall events to handle the profiling buffer races
>     by disabling interrupts, now that the buffers are globals.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> 


