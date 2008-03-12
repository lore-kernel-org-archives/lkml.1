Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYCLDxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYCLDxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYCLDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:53:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYCLDxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:53:24 -0400
Message-ID: <47D753AC.8080206@garzik.org>
Date: Tue, 11 Mar 2008 23:53:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genhd must_check warning fix
References: <20080312001317.D68A526F991@magilla.localdomain> <47D74D0E.8090308@garzik.org> <200803121440.26356.nickpiggin@yahoo.com.au>
In-Reply-To: <200803121440.26356.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 12 March 2008 14:25, Jeff Garzik wrote:
>> Roland McGrath wrote:
>>> Fixes:
>>>
>>> 	block/genhd.c:361: warning: ignoring return value of ‘class_register’,
>>> declared with attribute warn_unused_result
>>>
>>> Signed-off-by: Roland McGrath <roland@redhat.com>
>>> ---
>>>  block/genhd.c |    4 +++-
>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/block/genhd.c b/block/genhd.c
>>> index c44527d..00da521 100644
>>> --- a/block/genhd.c
>>> +++ b/block/genhd.c
>>> @@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t devt, int
>>> *part, void *data)
>>>
>>>  static int __init genhd_device_init(void)
>>>  {
>>> -	class_register(&block_class);
>>> +	int error = class_register(&block_class);
>>> +	if (unlikely(error))
>>> +		return error;
>>>  	bdev_map = kobj_map_init(base_probe, &block_class_lock);
>>>  	blk_dev_init();
>> ACK
>>
>> I was silly and simply tuned out this warning, assuming [wrongly] that
>> it was difficult to fix like the fs/partitions.c warning.
>>
>> Shows how "helpful" those warnings are...
> 
> I don't see why? If the warning wasn't there, then Roland probably
> wouldn't have noticed. So to me it shows that the warning actually
> is helpful (without "") in this case.

The point was more that the warnings are so often silly that it teaches 
the human to tune out the warnings -- even when they turn out to reveal 
real problems, as in this case.

I've been working quietly, the past several kernels, trying to kill most 
compiler warnings, so I've been paying close attention to this sort of 
stuff in general.

	Jeff




