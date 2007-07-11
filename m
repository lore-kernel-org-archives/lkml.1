Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbXGKTmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbXGKTmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXGKTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:41:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:36466 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXGKTlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:41:51 -0400
Date: Wed, 11 Jul 2007 20:40:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: do not add port that is not initialized
Message-ID: <20070711194050.GB28258@flint.arm.linux.org.uk>
References: <200707101703.36173.yinghai.lu@sun.com> <20070711071742.GA12952@flint.arm.linux.org.uk> <200707111005.53836.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707111005.53836.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:05:53AM -0600, Bjorn Helgaas wrote:
> On Wednesday 11 July 2007 01:17:42 am Russell King wrote:
> > On Tue, Jul 10, 2007 at 05:03:35PM -0700, Yinghai Lu wrote:
> > > [PATCH] serial: do not add port that is not initialized
> > > 
> > > if the port is not initialized with correct iobase, and membase, we don't
> > > need to add that port.
> > > for x86, when pnpacpi is enabled, we will not get extra ttyS1/ttyS2/ttyS3 in
> > > /sys/devices/platform/serial8250/tty
> > > 
> > > Sign-off-by: Yinghai Lu <yinghai.lu@sun.com>
> > 
> > What if someone wants to run setserial on /dev/ttyS1 to set it's base
> > address, irq and other parameters?  People still do this.
> 
> I agree that people still use setserial that way, and we shouldn't
> make this change because it would break things.
> 
> But I also agree with Yinghai that these extra phantom devices are
> just weird.  It would be a lot nicer if there were a way to say,
> "please, Mr. Serial Driver, create me a new ttyS device with these
> parameters."
> 
> But no, I'm not volunteering to do that.

Indeed, and since distros still haven't picked up my setserial v3,
I see little chance of that ever being practical.  Not that I've
really tried very hard to get them to - no real idea who to contact
to make that happen, and of course I've no interest in making it
happen anymore.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
