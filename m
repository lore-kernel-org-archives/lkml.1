Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZIJHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZIJHsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZIJHsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:48:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46906 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZIJHsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:48:18 -0400
Date: Thu, 10 Sep 2009 09:48:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, apw@canonical.com,
       bonbons@linux-vserver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <20090910074820.GS18599@kernel.dk>
References: <20090904183525.GB18599@kernel.dk> <f48e25c99e41e375f2ddd85989cd39e1@coraid.com> <20090905051735.GH18599@kernel.dk> <366469f19c41e0150028b886f6859019@coraid.com> <20090908193540.GB18599@kernel.dk> <60772f633c524ba873f569966fccd6ce@coraid.com> <20090909180804.3e62331a@lxorguk.ukuu.org.uk> <30b7855d211ab5b6bef6fe2cd9b76295@coraid.com> <20090909205835.GK18599@kernel.dk> <810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Ed Cashin wrote:
> On Wed Sep  9 16:59:30 EDT 2009, jens.axboe@oracle.com wrote:
> > On Wed, Sep 09 2009, Ed Cashin wrote:
> ...
> > > To implement the barrier, [aoe] would stop generating new AoE write
> > > commands, wait for AoE write responses for all the outstanding write
> > > commands, issue the ATA cache flush command, wait for the response to
> > > the flush, and then resume normal activity.
> > 
> > That's how barriers work with sata to begin with, so I'd very much
> > recommend that you do the same in aoe instead of just not supporting it.
> 
> This patch with EOPNOTSUPP just fixes the regression in 2.6.31-rc9.
> 
> A patch adding support for barriers would be nice.  Since I have
> limited time I tried to motivate that work by using the torture tests
> that Chris Mason (I believe it was) posted a while ago, but I could
> not get any problems to manifest using that torture test.
> 
> If I had a reproducable problem case that the barrier implementation
> could fix, it would be very helpful.

Depending on timing and the other end, it may not be easy to reproduce.
But the problem is indeed real, so I think you should just add the
proper barrier implementation instead of spending too much time trying
to create a reproducable problem. By the time you get there, you could
have fixed it many times over :-)

-- 
Jens Axboe

