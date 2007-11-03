Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXKCTdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXKCTdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXKCTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:33:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50634 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755402AbXKCTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:33:06 -0400
Date: Sat, 3 Nov 2007 12:33:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slub: fix Objects count
In-Reply-To: <Pine.LNX.4.64.0711031904470.14407@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031226131.5695@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031125090.5395@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031904470.14407@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> I was afraid you might say something like that.
> Perhaps it'll be a patch I need to use in my own builds.
> Though I'd have thought others would want that accuracy too.
> Didn't SLAB give it?  (The "r*gr*ss**n" word!)

Slab also only counts objects that are not in the queues. See free_block() 
f.e.

We could improve the situation by flushing all cpu slabs before counts are 
determined.

Which can be done manually. Run

	slabinfo -s

and then look at the numbers.


> > Adds to much overhead to the fast paths
> 
> You've come to that conclusion very quickly!

I have just spend a few weeks optimizing the fast and slow paths and there 
is some additional overhead that I am still trying to eliminate.

> Any numbers to back it up?

The performance in the fast paths depends on updating only a single word
for an allocation. Adding another counter makes that impossible.

See the recent post on SLUB regression on SMP.
