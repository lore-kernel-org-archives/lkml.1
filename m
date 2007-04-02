Return-Path: <linux-kernel-owner+w=401wt.eu-S965951AbXDBVbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951AbXDBVbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965954AbXDBVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:31:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56970 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965951AbXDBVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:31:38 -0400
Date: Mon, 2 Apr 2007 14:31:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Hansen <hansendc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] Generic Virtual Memmap suport for SPARSEMEM
In-Reply-To: <1175548924.22373.109.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704021428340.2272@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
  <1175547000.22373.89.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0704021351590.1224@schroedinger.engr.sgi.com>
 <1175548924.22373.109.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Dave Hansen wrote:

> > > Hmmmmmmm.  Can we combine this with sparse_index_alloc()?  Also, why not
> > > just use the slab for this?
> > 
> > Use a slab for page sized allocations? No.
> 
> Why not?  We use it above for sparse_index_alloc() and if it is doing
> something wrong, I'd love to fix it.  Can you elaborate?

The slab allocator purposes is to deliver small sub page sized chunks.
The page allocator is there to allocate pages. Both are optimized for its 
purpose.

> > I just extended this in V2 to also work on IA64. Its pretty generic.
> 
> Can you extend it to work on ppc? ;)

I do not know enough about how ppc handles large pages.

> You haven't posted V2, right?

No tests are still running.

> > > Then, do whatever magic you want in alloc_vmemmap().
> > 
> > That would break if alloc_vmemmap returns NULL because it cannot allocate 
> > memory.
> 
> OK, that makes sense.  However, it would still be nice to hide that
> #ifdef somewhere that people are a bit less likely to run into it.  It's
> just one #ifdef, so if you can kill it, great.  Otherwise, they pile up
> over time and _do_ cause real readability problems.

Well think about how to handle the case that the allocatiopn of a page 
table page or a vmemmap block fails. Once we have that sorted out then we 
can cleanup the higher layers.

