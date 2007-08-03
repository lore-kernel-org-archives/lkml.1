Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbXHCQu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbXHCQu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXHCQuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:50:18 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:49027 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXHCQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:50:16 -0400
Date: Fri, 3 Aug 2007 17:50:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Message-ID: <20070803165000.GA22075@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030737.56316.david-b@pacbell.net> <20070803150303.GA19968@srcf.ucam.org> <200708030929.17049.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708030929.17049.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 09:29:16AM -0700, David Brownell wrote:
> On Friday 03 August 2007, Matthew Garrett wrote:
> > And, frankly, if I got a requestor like that every time I plugged in a 
> > new USB device I'd be fairly unhappy.
> 
> Which is why my comment was about something else entirely!
> 
> That is, having an out-of-kernel database which could preclude
> the need for such requestors for devices already known.

Plus a mechanism for pushing data into it, plus a mechanism for ensuring 
that inaccurate data doesn't get in there, plus some what of pushing 
updates out to users, plus privilege escalation for setting the value, 
plus policy management to ensure that normal users can't mess with the 
autosuspend values for other users? No, this isn't trivial - especially 
when there's a straightforward in-kernel mechanism (only enable it when 
it's known to be safe)

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

Both /proc/bus/usb and /dev/bus/usb are provided. Anything that fails to 
work with /dev/bus/usb is buggy - libusb copes fine. We're in the 
process of transitioning away from the legacy interface. It could be 
worse - we could have just removed it on the grounds that it doesn't 
work properly.

> > System/Preferences/Power Management
> 
> There's no option there to affect what happens when it's running
> on battery power.  Though I'm curious what it means when it has
> a "suspend" option (not "hibernate") ... I wouldn't mind STR.

That's odd. In the "On battery power" tab I see an option to choose the 
action when the battery power is critically low.

> > It can be, but I'd prefer to have userspace enable functionality than 
> > have the kernel break things.
> 
> That side of things has been absent from the discussion so far.
> 
> When something is wrongly blacklisted (by whatever), how are you
> proposing that it get un-blacklisted?  Seems to me that whatever
> mechanism resolves that issue should also work the other way around...

The worst case scenario in the "Disable by default, allow userspace to 
whitelist" case is that some machines draw slightly more power. The 
worst case scenario in the "Enable by default, allow userspace to 
blacklist" case is that some hardware doesn't work because of race 
conditions between autosuspend and userspace having the opportunity to 
disable it, or devices not being in the blacklist, or somebody not 
having adequately new usrspace, or...
-- 
Matthew Garrett | mjg59@srcf.ucam.org
