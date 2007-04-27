Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbXD0Mg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbXD0Mg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbXD0Mg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:36:28 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:24053 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755668AbXD0Mg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:36:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=i3LY/yfsN2UrX7sqlwzmmtD4Rl/O/pNW4e6ZM5b93xFoMUqVUWS8edySQW7AXhGNkBMNoYc0Rktq+RxG3r5vDWcASEmhyxgxNwJaQe4zpoZkPDU2fRZosjfvy0ljDZUL4sGSD+VWNmPzSLTgwzDsy5SDfQyLvv2Pyof3ECTItdQ=  ;
X-YMail-OSG: ielz4o4VM1leunuVf8_8A4pZAnS_E06LnZvHzcOo7rKVCRMloRMpeHRv6pmSPFZNlvfBZd8G_w--
Message-ID: <4631EE37.8040703@yahoo.com.au>
Date: Fri, 27 Apr 2007 22:36:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>	<20070426190438.3a856220.akpm@linux-foundation.org>	<20070427022731.GF65285596@melbourne.sgi.com>	<20070426195357.597ffd7e.akpm@linux-foundation.org>	<20070427042046.GI65285596@melbourne.sgi.com>	<20070426221528.655d79cb.akpm@linux-foundation.org>	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>	<20070426235542.bad7035a.akpm@linux-foundation.org>	<17969.55533.59287.509889@cargo.ozlabs.ibm.com>	<4631E173.7000204@yahoo.com.au> <17969.59676.356383.189020@cargo.ozlabs.ibm.com>
In-Reply-To: <17969.59676.356383.189020@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Nick Piggin writes:
> 
> 
>>For the TLB issue, higher order pagecache doesn't help. If distros
> 
> 
> Oh?  Assuming your hardware is capable of supporting a variety of page
> sizes, and of putting a page at any address that is a multiple of its
> size, it should help, potentially a great deal, as far as I can see.
> I'm thinking in particular of machines that have software-loaded
> fully-associative TLBs and support a lot of page sizes, e.g.
> 4kB * 4^n for n = 0 up to 8 or so, like some embedded powerpc chips.

That's a little bit more than just the higher order pagecache patch.
But I don't know if that would be impossible to do with the "attempt
to allocate contiguous pagecache" approach either. Or if it would be
worthwhile to support.


>>ship with a 4K page size on powerpc, and use some larger pages in
>>the pagecache, some people are still going to get angry because
>>they wanted to use 64K pages... But I agree 64K pages is too big
>>for most things anyway, and 16 would be better as a default (which
>>hopefully x86-64 will get one day).
> 
> 
> Even 16k is going to bloat the page cache, and some people will
> complain.  One way that x86-64 could do 16k pages is by still indexing
> the PTE page in units of 4k, but then have an indicator in the PTE
> that this is a 16k page.  Thus a 16k page would occupy 4 consecutive
> PTEs, but once it was loaded into the TLB, a single TLB entry would
> map the whole 16k.  That would give the expanded TLB reach and allow
> 4k and 16k pages to be intermixed freely.

I guess any page size bloats the pagecache relative to something
smaller :) But 4K doesn't seem to be proving too much problem for
x86 and I'm not talking about an actual implementation coming up,
but just a size that would make sense in future (and probably last
for a long time).

-- 
SUSE Labs, Novell Inc.
