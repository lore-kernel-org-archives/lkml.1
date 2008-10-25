Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYJYNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYJYNu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYJYNuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 09:50:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYJYNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 09:50:09 -0400
Date: Sat, 25 Oct 2008 09:50:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] ftrace: function oprofiler
In-Reply-To: <c62985530810250351u40b671afg2fada687ee1d62f4@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810250946300.27727@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com> <c62985530810250351u40b671afg2fada687ee1d62f4@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 25 Oct 2008, Fr?d?ric Weisbecker wrote:

> Hi Steven,
> 
> 2008/10/25 Steven Rostedt <rostedt@goodmis.org>:
> > # cat /debug/tracing/ftrace_profile | sort -brn | head -20
> >   280075  : __rcu_read_unlock+0xb/0xa2
> >   280065  : __rcu_read_lock+0x11/0xb3
> 
> The rcu function are on top of this profile. May be it's because you use
> rcu when you touch your hash table.
> Wouldn't be interesting to disable the counter adding for these
> functions when they
> are used at this time?

It is disabled at that time. Look at the trace_active variable. If it
is already set for that CPU, the counter is disabled.

But!  That said. I need to make the count an atomic inc. There's nothing
protecting it from SMP.

> 
> > +config FUNCTION_PROFILER
> > +       bool "Trace max stack"
> 
> Copy-paste error? :-)

Hehe, yeah. This and the above bug are both the cause of writing this 
after midnight. That is exactly why I said this is not ready for inclusion 
;-)

-- Steve

