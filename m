Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZHXVQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZHXVQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZHXVQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:16:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:33332 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZHXVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:16:34 -0400
Message-ID: <4A930313.9070404@vflare.org>
Date: Tue, 25 Aug 2009 02:46:03 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com> <4A92EBB4.1070101@vflare.org> <Pine.LNX.4.64.0908242132320.8144@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908242132320.8144@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 02:09 AM, Hugh Dickins wrote:
> On Tue, 25 Aug 2009, Nitin Gupta wrote:
>> On 08/24/2009 11:03 PM, Pekka Enberg wrote:
>>>
>>> What's the purpose of passing PFNs around? There's quite a lot of PFN
>>> to struct page conversion going on because of it. Wouldn't it make
>>> more sense to return (and pass) a pointer to struct page instead?
>>
>> PFNs are 32-bit on all archs
>
> Are you sure?  If it happens to be so for all machines built today,
> I think it can easily change tomorrow.  We consistently use unsigned long
> for pfn (there, now I've said that, I bet you'll find somewhere we don't!)
>
> x86_64 says MAX_PHYSMEM_BITS 46 and ia64 says MAX_PHYSMEM_BITS 50 and
> mm/sparse.c says
> unsigned long max_sparsemem_pfn = 1UL<<  (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>

For PFN to exceed 32-bit we need to have physical memory > 16TB (2^32 * 4KB).
So, maybe I can simply add a check in ramzswap module load to make sure that
RAM is indeed < 16TB and then safely use 32-bit for PFN?

Thanks,
Nitin
