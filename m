Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYEKUSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYEKUSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYEKUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:18:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYEKUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:18:37 -0400
Message-ID: <48275493.40601@firstfloor.org>
Date: Sun, 11 May 2008 22:18:27 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] bootmem2 III
References: <20080509151713.939253437@saeurebad.de>	<20080509184044.GA19109@one.firstfloor.org> <87lk2gtzta.fsf@saeurebad.de>
In-Reply-To: <87lk2gtzta.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

>> On Fri, May 09, 2008 at 05:17:13PM +0200, Johannes Weiner wrote:
>>> here is bootmem2, a memory block-oriented boot time allocator.
>>>
>>> Recent NUMA topologies broke the current bootmem's assumption that
>>> memory nodes provide non-overlapping and contiguous ranges of pages.
>> I'm still not sure that's a really good rationale for bootmem2.
>> e.g. the non continuous nodes are really special cases and there tends
>> to be enough memory at the beginning which is enough for boot time
>> use, so for those systems it would be quite reasonably to only 
>> put the continuous starts of the nodes into bootmem.
> 
> Hm, that would put the logic into arch-code.  I have no strong opinion
> about it.

In fact I suspect the current code will already work like that
implicitely. The aliasing is only a problem for the new "arbitary node
free_bootmem" right?

>> That said the bootmem code has gotten a little crufty and a clean
>> rewrite might be a good idea.
> 
> I agree completely.

The trouble is just that bootmem is used in early boot and early boot is
very subtle and getting it working over all architectures could be a
challenge. Not wanting to discourage you, but it's not exactly the
easiest part of the kernel to hack on.

-Andi
