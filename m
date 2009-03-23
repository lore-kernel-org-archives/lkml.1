Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZCWSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZCWSoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZCWSoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:44:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZCWSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:44:09 -0400
Date: Mon, 23 Mar 2009 14:44:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
In-Reply-To: <20090322150657.GA17415@elte.hu>
Message-ID: <alpine.DEB.2.00.0903231443090.3578@gandalf.stny.rr.com>
References: <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com>
 <20090321190746.GC7148@linux.vnet.ibm.com> <20090321200919.GA23992@elte.hu> <20090321210154.GD7148@linux.vnet.ibm.com> <20090322142409.GA3279@elte.hu> <20090322150657.GA17415@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Mar 2009, Ingo Molnar wrote:

> 
> one thing to note is:
> 
>  <EOI>  [<ffffffff802b78ad>] ? ftrace_likely_update+0x1f/0x27
>  [<ffffffff8022cf88>] ? prepare_ftrace_return+0x3c/0x158
>  [<ffffffff8022d070>] ? prepare_ftrace_return+0x124/0x158
>  [<ffffffff8020c776>] ? ftrace_graph_caller+0x46/0x6d
>  [<ffffffff802a2cd8>] ? jhash+0x9/0x1e6
>  [<ffffffff802a30d9>] ? get_tracepoint+0x30/0x7f
>  [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
>  [<ffffffff8020db1c>] call_softirq+0x1c/0x28
> 
> the branch profiler should be disabled inside ftrace ...

Actually, if the branch tracer is off (only profiling enabled) I actually 
used it to look at the conditions taken inside of ftrace. I prefer that it 
is not disabled. But obviously, we must disable it, if we do the branch 
tracing.

-- Steve

