Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZCTJ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZCTJ7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZCTJ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:58:48 -0400
Received: from www.tglx.de ([62.245.132.106]:59522 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZCTJ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:58:47 -0400
Date: Fri, 20 Mar 2009 10:58:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <49C36149.9000703@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu>
 <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C36149.9000703@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Michal Simek wrote:

> Thomas,
> 
> just one other question.
> For me will be useful to use second timer which is inside timer IP core.
> There are two timers with one interrupt line. And I can of course resolve which
> counter cause it. That's no problem.
> 
> My question is about timer_irqaction where is dev_id. What should be there?
> Point to clocksource structure or clockevent?
> 
> static struct irqaction timer_irqaction = {
> 	.handler = timer_interrupt,
> 	.flags = IRQF_DISABLED | IRQF_TIMER,
> 	.name = "timer",
> 	.dev_id = &clocksource_microblaze,
> };

The clockevent of course. It's the one which emits the interrupts.

Just for clarification. The clocksource is basically a counter to read
out the current time. Such a counter usually does not deliver
interrupts. It wraps at some point, but that is handled by the generic
time keeping code. If you setup the 32 bit counter to count up and let
it run free then the counter will wrap from 0xffffffff to 0. Nothing
you have to worry about. You just provide a function to read it.

The clockevent is the device which delivers either periodic or oneshot
interrupts. Sa you dont have to worry about the shared interrupt line
in that case.

Thanks,

	tglx
