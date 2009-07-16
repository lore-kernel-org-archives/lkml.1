Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZGPIHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZGPIHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZGPIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:07:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:50349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZGPIHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:07:49 -0400
Message-ID: <4A5EDF90.7090900@kernel.org>
Date: Thu, 16 Jul 2009 17:06:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org> <4A5EDD81.6060409@panasas.com>
In-Reply-To: <4A5EDD81.6060409@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Jul 2009 08:06:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 07/16/2009 09:44 AM, Tejun Heo wrote:
>> Commit ab0fd1debe730ec9998678a0c53caefbd121ed10 tries to prevent merge
>> of requests with different failfast settings.  In elv_rq_merge_ok(),
>> it compares new bio's failfast flags against the merge target
>> request's.  However, the flag testing accessors for bio and blk don't
>> return boolean but the tested bit value directly and FAILFAST on bio
>> and blk don't match, so directly comparing them with == results in
>> false negative unnecessary preventing merge of readahead requests.
>>
>> This patch convert the results to boolean by negating them before
>> comparison.
> 
> I don't like that at all. Please fix the accessors to return
> boolean. They look and regarded as boolean. I've never seen
> them used as their bit value.

Yeah, I'll be happier that way but please note that this patch is only
for 2.6.31.  2.6.32 won't have this code at all and we're past the
merge window, so the smallest fix wins in this case, I think.  Also,
changing only some of the accessors will increase the level of
confusion while changing all of them for 2.6.31 at this point is way
too invasive (there can be cases where the bit mask return value is
depended upon).

Looks like the flags are gonna go through considerable cleanup pretty
soon, so let's postpone small things till then.

> if you are concerned with performance don't
> an if(flag & bit) is even slightly slower then
>    if(0 != (flag & bit)) on some processors

I wasn't worried about the performance at all.

Thanks.

-- 
tejun
