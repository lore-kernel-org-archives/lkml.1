Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbZCMWt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbZCMWt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbZCMWtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:49:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbZCMWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:49:50 -0400
Message-ID: <49BAE210.7090300@zytor.com>
Date: Fri, 13 Mar 2009 15:45:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
References: <49B7EDF4.7060904@goop.org> <49B800B8.2040009@kernel.org> <49B9A1CD.5040704@goop.org> <49B9AC7F.9030302@kernel.org> <49BAC1B0.6050107@goop.org>
In-Reply-To: <49BAC1B0.6050107@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>>
>>> INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE +
>>> ALLOCATOR_SLOP)*PAGE_SIZE_asm
>>>     
>>
>> no user for INIT_MAP_BEYOND_END any more.
>>   
> 
> There are several remaining references:
> 
> : abulafia:pts/0; grep INIT_MAP_BEYOND_END arch/x86/kernel/head_32.S 
> INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + 
> ALLOCATOR_SLOP)*PAGE_SIZE_asm
> * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
>      * End condition: we must map up to and including INIT_MAP_BEYOND_END
>     leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
>      * End condition: we must map up to and including INIT_MAP_BEYOND_END
>     leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
> 
> Are you saying they're redundant and should be removed?
> 

Those references are just the actual reservation of memory.  If all the 
users of that memory are converted to either brk or bss, 
INIT_MAP_BEYOND_END should be removed.  If all the users of that memory 
aren't converted to brk to bss, we should do so.

	-hpa
