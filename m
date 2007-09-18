Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbXIROmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbXIROmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbXIROm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:42:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbXIROm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:42:28 -0400
Message-ID: <46EFE3AE.9040909@redhat.com>
Date: Tue, 18 Sep 2007 10:41:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Anton Altaparmakov <aia21@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <200709170828.01098.nickpiggin@yahoo.com.au> <46EEB3AC.20205@redhat.com> <200709180312.31937.nickpiggin@yahoo.com.au>
In-Reply-To: <200709180312.31937.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 18 September 2007 03:04, Rik van Riel wrote:
>> Nick Piggin wrote:
>>> (Rik has a patch sitting in -mm I believe which would make this problem
>>> even worse, by doing even less highmem scanning in response to lowmem
>>> allocations).
>> My patch should not make any difference here, since
>> balance_pgdat() already scans the zones from high to
>> low and sets an end_zone variable that determines the
>> highest zone to scan.
>>
>> All my patch does is make sure that we do not try to
>> reclaim excessive amounts of dma or low memory when
>> a higher zone is full.
> 
> Sorry, yeah I had it the wrong way around. Your patch would not
> increase the probability of this problem.
> 
> We could have some logic in there to scan highmem when buffer
> heads are over limit. But that really kind of sucks in that it introduces
> some arbitrary point where reclaim behaviour completely changes...
> Adding a shrinker for buffer heads is the "logical" approach 

Christoph Lameter's slab defragmenting patch set does
this.  One reason Andrew has not merged that code yet
is a lack of reviewers, so I am going through it with
a fine comb and hope to have the patches reviewed by
the end of today.

Lets get this bug fixed the right way.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
