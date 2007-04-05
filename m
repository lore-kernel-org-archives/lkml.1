Return-Path: <linux-kernel-owner+w=401wt.eu-S1767344AbXDEVkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767344AbXDEVkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767349AbXDEVkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:40:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767344AbXDEVkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:40:09 -0400
Message-ID: <46156CA9.3060105@redhat.com>
Date: Thu, 05 Apr 2007 17:39:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<461357C4.4010403@yahoo.com.au>	<46154226.6080300@redhat.com> <20070405140723.8477e314.akpm@linux-foundation.org>
In-Reply-To: <20070405140723.8477e314.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS

> I wonder which way you're using, and whether using the other way changes
> things.

I'm using the default Fedora config file, which has
NR_CPUS defined to 64 and CONFIG_SPLIT_PTLOCK_CPUS
to 4, so I am using the split locks.

However, I suspect that each 512kB malloced area
will share one page table lock with 4 others, so
some contention is to be expected.

>> For more real world workloads, like the MySQL sysbench one,
>> I still suspect that your patch would improve things.
>>
>> Time to move back to debugging other stuff, though.
>>
>> Andrew, it would be nice if our patches could cook in -mm
>> for a while.  Want me to change anything before submitting?
> 
> umm.  I took a quick squint at a patch from you this morning and it looked
> OK to me.  Please send the finalish thing when it is fully baked and
> performance-tested in the various regions of operation, thanks.

Will do.

Ulrich has a test version of glibc available that
uses MADV_DONTNEED for free(3), that should test
this thing nicely.

I'll run some tests with that when I get the
time, hopefully next week.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
