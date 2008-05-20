Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYETCcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYETCcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYETCcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:32:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:46928 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYETCcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hleap/mokvAVPXhGaZUGKECSzPvjuW9shX3ThcIoKTZ9atRwIMTzmdxLtlNBVCqRIg7koLboC2WkgeacVGPS0CLbkumRS8AvuhLUSYcMUFhB5BZAMU01EzLs0pKHHoc2nAPbtOPDQT7UepxHyrDXOKtSCZeZSgf9rpEq1KGHAHY=
Message-ID: <44c63dc40805191932t6a386cb7r389b6e5d3d3bf095@mail.gmail.com>
Date: Tue, 20 May 2008 11:32:19 +0900
From: "MinChan Kim" <barrioskmc@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] Fix to return wrong pointer in slob
Cc: "MinChan Kim" <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <1211218837.18026.116.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48317CA8.1080700@gmail.com> <1211218837.18026.116.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 2:40 AM, Matt Mackall <mpm@selenic.com> wrote:
>
> On Mon, 2008-05-19 at 22:12 +0900, MinChan Kim wrote:
>> Although slob_alloc return NULL, __kmalloc_node returns NULL + align.
>> Because align always can be changed, it is very hard for debugging
>> problem of no page if it don't return NULL.
>>
>> We have to return NULL in case of no page.
>>
>> Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/slob.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/slob.c b/mm/slob.c
>> index 6038cba..258d76d 100644
>> --- a/mm/slob.c
>> +++ b/mm/slob.c
>> @@ -469,9 +469,12 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
>>                       return ZERO_SIZE_PTR;
>>
>>               m = slob_alloc(size + align, gfp, align, node);
>> -             if (m)
>> -                     *m = size;
>> -             return (void *)m + align;
>> +             if (!m)
>> +                     return NULL;
>> +             else {
>> +                     *m = size;
>> +                     return (void *)m + align;
>> +             }
>
> This looks good, but I would remove the 'else {' and '}' here. It's nice
> to have the 'normal path' minimally indented.

I agree
Thanks, Matt :)


-- 
Thanks,
MinChan Kim
