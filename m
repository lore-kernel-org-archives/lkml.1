Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbXENQht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbXENQht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXENQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:37:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37419 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754689AbXENQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:37:42 -0400
Date: Mon, 14 May 2007 09:37:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179159011.2942.16.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705140935530.10801@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
 <1179159011.2942.16.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> > Why does this have to handled by the slab allocators at all? If you have 
> > free pages in the page allocator then the slab allocators will be able to 
> > use that reserve.
> 
> Yes, too freely. GFP flags are only ever checked when you allocate a new
> page. Hence, if you have a low reaching alloc allocating a slab page;
> subsequent non critical GFP_KERNEL allocs can fill up that slab. Hence
> you would need to reserve a slab per object instead of the normal
> packing.

This is all about making one thread fail rather than another? Note that 
the allocations are a rather compex affair in the slab allocators. Per 
node and per cpu structures play a big role.


