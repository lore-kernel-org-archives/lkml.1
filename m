Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYKMUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYKMUM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYKMUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:12:20 -0500
Received: from gw.goop.org ([64.81.55.164]:44578 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYKMUMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:12:19 -0500
Message-ID: <491C8A20.1070107@goop.org>
Date: Thu, 13 Nov 2008 12:12:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
References: <491C61B1.10005@goop.org> <20081113195341.GA8299@cmpxchg.org>
In-Reply-To: <20081113195341.GA8299@cmpxchg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
>> -	do {
>> -		BUG_ON(!pte_none(*pte));
>>     
>
> Dropping by intention?
>   

Hm, I couldn't really see the point.   But I didn't really want to 
introduce any functional changes with this patch, so I'll add it back.

>> 	BUG_ON(addr >= end);
>> -	pfn -= addr >> PAGE_SHIFT;
>> -	pgd = pgd_offset(mm, addr);
>> -	flush_cache_range(vma, addr, end);
>>     
>
> Was the flushing redundant?  I can't spot it reappearing anywhere.

I guess its needed for virtually indexed cache architectures; I'll add 
it back.

Thanks for reviewing.

    J
