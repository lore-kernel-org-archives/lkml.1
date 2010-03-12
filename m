Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0CLMPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 07:15:22 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:33061 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0CLMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:15:21 -0500
Message-ID: <4B9A3049.7010602@linux.vnet.ibm.com>
Date: Fri, 12 Mar 2010 13:15:05 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <20100311154124.e1e23900.akpm@linux-foundation.org> <4B99E19E.6070301@linux.vnet.ibm.com> <20100312020526.d424f2a8.akpm@linux-foundation.org> <20100312104712.GB18274@csn.ul.ie>
In-Reply-To: <20100312104712.GB18274@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Fri, Mar 12, 2010 at 02:05:26AM -0500, Andrew Morton wrote:
>> On Fri, 12 Mar 2010 07:39:26 +0100 Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> wrote:
>>
>>>
>>> Andrew Morton wrote:
>>>> On Mon,  8 Mar 2010 11:48:20 +0000
>>>> Mel Gorman <mel@csn.ul.ie> wrote:
[...]

>> If not, we broke it again.
>>
> 
> We were broken with respect to this in the first place. That
> cond_reched() is badly placed and waiting on congestion when congestion
> might not be involved is also a bit odd.
> 
> It's possible that Christian's specific problem would also be addressed
> by the following patch. Christian, willing to test?

Will is here, but no chance before monday/tuesday to get a free machine 
slot - I'll post results as soon as I get them.

> It still feels a bit unnatural though that the page allocator waits on
> congestion when what it really cares about is watermarks. Even if this
> patch works for Christian, I think it still has merit so will kick it a
> few more times.

In whatever way I can look at it watermark_wait should be supperior to 
congestion_wait. Because as Mel points out waiting for watermarks is 
what is semantically correct there.

If there eventually some day comes a solution without any of those waits 
I'm fine too - e.g. by closing whatever races we have and fixing that 
one context can never run into this in direct_reclaim:
1. free pages with try_to_free
2. not getting one in the subsequent get_page call

But as long as we have a wait - watermark waiting > congestion waiting 
(IMHO).

> ==== CUT HERE ====
> page-allocator: Attempt page allocation immediately after direct reclaim
[...]
-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
