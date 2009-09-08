Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZIHKuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZIHKuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZIHKue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:50:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbZIHKue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:50:34 -0400
Date: Tue, 8 Sep 2009 12:50:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
Message-ID: <20090908105036.GT18599@kernel.dk>
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop> <20090908005520.GA7967@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908005520.GA7967@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Wu Fengguang wrote:
> Minchan,
> 
> I tend to agree with the change, but somehow confused by blkparse(1):
> 
>         Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.
> 
> Li Zefan has been working on blktrace and he can tell more.

The documentation details the original implementation. I'm guessing the
need to move this trace hook is due to some user space tracking that
gets confused, because it cannot match the queue intent with a merge or
an insert.

I have no problems moving the trace call. If we had a matching bio_endio
trace, then I'd say moving it would lose information. But right now it
doesn't.

-- 
Jens Axboe

