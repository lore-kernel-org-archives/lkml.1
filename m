Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYGYHkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYGYHkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYGYHjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:39:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYGYHjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:39:53 -0400
Subject: Re: page swap allocation error/failure in 2.6.25
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Samad <alex@samad.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080725072015.GA17688@samad.com.au>
References: <20080725072015.GA17688@samad.com.au>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 09:40:01 +0200
Message-Id: <1216971601.7257.345.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 17:20 +1000, Alex Samad wrote:
> Hi
> 
> I reported this earlier (http://lkml.org/lkml/2008/7/13/41) which I had
> attributed to miss match mtu and route information.
> 
> But I have started to see the errors again.
> 
> 
> Jul 25 13:07:07 hufpuf kernel: [269282.912693] swapper: page allocation
> failure. order:2, mode:0x20
> Jul 25 13:07:07 hufpuf kernel: [269282.912700] Pid: 0, comm: swapper
> Tainted: GF        2.6.25-2-amd64 #1
> Jul 25 13:07:07 hufpuf kernel: [269282.912703] 
> Jul 25 13:07:07 hufpuf kernel: [269282.912703] Call Trace:
> Jul 25 13:07:07 hufpuf kernel: [269282.912705]  <IRQ>
> [<ffffffff8027709a>] __alloc_pages+0x2f8/0x312
> Jul 25 13:07:07 hufpuf kernel: [269282.912750]  [<ffffffff80294c63>]
> kmem_getpages+0xc5/0x193
> Jul 25 13:07:07 hufpuf kernel: [269282.912757]  [<ffffffff8029529d>]
> fallback_alloc+0x147/0x1c0
> Jul 25 13:07:07 hufpuf kernel: [269282.912769]  [<ffffffff80294ed8>]
> kmem_cache_alloc_node+0x105/0x138
> Jul 25 13:07:07 hufpuf kernel: [269282.912777]  [<ffffffff803ac4ae>]
> __alloc_skb+0x64/0x12d


Its harmless if it happens sporadically. 

Atomic order 2 allocations are just bound to go wrong under pressure.

