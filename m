Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXI1Slc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXI1Slc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXI1SlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:41:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56070 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754746AbXI1SlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:41:19 -0400
Date: Fri, 28 Sep 2007 11:41:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <1191003950.18147.85.camel@lappy>
Message-ID: <Pine.LNX.4.64.0709281133570.5397@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>  <20070919033643.763818012@sgi.com>
  <200709280742.38262.nickpiggin@yahoo.com.au> 
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> 
 <1191002119.18147.80.camel@lappy>  <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
 <1191003950.18147.85.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Peter Zijlstra wrote:

> memory got massively fragemented, as anti-frag gets easily defeated.
> setting min_free_kbytes to 12M does seem to solve it - it forces 2 max
> order blocks to stay available, so we don't mix types. however 12M on
> 128M is rather a lot.

Yes, strict ordering would be much better. On NUMA it may be possible to 
completely forbid merging. We can fall back to other nodes if necessary. 
12M is not much on a NUMA system.

But this shows that (unsurprisingly) we may have issues on systems with a 
small amounts of memory and we may not want to use higher orders on such 
systems.

The case you got may be good to use as a testcase for the virtual 
fallback. Hmmmm... Maybe it is possible to allocate the stack as a virtual 
compound page. Got some script/code to produce that problem?
