Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbYDNQzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbYDNQzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762686AbYDNQyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:54:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4401 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762654AbYDNQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:54:50 -0400
Date: Mon, 14 Apr 2008 18:54:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414165442.GN12774@kernel.dk>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080413070513.GB19773@elte.hu> <20080413125205.GP11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413125205.GP11962@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13 2008, Matthew Wilcox wrote:
> On Sun, Apr 13, 2008 at 09:05:13AM +0200, Ingo Molnar wrote:
> > there's also another aspect: completions are faster a bit 
> > in theory, because they know that they will schedule most of the time - 
> > while semaphores assume that they will _not_ schedule. (And that's 
> > exactly because the intent of the developer when using a completion is 
> > crystal clear.)
> 
> In practice though, the current implementation is slower.  Of course,
> that's fixable, and I strongly suspect that the current users of
> completions simply don't care about speed -- the normal use of
> completions is in startup and shutdown paths where a millisecond extra
> isn't going to be noticable.

I'd be surprised if it was in that range, milisecond range would
definetely mean that something was completely bused in that area :-).
IOW, I'd be surprised if you can measure much of a difference, even in
microbencmarks.

And performance does matter somewhat, it's not ONLY used in
startup/shutdown scenarios. The block layer uses it for sync requests,
for instance.

-- 
Jens Axboe

