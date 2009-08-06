Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZHFBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZHFBVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZHFBVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:21:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:59094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZHFBU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:20:59 -0400
Message-ID: <4A7A2FB1.9050407@kernel.org>
Date: Wed, 05 Aug 2009 18:19:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node
References: <4A785C17.3030104@kernel.org>	 <1249406368.27006.10789.camel@localhost.localdomain>	 <4A794D8A.1060508@kernel.org> <1249518985.27006.10805.camel@localhost.localdomain>
In-Reply-To: <1249518985.27006.10805.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Wed, 2009-08-05 at 02:14 -0700, Yinghai Lu wrote:
>> without this patch
>>
>> [  299.175436] igbvf 0000:41:10.0: enabling device (0000 -> 0002)
>> [  299.180009] igbvf 0000:41:10.0: using 64bit DMA mask
>> [  299.183077] igbvf 0000:41:10.0: using 64bit consistent DMA mask
>> [  299.199870] igbvf 0000:41:10.0: enabling bus mastering
>> [  299.205534] igbvf 0000:41:10.0: setting latency timer to 64
>> [  299.219654] reserve_memtype added 0xcfc00000-0xcfc04000, track uncached-minus, req uncached-minus, ret uncached-minus
>> [  299.239615] reserve_memtype added 0xcfc20000-0xcfc21000, track uncached-minus, req uncached-minus, ret uncached-minus
>> [  299.260181]   alloc irq_desc for 217 on node 2
>> [  299.263501]   alloc kstat_irqs on node 2
>> [  299.276276] alloc irq_2_iommu on node 0
>> [  299.281847] igbvf 0000:41:10.0: irq 217 for MSI/MSI-X
>> [  299.285511]   alloc irq_desc for 218 on node 2
>> [  299.297813]   alloc kstat_irqs on node 2
>> [  299.302543] alloc irq_2_iommu on node 0
>> [  299.315358] igbvf 0000:41:10.0: irq 218 for MSI/MSI-X
>> [  299.321102]   alloc irq_desc for 219 on node 2
>> [  299.325932]   alloc kstat_irqs on node 2
>> [  299.338616] alloc irq_2_iommu on node 0
>> [  299.340789] igbvf 0000:41:10.0: irq 219 for MSI/MSI-X
>> [  299.356532] igbvf 0000:41:10.0: PF still in reset state, assigning new address
>> [  299.365128] igbvf 0000:41:10.0: PF still resetting
>> [  299.377625] igbvf 0000:41:10.0: Intel(R) 82576 Virtual Function
>> [  299.385619] igbvf 0000:41:10.0: Address: c6:e3:de:62:de:eb
>> [  299.395957] igbvf 0000:41:10.0: MAC: 1
>>
>> thought we could put irq_2_iommu to same node too.
> 
> Yinghai, even with this patch, we will still be allocating from node-0.
> No?

with this patch will get 
alloc irq_2_iommu on node 2

YH
