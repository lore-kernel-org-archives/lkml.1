Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXKFT0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXKFT0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXKFT0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:26:16 -0500
Received: from brick.kernel.dk ([87.55.233.238]:1424 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbXKFT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:26:16 -0500
Date: Tue, 6 Nov 2007 20:26:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: fix IOPRIO_CLASS_IDLE delays
Message-ID: <20071106192611.GS1767@kernel.dk>
References: <20071106200510.GA11435@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106200510.GA11435@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06 2007, Oleg Nesterov wrote:
> After the fresh boot:
> 
> 	ionice -c3 -p $$
> 	echo cfq >> /sys/block/XXX/queue/scheduler
> 	dd if=/dev/XXX of=/dev/null bs=512 count=1
> 
> Now dd hangs in D state and the queue is completely stalled for approximately
> INITIAL_JIFFIES + CFQ_IDLE_GRACE jiffies. This is because cfq_init_queue()
> forgets to initialize cfq_data->last_end_request.

Another good catch, thanks Oleg!

> (I guess this patch is not complete, overflow is still possible)

Hmm, where would it overflow?

-- 
Jens Axboe

