Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZBRON6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZBRON6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZBRONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:13:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZBRONs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:13:48 -0500
Message-ID: <499C17B8.3030609@redhat.com>
Date: Wed, 18 Feb 2009 14:14:16 +0000
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com> <499C1158.7020401@redhat.com> <20090218135436.GF8751@amd.com> <499C1536.30302@redhat.com> <20090218141017.GG8751@amd.com>
In-Reply-To: <20090218141017.GG8751@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>> sp->spt is allocated using mmu_memory_cache_alloc(), which zeros the page.  How can the assertion fail?
>>     
>
> In the code I see (current kvm-git) mmu_memory_cache_alloc() does zero
> nothing. It takes the page from the preallocated pool and returns it.
> The pool itself is filled with mmu_topup_memory_caches() which calls
> mmu_topup_memory_cache_page() to fill the mmu_page_cache (from which the
> sp->spt page is allocated later). And the mmu_topup_memory_cache_page()
> function calls alloc_page() and does not zero the result. This let the
> assertion trigger.
>   

Right, I was looking at the 2.6.29 tree.  The patch is correct (and the 
others look good as well).  As usual, I'd like Marcelo to take a look as 
well.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

