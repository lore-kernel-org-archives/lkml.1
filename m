Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZIKR7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZIKR7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZIKR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:59:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZIKR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:59:29 -0400
Date: Fri, 11 Sep 2009 13:59:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 1/4] writeback: merely wakeup flusher thread if work
	allocation fails for WB_SYNC_NONE
Message-ID: <20090911175930.GA19598@infradead.org>
References: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com> <1252669832-13553-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252669832-13553-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
> +	 * bdi_queue_work() will wake up the thread and flush old data. This
> +	 * should ensure some amount of progress in freeing memory.
> +	 */
> +	if (wbc->sync_mode != WB_SYNC_ALL) {
> +		struct bdi_work *w = bdi_alloc_work(wbc);
>  
> +		bdi_queue_work(wbc->bdi, w);
> +	} else {
> +		struct bdi_work work;
>  
> +		bdi_work_init(&work, wbc);
> +		work.state |= WS_ONSTACK;
>  
> +		bdi_queue_work(wbc->bdi, &work);
> +		bdi_wait_on_work_clear(&work);

That's even nice than my version, great.

