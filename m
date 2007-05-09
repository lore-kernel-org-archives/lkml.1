Return-Path: <linux-kernel-owner+w=401wt.eu-S935566AbXEICYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566AbXEICYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935347AbXEICYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:24:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43480 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935402AbXEICYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:24:07 -0400
Date: Tue, 8 May 2007 19:24:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070509021911.GB11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070509021911.GB11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Matt Mackall wrote:

> > > Yes. It can in fact put 512 8-byte objects in a 4k page. More
> > 
> > So can SLUB.
> 
> Not without at least a bit per-object of overhead. So you can either
> fit 512 objects in 4160 bytes or 504 objects in 4k.

Slub uses a linked list pointer in the page struct which is NULL if all 
objects are allocated. There is no bit per object overhead.

> For the kmalloc case, we do have an 8-byte header, which works out to
> be about 1/8th of the slop that mainline kmalloc over SLAB has on

Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient 
than SLUB.

> average due to power of two cache sizes. So in both cases, less
> overhead than SLAB and different-sized objects can be comingled. SLUB
> would be awfully hard-pressed to have lower space overhead.

Its simple and easy to do and it was done in SLUB.
