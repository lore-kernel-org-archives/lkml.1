Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZCTRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZCTRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZCTRnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:43:02 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54314 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZCTRnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:43:01 -0400
Date: Fri, 20 Mar 2009 13:40:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nitin Gupta <nitingupta910@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
In-Reply-To: <49C3C321.8080508@vflare.org>
Message-ID: <alpine.DEB.1.10.0903201337500.18010@qirst.com>
References: <49C3A31D.6070208@vflare.org> <49C3A435.7060703@vflare.org> <alpine.DEB.1.10.0903201042570.3740@qirst.com> <49C3C321.8080508@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Nitin Gupta wrote:

> > Maybe try a fair test instead of relying on kmalloc rounding up to
> > the next power of 2 size?
> >
>
> Okay, for testing, I will make some wrappers around SLOB that directly use
> slob_alloc() to avoid any of this rounding-off. I hope to show some data on
> this soon. But considering other SLOB issues, this should not, hopefully,
> be a blocker for compcache.

SLOB is not rounding off. SLAB/SLUB are. You need to create custom
kmem_caches for this.

> I think, with a bit playing around with interfaces, it can be turned into
> general purpose allocator (this will most probably lack highmem support).

Then it would need to implement the SLAB api (see include/linux/slab.h).
Thus we are getting slab allocator #5.

