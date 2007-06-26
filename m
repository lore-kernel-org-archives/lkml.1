Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXFZTLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXFZTLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbXFZTK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:10:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37537 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759504AbXFZTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:10:58 -0400
Date: Tue, 26 Jun 2007 12:10:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nish Aravamudan <nish.aravamudan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
In-Reply-To: <29495f1d0706261204x5b49511co18546443c78033fd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706261209170.19878@schroedinger.engr.sgi.com>
References: <20070619090616.GA23697@linux-sh.org> 
 <20070626002131.ff3518d4.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706261112380.18010@schroedinger.engr.sgi.com>
 <29495f1d0706261204x5b49511co18546443c78033fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Nish Aravamudan wrote:

> > No. alloc_pages follows memory policy. alloc_pages_node does not. One of
> > the reasons that I want a new memory policy layer are these kinds of
> > strange uses.
> 
> What would break by changing, in alloc_pages_node()
> 
>        if (nid < 0)
>                nid = numa_node_id();
> 
> to
> 
>        if (nid < 0)
>                return alloc_pages_current(gfp_mask, order);
> 
> beyond needing to make alloc_pages_current() defined if !NUMA too.

It would make alloc_pages_node obey memory policies instead of only
following cpuset constraints. An a memory policy may redirect the 
allocation from the local node ;-).


