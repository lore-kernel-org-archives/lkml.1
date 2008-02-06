Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbYBFXIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbYBFXIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbYBFXF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:05:57 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:14232 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763477AbYBFXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:05:53 -0500
X-Trace: 660080574/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJ/MqUdRAVlC/2dsb2JhbACBWatK
Subject: Re: [PATCH 2/2] - SH/Dreamcast - fix maple bus bugs
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080206230127.GA9614@kroah.com>
References: <1202337981.6162.8.camel@localhost.localdomain>
	 <1202338431.6162.15.camel@localhost.localdomain>
	 <20080206230127.GA9614@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 23:05:14 +0000
Message-Id: <1202339114.6162.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 15:01 -0800, Greg KH wrote:
> On Wed, Feb 06, 2008 at 10:53:51PM +0000, Adrian McMenamin wrote:
> > -	dev->function = function;
> > -	dev->dev.bus = &maple_bus_type;
> > -	dev->dev.parent = &maple_bus;
> > -	dev->dev.release = &maple_release_device;
> > -	retval = device_register(&dev->dev);
> > -	if (retval) {
> > -		printk(KERN_INFO
> > -		       "Maple bus: Attempt to register device (%x, %x) failed.\n",
> > -		       dev->port, dev->unit);
> > -		maple_free_dev(dev);
> > +	mdev->function = function;
> > +	mdev->dev.release = &maple_release_device;
> > +	if (mdev->registered == 0) {
> > +		retval = device_register(&mdev->dev);
> > +		if (retval) {
> > +			printk(KERN_INFO
> > +			"Maple bus: Attempt to register device"
> > +			" (%x, %x) failed.\n",
> > +			mdev->port, mdev->unit);
> > +			maple_free_dev(mdev);
> > +			mdev = NULL;
> > +			return;
> > +		}
> > +		mdev->registered = 1;
> >  	}
> > -	dev->registered = 1;
> 
> I think you are still papering over the real problem here of trying to
> register a device twice.  That's something you should never be doing,
> and your bus walking logic must be incorrect...
> 
I just left that in as a sanity check. It should never be acted on. I
can remove it if you prefer.

