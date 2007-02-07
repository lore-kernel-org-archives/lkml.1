Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXBGBPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXBGBPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030518AbXBGBPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:15:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030510AbXBGBPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:15:30 -0500
Date: Tue, 6 Feb 2007 17:15:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: "Kai" <epimetreus@fastmail.fm>, stable@suse.de, org@suse.de,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at
 mm/filemap.c:537!
Message-Id: <20070206171509.f92e0ed2.akpm@linux-foundation.org>
In-Reply-To: <17865.3776.511594.763544@notabene.brown>
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
	<17865.3776.511594.763544@notabene.brown>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 10:26:56 +1100
Neil Brown <neilb@suse.de> wrote:

> +static int bio_fits_rdev(struct bio *bi)
> +{
> +	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
> +
> +	if ((bi->bi_size>>9) > q->max_sectors)
> +		return 0;
> +	blk_recount_segments(q, bi);
> +	if (bi->bi_phys_segments > q->max_phys_segments ||
> +	    bi->bi_hw_segments > q->max_hw_segments)
> +		return 0;
> +
> +	if (q->merge_bvec_fn)
> +		/* it's too hard to apply the merge_bvec_fn at this stage,
> +		 * just just give up
> +		 */
> +		return 0;
> +
> +	return 1;
> +}

Isn't think going to return 0 rather a lot of the time?

