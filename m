Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZHPDyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZHPDyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 23:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZHPDyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 23:54:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZHPDyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 23:54:03 -0400
Message-ID: <4A87829C.4090908@redhat.com>
Date: Sat, 15 Aug 2009 23:53:00 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Jeff Dike <jdike@addtoit.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <20090806210955.GA14201@c2.user-mode-linux.org> <20090816031827.GA6888@localhost>
In-Reply-To: <20090816031827.GA6888@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
>> Side question -
>> 	Is there a good reason for this to be in shrink_active_list()
>> as opposed to __isolate_lru_page?
>>
>> 		if (unlikely(!page_evictable(page, NULL))) {
>> 			putback_lru_page(page);
>> 			continue;
>> 		}
>>
>> Maybe we want to minimize the amount of code under the lru lock or
>> avoid duplicate logic in the isolate_page functions.
> 
> I guess the quick test means to avoid the expensive page_referenced()
> call that follows it. But that should be mostly one shot cost - the
> unevictable pages are unlikely to cycle in active/inactive list again
> and again.

Please read what putback_lru_page does.

It moves the page onto the unevictable list, so that
it will not end up in this scan again.

>> But if there are important mlock-heavy workloads, this could make the
>> scan come up empty, or at least emptier than we might like.
> 
> Yes, if the above 'if' block is removed, the inactive lists might get
> more expensive to reclaim.

Why?

-- 
All rights reversed.
