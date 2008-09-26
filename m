Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYIZDVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYIZDVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 23:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYIZDVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 23:21:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:32882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYIZDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 23:21:04 -0400
Date: Thu, 25 Sep 2008 20:19:18 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       phil@hannent.co.uk, mwilder@cs.nmsu.edu
Subject: Re: [PATCH] Input: add mmio xi driver
Message-ID: <20080926031918.GA10083@suse.de>
References: <20080925232237.GA22938@suse.de> <20080925182055.f12f5d0b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925182055.f12f5d0b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 06:20:55PM -0700, Randy Dunlap wrote:
> On Thu, 25 Sep 2008 16:22:37 -0700 Greg KH wrote:
> 
> > 
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > This patch adds the Mimio Xi interactive whiteboard driver to the tree.
> > 
> > It was originally written by mwilder@cs.nmsu.edu, but cleaned up and
> > forward ported by me to the latest kernel version.
> > 
> > 
> > Cc: Phil Hannent <phil@hannent.co.uk>
> > Cc: <mwilder@cs.nmsu.edu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/input/misc/Kconfig  |   11 
> >  drivers/input/misc/Makefile |    1 
> >  drivers/input/misc/mimio.c  |  913 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 925 insertions(+)
> > 
> > --- a/drivers/input/misc/Kconfig
> > +++ b/drivers/input/misc/Kconfig
> > @@ -164,6 +164,17 @@ config INPUT_POWERMATE
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called powermate.
> >  
> > +config INPUT_MIMIO
> > +	tristate "Mimio Xi interactive whiteboard support"
> > +	depends on USB_ARCH_HAS_HCD
> > +	select USB
> 
> Prefer not to select entire subsystems, but to depend on them.
> However, lots of drivers in drivers/input/ select USB...  :(

When in Rome... :)

> > +static void mimio_irq_out(struct urb *urb)
> > +{
> > +	unsigned long flags;
> > +	struct mimio *mimio;
> > +
> > +	mimio = urb->context;
> > +
> > +	if (urb->status)
> > +		dev_dbg(&mimio->idev->dev, "urb-status: %d.\n", urb->status);
> > +
> > +	spin_lock_irqsave(&mimio->txlock, flags);
> > +	mimio->txflags |= MIMIO_TXDONE;
> > +	spin_unlock_irqrestore(&mimio->txlock, flags);
> > +	wmb();
> 
> We want comments/explanation on all barriers or just "barrier();" ??

Ick, good catch, that shouldn't be needed, I'll go delete it.

> > +	/*
> > +	 * Build input device info
> > +	 */
> > +	usb_make_path(udev, path, 64);
> 
> s/64/sizeof(path)/

Thanks, will fix.

Thanks for the review, I appreciate it.

greg k-h
