Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0CGSSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:18:47 -0500
Received: from kroah.org ([198.145.64.141]:40609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0CGSSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:18:45 -0500
Date: Sun, 7 Mar 2010 10:16:49 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: The gregkh patch scripts
Message-ID: <20100307181649.GD3718@kroah.com>
References: <Pine.LNX.4.44L0.1003062253101.29076-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003062253101.29076-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 11:19:20PM -0500, Alan Stern wrote:
> Greg:
> 
> Are the scripts you use for creating the various gregkh-*.patch files 
> stored in 
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/scripts/
> 
> ?  Those files appear not to have been updated for quite some time.

Until last week, yes, they were the most recent version.

However, last week I made some changes, which caused things to break in
different ways as you have noticed.

> Regardless, the way the current scripts work has got a problem.  As far
> as I can tell, they take Linus's current tree, apply your various
> accumulated quilt series files, and then compute the diff between the
> end result and the starting point.  The output is labelled with name of
> the starting tree.  (If my understanding is wrong then tell me so and
> ignore the rest of this message.)

No, that is correct.

I switched to using a git commit base to make it easier to handle the
merges in the linux-next tree due to problems that Stephen was having
when merging my trees into there.

> The problem is that Linus's current tree is not a good starting point.  
> For example, right now several of the individual files such as
> gregkh-07-usb-2.6.33.patch are completely empty.  This is because you
> have sent all the pending changes upstream, so they are now included in
> Linus's tree and hence they don't show up in a diff.

Yes that is true.

But I do think that Linus's tree is a good starting point, as that
reflects my current quilt patchset identically.

> But...  The file is still named "gregkh-07-usb-2.6.33.patch", even
> though it isn't a patch against 2.6.33 -- it's a patch against whatever
> Linus's tree happened to contain at the time you ran the script.  
> Since I don't know what tree that was (and I don't have git repository
> for the kernel anyway), I can't use the patch file.  (Well, I _can_ use 
> it because it's empty, but it doesn't do me any good -- the principle 
> is still valid.)

Yes, the issue is that the base tree is not labeled the same.  I should
rename the patch to be "gregkh-07-usb-SHA.patch" to be more refelective
of what it really is.

If you look at the quilt series that linux-next pulls from, those have
the correct marking with the # BEGIN markings that linux-next relies on.
It identifies the proper SHA1 to base the tree off of.

> As Linus has explained to quite a few people, this isn't a good way to
> operate.  What your scripts do is essentially the same as rebasing a
> publicly-exported git repository, which should be done relatively
> infrequently.  It's okay to rebase against the actual releases and the
> *-rcN trees, because they are well-defined intermediate points.  But
> rebasing against a *-rcN-gitM should be quite rare, and rebasing
> against anything else is basically forbidden.
> 
> This means the scripts shouldn't start with the vanilla
> tree-of-the-moment.  They should start with the most recent release or
> -rcN tag.  In rare cases they could use an rcN-gitM tag, but only if
> there's a good reason.
> 
> So for example, the current gregkh-*-2.6.33.patch files should be quite
> large, because they should contain all the accumulated development for
> the last three months that hasn't gotten into 2.6.33.  When 2.6.34-rc1
> is released then the files should get small, since they would then
> contain only material that was submitted slightly before or during the
> merge window.
> 
> Can the scripts be updated to work in this way?

Yes, I can switch back to going off of the -rcN-gitM markings that I was
using in the past.  If I do that does it make it easier for you?

And yes, you are right, this is a constant rebase, and that's wrong on
my part.

This makes me reconsider the fact that I'm using quilt for all of this.
Perhaps if I switch to a git tree, it would all be easier for people
like you?  Would you prefer that?

For stuff like my staging tree, I'm almost convinced that switching to
git makes more sense as keeping that many patches in quilt is a mess and
I don't ever end up rebasing anything or deleting any patches in the
middle anymore.

For USB, yeah, I think it's also time to switch over as well.  What do
you think?

thanks,

greg k-h
