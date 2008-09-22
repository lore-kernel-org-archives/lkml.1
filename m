Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYIVTCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYIVTCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYIVTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:02:15 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:28840 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYIVTCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:02:15 -0400
X-BigFish: VPS-28(z1039oz1dbaM1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7M26S-03-5D1-01
Date: Mon, 22 Sep 2008 21:01:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080922190144.GK24392@amd.com>
References: <20080922111730.GF5987@elte.hu> <20080923002516R.fujita.tomonori@lab.ntt.co.jp> <20080922162314.GC24392@amd.com> <20080923015059M.fujita.tomonori@lab.ntt.co.jp> <20080922183414.GI24392@amd.com> <20080922184822.GA24046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922184822.GA24046@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 19:01:44.0887 (UTC) FILETIME=[A806B470:01C91CE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 08:48:22PM +0200, Ingo Molnar wrote:
> applied Fujita's patch below to tip/x86/iommu that reverts those 
> options, thanks guys!
> 
> i'm wondering how we should proceed. For debug, iommu=off is certainly 
> good enough - all kernels are supposed to work out of box on all hw, and 
> every other result is a regression that must be fixed.
> 
> For performance tuning, it probably makes sense for developers to tune 
> IOMMU details (so that the bootup defaults can be improved - this is not 
> really something that should be done on a workload basis), but for that 
> IMO a /debug interface is a lot more useful than rather intrusive (and 
> inflexible) boot options.
>
> What do you think about a debugfs based tuning of various IOMMU details? 
> Maybe even the active driver could be changed - say from AMD-IOMMU to 
> GART, or to off.

Yes, for the IO/TLB flushing policy a /debug interface is usefull and
certainly for a number of other parameters we have today at the
commandline.
But I am not sure if we can change the IOMMU implementation on-the-fly
at runtime. We have to wait until all drivers have released their dma
memory before we can switch it off. For coherent allocations this may
take a long time.
So for selecting the type of IOMMU active in the system the command line
parameters are needed, I think. I prefer the iommu=$type parameter for
selecting the default (better: to select a default different from what
the kernel had chosen itself). We can have the IOMMU specific options to
switch it off in addition if we like to.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

