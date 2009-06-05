Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZFEPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZFEPOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZFEPOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:14:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58397 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZFEPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:14:13 -0400
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
       kay.sievers@vrfy.org
In-Reply-To: <4A2934F5.4050601@tuffmail.co.uk>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
	 <1244209873.23533.29.camel@penberg-laptop>
	 <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com>
	 <1244213412.23533.41.camel@penberg-laptop>
	 <4A2931F5.1090709@tuffmail.co.uk>  <4A2934F5.4050601@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 18:14:13 +0300
Message-Id: <1244214853.23533.43.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, 2009-06-05 at 16:08 +0100, Alan Jenkins wrote:
> Alan Jenkins wrote:
> > Pekka Enberg wrote:
> >> Hi Alan,
> >>
> >> On Fri, 2009-06-05 at 15:38 +0100, Alan Jenkins wrote:
> >>  
> >>> Ok.  I didn't bother shutting down my system, but I get a similar
> >>> difference; 16 wakeups/s disabled v.s. 25 enabled.  Anecdotally,
> >>> disabling the camera does help battery life, and presumably Asus had
> >>> good reason to implement it!  (The shipped OS "fixes" the usability
> >>> problem by patching the camera apps).
> >>>
> >>> BUT I found that autosuspend didn't seem to break anything, and
> >>> enabling it also got me down to 16 wakeups/s.  I think this is ideal
> >>> because autosuspend is automatic so I can save power without manual
> >>> toggling.
> >>>
> >>> Here's some magic to enable autosuspend:
> >>>
> >>> # echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
> >>>
> >>> Ideally this wants to be enabled automatically using a udev rule.
> >>>     
> >>
> >> Can the kernel do this by default for this specific driver on eeepc?
> >>
> >>             Pekka
> >>
> >>   
> >
> > Auto-suspend white-listing would be done on the basis of USB ids 
> > (vendor, product).  At the moment it's expected that userspace should 
> > take ownership of it.  There's no infrastructure for in-kernel 
> > whitelisting.  I think.
> >
> > Large lists in udev rules can work, there are already lists of USB 
> > devices to set permissions for libusb access, e.g. for libmtp.
> >
> > [CC usb list - in the hope someone will point out if I got this wrong 
> > :-)]
> >
> > Alan
> 
> Btw I've now tested the udev rule, you can just dump this in a new 
> .rules file under /etc/udev/rules.d:
> 
> SUBSYSTEM=="usb", ATTR{idVendor}=="eb1a", ATTR{idProduct}=="2761", ATTR{power/level}="auto"
> 
> 
> Not sure who I should submit it to though :-).  debian-eeepc would take 
> it, but perhaps it should go in udev's default rules.

AFAIK, Kay Sievers maintains the udev rules so lets cc him. And yeah, I
totally agree that it should go to the generic ones, not to
debian-eeepc.

			Pekka

