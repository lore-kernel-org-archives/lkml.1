Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYJUEOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYJUEOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYJUEOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:14:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYJUEOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:14:07 -0400
Date: Tue, 21 Oct 2008 00:14:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Lockup in tracepoint unregister in sched switch ftrace plugin
In-Reply-To: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[ Paul, Thomas, wake up ]

On Mon, 20 Oct 2008, Steven Rostedt wrote:
> 
>   which calls unregister_trace_sched_switch define as macro to:
> 
> kernel/tracepoint.c: tracepoint_probe_unregister
>    " "  : remove_tracepoint
> kernel/rcupdate.c: rcu_barrier_sched
>    " "  : _rcu_barrier
> 
> where it gets stuck at that "wait_for_completion".
> 
> I'm not sure if, because this is a scheduler trace point that we are 
> hitting some kind of race that is preventing the wait_for_completion to 
> finish, or what.

Note, I just booted this kernel with CONFIG_NOHZ=n and it booted fine.
This looks like a bug somewhere in tracepoints/RCU/dynamic-ticks

-- Steve

