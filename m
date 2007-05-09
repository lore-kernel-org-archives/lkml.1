Return-Path: <linux-kernel-owner+w=401wt.eu-S1033692AbXEID1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033692AbXEID1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968834AbXEID1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:27:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54770 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969557AbXEID1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:27:09 -0400
Date: Tue, 8 May 2007 20:27:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <46413D6A.6000502@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705082025010.22016@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070508.185141.85412154.davem@davemloft.net> <46412BB5.1060605@yahoo.com.au>
 <20070509025634.GC11115@waste.org> <46413D6A.6000502@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Nick Piggin wrote:

> SLAB_DESTROY_BY_RCU is quite a nice way to mitigate some RCU freeing
> overheads for small objects, so I'd expect it may see wider use in
> future. Maybe all those users would be fine too, but it's a bit nasty
> to have already tricky RCU semantics deviate...

Signal handling is using RCU too right?

> > I think if we want RCU to actually work, we want to run ->dtor in
> > __kmem_cache_free?
> 
> Yeah, thinko... thanks.

According to SLAB code: RCU cannot have a dtor.

kmem_cache_create()

     if (flags & SLAB_DESTROY_BY_RCU)
                BUG_ON(dtor);

