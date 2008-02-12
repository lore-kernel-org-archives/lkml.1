Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYBLEkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYBLEkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYBLEkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:40:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYBLEkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:40:03 -0500
Date: Mon, 11 Feb 2008 20:43:14 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080212044314.GA4888@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 08:31:46PM -0800, Arjan van de Ven wrote:
> On Mon, 11 Feb 2008 20:21:33 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> 
> > > The maintainer will be notified.  I hope to provide some clue as to
> > > what the conflict is with, but probably not initially.
> > > 
> > > I will attempt to build the tree between each merge (and a failed
> > > build will again cause the offending tree to be dropped).
> > 
> > This is going to get really interesting, especially when (not if) we
> > do more global api changes.  Look at the last round of kobject
> > changes. That touched a lot of different places, and other trees
> > ended up not building because of it, because I changed apis and they
> > had added new code based on the old apis.
> > 
> > I think the only way to fix this is not going to just "drop the tree"
> > like you are suggesting, but to let both people know (the person who
> > caused the change, and the person who's tree broke after the merge),
> > and then either add a "fixup patch" for the build like Andrew has been
> > doing, or disabling something from the build section.
> > 
> 
> in my experience, the only chance you have is doing API changes as
> first in the set of changes, and then hoping (making) all other trees
> use the new APIs. Any other order just turns into an impossible
> mismash.

I agree, and that's what I do.

The problem is, the API change is still in my tree.  So, if for example,
the IB tree goes and adds some new functionality before my API changes
have landed, they need to use the "old" API in order for them to be able
to test and build things on their own.  Then, when the -next tree merges
everything together, the IB tree breaks the build, not my driver tree.

It's those "who goes first" type things that end up being the cause of a
lot of Andrew's headaches I think :)

thanks,

greg k-h
