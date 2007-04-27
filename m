Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXD0Nkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXD0Nkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXD0Nkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:40:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37554 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbXD0NkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:40:21 -0400
Date: Fri, 27 Apr 2007 14:39:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427133947.GB4152@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4631EBC8.4060003@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:25:44PM +1000, Nick Piggin wrote:
> Linus's favourite jokes about powerpc mmu being crippled forever, aside ;)

Different mmu.  The desktop 32bit mmu Linus refered to has almost nothing
in common with the mmu on 64bit systems.

> >Right this could help but it is not addressing the basic requirement for
> >devices that need large contiguuos chunks of memory for I/O.
> 
> Did you read the last paragraph? Or anything Andrew's been writing?
> 
>  "After that, I'd find it amusing if HBAs worth thousands of $ have
>   trouble looking up sglists at the relatively glacial pace that IO
>   requires, and/or can't spare a few more K for reasonable sglist
>   sizes, but if that is really the case, then we could use iommus
>   and/or just attempt to put physically contiguous pages in pagecache,
>   rather than require it."

Real highend HBAs don't have that problem.  But for example aacraid
which is very common on mid-end servers is a _lot_ faster when it
gets continous memory.  Some benchmark was 10 or more percent faster
on windows due to this.
