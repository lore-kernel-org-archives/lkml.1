Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXERErq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXERErq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXERErj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:47:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755219AbXEREri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:47:38 -0400
Date: Thu, 17 May 2007 21:47:40 -0700 (PDT)
Message-Id: <20070517.214740.51856086.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070518040854.GA15654@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 18 May 2007 06:08:54 +0200

> I'd like to be the first to propose an increase to the size of struct page
> just for the sake of increasing it!
> 
> If we add 8 bytes to struct page on 64-bit machines, it becomes 64 bytes,
> which is quite a nice number for cache purposes.
> 
> However we don't have to let those 8 bytes go to waste: we can use them
> to store the virtual address of the page, which kind of makes sense for
> 64-bit, because they can likely to use complicated memory models.
> 
> I'd say all up this is going to decrease overall cache footprint in 
> fastpaths, both by reducing text and data footprint of page_address and
> related operations, and by reducing cacheline footprint of most batched
> operations on struct pages.
> 
> Flame away :)

I've toyed with this several times on sparc64, and in my experience
the extra memory reference on page->virtual costs on average about the
same as the non-power-of-2 pointer arithmetic.

The decision is absolutely arbitrary performance wise, but if you
consider the memory wastage on enormous systems going without
page->virtual I think is clearly better.
