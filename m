Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYGDNcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYGDNcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGDNcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:32:41 -0400
Received: from www.tglx.de ([62.245.132.106]:56767 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYGDNck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:32:40 -0400
Date: Fri, 4 Jul 2008 15:32:21 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080704133221.GC2257@local>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com> <20080703124505.GB3197@local> <aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com> <20080704060108.GA11794@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704060108.GA11794@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 08:01:08AM +0200, Uwe Kleine-K?nig wrote:
> Magnus Damm wrote:
> > On Thu, Jul 3, 2008 at 9:45 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> > > On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-K?nig wrote:
> > >> Hans J. Koch wrote:
> > >> > On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
> > >> > > From: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
> > >> > >
> > >> > > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> > >> > > is responsible for acknowledging and re-enabling the interrupt.
> > >> >
> > >> > This can easily be done without your patch.
> > >
> > > BTW, the above wording "the user space driver is responsible for
> > > acknowledging and re-enabling the interrupt" is misleading. The kernel
> > > always has to acknowledge/disable/mask the interrupt. Userspace can only
> > > reenable it, ideally by writing to a chip register. In some cornercases
> > > for broken hardware we need the newly introduced write function.
> > 
> > You seem to be mixing up masking/acknowledging the interrupt
> > controller and masking/acknowledging the actual hardware device. In
> > User IRQ Mode, the only thing the user space driver is accessing is
> > the hardware device, with the exception of write() to re-enable
> > interrupts which results in a enable_irq() that touches the interrupt
> > controller.
> But to be honest Hans is right here, the commit log wording is not
> optimal.  I suggest:
> 
> 	This patch adds a "User IRQ Mode" to UIO. In this mode the
> 	kernel space simply disables the serviced interrupt in the
> 	interrupt controller and the user space driver is responsible
> 	for acknowledging it in the device and reenabling it.
> 
> 	Note that this implies that the interrupt might be disabled for
> 	long periods, so this isn't usable for shared interrupt lines.
> 
> Maybe it's sensible to add the User IRQ Mode functions at least for now
> into platform code.  Then at a later time if and when there are several
> copies the discussion to move it to the generic part might be easier.

Thanks for this suggestion. I agree. Maybe we find a different solution
until then.

> 
> BTW, I currently have a situation where it IMHO really makes sense to
> use the User IRQ Mode:  We sell a cpu module to a customer with
> Linux.  I provide a uio device for some memory mapped periphal on the
> customers board that I don't know in detail.  With the User IRQ Mode I
> only need to know the chip select and the irq line, no further
> information is needed for the device.

The only additional information you need now is which bit in which
register you have to set/clear to mask the irq. I also have customer
chips here where this one information is all I know about the chip.

Thanks,
Hans

