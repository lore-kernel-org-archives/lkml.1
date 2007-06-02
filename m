Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbXFBAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbXFBAMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbXFBAMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:12:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43830 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756211AbXFBAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:12:45 -0400
Date: Fri, 1 Jun 2007 17:12:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011659170.10164@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011638360.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011642530.9992@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Linus Torvalds wrote:

> > A too large alloc is >32MB or MAX_ORDER << PAGE_SIZE. A BUG_ON in 
> > kmalloc_slab() will trigger.
> 
> Did we use to BUG_ON()? I think that's wrong. There are ways for users to 
> potentially ask the kernel to do big allocations, and the correct response 
> is to say "no can do", not to crash!

There is no way to distinguish that from out of memory. Failing on large 
allocs is what we have always done for kmalloc(). Before 2.6.22 we used to 
fail for allocs > 256k which was a big nuisance for NUMAs large allocs.

The patches in 2.6.22 allow us for the first time to allocate arbitrary 
sized objects up to MAX_ORDER. So we no longer have troubles with large 
NUMA objects.

