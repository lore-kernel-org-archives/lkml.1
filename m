Return-Path: <linux-kernel-owner+w=401wt.eu-S937008AbXHGWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937008AbXHGWTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935328AbXHGWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:18:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35577 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935535AbXHGWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:18:41 -0400
Date: Tue, 7 Aug 2007 15:18:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <phillips@phunq.net>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <200708061649.56487.phillips@phunq.net>
Message-ID: <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <200708061559.41680.phillips@phunq.net>
 <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com>
 <200708061649.56487.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Daniel Phillips wrote:

> > AFAICT: This patchset is not throttling processes but failing
> > allocations.
> 
> Failing allocations?  Where do you see that?  As far as I can see, 
> Peter's patch set allows allocations to fail exactly where the user has 
> always specified they may fail, and in no new places.  If there is a 
> flaw in that logic, please let us know.

See the code added to slub: Allocations are satisfied from the reserve 
patch or they are failing.

> > The patchset does not reconfigure the memory reserves as 
> > expected.
> 
> What do you mean by that?  Expected by who?

What would be expected it some recalculation of min_freekbytes?

> > And I suspect that we  
> > have the same issues as in earlier releases with various corner cases
> > not being covered.
> 
> Do you have an example?

Try NUMA constraints and zone limitations.
 
> > Code is added that is supposedly not used.
> 
> What makes you think that?

Because the argument is that performance does not matter since the code 
patchs are not used.

> > If it  ever is on a large config then we are in very deep trouble by
> > the new code paths themselves that serialize things in order to give
> > some allocations precendence over the other allocations that are made
> > to fail ....
> 
> You mean by allocating the reserve memory on the wrong node in NUMA?  

No I mean all 1024 processors of our system running into this fail/succeed 
thingy that was added.

> That is on a code path that avoids destroying your machine performance 
> or killing the machine entirely as with current kernels, for which a 

As far as I know from our systems: The current kernels do not kill the 
machine if the reserves are configured the right way.

> few cachelines pulled to another node is a small price to pay.  And you 
> are free to use your special expertise in NUMA to make those fallback 
> paths even more efficient, but first you need to understand what they 
> are doing and why.

There is your problem. The justification is not clear at all and the 
solution likely causes unrelated problems.


 
