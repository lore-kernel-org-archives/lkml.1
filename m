Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXDBGkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXDBGkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933928AbXDBGkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:40:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933AbXDBGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:40:50 -0400
Date: Mon, 2 Apr 2007 08:40:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
Message-ID: <20070402064046.GA24269@one.firstfloor.org>
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com> <20070401.201134.82699692.davem@davemloft.net> <21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com> <20070401.220841.89389711.davem@davemloft.net> <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com> <p731wj31ear.fsf@bingen.suse.de> <21d7e9970704012238x2c5e6c62hc30933d9575910cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970704012238x2c5e6c62hc30933d9575910cf@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 03:38:48PM +1000, Dave Airlie wrote:
> Doesn't __get_free_pages give me physically linear memory, which while
> nice it isn't essential for what I need, so if I can't get my full
> allocation I could in theory just start to fallback down the orders
> and calling it multiple times to actually get the amount of memory I

You get linear memory. Just get individual pages.

If you want to merge them you can use vmap(),
but in the kernel you should probably just fix your in kernel 
code to not require that and work with sg lists.

If you get the pages piece by piece you can also more easily
remap them linearly into user space.

> need, this just seems overly cumbersome when what I really want is
> vmalloc_32 to just work correctly on 64-bit systems... (why doesn't
> vmalloc_32 pass __GFP_DMA32 to the allocator????)

It probably should, but see second part of sentence above.

And please never put closed lists in cc of l-k posts. Evil cc dropped.

-Andi

