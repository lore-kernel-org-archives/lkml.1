Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZJZToK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZJZToK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbZJZToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:44:07 -0400
Received: from kroah.org ([198.145.64.141]:42975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbZJZToC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:44:02 -0400
Date: Mon, 26 Oct 2009 12:40:58 -0700
From: Greg KH <greg@kroah.com>
To: Antti =?iso-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix hso soft-lockup
Message-ID: <20091026194058.GA25263@kroah.com>
References: <1256200578.3057.113.camel@nomovok.homedomain>
 <20091026171550.GA24910@kroah.com>
 <1256585855.3591.52.camel@nomovok.homedomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256585855.3591.52.camel@nomovok.homedomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 09:37:35PM +0200, Antti Kaijanmäki wrote:
> > > ---
> > >  drivers/net/usb/hso.c |    9 ++++++---
> > >  1 files changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> > > index fa4e581..539642a 100644
> > > --- a/drivers/net/usb/hso.c
> > > +++ b/drivers/net/usb/hso.c
> > > @@ -2,6 +2,7 @@
> > >   *
> > >   * Driver for Option High Speed Mobile Devices.
> > >   *
> > > + *  Copyright (C) 2009 Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
> > 
> > Adding a copyright for a few lines changed is not really correct.
> 
> Well, it depends on policy. Some might argue that if you make a change
> of any sort you must include your copyright notice. I also used a fair
> amount of time to track down the problem so this is not just a
> whitespace fix or something. But I understand if this is not considered
> substantial enough to justify copyright notice and will leave this out
> from the revised patch.

According to some lawyers whom I have discussed this with, you need to
have written at least 1/3 of the lines in the file to be able to claim
this in the file itself.  That might not be true, but is a good
guideline that I've used over the years.

You always own the copyright to your individual change though, and git
preserves that information for all time as well.

> > > @@ -1527,7 +1530,7 @@ static void tiocmget_intr_callback(struct urb *urb)
> > >  		dev_warn(&usb->dev,
> > >  			 "hso received invalid serial state notification\n");
> > >  		DUMP(serial_state_notification,
> > > -		     sizeof(hso_serial_state_notifation))
> > > +		     sizeof(struct hso_serial_state_notification));
> > 
> > Is this a build fix not related to the bug above?
> 
> No, as I commented on commit log message the patch also fixes the debug
> routines. They have to be enabled by hand by uncommenting a DEBUG define
> on the top of the file so this is not anything fatal, just minor
> inconvenience.
> 
> I thought the debug routines were not important enough to have their own
> patch and could be included in this patch as the patch is very small and
> the debug routines do not affect any default functionality. Naturally I
> can remove the debug routine fix if you want. It's trivial for anyone to
> fix them when needed :)

Yes, that should be a new patch, especially as it would not be needed
to fix older kernels for the original bug.

So, care to send 2 patches?  The debug one isn't needed to be sent to
the stable@kernel.org address.

thanks,

greg k-h
