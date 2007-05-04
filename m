Return-Path: <linux-kernel-owner+w=401wt.eu-S1031371AbXEDQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031371AbXEDQg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031379AbXEDQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:36:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55268 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031187AbXEDQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:36:19 -0400
Date: Fri, 4 May 2007 09:36:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
In-Reply-To: <20070504103157.215424767@chello.nl>
Message-ID: <Pine.LNX.4.64.0705040932200.22033@schroedinger.engr.sgi.com>
References: <20070504102651.923946304@chello.nl> <20070504103157.215424767@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Peter Zijlstra wrote:

> Expost buffer_size in order to allow fair estimates on the actual space 
> used/needed.

If its just an estimate that you are after then I think ksize is 
sufficient.

The buffer size does not include the other per slab overhead that SLAB 
needs nor the alignment overhead or the padding. For SLUB you'd be more 
lucky but there it does not include the per slab padding that exist.

Need to check how this is going to be used. It is difficult to estimate 
slab use because this depends on the availability of object slots in 
partial slabs.

I could add a function that tells you how many object you could allocate 
from a slab without the page allocator becoming involved? It would count 
the object slots available on the partial slabs.
