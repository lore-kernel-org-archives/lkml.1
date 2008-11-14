Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbYKNFXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbYKNFXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYKNFW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:22:58 -0500
Received: from gw.goop.org ([64.81.55.164]:46550 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYKNFW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:22:58 -0500
Message-ID: <491D0B2F.7050900@goop.org>
Date: Thu, 13 Nov 2008 21:22:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
References: <491C61B1.10005@goop.org> <200811141319.56713.nickpiggin@yahoo.com.au> <491CE8C6.4060000@goop.org> <200811141417.35724.nickpiggin@yahoo.com.au>
In-Reply-To: <200811141417.35724.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 14 November 2008 13:56, Jeremy Fitzhardinge wrote:
>   
>> Nick Piggin wrote:
>>     
>>> This isn't performance critical to anyone?
>>>       
>> The only difference should be between having the specialized code and an
>> indirect function call, no?
>>     
>
> Indirect function call per pte. It's going to be slower surely.
>   

Yes, though changing the calling convention to handle (up to) a whole 
page worth of ptes in one call would be fairly simple I think.

> It is accepted practice to (carefully) duplicate the page table walking
> functions in memory management code. I don't think that's a problem,
> there is already so many instances of them (just be sure to stick to
> exactly the same form and variable names, and any update or bugfix to
> any of them is trivially applicable to all).
>   

I think that's pretty awful practice, frankly, and I'd much prefer there 
to be a single iterator function which everyone uses.  The open-coded 
iterators everywhere just makes it completely impractical to even think 
about other kinds of pagetable structures.  (Of course we have at least 
two "general purpose" pagetable walkers now...)

    J
