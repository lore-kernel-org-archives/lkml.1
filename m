Return-Path: <linux-kernel-owner+w=401wt.eu-S935287AbZDJAkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287AbZDJAkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbZDJAjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:39:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49510 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbZDJAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:39:52 -0400
Date: Fri, 10 Apr 2009 10:39:47 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090410003947.GA21681@brong.net>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain> <20090409184022.GA2665@elte.hu> <20090409193635.GO14687@one.firstfloor.org> <20090409211733.GA23233@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090409211733.GA23233@elte.hu>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 11:17:33PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Using a mutex seems like the sane choice here. I'd advocate spinlocks 
> > > for a new filesystem any day (but even there it's a fine choice to have 
> > > a mutex, if top of the line scalability is not an issue).
> > > 
> > > But for a legacy filesystem like reiser3, which depended on the BKL 
> > 
> > reiser3 is much more widely used in the user base than a lot of 
> > "non legacy" file systems. It's very likely it has significantly 
> > more users than ext4 for example. Remember that it was the default 
> > file system for a major distribution until very recently. [...]
> 
> ( Drop the condescending tone please - i very much know that SuSE 
>   installed reiser3 by default for years. It is still a legacy 
>   filesystem and no new development has gone into it for years. )

legacy (adj) — A pejorative term used in the computer industry meaning
"it works"

http://homepages.tesco.net/~J.deBoynePollard/FGA/legacy-is-not-a-pejorative.html

It's by far the best of all the currently available and stable
filesystems for our workload (big honking Cyrus IMAP boxes)

There have been bugfixes and occasional bits and pieces over
the years.  We applied a couple of patches for a while until
they were accepted upstream only a couple of years ago.

It doesn't get much new development because, gee, "it works".
Some people like their filesystem to keep just working in a
predictable way.

I would be very concerned if people though it was OK to break
it just because these shiny new ext4 and btrfs filesystem which
are _NOT_YET_READY_ had replaced it.

Ta.
 
> > [...] I also got a few reiser3 fs still around, it tended to 
> > perform very well on kernel hacker workloads.
> 
> Then i am sure you must like this patch: it introduces a per 
> superblock lock, splitting up the big BKL serialization. You
> totally failed to even acknowledge that advantage, maybe you
> missed that aspect?
> 
> For example, if you have /home and / on separate reiser3 
> filesystems, you could see as much as a 200% jump in performance 
> straight away on certain workloads, on a dual-core box.
> 
> That big BKL overhead is a real reiser3 scalability problem - 
> especially on reiser3 using servers which are likely to have several 
> filesystems on the same box.

Yes - I'm certainly interested in that.

That said, we have a box with 83 reiserfs partitions on it, and
which is constrained by IO (main servers really don't need much
CPU).  Performance is pretty good even now.

So - I'm interested in this patch series, but not at the expense
of making reiserfs any less stable.  Our customers, funnily enough,
like it when our service is stable!

Thanks,

Bron.
