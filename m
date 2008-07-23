Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYGWANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYGWANp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYGWANg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:13:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:47922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYGWANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:13:36 -0400
Date: Tue, 22 Jul 2008 17:11:33 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       g.liakhovetski@pengutronix.de
Subject: Re: [patch 2.6.26-rc5] gpio: sysfs interface (updated)
Message-ID: <20080723001133.GA8592@kroah.com>
References: <200806121153.36557.david-b@pacbell.net> <20080722162751.e8584d46.akpm@linux-foundation.org> <20080722232824.GA22596@kroah.com> <200807221701.36462.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807221701.36462.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 05:01:36PM -0700, David Brownell wrote:
> On Tuesday 22 July 2008, Greg KH wrote:
> > 
> > > device_create_drvdata() has magically vanished from today's linux-next,
> > > so this code doesn't compile any more.
> > > 
> > > This:
> > > 
> > > @@ -453,8 +453,8 @@ int gpio_export(unsigned gpio, bool dire
> > >       if (status == 0) {
> > >               struct device   *dev;
> > >  
> > > -             dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
> > > -                             desc, "gpio%d", gpio);
> > > +             dev = device_create(&gpio_class, desc->chip->dev, 0, desc,
> > > +                                     "gpio%d", gpio);
> > 
> > Should be NULL instead of 0 there, otherwise sparse will complain.
> 
> The zero is a dev_t ... ??  (As Andrew just noted too.)
> 
> "desc" might need to be NULL, but it's a valid pointer
> (for driver_data).  I think this was a mental off-by-one...

Yes, you are correct, my mistake.

greg k-h
