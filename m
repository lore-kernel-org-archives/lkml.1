Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0BKOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:09:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0BKOJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:09:25 -0500
Message-ID: <4B740F7A.5020702@redhat.com>
Date: Thu, 11 Feb 2010 09:08:58 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com> <4B7383D5.2080904@redhat.com> <alpine.DEB.2.00.1002102359460.22152@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002102359460.22152@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 04:19 AM, David Rientjes wrote:
> On Wed, 10 Feb 2010, Rik van Riel wrote:
>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1914,6 +1914,9 @@ rebalance:
>>>    	 * running out of options and have to consider going OOM
>>>    	 */
>>>    	if (!did_some_progress) {
>>> +		/* The oom killer won't necessarily free lowmem */
>>> +		if (high_zoneidx<   ZONE_NORMAL)
>>> +			goto nopage;
>>>    		if ((gfp_mask&   __GFP_FS)&&   !(gfp_mask&   __GFP_NORETRY)) {
>>>    			if (oom_killer_disabled)
>>>    				goto nopage;
>>
>> Are there architectures that only have one memory zone?
>>
>
> It actually ends up not to matter because of how gfp_zone() is implemented
> (and you can do it with mem= on architectures with larger ZONE_DMA zones
> such as ia64).  ZONE_NORMAL is always guaranteed to be defined regardless
> of architecture or configuration because it's the default zone for memory
> allocation unless specified by a bit in GFP_ZONEMASK, it doesn't matter
> whether it actually has memory or not.  high_zoneidx in this case is just
> gfp_zone(gfp_flags) which always defaults to ZONE_NORMAL when one of the
> GFP_ZONEMASK bits is not set.  Thus, the only way to for the conditional
> in this patch to be true is when __GFP_DMA, or __GFP_DMA32 for x86_64, is
> passed to the page allocator and CONFIG_ZONE_DMA or CONFIG_ZONE_DMA32 is
> enabled, respectively.

Fair enough.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
