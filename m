Return-Path: <linux-kernel-owner+w=401wt.eu-S1763702AbYBLX6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763702AbYBLX6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYBLX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:58:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYBLX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:58:22 -0500
Date: Tue, 12 Feb 2008 15:58:53 -0800 (PST)
Message-Id: <20080212.155853.193190548.davem@davemloft.net>
To: jeff@garzik.org
Cc: arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <47B1CB08.4020101@garzik.org>
References: <20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 12 Feb 2008 11:36:24 -0500

> Rebasing is low impact only if you don't have git downstream people.
> Otherwise, you're just treating it as a useful quilt clone, really.

Understood.

One of the key operations that I'm interested in is removing things
from the history.  If I could do that using GIT without any side
effects and in a way that really would remove it from the tree, I
would do that in a heartbeat.

At 1500 changesets, a merge conflict shows up about once
every day or two as 2.6.N nears it's release into final
as bug fixes trickle in.

I find using GIT to fixup merge errors on a tree of that
scale to be really painful.  And it only fixes up the final
result in a merge changeset.

Just like we expect submitters to refresh their patches
as things change upstream, we as developers should be able
to refresh trees of changes we are maintaining for similar
effect.

This is all made difficult because GIT's commit IDs are tied
to where they are in the tree, and thus are dependant upon
the wholeness of parents and subsequently their parents.

That's why it's hard to "just remove" something completely
without rebasing the tree.

Let me give you a good example, just yesterday I had to rebase
my net-2.6 tree a few times.  It's because I put a patch in there
that the person said was OK but it broke the build.  There is
zero reason for me to push that tree to Linus with the bad
commit and the revert, it's just noise and makes the tree harder
for people to review.

Now, to preserver your tree's history I simply reapplied the
stuff I wanted then repulled your tree.

But right now I have to redo the include/linux/rcupdate.h that's in
there because it has a bug.  I now want to rebase again to just kick
out the existing rcupdate.h changeset, because I know of no
alternative that really lets me get rid of the original bogus
changeset.
