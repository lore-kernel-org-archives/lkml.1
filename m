Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXBKSzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXBKSzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXBKSzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:55:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXBKSzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:55:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Barkalow <barkalow@iabervon.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 19:53:00 +0100
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111536.20871.rjw@sisk.pl> <Pine.LNX.4.64.0702111154570.20138@iabervon.org>
In-Reply-To: <Pine.LNX.4.64.0702111154570.20138@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111953.02229.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 18:27, Daniel Barkalow wrote:
> On Sun, 11 Feb 2007, Rafael J. Wysocki wrote:
> 
> > The problem is it was made implicit long ago.  The design is "optimistic", so
> > to speak, and I think we have the following choices:
> > 
> > 1) Change the design to make the kernel refuse to suspend if there are any
> > drivers not explicitly flagged as "suspend/resume-safe".  [This looks like a
> > lot of work to me, but it is generally doable provided that someone has enough
> > time to do it.  Unfortunately it has to be done in one shot for all of the
> > known good drivers to avoid user-observable regressions.]
> 
> The kernel wouldn't necessarily have to refuse to suspend.

Well, not from the start, but I think at some point in the fufure it would.

> It could just warn (and list the drivers that aren't marked), or could
> require some extra insistance from the user.

We would have to change the interface for that and I don't want to do it.

> It would be good to have it log a message saying something like: "If you can
> read this, report that ne2000 seems to be safe for suspend/resume".

Sure, it would.

> Having drivers explicitly marked as to whether they are safe is a good kernel
> feature; what to do if they're not is policy.

That's true, but I assume that the people who opt for doing that are also
willing to take part in the review of the drivers. :-)

> > 2) Require the authors of new drivers to _either_ ensure that their drivers
> > will be suspend/resume-safe (and I mean both STR and STD here), _or_ explicitly
> > flag the drivers as "suspend/resume-unsafe", for example by impelenting
> > .suspend() routines returning -ENOSYS.  [The existing drivers can be modified
> > to follow this convention gradually.]
> 
> I don't see any reason not to do (2) regardless of (1). That was (my idea 
> of) the statement that started this thread: new drivers need to not mess 
> up on suspend/resume, as a matter of suitability for inclusion. Of course, 
> we need some way for drivers to indicate that they work fine with the 
> PCI-layer defaults. And it should probably more machine-readable than the 
> author telling reviewers that it works.

Well, if we change the design to fail by default, the authors of new drivers
will only have to flag them if they believe that the drivers are
suspend/resume-safe.

> > - Problem what to do with drivers that work for some people and don't work
> > for the others (ie. if we don't flag them as known good, we will break the
> > setups in which they work)
> 
> I think the only interesting case here is when a device resumes fine with 
> no driver support if the BIOS manages to deal effectively with it, but the 
> BIOS generally doesn't.

Well, I don't think so.  Let's estimate the number of drivers that define
.resume() right now:

$ grep -I -l -r '.resume =' linux-2.6.20/drivers/ | wc
    102     102    4169

And I think there are much more drivers that really work fine with respect
to the suspend/resume.

This indicates that in fact many drivers can be marked as known good even
though they don't define the .suspend() or .resume() routines.

Greetings,
Rafael
