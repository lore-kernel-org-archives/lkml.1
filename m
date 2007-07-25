Return-Path: <linux-kernel-owner+w=401wt.eu-S1764557AbXGYNsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764557AbXGYNsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXGYNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:48:09 -0400
Received: from mx12.go2.pl ([193.17.41.142]:41184 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847AbXGYNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:48:07 -0400
Date: Wed, 25 Jul 2007 15:57:18 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin ??lusarz <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070725135718.GB1843@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com> <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu> <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org> <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185322771.4175.102.camel@chaos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 02:19:31AM +0200, Thomas Gleixner wrote:
...
> Looking into the IO_APIC code, the resend via send_IPI_self() happens
> unconditionally. So the resend is done for level and edge interrupts.
> This makes the problem more mysterious.
> 
> The code in question lib8390.c does
> 
> 	disable_irq();
> 	fiddle_with_the_network_card_hardware()
> 	enable_irq();
...
> 
> No idea how this affects the network card, as the code there must be
> able to handle interrupts, which are not originated from the card due to
> interrupt sharing.

I think, in this last yesterday's patch Ingo could be right, yet!
The comment at the beginnig points this is done like that because
of chip's slowness. And problems with timing are mysterious.

On the other hand author of this code didn't use spin_lock_irqsave
for some reason, probably after testing this option too. So, I hope
this is the right path, but alas, I'm not sure this patch has to
prove this 100%.

Anyway, in my opinion this situation where interrupts could/have_to
be used for such strange things should confirm the need of more
options for handling irqs individually.

Thanks,
Jarek P.
