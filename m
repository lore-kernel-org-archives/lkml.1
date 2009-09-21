Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZIUJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZIUJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZIUJJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:09:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33945 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbZIUJJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:09:17 -0400
Date: Mon, 21 Sep 2009 10:09:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
Message-ID: <20090921090923.GH12726@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie> <4AB74129.90402@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4AB74129.90402@in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 02:32:33PM +0530, Sachin Sant wrote:
> Mel Gorman wrote:
>>> I applied the three patches from Mel and one from Tejun.
>>>     
>>
>> Thanks Sachin
>>
>> Was there any useful result from Tejun's patch applied on its own?
>>   
> Haven't tried with just the patch from Tejun. I will give this a try.
> I might not get a chance to test this until late in the evening my time.
> (Today being a holiday for me )
>

Ok, I've blatently nabbed your machine again then (yoink haha) and
a relevant kernel is building at the moment. I'll put the dmesg when it
becomes available. Go enjoy your holiday

>>> Tejun, the above hang looks exactly the same as the one
>>> i have reported here :
>>>
>>> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-September/075791.html
>>>
>>> This particular hang was bisected to the following patch
>>>
>>> powerpc64: convert to dynamic percpu allocator
>>>
>>> This hang can be recreated without SLQB. So i think this is a different
>>> problem. 
>>>
>>>     
>>
>> Was that bug ever resolved?
>>   
> The bug was still present with git9(78f28b..). With latest git
> git10(ebc79c4 ..)i haven't tested it yet because of perf counter
> build errors.
>

Ok, so right now there are three separate bugs with this machine

1. SLQB + Memoryless shots itself in the face due to suspected
	per-cpu area corruption
2. SLQB with memoryless nodes frees pages remotely and allocates
	locally with a similar effect as if it was a memory leak.
3. pcpu_alloc can hang but is not related to SLQB

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
