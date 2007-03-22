Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXCVVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXCVVQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXCVVQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:16:05 -0400
Received: from www.osadl.org ([213.239.205.134]:37208 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752650AbXCVVQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:16:04 -0400
Subject: Re: [PATCH] Fix irqpoll on IA64 (timer interrupt != 0)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernhard Walle <bwalle@suse.de>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070322140922.a59bea5c.akpm@linux-foundation.org>
References: <20070320150027.GA18143@strauss.suse.de>
	 <20070322140922.a59bea5c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 22:23:21 +0100
Message-Id: <1174598601.10840.231.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 14:09 -0700, Andrew Morton wrote:
> I think the term 'timer_interrupt' is a bit generic-sounding.  Would it be
> better to call it irqpoll_interrupt?  After all, some architecture might
> want to use, umm, the keyboard interrupt to trigger IRQ polling ;)  

Interesting thought, but in general I have to agree.

> Also, the code presently passes the magic IRQ number into the generic IRQ
> code.  I wonder if we'd get a more pleasing result if we were to make the
> generic IRQ code call _out_ to the architecture:

> Then, ia64 can implement arch_is_irqpoll_irq() and it can do whatever it
> wants in there.
> 
> The __attribute__((weak)) thing adds a little bit of overhead, but I don't
> think this is a fastpath?

Well, depends what you consider a fastpath. When noirqdebug == 0, it is
called on every interrupt.

	tglx


