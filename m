Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXCUPzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXCUPzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCUPzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:55:07 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34264 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbXCUPzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:55:06 -0400
Date: Wed, 21 Mar 2007 16:52:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Christoph Lameter" <christoph@lameter.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
Message-Id: <20070321165230.257c61d1.dada1@cosmosbay.com>
In-Reply-To: <84144f020703210847n53713bcj3a86d845cd3e56d6@mail.gmail.com>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703210737400.1573@graphe.net>
	<20070321163635.82697f08.dada1@cosmosbay.com>
	<84144f020703210847n53713bcj3a86d845cd3e56d6@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 17:47:13 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Last time I checked 'struct page', they was no nodeid in it.
> 
> Hmm, page_to_nid() in include/linx/mm.h doesn't agree with you:
> 
> #ifdef NODE_NOT_IN_PAGE_FLAGS
> extern int page_to_nid(struct page *page);
> #else
> static inline int page_to_nid(struct page *page)
> {
>         return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
> }
> #endif
> 

Correct, but still another ifdef NODE_NOT_IN_PAGE_FLAGS

Anyway the correct path is to check GFP_THISNODE stuff, because we can
even avoid access to 'struct page' to get the nodeid, at least on x86_64 NUMA,
where struct memnode can provide the information with less cache footprint.

