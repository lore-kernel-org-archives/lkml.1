Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZCCJRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZCCJRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZCCJQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:16:52 -0500
Received: from thunk.org ([69.25.196.29]:57192 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZCCJQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:16:51 -0500
Date: Tue, 3 Mar 2009 04:16:38 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: david@lang.hm, Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
	tree"
Message-ID: <20090303091638.GD32284@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, david@lang.hm,
	Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
	wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com> <49ACC6B0.409@garzik.org> <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com> <20090303072637.GB4440@kroah.com> <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com> <alpine.DEB.1.10.0903022340060.14744@asgard.lang.hm> <43e72e890903022357p7594cf98gd7c1061a78f8828a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890903022357p7594cf98gd7c1061a78f8828a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:57:23PM -0800, Luis R. Rodriguez wrote:
> >> OK small silly example is convincing distributions it may be a good
> >> idea to carry linux-next kernel packages as options to users to
> >> hopefully down the road reduce the delta between what they carry and
> >> what is actually upstream.
> >
> > linux-next is a testing tree for developers, it changes day to day, doesn't
> > contain all relavent changes, and is definantly _not_ something that distros
> > should be pushing to users.
> 
> Why not? Just as people may want to get bleeding edge wireless I don't
> see why a user may not want to simply get bleeding edge wireless and
> bleeding edge audio, and video. The latest RC series helps but lets
> face it there are also a lot of good stuff queued for the -next
> releases as well. The way I'm seeing this is if a user has no support
> for a device on their system it should look something like this:

What kind of distribution kernel are you talking about here?  Even for
a community distribution kernel, it typically goes through at least
1-3 months of testing before it is finally released.  And an
enterprise distro will snapshot a good six months before release time.
Or are you talking about a bleeding-edge "kernel of the day" that a
distro like Fedora ships?

Also there's a very big difference between getting a bleeding edge
driver which doesn't have much impact on the rest of the kernel, and a
bleeding edge subsystem which may impact other parts of the kernel.
Unfortunately the wireless subsystem is not as immature as other parts
of the kernel, so I've noticed that it's not that rare for a new
driver to depend on new infrastructure in the wireless stack.  But in
the long run, hopefully that will go away.

The reason why distro's are hesitant to take bleeding edge code that
hasn't been accepted yet is that it may never be accepted.  (Case in
point, the disaster that has been Xen, and the huge amount of pain
this is cost the enterprise distro's, since they've been forced to
dedicated a non-trival amount of engineering resources to backport
hell.)  

Or it may be accepted in a different form than what they took in their
snapshot.  And/or it might be buggy, causing them to have to deal with
a huge amount of pain trying to fix a particular problem.

For a subsystem where Linus largely trusts the maintainer to send good
pull requests, it may seem that just because something is queued for
the next merge window, it's automatically going to go in during the
next merge window, and so it's fair game to try to pressure
distributions to accept the code before Linus has accepted it.
However, there is always the distinct chance that it won't be accepted
for one reason or another.  Or it may be that when it starts getting
testing, it has so many bugs that Linus decides to revert the one or
more patches from mainline, or possibly even the entire merged branch.

In practice, especially for a distribution kernel that gets months and
months of baking, there is typically enough time for a patchset to get
merged into Linus, and for the maintainer to ask the distro to
backport some new functionality which is now in mainline.

	      	  		      	     - Ted
