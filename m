Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZC2LXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZC2LXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZC2LXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:23:42 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:42155 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZC2LXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p5R7MLoqxsAYYXDZbEPa5Tc8Pl2QQ9+UZEeI/pLwPpRLWDyQ5ViKG9y1iyvzYkRKVZ
         hrw5b28Ofc2f16kVGoh7vpLBU0nKeYCh1yqwtb1XNDjsN3uEDtzuEBKGCJr6Zvw1+H0u
         ZyUo2LGCEhiaAbcswTtaWBpF1vPEvzFjUgwl8=
Message-ID: <49CF5A2A.1010305@vflare.org>
Date: Sun, 29 Mar 2009 16:53:22 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xvmalloc memory allocator
References: <49CEEE5A.4080004@vflare.org> <49CEEF30.9060202@vflare.org> <49CF4FFA.8090904@gmail.com>
In-Reply-To: <49CF4FFA.8090904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> Nitin Gupta wrote:
>> +static void stat_inc(u64 *value)
>> +{
>> +    (*value)++;
>> +}
>> +
>> +static void stat_dec(u64 *value)
>> +{
>> +    (*value)--;
>> +}
> 
> Why not open code it?
>


This looks nicer, doesn't it?


>> +
>> +static u32 test_flag(struct block_header *block, enum blockflags flag)
>> +{
>> +    return block->prev & (1 << flag);
>> +}
>> +
>> +static void set_flag(struct block_header *block, enum blockflags flag)
>> +{
>> +    block->prev |= (1 << flag);
>> +}
>> +
>> +static void clear_flag(struct block_header *block, enum blockflags flag)
>> +{
>> +    block->prev &= ~(1 << flag);
>> +}
> 
> Why don't you use test_bit / __set_bit / __clear_bit directly?
> 

block->prev is 16 bits. __set_bit() etc. need unsigned long pointer.

>> +struct xv_pool *xv_create_pool(void)
>> +{
>> +    int i;
>> +    u32 ovhd_size;
>> +    struct xv_pool *pool;
>> +
>> +    ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
>> +    pool = kmalloc(ovhd_size, GFP_KERNEL);
>> +    if (!pool)
>> +        return NULL;
>> +
>> +    memset(pool, 0, ovhd_size);
> 
> Please use kzalloc.
> 

Ok...

>> +
>> +    for (i = 0; i < NUM_FREE_LISTS; i++) {
>> +        pool->freelist[i].pagenum = 0;
>> +        pool->freelist[i].offset = 0;
>> +    }
> 
> It was already zeroed by memset.
> 
Remains from earlier code; we used to set it to 'INVALID_PGNUM'.
Ok, will remove this.


Thanks for review.
Nitin
