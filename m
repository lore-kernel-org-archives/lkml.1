Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbXIFWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbXIFWr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbXIFWrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:47:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbXIFWru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:47:50 -0400
Message-ID: <46E08382.9020503@redhat.com>
Date: Thu, 06 Sep 2007 18:47:30 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       safari-kernel@safari.iki.fi
Subject: Re: [PATCH] prevent kswapd from freeing excessive amounts of lowmem
References: <46DF3545.4050604@redhat.com>	<20070905182305.e5d08acf.akpm@linux-foundation.org>	<46E02CF5.3020301@redhat.com> <20070906153426.a173f8e2.akpm@linux-foundation.org>
In-Reply-To: <20070906153426.a173f8e2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Thu, 06 Sep 2007 12:38:13 -0400 Rik van Riel <riel@redhat.com> wrote:
>> Andrew Morton wrote:
> 
> (What happened to the other stuff I said?)

Mlock can cause the problem too.  As for all_unreclaimable,
it is ignored when priority == DEF_PRIORITY, balance_pgdat
always seems to start in this stage.

>>> I guess for a very small upper zone and a very large lower zone this could
>>> still put the scan balancing out of whack, fixable by a smarter version of
>>> "8*zone->pages_high" but it doesn't seem very likely that this will affect
>>> things much.
>>>
>>> Why doesn't direct reclaim need similar treatment?
>> Because we only go into the direct reclaim path once
>> every zone is at or below zone->pages_low, and the
>> direct reclaim path will exit once we have freed more
>> than swap_cluster_max pages.
>>
> 
> hm.  Now I need to remember why direct-reclaim does that :(

This is done so the system does not end up with the first
process that goes into page reclaim staying there forever,
while the other processes in the system happily consume
the pages freed by that poor first process.

There may be other reasons, too.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
