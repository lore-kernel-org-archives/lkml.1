Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXKCTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXKCTKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXKCTKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:10:36 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34697 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbXKCTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:10:36 -0400
Date: Sat, 3 Nov 2007 19:09:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slub: fix Objects count
In-Reply-To: <Pine.LNX.4.64.0711031125090.5395@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711031904470.14407@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031125090.5395@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Christoph Lameter wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> 
> > The count of active Objects shown by Slub's slabinfo is too approximate,
> > because each cpu slab is counted as all in use, even when lots are free.
> > That makes tracing leaks harder than it need be.
> 
> True but that is the way it is for performance reasons.

I was afraid you might say something like that.
Perhaps it'll be a patch I need to use in my own builds.
Though I'd have thought others would want that accuracy too.
Didn't SLAB give it?  (The "r*gr*ss**n" word!)

> > Add a free count into kmem_cache_cpu (which doesn't enlarge it on 64-bit),
> > to keep that count in the hot and dirty per-cpu cacheline.
> 
> Adds to much overhead to the fast paths

You've come to that conclusion very quickly!
Any numbers to back it up?

> and will make the current optimizations in mm impossible.

I'll have to wait and see what those are: you move too fast for me.

Hugh
