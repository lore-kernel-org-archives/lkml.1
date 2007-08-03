Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXHCPDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXHCPDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761911AbXHCPDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:03:17 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:44374 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761649AbXHCPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:03:16 -0400
Date: Fri, 3 Aug 2007 16:03:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Message-ID: <20070803150303.GA19968@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030701.11404.david-b@pacbell.net> <20070803140909.GA19245@srcf.ucam.org> <200708030737.56316.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708030737.56316.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 07:37:55AM -0700, David Brownell wrote:
> On Friday 03 August 2007, Matthew Garrett wrote:
> > Popping up a box saying "Is your device broken?" isn't good UI. 
> 
> Which is why I didn't suggest doing that, of course.  The only
> one making that kind of straw man argument seems to be you.

But however you phrase it, that's effectively what it is. "Does your 
device work?" just makes users wonder why the damn computer doesn't know 
already. "This option may prevent your device from working. Click here 
to switch it off" results in them wondering why it was switched on in 
the first place. Many of our users aren't technical - they don't care 
about saving 200mW, they just care about their printer working when they 
plug it in.

And, frankly, if I got a requestor like that every time I plugged in a 
new USB device I'd be fairly unhappy.

> > No. But given a choice between working hardware or marginally better 
> > runtime PM, they're going to choose working hardware.
> 
> However, you've strongly implied that you want to see a short term
> patch, of the type which will (as Rogan Dawes implied) prevent solving
> the problem in the long term ...

Because I don't believe we'll ever identify every device that gets 
broken, and so as a result I think it's better to disable the 
functionality by default for anything that might be broken.

> If I were to describe any dialog users would see, it would be more
> like "I don't recognize this device, help me set it up right...".
> As with music CDs, that help might update the database for the next
> person.  (Assuming this were done well, of course.)

Users understand CDs. They don't understand runtime power management.

> > I'm speaking as part of the Ubuntu kernel team, and I've been discussing 
> > this with Fedora people.
> 
> And has the discussion included the userspace people?  (I don't
> know how Ubuntu or Fedora folk structure such platform-scope
> tasks.  By inference, there's not enough cross-pollination...)

I also handle a lot of the desktop/kernel integration.

> Speaking of which, what's this /dev/bus/usb/* crap on Ubuntu?
> I had to undo all that on my Feisty system before any normal
> /proc/bus/usb stuff would work again.

"Usbfs files can't handle Access Control Lists (ACL), which are the 
default way to grant access to USB devices for untrusted users of a 
desktop system. The usbfs functionality is replaced by real device-nodes 
managed by udev. These nodes live in /dev/bus/usb and are used by 
libusb."

(From Kconfig)

> > You commonly run a laptop off battery while having a printer plugged in?
> 
> Unfortunately I need to run laptop off AC since its battery life is
> painfully short, and since Linux behaves so incredibly rudely when
> the battery power goes down to almost-zero:  it lets it go to zero
> rather than hibernating.  (And doesn't automatically enter suspend
> when it idles, either...)

System/Preferences/Power Management

> Note by the way that if you were -- for the sake of argument -- accept
> my premise that this should all be handled in userspace ... it's very
> easy to make userspace code do what you want.  It doesn't need to be
> done inside the kernel.

It can be, but I'd prefer to have userspace enable functionality than 
have the kernel break things.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
