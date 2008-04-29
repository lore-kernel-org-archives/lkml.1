Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYD2Mox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYD2Mox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbYD2Moc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:44:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1485 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbYD2Moc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:44:32 -0400
Date: Tue, 29 Apr 2008 14:44:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Skip I/O merges when disabled
Message-ID: <20080429124427.GP12774@kernel.dk>
References: <481715E7.2070103@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481715E7.2070103@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Alan D. Brunelle wrote:

> 
> The block I/O + elevator + I/O scheduler code spend a lot of time trying
> to merge I/Os -- rightfully so under "normal" circumstances. However,
> if one were to know that the incoming I/O stream was /very/ random in
> nature, the cycles are wasted.
> 
> This patch adds a per-request_queue tunable that (when set) disables
> merge attempts (beyond the simple one-hit cache check), thus freeing up
> a non-trivial amount of CPU cycles.

Thanks Alan, applied. Made one little change (since I had to hand apply
the patch anyway):


> +static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
> +{
> +	int nm = test_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
> +	return queue_var_show(nm, page);
> +}

static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
{
	return queue_var_show(blk_queue_nomerges(q), page);
}

-- 
Jens Axboe

