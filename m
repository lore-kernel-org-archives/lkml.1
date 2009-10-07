Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbZJGVH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbZJGVH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZJGVH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:07:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZJGVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:07:28 -0400
Date: Wed, 7 Oct 2009 23:06:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091007210651.GB1656@one.firstfloor.org>
References: <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 01:51:07PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Oct 2009, Andi Kleen wrote:
> > 
> > With some strategic prefetches it might be cheap enough to use 
> > two cache lines. Just fetch it with the other.
> 
> I _seriously_ doubt that.
> 
> This is one of the biggest (and hottest) hash tables in the whole kernel.
> 
> No amount of prefetching will help the fact that you effectively double 
> your cache footprint / working set if you have to fetch two cachelines in 
> the hot case lookup rather than one.

It won't double it, because there are many more cache lines from
all kinds of other things in these paths. The point was just to hide 
the latency of fetching two at different times. The actual cache foot print
is not that important, as long as it's not excessive, just the latencies
hurt.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
