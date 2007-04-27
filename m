Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXD0M0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXD0M0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbXD0M0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:26:03 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31491 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755718AbXD0M0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:26:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GdyPuMW1Y23UUM0atTjeXgHPQMw8GPtXNlrf5ab904BR0BHQTWBVfU/u9RFLvApWIQIofvpKuOIruECBd984+3AFxJlEP66KbgTbFDwum+RXCubksI8rt5xH+XFNcCyMplwdl2zzc11PBBjB7petowo3MiV66qk2z0Haczc8YXs=  ;
X-YMail-OSG: RNm9rw4VM1ldkaFIv3xqjTd7BwXjp2R7IpjO3N6FtZ6grKUOTSxJ6APE761Wp5dFASkPlMUcPg--
Message-ID: <4631EBC8.4060003@yahoo.com.au>
Date: Fri, 27 Apr 2007 22:25:44 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 27 Apr 2007, Nick Piggin wrote:
> 
> 
>>For the TLB issue, higher order pagecache doesn't help. If distros
>>ship with a 4K page size on powerpc, and use some larger pages in
>>the pagecache, some people are still going to get angry because
>>they wanted to use 64K pages... But I agree 64K pages is too big
>>for most things anyway, and 16 would be better as a default (which
>>hopefully x86-64 will get one day).
> 
> 
> Powerpc supports multiple pagesizes. Maybe we could make mmap use those 
> page sizes some day if we had a variable order page cache. Your stands on 
> the issue means that powerpc will be forever crippled and not be able to 
> use its full potential.

Linus's favourite jokes about powerpc mmu being crippled forever, aside ;)

This seems like just speculation. I would not be against something which,
without, would "cripple" some relevant hardware, but you are just handwaving
at this point. And you are still ignoring the alternatives.


>>Anyway, for io performance, there are alternatives, dispite what
>>some people seem to be saying. We can submit larger sglists to the
>>device for larger ios, which Jens is looking at (which could help
>>all types of workloads, not just those with sequential large file
>>IO).
> 
> 
> Right this could help but it is not addressing the basic requirement for
> devices that need large contiguuos chunks of memory for I/O.

Did you read the last paragraph? Or anything Andrew's been writing?

  "After that, I'd find it amusing if HBAs worth thousands of $ have
   trouble looking up sglists at the relatively glacial pace that IO
   requires, and/or can't spare a few more K for reasonable sglist
   sizes, but if that is really the case, then we could use iommus
   and/or just attempt to put physically contiguous pages in pagecache,
   rather than require it."

-- 
SUSE Labs, Novell Inc.
