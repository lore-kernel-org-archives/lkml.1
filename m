Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXKBOfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXKBOfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXKBOfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:35:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34637 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753889AbXKBOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:35:37 -0400
Date: Fri, 2 Nov 2007 07:35:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <1193999326.27652.348.camel@twins>
Message-ID: <Pine.LNX.4.64.0711020734070.26635@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com> 
 <20071101.153824.91808126.davem@davemloft.net> 
 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com> 
 <20071101.155805.65012933.davem@davemloft.net> <1193999326.27652.348.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007, Peter Zijlstra wrote:

> On Thu, 2007-11-01 at 15:58 -0700, David Miller wrote:
> 
> > Since you're the one who wants to change the semantics and guarentees
> > of this interface, perhaps it might help if you did some greps around
> > the tree to see how alloc_percpu() is actually used.  That's what
> > I did when I started running into trouble with your patches.
> 
> This fancy new BDI stuff also lives off percpu_counter/alloc_percpu().

Yes there are numerous uses. I even can increase page allocator 
performance and reduce its memory footprint by using it here.

> That means that for example each NFS mount also consumes a number of
> words - not quite sure from the top of my head how many, might be in the
> order of 24 bytes or something.
> 
> I once before started looking at this, because the current
> alloc_percpu() can have some false sharing - not that I have machines
> that are overly bothered by that. I like the idea of a strict percpu
> region, however do be aware of the users.

Well I wonder if I should introduce it not as a replacement but as an 
alternative to allocpercpu? We can then gradually switch over. The 
existing API does not allow the specification of gfp_masks or alignements.

