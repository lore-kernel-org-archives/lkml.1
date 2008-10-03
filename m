Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYJCMje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYJCMje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYJCMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:39:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbYJCMjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:39:14 -0400
Message-ID: <48E6121E.8050100@linux-foundation.org>
Date: Fri, 03 Oct 2008 07:37:50 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for	allocation
 by the reclaimer
References: <20081002143508.GE11089@brain> <48E4F6EC.7010500@linux-foundation.org> <20081003123545.EF5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081003123545.EF5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>> Parallel allocations are less a problem if the freed order 0 pages get merged
>> immediately into the order 1 freelist. Of course that will only work 50% of
>> the time but it will have a similar effect to this patch.
> 
> Ah, Right.
> Could we hear why you like pcp disabling than Andy's patch?

Its simpler code wise.


> Honestly, I think pcp has some problem.

pcps are a particular problem on NUMA because the lists are replicated per
zone and per processor.

> But I avoid to change pcp because I don't understand its design.

In the worst case we see that pcps cause a 5% performance drop (sequential
alloc w/o free followed by sequential free w/o allocs). See my page allocator
tests in my git tree.

> Maybe, we should discuss currect pcp behavior?

pcps need improvement. The performance issues with the page allocator fastpath
are likely due to bloating of the fastpaths (antifrag did not do much good on
that level). Plus current crops of processors are sensitive to cache footprint
issues (seems that the tbench regression in the network stack also are due to
the same effect). Doubly linked lists are not good  today because they touch
multiple cachelines.




