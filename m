Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbZDBJJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbZDBJJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZDBJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:09:46 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:20727 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751446AbZDBJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:09:46 -0400
Message-ID: <49D4805C.70400@panasas.com>
Date: Thu, 02 Apr 2009 12:07:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 05/17] bio: cleanup rw usage
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-6-git-send-email-tj@kernel.org> <49D47925.5050307@panasas.com> <49D47F3F.7000105@kernel.org>
In-Reply-To: <49D47F3F.7000105@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 09:09:43.0230 (UTC) FILETIME=[C2C7FDE0:01C9B372]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 12:02 PM, Tejun Heo wrote:
> Boaz Harrosh wrote:
>> On 04/01/2009 04:44 PM, Tejun Heo wrote:
>>> Impact: cleanup
>>>
>>> bio confusingly uses @write_to_vm and @reading for data directions,
>>> both of which mean the opposite of the usual block/bio convention of
>>> using READ and WRITE w.r.t. IO devices.  The only place where the
>>> inversion is necessary is when caling get_user_pages_fast() in
>>> bio_copy_user_iov() as the gup uses the VM convention of read/write
>>> w.r.t. VM.
>>>
>>> This patch converts all bio functions to use READ/WRITE rw parameter
>>> and let the one place where inversion is necessary to rw == READ.
>>>
>> Hi one more nit picking just if you are at it. If you want
>> I can do the work and send it to you so you can squash it into this patch.
>> See bellow
>>
>>> +	if (rw == WRITE)
>>> +		bio->bi_rw |= 1 << BIO_RW;
>> can we pleas have an inline that does that? Like bio_set_dir()?
>> and change all users. You will be surprised how many there are.
>>
>> It gives me an hart attack every time I have to write yet another
>> one.
> 
> Things like this are actually what I'm trying to clean up.  If you
> look at the whole series, at the end, there remains only one place
> which sets the flag in the blk/bio map paths and all users of
> blk_rq_map_*() interface couldn't care less about the flag because
> they provide only the necessary information through strictly defined
> API.
> 

Right, I know. and its great.

I'm saying, all these other block-layer places and all
these places above block like stacking drivers and filesystems
That use generic_make_request and friends. If at it these can be
cleaned as well, in regard to this small thingy.

> Thanks.
> 

I'll do it, no problems. Would you push it with your patchset?

Thanks
Boaz
