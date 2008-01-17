Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYAQDDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYAQDDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYAQDC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:02:56 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:59851 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYAQDCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:02:55 -0500
Date: Wed, 16 Jan 2008 22:02:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080117025004.GE2322@Krystal>
Message-ID: <Pine.LNX.4.58.0801162202160.20257@gandalf.stny.rr.com>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
 <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal>
 <20080117025004.GE2322@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:

> It would imply the creation of a new vsyscall : vgetschedperiod
>
> It would read a counter that would increment each time the thread is
> scheduled out (or in). It would be a per thread counter (not a per cpu
> counter) so we can deal appropriately with a stopped thread that would
> happen to come back running a loooong time afterward (if we do per-cpu
> counters, we could get the same 32 bits counter value falsely if it is
> shared with other thread activity).
>
> Then, the clocksource read code would look like :
>
> int period;
>
> do {
>   period = vgetschedperiod();
>
>   perform the clocksource read..
>
> } while (period != vgetschedperiod());
>
> Therefore, we would be sure that we have not been scheduled out while
> reading the value. I think this new vsyscall could be useful for others.
> Actually, it would make implementation of RCU in user-space possible (as
> long as the read-side can retry the read operation).


This is something that I would agree is useful.

-- Steve

