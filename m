Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZELNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZELNWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZELNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:22:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZELNWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:22:04 -0400
Message-ID: <4A09778B.5030809@redhat.com>
Date: Tue, 12 May 2009 09:20:11 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first	class
 citizen
References: <20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025058.GA7518@localhost>
In-Reply-To: <20090512025058.GA7518@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

>> Also, the change makes this comment:
>>
>> 	spin_lock_irq(&zone->lru_lock);
>> 	/*
>> 	 * Count referenced pages from currently used mappings as
>> 	 * rotated, even though they are moved to the inactive list.
>> 	 * This helps balance scan pressure between file and anonymous
>> 	 * pages in get_scan_ratio.
>> 	 */
>> 	reclaim_stat->recent_rotated[!!file] += pgmoved;
>>
>> inaccurate.
> 
> Good catch, I'll just remove the stale "even though they are moved to
> the inactive list".

Well, it is still true for !VM_EXEC pages.

-- 
All rights reversed.
