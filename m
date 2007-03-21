Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXCUDLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXCUDLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCUDLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:11:01 -0400
Received: from graphe.net ([209.204.138.32]:38894 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXCUDLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:11:01 -0400
Date: Tue, 20 Mar 2007 20:10:51 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Andi Kleen <andi@firstfloor.org>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <20070321024452.GA17532@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703202006230.20568@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Andi Kleen wrote:

> > We usually use page_to_nid(). Sure this will determine the node the object 
> > resides on. But this may not be the node on which the slab is tracked 
> > since there may have been a fallback at alloc time.
> 
> How about your slab rewrite?  I assume it would make more sense to fix
> such problems in that code instead of the old which is going to be replaced
> at some point.

The slab rewrite first allocates a page and then determines where it 
came from instead of requiring the page allocator to allocate from a 
certain node. Plus SLUB does not keep per cpu or per node object queues. 
So the problem does not occur in the same way. The per cpu slab in SLUB 
can contain objects from another node whereas SLAB can only put node local 
objects on its queues.


