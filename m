Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbXLNAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbXLNAmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762001AbXLNAmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:42:11 -0500
Received: from rtr.ca ([76.10.145.34]:2250 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbXLNAmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:42:09 -0500
Message-ID: <4761D160.7060603@rtr.ca>
Date: Thu, 13 Dec 2007 19:42:08 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, lkml@rtr.ca,
       matthew@wil.cx, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
References: <20071213185326.GQ26334@parisc-linux.org>	<4761821F.3050602@rtr.ca>	<20071213192633.GD10104@kernel.dk>	<4761883A.7050908@rtr.ca>	<476188C4.9030802@rtr.ca>	<20071213193937.GG10104@kernel.dk>	<47618B0B.8020203@rtr.ca>	<20071213195350.GH10104@kernel.dk>	<20071213200219.GI10104@kernel.dk>	<476190BE.9010405@rtr.ca>	<20071213200958.GK10104@kernel.dk>	<20071213140207.111f94e2.akpm@linux-foundation.org>	<1197584106.3154.55.camel@localhost.localdomain>	<20071213142935.47ff19d9.akpm@linux-foundation.org>	<4761B32A.3070201@rtr.ca>	<4761BCB4.1060601@rtr.ca>	<4761C8E4.2010900@rtr.ca>	<4761CE88.9070406@rtr.ca> <20071213163726.3bb601fa.akpm@linux-foundation.org>
In-Reply-To: <20071213163726.3bb601fa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 13 Dec 2007 19:30:00 -0500
> Mark Lord <liml@rtr.ca> wrote:
> 
>> Here's the commit that causes the regression:
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -760,7 +760,8 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>>  		struct page *page = __rmqueue(zone, order, migratetype);
>>  		if (unlikely(page == NULL))
>>  			break;
>> -		list_add_tail(&page->lru, list);
>> +		list_add(&page->lru, list);
> 
> well that looks fishy.
..

Yeah.  I missed that, and instead just posted a patch
to search the list in reverse order, which seems to work for me.

I'll try just reversing that line above here now.. gimme 5 minutes or so.

Cheers
