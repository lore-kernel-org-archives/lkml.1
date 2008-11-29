Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYK2QYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYK2QYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYK2QYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:24:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYK2QYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:24:43 -0500
Message-ID: <49316CAF.2010006@redhat.com>
Date: Sat, 29 Nov 2008 11:24:15 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max
 pages
References: <20081128140405.3D0B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <492FCFF6.1050808@redhat.com> <20081129164624.8134.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081129164624.8134.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> The result talk about three things.
> 
>   - rvr and mine patch increase direct reclaim imbalancing, indeed.
>   - However, background reclaim scanning is _very_ much than direct reclaim.
>     Then, direct reclaim imbalancing is ignorable on the big view.
>     rvr patch doesn't reintroduce zone imbalancing issue.
>   - rvr's priority==DEF_PRIORITY condition checking doesn't improve
>     zone balancing at all.
>     we can drop it.
> 
> Again, I believe my patch improve vm scanning totally.
> 
> Any comments?

Reclaiming is very easy when the workload is just page cache,
because the application will be throttled when too many page
cache pages are dirty.

When using mmap or memory hogs writing to swap, applications
will not be throttled by the "too many dirty pages" logic,
but may instead end up being throttled in the direct reclaim
path instead.

At that point direct reclaim may become a lot more common,
making the imbalance more significant.

I'll run a few tests.

> Andrew, I hope add this mesurement result to rvr bailing out patch description too.

So far the performance numbers you have measured are very
encouraging and do indeed suggest that the priority==DEF_PRIORITY
thing does not make a difference.

-- 
All rights reversed.
