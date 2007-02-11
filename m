Return-Path: <linux-kernel-owner+w=401wt.eu-S1750746AbXBKR1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750746AbXBKR1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXBKR1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:27:10 -0500
Received: from iabervon.org ([66.92.72.58]:2690 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXBKR1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:27:09 -0500
Date: Sun, 11 Feb 2007 12:27:07 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
In-Reply-To: <200702111536.20871.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0702111154570.20138@iabervon.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111450.49736.rjw@sisk.pl>
 <20070211135708.GC1868@1wt.eu> <200702111536.20871.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007, Rafael J. Wysocki wrote:

> The problem is it was made implicit long ago.  The design is "optimistic", so
> to speak, and I think we have the following choices:
> 
> 1) Change the design to make the kernel refuse to suspend if there are any
> drivers not explicitly flagged as "suspend/resume-safe".  [This looks like a
> lot of work to me, but it is generally doable provided that someone has enough
> time to do it.  Unfortunately it has to be done in one shot for all of the
> known good drivers to avoid user-observable regressions.]

The kernel wouldn't necessarily have to refuse to suspend. It could just 
warn (and list the drivers that aren't marked), or could require some 
extra insistance from the user. It would be good to have it log a message 
saying something like: "If you can read this, report that ne2000 seems to 
be safe for suspend/resume". Having drivers explicitly marked as to 
whether they are safe is a good kernel feature; what to do if they're not 
is policy.

> 2) Require the authors of new drivers to _either_ ensure that their drivers
> will be suspend/resume-safe (and I mean both STR and STD here), _or_ explicitly
> flag the drivers as "suspend/resume-unsafe", for example by impelenting
> .suspend() routines returning -ENOSYS.  [The existing drivers can be modified
> to follow this convention gradually.]

I don't see any reason not to do (2) regardless of (1). That was (my idea 
of) the statement that started this thread: new drivers need to not mess 
up on suspend/resume, as a matter of suitability for inclusion. Of course, 
we need some way for drivers to indicate that they work fine with the 
PCI-layer defaults. And it should probably more machine-readable than the 
author telling reviewers that it works.

> - Problem what to do with drivers that work for some people and don't work
> for the others (ie. if we don't flag them as known good, we will break the
> setups in which they work)

I think the only interesting case here is when a device resumes fine with 
no driver support if the BIOS manages to deal effectively with it, but the 
BIOS generally doesn't. Otherwise, I think it's only going to work at 
all if the author put in the effort to make it work (so it should be 
"known good"), but there may be bugs (firmware, BIOS, driver, etc). But 
that's true of any functionality.

	-Daniel
*This .sig left intentionally blank*
