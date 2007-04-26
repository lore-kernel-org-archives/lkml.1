Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXDZIzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXDZIzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbXDZIzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:55:13 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:38308 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933721AbXDZIzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:55:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S/wkldAiYCnZalSq+S5nZZktnNJ4NMFjCCnK9rtJ9g2l6qGt7NdHeZXXXe9EoAwwg0vlhX6331/ntQ6IlGRrzDbARRG1tAADxN811X+ti4NzPN3OxSTZywk/nmFfH0rTVNPpKDmCV982/Ls/I4g/eh6LnH1BaeAJB767zjtnzmE=  ;
X-YMail-OSG: LzuifukVM1kUXsRSR7y0nvgT5hpq7lSrlq6C.lZ6zL.71BFu9.oxmut38gYHLL.j7stn7qV8Jw--
Message-ID: <463068E5.6000402@yahoo.com.au>
Date: Thu, 26 Apr 2007 18:55:01 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426084012.GA26926@skynet.ie>
In-Reply-To: <20070426084012.GA26926@skynet.ie>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (26/04/07 16:50), Nick Piggin didst pronounce:

>>Fragmentation is the problem. The anti-frag patches don't actually
>>guarantee anything about fragmentation, and even if they did, then
> 
> 
> The grouping pages by mobility do not guarantee anything but the memory
> partition (kernelcore= boot parameter) does give hard guarantees about
> the amount of memory that is "movable". Of course, the partition requires
> configuration at boot-time so it's less than ideal but it does give hard
> guarantees.

For the hugepages people, I can understand that's a solution. But that's
the last thing you want to do on a system with a limited amount of memory,
or a regular Joe's desktop/server.


> Indeed but then you have to deal with internal fragmentation 
> for pages-larger-than-TLB-page. I'm not saying it's wrong but it does
> come with it's own set of issues.

None of them is perfect (the ways to increase the size of pagecache pages,
that is).

I think in the long term, TLB page sizes will probably increase a little
bit... but if a given page size is "good enough" for a CPU, they really
should be good enough for other hardware. I mean, come on, the CPU's TLB
has to have a good hit ratio and handle several lookups per cycle with a
3-cycle latency on 3GHz+ hardware... surely a an IO controller's
scatter-gather engine or IOMMU that has to do a few lookups per disk IO
is nowhere near so critical as a CPU's datapath: just add a few more
entries to it, they've already got hundreds of megs of cache, so that
isn't an issue either.

-- 
SUSE Labs, Novell Inc.
