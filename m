Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZDURXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZDURXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZDURWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:22:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZDURWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:22:49 -0400
Date: Tue, 21 Apr 2009 19:15:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090421171530.GA12014@redhat.com>
References: <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Linus Torvalds wrote:
>
> On Tue, 21 Apr 2009, Oleg Nesterov wrote:
> >
> > > (You do rcu_read_unlock() earlier, but that's okay.)
> >
> > Yes, but unless we have a "strong" reason, it is better to take
> > fs->lock first. rcu_read_lock() is free, but disables preemption.
>
> .. but so does taking a spinlock. So it shouldn't matter.
>
> We could play games with that (the same way I think we have some games for
> large-system irq latency with '__raw_spin_lock_flags()' on ia64), but that
> makes sense only when you have lots of CPU's and expect irq latency to
> suffer.
>
> And it doesn't tend to make sense for preemption latency, because if you
> have so many CPU's that you have lots of spinning on locks, you would
> normally not really care deeply about preemption (sure, in theory it's a
> real-time thing, in practice I doubt you'll find anybody who cares).

OK, I agree, it doesn't really matter from latency/etc pov.

But still I can't understand why it is better to take fs->lock under
RCU lock. I mean, "fs->lock is the innermost lock" should not apply
to rcu_read_lock(). Because the latter is a bit special, no?

Oleg.

