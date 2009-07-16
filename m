Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZGPIUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZGPIUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZGPIUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:20:17 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:2152
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752760AbZGPIUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:20:15 -0400
Message-ID: <4A5EE2BD.8030100@panasas.com>
Date: Thu, 16 Jul 2009 11:20:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org> <4A5EDD81.6060409@panasas.com> <4A5EDF90.7090900@kernel.org>
In-Reply-To: <4A5EDF90.7090900@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 08:20:15.0585 (UTC) FILETIME=[3F4D0D10:01CA05EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 11:06 AM, Tejun Heo wrote:
> Boaz Harrosh wrote:
>> On 07/16/2009 09:44 AM, Tejun Heo wrote:
>>> Commit ab0fd1debe730ec9998678a0c53caefbd121ed10 tries to prevent merge
>>> of requests with different failfast settings.  In elv_rq_merge_ok(),
>>> it compares new bio's failfast flags against the merge target
>>> request's.  However, the flag testing accessors for bio and blk don't
>>> return boolean but the tested bit value directly and FAILFAST on bio
>>> and blk don't match, so directly comparing them with == results in
>>> false negative unnecessary preventing merge of readahead requests.
>>>
>>> This patch convert the results to boolean by negating them before
>>> comparison.
>> I don't like that at all. Please fix the accessors to return
>> boolean. They look and regarded as boolean. I've never seen
>> them used as their bit value.
> 
> Yeah, I'll be happier that way but please note that this patch is only
> for 2.6.31.  2.6.32 won't have this code at all and we're past the
> merge window, so the smallest fix wins in this case, I think.  Also,
> changing only some of the accessors will increase the level of
> confusion while changing all of them for 2.6.31 at this point is way
> too invasive (there can be cases where the bit mask return value is
> depended upon).
> 

OK So could you put a FIXME: and fat comment, on that weird "!"(s)
everywhere?

> Looks like the flags are gonna go through considerable cleanup pretty
> soon, so let's postpone small things till then.
> 
>> if you are concerned with performance don't
>> an if(flag & bit) is even slightly slower then
>>    if(0 != (flag & bit)) on some processors
> 
> I wasn't worried about the performance at all.
> 
> Thanks.
> 

Thanks
