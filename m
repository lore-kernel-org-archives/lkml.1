Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbXBLAXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbXBLAXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXBLAXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:23:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXBLAXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:23:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 01:20:53 +0100
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171233454.4493.74.camel@nigel.suspend2.net> <45CFB06B.5080102@imap.cc>
In-Reply-To: <45CFB06B.5080102@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120120.54967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 12 February 2007 01:10, Tilman Schmidt wrote:
> Hi,
> 
> Am 11.02.2007 23:37 schrieb Nigel Cunningham:
> > On Sun, 2007-02-11 at 00:45 +0100, Tilman Schmidt wrote:
> >> Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> >>> If your device requires power management, and you know it requires power
> >>> management, why not just implement power management? [...]
> >> Like it or not, power management is far from trivial, and people
> >> writing device drivers have limited resources. [...]
> > It's not that complex. All we're really talking about is a bit of extra
> > code to cleanup and configure hardware state; things that the driver
> > author already knows how to do. S3 might require a bit more
> > initialisation if firmware needs to be reloaded or more extensive
> > configuration needs to be done, but if there's firmware to be loaded,
> > there is a reasonably good probability that we loaded it from Linux to
> > start with anyway.
> 
> You are assuming a perfect world where driver authors have complete
> knowledge of their devices. In reality, many drivers (including
> those I have the mixed pleasure of maintaining) are based at least
> in part on reverse engineering, and managing power states may well
> fall into the domain of things not yet sufficiently reverse
> engineered.

Exactly.

> >> Also, in your argument you neglected a few cases:
> >> - What if my device does not require power management?
> > 
> > Then you as a generic routine that does nothing but return success
> > (potentially shared with other drivers that are in the same situation).
> 
> But if I just write an empty routine like that I open myself up to
> criticism along the lines of "writing dummy routines just in order
> to shut up kernel warnings". BTDT.

Well, for me the design that required driver authors to write empty routines
returning success, would be bad.

> >> - What if I don't know whether my device requires power management?
> > 
> > The questions are straight forward: Is there hardware state that needs
> > to be configured if you've just booted the computer and nothing else has
> > touched it? If so, that needs to be done in a resume method. Do you need
> > to clean up state prior to doing the things in the resume method, or
> > otherwise do things to quiesce the driver? If so, they will need to be
> > done in the suspend method. The result will be roughly similar to what
> > you do for module load/unload, except maybe less complete in some cases.
> 
> I don't doubt your basic assessment. However it doesn't translate that
> easily into a real implementation. In my case, I maintain a USB driver,
> so I have to deal with USB specifics of suspend/resume which happen not
> to be that well documented. My driver provides an isdn4linux device but
> isdn4linux knows nothing about suspend/resume so I am on my own on how
> to reconcile the two. The device itself, though in turn far from trivial,
> is actually the least of my worries.
> 
> >> - What if I know my device would require power management, but don't
> >>   know how to implement it?
> > 
> > I've just told you above :) Now you know!
> 
> No I don't. See above.
> 
> >>> -ENOSYS is just not acceptable.
> >> Your argument falls down the moment you consider the alternative:
> >> not merging the driver means that the device won't work at all.
> >> (Given that out-of-tree drivers are actively discouraged, to put
> >> it mildly.) That's arguably farther from "desktop readiness" than
> >> a device not supporting power management.
> > 
> > I disagree (but I would, of course!). If we apply your logic
> > consistently, we should merge the driver as soon as any code is written
> > for it (anything is better than nothing). I'm simply arguing that a
> > driver that handling suspend and resume should be as much of a
> > requirement as not causing memory corruption or such like are.
> 
> Well, that's a common fallacy about applying any logic consistently.
> There's a continuum of usefulness from "hardly works at all" through
> "causes random memory corruption", "doesn't support power management",
> and "does not support some esoteric protocol variety no one ever heard
> of anyways" up to "supports any and all uses to which anyone could
> possibly want to put the device". I would argue that "doesn't support
> power management" is *much* farther up that ladder than, for example,
> "causes random memory corruption".

 I agree with that.  Moreover, I think that the suspend/resume support is
something you _can_ _live_ without while living, for instance, without
networking at all would be difficult these days. Therefore I would certainly
accept the driver that didn't support suspend/resume for my network adapter
and I'd be happy to use it anyway.

On the other hand, it would be nice if that driver did something that would
prevent the system from suspending when it's loaded, just in case.

Greetings,
Rafael
