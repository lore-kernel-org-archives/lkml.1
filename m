Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXJEKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXJEKcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXJEKcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:32:35 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50539 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXJEKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:32:34 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, wfg@mail.ustc.edu.cn, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1IdkOf-0002tK-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Fri, 05 Oct 2007 12:27:05 +0200)
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
	 <E1IdjOa-0002qg-00@dorka.pomaz.szeredi.hu> <1191577623.22357.69.camel@twins> <E1IdkOf-0002tK-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1IdkTY-0002tc-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 12:32:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that's an improvement in all respects.
> 
> However it still does not generally address the deadlock scenario: if
> there's a small DMA zone, and fuse manages to put all of those pages
> under writeout, then there's trouble.

And the only way to solve that AFAICS, is to make sure fuse never uses
more than e.g. 50% of _any_ zone for page cache.  And that may need
some tweaking in the allocator...

Miklos
