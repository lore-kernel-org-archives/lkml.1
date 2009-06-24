Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZFXQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZFXQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZFXQwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:52:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428AbZFXQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:52:25 -0400
Date: Wed, 24 Jun 2009 09:52:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090624094622.d0b0fd82.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906240948430.3240@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Andrew Morton wrote:
> 
> Well yes.  Using GFP_NOFAIL on a higher-order allocation is bad.

Yes, but your definition of "higher order" is incorrect.

At the very least, we should change the "order > 0" to "order > 1".

As I already mentioned, SLAB uses order-1 allocations in order to not have 
excessive fragmentation for small kmalloc/slab's that would otherwise 
waste tons of memory.

Think network packets at 1500 bytes each. You can allocate two per page, 
or five per 2-pages. That's a 25% memory usage difference! 

And getting an order-1 allocation is simply not that much harder than an 
order-0 one. It starts getting hard once you get to order-3 or more.

			Linus
