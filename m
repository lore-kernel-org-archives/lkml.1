Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZFJCQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZFJCQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 22:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZFJCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 22:15:54 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47724 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFJCPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 22:15:53 -0400
Message-ID: <4A2F1741.8090100@ct.jp.nec.com>
Date: Wed, 10 Jun 2009 11:15:29 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Boaz Harrosh <bharrosh@panasas.com>, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk>
In-Reply-To: <20090609180344.GQ11363@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
>> Hi Jens,
>>
>> +/*
>> + * Copy request information of the original request to the clone request.
>> + */
>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>> +{
>> +	dst->cpu = src->cpu;
>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
>> +	dst->cmd_type = src->cmd_type;
>> +	dst->__sector = blk_rq_pos(src);
>> +	dst->__data_len = blk_rq_bytes(src);
>> +	dst->nr_phys_segments = src->nr_phys_segments;
>> +	dst->ioprio = src->ioprio;
>> +	dst->buffer = src->buffer;
>> +	dst->cmd_len = src->cmd_len;
>> +	dst->cmd = src->cmd;
> 
> Are you making sure that 'src' always exists while 'dst' is alive?

Yes.
Request-based dm is the owner of 'src' (original) and
it never frees 'src' until the 'dst' (clone) are completed.

I avoided deep-copying __cmd/buffer/sense as it's costly
(additional allocation and memcpy).
And I don't think there are any needs for that.
But if anyone really wants that even with the copying cost,
please speak up.

Thanks,
Kiyoshi Ueda
