Return-Path: <linux-kernel-owner+w=401wt.eu-S947814AbXHMO7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947814AbXHMO7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945096AbXHMMai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:30:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25615 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S945048AbXHMMaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:30:35 -0400
Date: Mon, 13 Aug 2007 14:30:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070813123031.GS23758@kernel.dk>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu> <20070803001447.GA14775@wotan.suse.de> <20070804065037.GA30816@elte.hu> <20070806032949.GA16401@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806032949.GA16401@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06 2007, Nick Piggin wrote:
> > > What CPU did you get these numbers on? Do the indirect calls hurt much 
> > > on those without an indirect predictor? (I'll try running some tests).
> > 
> > it was on an older Athlon64 X2. I never saw indirect calls really 
> > hurting on modern x86 CPUs - dont both CPU makers optimize them pretty 
> > efficiently? (as long as the target function is always the same - which 
> > it is here.)
> 
> I think a lot of CPUs do. I think ia64 does not. It predicts
> based on the contents of a branch target register which has to
> be loaded I presume before instructoin fetch reaches the branch.
> I don't know if this would hurt or not.

Testing on ia64 showed that the indirect calls in the io scheduler hurt
quite a bit, so I'd be surprised if the impact here wasn't an issue
there.

-- 
Jens Axboe

