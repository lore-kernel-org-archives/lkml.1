Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXJ2DeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXJ2DeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXJ2DeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:34:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37676 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750949AbXJ2DeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:34:15 -0400
Date: Sun, 28 Oct 2007 20:34:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 08/10] SLUB: Optional fast path using cmpxchg_local
In-Reply-To: <Pine.LNX.4.64.0710281502480.4207@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0710282031060.28860@schroedinger.engr.sgi.com>
References: <20071028033156.022983073@sgi.com> <20071028033300.240703208@sgi.com>
 <Pine.LNX.4.64.0710281502480.4207@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Pekka J Enberg wrote:

> -	local_irq_restore(flags);
> +	object = do_slab_alloc(s, c, gfpflags, node, addr);
> +	if (unlikely(!object))
> +		goto out;

Undoing the optimization that one of the earlier patches added.

The #ifdef version is for me at least easier to read. The code there is a 
special unit that has to deal with the most performance critical piece of 
the slab allocator. And the #ifdef there clarifies that any changes have 
to be done to both branches.

