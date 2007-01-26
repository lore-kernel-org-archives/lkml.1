Return-Path: <linux-kernel-owner+w=401wt.eu-S1161100AbXAZRtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161100AbXAZRtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161099AbXAZRtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:49:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:46175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161100AbXAZRte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:49:34 -0500
Date: Fri, 26 Jan 2007 09:48:28 -0800
From: Greg KH <greg@kroah.com>
To: Rainer Weikusat <rainer.weikusat@sncag.com>
Cc: Rainer Weikusat <rweikusat@sncag.com>, torvalds@linux-foundation.org,
       bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Message-ID: <20070126174828.GA28890@kroah.com>
References: <877ivb2kvc.fsf@semtex.sncag.com> <20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y7nq131x.fsf@semtex.sncag.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:43:22AM +0100, Rainer Weikusat wrote:
> Greg KH <greg@kroah.com> writes:
> > On Thu, Jan 25, 2007 at 04:20:55PM +0100, Rainer Weikusat wrote:
> >> 2.6.19 introduced changes to the UHCI handling of interrupt URBs that
> >> caused at least some keyspan USB-to-serial converters to fail,
> 
> [...]
> 
> > I copied you when this patch was added to my tree,
> 
> The only thing I received was a 'this patch has been dropped from
> the MM-tree because something happened' message.

You were also copied on the patch when it was added to my tree.  Email
was sent to your rweikusat@sncag.com address.

> > as I had reworked it to be a bit more acceptable (no pointer
> > arithmatic, proper coding style, use the newer macros for endpoint
> > detection, etc.),
> 
> You have basically done a couple of (functionally) totally pointless
> changes, like
> 
> 	- not using iterator-style array traversals, but indexed ones
>           instead

Which is the better way to document exactly how you are walking through
all of the endpoints.

> 	- doing the calculation to determine the endpoint type in
>           three different places instead of in one place, because the
>           somewhat silly endpoint classification interfaces enforces
>           this

3 places?  You mean in the if call?

> 	- not using a single switch-statement but an if-else-cascade,
>           again due to limitations of that interface

This really isn't a problem.

> 	- replacing the while-loop with an identical for-loop

Again, this is the better way to walk through all of the endpoints for a
device.

> The net effect of these changes is that an optimizing compiler will
> have to work somewhat more to remove all the redundant stuff that
> was added.

This is initialization code, it's better to be obvious as to what you
are trying to do here than trying to do the compiler's job for it.
Especially as it is not a critical path by any means.

> As for 'proper coding style', the code conforms to what is
> documented as 'proper kernel coding style'. If this assumption of mine
> is incorrect, I'd be happy to hear about reasons why this would be so,
> to take them into account for eventual future patches.

There were some statements that had more than one on one line (I think
in a few usages of 'if'), but as I don't have the original patch handy,
I'll defer.

The _main_ coding style difference is that it was not obvious as to what
you were doing while walking the list of endpoints in the device.  That
is why I changed the code, to be more obvious to who ever looks at the
code next (most likely me in about 2 years...)

> > I this patch does not work, please let me know, and I will be glad
> > to work to fix it.
> 
> I think I'll just resend the working one in this case. But the logic
> appears to be identical, so I do not so a reason why it shouldn't.

Please work to see what is wrong with the existing patch.  Is there
anything that I can do to help you out?

thanks,

greg k-h
