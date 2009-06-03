Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZFCOxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZFCOxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZFCOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:53:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZFCOxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:53:42 -0400
Message-ID: <4A268DF8.6000701@redhat.com>
Date: Wed, 03 Jun 2009 10:51:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][v2] swap: virtual swap readahead
References: <20090602223738.GA15475@cmpxchg.org> <20090602233457.GY1065@one.firstfloor.org> <20090603132751.GA1813@cmpxchg.org>
In-Reply-To: <20090603132751.GA1813@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Wed, Jun 03, 2009 at 01:34:57AM +0200, Andi Kleen wrote:
>> On Wed, Jun 03, 2009 at 12:37:39AM +0200, Johannes Weiner wrote:

>>> +		pgd = pgd_offset(vma->vm_mm, pos);
>>> +		if (!pgd_present(*pgd))
>>> +			continue;
>>> +		pud = pud_offset(pgd, pos);
>>> +		if (!pud_present(*pud))
>>> +			continue;
>>> +		pmd = pmd_offset(pud, pos);
>>> +		if (!pmd_present(*pmd))
>>> +			continue;
>>> +		pte = pte_offset_map_lock(vma->vm_mm, pmd, pos, &ptl);
>> You could be more efficient here by using the standard mm/* nested loop
>> pattern that avoids relookup of everything in each iteration. I suppose
>> it would mainly make a difference with 32bit highpte where mapping a pte
>> can be somewhat costly. And you would take less locks this way.
> 
> I ran into weird problems here.  The above version is actually faster
> in the benchmarks than writing a nested level walker or using
> walk_page_range().  Still digging but it can take some time.  Busy
> week :(

I'm not too worried about not walking the page tables,
because swap is an extreme slow path anyway.

-- 
All rights reversed.
