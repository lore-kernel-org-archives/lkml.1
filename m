Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYJBPs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYJBPs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYJBPsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:48:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51645 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYJBPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:48:50 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>
	 <1222912413.2995.80.camel@laptop-eth.lan>
	 <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 08:48:45 -0700
Message-Id: <1222962525.2995.100.camel@laptop-eth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 11:02 -0400, Steven Rostedt wrote:
> On Wed, 1 Oct 2008, Daniel Walker wrote:
> > > 
> > > Converting an interrupt to threaded makes only sense when the handler
> > > code takes advantage of it by integrating tasklet/softirq
> > > functionality and simplifying the locking.
> > 
> > I'm not clear on your direction here.. I don't have a problem with a
> > mass driver audit, which I think is what your suggesting with this patch
> > set .. However, a mass audit like that would push a fully real time
> > system out for quite some time..
> 
> This has nothing to do with real time, although it helps.

Clearly threading irq handlers does have something to do with real time,
unless this patch isn't actually threading anything ..

> > 
> > I also don't see a clear connection between these changes and ultimately
> > removing spinlock level latency in the kernel. I realize you don't
> > address that in your comments, but this is part of the initiative to
> > remove spinlock level latency..
> 
> This is a completely different topic.

It's all connected to the removal of latency .. One part depending on
the other parts, so you can't disconnect this from the rest of it.

> > 
> > So with this set of changes and in terms of real time, I'm wonder your
> > going with this ?
> 
> This helps with latencies and locking. With the current scheme of hardirq, 
> softirq/tasklets, there are a lot of craziness with spin_locks and 
> spin_lock_irqs and mutexes.
> 
> By creating an interrupt thread, we can skip the softirq/tasklet 
> altogether, and this simplifies locking.

How does this simplify locking ?

Daniel

