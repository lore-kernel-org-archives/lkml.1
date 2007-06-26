Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbXFZSO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbXFZSO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXFZSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:14:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43691 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbXFZSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:14:19 -0400
Date: Tue, 26 Jun 2007 11:14:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
In-Reply-To: <20070626002131.ff3518d4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706261112380.18010@schroedinger.engr.sgi.com>
References: <20070619090616.GA23697@linux-sh.org>
 <20070626002131.ff3518d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> > +#ifdef CONFIG_NUMA
> > +	if (node != -1)
> > +		page = alloc_pages_node(node, gfp, order);
> > +	else
> > +#endif
> > +		page = alloc_pages(gfp, order);
> 
> Isn't the above equivalent to a bare
> 
> 	page = alloc_pages_node(node, gfp, order);
> 
> ?

No. alloc_pages follows memory policy. alloc_pages_node does not. One of 
the reasons that I want a new memory policy layer are these kinds of 
strange uses.

> 
> 	if (node < 0
> 
> rather than comparing with -1 exactly.
> 
> On many CPUs it'll save a few bytes of code.

-1 means no node specified and much of the NUMA code compares with -1.

