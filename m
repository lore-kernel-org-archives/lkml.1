Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbXDXRFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbXDXRFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXDXRFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:05:50 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6459 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbXDXRFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:05:49 -0400
Date: Tue, 24 Apr 2007 19:02:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, OVZDL <devel@openvz.org>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Message-ID: <20070424170227.GB27887@kernel.dk>
References: <1177422791.435404.4031.nullmailer@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177422791.435404.4031.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, Vasily Tarasov wrote:
> From: Vasily Tarasov <vtaras@openvz.org>
> 
> cfq hash is no more necessary.  We always can get cfqq from io context.
> cfq_get_io_context_noalloc() function is introduced, because we don't want to
> allocate cic on merging and checking may_queue.
> In order to identify sync queue we've used hash key = CFQ_KEY_ASYNC. Since hash
> is eliminated we need to use other criterion: sync flag for queue is added.
> In all places where we dig in rb_tree we're in current context, so no
> additional locking is required.
> 
> Advantages of this patch: no additional memory for hash, no seeking in hash,
> code is cleaner. But it is necessary now to seek cic in per-ioc rbtree, but
> it is faster:
> - most processes work only with few devices
> - most systems have only few block devices
> - it is a rb-tree

Vasily, this is still not against the CFQ branch, I get tons of rejects:

axboe@nelson:/src/linux-2.6-block $ patch -p1 --dry-run < ~/foo
[...]
10 out of 27 hunks FAILED -- saving rejects to file
block/cfq-iosched.c.rej

If you don't want to use the git tree, then just grab

http://brick.kernel.dk/snaps/cfq-update-20070424

and apply it to 2.6.21-rc7-gitX (latest) and provide a diff against
that. Thanks!

-- 
Jens Axboe

