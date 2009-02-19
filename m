Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbZBSMwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbZBSMwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZBSMvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:51:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:3995 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZBSMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:51:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xjB59xoO8WB6mJH2QKTsR444/al8GFqnl9ex4ouHv+CzU6UjBSoQg2/P+rP3GdhWqr
         BauhU1p6nWR4OwzD5V9NzJJUY9hov0EACiMUNYxbLSqZw2UXkmjtQB1PEzYmSejZ7qEi
         Z6OtsLDNxeVPetoBhzJDQxawejhoUeUTE6jyg=
MIME-Version: 1.0
In-Reply-To: <1235034967.29813.10.camel@penberg-laptop>
References: <20090218093858.8990.A69D9226@jp.fujitsu.com>
	 <1234944569.24030.20.camel@penberg-laptop>
	 <20090219085229.954A.A69D9226@jp.fujitsu.com>
	 <1235034967.29813.10.camel@penberg-laptop>
Date: Thu, 19 Feb 2009 21:51:48 +0900
X-Google-Sender-Auth: b84ce56d53cd63cb
Message-ID: <2f11576a0902190451w294aa2fan29b61fa3619f459b@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/19 Pekka Enberg <penberg@cs.helsinki.fi>:
> On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
>> > > In addition, if pekka patch (SLAB_LIMIT = 8K) run on ia64, 16K allocation
>> > > always fallback to page allocator and using 64K (4 times memory consumption!).
>> >
>> > Yes, correct, but SLUB does that already by passing all allocations over
>> > 4K to the page allocator.
>>
>> hmhm
>> OK. my mail was pointless.
>>
>> but why? In my understanding, slab framework mainly exist for efficient
>> sub-page allocation.
>> the fallbacking of 4K allocation in 64K page-sized architecture seems
>> inefficient.
>
> I don't think any of the slab allocators are known for memory
> efficiency. That said, the original patch description sums up the
> rationale for page allocator pass-through:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=aadb4bc4a1f9108c1d0fbd121827c936c2ed4217
>
> Interesting enough, there seems to be some performance gain from it as
> well as seen by Mel Gorman's recent slab allocator benchmarks.

Honestly, I'm bit confusing.
above url's patch use PAGE_SIZE, but not 4K nor architecture independent value.
Your 4K mean PAGE_SIZE?
