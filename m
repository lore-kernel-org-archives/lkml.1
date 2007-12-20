Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXLTWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXLTWMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXLTWMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:12:47 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:36702 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbXLTWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:12:46 -0500
Message-ID: <476AE8C9.9080601@opengridcomputing.com>
Date: Thu, 20 Dec 2007 16:12:25 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: benh@au1.ibm.com
CC: benh@ozlabs.au.ibm.com, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
Subject: Re: iommu dma mapping alignment requirements
References: <476AA2E2.5010007@opengridcomputing.com>	 <1198181862.6779.3.camel@pasglop>  <476AD84E.4000507@opengridcomputing.com> <1198186017.6779.28.camel@pasglop>
In-Reply-To: <1198186017.6779.28.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2007-12-20 at 15:02 -0600, Steve Wise wrote:
>> Benjamin Herrenschmidt wrote:
>>> Adding A few more people to the discussion. You may well be right and we
>>> would have to provide the same alignment, though that sucks a bit as one
>>> of the reason we switched to 4K for the IOMMU is that the iommu space
>>> available on pSeries is very small and we were running out of it with
>>> 64K pages and lots of networking activity.
>>>
>> But smarter NIC drivers can resolve this too, I think, but perhaps 
>> carving up full pages of mapped buffers instead of just assuming mapping 
>> is free...
> 
> True, but the problem still happenens today, if we switch back to 64K
> iommu page size (which should be possible, I need to fix that), we
> -will- run out of iommu space on typical workloads and that is not
> acceptable.
> 
> So we need to find a compromise.
> 
> What I might do is something around the lines of: If size >= PAGE_SIZE,
> and vaddr (page_address + offset) is PAGE_SIZE aligned, then I enforce
> alignment of the resulting mapping.
> 
> That should fix your case. Anything requesting smaller than PAGE_SIZE
> mappings would lose that alignment but I -think- it should be safe, and
> you still always get 4K alignment anyway (+/- your offset) so at least
> small alignment restrictions are still enforced (such as cache line
> alignment etc...).
> 
> I'll send you a test patch later today.
> 
> Ben.
> 

Sounds good.  Thanks!

Note, that these smaller sub-host-page-sized mappings might pollute the 
address space causing full aligned host-page-size maps to become 
scarce...  Maybe there's a clever way to keep those in their own segment 
of the address space?


