Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYJaDRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYJaDRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYJaDQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:16:54 -0400
Received: from kroah.org ([198.145.64.141]:55966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753485AbYJaDQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:16:53 -0400
Date: Thu, 30 Oct 2008 20:13:57 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
Message-ID: <20081031031357.GA20944@kroah.com>
References: <20081030054944.GA19035@kroah.com> <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org> <20081030215734.GA18822@kroah.com> <alpine.LFD.2.00.0810301619260.21084@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810301619260.21084@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 04:28:46PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 30 Oct 2008, Greg KH wrote:
> > 
> > But as for the 'bisectability' at one point in the merge, you will be
> > adding a stand-alone driver into the kernel itself.  So for anyone
> > traversing down that path, all you would be building would be the driver
> > itself, the whole rest of the kernel is "gone".
> 
> Right. This was exactly what happened initially in the btrfs thing. And it 
> was horrid.
> 
> It was horrid because it was totally unexpected for users, and causes huge 
> churn and confusion when trying to check out a totally different directory 
> layout (and git won't remove the old *.o files, so trust me, it _will_ be 
> confusing).

I agree, I don't want this to happen.

> What I got Chris Mason to do was to run
> 
> 	git filter-branch --index odd-script-goes-here
> 
> with that odd script looking something like:
> 
> >       #!/bin/sh
> >       exists=$(git ls-files fs/btrfs/)
> >       [ -z "$exists" ] &&
> >               git ls-files --stage |
> >               awk -F '\t' '{ print "0 0000000000000000000000000000000000000000\t" $2 "\n" $1 "\tfs/btrfs/" $2 }' |
> >               git update-index --index-info
> 
> which basically does a directory rename in the branch (obviously, in this 
> case into fs/btrfs, which is not what _you_ want). That way, at least the 
> directory structure of the tree you merge has the same layout, and you 
> don't get _that_ particular directory jumping back and forth.
> 
> Chris also merged in the history at the 2.6.26 tree (I think), so that 
> while his original history had had just a stand-alone btrfs build, the end 
> result was actually *totally* bisectable. Again, you should ask him about 
> any other scripts he ran.

Ok, this seems a lot more reasonable, and doable.

But then I took a long look at the cvs commit logs.

And you are right, they are crap, and pointless to have here.

So, thanks a lot for showing me how to do this properly, in the future I
might do this (actually, for one wireless driver, I might do this now,
as it was always developed in git), but for the comedi code, I'll just
use the "normal" method of adding drivers one at a time, with none of
the crazy past history sucked in as it doesn't add any value.

thanks,

greg k-h
