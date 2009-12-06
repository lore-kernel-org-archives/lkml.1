Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZLFIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZLFIdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZLFIdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:33:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40927 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZLFIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:33:03 -0500
Message-ID: <4B1B6C3C.7060503@cs.helsinki.fi>
Date: Sun, 06 Dec 2009 10:33:00 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slab, kmemleak, minor, stop calling kmemleak_erase()
 unconditionally
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>	<1259740550-10394-2-git-send-email-hooanon05@yahoo.co.jp> <tnxr5rd4s6m.fsf@pc1117.cambridge.arm.com>
In-Reply-To: <tnxr5rd4s6m.fsf@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
>> When the gotten object is NULL (probably due to ENOMEM),
>> kmemleak_erase() is unnecessary here, It just sets NULL to where already
>> is NULL.
>> Add a condition.
>>
>> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
>> ---
>>  mm/slab.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 7dfa481..4e61449 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3109,7 +3109,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>>  	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
>>  	 * treat the array pointers as a reference to the object.
>>  	 */
>> -	kmemleak_erase(&ac->entry[ac->avail]);
>> +	if (objp)
>> +		kmemleak_erase(&ac->entry[ac->avail]);
>>  	return objp;
>>  }
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Applied, thanks!
