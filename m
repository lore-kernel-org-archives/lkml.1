Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbYBLREI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbYBLREI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbYBLRDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:03:55 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58937 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYBLRDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:03:53 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <47B1CB08.4020101@garzik.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 11:03:39 -0600
Message-Id: <1202835819.3137.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 11:36 -0500, Jeff Garzik wrote:
> David Miller wrote:
> > This is why, with the networking, we've just tossed all of the network
> > driver stuff in there too.  I can rebase freely, remove changesets,
> > rework them, etc. and this causes a very low amount of pain for Jeff
> > Garzik and John Linville.
> 
> 
> s/very low/not low/
> 
> Rebasing is always a pain, and John and I both agreed the other day that 
> you do it too often.
> 
> I've complained about this before, too...  but figured this was just 
> another thing I was getting ignored on, and so life moved on.  But don't 
> try to sell rebasing as "low pain".
> 
> Rebasing makes the history all nice and pretty, but by totalling 
> flattening the history, trashing all the commit ids (and rewriting 
> associated metadata), you create obvious downstream problems.
> 
> Rebasing is  low impact only if you don't have git downstream people. 
> Otherwise, you're just treating it as a useful quilt clone, really.

I used to be in this camp too: seeing rebasing as the ultimate evil.
However, what I found was that as I tried to preserve my merge tree's
history, I was picking up merge points with non trivial fixups.  You can
argue that this is how git is supposed to operate, but the problem is
that these merge points become immovable objects in the tree history ...
I can't rebase the tree at all any more and I can't simply remove a
commit (which gets messy for commits duplicated by other trees)  They
also effectively separate the fix up from the patch causing it.   Plus,
it became difficult for people to go to gitweb to see the tree history,
because everything before the merge point got buried.

I finally concluded that I needed to rebase my trees to resolve
conflicts rather than merging them.  The advantages are I know the exact
patch with the problem and I can keep the history annotated with what
had to be done to get it to apply.  Plus with git (and this is a huge
advantage over quilt) knowing the base of the patch, I can still use the
merge algorithms to help me do the fixup.

I'm not saying rebase constantly ... I'm still mindful of the disruption
it causes, so I only do it if I pick up an actual conflict.  However, I
do think it does becomes necessary at times.

The problem rebasing causes is that git is pretty horrible at rebasing a
tree which is based on your now rebased tree (try saying that after a
few martinis).  Git really needs to acquire better rebasing tools for
this one case, but if that were solved, I think a lot of the objections
to rebasing could be answered.

James


