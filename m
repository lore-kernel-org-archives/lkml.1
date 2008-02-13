Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYBMSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYBMSgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYBMSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:36:40 -0500
Received: from mga06.intel.com ([134.134.136.21]:43483 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021AbYBMSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:36:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,347,1199692800"; 
   d="scan'208";a="339415423"
Date: Wed, 13 Feb 2008 10:31:18 -0800
From: mark gross <mgross@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: muli@il.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
Message-ID: <20080213183118.GB1162@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080212085256.GF5750@rhun.haifa.ibm.com> <20080212.010006.255202479.davem@davemloft.net> <20080212155448.GC27490@linux.intel.com> <20080212.154630.241691261.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.154630.241691261.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 07:54:48AM -0800, David Miller wrote:
> > Something could be done:
> > we could enable drivers to have DMA-pools they manage that get mapped
> > and are re-used.
> > 
> > I would rather the DMA-pools be tied to PID's that way any bad behavior
> > would be limited to the address space of the process using the device.
> > I haven't thought about how hard this would be to do but it would be
> > nice.  I think this could be tricky.
> 
> Yes, this is a good idea especially for networking.
> 
> For transmit on 10GB links the IOMMU setup is near the top
> of the profiles.

true.
 
> What a driver could do is determine the maximum number of
> IOMMU pages it could need to map one maximally sized packet.
> So then it allocates enough space for all such entries in
> it's TX ring.
> 
> This eliminates the range allocation from the transmit path.
> All that's left is "remap DMA range X to scatterlist Y"
> 
> And yes it would be nice to have dma_map_skb() type interfaces
> so that we don't walk into the IOMMU code N times per packet.


/me starts looking more closely at how this could be done...

--mgross
 
