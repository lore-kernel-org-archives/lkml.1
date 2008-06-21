Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYFUO4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYFUO4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYFUO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:56:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYFUO42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:56:28 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
	<20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 21 Jun 2008 10:53:49 -0400
In-Reply-To: <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com> (Steven Rostedt's message of "Sat, 21 Jun 2008 10:36:23 -0400 (EDT)")
Message-ID: <y0mwskiyh36.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

> [...]  Format strings only help for printf like operations. [...]

That is not so.  They are far from panaceanic, but printf formats are
useful for type checked simple scalars, which we can extract and use
for purposes other than printf like operations.

> The best example of this is the sched_switch code. LTTng and friends
> just want a pid and comm to show. But there's tracers that want more
> info from the task_struct. We also like to see the priority of the
> task.  [...]

This is the sort of information that can help generate a compromise.
For this case, pass a few raw pointers that a compiled-in tracing
engine can dereference at will, and *also pass* a few user-level
scalars that a separately-compiled tracing engine can use.

> Passing in a pointer to the structure being traced should be enough
> for all tracers.

On the contrary, we have explained why *this is not so*.  Using raw
general structure pointers in impractical for some tracers.

> Now back to your question, why don't we like the printf
> format. Simply because it does nothing for pointers. It might help
> you with a %d and number of parameters, but a %p can not tell the
> difference between a struct tasks_struct *, and a int *, which can
> have even more devastating results.

Indeed.  Unfortunately, C is not kind to us in the way that perhaps
C++ templates could be.  We have not yet seen a single mechanism that
does all of:

- type-safe passing of arbitrary pointer/etc. types (so compiled-in
  trace data consumers can go wild with data passing)
- declarative / separately-compiled consumption of types
  (so lttng/systemtap/userspace can hook in without heroics)
- parsimonious implementation

Maybe a solution could involve some restrictions on the generalities.
For example, can we narrow down the number of different scalar +
pointer types to a fixed handful?  Can we tolerate type-safety being
provided by families of function declarations rather than one generic
one?


> It also just looks like a debug session instead of a trace marker.

Why do you think the difference between those is profound?


- FChE
