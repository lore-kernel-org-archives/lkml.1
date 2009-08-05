Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbZHERVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbZHERVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934516AbZHERVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:21:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38474 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075AbZHERVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:21:02 -0400
Message-ID: <4A79BF55.5090004@redhat.com>
Date: Wed, 05 Aug 2009 13:20:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random>
In-Reply-To: <20090805155805.GC23385@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Wed, Aug 05, 2009 at 10:40:58AM +0800, Wu Fengguang wrote:
>>  			 */
>> -			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
>> +			if ((vm_flags & VM_EXEC) || PageAnon(page)) {
>>  				list_add(&page->lru, &l_active);
>>  				continue;
>>  			}
>>
> 
> Please nuke the whole check and do an unconditional list_add;
> continue; there.

That would reinstate the bug that the VM has no pages
available for evicting.  There are very good reasons
that only VM_EXEC file pages get moved to the back of
the active list if they were referenced, and nothing
else.

-- 
All rights reversed.
