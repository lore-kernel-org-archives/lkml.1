Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXHCRqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXHCRqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbXHCRqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:46:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:54020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbXHCRqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:46:43 -0400
Date: Fri, 3 Aug 2007 10:49:00 -0700
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-usb-devel@lists.sourceforge.net, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803174900.GB17053@suse.de>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030737.56316.david-b@pacbell.net> <20070803150303.GA19968@srcf.ucam.org> <200708030929.17049.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708030929.17049.david-b@pacbell.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 09:29:16AM -0700, David Brownell wrote:
> On Friday 03 August 2007, Matthew Garrett wrote:
> > > Speaking of which, what's this /dev/bus/usb/* crap on Ubuntu?
> > > I had to undo all that on my Feisty system before any normal
> > > /proc/bus/usb stuff would work again.
> > 
> > "Usbfs files can't handle Access Control Lists (ACL), which are the 
> > default way to grant access to USB devices for untrusted users of a 
> > desktop system. The usbfs functionality is replaced by real device-nodes 
> > managed by udev. These nodes live in /dev/bus/usb and are used by 
> > libusb."
> > 
> > (From Kconfig)
> 
> That's shortly after the explanation that the relevant Kconfig
> option is for  ** /proc/bus/usb ** files ... note that despite the
> strangeness in that text (usbfs still hasn't been "replaced", so
> that should say "will eventually be replaced" not "is replaced"),
> it's clear that /proc/bus/usb/ and /dev/bus/usb/ are two different
> things.  And thus:  that Ubuntu's /dev/bus/usb/ setup is flakey.

Hm, if you look at SuSE and Fedora, they too are putting usbfs in
/dev/bus/usb/ now, not mounting the filesystem, but using the device
nodes for access due to ACLs for local users.

libusb works just fine with this, and I think that all other programs
that directly access the old /proc/bus/usb mount are fixed up, with the
exception of usbview (but I do have patches floating around for that to
solve it.)

thanks,

greg k-h
