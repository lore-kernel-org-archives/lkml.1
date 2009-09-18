Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZIRF6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZIRF6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZIRF6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:58:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZIRF6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:58:42 -0400
Message-ID: <4AB32148.3010004@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 13:57:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
References: <4AB2E57B.2090101@ce.jp.nec.com>
In-Reply-To: <4AB2E57B.2090101@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jun'ichi Nomura wrote:
> Since 2.6.31 now has request-based device-mapper, it's useful to have
> a tracepoint for request-remapping as well as bio-remapping.
> 
> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().

> Existing trace_block_remap() is left unchanged but it might be better to
> rename it to trace_block_bio_remap().

Why not. ;)

> +static void blk_add_trace_rq_remap(struct request_queue *q,
> +				   struct request *rq, dev_t dev,
> +				   sector_t from)
> +{
> +	struct blk_trace *bt = q->blk_trace;
> +	struct blk_io_trace_remap r;
> +
> +	if (likely(!bt))
> +		return;
> +
> +	r.device_from = cpu_to_be32(dev);
> +	r.device_to   = disk_devt(rq->rq_disk);

cpu_to_be32(dis_devt(...))

> +	r.sector_from = cpu_to_be64(from);
> +
> +	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
> +			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
> +			sizeof(r), &r);
> +}
