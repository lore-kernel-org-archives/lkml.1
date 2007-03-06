Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbXCFCui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbXCFCui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933876AbXCFCui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:50:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:49592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933871AbXCFCug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:50:36 -0500
Date: Mon, 5 Mar 2007 18:48:50 -0800
From: Greg KH <greg@kroah.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Adrian Bunk <bunk@stusta.de>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070306024850.GA24477@kroah.com>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305234052.GR3441@stusta.de> <20070306000722.GA11436@kroah.com> <20070306013020.GN23311@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306013020.GN23311@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 07:30:21PM -0600, Matt Mackall wrote:
> On Mon, Mar 05, 2007 at 04:07:22PM -0800, Greg KH wrote:
> > On Tue, Mar 06, 2007 at 12:40:52AM +0100, Adrian Bunk wrote:
> > > On Mon, Mar 05, 2007 at 10:58:13AM -0800, Greg KH wrote:
> > > > 
> > > > Ok, how about the following patch.  Is it acceptable to everyone?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > ---
> > > >  init/Kconfig |   13 +++++++++++--
> > > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > > 
> > > > --- gregkh-2.6.orig/init/Kconfig
> > > > +++ gregkh-2.6/init/Kconfig
> > > > @@ -290,8 +290,17 @@ config SYSFS_DEPRECATED
> > > >  	  that belong to a class, back into the /sys/class heirachy, in
> > > >  	  order to support older versions of udev.
> > > >  
> > > > -	  If you are using a distro that was released in 2006 or later,
> > > > -	  it should be safe to say N here.
> > > > +	  If you are using an OpenSuSE, Gentoo, Ubuntu, or Fedora
> > > > +	  release from 2007 or later, it should be safe to say N here.
> > > > +
> > > > +	  If you are using Debian or other distros that are slow to
> > > > +	  update HAL, please say Y here.
> > > >...
> > > 
> > > The sane solution seems to be to enable SYSFS_DEPRECATED unconditionally 
> > > for all users, and schedule it's removal for mid-2008 (or later).
> > > 
> > > 12 months after the first _release_ of a HAL that can live without seems 
> > > to be the first time when we can consider getting rid of it, since all 
> > > distributions with at least one release a year should ship it by then.
> > > 
> > > Currently, SYSFS_DEPRECATED is only a trap for users.
> > 
> > Huh?
> > 
> > No, again, I've been using this just fine for about 6 months now.
> > 
> > And what about all of the servers not using HAL/NetworkManager?
> > And what about all of the embedded systems not using either?
> > 
> > So to not allow this to be turned off by people who might want to (we
> > want this for OpenSuSE 10.3, and Fedora 7 also will want this, as will
> > other distros released this year), is pretty heavy-handed.
> > 
> > It also will work in OpenSuSE 10.2 which is already released, and I
> > think Fedora 6, but I've only limited experience with these.
> > 
> > Oh, and Gentoo works just fine, and has been for the past 6 months.
> >
> > I would just prefer to come up with an acceptable set of wording that
> > will work to properly warn people.
> > 
> > I proposed one such wording which some people took as a slam against
> > Debian, which it really was not at all.
> > 
> > Does someone else want to propose some other wording instead?
> 
> Back up a bit. Let's review:
> 
> Problem: NetworkManager stopped working with my ipw2200 on Debian/unstable

Wait, have confirmed that if you enable this config option,
NetworkManager starts back up again and works properly?

If so, can you disable the option and strace it to see what program is
trying to access what?  That will put the
HAL/NetworkManager/libsysfs/distro script finger pointing to rest pretty
quickly :)

thanks,

greg k-h
