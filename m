Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYJBPDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYJBPDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYJBPCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:02:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYJBPCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:02:53 -0400
Date: Thu, 2 Oct 2008 11:02:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222912413.2995.80.camel@laptop-eth.lan>
Message-ID: <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de> <1222912413.2995.80.camel@laptop-eth.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Daniel Walker wrote:
> > 
> > Converting an interrupt to threaded makes only sense when the handler
> > code takes advantage of it by integrating tasklet/softirq
> > functionality and simplifying the locking.
> 
> I'm not clear on your direction here.. I don't have a problem with a
> mass driver audit, which I think is what your suggesting with this patch
> set .. However, a mass audit like that would push a fully real time
> system out for quite some time..

This has nothing to do with real time, although it helps.

> 
> I also don't see a clear connection between these changes and ultimately
> removing spinlock level latency in the kernel. I realize you don't
> address that in your comments, but this is part of the initiative to
> remove spinlock level latency..

This is a completely different topic.

> 
> So with this set of changes and in terms of real time, I'm wonder your
> going with this ?

This helps with latencies and locking. With the current scheme of hardirq, 
softirq/tasklets, there are a lot of craziness with spin_locks and 
spin_lock_irqs and mutexes.

By creating an interrupt thread, we can skip the softirq/tasklet 
altogether, and this simplifies locking.

There are other cases where threaded interrupt handlers also improve 
performance. But we will get to those in due time.

-- Steve

