Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXCFAJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXCFAJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933595AbXCFAJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:09:06 -0500
Received: from ns.suse.de ([195.135.220.2]:40922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933575AbXCFAJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:09:04 -0500
Date: Mon, 5 Mar 2007 16:07:22 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070306000722.GA11436@kroah.com>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305234052.GR3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305234052.GR3441@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 12:40:52AM +0100, Adrian Bunk wrote:
> On Mon, Mar 05, 2007 at 10:58:13AM -0800, Greg KH wrote:
> > 
> > Ok, how about the following patch.  Is it acceptable to everyone?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ---
> >  init/Kconfig |   13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > --- gregkh-2.6.orig/init/Kconfig
> > +++ gregkh-2.6/init/Kconfig
> > @@ -290,8 +290,17 @@ config SYSFS_DEPRECATED
> >  	  that belong to a class, back into the /sys/class heirachy, in
> >  	  order to support older versions of udev.
> >  
> > -	  If you are using a distro that was released in 2006 or later,
> > -	  it should be safe to say N here.
> > +	  If you are using an OpenSuSE, Gentoo, Ubuntu, or Fedora
> > +	  release from 2007 or later, it should be safe to say N here.
> > +
> > +	  If you are using Debian or other distros that are slow to
> > +	  update HAL, please say Y here.
> >...
> 
> The sane solution seems to be to enable SYSFS_DEPRECATED unconditionally 
> for all users, and schedule it's removal for mid-2008 (or later).
> 
> 12 months after the first _release_ of a HAL that can live without seems 
> to be the first time when we can consider getting rid of it, since all 
> distributions with at least one release a year should ship it by then.
> 
> Currently, SYSFS_DEPRECATED is only a trap for users.

Huh?

No, again, I've been using this just fine for about 6 months now.

And what about all of the servers not using HAL/NetworkManager?
And what about all of the embedded systems not using either?

So to not allow this to be turned off by people who might want to (we
want this for OpenSuSE 10.3, and Fedora 7 also will want this, as will
other distros released this year), is pretty heavy-handed.

It also will work in OpenSuSE 10.2 which is already released, and I
think Fedora 6, but I've only limited experience with these.

Oh, and Gentoo works just fine, and has been for the past 6 months.

I would just prefer to come up with an acceptable set of wording that
will work to properly warn people.

I proposed one such wording which some people took as a slam against
Debian, which it really was not at all.

Does someone else want to propose some other wording instead?

thanks,

greg k-h
