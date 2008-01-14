Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYANJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYANJwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYANJwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:52:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53190 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYANJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:52:09 -0500
Date: Mon, 14 Jan 2008 09:46:31 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: nigel@nigel.suspend2.net, nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080114094631.GB22818@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz> <478A95DB.80407@suspend2.net> <20080114004959.0f533fef@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114004959.0f533fef@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:49:59AM +0000, Alan Cox wrote:
> > > Is printk() enough for 'we've just lost your data' condition? Maybe we
> > > should abort suspend if we can't drain fifo?
> > 
> > No way. Think about this from a users' perspective. No one wants suspend
> > to ram or hibernate functionality that works sometimes and not others.
> > They want it to work reliably so they don't have to worry about their
> > laptop overheating while they're getting on the bus or airplane.
> > Aborting isn't an option.
> 
> Dumb question on the printk however - what if the port that is sticking
> is the console - don't we recurse and die ?

How do we recurse?  printk never calls the suspend method.

What *might* happen is that printk might call the serial console write
function, which waits a maximum of 10ms per character to be sent without
hardware console flow control, or one second per character with hardware
console flow control.

This will only happen when there isn't something asserting CTS connected
to the console port and hardware console flow control has been configured
at boot time.

This will also happen in normal operation if you set the system up as
above and deassert CTS - there's nothing suspend specific about that.

Finally note that hardware console flow control is entirely separate from
the user-level flow control settings or the hardware's ability.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
