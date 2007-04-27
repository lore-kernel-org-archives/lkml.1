Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXD0MMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXD0MMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbXD0MMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:12:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755730AbXD0MMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:12:06 -0400
Date: Fri, 27 Apr 2007 05:12:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <4631E173.7000204@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nick Piggin wrote:

> For the TLB issue, higher order pagecache doesn't help. If distros
> ship with a 4K page size on powerpc, and use some larger pages in
> the pagecache, some people are still going to get angry because
> they wanted to use 64K pages... But I agree 64K pages is too big
> for most things anyway, and 16 would be better as a default (which
> hopefully x86-64 will get one day).

Powerpc supports multiple pagesizes. Maybe we could make mmap use those 
page sizes some day if we had a variable order page cache. Your stands on 
the issue means that powerpc will be forever crippled and not be able to 
use its full potential.
 
> Anyway, for io performance, there are alternatives, dispite what
> some people seem to be saying. We can submit larger sglists to the
> device for larger ios, which Jens is looking at (which could help
> all types of workloads, not just those with sequential large file
> IO).

Right this could help but it is not addressing the basic requirement for
devices that need large contiguuos chunks of memory for I/O.
