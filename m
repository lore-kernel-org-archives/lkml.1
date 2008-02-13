Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbYBMA1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbYBMA1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYBMA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:27:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbYBMA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:26:59 -0500
Date: Tue, 12 Feb 2008 16:27:30 -0800 (PST)
Message-Id: <20080212.162730.126662377.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <1202840682.3137.83.camel@localhost.localdomain>
References: <1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 12 Feb 2008 12:24:42 -0600

> Hm ... I think net is a counter example to this.  Rebases certainly work
> for them.  The issue, I thought, was around the policy of rebasing and
> how often.
> 
> I see the question as being one of who creates the history.  When
> something goes into your tree, that's an obvious history point and we
> can't rewrite it.  However, when something goes into my trees, I don't
> think it's as obviously a history point that has to be preserved, so I
> can rebase obviously, rebasing causes disruption, so I don't do it
> unless it's necessitated by an actual conflict.

And I realize that regrettably I end up rebasing a lot.

Let's say that today I merge a TCP bug fix into Linus's 2.6.24-rcX
tree.  When I have the net-2.6.25 tree going I know that this is going
to create merge conflicts with the 80 or so odd TCP patches I have in
there.

Nobody can pull net-2.6.25 into Linus upstream without having to sift
through the merging of that stuff.  It never merges cleanly using
the automated mechanisms, because since the changes are split up
nicely there are long changeset dependency chains.

So I rebase, and do the merging work by hand.

Next, let's say Jeff merges some net driver bug fixes into upstream,
resulting in potential conflicts with the several hundred or so driver
changes that are in the net-2.6.25 tree too.

In fact near the end of 2.6.24 development, there was a new merge
conflict created on a daily basis with the net-2.6.25 tree.  You
simply cannot avoid this when you're managing 1500+ changes.

I even had to rebase the net-2.6.25 tree once or twice in Australia as
the merge window was openning up because I could push something
cleanly to Linus.  There were conflicts created by stuff that got in
before the net-2.6.25 tree, mostly in files like the feature removal
schedule, Kconfig files, and whatnot.

At times I even felt the urge to avoid merging a bug fix upstream
because of all the merge conflicts it would create, but I of course
can't and won't do that. 8)

It actually turns out that things simplify once a tree gets into the
-stable folks hands.  I pick out bug fixes as they go upstream, and
toss it to them once Linus sucks it in and I have an upstream
changeset ID to give them.  I don't have to worry about -stable
changesets causing development merge grief later on.

And I've also yet to be shown how to completely remove a changeset
from a GIT tree without rebasing :-)
