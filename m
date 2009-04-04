Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZDDRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZDDRe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZDDReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:34:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46421 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZDDReP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:34:15 -0400
Date: Sat, 4 Apr 2009 19:34:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090404173412.GF5178@kernel.dk>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04 2009, Linus Torvalds wrote:
> 
> 
> On Sat, 4 Apr 2009, Jens Axboe wrote:
> > 
> > Big nack on this patch. Ted, this is EXACTLY where I told you we saw big
> > write regressions (sqlite performance drops by a factor of 4-5). Do a
> > git log on fs/buffer.c and see the original patch (which does what your
> > patch does) and the later revert. No idea why you are now suggestion
> > making that exact change?!
> 
> Jens, if I can re-create the 'fsync' times (I haven't yet), then the 
> default scheduler _will_ be switched to AS.

Linus, I'm not aware of a difference here between AS and CFQ. If there
is, it's surely a bug and it will be fixed ASAP. The email I wrote has
nothing to do with CFQ performance, it was a general observation on what
happened with an identical patch.

> > Low latency is nice, but not at the cost of 4-5x throughput for real
> > world cases.
> 
> I'm sorry, but that fsync thing _is_ a real-world case, and it's the one 
> that a hell of a lot more people care about than some idiotic sqlite 
> throughput issue.

sqlite is just one case, I'm sure there are others. My point is that we
should make sure that we don't regress on the throughput side. It's a
trade off, we don't want throughput to fall through the floor either.

> You have a test-case now. Consider it a priority, or consider CFQ to be a 
> "for crazy servers that only care about throughput".

CFQ was never for crazy servers, it was very much about interactiveness
from the very beginning. So if it's broken on CFQ, it will of course get
fixed right away.

> Quite frankly, the fact that I can see _seconds_ of latencies with a 
> really good SSD is not acceptable. The fact that it is by design is even 
> less so.

Agree, multi-second latencies is not acceptable.

> Latency is more important than throughput. It's that simple.

It's really not that simple, otherwise the schedulers would be much
simpler. It's pretty easy to get good latency if you disregard any
throughput concerns, that'll never work in the real world. Latency is
definitely extremely important, but simply stating that latency is the
one and only factor of importance is just too simplistic.

-- 
Jens Axboe

