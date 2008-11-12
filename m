Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYKLVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYKLVPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYKLVPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:15:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59229 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYKLVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:15:21 -0500
Subject: Re: [PATCH =-v3 18/21] fanotify: all userspace to set timeouts
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20081112165610.GD19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	 <20081112161201.25434.80001.stgit@paris.rdu.redhat.com>
	 <20081112165610.GD19669@infradead.org>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 16:14:32 -0500
Message-Id: <1226524472.3353.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:56 -0500, Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 11:12:01AM -0500, Eric Paris wrote:
> > fanotify when used to make access decisions has a default 5 second timeout.
> > This patch will allow userspace listeners to change their timeout on a
> > group wide basis.  Userspace listeners will still be able to reset the
> > timeout for individual events.
> 
> Really, I think you start to over-engineer.  I think this whole stuff
> would have a much higher chance if you could come up with a staged set
> of patchsets, ala:
> 
>  (1) unify the current *notify schemes
>  (2) add a filesystem wide notify scheme
>  (3) add blocking filesystem notifiers
> 
> and then maybe a fourth with all the misc little things that I doubt
> will have much of a chance.

This patch set is mostly lined up from most useful to least and every
patch comiles and runs on its own.  The request for per listener
timeouts is based on the array of potential users.  Mainly it was put in
to allow HSMs to set a high timeout while they ran off and pulled a tape
out of the robot.  I already let them reset the timeout if they need
more time, so I'm find with dropping it if it is so hard to handle.

I'll take a look at #1 but #2 and #3 is exactly what I did.  I added
fanotify.  I added an interface for it.  And then I flushed out #2 to
the point it was useful on it's own (and off list I've gotten e-mail
indicating we have non-AV/malware people interested in using this part
of fanotify )

#3 is filled out from patches 10-13.  14+ are all misc but aside from
this particular patch I can't see any other way to achieve the intended
goals.

I'd love to hear any ideas on how to unitfy the three.  Heck I'd be glad
to hear any idea how to unify even inotify and dnotify since all three
have such wildly different lifetimes and implementations..

I'll poke at this but for now I see my patches as (mostly) clean,
useful, and complete.

-Eric

