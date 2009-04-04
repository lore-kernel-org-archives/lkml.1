Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZDDJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZDDJpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZDDJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:45:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755834AbZDDJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:45:28 -0400
Date: Sat, 4 Apr 2009 10:44:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Commit 7a192ec is build breaking
Message-ID: <20090404094453.GA11209@flint.arm.linux.org.uk>
References: <20090328140049.GA4344@flint.arm.linux.org.uk> <20090404041740.GA6504@suse.de> <d82e647a0904040018n6e5a261eodcb42d4bb76e65aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0904040018n6e5a261eodcb42d4bb76e65aa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that since I was sending a new set of ARM fixes a couple of days
ago and there didn't seem to be anyone listening to my emails, I fixed
the PXA flash driver myself.  Linus now has that fix.

On Sat, Apr 04, 2009 at 03:18:04PM +0800, Ming Lei wrote:
> 2009/4/4 Greg KH <gregkh@suse.de>:
> > On Sat, Mar 28, 2009 at 02:00:49PM +0000, Russell King wrote:
> >> The commit:
> >>
> >>     platform driver: fix incorrect use of 'platform_bus_type' with 'struct device_driver'
> >>
> >> contains this:
> >>
> >> -static int __exit pxa2xx_flash_remove(struct device *dev)
> >> +static int __exit pxa2xx_flash_remove(struct platform_device *dev)
> >> ...
> >> -       .remove         = __exit_p(pxa2xx_flash_remove),
> >> +       .remove         = __devexit_p(pxa2xx_flash_remove),
> >>
> >> which leads to the following build error:
> >>
> >> `pxa2xx_flash_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> >>
> >> This is not the only instance of it in this patch - all __exit_p's
> >> touched by this patch have been converted to __devexit_p's without
> >> regard to the original function.
> >>
> >> Let's revert this change and, if we are going to convert functions
> >> to be __devexit/__devinit, lets have that as a _separate_ patch doing
> >> just that change.
> >
> > Ick, Ming, any thoughts?  I'll revert your patch as it looks like it is
> > incorrect in this way.
> 
> OK, revert the patch ,please.
> I'll resend a patch to fix incorrect use of 'platform_bus_type' ,
> which does not touch
> __exit_p.
> 
> Thanks!
> 
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 
> 
> -- 
> Lei Ming

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
