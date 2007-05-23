Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXEWEWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXEWEWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXEWEWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:22:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38394 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbXEWEV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:21:59 -0400
Date: Tue, 22 May 2007 21:21:45 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Mark Lord <lkml@rtr.ca>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070523042145.GA27329@kroah.com>
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca> <200705222243.56007.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705222243.56007.dtor@insightbb.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 10:43:55PM -0400, Dmitry Torokhov wrote:
> On Tuesday 22 May 2007 17:24, Mark Lord wrote:
> > Dmitry Torokhov wrote:
> > > 1. dev->uevent_suppress = 1;
> > > 2. device_register(dev);
> > > 3. device_create_file(dev, ...);
> > > 4. dev->uevent_suppress = 0;
> > > 5. kobject_uevent(&dev->kobj, KOBJ_ADD);
> > 
> > I don't see how that prevents an already-running udevd
> > from seeing the partially filled in /sys/ entry,
> > if it were.. say.. already doing a /sys scan,
> > or even just during initial startup.
> 
> I tought udev relies on uevents and does not hunt through sysfs on
> its own...

Actually, udev can run without sysfs at all these days :)

And yes, it only starts to look for things when it recieves an event, it
does not "scan" sysfs at all.

thanks,

greg k-h
