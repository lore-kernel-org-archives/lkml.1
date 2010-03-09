Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0CIP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:56:21 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:39784 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0CIP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:56:18 -0500
Message-ID: <4B966F93.9060207@linux.vnet.ibm.com>
Date: Tue, 09 Mar 2010 16:56:03 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-allocator: Under memory pressure, wait on pressure
 to relieve instead of congestion
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <1268048904-19397-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003090946180.28897@router.home>
In-Reply-To: <alpine.DEB.2.00.1003090946180.28897@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> On Mon, 8 Mar 2010, Mel Gorman wrote:
> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 30fe668..72465c1 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -398,6 +398,9 @@ struct zone {
>>  	unsigned long		wait_table_hash_nr_entries;
>>  	unsigned long		wait_table_bits;
>>
>> +	/* queue for processes waiting for pressure to relieve */
>> +	wait_queue_head_t	*pressure_wq;
>> +
>>  	/*
> 
> The waitqueue is in a zone? But allocation occurs by scanning a
> list of possible zones.
> 
>> +long zonepressure_wait(struct zone *zone, unsigned int order, long timeout)
> 
> So zone specific.
> 
>> -		if (!page && gfp_mask & __GFP_NOFAIL)
>> -			congestion_wait(BLK_RW_ASYNC, HZ/50);
>> +		if (!page && gfp_mask & __GFP_NOFAIL) {
>> +			/* If still failing, wait for pressure on zone to relieve */
>> +			zonepressure_wait(preferred_zone, order, HZ/50);
> 
> The first zone is special therefore...
> 
> What happens if memory becomes available in another zone? Lets say we are
> waiting on HIGHMEM and memory in ZONE_NORMAL becomes available?

Do you mean the same as Nick asked or another aspect of it?
citation:
"I mean the other way around. If that zone's watermarks are not met, 
then why shouldn't it be woken up by other zones reaching their watermarks."


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
