Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZD3GsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZD3GsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZD3Grz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:47:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZD3Gry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:47:54 -0400
Date: Thu, 30 Apr 2009 08:47:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: swap arg name "from" and "to" of
	blk_add_trace_remap
Message-ID: <20090430064734.GE9559@elte.hu>
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430133627.D217.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Subject: [PATCH] blktrace: swap arg name "from" and "to" of blk_add_trace_remap
> 
> Impact: cleanup for improve readability
> 
> Currently, blk_add_trace_remap has following prototype.
> 
> static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> 				       dev_t dev, sector_t from, sector_t to)
> 
> but caller pass "from" secter as 4th arg, "to" sector as 5th arg.
> 
> example,
> --------------------------------------------------------
> static inline void blk_partition_remap(struct bio *bio)
> {
> 	struct block_device *bdev = bio->bi_bdev;
> 
> 	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
> 		struct hd_struct *p = bdev->bd_part;
> 
> 		bio->bi_sector += p->start_sect;
> 		bio->bi_bdev = bdev->bd_contains;
> 
> 		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
> 				    bdev->bd_dev, bio->bi_sector,
> 				    bio->bi_sector - p->start_sect);
> 	}
> }
> --------------------------------------------------------
> 
> Oh my god, it's reverse order.
> Fortunately, print logic reverse again. the twice reversing hide problem.

heh ... well spotted.

> but, but...
> It repeatedly confuse reviewer (include me!).
> Then, swapping argment name is better.

Agreed. Li, Jens, what do you think?

	Ingo
