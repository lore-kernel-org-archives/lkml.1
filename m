Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360Ab0CMBRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:17:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936358Ab0CMBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:17:41 -0500
Date: Fri, 12 Mar 2010 17:14:23 -0500
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl,
       andrea.gallo@stericsson.com, dbrownell@users.sourceforge.net,
       eric.y.miao@gmail.com, hugh.dickins@tiscali.co.uk, jamie@shareable.org,
       John Stultz <johnstul@us.ibm.com>, linux@bohmer.net, nico@marvell.com,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the
 right place
Message-Id: <20100312171423.b7e7a838.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
References: <201003112208.o2BM8wJU013575@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1003130031300.22855@localhost.localdomain>
	<20100312155015.090ba541.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010 01:59:50 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> 
> I'm simply refusing to apply patches which just shuffle code around to
> warn about obscure use cases instead of tackling the real problem of
> long running irq handlers which prevent us to get rid of IRQF_DISABLED
> and just run all interrupt handlers with irqs disabled.

I'm having trouble agreeing with that aim, really.

We can tweak and tune until we're blue in the face, but the system's
IRQ latency will always be worse if handlers always run with interrupts
disabled.

Plus this approach introduces dependencies between unrelated drivers
(and between _each_ driver and the overall system) which simply don't
exist if those drivers are being nicer to the rest of the system.

