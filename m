Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZKVN3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZKVN3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 08:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZKVN3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 08:29:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZKVN3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 08:29:34 -0500
Date: Sun, 22 Nov 2009 14:29:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-ID: <20091122132915.GA3046@elte.hu>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
 <20091120163751.731781e8.akpm@linux-foundation.org>
 <20091121170437.0839daef.isloginov@gmail.com>
 <20091121095429.1378828c.akpm@linux-foundation.org>
 <20091122021128.db47e202.isloginov@gmail.com>
 <20091121152633.8c79e341.akpm@linux-foundation.org>
 <20091122124631.908a32c4.isloginov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122124631.908a32c4.isloginov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ilya Loginov <isloginov@gmail.com> wrote:

> What do you think about this version of patch?
> Is it good enought?
> 
> Signed-off-by: Ilya Loginov <isloginov@gmail.com>
> ---
>  arch/alpha/include/asm/cacheflush.h         |    1 +
>  arch/arm/include/asm/cacheflush.h           |    1 +
>  arch/avr32/include/asm/cacheflush.h         |    1 +
>  arch/blackfin/include/asm/cacheflush.h      |    2 ++
>  arch/cris/include/asm/cacheflush.h          |    1 +
>  arch/frv/include/asm/cacheflush.h           |    1 +
>  arch/h8300/include/asm/cacheflush.h         |    1 +
>  arch/ia64/include/asm/cacheflush.h          |    1 +
>  arch/m32r/include/asm/cacheflush.h          |    3 +++
>  arch/m68k/include/asm/cacheflush_mm.h       |    1 +
>  arch/m68k/include/asm/cacheflush_no.h       |    1 +
>  arch/microblaze/include/asm/cacheflush.h    |    1 +
>  arch/mips/include/asm/cacheflush.h          |    1 +
>  arch/mn10300/include/asm/cacheflush.h       |    1 +
>  arch/parisc/include/asm/cacheflush.h        |    1 +
>  arch/powerpc/include/asm/cacheflush.h       |    1 +
>  arch/s390/include/asm/cacheflush.h          |    1 +
>  arch/sh/include/asm/cacheflush.h            |    1 +
>  arch/sh/include/cpu-common/cpu/cacheflush.h |    1 +
>  arch/sh/include/cpu-sh2a/cpu/cacheflush.h   |    1 +
>  arch/sh/include/cpu-sh3/cpu/cacheflush.h    |    1 +
>  arch/sh/include/cpu-sh4/cpu/cacheflush.h    |    1 +
>  arch/sh/include/cpu-sh5/cpu/cacheflush.h    |    1 +
>  arch/sparc/include/asm/cacheflush_32.h      |    1 +
>  arch/sparc/include/asm/cacheflush_64.h      |    1 +
>  arch/x86/include/asm/cacheflush.h           |    1 +
>  arch/xtensa/include/asm/cacheflush.h        |    2 ++
>  drivers/mtd/mtd_blkdevs.c                   |    2 ++
>  include/linux/bio.h                         |   19 +++++++++++++++++++
>  include/linux/blkdev.h                      |   18 ++++++++++++++++++
>  30 files changed, 70 insertions(+)

patch looks mangled in the middle:

> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -12,6 +12,7 @@ static inline void flush_cache_range(struct
> vm_area_struct *vma, unsigned long start, unsigned long end) { }
>  static inline void flush_cache_page(struct vm_area_struct *vma,
>  				    unsigned long vmaddr, unsigned
> long pfn) { } +#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
>  static inline void flush_dcache_page(struct page *page) { }
>  static inline void flush_dcache_mmap_lock(struct address_space
> *mapping) { } static inline void flush_dcache_mmap_unlock(struct
> address_space *mapping) { } diff --git

	Ingo
