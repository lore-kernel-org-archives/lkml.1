Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXEPUpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXEPUpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbXEPUpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:45:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43745 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbXEPUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:45:01 -0400
Date: Wed, 16 May 2007 13:44:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179348039.2912.48.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705161343080.11234@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com> 
 <20070514161224.GC11115@waste.org>  <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
  <1179164453.2942.26.camel@lappy>  <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
  <1179170912.2942.37.camel@lappy> <1179250036.7173.7.camel@twins> 
 <Pine.LNX.4.64.0705151457060.3155@schroedinger.engr.sgi.com> 
 <1179298771.7173.16.camel@twins>  <Pine.LNX.4.64.0705161139540.10265@schroedinger.engr.sgi.com>
  <1179343521.2912.20.camel@lappy>  <Pine.LNX.4.64.0705161235490.10660@schroedinger.engr.sgi.com>
  <1179346738.2912.39.camel@lappy>  <Pine.LNX.4.64.0705161320020.11018@schroedinger.engr.sgi.com>
 <1179348039.2912.48.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Peter Zijlstra wrote:

> > How does all of this interact with
> > 
> > 1. cpusets
> > 
> > 2. dma allocations and highmem?
> > 
> > 3. Containers?
> 
> Much like the normal kmem_cache would do; I'm not changing any of the
> page allocation semantics.

So if we run out of memory on a cpuset then network I/O will still fail?

I do not see any distinction between DMA and regular memory. If we need 
DMA memory to complete the transaction then this wont work?


> But its wanted to try the normal cpu_slab path first to detect that the
> situation has subsided and we can resume normal operation.

Is there some indicator somewhere that indicates that we are in trouble? I 
just see the ranks.

