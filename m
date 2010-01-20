Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0ATWi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0ATWi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716Ab0ATWi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:38:57 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54214 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab0ATWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:38:56 -0500
Date: Wed, 20 Jan 2010 17:38:55 -0500
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
	(which 2.6.26 did not see) on Geode LX/CS5536.
Message-ID: <20100120223855.GQ24305@caffeine.csclub.uwaterloo.ca>
References: <20100120214556.GP24305@caffeine.csclub.uwaterloo.ca> <Pine.LNX.4.44L0.1001201704360.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001201704360.1360-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 05:06:53PM -0500, Alan Stern wrote:
> On Wed, 20 Jan 2010, Lennart Sorensen wrote:
> 
> > On Wed, Jan 20, 2010 at 03:20:46PM -0500, Alan Stern wrote:
> > > Okay, this means that something else is affecting the IRQ line.
> > 
> > Yep.  I went and disabled irq5 on the LPC bus, and that didn't help.
> > 
> > > > Interestingly the number of interrupts listed in /proc/interrupts is
> > > > exactly 300000.
> > > 
> > > That's probably because the kernel disabled the IRQ after 100000 
> > > unhandled interrupts, and re-enabled it each time a new device was
> > > registered for that IRQ.
> > 
> > Certainly seems to be the case.
> > 
> > > Or you could just stop using USB on the old box.  :-)
> > 
> > Well I just tried another box, and same thing.
> > 
> > If I boot with 'irqpoll' then everything seems fine.
> > 
> > Any idea how I can figure out why irqpoll makes it happy?  Does it give
> > any reports anywhere about misrouted irqs?
> 
> Not that I know of.

That's unfortunate.  After all it would be nice if irqpoll found an
unhandled irq and called all the other handlers and the irq went away,
then a report of which handler cleared it would be very helpful.

> Does 2.6.26 fail on the new machine?

Yes.

As far as I can tell some machines don't see the problem.  I am still
investigating that.

> Are you using a .config different from the one that used to work with 
> 2.6.26?

Well of course, but not for the USB settings.  It is supposed to be the
same as far as possible.  I will go compare them in more detail.

-- 
Len Sorensen
