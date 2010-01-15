Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0AOMxb (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407Ab0AOMxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:53:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:33125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0AOMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:53:30 -0500
Subject: Re: lockdep: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R}
 usage.
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20100115124410.GI28498@discord.disaster>
References: <20100115120253.GH28498@discord.disaster>
	 <1263557473.4244.399.camel@laptop>
	 <20100115124410.GI28498@discord.disaster>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 13:53:15 +0100
Message-ID: <1263559995.4244.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 23:44 +1100, Dave Chinner wrote:
> 
> > > I can't work out what the <mumble>RECLAIM_FS<mumble> notations are
> > > supposed to mean from the code and they are not documented at
> > > all, so I need someone to explain what this means before I can
> > > determine if it is a valid warning or not....
> > 
> > The <mumble>RECLAIM_FS<mumble> bit means that lock (iprune_sem) was
> > taken from reclaim and is also taken over an allocation.
> 
> So there's an implicit, undocumented requirement that inode reclaim
> during unmount requires a filesystem to do GFP_NOFS allocation? 

Well, I don't know enough about xfs (of filesystems in generic) to say
that with any certainty, but I can imagine inode writeback from the sync
that goes with umount to cause issues.

If this inode reclaim is past all that and the filesystem is basically
RO, then I don't think so and this could be considered a false positive,
in which case we need an annotation for this.

I added hch since he poked at similar reclaim recursions on XFS before
and Nick since he thought up this annotation and knows more about
filesystems than I do.



