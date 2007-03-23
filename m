Return-Path: <linux-kernel-owner+w=401wt.eu-S1945899AbXCWOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945899AbXCWOur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945896AbXCWOur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:50:47 -0400
Received: from graphe.net ([209.204.138.32]:45751 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945899AbXCWOuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:50:46 -0400
Date: Fri, 23 Mar 2007 07:50:28 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
In-Reply-To: <20070323121512.c287ddef.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703230749130.29603@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
 <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
 <20070321160929.GB25583@one.firstfloor.org> <20070323121512.c287ddef.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Eric Dumazet wrote:

> Checking Christoph quicklist implementation, I found the same cache miss in free() than SLAB has.
> 
> /* common implementation *
> int virt_to_nid(const void *addr)
> {
> 	struct page *page = virt_to_page(addr); 
> 	return page_to_nid(page);
> }
> 
> On some platforms (x86_64 for example), could we have a better 
> implementation, not accessing struct page, but using phys_to_nid() ?

This is going to pollute the caches since we then use multiple ways to 
determine the node of a page. Its better to stay with the same approach 
for all pages. The page struct is used for many other purposes as well. 
Its likely to be in the cpu cache.


