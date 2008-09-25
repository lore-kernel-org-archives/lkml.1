Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYIYCIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYIYCIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYIYCHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:07:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:37204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYIYCHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:07:48 -0400
Date: Wed, 24 Sep 2008 19:06:08 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080925020608.GA13869@suse.de>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 07:39:42PM -0400, Parag Warudkar wrote:
> On Wed, Sep 24, 2008 at 7:00 PM, Greg KH <gregkh@suse.de> wrote:
> > So, does this all look good to everyone?  Any questions/issues?
> >
> 
> I sure hope this does not end up like EXPERIMENTAL although it
> essentially does duplicate the intent of EXPERIMENTAL.
> (In other words - drivers live there for ever in staging mode, we
> print warnings and generally nobody cares about the problem since the
> kernel is tainted.)

No, this is much different from EXPERIMENTAL.  That flag is pretty much
useless right now.  This is for a temporary landing place for drivers
that are not good enough to be merged, yet are useful enough for some
people to use.

Examples of this is the USB driver I posted, some network drivers that
are in -staging that only work on x86 boxes, and drivers that have
userspace interfaces that are "wrong" and need to be changed (reading
files from /etc is one example.)

All of those types of drivers are not capable of being merged today, and
EXPERIMENTAL doesn't mean anything there.

Also, api changes do not have to propagate into the drivers/staging/
directory.  I'll work to keep up with them, keeping everything working
properly, just like I have been with the external -staging tree.  This
is just pushing it into the tree to give it much wider exposure and draw
from more developers makeing it easier to give them the proper credit
for this clean-up work.

> That aside please at least substitute the word CRAP with something
> better - like TAINT_NON_PRODUCTION or TAINT_UNRELIABLE or
> TAINT_WORK_IN_PROGRESS or TAINT_EXPERIMENTAL .

Why, that word is only internal, nothing outside of the kernel sees that
flag at all, no user will ever know this.

And if we leave it as TAINT_CRAP, and a developer sees it, perhaps it
will cause them to make their code cleaner next time around :)

> Also, I suppose it would be useful for Production machines to have a
> kernel command line flag or something to say don't load staging
> modules - for instance to prevent against automatic loading on drivers
> from staging directory to support some oddball device etc.

I can easily add a "no_crap" flag to the command line.  Oops, there's
that word going out to userspace, how about "no_staging"?

> Thinking more about it - could this whole thing not be achieved by
> setting per module experimental flag and refusing to insmod'ing
> experimental modules if -f was not specified. I believe force loading
> also taints the kernel? All drivers intended for staging can set that
> flag  - this way we don't need another TAINT flag and there is no need
> for the directory name hack.

This keeps these kinds of drivers in one place, obvious to all that work
needs to be done, and userspace interfaces can, and usually will change
for such drivers.

I think the boat has left on making EXPERIMENTAL mean anything anymore,
but if you or anyone else wants to clean up the tree, and free it up,
then I would reconsider using it here instead.  But you can't start
making it something that means more than it does today, as I can easily
see that breaking systems that currently rely on those drivers.

thanks,

greg k-h
