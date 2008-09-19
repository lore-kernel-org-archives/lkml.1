Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYISAXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYISAXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYISAXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:23:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYISAXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:23:32 -0400
Message-ID: <48D2F05C.4040000@redhat.com>
Date: Thu, 18 Sep 2008 17:20:44 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com> <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com> <48D2D3B2.10503@goop.org> <48D2E65A.6020004@redhat.com> <48D2EBBB.205@goop.org>
In-Reply-To: <48D2EBBB.205@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
>>> bet there's an appropriate pvop hook you could use to force
>>> synchronization just before the kernel actually inspects the bits
>>> (leaving lazy mode sounds good).
>>>   
>>>       
>> It would have to be a new lazy mode, not the existing one, I think.
>>     
>
> The only direct use of pte_young() is in zap_pte_range, within a
> mmu_lazy region.  So syncing the A bit state on entering lazy mmu mode
> would work fine there.
>
>   

Ugh, leaving lazy pte.a mode when entering lazy mmu mode?


> The call via page_referenced_one() doesn't seem to have a very
> convenient hook though.  Perhaps putting something in
> page_check_address() would do the job.
>
>   

Why there?

Why not explicitly in the callers?  We need more than to exit lazy pte.a 
mode, we also need to enter it again later.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

