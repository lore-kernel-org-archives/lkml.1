Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXEUHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXEUHKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbXEUHKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:10:40 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:48086 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754614AbXEUHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:10:39 -0400
Message-ID: <465145BB.7050301@panasas.com>
Date: Mon, 21 May 2007 10:09:47 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] x86-64: update iommu/dma mapping functions to sg
  helpers
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972373765-git-send-email-jens.axboe@oracle.com> <464322BC.50101@panasas.com> <20070521063249.GE14746@kernel.dk>
In-Reply-To: <20070521063249.GE14746@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2007 07:09:49.0109 (UTC) FILETIME=[0506BE50:01C79B77]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 10 2007, Benny Halevy wrote:
>> @@ -411,12 +406,13 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>>  			   boundary and the new one doesn't have an offset. */
>>  			if (!iommu_merge || !nextneed || !need || s->offset ||
>>  			    (ps->offset + ps->length) % PAGE_SIZE) { 
>> -				if (dma_map_cont(sg, start, i, sg+out, pages,
>> -						 need) < 0)
>> +				if (dma_map_cont(start_sg, i - start, sg+out,
>> +						  pages, need) < 0)
>>  					goto error;
>>  				out++;
>>  				pages = 0;
>> -				start = i;	
>> +				start = i;
>> +				start_sg = s;
>>  			}
>>  		}
>>  
>> @@ -424,7 +420,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>>  		pages += to_pages(s->offset, s->length);
>>  		ps = s;
>>  	}
>> -	if (dma_map_cont(sg, start, i, sg+out, pages, need) < 0)
>> +	if (dma_map_cont(start_sg, i - start, sg+out, pages, need) < 0)
>>  		goto error;
>>  	out++;
>>  	flush_gart();
> 
> Your patch is (very) buggy, the whole premise of doing chained sg
> entries makes sg + int illegal!
> 

You're right.  I'll send a fix asap.

Benny

-- 
Benny Halevy
Software Architect
Tel/Fax: +972-3-647-8340
Mobile: +972-54-802-8340
bhalevy@panasas.com
 
Panasas, Inc.
The Leader in Parallel Storage
www.panasas.com
