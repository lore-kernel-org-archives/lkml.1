Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXC0IO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXC0IO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXC0IO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:14:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:36585 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXC0IOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:14:55 -0400
Subject: Re: [PATCH] genirq: do not mask interrupts by default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20070327073227.GA26457@elte.hu>
References: <200702161759.l1GHxsO8010669@hera.kernel.org>
	 <1174972037.5329.5.camel@localhost.localdomain>
	 <1174972685.5329.12.camel@localhost.localdomain>
	 <20070327073227.GA26457@elte.hu>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 18:04:24 +1000
Message-Id: <1174982665.14065.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 09:32 +0200, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > Note that I'm not opposed to the change at all, I think it's a good 
> > idea, I'm just worried I'm discovering it a bit late and I've seen 
> > PICs broken in some many colorful ways that I'm a bit worried... Oh 
> > well...
> 
> This change does not really change irq-flow semantics, what it does is 
> that disable_irq()'s effect is delayed. The irq controller does not have 
> to re-assert the irq, we've got the soft-resend mechanism. What am i 
> missing? Are you worried about this change causing actual breakage? (and 
> i'm sorry about not having Cc:-ed you explicitly, i could have sworn you 
> were included in that discussion but apparently not!)

I'm worried about some broken controllers I know of that might indeed
swallow the interrupt if it occurs, we ack it, then disable it, and
later on re-enable it...

I think the main case I have in mind (pmac-pic) has the necessary
retrigger all over the place but there is definitely a change in the
flow of disabling/enabling here.

Anyway, I'll run some tests tomorrow and make noise if I find something
broken, though I can't test the various embedded thingies in
arch/powerpc.

Ben.


