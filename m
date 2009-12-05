Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbZLEAj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbZLEAj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932717AbZLEAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:39:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:43796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbZLEAjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:39:22 -0500
Date: Fri, 4 Dec 2009 16:35:33 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, stable@kernel.org,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Message-ID: <20091205003533.GD8792@suse.de>
References: <200912041423.10632.dmitry.torokhov@gmail.com>
 <Pine.LNX.4.44L0.0912041844450.5593-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912041844450.5593-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 06:50:35PM -0500, Alan Stern wrote:
> On Fri, 4 Dec 2009, Dmitry Torokhov wrote:
> 
> > > Maybe reference counting is inelegant; it depends on your point of
> > > view.  Can you think of a more elegant way to make sure that a pointer
> > > isn't stale?
> > 
> > Yes, just say "no" to device_create() and friends.
> 
> device_create() wasn't used in the case Oliver is discussing.

It was implied, as you had a pointer to the device, not the device
itself.

> >  Embed device structure in
> > yours,
> 
> You can't do that when the device structure wasn't created by your 
> driver.

But for USB devices, it is part of the device you are handed.  Same goes
for PCI devices, and most other types of drivers, right?

> >  be mindful of lifetime rules and only use "your" device (i.e device
> > bound to your driver).
> 
> What do you mean by "use"?  In Oliver's case he wasn't using the
> device, he was using the device structure.  (Maybe that's what you
> meant.)

I think that is what is meant here.

> And he wanted to use it at a time when it wasn't bound to his
> driver, because userspace still had an open file reference to it.  
> There isn't really any way around this.

But you still have a valid device, just not maybe a driver bound to it.

> > This way, as long as your refcount your instance you
> > can rest assured the device structure is there as well.
> 
> I rather think that a simple device_get() and device_put() is easier 
> than trying to follow a bunch of rules, especially in cases where they 
> don't apply!  :-)

Like here :)

thanks,

greg k-h
