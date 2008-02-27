Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYB0V5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYB0V5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYB0V5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:57:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49526 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756897AbYB0V47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:56:59 -0500
Date: Wed, 27 Feb 2008 13:56:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: dada1@cosmosbay.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yanmin_zhang@linux.intel.com, travis@sgi.com
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
In-Reply-To: <20080227122451.6a3b5565.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802271353520.12963@schroedinger.engr.sgi.com>
References: <47BDBC23.10605@cosmosbay.com> <Pine.LNX.4.64.0802271158100.1790@schroedinger.engr.sgi.com>
 <20080227122451.6a3b5565.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Andrew Morton wrote:

> On Wed, 27 Feb 2008 11:59:32 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Any decision made on what to do about this one? Mike or I can 
> > repost the per cpu allocator against mm? The fix by Eric could be used 
> > in the interim for 2.6.24?
> > 
> 
> I suppose I'll merge Eric's patch when I've tested it fully (well, as fully
> as I test stuff).

Urgh. You too?
 
> It'd be nice to get that cache_line_size()/L1_CACHE_BYTES/L1_CACHE_ALIGN()
> mess sorted out.  If it's a mess - I _think_ it is?

Well I tried it when slub went first in and it did not go well. The issue 
is that x86 detects the cache line size on bootup. Thus cache_line_size(). 
Most of the other arch have compile time cache line sizes. Thus 
L1_CACHE_BYTES. So L1_CACHE_BYTES is the maximum value that 
cache_line_size() can take.

What I was attempting to do is to make x86 have one compile time cache 
line size L1_CACHE_BYTES. That raised objections because space was wasted.
