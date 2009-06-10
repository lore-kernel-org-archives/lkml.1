Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZFJHzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZFJHzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZFJHzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:55:31 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:5869
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752638AbZFJHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:55:30 -0400
Message-ID: <4A2F66ED.80206@panasas.com>
Date: Wed, 10 Jun 2009 10:55:25 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk> <4A2F1741.8090100@ct.jp.nec.com>
In-Reply-To: <4A2F1741.8090100@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2009 07:55:28.0448 (UTC) FILETIME=[D206F400:01C9E9A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2009 05:15 AM, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
>> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
>>> Hi Jens,
>>>
>>> +/*
>>> + * Copy request information of the original request to the clone request.
>>> + */
>>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>>> +{
>>> +	dst->cpu = src->cpu;
>>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
>>> +	dst->cmd_type = src->cmd_type;
>>> +	dst->__sector = blk_rq_pos(src);
>>> +	dst->__data_len = blk_rq_bytes(src);
>>> +	dst->nr_phys_segments = src->nr_phys_segments;
>>> +	dst->ioprio = src->ioprio;
>>> +	dst->buffer = src->buffer;
>>> +	dst->cmd_len = src->cmd_len;
>>> +	dst->cmd = src->cmd;
>> Are you making sure that 'src' always exists while 'dst' is alive?
> 
> Yes.
> Request-based dm is the owner of 'src' (original) and
> it never frees 'src' until the 'dst' (clone) are completed.
> 
> I avoided deep-copying __cmd/buffer/sense as it's costly
> (additional allocation and memcpy).

For my needs for example dst->cmd will be different then
src->cmd. Could be untouched. The caller will set what he
needs.

dst->sense should be untouched, caller can set to src->sense
if he wants to. Or like me he already have another buffer.

dst->buffer is always NULL in my path so I don't know
what that is. Tejun?

It should only be about bios and lengths.

And a big fat comment about what it does and what it
does not.

> And I don't think there are any needs for that.
> But if anyone really wants that even with the copying cost,
> please speak up.
> 
> Thanks,
> Kiyoshi Ueda

Thanks
Boaz
