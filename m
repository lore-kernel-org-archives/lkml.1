Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYCDFhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYCDFhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYCDFh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:37:26 -0500
Received: from c60.cesmail.net ([216.154.195.49]:22868 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYCDFhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:37:25 -0500
Message-ID: <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net>
Date: Tue, 04 Mar 2008 00:37:23 -0500
From: Pavel Roskin <proski@gnu.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
References: <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	<20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	<alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	<1204304352.6767.21.camel@localhost>
	<alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	<1204305609.21719.16.camel@dv>
	<alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	<1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu>
	<1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu>
In-Reply-To: <20080303105752.GA23594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ingo Molnar <mingo@elte.hu>:

>
> * Pavel Roskin <proski@gnu.org> wrote:
>
>> > btw., what are the technical reasons why ndiswrapper cannot be done
>> > in userspace, much like the (wildly successful) FUSE concept?
>>
>> ndiswrapper contains essentially two drivers in one - PCI and USB.
>> The PCI driver uses DMA, which should be a strong argument for keeping
>> it in the kernel.
>
> how exactly does it use DMA - how does it allocate the memory it later
> on DMAs into, and how does it typically program that DMA target - is
> there any control over that in the NDIS protocol - or will NDIS drivers
> just write random addresses to the mmio space and then the hardware does
> DMA to/from those addresses? [without the NDIS framework having any
> knowledge about the encoding of those bits?]

Sorry for delay.  I'm really not sure.  The maintainer of ndiswrapper  
is currently offline, and I'm just trying to take care of the basic  
stuff.

All I can say is NdisMAllocateSharedMemory maps to  
dma_alloc_coherent(), and there are some references to scatter-gather  
lists.  There is a call to dma_map_single(), which is ultimately  
called by the Tx function net_dev->hard_start_xmit.

I understand there is some control from NDIS.  At least it can request  
memory available for DMA.

> on modern hardware it might even be possible to jail an ndiswrapper
> driver to its own pages via the IOMMU.

It's possible that ndiswrapper would support Vista drivers only on  
x86_64, which should always have IOMMU, if I understand correctly.   
But it would be nice to have proper support for older XP drivers on x86.

-- 
Regards,
Pavel Roskin
