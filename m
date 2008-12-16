Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYLPB2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYLPB2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYLPB2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:28:22 -0500
Received: from gw.goop.org ([64.81.55.164]:53932 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYLPB2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:28:21 -0500
Message-ID: <49470433.4050504@goop.org>
Date: Mon, 15 Dec 2008 17:28:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200707241052.13825.nickpiggin@yahoo.com.au> <4941C568.4070207@goop.org> <200707241140.12945.nickpiggin@yahoo.com.au>
In-Reply-To: <200707241140.12945.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 12 December 2008 12:59, Jeremy Fitzhardinge wrote:
>   
>> Nick Piggin wrote:
>>     
>>> Hi,
>>>
>>> On Friday 12 December 2008 06:05, Jeremy Fitzhardinge wrote:
>>>       
>>>> Hi Nick,
>>>>
>>>> In Xen when we're killing the lazy vmalloc aliases, we're only concerned
>>>> about the pagetable references to the mapped pages, not the TLB entries.
>>>>         
>>> Hm? Why is that? Why wouldn't it matter if some page table page gets
>>> written to via a stale TLB?
>>>       
>> No.  Well, yes, it would, but Xen itself will do whatever tlb flushes
>> are necessary to keep it safe (it must, since it doesn't trust guest
>> kernels).  It's fairly clever about working out which cpus need flushing
>> and if other flushes have already done the job.
>>     
>
> OK. Yeah, then the problem is simply that the guest may reuse that virtual
> memory for another vmap.
>   

Hm.  What you would you think of a "deferred tlb flush" flag (or 
something) to cause the next vmap to do the tlb flushes, in the case the 
vunmap happens in a context where the flushes can't be done?

    J
