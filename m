Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYJ3LPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYJ3LPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYJ3LOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:14:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:41270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYJ3LOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:14:54 -0400
Subject: Re: [PATCH 1/2] lockdep: implement full check without irq checking
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1225362995.3690.10.camel@johannes.berg>
References: <1224790541.6002.53.camel@johannes.berg>
	 <1224791072.6002.63.camel@johannes.berg>
	 <1225293796.9315.4.camel@lappy.programming.kicks-ass.net>
	 <1225362995.3690.10.camel@johannes.berg>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 12:15:16 +0100
Message-Id: <1225365316.7803.69.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 11:36 +0100, Johannes Berg wrote:

> > del_timer_sync():
> > 
> >   local_irq_save(flags);
> >   lock_aquire(my fake timer lock);
> >   lock_release(...);
> >   local_irq_restore(flags);
> > 
> > and make that conditional CONFIG_PROVE_LOCKING and or wrap it up
> > somewhere..
> 
> Yeah, that is possible, but it seemed to me that would affect the
> performance of del_timer_sync() quite a bit. Not sure it matters. And on
> powerpc (which I care about) it won't actually affect performance much
> because we lazily disable IRQs, but still. The >= 2 change also seemed
> to generate smaller code?

Its debug code, and I the >= 2 change makes the code much less obvious.

So I prefer the slightly less performant but conceptually cleaner IRQ
disable variant.


