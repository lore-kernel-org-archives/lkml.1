Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZDGAei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZDGAei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZDGAe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:34:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61160 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZDGAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:34:28 -0400
Date: Mon, 6 Apr 2009 20:34:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
In-Reply-To: <20090406235850.GA20273@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.0904062032160.24008@gandalf.stny.rr.com>
References: <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com> <1238916865.7989.212.camel@tropicana> <20090405171146.GK6893@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com>
 <20090406161527.GD6988@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061529370.4317@gandalf.stny.rr.com> <20090406194417.GA5936@nowhere> <alpine.DEB.2.00.0904061552260.23509@gandalf.stny.rr.com> <20090406201524.GF6988@linux.vnet.ibm.com>
 <20090406235850.GA20273@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Paul E. McKenney wrote:
> 
> Hmmm...  Do the start_critical_timings() and stop_critical_timings()
> functions have anything to do with ftrace()?

Yep.

> 
> It does not look like I can just bury RCU-idle controls in these
> functions, given that they are also invoked around call_console_drivers(),
> but if all the idle loops are surrounded by stop_critical_timings() and
> start_critical_timings(), that would ease location of all the idle
> loops.  ;-)

They are for the irqsoff tracer. Several archs will disable interrupts and 
call an assembly "halt" type instruction that can be woken up by 
interrupts. But this skips the irqs off check, and we end up with irqsoff 
showing the idle loop with huge interrupts off latencies.

I'm not sure they are included in all archs. They may be.

-- Steve

