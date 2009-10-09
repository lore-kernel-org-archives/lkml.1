Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbZJIKI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbZJIKI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbZJIKI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759920AbZJIKIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:08:25 -0400
Date: Fri, 9 Oct 2009 12:07:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>, David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009100748.GE17818@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de> <20091008125746.GL9228@kernel.dk> <20091008132200.GB30316@wotan.suse.de> <20091009085451.GS9228@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009085451.GS9228@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 10:54:52AM +0200, Jens Axboe wrote:
> On Thu, Oct 08 2009, Nick Piggin wrote:
> > This is actualy nice too. My tests were on a 2s8c Barcelona system,
> > but this is showing we have a nice serial win on Nehalem as well.
> > Actually K8 CPUs have a bit faster lock primitives than earlier
> > Intel CPUs I think (closer to Nehalem), so we might see an even
> > bigger win with a Core2.
> 
> Ran it on another box. This isn't quite a core 2 though, it's a sparc64
> (Niagara 2). It has 64 threads, too, but just 8 cores.
> 
> 2.6.32-rc3 serial
> real    0m5.390s
> user    0m1.340s
> sys     0m2.970s
> 
> 2.6.32-rc3 parallel
> real    0m2.009s
> user    0m0.900s
> sys     0m2.490s
> 
> vfs serial
> real    0m4.816s
> user    0m1.250s
> sys     0m2.270s
> 
> vfs parallel
> real    0m1.967s
> user    0m0.920s
> sys     0m1.960s
> 
> So it's a win-win there on that platform too.

That's nice to see it's really quite a good win in the serial case
on this CPU too.

Parallel interestingly not improved. Whether it is because the locks
are able to be bounced around much more quickly than on our multi
socket systems, or some quirk of the lots-of-chickens CPU that doesn't
take so well to the workload, I don't know. Maybe it's even the
fs->lock that will still be there in your patches.

