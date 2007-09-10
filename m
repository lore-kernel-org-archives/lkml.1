Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXIJUW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXIJUW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbXIJUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:22:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52797 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757278AbXIJUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:22:20 -0400
Date: Mon, 10 Sep 2007 13:22:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Daniel Phillips <phillips@phunq.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1189454145.21778.48.camel@twins>
Message-ID: <Pine.LNX.4.64.0709101318160.25407@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <200709050220.53801.phillips@phunq.net>
  <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com> 
 <200709050916.04477.phillips@phunq.net>  <Pine.LNX.4.64.0709101220001.24735@schroedinger.engr.sgi.com>
 <1189454145.21778.48.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Peter Zijlstra wrote:

> On Mon, 2007-09-10 at 12:25 -0700, Christoph Lameter wrote:
> 
> > Of course boundless allocations from interrupt / reclaim context will 
> > ultimately crash the system. To fix that you need to stop the networking 
> > layer from performing these.
> 
> Trouble is, I don't only need a network layer to not endlessly consume
> memory, I need it to 'fully' function so that we can receive the
> writeout completion.

You need to drop packets after having inspected them right? Why wont 
dropping packets after a certain amount of memory has been allocated work? 
What is so difficult about that?

> or
> 
>   - have a global reserve and selectively serves sockets
>     (what I've been doing)

That is a scalability problem on large systems! Global means global 
serialization, cacheline bouncing and possibly livelocks. If we get into 
this global shortage then all cpus may end up taking the same locks 
cycling thought the same allocation paths.

> So, if you will, you can view my approach as a reserve per socket, where
> most sockets get a reserve of 0 and a few (those serving the VM) !0.

Well it looks like you know how to do it. Why not implement it?



