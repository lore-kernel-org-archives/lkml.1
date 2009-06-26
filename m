Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZFZGbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZFZGbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbZFZGbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:31:38 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43938 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbZFZGbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:31:37 -0400
Message-ID: <4A446B49.8040001@shipmail.org>
Date: Fri, 26 Jun 2009 08:31:37 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jerome Glisse <glisse@freedesktop.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: TTM page pool allocator
References: <1245931298.13359.8.camel@localhost.localdomain> <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
In-Reply-To: <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie skrev:
> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
>   
>> Hi,
>>
>> Thomas i attach a reworked page pool allocator based on Dave works,
>> this one should be ok with ttm cache status tracking. It definitely
>> helps on AGP system, now the bottleneck is in mesa vertex's dma
>> allocation.
>>
>>     
>
> My original version kept a list of wb pages as well, this proved to be
> quite a useful
> optimisation on my test systems when I implemented it, without it I
> was spending ~20%
> of my CPU in getting free pages, granted I always used WB pages on
> PCIE/IGP systems.
>
> Another optimisation I made at the time was around the populate call,
> (not sure if this
> is what still happens):
>
> Allocate a 64K local BO for DMA object.
> Write into the first 5 pages from userspace - get WB pages.
> Bind to GART, swap those 5 pages to WC + flush.
> Then populate the rest with WC pages from the list.
> Granted I think allocating WC in the first place from the pool might
> work just as well since most of the DMA buffers are write only.
>   

Yes, I think in the latter case the user-space driver should take care 
to specify WC from the beginning, when the BO is allocated.

BTW is there any DMA buffer verification taking place on WC buffers on 
Radeon?

> Dave.
>   

/Thomas

