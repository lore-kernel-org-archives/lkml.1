Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbYDEEdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbYDEEdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 00:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYDEEdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 00:33:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41290 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYDEEdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 00:33:44 -0400
Date: Fri, 4 Apr 2008 21:37:41 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was:
	2.6.25-rc8-mm1]
Message-ID: <20080405043741.GA26420@kroah.com>
References: <Pine.LNX.4.44L0.0804041721080.2175-100000@iolanthe.rowland.org> <Pine.LNX.4.44L0.0804042331460.16995-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804042331460.16995-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 11:46:59PM -0400, Alan Stern wrote:
> On Fri, 4 Apr 2008, Alan Stern wrote:
> 
> > On Fri, 4 Apr 2008, Greg KH wrote:
> > 
> > > On Fri, Apr 04, 2008 at 10:16:32PM +0200, Jiri Slaby wrote:
> > > > On 04/02/2008 06:32 AM, Andrew Morton wrote:
> > > >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> > > >
> > > > After
> > > > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
> > > > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind
> > > >
> > > > I have this in logs:
> > > >
> > > > sysfs: duplicate filename 'usbdev4.12_ep81' can not be created
> > > 
> > > Does this also show up in 2.6.25-rc8 without -mm?
> > > 
> > > I thought I fixed this already, I don't see what slipped into -mm that
> > > would have caused it to come back.  Time to run some more tests...
> > > 
> > > Oh, also note that binding and unbinding the main "usb" driver is not
> > > encouraged, or even supported.  I'm amazed it works, as this is not
> > > something that any "real" user would do as it makes no sense at all
> > > because we have no "alternative" drivers yet for the main USB device.
> > 
> > It's a real bug.  I don't have time to track it down now.  Next week...
> 
> Here's the answer.  The bug was introduced when the definition of 
> device_is_registered() in include/linux/device.h was changed.  The old 
> definition returned 0 when called inside a driver's remove method for a 
> device being unregistered, whereas the new definition returns 1.  I 
> don't know when this change was made.

I've changed that in the -mm tree to make some PCI stuff much easier.  I
didn't realize that USB was depending on when this was being set, sorry
about it.

I like your fix better, it makes the code path much simpler :)

thanks,

greg k-h
