Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbXCUASN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbXCUASN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 20:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXCUASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 20:18:13 -0400
Received: from graphe.net ([209.204.138.32]:33485 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXCUASM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 20:18:12 -0400
Date: Tue, 20 Mar 2007 17:18:04 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Andi Kleen <andi@firstfloor.org>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <20070320213218.GA13952@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703201716440.17799@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Andi Kleen wrote:

> > > Is it possible virt_to_slab(objp)->nodeid being different from pfn_to_nid(objp) ?
> > 
> > It is possible the page allocator falls back to another node than 
> > requested. We would need to check that this never occurs.
> 
> The only way to ensure that would be to set a strict mempolicy.
> But I'm not sure that's a good idea -- after all you don't want
> to fail an allocation in this case.
> 
> But pfn_to_nid on the object like proposed by Eric should work anyways.
> But I'm not sure the tables used for that will be more often cache hot
> than the slab.

We usually use page_to_nid(). Sure this will determine the node the object 
resides on. But this may not be the node on which the slab is tracked 
since there may have been a fallback at alloc time.

