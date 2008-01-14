Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYANAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYANAac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYANAaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:30:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47524 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbYANAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:30:18 -0500
Date: Mon, 14 Jan 2008 00:29:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080114002912.GA19195@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111101721.GA4463@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 10:17:21AM +0000, Pavel Machek wrote:
> On Tue 2008-01-08 11:57:03, Russell King wrote:
> > +		if (!tries)
> > +			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
> > +			       port->dev ? port->dev->bus_id : "",
> > +			       port->dev ? ": " : "",
> > +			       drv->dev_name, port->line);
> >  
> >  		ops->shutdown(port);
> >  	}
> > 
> 
> Is printk() enough for 'we've just lost your data' condition? Maybe we
> should abort suspend if we can't drain fifo?

That would mean that a port set for hardware flow control, with hardware
implemented flow control, has CTS deasserted, you'll never suspend.

If you're suspending because your battery is almost dead what would you
prefer - the system being prevented from suspending and losing complete
power unexpectedly, resulting in complete data loss, or losing the
characters in the serial port and suspending?

Which is the lesser of two evils?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
