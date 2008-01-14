Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYANJFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYANJFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYANJFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:05:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38821 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbYANJFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:05:00 -0500
Date: Mon, 14 Jan 2008 10:04:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
	won't drain
Message-ID: <20080114090459.GB4024@elf.ucw.cz>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz> <20080114002912.GA19195@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114002912.GA19195@flint.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-01-14 00:29:12, Russell King wrote:
> On Fri, Jan 11, 2008 at 10:17:21AM +0000, Pavel Machek wrote:
> > On Tue 2008-01-08 11:57:03, Russell King wrote:
> > > +		if (!tries)
> > > +			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
> > > +			       port->dev ? port->dev->bus_id : "",
> > > +			       port->dev ? ": " : "",
> > > +			       drv->dev_name, port->line);
> > >  
> > >  		ops->shutdown(port);
> > >  	}
> > > 
> > 
> > Is printk() enough for 'we've just lost your data' condition? Maybe we
> > should abort suspend if we can't drain fifo?
> 
> That would mean that a port set for hardware flow control, with hardware
> implemented flow control, has CTS deasserted, you'll never suspend.

Yep. 

> If you're suspending because your battery is almost dead what would you
> prefer - the system being prevented from suspending and losing complete
> power unexpectedly, resulting in complete data loss, or losing the
> characters in the serial port and suspending?
> 
> Which is the lesser of two evils?

Not sure, but there's third option -- correct but more work. What
about saving/restoring fifo state? That will not stall suspend, nor
will loose data.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
