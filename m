Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXJEL2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXJEL2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXJEL2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:28:36 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44402 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXJEL2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:28:35 -0400
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, akpm@linux-foundation.org, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no
In-reply-to: <1191581854.22357.85.camel@twins> (message from Peter Zijlstra on
	Fri, 05 Oct 2007 12:57:34 +0200)
Subject: Re: [PATCH] remove throttle_vm_writeout()
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <20071004145640.18ced770.akpm@linux-foundation.org>
	 <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	 <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
	 <E1Ida56-0002Zz-00@dorka.pomaz.szeredi.hu>
	 <20071004164801.d8478727.akpm@linux-foundation.org>
	 <E1Idanu-0002c1-00@dorka.pomaz.szeredi.hu>
	 <20071004174851.b34a3220.akpm@linux-foundation.org>
	 <1191572520.22357.42.camel@twins>
	 <E1IdjOa-0002qg-00@dorka.pomaz.szeredi.hu>
	 <1191577623.22357.69.camel@twins>
	 <E1IdkOf-0002tK-00@dorka.pomaz.szeredi.hu> <1191581854.22357.85.camel@twins>
Message-Id: <E1IdlKu-0002wW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 13:27:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Limiting FUSE to say 50% (suggestion from your other email) sounds like
> a horrible hack to me. - Need more time to think on this.

I don't really understand all that page balancing stuff, but I think
this will probably never or very rarely happen, because the allocator
will prefer the bigger zones, and the dirty page limiting will not let
the bigger zones get too full of dirty pages.

And even it can happen, it's not necessarily a fuse-only thing.

It makes tons of sense to make sure, that we don't fully dirty _any_
specialized zone.  One special zone group are the low-memory pages.
And currently balance_dirty_pages() makes sure we don't fill that up
with dirty file backed pages.  So something like that should make
sense for other special zones like DMA as well.

I'm not saying it's trivial, or even possible to implement, just
thinking...

Miklos
