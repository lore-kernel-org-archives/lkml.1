Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168Ab0COCxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:53:15 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47871 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab0COCxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:53:09 -0400
Date: Mon, 15 Mar 2010 02:52:49 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, u.kleine-koenig@pengutronix.de,
       a.p.zijlstra@chello.nl, andrea.gallo@stericsson.com,
       dbrownell@users.sourceforge.net, eric.y.miao@gmail.com,
       hugh.dickins@tiscali.co.uk, John Stultz <johnstul@us.ibm.com>,
       linux@bohmer.net, nico@marvell.com,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the right place
Message-ID: <20100315025249.GP6491@shareable.org>
References: <201003112208.o2BM8wJU013575@imap1.linux-foundation.org> <alpine.LFD.2.00.1003130031300.22855@localhost.localdomain> <20100312155015.090ba541.akpm@linux-foundation.org> <alpine.LFD.2.00.1003130130090.22855@localhost.localdomain> <20100312171423.b7e7a838.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312171423.b7e7a838.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> We can tweak and tune until we're blue in the face, but the system's
> IRQ latency will always be worse if handlers always run with interrupts
> disabled.

Are you sure?

If good, fast irq handler A runs with interrupts enabled,
and good, fast irq handler B runs (interrupting A),
A's latency goes _up_ not down.

If B happens first, then you get B's latency going up, and A's latency going down.

It's not really clear what happens to average latency.  But if you
know that some handlers require lower latency than others (e.g. serial
ports with small FIFOs), it makes sense to prioritise them.

-- Jamie
