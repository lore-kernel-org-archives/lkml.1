Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZHKXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZHKXds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZHKXdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:33:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56328 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbZHKXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:33:45 -0400
Date: Wed, 12 Aug 2009 08:31:03 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/6] tracing, page-allocator: Add trace event for page traffic related to the buddy lists
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, Peter Zijlstra <peterz@infradead.org>,
       Li Ming Chun <macli@brc.ubc.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <1249918915-16061-4-git-send-email-mel@csn.ul.ie>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie> <1249918915-16061-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20090811164030.9AE2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The page allocation trace event reports that a page was successfully allocated
> but it does not specify where it came from. When analysing performance,
> it can be important to distinguish between pages coming from the per-cpu
> allocator and pages coming from the buddy lists as the latter requires the
> zone lock to the taken and more data structures to be examined.
> 
> This patch adds a trace event for __rmqueue reporting when a page is being
> allocated from the buddy lists. It distinguishes between being called
> to refill the per-cpu lists or whether it is a high-order allocation.
> Similarly, this patch adds an event to catch when the PCP lists are being
> drained a little and pages are going back to the buddy lists.
> 
> This is trickier to draw conclusions from but high activity on those
> events could explain why there were a large number of cache misses on a
> page-allocator-intensive workload. The coalescing and splitting of buddies
> involves a lot of writing of page metadata and cache line bounces not to
> mention the acquisition of an interrupt-safe lock necessary to enter this
> path.

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



