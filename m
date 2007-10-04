Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXJDK6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXJDK6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXJDK55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:57:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10871 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbXJDK55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:57:57 -0400
Date: Thu, 4 Oct 2007 12:59:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Mullis <dwm@meer.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004105930.GC5711@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop> <20071003231659.f41df5ed.akpm@linux-foundation.org> <20071004072515.GC5236@kernel.dk> <20071004100154.6093844d@poseidon.drzeus.cx> <20071004080631.GB23808@kernel.dk> <20071004104626.2a219926@poseidon.drzeus.cx> <20071004093014.GE23808@kernel.dk> <20071004122439.0944f3db@poseidon.drzeus.cx> <20071004103805.GB5711@kernel.dk> <20071004124602.2be94bfe@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004124602.2be94bfe@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Pierre Ossman wrote:
> On Thu, 4 Oct 2007 12:38:05 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Oct 04 2007, Pierre Ossman wrote:
> > > 
> > > Is that a yes or a no? You said that the ->page field was involved
> > > in
> > 
> > It's a conditional yes, re-read it :-)
> > 
> 
> I didn't get the memo about what chained sg entries entail.

It's been posted here several times, but that's ok and it should not
matter. I just can't answer your question with a clear yes or no, since
it depends on certain situations.

> > > list chaining, so does or doesn't it have to be initialized before a
> > > call to sg_init_one()?
> > 
> > That's not the problem. It has to be initialized before calling
> > blk_rq_map_sg(). sg_init_one() will zero the entire sg entry, and that
> > breaks if that particular sg entry is part of a larger sg table AND
> > that sg entry happens to be the chain element.
> > 
> 
> Ok, then it shouldn't affect my world at least.

No, I think mmc is fine, it just needed that memset.

> PS. Did someone forget to do a review of all blk_rq_map_sg() callers
> before committing the chained list stuff? ;)

Apparently this one got missed (and cciss), I'll do a new look just to
be on the safe side.

-- 
Jens Axboe

