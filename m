Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXE0JNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXE0JNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXE0JNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:13:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58397 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXE0JNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:13:44 -0400
Date: Sun, 27 May 2007 01:57:41 -0700
From: Greg KH <greg@kroah.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dtor@insightbb.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070527085741.GA14141@kroah.com>
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca> <200705222243.56007.dtor@insightbb.com> <20070523042145.GA27329@kroah.com> <46544130.1010901@rtr.ca> <20070523151426.GB26046@kroah.com> <46585C52.7020808@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46585C52.7020808@tmr.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 12:12:02PM -0400, Bill Davidsen wrote:
>  Greg KH wrote:
> > On Wed, May 23, 2007 at 09:27:12AM -0400, Mark Lord wrote:
> >>  Greg KH wrote:
> >>> And yes, it only starts to look for things when it recieves an event, it
> >>> does not "scan" sysfs at all.
> >>  Does it "look for" only that one event, or does it "scan" at that point?
> > udev will act on that event, and as I mentioned, not read anything from
> > sysfs at all, unless a custom rule is in the rules file asking it to
> > read a specific sysfs file in the tree.
> > So no "scanning" happens unless specificically asked for.
> > And as mentioned, udev can work just fine without sysfs enabled at all
> > now, with the exception of some custom rules for some devices.
>  I think what Mark is asking is about the case where udev gets an event, is 
>  told to look in sysfs, and while looking encounters a partially described 
>  device.
> 
>  Now that the "this won't happen unless..." cases, could someone cover this 
>  and state that it either can't happen because {reason} or that if it does 
>  the result will be {description}.

It can happen if the attributes are added after the device is created,
so you need to add your attributes to the default groups before it is
registered with the driver core.

thanks,

greg k-h
