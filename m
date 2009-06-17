Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbZFQNSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbZFQNSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZFQNSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:18:43 -0400
Received: from mail.oxtel.com ([193.200.114.15]:4130 "EHLO oxtel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752459AbZFQNSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:18:42 -0400
Message-ID: <4A38ED31.9030705@oxtel.com>
Date: Wed, 17 Jun 2009 14:18:41 +0100
From: Chris Pringle <chris.pringle@oxtel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: "linuxppc-dev@ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com>
 <20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com>
 <4A37CC72.3060709@freescale.com> <4A37CF02.5080906@oxtel.com>
 <4A37D073.6020802@freescale.com> <4A38A21B.5060306@oxtel.com>
In-Reply-To: <4A38A21B.5060306@oxtel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: chris.pringle
X-Server: VPOP3 Enterprise V2.6.0b - Registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Pringle wrote:
>> You could enable CONFIG_NOT_COHERENT_CACHE.
>>
> I've just tried this (I had to edit Kconfig in power/platforms to make 
> the build system accept it), and interestingly it's making no 
> difference. I'm using streaming mappings, and are using the pci_map_sg 
> functions to ensure the memory is mapped/flushed correctly. I've also 
> explicitly put in a pci_dma_sync_sg_for_device, however that's also 
> not made any difference. Turning the cpu cache snoop off has the same 
> affect as it did without CONFIG_NOT_COHERENT_CACHE; it gets much 
> worse. Any other ideas?
>
> Will back off the low latency patches next, and give 2.6.30 a try - 
> see if that makes any difference.
>
Low latency patches made no difference. Tried it with 2.6.30 and it now 
works. There are a couple of commits contributing to the fix, including 
one introduced between 2.6.29-rc8 and 2.6.29 proper in 
powerpc/kernel/head_32.S (couple of commits with the name "Fix Respect 
_PAGE_COHERENT on classic ppc32 SW TLB load machines"). I've tried 
backporting this to 2.6.29-rc8 and it then worked. Backporting to 2.6.26 
made no difference however, so I suspect there are other things fixed 
which are also contributing.

I'm going to move to 2.6.29/2.6.30 which should resolve our issue.

Thanks to all who have contributed to this thread.

Chris

-- 

______________________________
Chris Pringle
Software Engineer

Miranda Technologies Ltd.
Hithercroft Road
Wallingford
Oxfordshire OX10 9DG
UK

Tel. +44 1491 820206
Fax. +44 1491 820001
www.miranda.com

____________________________

Miranda Technologies Limited
Registered in England and Wales CN 02017053
Registered Office: James House, Mere Park, Dedmere Road, Marlow, Bucks, SL7 1FJ
