Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXD1FIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXD1FIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030986AbXD1FIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:08:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41301 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965440AbXD1FIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:08:19 -0400
Date: Fri, 27 Apr 2007 22:08:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070427215634.325606a9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
 <20070427002640.22a71d06.akpm@linux-foundation.org>
 <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com>
 <20070427121108.9ee05710.akpm@linux-foundation.org>
 <20070428031739.GK32602149@melbourne.sgi.com> <20070427215634.325606a9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> My (repeated) point is that if we populate pagecache with physically-contiguous 4k
> pages in this manner then bio+block will be able to create much larger SG lists.

True but the "if" becomes exceedingly rare the longer the system was in 
operation. 64k implies 16 pages in sequence. This is going to be a bit 
difficult to get. Then there is the overhead of handling these pages. 
Which may be not significant given growing processor capabilities in some 
usage cases. In others like a synchronized application running on a large 
number of nodes this is likely introduce random delays between processor 
to processor communication that will significantly impair performance.

And then there is the long list of features that cannot be accomplished 
with such an approach like mounting a volume with large block size, 
handling CD/DVDs, getting rid of various shim layers etc.

I'd also like to have much higher orders of allocations for scientific 
applications that require an extremely large I/O rate. For those we 
could f.e. dedicate memory nodes that will only use a very high page 
order to prevent fragmentation. E.g. 1G pages is certainly something that 
lots of our customers would find beneficial (and they are actually 
already using those types of pages in the form of huge pages but with 
limited capabilities).

But then we are sadly again trying to find another workaround that 
will not get us there and will not allow the flexibility in the 
VM that would make things much easier for lots of usage scenarios.

