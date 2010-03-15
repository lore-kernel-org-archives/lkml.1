Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0COG1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:27:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab0COG1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:27:13 -0400
Date: Sun, 14 Mar 2010 23:25:07 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, u.kleine-koenig@pengutronix.de,
       a.p.zijlstra@chello.nl, andrea.gallo@stericsson.com,
       dbrownell@users.sourceforge.net, eric.y.miao@gmail.com,
       hugh.dickins@tiscali.co.uk, John Stultz <johnstul@us.ibm.com>,
       linux@bohmer.net, nico@marvell.com,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the
 right place
Message-Id: <20100314232507.9901f37d.akpm@linux-foundation.org>
In-Reply-To: <20100315025249.GP6491@shareable.org>
References: <201003112208.o2BM8wJU013575@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1003130031300.22855@localhost.localdomain>
	<20100312155015.090ba541.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
	<20100312171423.b7e7a838.akpm@linux-foundation.org>
	<20100315025249.GP6491@shareable.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 02:52:49 +0000 Jamie Lokier <jamie@shareable.org> wrote:

> Andrew Morton wrote:
> > We can tweak and tune until we're blue in the face, but the system's
> > IRQ latency will always be worse if handlers always run with interrupts
> > disabled.
> 
> Are you sure?
> 
> If good, fast irq handler A runs with interrupts enabled,
> and good, fast irq handler B runs (interrupting A),
> A's latency goes _up_ not down.
> 
> If B happens first, then you get B's latency going up, and A's latency going down.

If the hardware doesn't prioritise these interrupts then the programmer
can do so crudely, by running the critical one with interrupts disabled.

