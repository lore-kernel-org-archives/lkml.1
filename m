Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbXJ1WyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbXJ1WyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJ1WyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:54:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52469 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXJ1WyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:54:07 -0400
Date: Sun, 28 Oct 2007 22:53:25 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, svs1957@gmail.com,
       bgat@billgatliff.com, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to kernel
Message-ID: <20071028225325.GB12752@flint.arm.linux.org.uk>
References: <bug-9217-10286@http.bugzilla.kernel.org/> <20071024195717.0de6a248.akpm@linux-foundation.org> <47200F05.2050305@billgatliff.com> <20071025122303.GB7543@xi.wantstofly.org> <1193319816.6167.45.camel@localhost.localdomain> <20071025130250.cd759e90.akpm@linux-foundation.org> <1193349292.17244.1.camel@localhost.localdomain> <1193611607.7401.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193611607.7401.9.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 10:46:47PM +0000, Richard Purdie wrote:
> On Thu, 2007-10-25 at 22:54 +0100, Richard Purdie wrote:
> > On Thu, 2007-10-25 at 13:02 -0700, Andrew Morton wrote:
> > > It was in the inital report, at
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9217 :
> >
> > This is the commandline they wanted to use, not the one that was
> > actually used. The one that was used should appear on the console, on
> > the serial console if they have the lead or in dmesg when the device
> > boots. We know it probably contained root=/dev/mtdblock2 but thats it.
> > 
> > I'd like to confirm which commandline is appearing since if we know
> > which one it is we might stand a chance of knowing where it came from,
> > until then this is just a guessing game.
> 
> There was a followup in the bugzilla:
> 
> > I use u-boot to boot kernel.
> > When kernel >=2.6.23 boot it use u-boot default bootparam:
> > console=ttyS0,115200 console=tty1 root=/dev/mtdblock2 rootfstype=jffs2
> > Now I try to change it in u-boot source.
> >
> > kernel 2.6.22.9 change default u-boot boot params to what I set in
> > CONFIG_CMDLINE But 2.6.23 and later doesn't
> 
> So its not the standard bootloader, its one which passes an ATAG
> commandline and 2.6.23 onwards uses an ATAG commandline if present
> over the compiled in commandline.

That statement is misleading.  The kernel has _always_ used the command
line passed from the boot loader in preference to the built-in command
line.

The thing that's changed is that the kernel how honors the value passed
from the boot loader in R2 to find out where the ATAG list is - as
documented since 2002 that it will eventually do.  That's 5 years
of warning.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
