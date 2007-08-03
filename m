Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbXHCQaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbXHCQaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXHCQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:29:55 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:31458 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752573AbXHCQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:29:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r5VzyFv+pKO2ObxVErK5YufA7lP09RFP5oLz9l87BbKKiyx6vipjM0lbbPtOP+vK0CjrJRwJgs5SNgT4psvUTe0CkhkMO0kY1oCPl/QSVVvgvr+jxAt2oSeJ/+69pochRjKSAWJO4la0lTYhZkIkiUGB+qXvTyyqD8ZIsNm9UVs=  ;
X-YMail-OSG: OUPVhQQVM1l7uFznp75Qy_uVJrBnxRX9QpYFgdKlJFs45sMb8DmOaShWnS4ExSbqFTsjVuzJfDJ7gsy2EDA38QBW3it6hGtXb7HBmEXtp7d8rpJ.GK3Z35nCrNbpcA--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 09:29:16 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030737.56316.david-b@pacbell.net> <20070803150303.GA19968@srcf.ucam.org>
In-Reply-To: <20070803150303.GA19968@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030929.17049.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 07:37:55AM -0700, David Brownell wrote:
> > On Friday 03 August 2007, Matthew Garrett wrote:
> > > Popping up a box saying "Is your device broken?" isn't good UI. 
> > 
> > Which is why I didn't suggest doing that, of course.  The only
> > one making that kind of straw man argument seems to be you.
> 
> But however you phrase it, that's effectively what it is.

As http://en.wikipedia.org/wiki/Straw_Man phrases it,
"A straw man argument is an informal fallacy based on
misrepresentation of an opponent's position ... the
opponent's actual argument has not been refuted."

That's clearly what you've been doing by proposing some
specific -- and obviously bad -- user interfaces, none
of which have the fundamental characteristic I described.


> And, frankly, if I got a requestor like that every time I plugged in a 
> new USB device I'd be fairly unhappy.

Which is why my comment was about something else entirely!

That is, having an out-of-kernel database which could preclude
the need for such requestors for devices already known.


> > If I were to describe any dialog users would see, it would be more
> > like "I don't recognize this device, help me set it up right...".
> > As with music CDs, that help might update the database for the next
> > person.  (Assuming this were done well, of course.)
> 
> Users understand CDs. They don't understand runtime power management.

A new straw man!  Because power management isn't the relevant point.

All they'd ever have to understand is:  is it working correctly right
now?  That's after an experimental autosuspend, and after poking the
hardware to verify that, from the kernel perspective, it acts OK.

Oliver pointed out that the typical failure mode is easily detected
in software.  So when the user says "OK, I'll help set it up", the
worst case would be that the device is NOT recorded already in that
database, the user might need to be ready to unplug then replug the
device (when that experiment fails).


> > Speaking of which, what's this /dev/bus/usb/* crap on Ubuntu?
> > I had to undo all that on my Feisty system before any normal
> > /proc/bus/usb stuff would work again.
> 
> "Usbfs files can't handle Access Control Lists (ACL), which are the 
> default way to grant access to USB devices for untrusted users of a 
> desktop system. The usbfs functionality is replaced by real device-nodes 
> managed by udev. These nodes live in /dev/bus/usb and are used by 
> libusb."
> 
> (From Kconfig)

That's shortly after the explanation that the relevant Kconfig
option is for  ** /proc/bus/usb ** files ... note that despite the
strangeness in that text (usbfs still hasn't been "replaced", so
that should say "will eventually be replaced" not "is replaced"),
it's clear that /proc/bus/usb/ and /dev/bus/usb/ are two different
things.  And thus:  that Ubuntu's /dev/bus/usb/ setup is flakey.


> > > You commonly run a laptop off battery while having a printer plugged in?
> > 
> > Unfortunately I need to run laptop off AC since its battery life is
> > painfully short, and since Linux behaves so incredibly rudely when
> > the battery power goes down to almost-zero:  it lets it go to zero
> > rather than hibernating.  (And doesn't automatically enter suspend
> > when it idles, either...)
> 
> System/Preferences/Power Management

There's no option there to affect what happens when it's running
on battery power.  Though I'm curious what it means when it has
a "suspend" option (not "hibernate") ... I wouldn't mind STR.


> > Note by the way that if you were -- for the sake of argument -- accept
> > my premise that this should all be handled in userspace ... it's very
> > easy to make userspace code do what you want.  It doesn't need to be
> > done inside the kernel.
> 
> It can be, but I'd prefer to have userspace enable functionality than 
> have the kernel break things.

That side of things has been absent from the discussion so far.

When something is wrongly blacklisted (by whatever), how are you
proposing that it get un-blacklisted?  Seems to me that whatever
mechanism resolves that issue should also work the other way around...

- Dave

