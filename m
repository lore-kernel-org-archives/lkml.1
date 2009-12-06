Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZLFIdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZLFIdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZLFIdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:33:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40927 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZLFIdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:33:11 -0500
Message-ID: <4B1B6C45.1040809@cs.helsinki.fi>
Date: Sun, 06 Dec 2009 10:33:09 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slab, kmemleak, bugfix, pass the correct pointer
 to kmemleak_erase()
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>	<1259740550-10394-3-git-send-email-hooanon05@yahoo.co.jp> <tnxmy214s5k.fsf@pc1117.cambridge.arm.com>
In-Reply-To: <tnxmy214s5k.fsf@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
>> In ____cache_alloc(), the variable 'ac' may be changed after
>> cache_alloc_refill() and the following kmemleak_erase() may get an
>> incorrect pointer.
>> Update 'ac' after cache_alloc_refill() unconditionally.
>> cf. http://marc.info/?l=linux-kernel&m=125873373124187&w=2
>>     and its thread.
>>
>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>
>> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
>> ---
>>  mm/slab.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 4e61449..66e9047 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3103,6 +3103,11 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>>  	} else {
>>  		STATS_INC_ALLOCMISS(cachep);
>>  		objp = cache_alloc_refill(cachep, flags);
>> +		/*
>> +		 * the 'ac' may be updated by cache_alloc_refill(),
>> +		 * and kmemleak_erase() requires its correct value.
>> +		 */
>> +		ac = cpu_cache_get(cachep);
>>  	}
>>  	/*
>>  	 * To avoid a false negative, if an object that is in one of the
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Thanks.

Applied, thanks!
