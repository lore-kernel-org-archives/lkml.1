Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYIYEWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYIYEWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYIYEWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:22:06 -0400
Received: from mail.suse.de ([195.135.220.2]:37667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbYIYEWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:22:05 -0400
Date: Wed, 24 Sep 2008 21:21:08 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080925042108.GA3931@suse.de>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 10:59:03PM -0400, Parag Warudkar wrote:
> On Wed, Sep 24, 2008 at 10:06 PM, Greg KH <gregkh@suse.de> wrote:
> > No, this is much different from EXPERIMENTAL.  That flag is pretty much
> > useless right now.  This is for a temporary landing place for drivers
> > that are not good enough to be merged, yet are useful enough for some
> > people to use.
> 
> How? TAINT_EXPERIMENTAL (I'll stick to that, thanks :) and
> CONFIG_EXPERIMENTAL are no different - neither to users nor to
> developers. Here is why -

Sorry, no, the EXPERIMENTAL horse has left the barn.  If you want to run
after it and round it up and bring it back, that's great, but that is
going to be a lot of work that I'm sure not going to do.

> Both try to do the same thing - let people use the drivers on their
> own risk (as if the stable ones are developer's risk - but let's keep
> it aside for the moment) and give developers a chance to keep the code
> in sync with mainline and improve it per user problem reports or
> generally make it better.
> 
> You might try to differentiate between them on the basis of relative
> brokenness or crappiness if you will - but it is essentially the same
> - code that is not ideal for merge in mainline, code that needs user
> testing to trash out problems, and code that need to be in sync with
> mainline and code that users want to use in order to be able to use
> their hardware. I fail to see how this is different at all.

It is not different, except by name only.  Don't bike-shed :)

> > Examples of this is the USB driver I posted, some network drivers that
> > are in -staging that only work on x86 boxes, and drivers that have
> > userspace interfaces that are "wrong" and need to be changed (reading
> > files from /etc is one example.)
> >
> 
> I don't see a reason to further classify and label the experimental
> code - it is experimental. That classification suffices.

Again, no, the current EXPERMENTAL marking is pointless and a mess.  If
that were to be cleaned up then I'll reconsider.

> > Also, api changes do not have to propagate into the drivers/staging/
> > directory.  I'll work to keep up with them, keeping everything working
> > properly, just like I have been with the external -staging tree.  This
> > is just pushing it into the tree to give it much wider exposure and draw
> > from more developers makeing it easier to give them the proper credit
> > for this clean-up work.
> 
> Sure. Merge them under EXPERIMENTAL - may be with a big fat colored
> KConfig warning about what is broken.
> Tainting and labeling it staging does nothing of any value add. Sure
> you can have a staging directory in the tree and dump all the
> unmergeable code there if that gives a sense of isolation but I do not
> see a point in letting users build the staging code, loading it
> without their intervention and then printing a warning and tainting
> the kernel.

It provides a fast way into the kernel for companies who do not stick
around to take the time to merge things in.  That's what the -staging
tree has been doing quite well for the past 6 months or so, with lots of
drivers moving into mainline, and 15 drivers currently residing in it.

This is moving that tree into the kernel to provide all of the reasons I
previously mentioned.

> So what if there is a oops report tomorrow and we know it is Tainted :
> EXPERIMENTAL -  OOPS reports generally are very indicative of  where
> the problem is coming from and the knowledge that certain broken
> driver is loaded is just fine to be outside the kernel - no need for
> the TAINT intimidation which drives away users from reporting it and
> developers from addressing it.

But I sure want to show such a marking, don't you?  It isn't costing
anything, and if a developer doesn't want to debug the kernel if such a
driver is loaded, this allows them to do this.  It was a requirement
that came out of the discussion at the kernel summit.

> > I think the boat has left on making EXPERIMENTAL mean anything anymore,
> > but if you or anyone else wants to clean up the tree, and free it up,
> > then I would reconsider using it here instead.  But you can't start
> > making it something that means more than it does today, as I can easily
> > see that breaking systems that currently rely on those drivers.
> 
> There's the clue - this _will_ happen with staging - I can almost see it.
> So why not do it under one existing monster of an umbrella - or do you
> have plans to make sure you are not going to add a new staging driver
> unless the existing ones graduate to stable? Even if you do -  doable
> under EXPERIMENTAL.

No, it will not happen, the code is self-contained in a sub-directory,
with an active maintainer, and lots of active helper developers (as have
been sending me patches over the past weeks.)  If this does happen, and
drivers/staging/ grows to be a large dumping ground with no movement out
of it, then I'll worry about that then.  But I really don't think it
will happen.

thanks,

greg k-h
