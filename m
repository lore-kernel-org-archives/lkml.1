Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZGURzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZGURzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZGURzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:55:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZGURzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:55:52 -0400
Message-ID: <4A660101.3000307@redhat.com>
Date: Tue, 21 Jul 2009 13:55:13 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       hugh.dickins@tiscali.co.uk, chrisw@redhat.com, avi@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <1247851850-4298-7-git-send-email-ieidus@redhat.com> <20090721175139.GE2239@random.random>
In-Reply-To: <20090721175139.GE2239@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:

>> +static inline void page_add_ksm_rmap(struct page *page)
>> +{
>> +	if (atomic_inc_and_test(&page->_mapcount)) {
>> +		page->mapping = (void *) PAGE_MAPPING_ANON;
>> +		__inc_zone_page_state(page, NR_ANON_PAGES);
>> +	}
>> +}
> 
> Is it correct to account them as anon pages?

Yes, but ...

>> -	if (PageAnon(old_page)) {
>> +	if (PageAnon(old_page) && !PageKsm(old_page)) {
>>  		if (!trylock_page(old_page)) {
>>  			page_cache_get(old_page);
>>  			pte_unmap_unlock(page_table, ptl);
> 
> What exactly does it buy to have PageAnon return 1 on ksm pages,
> besides requiring the above additional check (that if we stick to the
> above code, I would find safer to move inside reuse_swap_page).

I guess that if they are to remain unswappable, they
should go onto the unevictable list.

Then again, I'm guessing this is all about to change
in not too much time :)

-- 
All rights reversed.
