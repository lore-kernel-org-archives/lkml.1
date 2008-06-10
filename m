Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYFJJCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYFJJCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYFJJCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:02:20 -0400
Received: from www.tglx.de ([62.245.132.106]:46018 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYFJJCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:02:19 -0400
Date: Tue, 10 Jun 2008 11:01:59 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610090158.GC4611@local>
References: <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <20080609075701.GA20656@digi.com> <20080609095408.GB3223@local> <20080609123204.GA27803@digi.com> <20080609142007.GH3223@local> <20080610061121.GA22814@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080610061121.GA22814@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 08:11:21AM +0200, Uwe Kleine-König wrote:
> > >
> > > IMHO it should be asserted that irqs are on before waiting for the irq
> > > in poll and read.  So I suggest to call irqcontrol(ON) before doing so.
> > > This should allow to work with that kind of hardware, right?
> > 
> > Yes. But userspace can simply write() a 1 to /dev/uioX to achieve the
> > same result. This would clearly show what's happening. Remember, this is
> > only needed for certain (broken) hardware. If we hide some automagic irq
> > enabling in the kernel, it'll become less obvious and might even have
> > some bad side effects. I want to avoid this kind of trickery, especially
> > as it is not needed. Userspace should use write() to control irqs. It's
> > like this with any normal UIO driver, and we shouldn't have a different
> > handling in uio_pdrv.
> > Think of a chip that's directly connected to the bus on some embedded
> > board. You use uio_pdrv to handle it. Then the very same chip appears on
> > a PCI card in a normal PC. You write a normal UIO driver for it. The
> > userspace part of both drivers could be exactly the same. But if
> > uio_pdrv automagically reenabled the irq, we would need different
> > handling in userspace, without reasons obvious to the user.

> Note that my intention is to enable irqs in uio.c, not uio_pdrv.c.

Forget it. We won't have some crap that automagically enables irqs in
read() and poll(), neither with irq_enable() nor with irqcontrol(). It's
not a clean solution. We now have a clean solution how userspace can
enable interrupts by using write(), and this (together with uio_pdrv)
can handle all cases we were talking about.

You keep arguing about code that neither introduces new features nor
offers any other advantages. I'm really tired of that.

Thanks,
Hans

