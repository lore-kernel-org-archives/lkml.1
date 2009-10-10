Return-Path: <linux-kernel-owner+w=401wt.eu-S934920AbZJJVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920AbZJJVLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934865AbZJJVLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:11:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51260 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934833AbZJJVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:11:08 -0400
Date: Sat, 10 Oct 2009 23:10:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>,
       Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/31] Swap over NFS -v20
Message-ID: <20091010211024.GB14051@elf.ucw.cz>
References: <1254405858-15651-1-git-send-email-sjayaraman@suse.de>
 <20091001174201.GA30068@infradead.org>
 <1254692482.21044.15.camel@laptop>
 <20091010120614.GC1811@ucw.cz>
 <1255177421.11081.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255177421.11081.0.camel@twins>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-10 14:23:41, Peter Zijlstra wrote:
> On Sat, 2009-10-10 at 14:06 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > One of them
> > > > would be the whole VM/net work to just make swap over nbd/iscsi safe.
> > > 
> > > Getting those two 'fixed' is going to be tons of interesting work
> > > because they involve interaction with userspace daemons.
> > > 
> > > NBD has fairly simple userspace, but iSCSI has a rather large userspace
> > > footprint and a rather complicated user/kernel interaction which will be
> > > mighty interesting to get allocation safe.
> > > 
> > > Ideally the swap-over-$foo bits have no userspace component.
> > > 
> > > That said, Wouter is the NBD userspace maintainer and has expressed
> > > interest into looking at making that work, but its sure going to be
> > > non-trivial, esp. since exposing PF_MEMALLOC to userspace is a, not over
> > > my dead-bodym like thing.
> > 
> > Well, as long as nbd-server is on separate machine (with real swap),
> > safe swapping over network should be ok, without PF_MEMALLOC for
> > userspace or similar nightmares, right?
> 
> Nope, as soon as the nbd-client looses its connection you're up shit
> creek.

Oops, right. Putting reconnect logic into the kernel would make sense.

I misunderstood your proposal. I thought you'd want to put
nbd-_server_ into the kernel too. I guess we violently agree that
that's unneccessary.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
