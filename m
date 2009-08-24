Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZHXTgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZHXTgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZHXTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:36:51 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:36771 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbZHXTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:36:50 -0400
Message-ID: <4A92EBB4.1070101@vflare.org>
Date: Tue, 25 Aug 2009 01:06:20 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
In-Reply-To: <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On 08/24/2009 11:03 PM, Pekka Enberg wrote:

<snip>

> On Mon, Aug 24, 2009 at 7:37 AM, Nitin Gupta<ngupta@vflare.org>  wrote:
>> +/**
>> + * xv_malloc - Allocate block of given size from pool.
>> + * @pool: pool to allocate from
>> + * @size: size of block to allocate
>> + * @pagenum: page no. that holds the object
>> + * @offset: location of object within pagenum
>> + *
>> + * On success,<pagenum, offset>  identifies block allocated
>> + * and 0 is returned. On failure,<pagenum, offset>  is set to
>> + * 0 and -ENOMEM is returned.
>> + *
>> + * Allocation requests with size>  XV_MAX_ALLOC_SIZE will fail.
>> + */
>> +int xv_malloc(struct xv_pool *pool, u32 size, u32 *pagenum, u32 *offset,
>> +                                                       gfp_t flags)

<snip>

>
> What's the purpose of passing PFNs around? There's quite a lot of PFN
> to struct page conversion going on because of it. Wouldn't it make
> more sense to return (and pass) a pointer to struct page instead?


PFNs are 32-bit on all archs while for 'struct page *', we require 32-bit or
64-bit depending on arch. ramzswap allocates a table entry <pagenum, offset>
corresponding to every swap slot. So, the size of table will unnecessarily
increase on 64-bit archs. Same is the argument for xvmalloc free list sizes.

Also, xvmalloc and ramzswap itself does PFN -> 'struct page *' conversion
only when freeing the page or to get a deferencable pointer.

Thanks,
Nitin

