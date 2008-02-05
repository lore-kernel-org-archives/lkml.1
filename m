Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYBEE7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYBEE7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYBEE7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:59:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51355 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYBEE7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:59:32 -0500
Date: Mon, 4 Feb 2008 20:57:59 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory
	leaks in Maple Bus driver
Message-ID: <20080205045759.GA19282@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain> <20080204052900.GB7585@kroah.com> <1202113675.6489.6.camel@localhost.localdomain> <20080204161437.GA20739@kroah.com> <1202164657.7046.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202164657.7046.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:37:37PM +0000, Adrian McMenamin wrote:
> 
> On Mon, 2008-02-04 at 08:14 -0800, Greg KH wrote:
> > On Mon, Feb 04, 2008 at 08:27:55AM +0000, Adrian McMenamin wrote:
> > > 
> > > On Sun, 2008-02-03 at 21:29 -0800, Greg KH wrote:
> > > > On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> > > > > From: Adrian McMenamin
> > > > > 
> > > > > This patch fixes the regression noted here:
> > > > > http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> > > > > previous commit of this driver and the memory leaks noted here:
> > > > > http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> > > > > cleanups).
> > > > 
> > > > Which portion of the patch fixes the kobject WARN_ON()?
> > > 
> > > 
> > > 
> > > +	if (mdev->registered == 0) {
> > > +		retval = device_register(&mdev->dev);
> > > +		if (retval) {
> > > +			printk(KERN_INFO
> > > +			"Maple bus: Attempt to register device"
> > > +			" (%x, %x) failed.\n",
> > > +			mdev->port, mdev->unit);
> > > +			maple_free_dev(mdev);
> > > +			mdev = NULL;
> > > +			return;
> > > +		}
> > > +		mdev->registered = 1;
> > > +	}
> > >  }
> > > 
> > > 
> > > Specifically the check on mdev->registered
> > 
> > So the code path could cause devices to be registered more than once?
> > That seems broken, as no other bus that I know of needs such a check :(
> > 
> > Is there a way to fix the root problem here, instead of this type of
> > change?
> > 
> 
> The hardware is very flaky. If I add in delays to the bus start, it will
> detect the devices, but it's not brilliant. Registering an empty device
> got round that problem, at the price of testing for the earlier
> registration.

That sounds like you are just papering over the problem.  Just delay
and let the hardware settle down if needed :)

thanks,

greg k-h
