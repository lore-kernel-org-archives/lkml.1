Return-Path: <linux-kernel-owner+w=401wt.eu-S1030949AbXD1C14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030949AbXD1C14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030952AbXD1C14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:27:56 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:32072 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030949AbXD1C1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:27:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=6WhlHFw2lJsyZo2ETMbykG3h5jD1Yt6MnH6xb4YYhgriekziEfbXHgW0Et/V8GALh2gzeCfxLcQRztJYw7U4bxy6OLMW/QKAiLj85IoMxmFyVzSavbicC9eyoh6jLUAVpoH9Ckn7RHQzgmNx06b69EUi0bRZ37Vyzb0fRmpgl+Y=  ;
X-YMail-OSG: psjpxu4VM1maeXomKq0k6.GJEvLNrqJ4LDGMCL8x3Cko4aBK4ltH79ffr0FaWjruc_p03vXoew--
Message-ID: <4632B121.3030005@yahoo.com.au>
Date: Sat, 28 Apr 2007 12:27:45 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au> <20070427133947.GB4152@infradead.org>
In-Reply-To: <20070427133947.GB4152@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Apr 27, 2007 at 10:25:44PM +1000, Nick Piggin wrote:
> 
>>Linus's favourite jokes about powerpc mmu being crippled forever, aside ;)
> 
> 
> Different mmu.  The desktop 32bit mmu Linus refered to has almost nothing
> in common with the mmu on 64bit systems.


Well I wasn't trying to make a point there so it isn't a big deal... but
he has known to say the 64-bit hash table is insane or broken. If he's
since recanted, I'd be interested to read the post :)


>>>Right this could help but it is not addressing the basic requirement for
>>>devices that need large contiguuos chunks of memory for I/O.
>>
>>Did you read the last paragraph? Or anything Andrew's been writing?
>>
>> "After that, I'd find it amusing if HBAs worth thousands of $ have
>>  trouble looking up sglists at the relatively glacial pace that IO
>>  requires, and/or can't spare a few more K for reasonable sglist
>>  sizes, but if that is really the case, then we could use iommus
>>  and/or just attempt to put physically contiguous pages in pagecache,
>>  rather than require it."
> 
> 
> Real highend HBAs don't have that problem.  But for example aacraid
> which is very common on mid-end servers is a _lot_ faster when it
> gets continous memory.  Some benchmark was 10 or more percent faster
> on windows due to this.

And that wasn't due to the 128 sg limit?

I guess 10% isn't a small amount. Though it would be nice to have
before/after numbers for Linux. And, like Andrew was saying, we could
just _attempt_ to put contiguous pages in pagecache rather than
_require_ it. Which is still robust under fragmentation, and benefits
everyone, not just files with a large pagecache size.

-- 
SUSE Labs, Novell Inc.
