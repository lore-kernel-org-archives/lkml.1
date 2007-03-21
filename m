Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbXCUNgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbXCUNgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXCUNgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:36:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48851 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbXCUNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:36:36 -0400
Date: Wed, 21 Mar 2007 15:36:34 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast\\@domdv\\.de" <ast@domdv.de>,
       "linux-kernel\\@vger\\.kernel\\.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <20070321133151.GC1939@ff.dom.local>
Message-ID: <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
 <20070321101143.GB1939@ff.dom.local> <84144f020703210513i37d1576erb7814483bcaad505@mail.gmail.com>
 <20070321133151.GC1939@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> With  __kmem_cache_free you would set #1 I hope, but if
> nobody would use this - debugging time wouldn't change.

I think you got it backwards. I suggested making the _current_ 
kmem_cache_free() deal with NULL (so everyone will get it) and add a new 
optimized __kmem_cache_free() for those call-sites that really need it.

On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> This could be acceptable, if there were no problems
> with fixing the errors. But there are problems - bugs
> like this aren't fixed on time - maybe because people
> waste too much time per bug?

You're barking up the wrong tree here, Jarek. I strongly feel that we 
should be more defensive in the slab for the exact reasons you outlined. 
There's bunch of bug reports people seem to dismiss as slab errors where 
in fact it's caused by a buggy caller.

That said, Eric and Andrew make a good point about kmem_cache_free() being 
in super-hot paths which clearly must be addressed. The only reason 
holding me back is the fact that I don't know what those super-hot 
call-sites are (with the exception of network skb allocation) so I am 
really in no position to make that patch.

			Pekka
