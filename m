Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbZCQDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbZCQDbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZCQDbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:31:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZCQDbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:31:12 -0400
Message-ID: <49BF193F.2090706@kernel.org>
Date: Mon, 16 Mar 2009 20:30:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: {PATCH] x86: print out initial max_pfn_mapped
References: <49BF0978.40605@kernel.org> <49BF0CA1.3010304@zytor.com>
In-Reply-To: <49BF0CA1.3010304@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> Impact: more debug info
>>
>> check range that is mapped before init_memory_mapping().
>> also make 64bit have max_pfn_mapped assigned before that calling
>>
>> Index: linux-2.6/arch/x86/mm/init.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init.c
>> +++ linux-2.6/arch/x86/mm/init.c
>> @@ -65,12 +65,11 @@ static void __init find_early_table_spac
>>  	 */
>>  #ifdef CONFIG_X86_32
>>  	start = 0x7000;
>> -	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
>> -					tables, PAGE_SIZE);
>> -#else /* CONFIG_X86_64 */
>> +#else
>>  	start = 0x8000;
>> -	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
>>  #endif
>> +	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
>> +					tables, PAGE_SIZE);
>>  	if (e820_table_start == -1UL)
>>  		panic("Cannot find space for the kernel page tables");
>>  
> 
> This doesn't seem to match anything anywhere in the description.
> Furthermore, why do we even have a different starting address for
> different architectures?  If anything, this starting address is way too
> low (hogging ZONE_DMA and all that...)
> 


>> also make 64bit have max_pfn_mapped assigned before that calling

so find_e820_area() could use max_pfn_mapped for 64 bit too.

for 64bit, you could use start from 16M for searching free range for left page table. right now
for 32bit, you may need to increase initial max_pfn_mapped to 32M (?) so could start searching from 16M.
need some code for head_32.S
anyway that will be another patch.

YH
