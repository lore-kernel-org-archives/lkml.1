Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000Ab0ABUdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0ABUdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897Ab0ABUdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:33:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36218 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0ABUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:33:11 -0500
Date: Sat, 2 Jan 2010 21:33:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102203305.GC30016@basil.fritz.box>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102201138.GF5076@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 09:11:39PM +0100, Frederic Weisbecker wrote:
> I've never lost any datas since I began this work. And
> I run it every day. If I had experienced lock inversions,
> and sometimes soft lockups, I did not experienced serious
> damages. It's a journalized filesystem that can fixup the things
> pretty well.

So are you confident that 2.6.33 will not have regular soft-lockups
for reiserfs users?

> 
> Also we are talking about potential lock inversions, in potential
> rare path, that could potentially raise soft lockups. That makes
> a lot of potentials, for things that are going to be fixed and
> for which I've never seen serious damages.

A soft lockup is a problem. Perhaps not totally serious,
but a user who experiences them regularly would rightly consider
such a release very broken.

> We could make a new reiserfs version by duplicating the code
> base. But nobody will test it. That would require to patch
> mkreiserfs, waiting for distros to ship it, waiting for
> users to ship the distros. Assuming at this time there
> will be remaining users to set up new reiserfs partitions.

I suspect your estimates on how widely reiserfs is used 
are quite off. However as usual a large part of the user
base simply only uses what their distribution ships.

> We could also have a reiserfs-no-bkl config option that
> would pick the duplicated code base. Again I fear few people
> will test it.

That sounds reasonable, at least have a workaround if there
are too many problems.

> Sometimes I do. Sometimes it's just wasteful. We don't want to relax
> the lock just because of a kmalloc(__GFP_NOFS).

If that's the problem you can always split the allocation:
first try it with __GFP_NOWAIT without lock dropped, then
if that fails do again with full __GFP_NOFS and lock drop.

However it's hard to believe that a few instructions
more or less would make much difference; I would normally
expect any larger changes coming from changes IO 
patterns or cache line bouncing.


> > Better some mildew than a seriously-broken-for-enough people's 
> > release (although I have my doubts that's the right metapher
> > for the BKL anyways)
> >
> > Having stable releases is an important part for
> > getting enough testers (we already have too little). And 
> > if we start breaking their $HOMEs they might become 
> > even less.
> 
> 
> This is very unlikely to break their $HOME.

Well break access to their $HOME

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
