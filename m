Return-Path: <linux-kernel-owner+w=401wt.eu-S934910AbXEIDYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910AbXEIDYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXEIDYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:24:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54597 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754909AbXEIDYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:24:42 -0400
Date: Tue, 8 May 2007 20:24:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070509031604.GD11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705082021420.22016@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
 <20070509031604.GD11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Matt Mackall wrote:

> > Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient 
> > than SLUB.
> 
> What size object does kmalloc(80) return? In SLAB, the answer is 128
> bytes with 48 bytes of slack space. In SLOB, the answer is 88 for 8
> bytes of slack space. Looks like SLUB is in the same camp as SLAB
> here:

There is a 96 sized general slab. So it would go up to that size. But you 
can create a 80 byte slab of course. And that may cost minimal overhead 
since 80 byte slabs may be merged. If one already exist then you get it 
for free.

> +/*
> + * We keep the general caches in an array of slab caches that are used for
> + * 2^x bytes of allocations.
> + */
> +extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
> ..
> +	if (size <=        128) return 7;

96 please. You skipped the first part.

> SLOB's kmalloc overhead is 8 bytes, always. That's 1/8th the average
> SLAB kmalloc overhead.

SLUB can generate an 80 byte slab with minimal overhead if you wanted. But 
yes I agree the flexbility there is an advantage if you have objects of 
various sizes.
