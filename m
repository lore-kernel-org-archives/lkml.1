Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYESEMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYESEMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYESEM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:12:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYESEM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:12:27 -0400
Date: Sun, 18 May 2008 21:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-Id: <20080518211140.b29bee30.akpm@linux-foundation.org>
In-Reply-To: <4830E60A.2010809@redhat.com>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
	<482DF44B.50204@redhat.com>
	<20080516220315.GB15334@shareable.org>
	<482E08E6.4030507@redhat.com>
	<8763tbcrbo.fsf@basil.nowhere.org>
	<20080519004325.GC8335@mit.edu>
	<4830E60A.2010809@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 21:29:30 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> Theodore Tso wrote:
> ...
> 
> > Given how rarely people have reported problems, I think it's a really
> > good idea to understand what exactly our exposure is for
> > $COMMON_HARDWARE. 
> 
> I'll propose that very close to 0% of users will ever report "having
> barriers off seems to have corrupted my disk on power loss!" even if
> that's exactly what happened.  And it'd be very tricky to identify in a
> post-mortem.  Instead we'd probably see other weird things caught down
> the road during some later fsck or during filesystem use, and then
> suggest that they go check their cables, run memtest86 or something...
> 
> Perhaps it's not the intent of this reply, Ted, but various other bits
> of this thread have struck me as trying to rationalize away the problem.

Not really.  It's a matter of understanding how big the problem is.  We
know what the cost of the solution is, and it's really large.

It's a tradeoff, and it is unobvious where the ideal answer lies,
especially when not all the information is available.

>  If the discussion were about proper locking to avoid corruption, would
> we really be  saying well, gosh, it's a *really* small window, and
> *most* people won't hit it very often, and proper locking would slow
> things down....

If it slowed really really important workloads by 30% then we'd be
running around with our hair on fire fixing that up.

But fixing this one is nowhere near as easy as fixing some locking
thing.

> So I think that as you suggest, looking for ways to make barriers less
> painful is the far better route, rather than sacrificing correctness for
> speed by turning them off by default when we know there is a chance for
> problems.  People running journaling filesystems most likely expect to
> be safe from this sort of thing, not most of the time, but all of the time.

Well.  Reducing the cost would of course make the decision easy.
