Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYGVXyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYGVXyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYGVXym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:54:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:42526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYGVXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:54:41 -0400
Date: Tue, 22 Jul 2008 16:51:55 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       g.liakhovetski@pengutronix.de
Subject: Re: [patch 2.6.26-rc5] gpio: sysfs interface (updated)
Message-ID: <20080722235155.GA7232@kroah.com>
References: <200806121153.36557.david-b@pacbell.net> <20080722162751.e8584d46.akpm@linux-foundation.org> <20080722232824.GA22596@kroah.com> <20080722163924.33e9ff84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722163924.33e9ff84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 04:39:24PM -0700, Andrew Morton wrote:
> On Tue, 22 Jul 2008 16:28:24 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Jul 22, 2008 at 04:27:51PM -0700, Andrew Morton wrote:
> > > On Thu, 12 Jun 2008 11:53:36 -0700
> > > David Brownell <david-b@pacbell.net> wrote:
> > > 
> > > > This adds a simple sysfs interface for GPIOs.
> > > 
> > > device_create_drvdata() has magically vanished from today's linux-next,
> > > so this code doesn't compile any more.
> > > 
> > > This:
> > > 
> > > --- a/drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix
> > > +++ a/drivers/gpio/gpiolib.c
> > > @@ -453,8 +453,8 @@ int gpio_export(unsigned gpio, bool dire
> > >  	if (status == 0) {
> > >  		struct device	*dev;
> > >  
> > > -		dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
> > > -				desc, "gpio%d", gpio);
> > > +		dev = device_create(&gpio_class, desc->chip->dev, 0, desc,
> > > +					"gpio%d", gpio);
> > 
> > Should be NULL instead of 0 there, otherwise sparse will complain.
> > 
> > 
> > >  		if (dev) {
> > >  			if (direction_may_change)
> > >  				status = sysfs_create_group(&dev->kobj,
> > > @@ -537,8 +537,8 @@ static int gpiochip_export(struct gpio_c
> > >  
> > >  	/* use chip->base for the ID; it's already known to be unique */
> > >  	mutex_lock(&sysfs_lock);
> > > -	dev = device_create_drvdata(&gpio_class, chip->dev, 0, chip,
> > > -			"gpiochip%d", chip->base);
> > > +	dev = device_create(&gpio_class, chip->dev, 0, chip, "gpiochip%d",
> > > +				chip->base);
> > 
> > Same here.
> > 
> 
> And is this change safe to merge into mainline?  Or should it wait
> until device_create_drvdata-removal and any associated stuff has
> merged?

This is safe to go to mainline now, device_create() and
device_create_drvdata() are both there (they are the same thing right
now), so it is fine.

after -rc1 is out, device_create_drvdata() is going to go away.

thanks,

greg k-h
