Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYAFNjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYAFNjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbYAFNj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:39:29 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53598 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbYAFNj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:39:27 -0500
Date: Sun, 6 Jan 2008 15:38:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106133854.GH2082@does.not.exist>
References: <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist> <4780D3E5.20908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4780D3E5.20908@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 02:13:09PM +0100, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sun, Jan 06, 2008 at 01:18:48PM +0100, Stefan Richter wrote:
> >> I'm afraid this can't be put into practice.  (User says which hardware
> >> and protocols he needs to be supported, scripts magically assemble a
> >> suitable configuration.)
> > 
> > Distribution installers and live CDs like Knoppix even manage to 
> > magically assemble a suitable configuration (e.g. autodetecting which 
> > modules they should load) without asking the user any questions.
> 
> Module autoloading is quite different.

Both are "hardware -> required kernel support" mappings.

I know that people don't like this idea since the CML2 discussions, but 
there even don't seem to be any big problems if anyone wants to put all 
the pieces together and assemble a suitable .config only based on the 
autodetection tools of some distribution and without asking the user 
any questions.

> > The information the user has to give when configuring his kernel is 
> > whether he wants to connects USB disks - whether or not the 
> > implementation of the kernel driver uses the in-kernel SCSI layer we can 
> > easily handle automatically without bothering the user.
> > 
> >> I think
> >>   - sensibly modularize our software,
> >>   - tell the user which software components there are,
> >>   - what they are for,
> >>   - how they depend on each other,
> >>   - make it easy enough for the user to navigate in the dependency
> >>     graph,
> >>   - provide fundamental safeguards and checks for a proper software
> >>     configuration
> >> is the best we can do.
> > 
> > It sounds strange that what you call the "the best we can do" would be 
> > much worse than what we are currently doing...
> > 
> > The current status quo is that a user e.g. only has to know that his 
> > ethernet controller is a "Broadcom 440x/47xx", the fact that a Sonics 
> > Silicon Backplane bus is used on the card is handled automatically by 
> > kconfig.
> 
> if NET_ETHERNET
> ...
> config B44
> 	tristate "Broadcom 440x/47xx ethernet support"
> 	depends on SSB_POSSIBLE
> 	select SSB
> 	select MII
> ...
> endif # NET_ETHERNET
> 
> There is a B44 option.  The prompt string (in other cases the help text)
> tells what it is for.  Furthermore, four dependencies are encoded; one
> in the direct form, one by if/endif, two in reverse form.  There are no
> further hints how to satisfy SSB_POSSIBLE, NET_ETHERNET, SSB, MII.  The
> kconfig system is told to enable SSB and MII no matter what, as long as
> SSB_POSSIBLE, NET_ETHERNET, and B44 are != n.
> 
> This /is/ what we are currently doing, not "worse than what we are
> currently doing".  We
>   - sensibly modularize our software,
>   - tell the user which software components there are,
>   - what they are for,
>   - how they depend on each other,
>   - make it easy enough for the user to navigate in the dependency
>     graph,
>   - provide fundamental safeguards and checks for a proper software
>     configuration.  (Well, we actually walk on thin ice whenever we
>     use the 'select' keyword.)
>...

You miss the fundamental point:

The vast majority of kconfig users are _not_ kernel hackers, and they 
neither know nor want to know anything about kernel internals - they 
just want to build a kernel suitable for their system.

You want to make an UI easier to use for the developers but harder to 
use for the users, and that's a bad deal.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

