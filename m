Return-Path: <linux-kernel-owner+w=401wt.eu-S964853AbXCSVQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbXCSVQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXCSVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:16:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51329 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964917AbXCSVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:16:04 -0400
Date: Mon, 19 Mar 2007 14:16:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       ast@domdv.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <20070319204945.GJ10459@waste.org>
Message-ID: <Pine.LNX.4.64.0703191414330.8328@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
 <20070319204945.GJ10459@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Matt Mackall wrote:

> I think this sort of thing should work:
> 
> a = kmalloc(...)
> b = kmem_cache_alloc(..)
> c = allocate_some_id(...)
> if (!a || !b || !c) {
>    free_some_id(c)
>    kmem_cache_free(c)

^^^^ this requires the specification of a kmem_cache structure and the 
object must be allocated by that cache.

>    kfree(a);

Here we dynamically determine the slab cache and do not verify even which 
slab it came from.

So you can always use kfree if you do not care. kmem_cache_free verifies
correctness.
