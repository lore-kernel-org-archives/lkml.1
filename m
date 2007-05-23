Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbXEWEZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbXEWEZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbXEWEZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:25:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbXEWEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:25:42 -0400
Date: Tue, 22 May 2007 21:24:18 -0700
From: Greg KH <greg@kroah.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Kristian H?gsberg <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070523042418.GB27329@kroah.com>
References: <46502A8B.70803@drzeus.cx> <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com> <4651E866.5010304@drzeus.cx> <1179775695.3320.82.camel@lov.localdomain> <46530F02.7010802@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46530F02.7010802@drzeus.cx>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 05:40:50PM +0200, Pierre Ossman wrote:
> Kay Sievers wrote:
> > We could change the driver-core to suppress the creation of an attribute
> > if the attribute's show() or store() method returns something like
> > -ENOENT at registration time?
> > The driver would pass _all_ possible attributes of the device at
> > registration time, but the core would only create the attributes which
> > are implemented for this particular device? Would that work for you?
> >   
> 
> Not sure. Not in an obvious way at least.
> 
> It also doesn't feel like "the kernel way". Generally you can
> create/allocate an object, assign attributes to it, then activate it.
> Couldn't it be done so that I can add sysfs stuff to a device after I
> just initialized it? (but before I add it).

No, unfortunatly it doesn't work that way today, sorry.

> > You can assign any number of attribute groups to the device. If they
> > don't have a group name, they will all be created directly at the device
> > level. Would that work for you?
> >
> >   
> 
> I've had a look at sysfs groups and the biggest beef I have with those
> is that they're too low level. In order to use them I first need to
> create device attributes, then create an array of pointers to each attr
> member. It would be nice if I could just feed an array of device
> attributes (i.e. I want wrappers).

If you can come up with a wrapper that will work, please let me know and
I'll be glad to add it.  Right now, it's pretty darn simple to do this
(look at the USB and PCI core code for examples if you need it.)

Anyway, groups are what you want and need, please use them and then you
don't have to worry about triggering an event later after you have
created your files on your own.

I'll try to get the time to add the "create a group and test the files
before adding them" variant soon so that firewire and others can use
them easier instead of having to roll their own code for it.

thanks,

greg k-h
