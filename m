Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXHXSGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXHXSGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764754AbXHXSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:05:40 -0400
Received: from ns.suse.de ([195.135.220.2]:38576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbXHXSFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:05:39 -0400
Date: Fri, 24 Aug 2007 11:04:23 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute
	registration bug
Message-ID: <20070824180423.GA5458@suse.de>
References: <20070824154906.GA19239@kroah.com> <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 01:59:55PM -0400, Alan Stern wrote:
> On Fri, 24 Aug 2007, Greg KH wrote:
> 
> > > Odd.  This doesn't include the entire patch; the second hunk is
> > > missing.  It should go on to say:
> > > 
> > > @@ -1109,10 +1113,12 @@ static void acm_disconnect(struct usb_interface *intf)
> > >  		return;
> > >  	}
> > >  	if (acm->country_codes){
> > > -		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
> > > -		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
> > > +		device_remove_file(&acm->control->dev,
> > > +				&dev_attr_wCountryCodes);
> > > +		device_remove_file(&acm->control->dev,
> > > +				&dev_attr_iCountryCodeRelDate);
> > >  	}
> > > -	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
> > > +	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
> > 
> > 
> > I thought so too, untill you look at the 2.6.22.5 release, which already
> > has that change in it for some reason.
> > 
> > So that part of the patch drops out, it turns out you just reverted
> > things back to the way things used to be here :)
> 
> I don't understand.  The history for stable/linux-2.6.22.y.git at
> http://git.kernel.org shows that the commit for my patch, labelled
> 
> 	6b30a4e1c357410a78d7bcb831743b0e99bab4ad,
> 
> includes both hunks.  And patch-2.6.22.5.bz2 includes both as well.  
> Something's fishy.

Ah crap, I see it now, this was already applied, I tried to apply it
again, it went with some fuzz for one chunk, which I ignored.

I'm starting to really appreciate Linus's hate for patch-fuzz :)

I'll drop this from the queue as it's already in the -stable series.
Thanks for pointing out my mistake, I appreciate it.

greg k-h
