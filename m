Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXHUVOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXHUVOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHUVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:14:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXHUVOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:14:36 -0400
Message-ID: <46CB55A8.4030501@redhat.com>
Date: Tue, 21 Aug 2007 17:14:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
References: <20070820215040.937296148@sgi.com> <46CB01B7.3050201@redhat.com> <Pine.LNX.4.64.0708211355430.3082@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708211355430.3082@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 21 Aug 2007, Rik van Riel wrote:
> 
>> Christoph Lameter wrote:
>>
>>> 1. First reclaiming non dirty pages. Dirty pages are deferred until reclaim
>>>    has reestablished the high marks. Then all the dirty pages (the laundry)
>>>    is written out.
>> That sounds like a horrendously bad idea.  While one process
>> is busy freeing all the non dirty pages, other processes can
>> allocate those pages, leaving you with no memory to free up
>> the dirty pages!
> 
> What is preventing that from occurring right now? If the dirty pags are 
> aligned in the right way you can have the exact same situation.

For one, dirty page writeout is done even when free memory
is low.  The kernel will dig into the PF_MEMALLOC reserves,
instead of deciding not to do writeout unless there is lots
of free memory.

Secondly, why would you want to recreate this worst case on
purpose every time the pageout code runs?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
