Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJUIb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJUIb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJUIbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:31:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:50141 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYJUIbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:31:17 -0400
Subject: Re: Bug in "genirq: record trigger type"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200810210101.19741.david-b@pacbell.net>
References: <200810202205.m9KM5une024759@hera.kernel.org>
	 <1224570730.7654.242.camel@pasglop>
	 <200810210101.19741.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 19:29:54 +1100
Message-Id: <1224577794.7654.253.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 01:01 -0700, David Brownell wrote:
> 
> I'm a bit more curious about another potential issue though ... as
> described in the patch comment:
> 
>      - Make set_irq_type() usage match request_irq() usage:
>         * IRQ_TYPE_NONE should be a NOP; succeed, so irq_chip methods
>           won't have to handle that case any more (many do it wrong).
> 
> It might be a bit more accurate to say irq_chip.set_type() methods
> are *inconsistent* in handling IRQ_TYPE_NONE.  Previously the
> set_irq_type() method would pass that down to irq_chip code. 
> 
> I had observed two behaviors, but I thought I observed a third one
> in some of the PowerPC code:
> 
>  (1) ignore it ... matching request_irq() usage
>  (2) return an error ... nasty
>  (3) assign some irq_chip-specific trigger mode
> 
> That third behavior might cause a bit of trouble, but I think
> it was only used during platform init.  Someone more attuned
> to PowerPC might want to check ...

Ok, I wrote a lot of the port of powerpc stuff to genirq so I supposed
I'm the person to do that sweep :-) I'll have a look tomorrow.

Thanks for the heads up,

Cheers,
Ben.


