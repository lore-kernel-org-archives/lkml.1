Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXCWRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXCWRTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXCWRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:19:50 -0400
Received: from graphe.net ([209.204.138.32]:34081 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXCWRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:19:43 -0400
Date: Fri, 23 Mar 2007 10:19:32 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
In-Reply-To: <20070323172212.6648412d.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703231017250.1434@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
 <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
 <20070321160929.GB25583@one.firstfloor.org> <20070323121512.c287ddef.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703230749130.29603@graphe.net> <20070323172212.6648412d.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Eric Dumazet wrote:

> Sorry ? page structs are not in cpu cache at all.

They are if they are in any way handled by the VM.
 
> You carefully commented your alloc() function saying it is touching two cache lines.
> But you omited to say that free() function needs 3 cache lines if CONFIG_NUMA

Yes it needs the third cacheline to check the node of the page in the NUMA 
case.

> For SLAB use, page struct is needed because we use lru.{next|prev} to 
> store slab/cachep pointers, but for a pure page allocator, unless I 
> misread your patch, we dont need it, if virt_to_nid() can do its job 
> without it.

The page allocator is only handling page_structs.
 
