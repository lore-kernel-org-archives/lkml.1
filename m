Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXBKGyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXBKGyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXBKGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:54:31 -0500
Received: from 1wt.eu ([62.212.114.60]:2323 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXBKGya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:54:30 -0500
Date: Sun, 11 Feb 2007 07:54:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Message-ID: <20070211065404.GA943@1wt.eu>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101130.44471.rjw@sisk.pl> <Pine.LNX.4.64.0702101231281.20138@iabervon.org> <200702102050.28218.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702102050.28218.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 08:50:27PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 10 February 2007 18:52, Daniel Barkalow wrote:
> > On Sat, 10 Feb 2007, Rafael J. Wysocki wrote:
> > 
> > > On Saturday, 10 February 2007 11:02, Nigel Cunningham wrote:
> > >
> > > > Well, the original desire was to stop new drivers getting in without
> > > > proper power management.
> > > 
> > > I know, but I agree with the argument that having a driver without the
> > > suspend/resume support is better than not having the driver at all.
> > 
> > How about if "proper power management" is defined to include the driver 
> > explicitly preventing suspend? It seems to me like the current problem is 
> > that driver writers don't think about power management at all, and the 
> > result is that, after suspend/resume, the system doesn't come back. It 
> > would be better if driver writers had to think about power management just 
> > enough to realize that it's not going to work, and make this information 
> > available to the system. At that point, it's relatively easy for the 
> > system to do something useful about it.
> 
> Actually, it is easy for the driver authors to do this right now.  They can
> just make the .suspend() routine always return an error.
> 
> Well, I think this is a good idea: if the device in question requires specific
> power management during the suspend/resume, but it is not implemented by the
> driver, we should require the author of the driver to define the .suspend()
> routine that returns -ENOSYS (preferably, with an explanatory warning in
> dmesg).

instead of modifying all drivers to explicitly state that they don't support
it, we should start with a test of the NULL pointer for .suspend which should
mean exactly the same without modifying the drivers. I find it obvious that
a driver which does provide a suspend function will not support it. And if
some drivers (eg /dev/null) can support it anyway, it's better to change
*those* drivers to explicitly mark them as compatible.

regards,
Willy

