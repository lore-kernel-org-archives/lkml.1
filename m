Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbYCCTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbYCCTae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYCCTaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:30:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754205AbYCCTaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:30:08 -0500
Date: Mon, 3 Mar 2008 11:30:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
In-Reply-To: <200803031414.43076.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0803031129330.7275@schroedinger.engr.sgi.com>
References: <47BDBC23.10605@cosmosbay.com> <200802232023.52352.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802271140470.1790@schroedinger.engr.sgi.com>
 <200803031414.43076.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> I think so. If we ask for HWCACHE_ALIGN, it must be for a good reason.
> If some structures get too bloated for no good reason, then the problem
> is not with the slab allocator but with the caller asking for
> HWCACHE_ALIGN.

Right. There should only be a few select users of this strange flag. 
Otherwise if a certain alignment is wanted specify it in the alignment 
parameter passed to kmem_cache_create.

