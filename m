Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbXJRK4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbXJRK4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763681AbXJRKzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:55:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4229 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763117AbXJRKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:55:54 -0400
Date: Thu, 18 Oct 2007 12:55:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071018105516.GT5063@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org> <20071017180042.GP15552@kernel.dk> <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org> <20071017182206.GS15552@kernel.dk> <47173B00.3070303@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47173B00.3070303@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Benny Halevy wrote:
> On Oct. 17, 2007, 20:22 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Oct 17 2007, Linus Torvalds wrote:
> >>
> >> On Wed, 17 Oct 2007, Jens Axboe wrote:
> >>>> So avoiding the "sg_next()" on the last entry is pointless. 
> >>> Yeah, I didn't quite understand why if sg was valid, why dereferencing
> >>> *(sg + 1)->page would crap out :/
> >> Actually, I take that back. If 'sg' is the last entry in a *non*linked 
> >> scatter-gather list (ie we don't use the last entry as a link, we actually 
> >> use it as a real SG entry), then "sg_next(sg)" will indeed access past the 
> >> end of the whole allocated array, and will access one past the end.
> >>
> >> And with page-alloc debugging, that *will* blow up.
> >>
> >> So I think your change to use "sg_next()" only when you actually need a 
> >> next pointer is the correct one after all.
> > 
> > Thanks, so I'm not totally crazy :-)
> > 
> > Can you just pull:
> > 
> >   git://git.kernel.dk/data/git/linux-2.6-block.git for-linus
> > 
> > then so we get those two pieces correct? Then the remaining issue seems
> > to be a new one that is biting Ingo elsewhere, at least we'll all be on
> > the same page then.
> > 
> 
> Jens, for_each_sg still calls sg_next on the last entry which will
> dereference a possibly bogus sg->page (for the sg_is_chain(sg)
> condition in sg_next) if the last entry is the last one on the page
> of unchained entry and sg+1 falls over into an uninitialized page.

Things have progressed a lot since, see my recent posting based on
Davem's proposal. Will post another patch soonish, that is also tested.

-- 
Jens Axboe

