Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYBYKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYBYKU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYBYKUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:20:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYBYKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:20:48 -0500
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com
In-Reply-To: <200802242033.52208.david-b@pacbell.net>
References: <200801181429.00485.david-b@pacbell.net>
	 <1200904299.6341.2.camel@lappy> <200801211022.36312.david-b@pacbell.net>
	 <200802242033.52208.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:20:28 +0100
Message-Id: <1203934828.6242.140.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 20:33 -0800, David Brownell wrote:
> > > >     ==> LOCKDEP feature is evidently missing:
> > > >             spin_lock_irq_nested(lock_ptr, lock_class)
> > > 
> > > This rant is more lines than adding the API :-/ the reason for it not
> > > being there is simple, it wasn't needed up until now.
> > 
> > I suspected that was the case, but for all I knew there was some
> > religious objection. 
> 
> Does this look about right?  Or, I suppose it could just call
> the _spin_lock_irqsave_nested() routine and discard the result.

Before I look at the code, and with a notice that I haven't had my
morning juice yet...

It seems to me a spin_lock_irq_nested() thing is redundant, because:

The lock must obviously be held hardirq safe and nested implies one is
already held. Hence the context is already hardirq safe thus using
spin_lock_irq/spin_unlock_irq is wrong because it will enable irqs and
destroy the irqsafe guarantee for the parent lock.

Obviously I'm missing something here.. otherwise you wouldn't need it.

As I'm very much not familiar with the IRQ code, could you spell it out
to me?

