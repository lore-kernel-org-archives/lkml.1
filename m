Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXGHSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXGHSTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXGHSTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:19:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbXGHSTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:19:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 20:26:53 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082026.54145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 04:24, Alan Stern wrote:
> On Sun, 8 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> > > Which is exactly my point.  It _doesn't_ work fine without a freezer, 
> > > because the USB stack currently relies on the freezer to prevent plug 
> > > activity.
> > 
> > Putting on hold plug activity has nothing, NOTHING, to do with the half
> > assed piece of deadlocking crap we have now we call a freezer.
> 
> You're wrong; it _does_ have something to do with the freezer.  The 
> connection is that the code uses the freezer to put plug activity on 
> hold.
> 
> You probably meant to say that it _should_ have nothing to do with the 
> freezer.  That's a different matter.  But in any case you should write 
> what you actually mean, rather than just putting down something as 
> inflammatory as possible.
> 
> > As long as you guys keep mixing up all the issues and coming up with
> > totally bogus solutions that cannot work, we won't have a useful suspend
> > (either to RAM or to disk) in linux.
> 
> In my defense, you should realize that until Rafael's notifier chain
> was added (just a few weeks ago, still not in mainline I believe) there
> was no other way to do it.  Plug activity needs to be stopped before
> the child devices are suspended, and the PM core does not send any
> notification to drivers at that time.  All it does is activate the 
> freezer.

Exactly.

And if we really want to get rid of the freezer, we need to _prepare_ for
that.  At least, we need to have an idea of how we will do thing when the
freezer is not there.

For example, how will we check if the system is not in a state in which the
resume is likely to fail?

There are more questions like that, IMO, and we should at least have a list
of them _before_ we remove the freezer.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
