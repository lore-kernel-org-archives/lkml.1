Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXCXKGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXCXKGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 06:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXCXKGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 06:06:32 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2702 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXCXKGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 06:06:31 -0400
Date: Sat, 24 Mar 2007 10:06:14 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Message-ID: <20070324100614.GA13764@flint.arm.linux.org.uk>
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
	len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
References: <17887.1174373206@kao2.melbourne.sgi.com> <200703211035.39340.bjorn.helgaas@hp.com> <20070321163758.GB28239@flint.arm.linux.org.uk> <200703211040.54380.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703211040.54380.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:40:54AM -0600, Bjorn Helgaas wrote:
> On Wednesday 21 March 2007 10:37, Russell King wrote:
> > On Wed, Mar 21, 2007 at 10:35:38AM -0600, Bjorn Helgaas wrote:
> > > On Tuesday 20 March 2007 08:32, Bjorn Helgaas wrote:
> > > > On Tuesday 20 March 2007 00:46, Keith Owens wrote:
> > > > > Booting with 'console=tty console=ttyS0,9600'.  The serial console on
> > > > > ttyS0 (0x3f8, irq 4) is probed twice, once from serial8250_init() and
> > > > > again from serial_pnp_probe().
> > > > 
> > > > I played with this last summer, but was too timid to finish it
> > > > and post it.  My plan was to remove the legacy SERIAL_PORT_DFNS,
> > > > make platform devices for them, and only register the platform
> > > > devices in the absence of PNP.
> > > > 
> > > > My motivation at the time was to prevent 8250 from claiming IRDA
> > > > devices that happened to live at legacy UART addresses.  I also
> > > > wanted to make IRDA (smsc-ircc2 in my case) smart enough to use
> > > > PNP to locate its devices, since 8250 would no longer claim them.
> > > > 
> > > > Here's the dusty patch (against 2.6.18-rc1-mm2).  If it seems
> > > > like a reasonable thing to do, I can update it, polish it up,
> > > > add a changelog, and post it.
> > > 
> > > Keith, does this patch help?  Russell didn't complain about it, so
> > > if it fixes your problem, maybe we could put it in -mm and see if
> > > it breaks anything else.
> > 
> > Yes I did.
> 
> Sorry.  What I should have said was "Russell gave constructive
> feedback for a minor improvement, but didn't complain about the
> overall approach of converting to platform devices, so if the
> patch solves your (Keith's) problem, I'll incorporate Russell's
> feedback and send an updated patch to Andrew."

I did also point out that the autoconfig should be transparent, and if
it isn't there's probably a bug in there somewhere.

So I partly view this patch as a papering over of the real problem, but
for other reasons it's more or less the right direction for stuff to go.
Except that the x86 definitions should be in arch/i386 rather than
drivers/serial, like the other architectures which have been converted
to this model already do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
