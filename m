Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXENQK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXENQK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXENQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:10:22 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:48606 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652AbXENQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:10:22 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
In-Reply-To: <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 18:10:11 +0200
Message-Id: <1179159011.2942.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 08:53 -0700, Christoph Lameter wrote:
> On Mon, 14 May 2007, Peter Zijlstra wrote:
> 
> > In the interest of creating a reserve based allocator; we need to make the slab
> > allocator (*sigh*, all three) fair with respect to GFP flags.
> 
> I am not sure what the point of all of this is. 
> 
> > That is, we need to protect memory from being used by easier gfp flags than it
> > was allocated with. If our reserve is placed below GFP_ATOMIC, we do not want a
> > GFP_KERNEL allocation to walk away with it - a scenario that is perfectly
> > possible with the current allocators.
> 
> Why does this have to handled by the slab allocators at all? If you have 
> free pages in the page allocator then the slab allocators will be able to 
> use that reserve.

Yes, too freely. GFP flags are only ever checked when you allocate a new
page. Hence, if you have a low reaching alloc allocating a slab page;
subsequent non critical GFP_KERNEL allocs can fill up that slab. Hence
you would need to reserve a slab per object instead of the normal
packing.

