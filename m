Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXJWDYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXJWDYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXJWDYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:24:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXJWDYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:24:11 -0400
Date: Mon, 22 Oct 2007 20:28:36 -0700
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow sysfs_remove_group() to be called on non-added
	groups
Message-ID: <20071023032836.GC7486@kroah.com>
References: <096fae99bd9797c5484ed8f4b87b82e58737cdc0.1189657514.git.michael@ellerman.id.au> <dc1166600710221902t1383ff88q421a17b1ff1382cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1166600710221902t1383ff88q421a17b1ff1382cd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 12:02:39PM +1000, Michael Ellerman wrote:
> On 9/13/07, Michael Ellerman <michael@ellerman.id.au> wrote:
> > It would be nice to be able to do:
> >
> > for_each_thing(thing) {
> >         error = sysfs_create_group(&thing->kobj, attrs);
> >         if (error) {
> >                 for_each_thing(thing)
> >                         sysfs_remove_group(&thing->kobj, attrs);
> >                 return error;
> >         }
> > }
> >
> > But there's a BUG_ON() in sysfs_remove_group() which hits if the attributes
> > were never added.
> >
> > As discussed here ...
> > http://ozlabs.org/pipermail/cbe-oss-dev/2007-July/002774.html
> >
> > .. we should just return in that case instead of BUG'ing.
> >
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >  fs/sysfs/group.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> > index f318b73..a256775 100644
> > --- a/fs/sysfs/group.c
> > +++ b/fs/sysfs/group.c
> > @@ -73,7 +73,8 @@ void sysfs_remove_group(struct kobject * kobj,
> >
> >         if (grp->name) {
> >                 sd = sysfs_get_dirent(dir_sd, grp->name);
> > -               BUG_ON(!sd);
> > +               if (!sd)
> > +                       return;
> >         } else
> >                 sd = sysfs_get(dir_sd);
> >
> >
> 
> Hi Greg,
> 
> I didn't see this in your series, any objections? AFAICT it still applies.

Hm, I think I just missed it, care to forward it to me "clean" again?

thanks,

greg k-h
