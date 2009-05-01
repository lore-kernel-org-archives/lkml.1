Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZEALwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZEALwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZEALv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:51:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:54573 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbZEALv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:51:58 -0400
Message-ID: <49FAE12F.4020005@cosmosbay.com>
Date: Fri, 01 May 2009 13:46:55 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: alloc_large_system_hash check order
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils> <20090430132544.GB21997@csn.ul.ie> <Pine.LNX.4.64.0905011202530.8513@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0905011202530.8513@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 01 May 2009 13:47:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins a écrit :
> On Thu, 30 Apr 2009, Mel Gorman wrote:
>> On Wed, Apr 29, 2009 at 10:09:48PM +0100, Hugh Dickins wrote:
>>> On an x86_64 with 4GB ram, tcp_init()'s call to alloc_large_system_hash(),
>>> to allocate tcp_hashinfo.ehash, is now triggering an mmotm WARN_ON_ONCE on
>>> order >= MAX_ORDER - it's hoping for order 11.  alloc_large_system_hash()
>>> had better make its own check on the order.

Well, I dont know why, since alloc_large_system_hash() already take
care of retries, halving size between each tries.

>>>
>>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>> Looks good
>>
>> Reviewed-by: Mel Gorman <mel@csn.ul.ie>
> 
> Thanks.
> 
>> As I was looking there, it seemed that alloc_large_system_hash() should be
>> using alloc_pages_exact() instead of having its own "give back the spare
>> pages at the end of the buffer" logic. If alloc_pages_exact() was used, then
>> the check for an order >= MAX_ORDER can be pushed down to alloc_pages_exact()
>> where it may catch other unwary callers.
>>
>> How about adding the following patch on top of yours?
> 
> Well observed, yes indeed.  In fact, it even looks as if, shock horror,
> alloc_pages_exact() was _plagiarized_ from alloc_large_system_hash().
> Blessed be the GPL, I'm sure we can skip the lengthy lawsuits!

As a matter of fact, I was planning to call my lawyer, so I'll reconsider
this and save some euros, thanks !

;)

It makes sense to use a helper function if it already exist, of course !

