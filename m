Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZLDHnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZLDHnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZLDHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:43:36 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49056 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZLDHng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:43:36 -0500
Date: Fri, 4 Dec 2009 08:43:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20091204074341.GH8742@kernel.dk>
References: <20091204143612.f30db275.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204143612.f30db275.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> block/built-in.o: In function `blkiocg_destroy':
> blk-cgroup.c:(.text+0x1bd48): undefined reference to `cfq_unlink_blkio_group'
> block/built-in.o: In function `blkiocg_weight_write':
> blk-cgroup.c:(.text+0x1c0d2): undefined reference to `cfq_update_blkio_group_weight'
> 
> Caused by commits b1c3576961847da26c91b1e97f226bb66be5fa3f ("blkio: Take
> care of cgroup deletion and cfq group reference counting") and
> f8d461d692c341add957fb973fb5ee1f62039dc7 ("blkio: Propagate cgroup weight
> updation to cfq groups").
> 
> When adding code that is CONFIG dependent, please build test it with and
> without the relevant CONFIG setting (in this case
> CONFIG_CFQ_GROUP_IOSCHED).  Also put the extern declarations of global
> functions into a header file.

The problem looks like a circular dependency betwen BLK_CGROUP and CFQ.
The Kconfig dependencies doesn't express that blk-cgroup also calls into
cfq, so you can't have cfq=m (cfq doesn't even export those functions).
It looks pretty messy, to be honest. I'll see if I can fix it up.

> I have used the version of the block tree from next-20091203 for today.

Thanks.

-- 
Jens Axboe

