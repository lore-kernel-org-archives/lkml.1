Return-Path: <linux-kernel-owner+w=401wt.eu-S1031071AbXDXMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031071AbXDXMwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031076AbXDXMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:52:21 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3890 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031071AbXDXMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:52:21 -0400
From: Vasily Tarasov <vtaras@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: OVZDL <devel@openvz.org>
References: <1177415595.191341.7293.nullmailer@me> <20070424122739.GJ3744@kernel.dk>
In-Reply-To: <20070424122739.GJ3744@kernel.dk>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Date: Tue, 24 Apr 2007 16:51:06 +0400
Message-Id: <1177419066.344602.20693.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Vasily Tarasov <vtaras@openvz.org>
>> 
>> cfq hash is no more necessary.  We always can get cfqq from io context.
>> cfq_get_io_context_noalloc() function is introduced, because we don't want
>> to
>> allocate cic on merging and checking may_queue.
>> In order to identify sync queue we've used hash key = CFQ_KEY_ASYNC. Since
>> hash
>> is eliminated we need to use other criterion: sync flag for queue is added.
>> In all places where we dig in rb_tree we're in current context, so no
>> additional locking is required.
>> 
>> 
>> Advantages of this patch: no additional memory for hash, no seeking in hash,
>> code is cleaner. But it is necessary now to seek cic in per-ioc rbtree, but
>> it is faster:
>> - most processes work only with few devices
>> - most systems have only few block devices
>> - it is a rb-tree
>
> Vasily, thanks for doing this, it's a good cleanup. One request, though
> - care to rebase this against the cfq devel branch? I'm afraid it's
> nowhere near applying right now.
> -- 
> Jens Axboe

Ouch, I see the sources are changed since the moment I was getting them...
I'll resend a fresh version!


