Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYGZR7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYGZR7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYGZR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:59:33 -0400
Received: from saeurebad.de ([85.214.36.134]:34579 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYGZR7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:59:33 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080726173832.GE9301@cs181140183.pp.htv.fi>
Date: Sat, 26 Jul 2008 19:59:08 +0200
In-Reply-To: <20080726173832.GE9301@cs181140183.pp.htv.fi> (Adrian Bunk's
	message of "Sat, 26 Jul 2008 20:38:32 +0300")
Message-ID: <87tzecy1ar.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adrian Bunk <bunk@kernel.org> writes:

> On Sat, Jul 26, 2008 at 07:18:05PM +0200, Haavard Skinnemoen wrote:
>> This fixes the following compile error on avr32, introduced by
>> commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c
>> (exec: remove some includes):
>> 
>> In file included from include/asm/tlb.h:24,
>>                  from fs/exec.c:55:
>> include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
>> include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
>> include/asm-generic/tlb.h: In function 'tlb_remove_page':
>> include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
>> make[1]: *** [fs/exec.o] Error 1
>> 
>> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
>> ---
>>  include/asm-generic/tlb.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>> 
>> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> index f490e43..f85f3a2 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -13,6 +13,7 @@
>>  #ifndef _ASM_GENERIC__TLB_H
>>  #define _ASM_GENERIC__TLB_H
>>  
>> +#include <linux/pagemap.h>
>>  #include <linux/swap.h>
>>  #include <asm/pgalloc.h>
>>  #include <asm/tlbflush.h>
>
> The patch is not the correct fix since the actual problem comes from 
> free_pages_and_swap_cache() in swap.h
>
> Patch is below, but it has not yet gotten enough testing that I'm 100% 
> confident it doesn't break anything else...

There is a comment about sparc and linux/pagemap.h in linux/swap.h.
Adrian, do you cross-compile for sparc?  If this issue is fixed, the
comment should probably go away and your patch is fine.

Otherwise, declaring page_cache_release() and release_pages() just above
these macros is perhaps the safer approach?

I agree that asm-generic/tlb.h should not include linux/swap.h.

	Hannes
