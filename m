Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYG3RyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYG3RyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYG3RyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:54:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYG3RyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:54:11 -0400
Date: Wed, 30 Jul 2008 19:54:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
Message-ID: <20080730175406.GN20055@kernel.dk>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30 2008, Miklos Szeredi wrote:
> On Wed, 30 Jul 2008, Linus Torvalds wrote:
> > On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > > 
> > > There are no real disadvantages: splice() from a file was
> > > originally meant to be asynchronous, but in reality it only did
> > > that for non-readahead pages, which happen rarely.
> > 
> > I still don't like this. I still don't see the point, and I still
> > think there is something fundamentally wrong elsewhere.

You snipped the part where Linus objected to dismissing the async
nature, I fully agree with that part.

> We discussed the possible solutions with Nick, and came to the
> conclusion, that short term (i.e. 2.6.27) this is probably the best
> solution.

Ehm where? Nick also said that he didn't like removing the ->confirm()
bits as they are completely related to the async nature of splice. You
already submitted this exact patch earlier and it was nak'ed.

> Long term sure, I have no problem with implementing async splice.
> 
> In fact, I may even have personal interest in looking at splice,
> because people are asking for a zero-copy interface for fuse.
> 
> But that is definitely not 2.6.27, so I think you should reconsider
> taking this patch, which is obviously correct due to its simplicity,
> and won't cause any performance regressions either.

Then please just fix the issue, instead of removing the bits that make
this possible.

-- 
Jens Axboe

