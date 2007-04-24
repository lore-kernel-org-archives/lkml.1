Return-Path: <linux-kernel-owner+w=401wt.eu-S1161733AbXDXM2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161733AbXDXM2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161740AbXDXM2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:28:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55563 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161733AbXDXM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:28:39 -0400
Date: Tue, 24 Apr 2007 14:27:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, OVZDL <devel@openvz.org>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Message-ID: <20070424122739.GJ3744@kernel.dk>
References: <1177415595.191341.7293.nullmailer@me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177415595.191341.7293.nullmailer@me>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
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
> 
> Advantages of this patch: no additional memory for hash, no seeking in hash,
> code is cleaner. But it is necessary now to seek cic in per-ioc rbtree, but
> it is faster:
> - most processes work only with few devices
> - most systems have only few block devices
> - it is a rb-tree

Vasily, thanks for doing this, it's a good cleanup. One request, though
- care to rebase this against the cfq devel branch? I'm afraid it's
nowhere near applying right now.

-- 
Jens Axboe

