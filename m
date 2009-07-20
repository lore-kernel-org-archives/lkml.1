Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZGTDHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZGTDHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZGTDHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:07:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54611 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZGTDG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:06:59 -0400
Message-ID: <4A63DF71.2070905@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 11:07:29 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] Remove initialization of page_table in	one_page_table_init()
References: <4A5C488A.90204@cn.fujitsu.com> <20090718141157.GH32618@elte.hu>
In-Reply-To: <20090718141157.GH32618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
>> Only judge if (!page_table) when CONFIG_DEBUG_PAGEALLOC or CONFIG_KMEMCHECK
>> are defined, then we don't need to set init value for page_table.
>>
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> ---
>> arch/x86/mm/init_32.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
>> index 3cd7711..55da09b 100644
>> --- a/arch/x86/mm/init_32.c
>> +++ b/arch/x86/mm/init_32.c
>> @@ -108,13 +108,13 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
>> static pte_t * __init one_page_table_init(pmd_t *pmd)
>> {
>>     if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
>> -        pte_t *page_table = NULL;
>> +        pte_t *page_table;
>>
>>         if (after_bootmem) {
>> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>>             page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
>> -#endif
>>             if (!page_table)
>> +#endif
>>                 page_table =
>>                 (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
> 
> I think the original code was cleaner - putting an #ifdef straight 
> into the middle of a control block is quite fragile.
> 
> 	Ingo
> 

Hello, Ingo

David Rientjes said that:
Nack, gcc will already optimize the branch out for configs without 
CONFIG_DEBUG_PAGEALLOC and CONFIG_KMEMCHECK.  The only thing this change 
does is make the code less readable.

I tested it with gcc -O2, and proved that David is correct.
Initialization of page_table and additional "if (!page_table)" was removed by optimization.
Please ignore this patch.

Thanks
Zhaolei

