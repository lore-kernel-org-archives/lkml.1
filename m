Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXHXSAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXHXSAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXHXR75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:59:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39457 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760559AbXHXR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:59:57 -0400
Date: Fri, 24 Aug 2007 13:59:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       <torvalds@linux-foundation.org>, Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, <stable@kernel.org>,
       <alan@lxorguk.ukuu.org.uk>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute
 registration bug
In-Reply-To: <20070824154906.GA19239@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Greg KH wrote:

> > Odd.  This doesn't include the entire patch; the second hunk is
> > missing.  It should go on to say:
> > 
> > @@ -1109,10 +1113,12 @@ static void acm_disconnect(struct usb_interface *intf)
> >  		return;
> >  	}
> >  	if (acm->country_codes){
> > -		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
> > -		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
> > +		device_remove_file(&acm->control->dev,
> > +				&dev_attr_wCountryCodes);
> > +		device_remove_file(&acm->control->dev,
> > +				&dev_attr_iCountryCodeRelDate);
> >  	}
> > -	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
> > +	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
> 
> 
> I thought so too, untill you look at the 2.6.22.5 release, which already
> has that change in it for some reason.
> 
> So that part of the patch drops out, it turns out you just reverted
> things back to the way things used to be here :)

I don't understand.  The history for stable/linux-2.6.22.y.git at
http://git.kernel.org shows that the commit for my patch, labelled

	6b30a4e1c357410a78d7bcb831743b0e99bab4ad,

includes both hunks.  And patch-2.6.22.5.bz2 includes both as well.  
Something's fishy.

Alan Stern

