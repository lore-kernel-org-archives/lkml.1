Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXCUHDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXCUHDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbXCUHDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:03:35 -0400
Received: from graphe.net ([209.204.138.32]:54860 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbXCUHDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:03:34 -0400
Date: Wed, 21 Mar 2007 00:03:05 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <4600D04B.6030305@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703210001220.25462@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net>
 <4600D04B.6030305@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Eric Dumazet wrote:

> The fast path is to put the pointer, into the cpu array cache. This object
> might be given back some cycles later, because of a kmem_cache_alloc() : No
> need to access the two cache lines (struct page, struct slab)

If you do that then the slab will no longer return objects from the 
desired nodes. The assumption is that cpu array objects are from the local 
node.
