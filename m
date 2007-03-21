Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXCUQiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXCUQiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXCUQiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:38:12 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3718 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXCUQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:38:11 -0400
Date: Wed, 21 Mar 2007 16:37:58 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Message-ID: <20070321163758.GB28239@flint.arm.linux.org.uk>
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
	len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
References: <17887.1174373206@kao2.melbourne.sgi.com> <200703200832.24921.bjorn.helgaas@hp.com> <200703211035.39340.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703211035.39340.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:35:38AM -0600, Bjorn Helgaas wrote:
> On Tuesday 20 March 2007 08:32, Bjorn Helgaas wrote:
> > On Tuesday 20 March 2007 00:46, Keith Owens wrote:
> > > Booting with 'console=tty console=ttyS0,9600'.  The serial console on
> > > ttyS0 (0x3f8, irq 4) is probed twice, once from serial8250_init() and
> > > again from serial_pnp_probe().
> > 
> > I played with this last summer, but was too timid to finish it
> > and post it.  My plan was to remove the legacy SERIAL_PORT_DFNS,
> > make platform devices for them, and only register the platform
> > devices in the absence of PNP.
> > 
> > My motivation at the time was to prevent 8250 from claiming IRDA
> > devices that happened to live at legacy UART addresses.  I also
> > wanted to make IRDA (smsc-ircc2 in my case) smart enough to use
> > PNP to locate its devices, since 8250 would no longer claim them.
> > 
> > Here's the dusty patch (against 2.6.18-rc1-mm2).  If it seems
> > like a reasonable thing to do, I can update it, polish it up,
> > add a changelog, and post it.
> 
> Keith, does this patch help?  Russell didn't complain about it, so
> if it fixes your problem, maybe we could put it in -mm and see if
> it breaks anything else.

Yes I did.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
