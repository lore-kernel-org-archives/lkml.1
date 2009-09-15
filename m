Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZIOTTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZIOTTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZIOTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:19:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39663 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395AbZIOTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:19:31 -0400
Date: Tue, 15 Sep 2009 21:19:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O (v2)
Message-ID: <20090915191934.GP23126@kernel.dk>
References: <200909151902.26609.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909151902.26609.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Corrado Zoccolo wrote:
> [This applies on top of  git://git.kernel.dk/linux-2.6-block.git for-2.6.32]
>
> When the number of processes performing I/O concurrently increases,
> a fixed time slice per process will cause large latencies.
> 
> This (v2) patch will scale the time slice assigned to each process,
> according to a target latency (tunable from sysfs, default 300ms).

OK, I'm ready to take this patch in for some testing. But please run it
through checkpatch, you have reeeally long lines. And shorten some of
your variable names while at it.

> @@ -1092,7 +1130,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  	 * fair distribution of slice time for a process doing back-to-back
>  	 * seeks. so allow a little bit of time for him to submit a new rq
>  	 */
> -	sl = cfqd->cfq_slice_idle;
> +	sl = min(cfqd->cfq_slice_idle, (unsigned)(cfqq->slice_end - jiffies));

min_t() ?

-- 
Jens Axboe

