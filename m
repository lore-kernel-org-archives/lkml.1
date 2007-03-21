Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXCUOIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXCUOIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXCUOIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:08:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXCUOIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:08:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Date: Wed, 21 Mar 2007 15:11:09 +0100
User-Agent: KMail/1.9.5
Cc: Jarek Poplawski <jarkao2@o2.pl>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast\\@domdv\\.de" <ast@domdv.de>,
       "linux-kernel\\@vger\\.kernel\\.org" <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI> <20070321133151.GC1939@ff.dom.local> <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211511.10342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 14:36, Pekka J Enberg wrote:
> On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> > With  __kmem_cache_free you would set #1 I hope, but if
> > nobody would use this - debugging time wouldn't change.
> 
> I think you got it backwards. I suggested making the _current_ 
> kmem_cache_free() deal with NULL (so everyone will get it) and add a new 
> optimized __kmem_cache_free() for those call-sites that really need it.
> 
> On Wed, 21 Mar 2007, Jarek Poplawski wrote:
> > This could be acceptable, if there were no problems
> > with fixing the errors. But there are problems - bugs
> > like this aren't fixed on time - maybe because people
> > waste too much time per bug?
> 
> You're barking up the wrong tree here, Jarek. I strongly feel that we 
> should be more defensive in the slab for the exact reasons you outlined. 
> There's bunch of bug reports people seem to dismiss as slab errors where 
> in fact it's caused by a buggy caller.
> 
> That said, Eric and Andrew make a good point about kmem_cache_free() being 
> in super-hot paths which clearly must be addressed. The only reason 
> holding me back is the fact that I don't know what those super-hot 
> call-sites are (with the exception of network skb allocation) so I am 
> really in no position to make that patch.

IMHO one way to find them is to actually slow down kmem_cache_free() and see
where the performance is hurt.

Greetings,
Rafael
