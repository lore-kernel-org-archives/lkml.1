Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZGACOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZGACOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZGACOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:14:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbZGACOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:14:22 -0400
Message-ID: <4A4AC636.4010307@redhat.com>
Date: Tue, 30 Jun 2009 22:13:10 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wu Fengguang <fengguang.wu@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
References: <1246291007.663.630.camel@macbook.infradead.org> <20090630140512.GA16923@localhost> <20090701094446.85C8.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090701094446.85C8.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> if my guess is correct, we need to implement #-of-reclaim-process throttling
> mechanism.

There are probably some other things that want throttling,
too.

For example, the number of pages currently under IO can
be as large as the entire file and anon inactive lists,
which can cause page reclaim to fail because none of the
pages are reclaimable yet.

This is probably not a big issue for the page cache,
since the readahead window will collapse before we hit
this problem.

However, we may want to take measures to ensure that
the total number of pages in swap readahead do not
take up the entire inactive anon list - maybe we should
limit it to half that amount, to stay on the safe side?

I'll whip up a patch for this tomorrow.

That should get rid of the OOMs that have been observed
with the swap readahead patches by Johannes.

-- 
All rights reversed.
