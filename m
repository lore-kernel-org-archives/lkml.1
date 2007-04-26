Return-Path: <linux-kernel-owner+w=401wt.eu-S1031232AbXDZOsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031232AbXDZOsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031233AbXDZOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:48:16 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:32585 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031232AbXDZOsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:48:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KYFu3FZ4R9smg108qV5DKqL/ovnU6Ok7MqzE7vAMxj+HqwoKkhsEBeWqt4N1Ug7o7UXAjGRJmyv+rUKB3AXIrMymf7e2+crH0xjkEXGY8tNcAC8m68SqY0F0HjOcahaWNgiVDdd2EkOLs138uls7Aedmu7USsJRdwoYidQ+Rbn8=  ;
X-YMail-OSG: d3qmOY4VM1mGfwF8yKSnjLK6mHWg1XLEBYepBbeGwgCLfyYlG2Rcrnjye4hxdLKPBZNYLzae3Q--
Message-ID: <4630BB95.80209@yahoo.com.au>
Date: Fri, 27 Apr 2007 00:47:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <20070426100652.GB27620@skynet.ie>
In-Reply-To: <20070426100652.GB27620@skynet.ie>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (25/04/07 23:46), Christoph Lameter didst pronounce:
> 
>>On Thu, 26 Apr 2007, Nick Piggin wrote:
>>
>>
>>>Yeah. IMO anti-fragmentation and defragmentation is the hack, and we
>>>should stay away from higher order allocations whenever possible.
>>
>>Right and we need to create series of other approaches that we then label 
>>"non-hack" to replace it. 
>>
> 
> 
> To date, there hasn't been a credible alternative to dealing with
> fragmentation. Breaking the 1:1 virtual:physical mapping and defragmenting
> would incur a serious performance hit.

Depends what you mean by "dealing with", I guess.

I would say there has been no credible alternative to virtually mapping
the kernel.


>>>Hardware is built to handle many small pages efficintly, and I don't
>>>understand how it could be an SGI-only issue. Sure, you may have an
>>>order of magnitude or more memory than anyone else, but even my lowly
>>>desktop _already_ has orders of magnitude more pages than it has TLB
>>>entries or cache -- if a workload is cache-nice for me, it probably
>>>will be on a 1TB machine as well, and if it is bad for the 1TB machine,
>>>it is also bad on mine.
>>
>>There have been numbers of people that have argued the same point. Just 
>>because we have developed a way of thinking to defend our traditional 4k 
>>values does not make them right.
>>
>>
>>>If this is instead an issue of io path or reclaim efficiency, then it
>>>would be really nice to see numbers... but I don't think making these
>>>fundamental paths more complex and slower is a nice way to fix it
>>>(larger PAGE_SIZE would be, though).
>>
>>The code paths can stay the same. You can switch CONFIG_LARGE pages off
>>if you do not want it and it is as it was.
>>
> 
> 
> It may not even need that that much effort. The most stressful use of the
> high order allocation paths here require the creation of a filesystem and
> is a deliberate action by the user.

Saying "oh this stuff may not always work quite right for everyone, but
it is OK because it is a special purpose solution for now" IMO is a big
sign saying that it is a bad design, and including it means we're lumped
with it forever.

-- 
SUSE Labs, Novell Inc.
