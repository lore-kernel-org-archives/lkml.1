Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXDZHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXDZHm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDZHm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:42:27 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:20081 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933228AbXDZHmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:42:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=wjyHZApvQnGT2b0OXLEgJroWAP5wbhgELFS73WYKx825cktvjauy8U7b+B8bfEOGS7xMp/BQvALHcDxk2j5QUvFTVYGj9peIf33UKRxaIcs9bHvJD6ocaszCd37agJOwwbn0MkW5B+Ulrm68WLj/2TVz4nrIiBAgu/8QAcKOVFg=  ;
X-YMail-OSG: ZwAqdz0VM1ml9P.Fwe83ua0I8r3WvxVVRAfi9qbiYr4sTS6QgIRlMFka._8MUs5b1mSzGo4o3g--
Message-ID: <463057D9.9030804@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:42:17 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>mapping through the radix tree. You just need to change the way the
>>>filesystem looks up pages.
>>
>>You didn't think any of the criticisms of higher order page cache size
>>were valid?
> 
> 
> They are all known points that have been discussed to death.

I missed the part where you showed that it was a better solution than
the alternatives.


>>>What are the exact requirement you are trying to address?
>>
>>Block size > page cache size.
> 
> 
> But what do you mean with it? A block is no longer a contiguous section of 
> memory. So you have redefined the term.

I don't understand what you mean at all. A block has always been a
contiguous area of disk.


>>You guys have a couple of problems, firstly you need to have ia64
>>filesystems accessable to x86_64. And secondly you have these controllers
>>without enough sg entries for nice sized IOs.
> 
> 
> This is not sgi specific sorry.
> 
> 
>>I sympathise, and higher order pagecache might solve these in a way, but
>>I don't think it is the right way to go, mainly because of the fragmentation
>>issues.
> 
> 
> And you dont care about Mel's work on that level?

I actually don't like it too much because it can't provide a robust
solution. What do you do on systems with small memories, or those that
eventually do get fragmented?

Actually, I don't know why people are so excited about being able to
use higher order allocations (I would rather be more excited about
never having to use them). But for those few places that really need
it, I'd rather see them use a virtually mapped kernel with proper
defragmentation rather than putting hacks all through the core code.


>>Increasing PAGE_SIZE, support for block size > page cache size, and getting
>>io controllers matched to a 4K page size IMO would be some good ways to
>>solve these problems. I know they are probably harder...
> 
> 
> No this has been tried before and does not work. Why should we loose the 
> capability to work with 4k pages just because there is some data that 
> has to be thrown around in quantity? I'd like to have flexibility here.

Is that a big problem? Really? You use 16K pages on your IPF systems,
don't you?


> The fragmentation problem is solvable and we already have a solution in 
> mm. So I do not really see a problem there?

I don't think that it is solved, and I think the heuristics that are
there would be put under more stress if they become widely used. And
it isn't only about whether we can get the page or not, but also about
the cost. Look up Linus's arguments about page colouring, which are
similar and  I also think are pretty valid.

-- 
SUSE Labs, Novell Inc.
