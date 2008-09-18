Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYIRLWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYIRLWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYIRLWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:22:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34010 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYIRLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:22:30 -0400
Date: Thu, 18 Sep 2008 13:18:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>, Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20080918111845.GH27832@elf.ucw.cz>
References: <48C7FCEE.8060404@kernel.org> <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com> <48C948A6.3080404@kernel.org> <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com> <48C9AB5A.705@kernel.org> <20080912165947.GB5094@kroah.com> <20080817194520.GB4043@ucw.cz> <20080917180405.GB3162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917180405.GB3162@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-17 11:04:05, Greg KH wrote:
> On Sun, Aug 17, 2008 at 09:45:21PM +0200, Pavel Machek wrote:
> > On Fri 2008-09-12 09:59:47, Greg KH wrote:
> > > On Fri, Sep 12, 2008 at 01:35:54AM +0200, Tejun Heo wrote:
> > > > Shem Multinymous wrote:
> > > > >> That reduction comes because input device supports poll and
> > > > >> sysfs_notify_event() does about the same thing.  The uesrland daemon
> > > > >> can just poll on a node and read data nodes when poll event on the
> > > > >> node triggeres.
> > > > > 
> > > > > Agreed.
> > > > > There's another issue with the current sysfs interface, though: hdapsd
> > > > > needs to read (x,y,timestamp) tuples, whereas sysfs provides just x
> > > > > and y in separate attributes which cannot be read atomically together.
> > > > > We can add a sysfs file with "x y timestamp" readouts, though this is
> > > > > unusual for sysfs (and certainly incompatible with hwmon).
> > > > 
> > > > Yes, right.  Forgot about the atomicity part altogether.  Thanks for
> > > > bringing it up.
> > > > 
> > > > >> Unloading heads will be simple.  Just echoing timeout in ms to sysfs
> > > > >> nodes, so I don't think it's a good idea to push out actual unloading
> > > > >> to another process especially as fork doesn't inherit mlockall.
> > > > > 
> > > > > I had in mind another daemon listening for "unload now" events, so no
> > > > > forking needed.
> > > > > This second daemon might make sense if we push the logic of deciding
> > > > > *which* disks to unload into userspace, since this logic is the same
> > > > > for the ThinkPad style and the HP style.
> > > > 
> > > > Hmmm... I can't (yet) see the benefit of having two separate userland
> > > > daemons.
> > > > 
> > > > >> On a related note, is there any plan to merge tp_smapi to mainline?
> > > > >> It seems you put a lot of work into it and I don't really see why it
> > > > >> should stay out of tree.
> > > > > 
> > > > > The only issue I'm aware of is finding a reasonably-named maintainer.
> > > > > On the technical side, the reviews on my lkml submission of
> > > > > thinkpad_ec+hdaps seemed good and all technical comments are since
> > > > > addressed. The code has been stable, well-tested and packaged by major
> > > > > distros for years.
> > > > 
> > > > Cool, can you please post the patch to the lkml and cc Greg
> > > > Kroah-Hartman <gregkh@suse.de>, Andrew Morton
> > > > <akpm@linux-foundation.org> and me?
> > > 
> > > Sorry, but no, I can't accept this code as it is coming from a "known
> > > anonymous" person containing information that it is not known where it
> > > came from.
> > 
> > So... what are you worried about?
> 
> Code created by access to specs that were not allowed to be published in
> GPL form by someone who wants to remain anonymous.

That anonymous person may have problems if they signed NDA.

I don't think they did, they even list the sources:

 *  The embedded controller on ThinkPad laptops has a non-standard interface,
 *  where LPC channel 3 of the H8S EC chip is hooked up to IO ports
 *  0x1600-0x161F and implements (a special case of) the H8S LPC protocol.
 *  The EC LPC interface provides various system management services (currently
 *  known: battery information and accelerometer readouts). This driver
 *  provides access and mutual exclusion for the EC interface.
*
 *  The LPC protocol and terminology is documented here:
 *  "H8S/2104B Group Hardware Manual",
 *  http://documentation.renesas.com/eng/products/mpumcu/rej09b0300_2140bhm.pdf

H8S chip seems to be documented.

...even if you are right, why is it problem for _us_. We are not
covered by NDAs we did not sign.

So can you list your concerns for _us_? Copyrights? Patents? Trade
secrets? Contracts?

> If people want to get this kind of code into the tree, they can write a
> new driver from scratch, based on public information on these chips.
> And you will have to defend exactly where this information was found
> as

These are rather bigger requirements than signed-off-by and then what
Novell legal people require before putting stuff in distribution. So
you should explain why this bigger requirements are warranted.

> you can not do it by information found in this "tainted" driver, sorry,
> that's not a legally viable way forward.

As far as I can see, using any information I find anywhere is
perfectly legal for writing a driver, as long as I don't sign &
violate a NDA. sourceforge.net is rather well-known, public source of
information. Why should it be treated specially?!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
