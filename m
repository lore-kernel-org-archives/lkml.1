Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbXDBFiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbXDBFiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXDBFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:38:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXDBFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rFU5wVAQqRd1EFew6VHW9JvUoDLX4A58vVKKqoAxSrS4nLhyoEkhG9OAf36AD+Tyba3+Fnu7Zqf2EglI7AmGElFGFNdO0xGjz0iKSSKx6pGMp4mfZ5J/MQqz/yt3I2ytXUTCh5uiCw1uh8vfTJ9nvf8dkQBh8fzvShFy1qsKCnk=
Message-ID: <21d7e9970704012238x2c5e6c62hc30933d9575910cf@mail.gmail.com>
Date: Mon, 2 Apr 2007 15:38:48 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <p731wj31ear.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	 <20070401.201134.82699692.davem@davemloft.net>
	 <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
	 <20070401.220841.89389711.davem@davemloft.net>
	 <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
	 <p731wj31ear.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > On a 64-bit machine GFP_KERNEL can give me any memory... it all works
> > fine on 32-bit highmem kernel as I don't get highmem... I really need
> > __GFP_DMA32 memory but we don't have a generic allocator that gives
> > this out that I can see..
>
> __get_free_pages(..., __GFP_DMA32) on 64bit or __GFP_KERNEL or i386
> (only gives you ~900MB)

Doesn't __get_free_pages give me physically linear memory, which while
nice it isn't essential for what I need, so if I can't get my full
allocation I could in theory just start to fallback down the orders
and calling it multiple times to actually get the amount of memory I
need, this just seems overly cumbersome when what I really want is
vmalloc_32 to just work correctly on 64-bit systems... (why doesn't
vmalloc_32 pass __GFP_DMA32 to the allocator????)

> Not sure what you mean? __alloc_pages never bounces by itself.
> The nearest you can get is __GFP_DMA/__GFP_DMA32, but these have
> their own 16MB/4GB zones and don't use the swiotlb pools. And of course it
> only gives you plain memory, but doesn't remap or copy anything.

Yes I want __GFP_DMA32 but I'd like it with vmalloc not with
__get_free_pages and I've no great need for physically linear page
allocations and as I'm after quite a large order I can see this
failing ... granted with a 4GB system maybe not that quickly..

Dave.
