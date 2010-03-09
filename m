Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0CIXc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:32:58 -0500
Received: from www.tglx.de ([62.245.132.106]:52123 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0CIXcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:32:55 -0500
Date: Wed, 10 Mar 2010 00:32:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Valdis.Kletnieks@vt.edu, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
In-Reply-To: <4B96D055.90201@metafoo.de>
Message-ID: <alpine.LFD.2.00.1003100022510.22855@localhost.localdomain>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>            <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain> <5309.1268153945@localhost> <alpine.LFD.2.00.1003091907500.22855@localhost.localdomain> <4B96D055.90201@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter,

On Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> > Right it's a valid SMP problem, but I got confused by the lengthy
> > explanation of a thread preempting an hard interrupt handler. :)
>
> Yes, sorry for bothering you with that. I actually had the symptoms
> described on a non SMP system. The irq in question was part of a
> longer irq chain and I though that it might be detached from the
> hardirq context somewhere along the chain.
> After your comment I reread some parts and it turned out that
> irq_enter()/irq_exit() was missing around the first level irq handler.

I'm happy you stared at that code even if you came to the wrong
conclusion vs. the problem that triggered your patch. You pointed out
a real bug in the code, which did not yet trigger because UP is not
affected and usually irqbalance pins irqs and also the irq threads to
a single cpu.

Thanks,

	tglx


