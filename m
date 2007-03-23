Return-Path: <linux-kernel-owner+w=401wt.eu-S1422910AbXCWNxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422910AbXCWNxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 09:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422924AbXCWNxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 09:53:23 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:35324 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422910AbXCWNxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 09:53:22 -0400
Date: Fri, 23 Mar 2007 14:53:23 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
Message-Id: <20070323145323.e3590899.dada1@cosmosbay.com>
In-Reply-To: <84144f020703230548g4bd2f8b1y4610bb2886860@mail.gmail.com>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	<Pine.LNX.4.64.0703210742080.1573@graphe.net>
	<Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
	<20070321160929.GB25583@one.firstfloor.org>
	<20070323121512.c287ddef.dada1@cosmosbay.com>
	<84144f020703230548g4bd2f8b1y4610bb2886860@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 14:48:24 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On 3/23/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Checking Christoph quicklist implementation, I found the same cache miss in
> > free() than SLAB has.
> >
> > /* common implementation *
> > int virt_to_nid(const void *addr)
> > {
> >         struct page *page = virt_to_page(addr);
> >         return page_to_nid(page);
> > }
> >
> > On some platforms (x86_64 for example), could we have a better implementation,
> > not accessing struct page, but using phys_to_nid() ?
> 
> Sounds good to me. At least cache_free_alien() in mm/slab.c to should
> be converted to use it.
> 

Not yet :(

Because in slab we currently need virt_to_slab(addr)->nodeid, not page_to_nid(virt_to_page(addr))

It might be different, according to Christoph
