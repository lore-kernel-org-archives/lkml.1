Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXDBFYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXDBFYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXDBFYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:24:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33039
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbXDBFYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:24:39 -0400
Date: Sun, 01 Apr 2007 22:24:38 -0700 (PDT)
Message-Id: <20070401.222438.74736622.davem@davemloft.net>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
References: <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
	<20070401.220841.89389711.davem@davemloft.net>
	<21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Mon, 2 Apr 2007 15:15:48 +1000

> > Perhaps we'll have to create something ugly like vmalloc_nobounce().
> >
> > Remind me again why you're ending up with swiotlb'd pages?
> > vmalloc_32() uses GFP_KERNEL which should use entirely lowmem and thus
> > RAM below 4GB and not anything which should need bounce buffering.
> 
> On a 64-bit machine GFP_KERNEL can give me any memory... it all works
> fine on 32-bit highmem kernel as I don't get highmem... I really need
> __GFP_DMA32 memory but we don't have a generic allocator that gives
> this out that I can see..

That clears things up thanks.

Perhaps the other uses of vmalloc_32() want GFP_32 semantics too,
although I didn't check.
