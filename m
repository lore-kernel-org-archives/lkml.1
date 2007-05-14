Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbXENPx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbXENPx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXENPxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:53:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54227 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754462AbXENPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:53:22 -0400
Date: Mon, 14 May 2007 08:53:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <20070514131904.440041502@chello.nl>
Message-ID: <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> In the interest of creating a reserve based allocator; we need to make the slab
> allocator (*sigh*, all three) fair with respect to GFP flags.

I am not sure what the point of all of this is. 

> That is, we need to protect memory from being used by easier gfp flags than it
> was allocated with. If our reserve is placed below GFP_ATOMIC, we do not want a
> GFP_KERNEL allocation to walk away with it - a scenario that is perfectly
> possible with the current allocators.

Why does this have to handled by the slab allocators at all? If you have 
free pages in the page allocator then the slab allocators will be able to 
use that reserve.

