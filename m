Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645Ab0A2PrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0A2PrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161Ab0A2PrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:47:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41598 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0A2PrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:47:07 -0500
Date: Fri, 29 Jan 2010 15:46:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Mark Lord <kernel@teksavvy.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
Message-ID: <20100129154653.GJ7139@csn.ul.ie>
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl> <4B61964F.6060307@teksavvy.com> <4B619C6D.9030205@teksavvy.com> <20100128142437.GA7139@csn.ul.ie> <4B62E904.9020401@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B62E904.9020401@teksavvy.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:56:20AM -0500, Mark Lord wrote:
> Mel Gorman wrote:
>> On Thu, Jan 28, 2010 at 09:17:17AM -0500, Mark Lord wrote:
> ..
>>> Rather than wasting time trying to bisect a full major kernel revision,
>>> I think instead I'll just focus on mm/page_alloc.c.
> ..
>> Well, it might not eve be necessary. In the patch I sent you, it pointed
>> the finger at commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61 being the
>> problem in that case. I believe your problem is a variation of the
>> slowdown-in-swapping problem except in your case it manifests as
>> GFP_ATOMIC allocations failing.
>>
>> If the fix does not help you, then I'll take a fresh look at the other
>> commits with your particular problem in mind.
> ..
>
> Last night, I installed 2.6.32.7, plus the patch you sent.
> So far, no allocation faults.
>

Nice one.

> I'll leave it running for another day or so, and then perhaps revert
> the one patch to see which of the two things (new kernel, or patch)
> is responsible for the difference.
>

Thanks, I'd appreciate it. While I'm reasonably confident the problem is
with MIGRATE_RESERVE not being free as intended and that the patch fixes
it, I'd like more proof.

> The changelog for 2.6.32.7 included something to fix default rsize/wsize
> values on NFS.  Dunno if this might have had an effect or not,
> but when it was failing.. NFS (order 1) was the most frequent case.
>

I consider it unlikely that a change in NFS is responsible. The network
MTU would remain the same and it's a bigger factor in the size of
allocations made. I think it's just a co-incidence that NFS reported the
most failures simply because it was responsible for the bulk of network
traffic.

Hugh, can I get a signed-off-by on that patch please? I can improve the
changelog if you like and send it to Andrew for merging if you like.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
