Return-Path: <linux-kernel-owner+w=401wt.eu-S935437AbYETWpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437AbYETWpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935509AbYETWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:43:15 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:33633 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935489AbYETWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:43:13 -0400
Message-ID: <4833542E.3040608@freescale.com>
Date: Tue, 20 May 2008 17:43:58 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, tpiepho@freescale.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <483344C0.3020703@freescale.com>	<20080520231516.76b924a2@core>	<4833524C.3040207@freescale.com> <20080520.153947.84346222.davem@davemloft.net>
In-Reply-To: <20080520.153947.84346222.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Scott Wood <scottwood@freescale.com>
> Date: Tue, 20 May 2008 17:35:56 -0500
> 
>> Alan Cox wrote:
>>>> It looks like we rely on -fno-strict-aliasing to prevent reordering 
>>>> ordinary memory accesses (such as to DMA descriptors) past the I/O 
>>> DMA descriptors in main memory are dependant on cache behaviour anyway
>>> and the dma_* operators should be the ones enforcing the needed behaviour.
>> What about memory obtained from dma_alloc_coherent()?  We still need a 
>> sync and a compiler barrier.  The current I/O accessors have the former, 
>> but not the latter.
> 
> The __volatile__ in the asm construct disallows movement of the
> inline asm relative to statements surrounding it.
> 
> The only reason barrier() in kernel.h needs a memory clobber is
> because of a bug in ancient versions of gcc.  In fact, I think
> that memory clobber might even be removable.

Current versions of GCC seem quite happy to move non-asm memory accesses 
around a volatile asm without a memory clobber; see the test Trent posted.

-Scott
