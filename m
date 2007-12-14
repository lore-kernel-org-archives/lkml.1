Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbXLNSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbXLNSah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXLNSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:30:20 -0500
Received: from rtr.ca ([76.10.145.34]:3501 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXLNSaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:30:15 -0500
Message-ID: <4762CBB6.5030301@rtr.ca>
Date: Fri, 14 Dec 2007 13:30:14 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       lkml@rtr.ca, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] fix page_alloc for larger I/O segments (improved)
References: <1197584106.3154.55.camel@localhost.localdomain> <20071213142935.47ff19d9.akpm@linux-foundation.org> <4761B32A.3070201@rtr.ca> <4761BCB4.1060601@rtr.ca> <4761C8E4.2010900@rtr.ca> <4761CE88.9070406@rtr.ca> <20071213163726.3bb601fa.akpm@linux-foundation.org> <4761D160.7060603@rtr.ca> <4761D279.6050500@rtr.ca> <20071214174236.GA28613@csn.ul.ie> <20071214181339.GW26334@parisc-linux.org>
In-Reply-To: <20071214181339.GW26334@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Dec 14, 2007 at 05:42:37PM +0000, Mel Gorman wrote:
>> Regrettably this interferes with anti-fragmentation because the "next" page
>> on the list on return from rmqueue_bulk is not guaranteed to be of the right
>> mobility type. I fixed it as an additional patch but it adds additional cost
>> that should not be necessary and it's visible in microbenchmark results on
>> at least one machine.
> 
> Is this patch to be preferred to the one Andrew Morton posted to do
> list_for_each_entry_reverse?
..

This patch replaces my earlier patch that Andrew has:

-               list_add(&page->lru, list);
+               list_add_tail(&page->lru, list);

Which, in turn, replaced the even-earlier list_for_each_entry_reverse patch.

-ml
