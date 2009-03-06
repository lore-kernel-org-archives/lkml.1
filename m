Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZCFJAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZCFJAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZCFI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:59:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:49443 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZCFI7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:59:50 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 19:58:42 +1100
Message-Id: <1236329922.7260.127.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 09:11 -0800, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Peter Zijlstra wrote:
> > 
> > Would you be willing to take such a patch?
> 
> Yes - some day.
> 
> The "irq's disabled fastpath" thing has been there since pretty much day 
> one, because some irq handlers always wanted it. Making it the default 
> (and the only choice) is fine.

 .../...

I tend to disagree... (not -that- strongly but I felt like saying it
anyway :-) some archs have a reasonably nice support in the PIC for
interrupt priorities, allowing higher priority interrupts to "preempt"
lower priority ones, which this would effectively render useless.

Also, while yes, I agree, interrupts handlers -should- be short in
practice IDE is far from being the only example where this is not the
case and so we would delay timer interrupts for example for a
significant amount of time (or serial, that's another good example).

Also, we use the priority on some platform to have a high priority used
as a kind of "debugger" NMI .. ie, we don't have a real NMI but it's
better than nothing and here too, this would break it.

I don't see us having such a strong benefit from this... in fact, with
things like -rt, interrupts get moved to threads no ? Thus they
typically run with interrupts enabled... why have a different behaviour
on non-rt ? or I am missing something ? (I'm not terribly familiar with
the -rt stuff here so I probably am missing something).

Cheers,
Ben.


