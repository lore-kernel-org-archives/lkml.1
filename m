Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYJVWxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYJVWxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJVWxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:53:42 -0400
Received: from kroah.org ([198.145.64.141]:58028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbYJVWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:53:41 -0400
Date: Wed, 22 Oct 2008 15:49:43 -0700
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       Andre Kelmanson <akelmanson@gmail.com>,
       Bouwsma Barry <freebeer.bouwsma@gmail.com>,
       Dan Kreiser <kreiser@informatik.hu-berlin.de>,
       Frank Neuber <fn@kernelport.de>,
       Jelle de Jong <jelledejong@powercraft.nl>,
       John Stowers <john.stowers.lists@gmail.com>,
       Lukas Kuna <lukas.kuna@evkanet.net>,
       Stefan Vonolfen <stefan.vonolfen@gmail.com>,
       Stephan Berberig <s.berberig@arcor.de>,
       Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
       Vitaly Wool <vwool@ru.mvista.com>, Zhenyu Wang <zhen78@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Message-ID: <20081022224943.GA22717@kroah.com>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com> <20081022220903.GA15278@kroah.com> <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com> <20081022222727.GA17599@kroah.com> <d9def9db0810221535xbe8e5aegef8b09b81206ee92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0810221535xbe8e5aegef8b09b81206ee92@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 12:35:54AM +0200, Markus Rechberger wrote:
> On Thu, Oct 23, 2008 at 12:27 AM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Oct 23, 2008 at 12:24:31AM +0200, Markus Rechberger wrote:
> >> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
> >> > On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
> >> >>     em2880-dvb:
> >> >>     * supporting the digital part of Empia based devices, which
> >> >> includes ATSC, ISDB-T and DVB-T
> >> >
> >> > <snip>
> >> >
> >> > Doesn't this driver duplicate some of the existing devices we already
> >> > support with the current in-kernel driver?  If so, why not just add the
> >> > new device support to the existing driver instead of duplicating
> >> > everything?
> >> >
> >> > This is going to cause a big problem for distros as they will not know
> >> > which to enable, so they will probably just disable this one, which is
> >> > what I don't think you want to have happen :(
> >> >
> >>
> >> the current driver doesn't support most devices which are in there,
> >
> > Then why not just add new device support to the existing one?
> >
> >> also the alsa audio driver can easily crash the whole system. (It's my
> >> code so I know what was wrong there).
> >
> > Why not send patches to fix it?
> >
> 
> that's why I'm sending that request at the moment, development still goes on
> on my side.

I don't understand, I don't see patches here to fix the existing
problems in the existing driver.  Am I missing something?

> >> Very likely the best would be to replace the available driver with it
> >> but I don't care, alot people use and have been using the driver from
> >> mcentral.de for a long time, development has always been opensource
> >> there too.
> >
> > Dropping existing code and replacing it entirely with a new base is not
> > how Linux kernel development works for the most part.
> >
> 
> the patch adds the driver from mcentral.de as alternative entry, not
> the best way but it currently supports almost all devices which have
> an entry in there.

What do you mean by "alternative" entry?  Our device/driver matching
system doesn't allow for "alternates" it is a "first one there wins"
type system, which, while isn't the nicest, is what it is.  This driver
is going to cause problems for distros, and for users, as if you build
them both as modules, it is pseudo-random which one will end up being
loaded first and binding to the device.

Which is not something we generally want to do to our users at all.

> > How about just sending patches in an incremental way, fixing problems in
> > the current driver that you know about, and adding support for all of
> > this goodness as well?  That's what all 2000+ other kernel developers
> > do when they want to make changes like this.
> >
> 
> I understand what you mean although too many things went from from the
> beginning on and people were in general not participating at
> discussions, it slightly changed now but the codebase evolved over
> time.
> 
> I'll be happy to do so for upcoming patches.

So we should drop our current rules for you, and trust that things from
here on out will be correct?  That doesn't sound like a good idea for us
to do, would you recommend doing something like that for someone else?

Especially given the above mentioned problems for users, this really
isn't going to work out.

Please send patches that evolve the current drivers into supporting
these new devices so that our development model is followed, and no user
ends up in trouble.

thanks,

greg k-h
