Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbYEFJ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbYEFJ32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765378AbYEFJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:21:29 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:57783 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765335AbYEFJVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:21:25 -0400
Message-ID: <48202353.9030402@seznam.cz>
Date: Tue, 06 May 2008 11:22:27 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, grant.likely@secretlab.ca
Subject: Re: [microblaze-uclinux] [PATCH 09/56] microblaze_v2: cache support
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu> <20080505173734.AB0E485805C@mail199-va3.bigfish.com>
In-Reply-To: <20080505173734.AB0E485805C@mail199-va3.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

> The microblaze has a write through data cache, hence 'flush' is really a
> misnomer here and interesting methods are 'invalidate'.  In addition,
> most of these functions should be used directly by an implementation of
> dma-coherent.c (which I can't find in your patches).  

I removed consistent.c or dma-coherent.c from files. I don't need this code for
now. Microblaze is currently no DMA arch.
I know we need this to ll_temac work but not now. I added this to my plan after
first pull.

M

> I'll try to cook up a patch for you with this today.
> 
> Steve
> 
>> +#define flush_cache_all()			__flush_cache_all()
>> +#define flush_cache_mm(mm)			do { } while (0)
>> +#define flush_cache_range(vma, start, end)	__flush_cache_all()
>> +#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
>> +
>> +#define flush_dcache_range(start, end)
> __flush_dcache_range(start, end)
>> +#define flush_dcache_page(page)		do { } while (0)
>> +#define flush_dcache_mmap_lock(mapping)		do { } while (0)
>> +#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
>> +
>> +#define flush_icache_range(start, len)
> __flush_icache_range(start, len)
>> +#define flush_icache_page(vma, pg)		do { } while (0)
>> +#define flush_icache_user_range(start, len)	do { } while (0)
>> +
>> +#define flush_cache_vmap(start, end)		do { } while (0)
>> +#define flush_cache_vunmap(start, end)		do { } while (0)
>> +
>> +struct page;
>> +struct mm_struct;
>> +struct vm_area_struct;
>> +
>> +/* see arch/microblaze/kernel/cache.c */
>> +extern void __flush_icache_all(void);
>> +extern void __flush_icache_range(unsigned long start, unsigned long
> end);
>> +extern void __flush_icache_page(struct vm_area_struct *vma, struct
> page *page);
>> +extern void __flush_icache_user_range(struct vm_area_struct *vma,
>> +				struct page *page,
>> +				unsigned long adr, int len);
>> +extern void __flush_cache_sigtramp(unsigned long addr);
>> +
>> +extern void __flush_dcache_all(void);
>> +extern void __flush_dcache_range(unsigned long start, unsigned long
> end);
>> +extern void __flush_dcache_page(struct vm_area_struct *vma, struct
> page *page);
>> +extern void __flush_dcache_user_range(struct vm_area_struct *vma,
>> +				struct page *page,
>> +				unsigned long adr, int len);
>> +
>> +extern inline void __flush_cache_all(void)
>> +{
>> +	__flush_icache_all();
>> +	__flush_dcache_all();
>> +}
>> +
>> +#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
>> +do { memcpy(dst, src, len); \
>> +	flush_icache_user_range(vma, page, vaddr, len); \
>> +} while (0)
>> +#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>> +	memcpy(dst, src, len)
>> +
>> +#endif /* _ASM_MICROBLAZE_CACHEFLUSH_H */
>> --
>> 1.5.4.GIT
>>
>> ___________________________
>> microblaze-uclinux mailing list
>> microblaze-uclinux@itee.uq.edu.au
>> Project Home Page :
> http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
>> Mailing List Archive :
> http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 
> 
> 

