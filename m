Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZIRO7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZIRO7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZIRO7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:59:12 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56788 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZIRO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:59:11 -0400
Message-ID: <4AB39A88.3040106@ce.jp.nec.com>
Date: Fri, 18 Sep 2009 23:34:48 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
References: <4AB2E57B.2090101@ce.jp.nec.com> <4AB32148.3010004@cn.fujitsu.com>
In-Reply-To: <4AB32148.3010004@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Jun'ichi Nomura wrote:
>> Since 2.6.31 now has request-based device-mapper, it's useful to have
>> a tracepoint for request-remapping as well as bio-remapping.
>>
>> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().
> 
>> Existing trace_block_remap() is left unchanged but it might be better to
>> rename it to trace_block_bio_remap().
> 
> Why not. ;)

OK, I'll add a renaming patch.

>> +static void blk_add_trace_rq_remap(struct request_queue *q,
>> +				   struct request *rq, dev_t dev,
>> +				   sector_t from)
>> +{
>> +	struct blk_trace *bt = q->blk_trace;
>> +	struct blk_io_trace_remap r;
>> +
>> +	if (likely(!bt))
>> +		return;
>> +
>> +	r.device_from = cpu_to_be32(dev);
>> +	r.device_to   = disk_devt(rq->rq_disk);
> 
> cpu_to_be32(dis_devt(...))

Thank you! I'll fix that.

>> +	r.sector_from = cpu_to_be64(from);
>> +
>> +	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
>> +			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
>> +			sizeof(r), &r);
>> +}

-- 
Jun'ichi Nomura, NEC Corporation
