Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbZJIRyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbZJIRyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934060AbZJIRyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:54:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41377 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055AbZJIRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:54:22 -0400
Date: Fri, 9 Oct 2009 19:53:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009175345.GE1656@one.firstfloor.org>
References: <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org> <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain> <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain> <20091007222235.GC1656@one.firstfloor.org> <20091008073930.GZ30316@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008073930.GZ30316@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 09:39:30AM +0200, Nick Piggin wrote:
> > My point (probably not very well written expressed)
> > was that in a typical VFS operation there are hundreds
> > of cache lines touched for various things (code, global, various
> > objects, random stuff) and one more or less in the final dentry 
> > is not that big a difference in the global picture.
> > (ok I realize final in this case means the elements in the path)
> 
> Yes I do know what you were getting at... Although I would
> say dcache is still fairly significant. It's 3 cachelines
> for every single path element we look up. Now I suspect it

That's true, for deeply nested paths where the elements add up 
it's a concern. I was assuming that paths are not that deep, but that might 
be too optimistic.

> Actually no, it does look relatively sane (I guess it doesn't
> change that much), except it might actualy be a nice idea
> to move d_iname up to about above d_lru, so we could actually
> do path lookup in 2 cachelines per entry (or even 1 if we
> they have very short names).
> 
> I will do a bit of profiling on the lookup code and see...

Yes numbers would be great.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
