Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZDGLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZDGLtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZDGLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:49:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45962 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZDGLtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:49:25 -0400
Date: Tue, 7 Apr 2009 13:49:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gentuu@gmail.com
Subject: Re: [GIT PULL] block updates for 2.6.30-rc1
Message-ID: <20090407114923.GT5178@kernel.dk>
References: <20090407113909.GS5178@kernel.dk> <a4423d670904070444p75bb8811p779ca9ed12719df4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670904070444p75bb8811p779ca9ed12719df4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07 2009, Alexander Beregalov wrote:
> 2009/4/7 Jens Axboe <jens.axboe@oracle.com>:
> > Hi Linus,
> >
> > This is the collected set of small updates in the block area, as well as
> > the CFQ update you tested yesterday. It's essentially the same, but
> > allows for a bit more queuing for a solitary IO issuer. If it ends up
> > interferring too much with new IO, I'll augment that check with a time
> > based one as well. Looks good here, though.
> >
> > There's also a fix for a long standing CFQ problem that caused slowdowns
> > with CFQ on streamed IO due to CFQ being too eager to restart IO
> > queuing.
> >
> >  git://git.kernel.dk/linux-2.6-block.git for-linus
> >
> 
> Hi Jens
> 
> I sent you a fix for loop device.
> http://patchwork.kernel.org/patch/15763/

I missed that the thread had the loop fix as well. I've included it now,
looks fine to me. Linus, the new diffstat is now:

 Dumentation/blockdev/00-INDEX   |    2 
 Documentation/blockdev/mflash.txt |   84 ++
 block/blk-core.c                  |   15 
 block/blk-merge.c                 |   29 
 block/blk-sysfs.c                 |    4 
 block/blk.h                       |   14 
 block/cfq-iosched.c               |  202 +++---
 block/elevator.c                  |   42 -
 drivers/block/Kconfig             |   17 
 drivers/block/Makefile            |    1 
 drivers/block/cciss.c             |  117 +++
 drivers/block/cciss.h             |    2 
 drivers/block/cciss_cmd.h         |   23 
 drivers/block/loop.c              |    7 
 drivers/block/mg_disk.c           | 1005 ++++++++++++++++++++++++++++++
 include/linux/blkdev.h            |    2 
 include/linux/elevator.h          |    1 
 include/linux/mg_disk.h           |  206 ++++++
 18 files changed, 1624 insertions(+), 149 deletions(-)

-- 
Jens Axboe

