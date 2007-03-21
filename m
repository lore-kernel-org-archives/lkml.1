Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXCUHPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXCUHPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbXCUHPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:15:06 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:36251 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXCUHPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:15:04 -0400
Message-ID: <4600DB6E.40107@cosmosbay.com>
Date: Wed, 21 Mar 2007 08:14:54 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Christoph Lameter <christoph@lameter.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net> <4600D04B.6030305@cosmosbay.com> <Pine.LNX.4.64.0703210001220.25462@graphe.net>
In-Reply-To: <Pine.LNX.4.64.0703210001220.25462@graphe.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Mar 2007 08:14:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Wed, 21 Mar 2007, Eric Dumazet wrote:
> 
>> The fast path is to put the pointer, into the cpu array cache. This object
>> might be given back some cycles later, because of a kmem_cache_alloc() : No
>> need to access the two cache lines (struct page, struct slab)
> 
> If you do that then the slab will no longer return objects from the 
> desired nodes. The assumption is that cpu array objects are from the local 
> node.

Me confused.

How the following could be wrong ?

static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
{
int mynode = numa_node_id();
int objnode = virt_to_nid(objp); // or whatever

if (mynode == objnode)
	return 0;
...
}

If numa_node_id() is equal to the node of the page containing the first byte 
of the object, then object is on the local node. Or what ?

Thank you
