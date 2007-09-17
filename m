Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXIQVX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXIQVX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXIQVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:23:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59585 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757994AbXIQVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:23:08 -0400
Date: Mon, 17 Sep 2007 14:23:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ak@suse.de, eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
In-Reply-To: <1190060393.5460.143.camel@localhost>
Message-ID: <Pine.LNX.4.64.0709171420330.29704@schroedinger.engr.sgi.com>
References: <20070830185053.22619.96398.sendpatchset@localhost> 
 <1190057534.5460.131.camel@localhost>  <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
 <1190060393.5460.143.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007, Lee Schermerhorn wrote:

> Only for vma policy, right?  show_numa_maps() isn't a performance path,
> and shared policies are already reference counted--just not unref'd!

Right.

> I do have some ideas for enhancements to memtoy to test vma policies in
> a multi-threaded task.  I have the basic multi-threading infrastructure
> that binds threads to cpus, allocates node local stacks, thread state
> structs, ... in my mmtrace tool that I can probably hack for use in
> memtoy to provoke cacheline bouncing of the mem policy.  But, if pft
> does the trick, I won't rush the memtoy enhancments...

Well pft is old and limited in what it can do. I'd be glad if you could 
put it into memtoy. Then it may perhaps be useful in the future.
 
> Meanwhile, we do have a mem policy ref counting bug in the mainline.

But we have had this ref counting issue forever with no ill effect. Memory 
policies were designed to have almost no overhead for the default 
allocation paths. Incrementing and decrementing refcounters makes that 
design no longer light weight as it was intended to be.


