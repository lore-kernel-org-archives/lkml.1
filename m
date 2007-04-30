Return-Path: <linux-kernel-owner+w=401wt.eu-S1422999AbXD3Fas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422999AbXD3Fas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423037AbXD3Fas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:30:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54002 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422999AbXD3Far (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:30:47 -0400
Date: Sun, 29 Apr 2007 22:30:46 -0700 (PDT)
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
In-Reply-To: <20070427235247.3576a463.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704292225540.1978@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
 <20070427002640.22a71d06.akpm@linux-foundation.org>
 <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com>
 <20070427121108.9ee05710.akpm@linux-foundation.org>
 <20070428031739.GK32602149@melbourne.sgi.com> <20070427215634.325606a9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
 <20070427223632.52def99e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704272319170.7610@schroedinger.engr.sgi.com>
 <20070427235247.3576a463.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> By misunderstanding any suggestions, misrepresenting them, making incorrect
> statements about them, by not suggesting any alternatives yourself, all of
> it buttressed by a stolid refusal to recognise that this patch has any
> costs.

That was even mentioned in the initial post.... Definitely it would 
require significant changes but getting there is fairly straightforward 
with the use of compound pages.
 
> This effectively leaves it up to others to find time to think about and to
> implement possible alternative solutions to the problems which you're
> observing.

They are working on other problems like radix tree scalability it seems. 

> The altenative which is on the table (and there may be others) is
> populating pagecache with physically contiguous pages.  This will fix the
> HBA problem and is much less costly in terms of maintenance and will
> improve all workloads on all machines and doesn't have the additional
> runtime costs of pagecache wastage and more memset() overhead with small
> files and it doesn't require administrator intervention.
> 
> OTOH (yes!  there are tradeoffs!) it will consume an unknown amount more
> CPU and it doesn't address the large-fs-blocksize requirement, but I don't
> know how important the latter is and given the unrelenting advocacy storm
> coming from the SGI direction I don't know how to find that out, frankly.

This is certainly a nice approach if it works and may address one 
issue that motivated this patchset but it does not address all.

