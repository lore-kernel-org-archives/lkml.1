Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZFEJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZFEJi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZFEJiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:38:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:46233 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFEJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:38:21 -0400
X-SpamScore: -42
X-BigFish: VPS-42(z21eWz1432R98dR14ffO936eN1805M103dK873fn241fmzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKRERO-02-5N4-01
Date: Fri, 5 Jun 2009 11:37:25 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-ID: <20090605093725.GC23657@alberich.amd.com>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org> <200906050339.n553d684048041@www262.sakura.ne.jp> <20090604205103.bbfe9af2.akpm@linux-foundation.org> <200906050400.n5540Sx0052981@www262.sakura.ne.jp> <20090604212018.b9e9f354.akpm@linux-foundation.org> <200906050651.n556p7Vo094549@www262.sakura.ne.jp> <20090605000310.a5b8fa56.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090605000310.a5b8fa56.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Jun 2009 09:38:12.0979 (UTC) FILETIME=[584EFC30:01C9E5C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 12:03:10AM -0700, Andrew Morton wrote:
> On Fri, 05 Jun 2009 15:51:07 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > >but I wonder why all those things are u64.  They all hold virtual
> > >addresses, don't they?  The code doesn't test highmem.  So shouldn't
> > >these all be unsigned longs?
> > memtest() in linux-2.6.29.4/arch/x86/mm/memtest.c is using "unsigned long".
> > 2.6.30 changed to use "u64" by some reason.
> 
> No reason, really.  "consistency". 

Yes, it was done that way for consistency.
See this thread
  http://lkml.org/lkml/2009/2/13/166

> It made the code slower,

not measurable

> larger

slightly on 32-bit

> and, err, not compile.

Mea culpa.

Overlooked the 64-bit division.
Did test this with 4.[23].x compilers on 32-bit which didn't complain ...

I assume you are going to send your do_div() fix upstream?


Thanks!

Andreas



